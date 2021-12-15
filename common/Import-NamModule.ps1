function Import-NamModule {
  param (
      [Parameter(Position=0)]
      [string]$Module
  ) 

  # Import module base on name or psm file path

  $result = [PSCustomObject]@{}
  $result | Add-Member -NotePropertyName "Module" -NotePropertyValue $Module

  if ( -not ($Module -eq "")) {
    try {
      $null = Import-Module -Name $Module -ErrorAction Stop # Name parameter accept bot path and module name
      $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "Success: Imported module $($Module)"
      $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $true
      return $result
    }
    catch {
      $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "Failed: $($_)"
      $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
      return $result
    }
  } else {
    $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "Failed: No module is provided"
    $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
    return $result
  }
}