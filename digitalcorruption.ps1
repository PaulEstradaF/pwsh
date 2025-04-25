# Glitch Model 3: Digital Corruption
# Rose stays still, glitches with vertical artifacts, then disintegrates

# Highly detailed ASCII Rose with special characters fixed for PowerShell
$rose = @(
    "                                                           ,",
    "                                                        _.'|",
    "                                                     ,-'  /;",
    "                                                   ,' |  /  |",
    "                                                  / . | /.' ;",
    "                        _._                       | ,  /   /",
    "                      ,'   '._        _           | | /_/,'",
    "                     '        '._   ,' ''.        ' ,' ,'",
    "                    /            ,,''      '.      ;/ -'_.--.._",
    "                   |             |         .|     /  ,' /_./.,\",
    "                   |       ,''-._  |      .' | ,'''- /_,-' \  \:.  ",
    "         _,._    _  '.   ._;,.. '.|      |  |'     '\   \   _,'",
    "     _.-;....'.-' '--.\ /:\_   '\,'._    |  |      /  ''''''",
    "  _,;-'''' \ '|       '| .  ''|'\   '.  | /      /",
    ",.:______,,...|      / | |   _.; |'.   './,'    .'",
    "            ,-'     |  './,-:_ |/   '.   \/    ,'",
    "           /       ,|   .:...,'     ,|'. |   ,'",
    "           '.    ,'  \ /._        _,|   \|-''''-        __ ,|",
    "             '--'     / \ '..---' ,'    |      '.   _,''_,'|",
    "            / .'      |  \  '-._,,'     ,'       |  / |/-- /",
    "            \ \'-.'''-. \  '.        _.-'\      _,' | /-- ,'",
    "            ;  \..._  ''---.'---;'-      \---;'._  |/ _,' __",
    "           /  ___   '|''-'-'    /         |  '-.:,|,;.-''  '-.",
    "           '''   ''''-\         /          |    _,:\;.____ / /   \",
    "                      '       /           /  ,' _,'\.   \''\\--.- \",
    "                       '.   ,' '-._     _/  / --/ | |:.  \ '. ' ' \",
    "                         '''       ''--'    | ,'| ' /  '---....----'",
    "                                            |/| ,'",
    "                                            |,,-''"
)

# Glitch characters to randomly replace in the rose
$glitchChars = "!@#$%^&*()_+-=[]{}|;:,./<>?"

