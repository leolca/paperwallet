#!/bin/bash

cut -d':' -f2 secret | awk '{$1=$1};1' | openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -out secret.enc
base64=$(base64 secret.enc)
base64 -w 0 secret.enc | qrencode -o qrcode.png
pandoc -f markdown <(cat instructions.md <(echo "") <(echo "![](qrcode.png)"; echo) <(echo "\`\`\`bash") <(echo "$base64") <(echo "\`\`\`") walletinfo.md) -o paperwallet_instructions.pdf
pdfunite paperwallet_cover.pdf paperwallet_instructions.pdf paperwallet.pdf
