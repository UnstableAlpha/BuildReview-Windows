
$props = Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\FirewallRules
$Rules = $props | Get-Member -MemberType NoteProperty | select -expand name | %{ $props.$_.tostring() }

$Headers = $Rules | %{ $_.split('|') | select -skip 1 | ?{ $_ -ne '' } } | ConvertFrom-Csv -Delimiter '=' -Header Item,Value | Group-Object Item | Select-Object -ExpandProperty Name

$Rules | %{

    $Item = $null
    $Item = $_.split('|') | select -skip 1 | ?{ $_ -ne '' }
    if($Item){
        $Hashvalues = $null
        $Hashvalues = @{}
        
        $Item | ConvertFrom-Csv -Delimiter '=' -Header Item,Value | Group-Object Item | %{
            $Hashvalues.Add( $_.Name, ($_.Group | select -expand value) )
        }
        

        $Out = iex "'' | select '$($Headers -join `"','`")'"
        foreach($H IN $Headers){
            
            if($Hashvalues.$H){
                $Out.$H = $Hashvalues.$H
             }else{
                $Out.$H = $null
             }
        
        }
        
       $Out
   }
   
}