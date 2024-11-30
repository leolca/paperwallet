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

The secret seed was encoded by Shamir's Secret Sharing method requiring #K# out of #N# secret parts to recover the seed.
Each paper wallet has a partial information to reconstruct the secret seed. You will have create a text file holding those
partial information, one in each line.

## File Decryption Instructions

Read the each QR code (or type the text below it) and save its content to a file named `secret.enc`.
Here is an example of such file content:

```txt
1-001f6193f82f2c32e5f06c4aa7cb6879f3cd40563be07e2324d8298baa122a8edb014b12a
2-4f56f02960363ebcff9d65bf6f9e03f3c9ff1c41f5eeac6d25dfe34b3ecdce437b56b2bb7
3-2ccb9f92131c1ba14ebda5aaeddf98ef16054ffff7339664873bff3a19cfee76e71a86b3b
```

Now you just have to retrieve the secret by using:
```bash
$ cat secret.enc | ssss-combine -t #K#
```

