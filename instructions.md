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
$ base64 -d secret.b64 > secret.txt
```
The content of this file (`secret.txt`) is the backup passphrase seed used to create my bitcoin wallet, what may be used to restore it.
