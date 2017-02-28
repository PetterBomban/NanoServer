function Import-NanoServerToHyperV
{
    [CmdletBinding()]
    param
    (
        [Parameter( Mandatory = $True,
                    Position = 0,
                    ValueFromPipelineByPropertyName = $True)]
        [Alias("TargetPath", "Path")]
        [string] $ImagePath,

        [Parameter( Mandatory = $True,
                    Position = 1,
                    ValueFromPipelineByPropertyName = $True)]
        [string] $ComputerName,

        [Parameter( Mandatory = $True,
                    Position = 2,
                    ValueFromPipelineByPropertyName = $True)]
        [Alias("TargetPath", "Image")]
        [string] $VHDPath
    )
    Import-Module Hyper-V

    New-VM -VHDPath $VHDPath -Name $ComputerName -



}

Import-NanoServerToHyperV
