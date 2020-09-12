# For categorizing show info
# Create a cmdlet that will retrieve info from whatever source online and spit it out with an object, with the episode number, season, show name, etc.. This kind of info will be used by other cmdlets down the line.  

# Function
function Get-TVEpList {
# Help is broken fix later
<#
    .SYNOPSIS
    Write synopsis of what this does

    .DESCRIPTION
    Write description here.

    .PARAMETER URI
    Explain what this paramter does

    .EXAMPLE
    Example of using the thingy.

    .INPUTS
    String

    .OUTPUTS
    PSCustomObject

    .NOTES
    Author:  TimekillerTK
    Website: https://github.com/TimekillerTK
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$URI
    )
}



