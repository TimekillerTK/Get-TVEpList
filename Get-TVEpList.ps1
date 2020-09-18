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

    .EXAMPLE
    Get-TVEpList -URI https://www.themoviedb.org/tv/314-star-trek-enterprise/season/1 
    
    This example will simply retrieve the episode titles from the URL and return them as an object
    
    .EXAMPLE
    Get-TVEpList -URI https://www.themoviedb.org/tv/314-star-trek-enterprise/season/1 -Regex "Spaghetti"
    
    This example uses a custom regex instead of the default "Season "

    .INPUTS
    String

    .OUTPUTS
    PSCustomObject

    .NOTES
    Author:  TimekillerTK
    Website: https://github.com/TimekillerTK
#>

    #CmdletBinding turns the function into an advanced function
    [CmdletBinding()]
    param (

        [Parameter(Mandatory)]
        [string[]]$URIs,

        [Parameter()]
        [string]$Regex = "Season "

    )
    PROCESS {

        # Create an empty arraylist object
        # This is suboptimal, optimize it LATER
        $arraylist = New-Object -TypeName "System.Collections.ArrayList"
        $arraylist.Clear()
            
        foreach ($URI in $URIs) {
            
            # Web scrape for URI
            $fetch = Invoke-WebRequest -Uri $URI
    
            # Selects the relevant links, obviously works only with TV shows, not movies
            $rawtitles = (($fetch.links).title | Where-Object { $_ -match $Regex }) | Select-Object -Unique
    


            # Template for ConvertFrom-String, doesn't work perfectly in all cases, needs to be looked at.
            $template = ("{ShowTitle*:Example Title}: Season {[int]Season:1} ({[int]Date:1988}): Episode {[int]Episode:1} - {EpTitle:Spaghetti Code?}`r`n" +
                        "{ShowTitle*:Another Example Title}: Season {[int]Season:17} ({[int]Date:2004}): Episode {[int]Episode:42} - {EpTitle:Wonderful, Spices!!!}`r`n" +
                        "{ShowTitle*:SomeThing}: Season {[int]Season:47} ({[int]Date:1950}): Episode {[int]Episode:142} - {EpTitle:nothing}")
    


            foreach($item in $rawtitles) {
                
                # converts the object 
                $temp = $item | ConvertFrom-String -TemplateContent $template

                # This is where the switch should be, but it needs to be refactored to work properly
                switch ($rawtitles.Count) {

                    # Checks total show epcount is between 10-99
                    { ($_ -ge 10) -and ($_ -le 99) } { 
            
                        #Write-Output "$temp.Episode is between 10-99"
                        if ($temp.Episode -lt 10){
                            $en = "0$($temp.Episode)"
                        } else {
                            $en = "$($temp.Episode)"
                        }
            
                    }
            
                    # Checks total show epcount is between 100-999
                    { ($_ -ge 100) -and ($_ -le 999) } { 
            
                        #Write-Output "$temp.Episode is between 100-999"
                        if ($temp.Episode -lt 10){
                            $en = "00$($temp.Episode)"
                        } elseif (($temp.Episode -ge 10) -and ($temp.Episode -lt 100)){
                            $en = "0$($temp.Episode)"
                        } else {
                            $en = "$($temp.Episode)"
                        }
                        
            
                    }
                    Default {Write-Output "TOTAL EPISODES IS BIGGER THAN GOD"}
                    
                } #switch
                
                $temp | Add-Member -MemberType NoteProperty `
                                   -Name 'EpisodeZeroed' `
                                   -Value $en


                # add an object to the arraylist
                $arraylist.Add($temp) | Out-Null
    
            } #foreach

        } #foreach

        # Return the result
        return $arraylist

    } #process
} #function


<#
Testing section for supporting search by title:

$URI = "https://www.themoviedb.org/search?query=my%20hero%20academia"

# Web scrape for URI
$fetch = Invoke-WebRequest -Uri $URI
  
$showlink = $fetch.links | Where-Object { $_ -like '*title="TV Shows"*' }

$realfetch = Invoke-WebRequest -Uri "https://www.themoviedb.org$($showlink.href)"
#>