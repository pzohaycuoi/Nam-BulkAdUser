function New-NamBulkAdUser {
  [CmdletBinding()]
  param (
    # Path to the csv file
    [Parameter(Mandatory)]
    [string]$FilePath
  )

  # current path
  $scriptDir = $PSScriptRoot

  # logging
  $logPath = "$($scriptDir)\..\log\"
  $logPath = Set-PathIsLinuxOrWin -FilePath $logPath
  $logFile = New-Item -Path $logPath.FilePath -Name "log-$(get-date -Format ddMMyyyy-hhmmss).log" -Force  
  
  # result
  $resultPath = "$($scriptDir)\..\result"
  $resultPath = Set-PathIsLinuxOrWin -FilePath $resultPath
  $resultFile = New-Item -Path $resultPath.FilePath -Name "log-$(get-date -Format ddMMyyyy-hhmmss).log" -Force  

  # Check if csv path exist
  $checkIfFileExist = Test-F
}