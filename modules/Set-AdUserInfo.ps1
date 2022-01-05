function Set-AdUserInfo {
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullorEmpty()]
    [string]$Identity,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$DisplayName,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$GivenName,

    [Parameter()]
    [AllowNull()]
    [AllowEmptyString()]
    [AllowEmptyCollection()]
    [string]$SurName,

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
    [psobject]$Manager,

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
  $inputData = $PSBoundParameters
  $parameterList = @("DisplayName", "GivenName", "SurName", "SamAccountName", "UserPrincipalName", "Title",
    "Department", "Manager", "StreetAddress", "City", "State", "PostalCode", "Country", "EmployeeNumber")

  # get user information
  try {
    $userInfo = Get-ADUser -Identity $Identity -ErrorAction Stop
  }
  catch {
    $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "Failed: Unable to get user $($Identity) Info: $($_)"
    $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
    return $result
  }

  # if manager parameter has value then get manager information
  if (($Manager -ne '') -and ($Manager -ne $null)) {
    try {
      $Manager = Get-ADUser -Identity $Manager -ErrorAction Stop
    }
    catch {
      $result | Add-Member -NotePropertyName "Log" -NotePropertyValue "Failed: Unable to get manager $($Manager) Info: $($_)"
      $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
      return $result
    }
  }

  $containList = @()
  $notContainList = @()
  $userInfoForCreating = [PSCustomObject]@{}

  # if any parameter has value then add it into the user object
  foreach ($userAttribute in $inputData.GetEnumerator()) {
    $userAttributeKey = $userAttribute.Key
    $userAttributeValue = $userAttribute.Value

    # Add value into user object for modifying user information
    if (($parameterList -contains $userAttributeKey) -and ($userAttributeValue -ne '') -and ($userAttributeValue -ne $null)) {
      # if manager paramter is provided then get information from $Manager variable instead of paramter value
      if ($userAttributeKey -eq "Manager") {
        $userInfo.Manager = $Manager
        $containList += $userAttributeKey
        $userInfoForCreating | Add-Member -NotePropertyName $userAttributeKey -NotePropertyValue $userAttributeValue
      }
      else {
        $containList += $userAttributeKey
        $userInfo.$userAttributeKey = $userAttributeValue
        $userInfoForCreating | Add-Member -NotePropertyName $userAttributeKey -NotePropertyValue $userAttributeValue 
      }
    }
    else {
      continue
    }
  }

  $result | Add-Member -NotePropertyName "UserInfo" -NotePropertyValue $userInfoForCreating
  $notContainList = $parameterList | Where-Object { $_ -notin $containList }
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