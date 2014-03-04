$script:title = "Progress"
$script:totalSteps = 0

function Init {
    param([string]$activity = "Progress")
    $script:title = $activity
    $script:totalSteps = 0
}

function Step {
    param([string]$status)
    $position = $script:totalSteps
    $script:totalSteps += 1
    
    [Func[int]]$getTotal = { return $script:totalSteps }
    $s = New-Module -ArgumentList $script:title,$status,$position,$getTotal -ScriptBlock {
        $activity = $args[0]
        $status = $args[1]
        $position = $args[2]
        $getTotal = $args[3]

        function Set {
            $total = $getTotal.Invoke()
            $pos = $position + 1
            Write-Host "Step $pos of ${total}: $status" -ForegroundColor Green -BackgroundColor Black
            $p = $position / $total * 100
            Write-Progress -Activity $script:activity -status $status -percentComplete $p
        }

        Export-ModuleMember -Function Set
    } -AsCustomObject

    return $s
}

function Done {
    param([string]$status = "Done")
    Write-Progress -Activity $script:title -status $status -percentComplete 100
}

Export-ModuleMember -Function Init, Step, Done
