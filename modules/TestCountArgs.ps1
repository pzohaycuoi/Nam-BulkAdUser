function PrintArgs()
{
  param (
      [Parameter()]
      [string]
      $
  )
    Write-Host "You passed $($args.Count) arguments:"
    $a = $args | fl *
    
    foreach ($item in $args) {
      if (($item -eq "") -or ($item -eq $null)) {
        Write-Host "cac"
      } else {
        Write-Host $item
      }
    }
}