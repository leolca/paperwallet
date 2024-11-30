#!/bin/bash

# Default behavior
use_shamir=false
encrypt=true

# Function to handle Shamir's Secret Sharing
create_shamir_shares() {
    echo "Creating Shamir's Secret Shares..."
    read -p "Enter the threshold (number of shares required to reconstruct): " threshold
    read -p "Enter the number of shares to generate: " shares
    if (( threshold >= shares )); then
	echo "Error: Threshold ($threshold) must be less than shares ($shares)."
        exit 1
    fi

    # Call ssss-split to generate the shares
    shares_output=$(cut -d':' -f2 secret | awk '{$1=$1};1' | ssss-split -t "$threshold" -n "$shares" -q)

    # Capture the shares into an array
    IFS=$'\n' read -d '' -r -a share_array <<< "$shares_output"

    # Generate a QR code for each share
    for i in "${!share_array[@]}"; do
	echo "Creating paper wallet $((i+1))..."
	if $encrypt; then
	    echo "${share_array[$i]}" | openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -out "secret_$((i+1)).enc"
	    secret=$(base64 "secret_$((i+1)).enc")
	    base64 -w 0 "secret_$((i+1)).enc" | qrencode -o "qrcode_$((i+1)).png"
	    pandoc -f markdown <(cat instructions_encsss.md <(echo "") <(echo "![](qrcode_$((i+1)).png)"; echo) <(echo "\`\`\`bash") <(echo "$secret") <(echo "\`\`\`") walletinfo.md | sed "s/#K#/$threshold/g" | sed "s/#N#/$shares/g") -o "paperwallet_instructions_$((i+1)).pdf"
	    pdfunite paperwallet_cover.pdf "paperwallet_instructions_$((i+1)).pdf" "paperwallet_$((i+1)).pdf"
	else
	    echo "${share_array[$i]}" > "secret_$((i+1)).enc"
	    secret="${share_array[$i]}"
	    cat "secret_$((i+1)).enc" | qrencode -o "qrcode_$((i+1)).png"
	    pandoc -f markdown <(cat instructions_sss.md <(echo "") <(echo "![](qrcode_$((i+1)).png)"; echo) <(echo "\`\`\`bash") <(echo "$secret" | fold -w 80) <(echo "\`\`\`") walletinfo.md | sed "s/#K#/$threshold/g" | sed "s/#N#/$shares/g") -o "paperwallet_instructions_$((i+1)).pdf"
	    pdfunite paperwallet_cover.pdf "paperwallet_instructions_$((i+1)).pdf" "paperwallet_$((i+1)).pdf"
	fi
	echo "Partial wallet $((i+1)) saved to file paperwallet_$((i+1)).pdf"
	rm "paperwallet_instructions_$((i+1)).pdf" "qrcode_$((i+1)).png" "secret_$((i+1)).enc" 
    done
    # echo "your-secret-key-value" | ssss-split -t 3 -n 5
    echo "Shamir's Secret Shares created."
}

# Function for default behavior
create_default_wallet() {
    echo "Creating default paper wallet..."
    if $encrypt; then
	cut -d':' -f2 secret | awk '{$1=$1};1' | openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -out secret.enc
	base64=$(base64 secret.enc)
	base64 -w 0 secret.enc | qrencode -o qrcode.png
        pandoc -f markdown <(cat instructions_encrypted.md <(echo "") <(echo "![](qrcode.png)"; echo) <(echo "\`\`\`bash") <(echo "$base64") <(echo "\`\`\`") walletinfo.md) -o paperwallet_instructions.pdf
        pdfunite paperwallet_cover.pdf paperwallet_instructions.pdf paperwallet.pdf
    else
	cut -d':' -f2 secret > secret.enc
	base64=$(base64 secret.enc)
	base64 -w 0 secret.enc | qrencode -o qrcode.png
        pandoc -f markdown <(cat instructions.md <(echo "") <(echo "![](qrcode.png)"; echo) <(echo "\`\`\`bash") <(echo "$base64") <(echo "\`\`\`") walletinfo.md) -o paperwallet_instructions.pdf
        pdfunite paperwallet_cover.pdf paperwallet_instructions.pdf paperwallet.pdf
    fi
    rm paperwallet_instructions.pdf secret.enc qrcode.png
    echo "Paper wallet created and save to file paperwallet.pdf."
    }

# Function to print the usage message
usage() {
    echo "Usage: $0 [-s|--shamir] [--noencryption]"
    echo
    echo "Options:"
    echo "  -s, --shamir       Use Shamir's Secret Sharing method"
    echo "  -n, --noencryption Disable encryption (default is enabled)"
    echo "  --help             Display this help message"
    exit 1
}

# Parse options
while getopts "s-:n-:" opt; do
    case "$opt" in
        s)
            use_shamir=true
            ;;
        n)
            encrypt=false  # User passed --noencryption
            ;;
        -)
            case "${OPTARG}" in
                shamir)
                    use_shamir=true
                    ;;
                noencryption)
                    encrypt=false
                    ;;
                help)
                    usage
                    ;;
                *)
                    echo "Unknown option: --${OPTARG}" >&2
                    usage
                    ;;
            esac
            ;;
        *)
            usage
            ;;
    esac
done

# Main script logic
if $use_shamir; then
    create_shamir_shares
else
    create_default_wallet
fi


