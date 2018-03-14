$ChecksumsFiles="MD5SUMS","SHA1SUMS","SHA256SUMS","SHA512SUMS"

$ChecksumsFiles | ForEach-Object {
  $hashmethod = $_.Substring(0,$_.Length-4)
  
  If (Test-Path $_) {
    Get-Content $_ | ForEach-Object {
      $line = $_.Split(" ",[System.StringSplitOptions]::RemoveEmptyEntries)
      $originhash = $line[0]
      $filename = $line[1]
      
      If (Test-Path $filename) {
        $hashobject = Get-FileHash -Path $filename -Algorithm $hashmethod
        $clchash = $hashobject.Hash
        If ($clchash -eq $originhash) {
          Write-Host "valid"
        }
        Else {
          Write-Host "Not valid"
          Write-Host "From file: $originhash"
          Write-Host "Calculate: $clchash"
        }
      }
    }
  }
}