param (
        [Parameter(Mandatory=$true)][string]$CommaSeparatedListofWorkspaces
)
# https://www.mssqltips.com/sqlservertip/5427/parsing-strings-from-delimiters-in-powershell/
$FileName = "workspace.txt"
if (Test-Path $FileName) {
  Remove-Item $FileName
}
# Create a list of existing workspaces
terraform workspace list >>workspace.txt
foreach ($WorkspaceName in $CommaSeparatedListofWorkspaces.Split(","))
{
    Write-Output "`n"
    $WorkspaceExists = "false"
# https://stackoverflow.com/questions/57174764/powershell-match-exact-string-from-list-of-lines
$WorkspaceName = $WorkspaceName.Trim()
# $TextPatternToSearch = $WorkspaceName
$file = Get-Content .\workspace.txt
$containsWord =$file | %{$_ -match $WorkspaceName}
    If (($containsWord -contains "true"))
    {
        $WorkspaceExists = "true"
        # Write-Host "##vso[task.setvariable variable=CheckWorkspace;isOutput=true]exists"
    } else {
        
        # Write-Host "##vso[task.setvariable variable=CheckWorkspace;isOutput=true]doesnotexist"
    }
    if ($WorkspaceExists -eq "false")
    {
        Write-Output "Workspace $WorkspaceName does not exist and will be created.`n"
        terraform workspace new $WorkspaceName  -no-color
    }
    if ($WorkspaceExists -eq "true")
    {
        Write-Output "Workspace $WorkspaceName exists.`n"
        terraform workspace select $WorkspaceName  -no-color
    }
    # Run terraform validate on the selected workspace
    terraform validate -json -no-color
    Write-Output "-----------------------------------"
}