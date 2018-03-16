
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
cd $PSScriptRoot
$SourceFile = ".\ports.txt"

if (Test-Path $SourceFile)
{
}
else {"ports" | set-content $SourceFile}


$PortObject = import-csv $SourceFile
$PortsToScan = $PortObject.ports

$IPAddress = "10.10.0.9"

Write-Host "Please select how you want to scan"
Write-Host "1 - Single Port"
Write-Host "2 - Range of Ports"
Write-Host "3 - File List of Ports"
$Selection = Read-Host "Make you selection"


Switch ($Selection)
{
    1 {$PortsToScan = Read-Host "Enter Port Number" }
    2 {
        $PortsToScan = ""
        [int]$StartPort = Read-Host "Enter Start Port"
        [int]$EndPort = Read-Host "Enter End Port"
        [int]$CurrentPort = $StartPort
        $PortsToScan = while ($CurrentPort -le $EndPort)
                        {

                        $PortToScan = $PortsToScan + $CurrentPort
                        $CurrentPort
                        $CurrentPort++

        
                        } 


    
      }
    3 {Write-Host "Ports list is in the same directory as the script and called ports.txt" }

}




$PortsToScan | foreach{
try{

$Connection = New-Object System.Net.Sockets.TcpClient

if($Connection.ConnectAsync($IPAddress,$_).Wait(1000))
{
 Write-Host "$IPAddress PORT $_ OPEN"
 
 $Connection.close()
 
} 
 else{
 Write-Host "$IPAddress PORT $_ CLOSED"
 $Connection.Close()
 
 }
 }
 catch{
 Write-Host "$IPAddress PORT $_ CLOSED"
 $Connection.Close()
 }
}



