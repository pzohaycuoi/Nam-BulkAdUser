function Get-CsvRequiredHeader {  
  param (
    [Parameter(Mandatory, Position=0)]
    [string]$FilePath,

    [Parameter(Mandatory, Position=1)]
    [string]$RequiredHeaderFile
  )

  # check if file csv contains all required headers base on a text file

  $result = [PSCustomObject]@{}
  $requiredHeaders = Get-Content -Path $RequiredHeaderFile
  $importCsv = Import-Csv -Path $FilePath
  $fileHeaders = $ImportCsv[0].PsObject.Properties.Name
  $result | Add-Member -NotePropertyName "FilePath" -NotePropertyValue $FilePath
  $result | Add-Member -NotePropertyName "RequiredHeaders" -NotePropertyValue $requiredHeaders
  $result | Add-Member -NotePropertyName "FileHeaders" -NotePropertyValue $fileHeaders
  $headerIncluded = @()
  $headerNotIncluded = @()
  
  # check if csv's header contains all the required headers
  foreach ($header in $requiredHeaders) {
    if ($fileHeaders -contains $header) {
      $headerIncluded += $header
    }
    else { 
      $headerNotIncluded += $header
    }
  }

  $result | Add-Member -NotePropertyName "HeaderIncluded" -NotePropertyValue $headerIncluded
  $result | Add-Member -NotePropertyName "HeaderNotIncluded" -NotePropertyValue $headerNotIncluded
  
  if (-not ($result.HeaderNotIncluded.count -gt 0)) {
    $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "Success: $($FilePath) has all required headers"
    $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $true
    return $result
  }
  else {
    $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "Failed: $($FilePath) doesn't have all required headers"
    $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
    return $result
  }
}