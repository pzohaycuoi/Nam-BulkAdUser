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
    if ($true -eq $getCsvReqHeader.Result) {
      New-Log -Level "INFO" -Message $getCsvReqHeader.Log -LogFile $logFile
      # get reference data base on location
      $locationCsvData = Import-Csv -Path $locationCsvPath
      $getRefLocationData = Search-DataAndLocation -Location $Location -ReferenceData $locationCsvData
      if ($true -eq $getRefLocationData) {
        New-Log -Level "INFO" -Message $getRefLocationData.Log -LogFile $logFile
        $getRefLocationData.LocationData
      }
      else {
        New-Log -Level "WARN" -Message $getRefLocationData.Log -LogFile $logFile
      }
    }
    else {
      New-Log -Level "ERROR" -Message $getCsvReqHeader.Log -LogFile $logFile
      break
    }
  }
  else {
    New-Log -Level "ERROR" -Message $importAdModule.Log -LogFile $logFile.FullName
    break
  } 
}