function New-NanoServer
{
    [CmdletBinding()]
    param
    (
        [ValidateSet("Compute")]
        [string] $ServerType,
        [string] $ComputerName,
        [string] $DomainName
    )
    Import-Module NanoServerImageGenerator

    $RootPath = Split-Path -Path $PSScriptRoot -Parent
    $RandomPassword = ((new-guid).guid -replace "-", "").substring(0,14)
    $RandomPassword = ConvertTo-SecureString -String $RandomPassword -AsPlainText -Force
    
    ## FIXME: This is for testing
    $Compute = $False
    $Defender = $False
    switch ($ServerType)
    {
        "Compute" { $Compute = $True }
        "Defender" { $Defender = $True }
    }

    ## Offline domain-join
    try
    {
        $DomainBlobPath = "$RootPath\TEMP\$ComputerName.djoin"
        djoin.exe /Provision /REUSE /Domain $DomainName /Machine $ComputerName /Savefile $DomainBlobPath
    }
    catch 
    {
        throw $Error[0]
    }
    
    ## TODO: Here we will eventually load values from a 
    ## .psd1-file or something.
    $Splat = @{
        MediaPath = "$RootPath\Files"
        BasePath = "$RootPath\Base"
        TargetPath = "$RootPath\Images\$ComputerName.vhd"
        DeploymentType = "Guest"
        Edition = "Datacenter"
        Ipv4Address = "192.168.0.95"
        Ipv4SubnetMask = "255.255.255.0"
        Ipv4Gateway = "192.168.0.102"
        Ipv4Dns = "172.18.0.2", "172.18.0.3"
        InterfaceNameOrIndex = "Ethernet"
        MaxSize = 20GB
        AdministratorPassword = $RandomPassword
        DomainBlobPath = $DomainBlobPath
        Compute = $Compute
        Defender = $Defender
        EnableRemoteManagementPort = $True
    }
    Write-Verbose "Creating image for $ServerType-server"
    New-NanoServerImage @Splat -Verbose 

    $Splat.ComputerName = $ComputerName
    $Splat.DomainName = $DomainName
    $Obj = [PSCustomObject]$Splat
    $Obj
}
$Params = @{
    ServerType = "Compute"
    ComputerName = "NanoTest"
    DomainName = "IKT-Fag.no"
}

New-NanoServer @Params -Verbose
