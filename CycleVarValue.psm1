Function CycleVarValue {
    param (
    [parameter (Mandatory=$true)][System.String]$VarName, #Name of the variable you are changing the value of
    [parameter (Mandatory=$true)][ValidateSet('Global','Script','Local')] [System.String] $VarScope,
    [parameter (Mandatory=$true)][array[]]$CycleValues, #Value [0] is the default, the options start counting at 1
    [parameter (Mandatory=$false)][System.String]$ReturnPoint, #Where the function will return to after incrementing the $VarName value.
    [parameter (Mandatory=$true)][string[]] $Reset # Yes or No to indicate you want to start at 0 again.  This allows you to call this from multiple places and reset the counter
    )
    
     <#
.SYNOPSIS 

    Cycles through the values of $CycleValues starting at Index 0.  You can use this to cycle a variable ON,OFF

.NOTES
    File Name  : CycleVarValue.ps1
    Author     : Ben Therien - btherien@cultureofprocess.com  
    Requires   : n/a

.EXAMPLE

    PS> CycleVarValue -VarName DiagMode -VarScope Global DiagMode -CycleValues OFF,ON -ReturnPoint return -Reset NO
    PS> CycleVarValue -VarName DiagMode -VarScope Global DiagMode -CycleValues 1,2,3,4,5,6,7,8,9,10 -ReturnPoint return -Reset NO

.LINK

    https://github.com/Inventologist/CycleVarValue

.LINK
#>

    IF (!(Test-Path Variable:"$VarName")) {New-Variable -Name $VarName -Scope $VarScope}
    IF (!(Test-Path Variable:\ToggleVarCurrValue)) {New-Variable -Name ToggleVarCurrValue -Scope Script -Value default}
    IF (!(Test-Path Variable:\CycleValuesIndex)) {New-Variable -Name CycleValuesIndex -Scope Script -Value 0}

    If ($Global:DiagMode -eq "ON") {Write-Host "CycleValuesIndex is: $CycleValuesIndex";Write-Host "$VarName is: "$CycleValues[$CycleValuesIndex]"";Write-Host "Incrementing CVI"}
    
    IF ($Reset -eq "YES") {$Script:CycleValuesIndex = 0}    
    IF ($Script:CycleValuesIndex -lt $CycleValues.Length) {$Script:CycleValuesIndex = $CycleValuesIndex + 1}
    IF ($Script:CycleValuesIndex -eq $CycleValues.Length) {$Script:CycleValuesIndex = 0}

    Set-Variable -Name $VarName -Scope $VarScope -Value $CycleValues["$Script:CycleValuesIndex"]
    
    If ($Global:DiagMode -eq "ON") {Write-Host "CycleValuesIndex is: $CycleValuesIndex";Write-Host "$VarName is: "$CycleValues[$CycleValuesIndex]"";pause}
} #Cycles a variable through a set of values