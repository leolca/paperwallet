# paperwallet

This project aims to create a secure paper wallet by encrypting a cryptocurrency backup seed with AES. The seed can be accessed using a passphrase you define, either one your family could uncover or a private passphrase known only to you--allowing you to recover the seed with just the paper wallet and your memory. This ensures the seed is never stored in plain text, making it a secure legacy.


# Requirements

To run the scripts, you'll need the following packages installed on your Linux system:

- `openssl`
- `coreutils`
- `qrencode`
- `pandoc`
- `poppler-utils`
- `xclip`
- `zbar-tools`
- `fswebcam`
- `ssss`
  
### Installing Dependencies

You can install all required packages by running the following command (on Debian-based systems like Ubuntu):

```bash
sudo apt update
sudo apt install -y openssl coreutils qrencode pandoc poppler-utils xclip zbar-tools fswebcam ssss
```

## Types of paper wallet

The `paperwallet.sh` script implements the creation of 4 different types paper wallets:

### Seed plain text encoded in base64 {#plaintextwallet}
### AES encrypted seed encoded in base64 {#aeswallet}
### Seed split in parts using Shamir's secret sharing scheme {#ssswallet}
### Seed split in parts using Shamir's secret sharing scheme and also using AES encryption with a different key for each part {#sssaeswallet}


## Usage

Create a AES encrypted bitcoin paper wallet from your seed phrase. If necessary, edit the `instructions` markdown file to add additional instructions. 

- `instructions.md` for the [plain text wallet](#plaintextwallet);
- `instructions_encrypted.md` for the [AES wallet](#aeswallet);
- `instructions_sss.md` for the [Shamir's wallet](#ssswallet);
- `instructions_encsss.md` for the [Shamir's AES wallet](#sssaeswallet).

Also edit `walletinfo.md` to add your wallet info.

Edit `secret` file and input your backup seed phrase, then run the `paperwallet.sh` script:

```bash
$ ./paperwallet.sh -n    # plain text wallet
$ ./paperwallet.sh       # AES encrypted wallet (default)
$ ./paperwallet.sh -s -n # Shamir's wallet
$ ./paperwallet.sh -s    # Shamir's AES wallet
```

![PDF of the paperwallet created](paperwallet.png)

To retrieve the backup seed open the PDF file to copy (screenshot) the QR code or use the webcam to capture the QR code on paper. 

For using a screenshot of the PDF file, do:

```bash
$ ./qrcode_decode.sh clipboard
```

For use the backup paper and your webcam, do:
```bash
$ ./qrcode_decode.sh webcam
```
The PDF contains the instructions to retrieve the seed.
