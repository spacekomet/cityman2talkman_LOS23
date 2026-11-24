# cityman2talkman_LOS23

A flashable zip that makes LineageOS 23 (built for the Lumia 950 XL) run better on the **Lumia 950 (talkman)**.

> Experimental.

## What it does

- Installs a new kernel (boot image) for the Lumia 950.  Based on lineage-23.2-20261122-UNOFFICIAL-cityman from [giannoccarol] to make RIL working together with wifi. 
- Replaces Lumia950XL venus, widevine and adsp firmware files in /vendor/firmware with Lumia950's, to enable audio and HW video acceleration. 
- Removes Lumia950XL modem files in /system/etc/firmware, forcing system to select them from phone modem parition mounted to /firmware, to enable GPS and RIL. 
- Changes the model name from "Lumia 950 XL" to "Lumia 950".
- Only supports Lumia 950.

## How to install

1. Download the newest zip from the [Releases](../../releases) page.
2. Copy it to your phone.
3. Boot into TWRP, make an optional backup of boot, system and vendor.
4. Tap **Install**, choose the zip, then reboot.

In case LineageOS 23 was already booted beforehand, rename the device in Settings > About phone > Device name (it keeps the old name until you change it).

## Credits

- [giannoccarol](https://github.com/giannoccarol) – the Lumia 950 XL LineageOS port (kernel and device tree) this is based on.
- **The Android4Lumia950 project** https://github.com/Android4Lumia950 – the talkman (Lumia 950) device tree and earlier
  LineageOS work that the talkman firmware and hardware details were checked against.



