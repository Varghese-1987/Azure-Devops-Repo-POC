[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [String] $OrganizationName,
    [Parameter(Mandatory = $true)]
    [String] $ProjectName,
    [Parameter(Mandatory = $true)]
    [String] $PersonalAccessToken,
    [Parameter(Mandatory = $true)]
    [String] $EmailAddress,
    [Parameter(Mandatory = $false)]
    [String] $GroupName = 'Contributors'
)

Import-Module -Name '.\Modules\Sitecore.General.psm1' -Force

$projectParams = @{
    OrganizationName    = $OrganizationName
    PersonalAccessToken = $PersonalAccessToken
    ProjectName         = $ProjectName
}
$projectId = ((Get-ScAzureDevOpsProject @projectParams).value |
    Where-Object { $_.Name -eq $ProjectName }).id

$projectDetailsParam = @{
    OrganizationName    = $OrganizationName
    PersonalAccessToken = $PersonalAccessToken
    ProjectId           = $projectId
}
$projectDescriptor = (Get-ScAzureDevOpsProjectDescriptorDetails @projectDetailsParam).value

$groupParams = @{
    OrganizationName    = $OrganizationName
    PersonalAccessToken = $PersonalAccessToken
    ProjectDescriptor   = $projectDescriptor
}

$contributorProject = (Get-ScAzureDevOpsGroupsUnderProject @groupParams).value |
Where-Object { $_.displayName -eq $GroupName }

$addUserParams = @{
    OrganizationName    = $OrganizationName
    PersonalAccessToken = $PersonalAccessToken
    GroupDescriptor     = $contributorProject.descriptor
    EmailAddress        = $EmailAddress
}
Add-ScAzureDevopsUserToTeams @addUserParams

Write-Host "User '$EmailAddress' is added to the default 'Contributors' group in the project '$ProjectName'.." -ForegroundColor 'Green'
