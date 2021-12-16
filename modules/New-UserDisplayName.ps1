function New-UserDisplayName {
  param (
      [Parameter(Mandatory, Position=0)]
      [string]$FirstName,
      
      [Parameter(Mandatory, Position=1)]
      [string]$LastName
  )

  # create user display name
  # first name and last name will be seperated by "," and " "
  # Ex: Nam Nguyen => Nam, Nguyen

  $userDisplayName = "$($FirstName), $($LastName)"
  return $userDisplayName
}