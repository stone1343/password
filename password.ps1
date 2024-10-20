# password.ps1 2024-10-20 JMS
Param (
  $length=12,
  $lower=1,
  $upper=1,
  $digit=1,
  $special=1,
  $chars='-_'
  )
# No specific reason why 100, it seems there should be an upper limit, 100 seems emore than enough
if ($length -gt 100) {
  Write-Output("Length must be less than or equal to 100")
  exit
}
if (($lower+$upper+$digit+$special) -lt 1) {
  Write-Output("At least one character class must be specified")
  exit
}
if ($length -lt $lower+$upper+$digit+$special) {
  Write-Output("Length must be greater than or equal to "+[string]($lower+$upper+$digit+$special))
  exit
}
# Omit lower and upper i, L, o
$lCharSet = "abcdefghjkmnpqrstuvwxyz"
$uCharSet = "ABCDEFGHJKMNPQRSTUVWXYZ"
$dCharSet = "0123456789"
$sCharSet = $chars
$fCharSet = ""
if ($lower -gt 0) { $fCharSet += $lCharSet }
if ($upper -gt 0) { $fCharSet += $uCharSet }
if ($digit -gt 0) { $fCharSet += $dCharSet }
if ($special -gt 0) { $fCharSet += $sCharSet }
$fCharSet = $fCharSet.ToCharArray()
$rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
$bytes = New-Object byte[]($length)
$rng.GetBytes($bytes)
$result = New-Object char[]($length)
for ($i = 0 ; $i -lt $length ; $i++) {
  if ($i -lt $lower) { $result[$i] = $lCharSet[$bytes[$i] % $lCharSet.Length] }
  elseif ($i -lt $lower+$upper) { $result[$i] = $uCharSet[$bytes[$i] % $uCharSet.Length] }
  elseif ($i -lt $lower+$upper+$digit) { $result[$i] = $dCharSet[$bytes[$i] % $dCharSet.Length] }
  elseif ($i -lt $lower+$upper+$digit+$special) { $result[$i] = $sCharSet[$bytes[$i] % $sCharSet.Length] }
  else { $result[$i] = $fCharSet[$bytes[$i] % $fCharSet.Length] }
}
$result = $result | Sort-Object { Get-Random }
Write-Output(-join $result)
