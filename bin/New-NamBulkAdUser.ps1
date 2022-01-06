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
  $checkIfFileExist = Test-FileExist -FilePath $FilePath -FileExtension ".csv"
  
  if ($checkIfFileExist.Result -eq $true) {
    New-Log -Level "INFO" -Message $checkIfFileExist.Log -LogFile $logFile

    # check if input csv has required headers
    $csvReqheader = "$($scriptDir)\..\data\input-required-header-csv.txt"
    $checkCsvReqHeader = Get-CsvRequiredHeader -FilePath $FilePath -RequiredHeaderFile $csvReqheader

    if ($checkCsvReqHeader.Result -eq $true) {
      New-Log -Level "INFO" -Message $checkCsvReqHeader.Log -LogFile $logFile

      # import and loop through csv file
      $csvData = Import-Csv -Path $FilePath

      foreach ($row in $csvData) {
        $data = [PSCustomObject]@{
          FirstName = $row.FirstName
          LastName = $row.LastName
          Title = $row.Title
          Department = $row.Department
          Manager = $row.Manager
          Location = $row.Location
          EmployeeNumber = $row.EmployeeNumber
        }
        $createUser = New-NamAdUser -FirstName $data.FirstName `
          -LastName $data.LastName `
          -Title $data.Title `
          -Department $data.Department `
          -Manager $data.Manager `
          -Location $data.Location `
          -EmployeeNumber $data.EmployeeNumber `
          -LogFile $logFile
        Write-Host $createUser
      }
    }
    else {
      New-Log -Level "ERROR" -Message $checkCsvReqHeader.Log -LogFile $logFile
      return $checkCsvReqHeader
    }
  }
  else {
     New-Log -Level "ERROR" -Message $checkIfFileExist.Log -LogFile $logFile
     return $checkIfFileExist
  }
}