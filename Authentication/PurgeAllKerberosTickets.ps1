# Purge all Kerberos tickets
$sessions = Get-WmiObject -ClassName Win32_LogonSession -Filter "AuthenticationPackage != 'NTLM'"
foreach ($session in $sessions) {
    $logonId = [Convert]::ToString($session.LogonId, 16)
    klist.exe purge -li $logonId
}
