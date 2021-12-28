function Set-AdUserInfo {
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullorEmpty()]
    [string]$Identity,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$Name,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$FirstName,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$LastName,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$SamAccountName,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$UserPrincipalName,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$OuPath,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$Title,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$Department,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$Manager,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$StreetAddress,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$City,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$State,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$PostalCode,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$Country,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$EmployeeNumber
  )

  # set information for the user
  
  $result = [PSCustomObject]@{}
  $result | Add-Member -NotePropertyName "User" -NotePropertyValue $Identity

  try {
    Set-AdUser -Identity $Identity `
      -DisplayName $Name `
      -GivenName $FirstName `
      -Surname $LastName `
      -SamAccountName $SamAccountName `
      -UserPrincipalName $UserPrincipalName `
      -Title $Title `
      -Department $Department `
      -Manager $Manager `
      -StreetAddress $StreetAddress `
      -City $City `
      -State $State `
      -PostalCode $PostalCode `
      -Country $Country `
      -EmployeeNumber $EmployeeNumber `
      -ErrorAction Stop
  }
  catch {
    
  }
}