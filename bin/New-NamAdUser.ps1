function New-NamAdUser {

  param (

    [Parameter(Mandatory)]
    [string]$FirstName,

    [Parameter(Mandatory)]
    [string]$LastName,

    [Parameter(Mandatory)]
    [string]$Title,

    [AllowEmptyString()]
    [string]$Department,

    [Parameter(Mandatory)]
    [string]$Manager,

    [Parameter(Mandatory)]
    [string]$Location

  )
  
  $importAdModuleStat = Import-AdModule
  if ($true -eq $importAdModuleStat) {
    $importLocationData = Import-LocationData
    if (-not ($false -eq $importLocation)) {
      $inputObject = Receive-InputData `
        -FirstName $FirstName `
        -LastName $LastName `
        -Title $Title `
        -Department $Department `
        -Manager $Manager `
        -Location $Location

      $refedObject = Reference-DataAndLocation -InputData $inputObject -ReferenceData $importLocationData
      if (-not ($refedObject.Result -eq "FAIL")) {
        $createAdUser = Create-AdUser -InputData $refedObject
        return $createAdUser
      }
      else {
        return $refedObject
      }
    }
    else {
      break
    }
  }
  else {
    break
  } 
}