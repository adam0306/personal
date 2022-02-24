Set-Location -Path ~\Desktop
$names = Get-content "~\Desktop\hostname.txt"

foreach ($name in $names)
{
    if (Test-Connection -ComputerName $name -Count 1 -ErrorAction SilentlyContinue){
        $result = $null
        $currentEAP = $ErrorActionPreference
        $result = [System.Net.Dns]::gethostentry($name)
        $ErrorActionPreference = $currentEAP
        $Resultlist += [string]$Result.HostName
        $name,$ResultList | Out-File -Append resolved.txt
        $result = $null
        $Resultlist = $null
    }
    else
    {
        $name | Out-File -Append down.txt
    }
}
