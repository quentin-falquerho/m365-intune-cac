# m365-intune-cac
Configuration-as-Code (CaC) repository designed for Microsoft Intune, featuring automated compliance policies, endpoint security baselines, and configuration profiles synced seamlessly across tenants via Microsoft Graph API and GitHub Actions.

Required Azure Prerequisites
To run this pipeline successfully, create an App Registration in Microsoft Entra ID with the following Application permissions for Microsoft Graph, and grant Admin Consent:

DeviceManagementConfiguration.ReadWrite.All
DeviceManagementServiceConfig.ReadWrite.All
