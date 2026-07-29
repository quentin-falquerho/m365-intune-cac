[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$TenantId,

    [Parameter(Mandatory=$true)]
    [string]$ClientId,

    [Parameter(Mandatory=$true)]
    [string]$ClientSecret
)

# 1. Authenticate to Microsoft Graph
$body = @{
    grant_type    = "client_credentials"
    scope         = "https://graph.microsoft.com/.default"
    client_id     = $ClientId
    client_secret = $ClientSecret
}

$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" -Method Post -Body $body
$headers = @{
    "Authorization" = "Bearer $($tokenResponse.access_token)"
    "Content-Type"  = "application/json"
}

# 2. Deploy Compliance Policies
$complianceFiles = Get-ChildItem -Path "./configs/compliance" -Filter "*.json"
foreach ($file in $complianceFiles) {
    $policyJson = Get-Content -Path $file.FullName -Raw
    $uri = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies"
    
    Write-Host "Deploying compliance policy: $($file.Name)"
    try {
        Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -Body $policyJson
        Write-Host "Successfully deployed $($file.Name)" -ForegroundColor Green
    } catch {
        Write-Error "Failed to deploy $($file.Name): $_"
    }
}

# 3. Deploy Configuration Profiles
$configFiles = Get-ChildItem -Path "./configs/configurations" -Filter "*.json"
foreach ($file in $configFiles) {
    $configJson = Get-Content -Path $file.FullName -Raw
    $uri = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"
    
    Write-Host "Deploying configuration profile: $($file.Name)"
    try {
        Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -Body $configJson
        Write-Host "Successfully deployed $($file.Name)" -ForegroundColor Green
    } catch {
        Write-Error "Failed to deploy $($file.Name): $_"
    }
}
