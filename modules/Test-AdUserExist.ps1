function Test-AdUserExist {

  param (
    [Parameter(Mandatory)]
    [string]
    $SamAccountName
  )

  # Check if the AD user exist
  
  $result = [PSCustomObject]@{}
  $result | Add-Member -NotePropertyName "UserSamAccountName" -NotePropertyValue $SamAccountName

  try {
    $checkAduserExist = Get-ADUser -Identity $SamAccountName -ErrorAction Stop
    
    if (-not ($null -eq $checkAduserExist)) {
      $result | Add-Member -NotePropertyName "Exist" -NotePropertyValue $true
      $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "User $($SamAccountName) is exist"
      $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $true
      return $result
    }
    else {
      $result | Add-Member -NotePropertyName "Exist" -NotePropertyValue $false
      $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "User $($SamAccountName) is not exist"
      $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $true
      return $result
    }
  }
  catch {
    $result | Add-Member -NotePropertyName "Exist" -NotePropertyValue $null
    $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "Failed: $($_)"
    $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
    return $result
  }
}