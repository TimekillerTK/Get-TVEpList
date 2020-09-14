#Requires -Version 7.0

# Function
function Get-TVEpList {
    <#
    .SYNOPSIS
    This tool will fetch individual episode titles from https://www.themoviedb.org

    .DESCRIPTION
    Tool for fetching individual episodes from https://www.themoviedb.org

    .PARAMETER URI
    Should be a URI pointing to an individual season of a specific show, like for example: https://www.themoviedb.org/tv/314-star-trek-enterprise/season/1

    .PARAMETER REGEX
    This regex pattern will be searched for within the URI provided

    .PARAMETER REMOVEILLEGALCHAR
    Removes NTFS illegal characters / ? < > \ : * | "

    .EXAMPLE
    Get-TVEpList -URI https://www.themoviedb.org/tv/314-star-trek-enterprise/season/1 
    
    This example will simply retrieve the episode titles from the URL and return them as an object
    
    .EXAMPLE
    Get-TVEpList -URI https://www.themoviedb.org/tv/314-star-trek-enterprise/season/1 -Regex "Spaghetti"
    
    This example uses a custom regex instead of the default "Season "

    .EXAMPLE
    Get-TVEpList -URI https://www.themoviedb.org/tv/314-star-trek-enterprise/season/1 -RemoveIllegalChars $true

    Will automatically remove NTFS illegal characters from the episode titles: / ? < > \ : * | "

    .INPUTS
    String

    .OUTPUTS
    PSCustomObject

    .NOTES
    Author:  TimekillerTK
    Website: https://github.com/TimekillerTK
#>

    #CmdletBinding turns the function into an advanced function with
    [CmdletBinding()]
    param (

        [Parameter(Mandatory)]
        [string]$URI,

        [Parameter()]
        [string]$Regex = "Season ",

        [Parameter()]
        [bool]$RemoveIllegalChar = $false
    )
    PROCESS {

        # Web scrape for URI
        $fetch = Invoke-WebRequest -Uri $URI

        # Selects the relevant links, obviously works only with TV shows, not movies
        $rawtitles = (($fetch.links).title | Where-Object { $_ -match $Regex }) | Select-Object -Unique

        # Create an empty arraylist object
        $arraylist = New-Object -TypeName "System.Collections.ArrayList"
        $arraylist.Clear()

        # Template for ConvertFrom-String, doesn't work perfectly in all cases, needs to be looked at.
        $template = ("{ShowTitle*:Example Title}: Season {[int]Season:1} ({[int]Date:1988}): Episode {[int]Episode:1} - {EpTitle:Spaghetti Code?}`r`n" +
                    "{ShowTitle*:Another Example Title}: Season {[int]Season:17} ({[int]Date:2004}): Episode {[int]Episode:42} - {EpTitle:Wonderful, Spices!!!}")

        foreach($item in $rawtitles) {
            
            # converts the object 
            $temp = $item | ConvertFrom-String -TemplateContent $template

            If($RemoveIllegalChar -eq $true) {
                
                # NTFS illegal characters for filenames, regex format
                $illegalchar = "\'", "\""", "\/", "\?", "\<", "\>", "\\", "\:", "\*", "\|" 

                # Loop that goes over each illegal character
                foreach ($item in $illegalchar) {
                    $temp.EpTitle = $temp.EpTitle -replace $item,""            
                }
            }
            
            # add an object to the arraylist
            $arraylist.Add($temp) | Out-Null

        }

        # Return the result
        return $arraylist

    }
}
