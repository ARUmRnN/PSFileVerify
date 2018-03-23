$ChecksumsFiles="MD5SUMS","SHA1SUMS","SHA256SUMS","SHA512SUMS"

$List = New-Object System.Collections.ArrayList

$ChecksumsFiles | ForEach-Object {
  If (Test-Path $_) {
    $hashmethod = $_.Substring(0,$_.Length-4)
    
    Get-Content $_ | ForEach-Object {
      $resline = @{}
      $resline["HashMethod"] = $hashmethod
      $line = $_.Split(" ",[System.StringSplitOptions]::RemoveEmptyEntries)
      $resline["FileName"] = $line[1]
      $resline["OriginHash"] = $line[0]
      $resline["FileExist"] = (Test-Path $resline.FileName)
      
      If ($resline.FileExist) {
        $resline["EvalHash"] = (Get-FileHash -Path $resline.FileName -Algorithm $resline.HashMethod).Hash
        $resline["Valid"] = ($resline.OriginHash -eq $resline.EvalHash)        
      }

      [void] $List.Add(([pscustomobject] $resline))
    }
  }
}

$List | Format-Table HashMethod, FileName, Valid