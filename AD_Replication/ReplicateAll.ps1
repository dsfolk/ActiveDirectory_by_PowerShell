
cmd /c "repadmin /showrepl * /csv > .\TempScriptFile_replsum.csv"
$ReplicationReport = Import-Csv -Path .\TempScriptFile_replsum.csv

foreach ($object in $ReplicationReport) {

    if ($object.showrepl_COLUMNS -match "ERROR") {Write-Host -ForegroundColor Red "Error: Unable to reach server $($object.'Destination DSA') to fetch replication ststus"}
    else {

        $replResult = repadmin /replicate $object.'Destination DSA' $object.'Source DSA' $object.'Naming Context'
        $replResult  = $replResult | Where-Object {$_}

        if ($replResult -match "completed successfully") {$status = "Success"}
        else {$status = "Failed. Error: $($replResult[0]) $($replResult[1])"}
        

        [PSCustomObject]@{
            'Replicating DC'    = $object.'Destination DSA'
            'From DC'           = $object.'Source DSA'
            'Partition Name'    = $object.'Naming Context' 
            'Status/Error'      = $status                
        } | Format-Table
    }
}
