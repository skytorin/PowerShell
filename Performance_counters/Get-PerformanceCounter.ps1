function Get-PerformanceCounter
{
    # Get the Performance Counters from the Registry
    $counters = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Perflib\009' -Name 'counter' | Select-Object -ExpandProperty Counter

    # Remove the last line
    $counters = $counters | Select-Object -SkipLast 1

    # Split the string into an array
    $counters = $counters.Split([Environment]::NewLine)

    $counterList = @()

    for ($x = 0; $x -lt $counters.Count; $x++) 
    {
        if ($x % 2 -eq 0) {
            $counterList += New-Object -TypeName PSObject -Property @{ CounterID = [int]$counters[($x -2)];CounterName = [string]$counters[$x - 1] }
        }
    }

    $counterList | Sort-Object -Property 'CounterID'
}

# Get performance counters sorted by ID
# Get-PerformanceCounter | Sort-Object -Property 'CounterID' | Format-Table -AutoSize

# Search for specific performance counters by name
# Get-PerformanceCounter | Where-Object {$_.CounterName -like 'file write*'}

# Get performance counters, sorted by name
Get-PerformanceCounter | Sort-Object -Property 'CounterName' | Format-Table -AutoSize