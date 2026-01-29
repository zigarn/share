#!/bin/sh

extension_id=$1

# flags = 2 (includeFiles) + 512 (includeLatestVersionOnly)
# cf. https://github.com/microsoft/azure-devops-node-api/blob/be525f3b50bee51517def9b2e9c52b9316b328e5/api/interfaces/GalleryInterfaces.ts#L2124-L2145
read -r -d '' extension_query <<JSONQUERY
{
    "assetTypes": null,
    "filters": [
        {
            "criteria": [
                {
                    "filterType": 7,
                    "value": "${extension_id}"
                }
            ],
            "pageSize": 1,
            "pageNumber": 1
        }
    ],
    "flags": 514
}
JSONQUERY
vsix_versions=$(
    curl --silent https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery \
        --header "Accept: application/json;api-version=7.2-preview.1" \
        --header "Content-Type: application/json" \
        --data "${extension_query}" \
    | jq --compact-output '.results[0].extensions[0].versions'
)

vsix_version=$(echo "${vsix_versions}" | jq --compact-output '.[] | select(.targetPlatform == "win32-x64")')
if [ -z ${vsix_version} ]; then
    echo "No specific package for platform win32-x64, use first one"
    vsix_version=$(echo "${vsix_versions}" | jq --compact-output '.[0]')
else
   echo "Use specific package for platform win32-x64"
fi

vsix_url=$(echo "${vsix_version}" | jq --raw-output '.files[] | select(.assetType == "Microsoft.VisualStudio.Services.VSIXPackage") | .source')

echo "Download ${vsix_url}"
curl --output ${extension_id}.vsix "${vsix_url}"
