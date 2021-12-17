function New-UserSamAcccountName {
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]$FirstName,
    
    [Parameter(Mandatory, Position=1)]
    [string]$LastName
  )

  # create user SamAccountName base on first name and last name
  # First letter of first name and whole last name
  # Ex: Nam Nguyen => nnguyen

  $samAccountName = "$($FirstName).$($LastName)"
  return $samAccountName
}