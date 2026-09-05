$Source = Join-Path $PSScriptRoot "home"
$Destination = $HOME

# 2. Display info
Write-Host "Source: $Source"
Write-Host "Target: $Destination"
Write-Host "Warning: Do you want to configure your Home Directory?`nThis will overwrite your Home Directory." -ForegroundColor Yellow

# 3. Prompt for choice
$Title   = "Confirm Copy"
$Message = "Do you want to proceed?"
$Choices = @(
    New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Proceed"
    New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Cancel"
)
$Decision = $Host.UI.PromptForChoice($Title, $Message, $Choices, 1)

# 4. Execute
if ($Decision -eq 0) {
    Write-Host "`nStarting copy..." -ForegroundColor Green
    robocopy $Source $Destination /E /IS /IT
} else {
    Write-Host "`nCancelled." -ForegroundColor Red
}