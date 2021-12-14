function Search-DataAndLocation {
  param (
    [Parameter(Mandatory, Position=0)]
    [String]
    $Location,

    [Parameter(Mandatory, Position=1)]
    [System.Object]
    $ReferenceData
  )

  # Get location data and check if input data exist

  # if InputData has location data then refer to the LocatationData and return the object with LocationData
  # else return only InputData
  $result = [PSCustomObject]@{}
  $result | Add-Member -NotePropertyName "Location" -NotePropertyValue $Location
  $getRefDataInput = $ReferenceData | Where-Object { $_.Location -eq $Location }

  if (-not ($null -eq $getRefDataInput)) {
    $locationData = [PSCustomObject]@{
      Location      = $Location
      StreetAddress = $getRefDataInput.StreetAddress
      City          = $getRefDataInput.City
      State         = $getRefDataInput.State
      PostalCode    = $getRefDataInput.PostalCode
      Country       = $getRefDataInput.Country
      OuPath        = $getRefDataInput.OuPath
    }
    $result | Add-Member -NotePropertyName "LocationData" -NotePropertyValue $locationData
    $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $true
  }
  else {
    $result | Add-Member -NotePropertyName "LocationData" -NotePropertyValue $null
    $result | Add-Member -NotePropertyName "Result" -NotePropertyValue $false
    return $result
  }
}