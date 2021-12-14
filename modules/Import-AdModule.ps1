function Import-AdModule {
  # Try to import Active Directory module
  $result = [PSCustomObject]@{}
  $result | Add-Member -NotePropertyName "ImportAdModule"

  try {
    if (-not (Get-Module -Name ActiveDirectory)) {
      # try to import the Module
      Import-Module -name ActiveDirectory -ErrorAction stop -WarningAction SilentlyContinue
      $null = Get-Module -Name ActiveDirectory -ErrorAction stop  # Query if the AD PSdrive is loaded
      return $true
    }
    else {
      return $true
    }
  }
  catch {
    return $false
  }
}