# Digital corruption-style characters (using ASCII characters instead of Unicode blocks)
$corruptionChars = @("#", "%", "@", "$", "=", "+", "|", "/", "\", "_", "-")

# Function to create a vertical digital corruption effect
function Add-VerticalCorruption {
    param (
        [array]$RoseLines,
        [int]$NumCorruptions = 5,
        [int]$MaxWidth = 3
    )
    
    $maxLength = 0
    foreach ($line in $RoseLines) {
        if ($line.Length -gt $maxLength) {
            $maxLength = $line.Length
        }
    }
    
    $corruptedRose = @()
    foreach ($line in $RoseLines) {
        $corruptedRose += $line
    }
    
    # Create vertical corruptions
    $corruptionPositions = @()
    for ($i = 0; $i -lt $NumCorruptions; $i++) {
        $pos = Get-Random -Minimum 0 -Maximum $maxLength
        $width = Get-Random -Minimum 1 -Maximum ($MaxWidth + 1)
        $corruptionPositions += @{Position = $pos; Width = $width}
    }
    
    # Apply corruptions
    for ($lineIdx = 0; $lineIdx -lt $corruptedRose.Count; $lineIdx++) {
        $line = $corruptedRose[$lineIdx]
        $newLine = ""
        
        for ($charIdx = 0; $charIdx -lt $maxLength; $charIdx++) {
            $isCorrupted = $false
            
            # Check if this position is in a corruption zone
            foreach ($corruption in $corruptionPositions) {
                if ($charIdx -ge $corruption.Position -and $charIdx -lt ($corruption.Position + $corruption.Width)) {
                    $isCorrupted = $true
                    break
                }
            }
            
            if ($isCorrupted) {
                # Add a corruption character
                $newLine += $corruptionChars[(Get-Random -Maximum $corruptionChars.Length)]
            } elseif ($charIdx -lt $line.Length) {
                # Add original character
                $newLine += $line[$charIdx]
            } else {
                # Pad with spaces
                $newLine += " "
            }
        }
        
        $corruptedRose[$lineIdx] = $newLine
    }
    
    return $corruptedRose
}

# Function to create a disintegrating version of a string
function Get-DisintegratedString {
    param (
        [string]$Text,
        [int]$DisintegrationLevel = 0,  # 0-100, higher means more disintegration
        [int]$CorruptionLevel = 0       # 0-100, higher means more digital corruption
    )
    
    $disintegratedText = ""
    
    foreach ($char in $Text.ToCharArray()) {
        # Check for disintegration (spaces)
        if ((Get-Random -Minimum 1 -Maximum 101) -le $DisintegrationLevel) {
            $disintegratedText += " "
        }
        # Check for corruption (replace with corruption character)
        elseif ((Get-Random -Minimum 1 -Maximum 101) -le $CorruptionLevel) {
            $disintegratedText += $corruptionChars[(Get-Random -Maximum $corruptionChars.Length)]
        } else {
            $disintegratedText += $char
        }
    }
    
    return $disintegratedText
}

# Function to generate random glitch text
function Get-GlitchText {
    param (
        [int]$Length = 10,
        [switch]$UseCorruption
    )
    
    $result = ""
    for ($i = 0; $i -lt $Length; $i++) {
        if ($UseCorruption) {
            $idx = Get-Random -Maximum $corruptionChars.Length
            $result += $corruptionChars[$idx]
        } else {
            $idx = Get-Random -Maximum $glitchChars.Length
            $result += $glitchChars[$idx]
        }
    }
    
    return $result
}

# Clear the screen
Clear-Host

# Get the console dimensions
$width = $host.UI.RawUI.WindowSize.Width
$height = $host.UI.RawUI.WindowSize.Height

# Position (centered horizontally)
$startX = [Math]::Floor(($width - 60) / 2)  # Centered with offset for rose width
$startY = 5  # Fixed position, not at the top

# Phase 1: Display normal flower for 3 seconds
Clear-Host
1..$startY | ForEach-Object { Write-Host "" }
foreach ($line in $rose) {
    # Center each line
    $padding = " " * $startX
    Write-Host "$padding$line" -ForegroundColor White
}
Start-Sleep -Seconds 3

# Phase 2: Glitch for 1 second (10 frames of 100ms each)
for ($i = 0; $i -lt 10; $i++) {
    Clear-Host
    1..$startY | ForEach-Object { Write-Host "" }
    
    # Create corrupted rose with vertical digital artifacts
    $corruptedRose = Add-VerticalCorruption -RoseLines $rose -NumCorruptions (Get-Random -Minimum 3 -Maximum 8) -MaxWidth 4
    
    foreach ($line in $corruptedRose) {
        # Center each line
        $padding = " " * $startX
        Write-Host "$padding$line" -ForegroundColor Red
    }
    
    # Add vertical scan lines
    $numScanLines = Get-Random -Minimum 1 -Maximum 4
    for ($j = 0; $j -lt $numScanLines; $j++) {
        $scanX = Get-Random -Minimum $startX -Maximum ($startX + 60)
        $scanChar = $corruptionChars[(Get-Random -Maximum 3)]
        $scanHeight = Get-Random -Minimum 10 -Maximum ($height - 5)
        
        # Save current cursor position
        $cursorX = $host.UI.RawUI.CursorPosition.X
        $cursorY = $host.UI.RawUI.CursorPosition.Y
        
        # Draw vertical scan line
        for ($k = 0; $k -lt $scanHeight; $k++) {
            $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $scanX, $k
            Write-Host $scanChar -ForegroundColor Red -NoNewline
        }
        
        # Restore cursor position
        $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $cursorX, $cursorY
    }
    
    Start-Sleep -Milliseconds 100
}

# Phase 3: Back to normal flower for a moment
Clear-Host
1..$startY | ForEach-Object { Write-Host "" }
foreach ($line in $rose) {
    # Center each line
    $padding = " " * $startX
    Write-Host "$padding$line" -ForegroundColor White
}
Start-Sleep -Seconds 1

# Phase 4: Disintegration with digital corruption
$maxDisintegrationFrames = 20
for ($frame = 0; $frame -le $maxDisintegrationFrames; $frame++) {
    # Clear the screen
    Clear-Host
    1..$startY | ForEach-Object { Write-Host "" }
    
    # Calculate disintegration and corruption levels (0-100)
    $disintegrationLevel = [Math]::Min(100, ($frame / $maxDisintegrationFrames) * 100)
    $corruptionLevel = [Math]::Min(80, ($frame / $maxDisintegrationFrames) * 80)
    
    # Occasionally add vertical corruptions during disintegration
    $useCorrupted = ($frame % 3 -eq 0) -and ($disintegrationLevel -gt 20)
    if ($useCorrupted) {
        $displayRose = Add-VerticalCorruption -RoseLines $rose -NumCorruptions (1 + [Math]::Floor($frame / 5)) -MaxWidth 3
    } else {
        $displayRose = $rose
    }
    
    # Display the rose with disintegration and corruption effects
    foreach ($line in $displayRose) {
        # Apply disintegration effect
        $processedLine = Get-DisintegratedString -Text $line -DisintegrationLevel $disintegrationLevel -CorruptionLevel $corruptionLevel
        
        # Center each line
        $padding = " " * $startX
        Write-Host "$padding$processedLine" -ForegroundColor White
    }
    
    # Add occasional scan lines during disintegration
    if ($disintegrationLevel -gt 50 -and (Get-Random -Minimum 1 -Maximum 3) -eq 1) {
        $scanX = Get-Random -Minimum $startX -Maximum ($startX + 60)
        $scanChar = $corruptionChars[(Get-Random -Maximum 3)]
        $scanHeight = Get-Random -Minimum 10 -Maximum ($height - 5)
        
        # Save current cursor position
        $cursorX = $host.UI.RawUI.CursorPosition.X
        $cursorY = $host.UI.RawUI.CursorPosition.Y
        
        # Draw scan line
        for ($k = 0; $k -lt $scanHeight; $k++) {
            $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $scanX, $k
            Write-Host $scanChar -ForegroundColor White -NoNewline
        }
        
        # Restore cursor position
        $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $cursorX, $cursorY
    }
    
    # Pause between frames
    Start-Sleep -Milliseconds 100
}
