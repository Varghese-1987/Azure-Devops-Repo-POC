function Get-ScAzureDevopsUriOrganization {
    [cmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName
    )
    return  "https://vssps.dev.azure.com/$($OrganizationName)/"
}

function Get-SCAzureDevopsAuthenticationHeader {
    param (
        [Parameter(Mandatory = $true)]
        $PersonalAccessToken
    )
    $AzureDevOpsAuthenicationHeader = @{
        Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PersonalAccessToken)"))
    }
    return $AzureDevOpsAuthenicationHeader
}

function Get-ScAzureDevOpsProjectDescriptorDetails {
    [cmdletBinding()]
    param(

        [Parameter(Mandatory = $true)]
        $OrganizationName,

        [Parameter(Mandatory = $true)]
        $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string]$ProjectId,

        [Parameter(Mandatory = $false)]
        [string]$ApiVersion = '5.1-preview.1'
    )

    $endPoint = $(Get-ScAzureDevopsUriOrganization -OrganizationName $OrganizationName ) + "_apis/graph/descriptors/$($ProjectId)?api-version=$ApiVersion"


    $restParam = @{
        Uri     = $endPoint
        Headers = $(Get-SCAzureDevopsAuthenticationHeader -PersonalAccessToken $PersonalAccessToken)
        Method  = 'GET'
    }
    Invoke-RestMethod @restParam

}

function Get-ScAzureDevOpsGroupsUnderProject {
    [cmdletBinding()]
    param(

        [Parameter(Mandatory = $true)]
        $OrganizationName,

        [Parameter(Mandatory = $true)]
        $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string]$ProjectDescriptor,

        [Parameter(Mandatory = $false)]
        [string]$ApiVersion = '5.1-preview.1'
    )

    $endPoint = $(Get-ScAzureDevopsUriOrganization -OrganizationName $OrganizationName ) + "_apis/graph/groups?scopeDescriptor=$($ProjectDescriptor)&api-version=$ApiVersion"

    $restParam = @{
        Uri     = $endPoint
        Headers = $(Get-SCAzureDevopsAuthenticationHeader -PersonalAccessToken $PersonalAccessToken)
        Method  = 'GET'
    }

    Invoke-RestMethod @restParam

}

function Add-ScAzureDevopsUserToTeams {
    [cmdletBinding()]
    param(

        [Parameter(Mandatory = $true)]
        $OrganizationName,

        [Parameter(Mandatory = $true)]
        $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string]$GroupDescriptor,

        [Parameter(Mandatory = $true)]
        [string]$EmailAddress,

        [Parameter(Mandatory = $false)]
        [string]$ApiVersion = '5.1-preview.1'
    )

    $endPoint = $(Get-ScAzureDevopsUriOrganization -OrganizationName $OrganizationName ) + "_apis/graph/users?groupDescriptors=$GroupDescriptor&api-version=$ApiVersion"

    $Body = @{
        principalName = $EmailAddress
    }
    $userBody = $Body | ConvertTo-Json

    $restParam = @{
        Uri         = $endPoint
        Headers     = $(Get-SCAzureDevopsAuthenticationHeader -PersonalAccessToken $PersonalAccessToken)
        Method      = 'POST'
        ContentType = 'application/json'
        Body        = $userBody
    }
    Invoke-RestMethod @restParam
}