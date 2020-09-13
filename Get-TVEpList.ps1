# Function
function Get-TVEpList {
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
    PROCESS {

        # Web scrape for URI
        $fetch = Invoke-WebRequest -Uri $URI

        # Selects the relevant links, obviously works only with TV shows, not movies
        $rawtitles = (($fetch.links).title | Where-Object { $_ -match 'Season ' }) | Select-Object -Unique

        # Create an empty arraylist object
        $arraylist = New-Object -TypeName "System.Collections.ArrayList"
        $arraylist.Clear()

        # Template for ConvertFrom-String
        $template = ("{ShowTitle*:Example Title}: Season {[int]Season:1} ({[int]Date:1988}): Episode {[int]Episode:1} - {EpTitle:Spaghetti Code?}`r`n" +
                    "{ShowTitle*:Another Example Title}: Season {[int]Season:17} ({[int]Date:2004}): Episode {[int]Episode:42} - {EpTitle:Wonderful, Spices!!!}")

        foreach($item in $rawtitles) {
            
            # converts the object 
            $temp = $item | ConvertFrom-String -TemplateContent $template
            
            # add an object to the arraylist
            $arraylist.Add($temp) | Out-Null

        }

        # Return the result
        return $arraylist

    }
}
