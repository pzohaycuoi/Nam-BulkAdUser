function Test-AdUserExist {

  param (
    [Parameter(Position = 0, ParameterSetName = "SamAccountName")]
    [string]$SamAccountName,

    [Parameter(Position = 1, ParameterSetName = "Name")]
    [string]$Name
  )

  # Check if the AD user exist can be use with SamAccountName or DisplayName
  
  if ($PSCmdlet.ParameterSetName -eq "SamAccountName") {
    $result = [PSCustomObject]@{}
    $result | Add-Member -NotePropertyName "UserSamAccountName" -NotePropertyValue $SamAccountName
  
    try {
      $checkAduserExist = Get-ADUser -Identity $SamAccountName -ErrorAction Stop
      
      if (-not ($null -eq $checkAduserExist)) {
        $result | Add-Member -NotePropertyName "Exist" -NotePropertyValue $true
        $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "User with SamAccountName: $($SamAccountName) is exist"
        $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $truec
        return $result
      }
    }
    catch {
      $result | Add-Member -NotePropertyName "Exist" -NotePropertyValue $false
      $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "$($_)"
      $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
      return $result
    } 
  } 
  elseif ($PSCmdlet.ParameterSetName -eq "Name") {
    $result = [PSCustomObject]@{}
    $result | Add-Member -NotePropertyName "Name" -NotePropertyValue $Name
  
    try {
      $checkAduserExist = Get-ADUser -Filter "Name -eq ""$($Name)""" -ErrorAction Stop
      
      if (-not ($null -eq $checkAduserExist)) {
        $result | Add-Member -NotePropertyName "Exist" -NotePropertyValue $true
        $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "User with Name: $($Name) is exist"
        $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $true
        return $result
      }
      else {
        $result | Add-Member -NotePropertyName "Exist" -NotePropertyValue $false
        $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "User with Name: $($Name) is not exist"
        $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $true
        return $result
      }
    }
    catch {
      $result | Add-Member -NotePropertyName "Exist" -NotePropertyValue $null
      $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "$($_)"
      $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
      return $result
    } 
  }
}