#!/bin/sh
# Builds ../lumia-flash.zip
#   boot.img            -> from this folder
#   venus/widevine/adsp -> copied from a checkout of android_vendor_msft_talkman
#
# Usage: FW_SRC=/path/to/android_vendor_msft_talkman ./build.sh
set -e
cd "$(dirname "$0")"

FW_SRC="${FW_SRC:-../android_vendor_msft_talkman}"
FW_DIR="$FW_SRC/proprietary/vendor/firmware"

[ -f boot.img ]  || { echo "boot.img missing"; exit 1; }
[ -d "$FW_DIR" ] || { echo "firmware dir not found: $FW_DIR (set FW_SRC)"; exit 1; }

# pick only the files that go into /vendor/firmware on the phone
rm -rf vendor_firmware && mkdir vendor_firmware
for pat in 'venus*' 'widevine*' 'adsp*'; do
  n=0
  for f in "$FW_DIR"/$pat; do
    [ -f "$f" ] || continue
    cp "$f" vendor_firmware/; n=$((n+1))
  done
  [ "$n" -gt 0 ] || { echo "no files matching $pat in $FW_DIR"; exit 1; }
  echo "$pat: $n files"
done

rm -f ../lumia-flash.zip
zip -qr9 ../lumia-flash.zip META-INF boot.img vendor_firmware
echo "Created ../lumia-flash.zip ($(ls vendor_firmware | wc -l) firmware files)"
