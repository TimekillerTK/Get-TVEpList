# Get-TVEpList
Retrieve info about episodes for a show, used with https://www.themoviedb.org/ specifically.

## How to use
Run `Get-TVEpList -URI https://www.themoviedb.org/tv/####/season/##`

## Todo
- Help is currently broken
- Uses regex pattern to find relevant info, as a result is fragile and can break easily. Find different solution?
- Currently only works on TV shows, should work on movies as well
- Add a parameter `-RemoveIllegalChar` to optionally remove illegal NTFS characters `"/ ? < > \ : * | "`