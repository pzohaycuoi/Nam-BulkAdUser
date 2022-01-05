function New-NamAdUser {
  param (
    [Parameter(Mandatory)]
    [string]$FirstName,

    [Parameter(Mandatory)]
    [string]$LastName,

    [Parameter()]
    [string]$Title,

    [AllowEmptyString()]
    [string]$Department,

    [Parameter()]
    [string]$Manager,

    [Parameter(Mandatory)]
    [string]$Location,

    [AllowEmptyString()]
    [string]$EmployeeNumber
  )
  
  # current path
  $scriptDir = $PSScriptRoot

  # logging and result
  $logPath = "$($scriptDir)\..\log\"
  $logPath = Set-PathIsLinuxOrWin -FilePath $logPath
  $logFile = New-Item -Path $logPath.FilePath -Name "log-$(get-date -Format ddMMyyyy-hhmmss).log" -Force

  # try to import ad module
  $importAdModule = Import-NamModule -Module ActiveDirectory
  if ($true -eq $importAdModule.Result) {
    New-Log -Level "INFO" -Message $importAdModule.Log -LogFile $logFile.FullName

    # check if location.csv has all required header
    $locationCsvPath = "$($scriptDir)\..\data\location.csv"
    $csvReqHeaderPath = "$($scriptDir)\..\data\location-required-header-csv.txt"
    $getCsvReqHeader = Get-CsvRequiredHeader -FilePath $locationCsvPath -RequiredHeaderFile $csvReqHeaderPath

    if ($getCsvReqHeader.Result -eq $true) {
      New-Log -Level "INFO" -Message $getCsvReqHeader.Log -LogFile $logFile.FullName

      # get reference data base on location
      $locationCsvData = Import-Csv -Path $locationCsvPath
      $getRefLocationData = Search-DataAndLocation -Location $Location -ReferenceData $locationCsvData

      if ($getRefLocationData.Result -eq $true) {
        New-Log -Level "INFO" -Message $getRefLocationData.Log -LogFile $logFile.FullName

        # test if OU path exist
        $testOuPath = Test-OuPath -OuPath $getRefLocationData.LocationData.OuPath

        if ($testOuPath.Result -eq $true) {
          New-Log -Level "INFO" -Message $testOuPath.Log -LogFile $logFile
          # create user basic information
          $userSan = New-UserSamAcccountName -FirstName $FirstName -LastName $LastName
          $userName = New-UserDisplayName -FirstName $FirstName -LastName $LastName

          # check if user with this SamAccountName and Name exist yet
          $checkIfUserSanExist = Test-AdUserExist -SamAccountName $userSan
          $checkIfUserNameExist = Test-AdUserExist -Name $userName

          if ($checkIfUserSanExist.Exist -eq $true) {
            New-Log -Level "WARN" -Message $checkIfUserSanExist.Log -LogFile $logFile.FullName
            $count = 0

            do {
              $count++
              $newUserSan = "$($userSan)$($count)"
              $checkIfUserSanExist = Test-AdUserExist -SamAccountName $newUserSan
            } until ($false -eq $checkIfUserSanExist.Exist)
            $userSan = $newUserSan
            New-Log -Level "INFO" -Message $checkIfUserSanExist.Log -LogFile $logFile.FullName
          }
          else {
            New-Log -Level "INFO" -Message $checkIfUserSanExist.Log -LogFile $logFile.FullName
          }

          if ($checkIfUserNameExist.Exist -eq $true) {
            New-Log -Level "WARN" -Message $checkIfUserNameExist.Log -LogFile $logFile.FullName
            $count = 0

            do {
              $count++
              $newUserName = "$($userName)$($count)"
              $checkIfUserNameExist = Test-AdUserExist -SamAccountName $newUserName
            } until ($false -eq $checkIfUserNameExist.Exist)
            $userName = $newUserName
            New-Log -Level "INFO" -Message $checkIfUserNameExist.Log -LogFile $logFile.FullName
          }
          else {
            New-Log -Level "INFO" -Message $checkIfUserNameExist.Log -LogFile $logFile.FullName
          }

          # create random password
          $password = New-RandomPassword -Length 12

          # gathering basic information
          $basicInfo = [PSCustomObject]@{
            Name              = $userName
            FirstName         = $FirstName
            LastName          = $LastName
            SamAccountName    = $userSan
            UserPrincipalName = $userSan
            Path              = $getRefLocationData.LocationData.OuPath
            Password          = $password
          }

          # create ad user
          $createAdUser = New-AdUserProcess -Name $basicInfo.Name `
            -GivenName $basicInfo.FirstName `
            -SurName $basicInfo.LastName `
            -SamAccountName $basicInfo.SamAccountName `
            -UserPrincipalName $basicInfo.UserPrincipalName `
            -Path $basicInfo.Path `
            -AccountPassword $basicInfo.Password

          if ($createAdUser.Result -eq $true) {
            New-Log -Level "INFO" -Message $createAdUser.Log -LogFile $logFile.FullName
            New-Log -Level "INFO" -Message "FirstName: $($createAdUser.AdUserInfo.FirstName)" -LogFile $logFile.FullName
            New-Log -Level "INFO" -Message "LastName: $($createAdUser.AdUserInfo.LastName)" -LogFile $logFile.FullName
            New-Log -Level "INFO" -Message "Name: $($createAdUser.AdUserInfo.Name)" -LogFile $logFile.FullName
            New-Log -Level "INFO" -Message "SamAccountName: $($createAdUser.AdUserInfo.SamAccountName)" -LogFile $logFile.FullName
            New-Log -Level "INFO" -Message "UserPrincipalName: $($createAdUser.AdUserInfo.UserPrincipalName)" -LogFile $logFile.FullName
            New-Log -Level "INFO" -Message "OuPath: $($createAdUser.AdUserInfo.OuPath)" -LogFile $logFile.FullName
            
            # gathering user's organization information
            $orgInfo = [PSCustomObject]@{
              Identity       = $userSan
              DisplayName    = $userName
              Title          = $Title
              Department     = $Department
              Manager        = $Manager
              StreetAddress  = $getRefLocationData.LocationData.StreetAddress
              City           = $getRefLocationData.LocationData.City
              State          = $getRefLocationData.LocationData.State
              PostalCode     = $getRefLocationData.LocationData.PostalCode
              Country        = $getRefLocationData.LocationData.Country
              EmployeeNumber = $EmployeeNumber
            }

            # Check if manager exist
            $checkIfManagerExist = Test-AdUserExist -SamAccountName $orgInfo.Manager

            if ($checkIfManagerExist.Exist -eq $true) {
              New-Log -Level "INFO" -Message $checkIfManagerExist.Log -LogFile $logFile.FullName
              # set user organization information
              $setAdUserInfo = Set-AdUserInfo -Identity $orgInfo.Identity `
                -DisplayName $orgInfo.DisplayName `
                -Title $orgInfo.Title `
                -Department $orgInfo.Department `
                -Manager $orgInfo.Manager `
                -StreetAddress $orgInfo.StreetAddress `
                -City $orgInfo.City `
                -State $orgInfo.State `
                -PostalCode $orgInfo.PostalCode `
                -Country $orgInfo.Country `
                -EmployeeNumber $orgInfo.EmployeeNumber
            }
            else {
              New-Log -Level "INFO" -Message $checkIfManagerExist.Log -LogFile $logFile.FullName
              # set user organization information without manager
              $setAdUserInfo = Set-AdUserInfo -Identity $orgInfo.Identity `
                -DisplayName $orgInfo.DisplayName `
                -Title $orgInfo.Title `
                -Department $orgInfo.Department `
                -StreetAddress $orgInfo.StreetAddress `
                -City $orgInfo.City `
                -State $orgInfo.State `
                -PostalCode $orgInfo.PostalCode `
                -Country $orgInfo.Country `
                -EmployeeNumber $orgInfo.EmployeeNumber
            }
            if ($setAdUserInfo.Result -eq $true) {
              New-Log -Level "INFO" -Message $setAdUserInfo.Log -LogFile $logFile.FullName
              foreach ($log in $setAdUserInfo.UserInfo) {
                New-Log -Level "INFO" -Message $log -LogFile $logFile.FullName
              }
            }
            else {
              New-Log -Level "ERROR" -Message $setAdUserInfo.Log -LogFile $logFile.FullName
              continue
            }
          }
          else {
            New-Log -Level "ERROR" -Message $createAdUser.Log -LogFile $logFile.FullName
            continue
          }
        }
        else {
          New-Log -Level "ERROR" -Message $testOuPath.Log -LogFile $logFile
          continue
        }
      }
      else {
        New-Log -Level "ERROR" -Message $getRefLocationData.Log -LogFile $logFile.FullName
        break
      }
    }
    else {
      New-Log -Level "ERROR" -Message $getCsvReqHeader.Log -LogFile $logFile.FullName
      break
    }
  }
  else {
    New-Log -Level "ERROR" -Message $importAdModule.Log -LogFile $logFile.FullName
    break
  } 
}