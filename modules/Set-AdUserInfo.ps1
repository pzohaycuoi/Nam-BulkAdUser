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
  # $userInfos = [PSCustomObject]@{}
  # foreach ($item in $PSBoundParameters) {
  #   $userInfos += $item
  # }
  $a = $PSBoundParameters
  $a = [PSCustomObject]$a
  $result | Add-Member -NotePropertyName "UserInfo" -NotePropertyValue $a
  $parameterList = @("Identity","Name","FirstName","LastName","SamAccountName","UserPrincipalName","OuPath","Title",
    "Department","Manager","StreetAddress","City","State","PostalCode","Country","EmployeeNumber")
  $containList = @()
  $notContainList = @()
  foreach ($item in $a.keys) {
    if ($parameterList -contains $item) {
      $containList += $item
    }
  }
  $notContainList = $parameterList | Where { $_ -notin $containList }
  
  # try {
  #   Set-AdUser -Identity $Identity `
  #     -DisplayName $Name `
  #     -GivenName $FirstName `
  #     -Surname $LastName `
  #     -SamAccountName $SamAccountName `
  #     -UserPrincipalName $UserPrincipalName `
  #     -Title $Title `
  #     -Department $Department `
  #     -Manager $Manager `
  #     -StreetAddress $StreetAddress `
  #     -City $City `
  #     -State $State `
  #     -PostalCode $PostalCode `
  #     -Country $Country `
  #     -EmployeeNumber $EmployeeNumber `
  #     -ErrorAction Stop
    
  #   $result | Add-member -NotePropertyName "Log" -NotePropertyValue "Success: User with identity $($Identity) has been modified"
  #   $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $true
  #   return $result
  # }
  # catch {
  #   Write-Host $Error
  #   $result | Add-member -NotePropertyName "Log" -NotePropertyValue "Failed: $($_)"
  #   $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
  #   return $result
  # }
}