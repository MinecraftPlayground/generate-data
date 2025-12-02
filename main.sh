#!/bin/sh

if [ "$INPUT_VERSION" == "latest-snapshot" ]; then
  echo "Fetching the latest snapshot version."
  latest_version=$(curl -L $INPUT_MANIFEST_API_URL | jq -r '.latest.snapshot')

  if [ -z "$latest_version" ]; then
    echo "Error: Could not find the latest snapshot version in the manifest."
    exit 1
  fi

  echo "Using latest snapshot version: $latest_version"
  INPUT_VERSION="$latest_version"

elif [ "$INPUT_VERSION" == "latest-release" ]; then
  echo "Fetching the latest release version."
  latest_version=$(curl -L $INPUT_MANIFEST_API_URL | jq -r '.latest.release')

  if [ -z "$latest_version" ]; then
    echo "Error: Could not find the latest release version in the manifest."
    exit 1
  fi

  echo "Using latest release version: $latest_version"
  INPUT_VERSION="$latest_version"

else
  echo "Using specified version: $INPUT_VERSION"
fi

echo "Make temp download directory."
TEMP_DOWNLOAD_DIR=$(mktemp -d)

echo "Fetch package URL from \"$INPUT_MANIFEST_API_URL\"."
package_url=$(curl -L $INPUT_MANIFEST_API_URL | jq -r ".versions[] | select(.id == \"$INPUT_VERSION\") | .url")

echo "Fetch client.jar URL from \"$package_url\"."
jar_url=$(curl -L $package_url | jq -r ".downloads.client.url")

echo "Fetching client.jar SHA1 hash from \"$package_url\"."
client_jar_sha1=$(curl -L $package_url | jq -r ".downloads.client.sha1")

echo "Downloading client.jar from \"$jar_url\"."
curl -L -o $TEMP_DOWNLOAD_DIR/client.jar $jar_url

echo "Verifying SHA1 hash of client.jar."
downloaded_sha1=$(sha1sum "$TEMP_DOWNLOAD_DIR/client.jar" | awk '{print $1}')

if [ "$downloaded_sha1" != "$client_jar_sha1" ]; then
  echo "Error: SHA1 hash does not match. Expected $client_jar_sha1, but got $downloaded_sha1."
  exit 1
else
  echo "SHA1 hash verification passed for client.jar."
fi

echo "Saved \"client.jar\" to \"$TEMP_DOWNLOAD_DIR\"."

echo "::group:: Extract assets from client.jar"
unzip "$TEMP_DOWNLOAD_DIR/client.jar" -d client \
    -x "*.class" \
    "assets/*" \
    "com/*" \
    "META-INF/*" \
    "net/*"
echo "::endgroup::"

echo "All files downloaded and processed."

exit 0
