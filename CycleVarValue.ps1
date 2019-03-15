Function CycleVarValue {
    param (
    [parameter (Mandatory=$true)][System.String]$VarName,
    [parameter (Mandatory=$true)][ValidateSet('Global','Script','Local')] [System.String] $VarScope,
    [parameter (Mandatory=$true)][System.String]$VarNameDescription,
    [parameter (Mandatory=$true)][String[]]$VarValue01, #Use VarValue 01 and 02 for and AB Toggle.  Set this value to the ON if Default is OFF or Vice Versa
    [parameter (Mandatory=$true)][String[]]$VarValue02, #Use VarValue 01 and 02 for and AB Toggle.  Set this value to the OFF if Default is OFF or Vice Versa
    [parameter (Mandatory=$false)][System.String]$ReturnPoint
    )

# EXAMPLE CycleVarValue -VarName DiagMode -VarScope Global -VarNameDescription DiagMode -VarValue01 ON -VarValue02 OFF -ReturnPoint return
           
    IF (!(Test-Path Variable:"$VarName")) {New-Variable -Name $VarName -Scope $VarScope}
    IF (!(Test-Path Variable:\ToggleVarCurrValue)) {New-Variable -Name ToggleVarCurrValue -Value default}
      
    IF ($VarName -eq "" -OR $ToggleVarCurrValue -eq "Default") { #If $VarName does not exist, create it.  Assumes that if it did not exist, it was "OFF"
        Write-Host "$VarNameDescription variable NOT set"
        Write-SuperLine "Therefore, $VarNameDescription is ","OFF" -C White,Red
        Write-Host ""
        Write-SuperLine "Turning $VarNameDescription ","ON" -C White,Green
           
        Set-Variable -Name $VarName -Scope $VarScope -Value $VarValue01
        Set-Variable -Name ToggleVarCurrValue -Scope Script -Value $VarValue01
        #CLS
        Invoke-Expression $ReturnPoint
        Return
        Break
    }

    IF ($ToggleVarCurrValue -eq "$VarValue01") {
        Write-SuperLine "$VarNameDescription is now ","$VarValue01" -C White,Green
        Write-Host ""
        Write-SuperLine "Setting $VarNameDescription to ","$VarValue02 " -C White,Red
        Set-Variable -Name $VarName -Scope $VarScope -Value $VarValue02
        Set-Variable -Name ToggleVarCurrValue -Scope Script -Value $VarValue02
        #CLS
        Invoke-Expression $ReturnPoint
        Return
        Break
    }

    IF ($ToggleVarCurrValue -eq "$VarValue02") {
        Write-SuperLine "$VarNameDescription is now ","$VarValue02" -C White,Green
        Write-Host ""
        Write-SuperLine "Setting $VarNameDescription to ","$VarValue01 " -C White,Red
    
        Set-Variable -Name $VarName -Scope $VarScope -Value $VarValue01
        Set-Variable -Name ToggleVarCurrValue -Scope Script -Value $VarValue01
        #CLS
        Invoke-Expression $ReturnPoint
        Return
        Break
    }
}