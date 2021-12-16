function New-AdUserProcess {
  param (
    [Parameter(Position = 0)]
    [string]$Name,

    [Parameter(Position = 1)]
    [string]$GivenName,

    [Parameter(Position = 2)]
    [string]$SurName,

    [Parameter(Position = 3)]
    [string]$SamAccountName,

    [Parameter(Position = 4)]
    [string]$UserPrincipalName,

    [Parameter(Position = 5)]
    [string]$Path,

    [Parameter(Position = 6)]
    [string]$AccountPassword
  )

  # Create ad user
  $passwordPlainText = $AccountPassword
  $password = $AccountPassword | ConvertTo-SecureString
  $adUserInfo = [PSCustomObject]@{
    FirstName      = $FirstName
    LastName       = $LastName
    Name           = $Name
    SamAccountName = $SamAccountName
    OuPath         = $OuPath
    Password       = $passwordPlainText
  }
  $result = [PSCustomObject]@{}
  $result | Add-Member -NotePropertyName "AdUserInfo" -NotePropertyValue $adUserInfo

  try {
    New-ADUser -Name $Name `
      -DisplayName $Name `
      -GivenName $FirstName `
      -Surname $LastName `
      -SamAccountName $samAccountName `
      -UserPrincipalName $samAccountName `
      -Title $Title `
      -Department $Department `
      -Manager $Manager `
      -StreetAddress $StreetAddress `
      -City $City `
      -State $State `
      -PostalCode $Postalcode `
      -Country $Country `
      -Path $OuPath `
      -AccountPassword $password `
      -ChangePasswordAtLogon $true `
      -ErrorAction Stop
  
    $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "Success: User $($Name) has been created"
    $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $true
    return $result
  }
  catch {
    $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "Failed: $($_)"
    $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
    return $result
  }
}