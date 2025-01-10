rsg="rg-apim"

az group create --name $rsg --location germanywestcentral

az deployment group create --resource-group $rsg --template-file apim/infra.bicep