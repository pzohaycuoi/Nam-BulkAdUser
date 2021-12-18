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
          New-Log -Level "INFO" -Message $checkIfUserNameExist.Log -LogFile $logFile.FullName
        }
        else {
          New-Log -Level "INFO" -Message $checkIfUserNameExist.Log -LogFile $logFile.FullName
        }

        # create random password
        $password = New-RandomPassword -Length 12

        # gathering basic information
        $basicInfo = [PSCustomObject]@{
          Name = $userName
          FirstName = $FirstName
          LastName = $LastName
          SamAccountName = $userSan
          UserPrincipalName = $userSan
          Path = $getRefLocationData.oupath
          Password = $password
        }

        # create ad user
        $createAdUser = New-AdUserProcess -Name $basicInfo.Name `
          -GivenName $basicInfo.FirstName `
          -SurName $basicInfo.LastName `
          -SamAccountName $basicInfo.SamAccountName `
          -UserPrincipalName $basicInfo.SamAccountName `
          -Path $basicInfo.Path `
          -AccountPassword $basicInfo.Password
      }

      if ($createAdUser.Result -eq $true) {
        New-Log -Level "INFO" -Message $createAdUser.Log -LogFile $logFile.FullName

      }
      else {
        New-Log -Level "ERROR" -Message $createAdUser.Log -LogFile $logFile.FullName
      }
      else {
        New-Log -Level "WARN" -Message $getRefLocationData.Log -LogFile $logFile.FullName
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