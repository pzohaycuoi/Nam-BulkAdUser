function New-NamAdUser {
  param (
    [Parameter(Mandatory)]
    [string]$FirstName,

    [Parameter(Mandatory)]
    [string]$LastName,

    [Parameter(Mandatory)]
    [string]$Title,

    [AllowEmptyString()]
    [string]$Department,

    [Parameter(Mandatory)]
    [string]$Manager,

    [Parameter(Mandatory)]
    [string]$Location,

    [AllowEmptyString()]
    [string]$EmployeeNumber
  )
  
  # logging and result
  $logPath = "$($scriptDir)\log\"
  $logPath = Set-PathIsLinuxOrWin -FilePath $logPath
  $logFile = New-Item -Path $logPath.FilePath -Name "log-$(get-date -Format ddMMyyyy-hhmmss).log" -Force

  # try to import ad module
  $importAdModule = Import-NamModule -Module ActiveDirectory
  if ($true -eq $importAdModule.Result) {
    New-Log -Level "INFO" -Message $importAdModule.Log -LogFile $logFile.FullName
    
    if (-not ($false -eq $importLocation)) {
      $inputObject = Receive-InputData `
        -FirstName $FirstName `
        -LastName $LastName `
        -Title $Title `
        -Department $Department `
        -Manager $Manager `
        -Location $Location

      $refedObject = Reference-DataAndLocation -InputData $inputObject -ReferenceData $importLocationData
      if (-not ($refedObject.Result -eq "FAIL")) {
        $createAdUser = Create-AdUser -InputData $refedObject
        return $createAdUser
      }
      else {
        return $refedObject
      }
    }
    else {
      break
    }
  }
  else {
    New-Log -Level "ERROR" -Message $importAdModule.Log -LogFile $logFile.FullName
    break
  } 
}