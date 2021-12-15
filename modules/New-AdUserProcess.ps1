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
    [string]$Title,

    [Parameter(Position = 6)]
    [string]$Department,

    [Parameter(Position = 7)]
    [string]$Manager,

    [Parameter(Position = 8)]
    [string]$StreetAddress,

    [Parameter(Position = 9)]
    [string]$City,

    [Parameter(Position = 10)]
    [string]$State,

    [Parameter(Position = 11)]
    [string]$PostalCode,

    [Parameter(Position = 12)]
    [string]$Country,

    [Parameter(Position = 13)]
    [string]$Path,

    [Parameter(Position = 14)]
    [SecureString]$AccountPassword
  )

  # Create ad user

  $adUserInfo = [PSCustomObject]@{
    FirstName      = $FirstName
    LastName       = $LastName
    Name           = $Name
    SamAccountName = $SamAccountName
    Title          = $Title
    Department     = $Department
    Manager        = $Manager
    StreetAddress  = $StreetAddress
    City           = $City
    State          = $State
    PostalCode     = $PostalCode
    Country        = $Country
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
    
    $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $true
  }
  catch {
    $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
  }
}