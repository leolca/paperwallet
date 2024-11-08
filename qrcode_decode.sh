#!/bin/bash

# Function to decode QR code from clipboard
decode_from_clipboard() {
  # Save clipboard image to a temporary file
  TEMP_IMAGE="/tmp/clipboard_image.png"
  xclip -selection clipboard -t image/png -o > "$TEMP_IMAGE"
  
  # Decode QR code using zbarimg
  zbarimg "$TEMP_IMAGE" --raw > secret.b64
  
  # Clean up temporary image
  #rm "$TEMP_IMAGE"
}

# Function to decode QR code from webcam
decode_from_webcam() {
  # Capture an image from the webcam (requires fswebcam)
  TEMP_IMAGE="/tmp/webcam_image.png"
  fswebcam --png 1 --save "$TEMP_IMAGE"
  
  # Decode QR code using zbarimg
  zbarimg "$TEMP_IMAGE" --raw > secret.b64
  
  # Clean up temporary image
  #rm "$TEMP_IMAGE"
}

# Check for argument to decide whether to use clipboard or webcam
if [[ "$1" == "clipboard" ]]; then
  decode_from_clipboard
elif [[ "$1" == "webcam" ]]; then
  decode_from_webcam
else
  echo "Usage: $0 [clipboard|webcam]"
  exit -1
fi

base64 -d secret.b64 > secret.enc
openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -in secret.enc -out secret.txt
cat secret.txt
