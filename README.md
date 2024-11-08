# paperwallet

Create a AES encrypted bitcoin paper wallet from your seed phrase. If necessary, edit the `instructions.md` file to add additional instructions.

Edit `secret` file and input your backup seed phrase, then run the `paperwallet.sh` script:

```bash
$ ./paperwallet.sh
```

To retrieve the backup seed open the PDF file to copy (screenshot) the QR code or use the webcam to capture the QR code on paper. 

For using a screenshot of the PDF file, do:

```bash
$ ./qrcode_decode.sh clipboard
```

For use the backup paper and your webcam, do:
```bash
$ ./qrcode_decode.sh webcam
```
