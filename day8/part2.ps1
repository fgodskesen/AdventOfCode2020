# Part 1 
# what is acc upon first time an instruction is executed second time
Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

# 
$inputData = Get-Content ".\day8\input.txt"


enum StateMachineState {
    Ready
    Finished
    OutOfBounds
    InfiniteLoop
}


class StateMachine {
    hidden [System.Collections.ArrayList]$_instructionset
    hidden [int]$_accumulator
    hidden [int]$_position
    hidden [StateMachineState]$_state
    
    StateMachine([string[]]$Instructionset) {
        $this._instructionset = [System.Collections.ArrayList]::new()


        for ($x = 0; $x -lt $Instructionset.Count; $x++) {
            $rx = [regex]::Match($Instructionset[$x], '(?:^(?<cmd>\S+)\s+(?<val>\S+)$)')


            $null = $this._instructionset.Add(
                [pscustomobject]@{
                    Command      = $rx.Groups['cmd'].Value
                    Value        = $rx.Groups['val'].Value
                    HasRunBefore = $false
                }
            )
        }
        
        # init internal variables
        $this._accumulator = 0
        $this._position = 0
        $this._state = [StateMachineState]::Ready



        # Add Read only members
        $this | Add-Member -Name Accumulator -MemberType ScriptProperty -Value {
            return $this._accumulator
        } -SecondValue { throw "property is read-only" }
        $this | Add-Member -Name Position -MemberType ScriptProperty -Value {
            return $this._position
        } -SecondValue { throw "property is read-only" }
        $this | Add-Member -Name State -MemberType ScriptProperty -Value {
            return $this._state
        } -SecondValue { throw "property is read-only" }
        $this | Add-Member -Name InstructionSet -MemberType ScriptProperty -Value {
            return $this._instructionset
        } -SecondValue { throw "property is read-only" }
    }


    [void]StepOnce() {
        if ($this._position -eq $this._instructionset.Count) {
            $this._state = [StateMachineState]::Finished
            Write-Host "Reached end of program."
            return
        }
        elseif ($this._position -lt 0 -or $this._position -gt $this._instructionset.Count) {
            $this._state = [StateMachineState]::OutOfBounds
            Write-Verbose "Error - position is outside of the InstructionSet"
            return
        }
        elseif ($this._instructionset[$this._position].HasRunBefore) {
            $this._state = [StateMachineState]::InfiniteLoop
            Write-Verbose "Error - Infinite loop. Halting execution."
            return            
        }


        # mark this instruction as previously ran
        $this._instructionset[$this._position].HasRunBefore = $true
        
        # then move position and/or change accumulator
        switch ($this._instructionset[$this._position].Command) {
            'nop' {
                $this._position++
                break
            }
            'jmp' {
                $this._position += $this._instructionset[$this._position].Value
                break
            }
            'acc' {
                $this._accumulator += $this._instructionset[$this._position].Value
                $this._position++
                break
            }
            default {
                throw 'NotImplemented'
                break
            }
        }
    }
    [object]Print() {
        return [pscustomobject]@{
            Pos = $this._position
            Acc = $this._accumulator
            State = $this._state
        }
    }
}


for ($x = 0; $x -lt $inputData.Count - 1; $x++) {
    Write-Host "Testing line $x"

    # replace nop/jmp in this line 
    if ($inputData[$x] -like 'jmp*') {
        $inputData[$x] = $inputData[$x].Replace('jmp','nop')
    } elseif ($inputData[$x] -like 'nop*') {
        $inputData[$x] = $inputData[$x].Replace('nop','jmp')
    }
    
    $machine = [StateMachine]::new($inputData)
    while ($machine.State -eq 'Ready') {
        $machine.StepOnce()
    }

    if ($machine.State -eq [StateMachineState]::Finished) {
        Write-Host "This one worked. Replaced operation in line $x"
        $machine.Print()
        break
    }


    # replace nop/jmp in this line back to original
    if ($inputData[$x] -like 'jmp*') {
        $inputData[$x] = $inputData[$x].Replace('jmp','nop')
    } elseif ($inputData[$x] -like 'nop*') {
        $inputData[$x] = $inputData[$x].Replace('nop','jmp')
    }
}