function Test-OuPath {
  param (
      [Parameter(Mandatory)]
      [string]$OuPath
  )

  # check if ou path exsit

  $result = [PSCustomObject]@{}
  $result | Add-Member -NotePropertyName "OuPath" -NotePropertyValue $OuPath

  try {
    $checkOuPath = [adsi]::Exists("LDAP://$($OuPath)")

    if ($checkOuPath -eq $true) {
      $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "Success: Oupath $($OuPath) is exist"
      $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $true
      return $result
    }
    else {
      $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "Failed: OuPath $($OuPath) is not exist"
      $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
      return $result
    }
  }
  catch {
    $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "Failed: $($_)"
    $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
    return $result
  }
}