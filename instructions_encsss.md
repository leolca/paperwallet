---
title: Bitcoin shared paper wallet
geometry: "a4paper, left=1cm, right=1cm, top=1cm, bottom=2cm"
fontsize: 10pt
header-includes:
  - \usepackage{titling}
  - \setlength{\droptitle}{-5em}
---

\vspace{-20truemm}

## Shamir's Secret Sharing

The secret seed was encoded by Shamir's Secret Sharing method requering #K# out of #N# secret parts to recover the seed.
Each paper wallet has an encrypted partial information to reconstruct the secret seed. You will have create a text file holding those
partial information, one in each line.

## File Decryption Instructions

First you have to decrypt each partial information required in the Shamir's Secret Sharing method.

Read each QR code and save its content to a file named `secret.b64`.

Alternatively, the content is also written as text in the base64 format. Type it into a text file (`secret.b64`).
Convert the base64 file into the binary file (`secret.enc`) using:
```bash
$ base64 -d secret.b64 > secret.enc
```

This file (`secret.enc`) was encrypted using OpenSSL with AES-256 in CBC mode, PBKDF2 for key derivation, and SHA-512 as the hashing algorithm. 
Its contents has the partial information used in Shamir's Secret Sharing method.

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

### Joining the partial information

For each partial encrypted paper wallet you will retrieve a different `secret.txt` text file, as described above.
Now you have to create a single file holding the content of each of these files in a different line.
The final file content will be similar to the example below:

```txt
1-001f6193f82f2c32e5f06c4aa7cb6879f3cd40563be07e2324d8298baa122a8edb014b12a
2-4f56f02960363ebcff9d65bf6f9e03f3c9ff1c41f5eeac6d25dfe34b3ecdce437b56b2bb7
3-2ccb9f92131c1ba14ebda5aaeddf98ef16054ffff7339664873bff3a19cfee76e71a86b3b
```
Now you just have to retrieve the secret by using:
```bash
$ cat secret.enc | ssss-combine -t #K#
```

