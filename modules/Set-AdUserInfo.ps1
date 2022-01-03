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
  $inputData = $PSBoundParameters
  $result | Add-Member -NotePropertyName "UserInfo" -NotePropertyValue $inputData
  $parameterList = @("Identity","Name","FirstName","LastName","SamAccountName","UserPrincipalName","OuPath","Title",
    "Department","Manager","StreetAddress","City","State","PostalCode","Country","EmployeeNumber")

  try {
    $userInfo = Get-ADUser -Identity $Identity -ErrorAction Stop
  }
  catch {
    $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "Failed: $($_)"
    $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
    return $result
  }

  $containList = @()
  $notContainList = @()

  foreach ($userAttribute in $inputData.GetEnumerator()) {
    $userAttributeKey = $userAttribute.Key
    $userAttributeValue = $userAttribute.Value
    $userInfo.$userAttributeKey = $userAttributeValue

    if ($parameterList -contains $userAttribute.Key) {
      $containList += $userAttribute.Key
    }
  }

  $notContainList = $parameterList | Where { $_ -notin $containList }
  $result | Add-Member -NotePropertyName "ContainList" -NotePropertyValue $containList
  $result | Add-Member -NotePropertyName "NotContainList" -NotePropertyValue $notContainList

  try {
    Set-AdUser -Instance $userInfo -ErrorAction Stop
    $result | Add-member -NotePropertyName "Log" -NotePropertyValue "Success: User with identity $($Identity) has been modified"
    $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $true
    return $result
  }
  catch {
    $result | Add-member -NotePropertyName "Log" -NotePropertyValue "Failed: $($_)"
    $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
    return $result
  }
}