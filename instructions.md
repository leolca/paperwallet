---
title: Bitcoin paper wallet
geometry: "a4paper, left=1cm, right=1cm, top=1cm, bottom=2cm"
fontsize: 10pt
header-includes:
  - \usepackage{titling}
  - \setlength{\droptitle}{-5em}
---

\vspace{-20truemm}

## File Decryption Instructions

Read the QR code and save its content to a file named `secret.b64`.

Alternatively, the content is also written as text in the base64 format. Type it into a text file (`secret.b64`).
Convert the base64 file into the binary file (`secret.enc`) using:
```bash
$ base64 -d secret.b64 > secret.enc
```

This file (`secret.enc`) was encrypted using OpenSSL with AES-256 in CBC mode, PBKDF2 for key derivation, and SHA-512 as the hashing algorithm. 
Its contents has the backup passphrase seed used to create my bitcoin wallet, what may be used to restore it.

Encryption Command used:
```bash
$ openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -in secret.txt -out secret.enc
```

To decrypt this file, follow these steps:

- Ensure you have OpenSSL installed: 
  You'll need OpenSSL to decrypt this file. Most Linux distributions come with it pre-installed. For macOS or Windows, you may need to download it from https://www.openssl.org/.

- Decryption Command:
  Run the following command, replacing secret.enc with the path to your encrypted file:
  ```bash
  $ openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -in secret.enc -out secret.txt
  ```
- Enter the Passphrase: 
  You'll be prompted to enter the passphrase used during encryption. Make sure to enter it exactly as set when the file was encrypted.

- Password hint: 
  If necessary, place the password hint here for your Family. Example: 
  "First pet name + Year we moved to our first house + Favorite shared family vacation spot + First word spoken by our firstborn + Color of the first car + Favorite desert."
