#!/bin/sh
HASH=$(git rev-parse HEAD)
sed "s/commitHash.*/commitHash = \"${HASH:0:16}\"/g" version_info.go
# ^ will not work on MacOS use
# sed -i '' "s/commitHash.*/commitHash = \"${HASH:0:16}\"/g" version_info.go
go fmt version_info.go