[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [String] $OrganizationName,
    [Parameter(Mandatory = $true)]
    [String] $ProjectId,
    [Parameter(Mandatory = $true)]
    [String] $PersonalAccessToken,
    [Parameter(Mandatory = $true)]
    [String] $EmailAddress,
    [Parameter(Mandatory = $false)]
    [String] $GroupName = 'Contributors'
)

Import-Module -Name '.\Modules\Sitecore.General.psm1' -Force

$projectDetailsParam = @{
    OrganizationName    = $OrganizationName
    PersonalAccessToken = $PersonalAccessToken
    ProjectId           = $ProjectId
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

Write-Host "User '$EmailAddress' is added to the default Contributors group in the project.." -ForegroundColor 'Green'
