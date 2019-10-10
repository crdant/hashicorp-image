#!/usr/bin/env bash

# Download the terraform binary and signature files.
function download() {
  product=$1
  version=$2
  
  pushd work 2>&1 1> /dev/null
    curl -Os https://releases.hashicorp.com/${product}/${version}/${product}_${version}_linux_amd64.zip
    curl -Os https://releases.hashicorp.com/${product}/${version}/${product}_${version}_SHA256SUMS
    curl -Os https://releases.hashicorp.com/${product}/${version}/${product}_${version}_SHA256SUMS.sig

    # Verify the signature file is untampered.
    keybase pgp verify -S hashicorp -d ${product}_${version}_SHA256SUMS.sig -i ${product}_${version}_SHA256SUMS

    # trust the binary if the checksum matches
    if shasum -a 256 -c ${product}_${version}_SHA256SUMS 2>/dev/null | grep "OK" ; then
      unzip ${product}_${version}_linux_amd64.zip && mv ${product} ../bin
    fi
  popd 2>&1 1>/dev/null
}

download terraform 0.12.10
download vault 0.5.2
