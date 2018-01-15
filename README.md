# Start-AzureSession
Adds an authenticated account to use for Azure Resource Manager cmdlet requests, while modifying global variables for PS prompt identification.  AzurePSDrive is also leveraged to allow for resource browsing.

## Getting Started
Blog entry: (https://osminer.blogspot.com/2018/01/powershell-profile-and-azure-login.html)
```
Start-AzureSession -l
```

### Prerequisites
* [Azure PowerShell Module](https://docs.microsoft.com/en-us/powershell/azure/install-azurerm-ps?view=azurermps-5.1.1)
* [AzurePSDrive Module](https://github.com/PowerShell/AzurePSDrive)
* Two global variables defined in the PowerShell Profile
```
$global:AzureSessionLoginState = $False
$global:AzureSessionLoginStateGov = $False
```
* Modify the PowerShell prompt function to change when the global variableschange
```
if ($AzureSessionLoginState -eq $True){
        Write-Host "[" -noNewLine
        Write-Host "Az" -foregroundcolor DarkCyan -noNewLine
        Write-Host "]" -nonewline
        } else {if ($AzureSessionLoginStateGov -eq $True){
            Write-Host "[" -noNewLine
            Write-Host "AzGov" -foregroundcolor DarkCyan -noNewLine
            Write-Host "]" -nonewline
        }
    }
```