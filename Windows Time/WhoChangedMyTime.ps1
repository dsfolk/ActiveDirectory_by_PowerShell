

$Audit = auditpol /get /category:System | Where-Object { $_ -match "Security State Change" }

if ($Audit -match "No Auditing") { Write-Host -ForegroundColor Yellow "Security State Change auditing is not enabled." }

else {

    Get-WinEvent -FilterHashtable @{LogName = 'Security'; Id = 4616 } | ForEach-Object {

        [xml]$eventInXML = $_.toXML()

        for ($i = 0; $i -lt $eventInXML.Event.EventData.Data.Count; $i++) {

            if ($eventInXML.Event.EventData.Data[$i].Name -eq "ProcessName") {$ProcessName = $eventInXML.Event.EventData.Data[$i].'#text'}
            if ($eventInXML.Event.EventData.Data[$i].Name -eq "ProcessId") {$ProcessId = $eventInXML.Event.EventData.Data[$i].'#text'}
            if ($eventInXML.Event.EventData.Data[$i].Name -eq "PreviousTime") {$PreviousTime = $eventInXML.Event.EventData.Data[$i].'#text'}
            if ($eventInXML.Event.EventData.Data[$i].Name -eq "NewTime") {$NewTime = $eventInXML.Event.EventData.Data[$i].'#text'}
            if ($eventInXML.Event.EventData.Data[$i].Name -eq "SubjectUserName") {$User = $eventInXML.Event.EventData.Data[$i].'#text'}
        
        }

        $NewTime = Get-Date $NewTime -Format "dd-MMM-yyyy HH:mm:ss:ms"
        $PreviousTime = Get-Date $PreviousTime -Format "dd-MMM-yyyy HH:mm:ss:ms"

        [PSCustomObject]@{
            ProcessName = $ProcessName
            ProcessId = $ProcessId
            PreviousTime = $PreviousTime
            NewTime = $NewTime
            User = $User
        } | ft
        
    }
        
}