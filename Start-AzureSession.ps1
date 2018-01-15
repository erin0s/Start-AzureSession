function Start-AzureSession () {
    <#
    .SYNOPSIS
        Adds an authenticated account to use for Azure Resource Manager cmdlet requests.

    .DESCRIPTION
        Adds an authenticated account to use for Azure Resource Manager cmdlet requests.
        Allowing you to choose commercial or government Azure environments.  Sets global
        variables to determine if an existing session exists.  Creates a PSDrive session
        called Azure:.

    .PARAMETER l
        Login to Commercial Azure: Login-AzureRmAccount

    .PARAMETER gov
        Login to Government Azure: Login-AzureRmAccount -EnvironmentName AzureUSGovernment

    .INPUTS
        None

    .OUTPUTS
        $global:AzureSessionLoginState: Azure Commercial boolean true/false
        $global:AzureSessionLoginStateGov: Azure Government boolean true/false

    .EXAMPLE
        Start-AzureSession
        Example 1: Start-AzureSession -l
                   Login to Azure Commercial, map Azure:, set AzureSessionLoginState to 
                   $true and AzureSessionLoginStateGov to $false
        Example 2: Start-AzureSession -gov
                   Login to Azure Government, map Azure:, set AzureSessionLoginStateGov to
                   $true and AzureSessionLoginState to $false
    .LINK
        None

    .NOTES
        Version:        1.0
        Author:         Erin Osminer
        Creation Date:  10/23/2017
        Purpose/Change: Renamed from Confirm-AzureSession, and added PSDrive
        Dependency:     Modules AzureRM, AzurePSDrive
    #>
	
    [CmdletBinding()]
    Param(
        [switch]$l,
        [switch]$gov
        )
    function Add-AzLogin () {
        $azacct = Get-AzureRmContext
        if ($l) {
            if ($azacct.Environment.Name -ne 'AzureCloud'){
                Login-AzureRmAccount | Out-Null
            }
        }
        if ($gov) {
            if ($azacct.Environment.Name -ne 'AzureUSGovernment'){
                Login-AzureRmAccount -EnvironmentName AzureUSGovernment | Out-Null
            }
        }
    }

    function add-AzPSDrive () {
        $psdparam = @{
            name = 'Azure'
            PSProvider = 'SHiPS'
            root = 'AzurePSDrive#Azure'
            Scope = 'global'
        }
        New-PSDrive @psdparam | out-null
    }

    function confirm-login () {
        $azacct = Get-AzureRmContext
        if ($azacct.Environment.Name -eq "AzureCloud") {
            $global:AzureSessionLoginState = $True
            $global:AzureSessionLoginStateGov = $False
        }
        if ($azacct.Environment.Name -eq "AzureUSGovernment") {
            $global:AzureSessionLoginStateGov = $True
            $global:AzureSessionLoginState = $False
        }
    }
    
    if ($PSBoundParameters.ContainsValue($true)) {
        Add-AzLogin
        $psinventory = Get-PSDrive
        if ($psinventory | Where-Object{$_.Name -contains "Azure"}){
            Remove-PSDrive Azure
            add-AzPSDrive
        } else {
            add-AzPSDrive
        }
    }
    confirm-login
    $Error.Clear()
    $PSBoundParameters.Clear()
}