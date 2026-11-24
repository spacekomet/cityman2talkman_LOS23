# cityman2talkman_LOS23

TWRP flashable zip for the **Lumia 950 (talkman, MSM8992)** running the LineageOS 23
build made from the cityman (Lumia 950 XL) device tree. One flash installs a new kernel
and swaps the firmware the talkman needs.

> Experimental. Make a Nandroid backup of **boot, system and vendor** in TWRP before flashing.

## What the zip does

The flashing logic is in
[`META-INF/com/google/android/update-binary`](META-INF/com/google/android/update-binary).
In order:

1. **Device check** – the zip refuses to install on anything but a Lumia 950:
   - the Lumia `DPP` partition must exist (TWRP may report the device as `talkman`,
     `angler` or `bullhead`, so the name alone is not trusted),
   - a device name containing `cityman`, or SoC id `207` / `253` (MSM8994, Lumia 950 XL),
     aborts the install,
   - the reported name must be `talkman`, `angler` or `bullhead`.
2. **Extract** the zip to `/tmp` and make sure `boot.img` and `vendor_firmware/` are present.
3. **Mount** `/system` (also system-as-root layouts) and `/vendor`, and remount them read-write.
4. **Flash `boot.img`** to the boot partition (`by-name/boot`, with the A/B slot suffix if there is one)
   with `dd`, then read it back and compare. Any mismatch aborts.
5. **Delete old modem files**
   - `mba*` and `modem*` in `/system/etc/firmware`
   - `mba*` in `/vendor/firmware`
6. **Copy firmware into `/vendor/firmware`** – every file in the zip's `vendor_firmware/`
   (`venus*`, `widevine*`, `adsp*`) replaces the file with the same name. Each file gets
   mode 644, owner root and the `vendor_file` SELinux label, and is compared after copying.
7. **Set the model name** – in the `build.prop` files of system, vendor, odm, product and
   system_ext, `Lumia 950 XL` becomes `Lumia 950` on `ro.product.*` lines only
   (shows in Settings > About phone > Model).
8. **Clean up**, unmount, then reboot.

The deletions run before the copies. The script stops at the first error and prints it in the
TWRP log. A successful install log shows `Device OK`, `boot.img OK` and the list of copied files.

## Installing

1. Download the newest `lumia950-flash-<commit>.zip` from the
   [Releases](../../releases) page (or from the artifact of a workflow run, which you
   must unzip once).
2. Copy it to the phone.
3. In TWRP: back up boot, system and vendor, then **Install** the zip and reboot.
4. After the first boot:
   - **Model** in Settings > About phone should show `Lumia 950`.
   - **Device name** is stored in the settings database on first boot, so rename it once by hand.
   - Check that the modem still comes up, because the zip removes the `mba*` / `modem*` files.

## How the zip is built

Built by GitHub Actions ([`.github/workflows/build-zip.yml`](.github/workflows/build-zip.yml)).

| Content | Source |
|---|---|
| `boot.img` | `base/boot.img` (the working image: ramdisk, command line, header) with only its kernel replaced by `Image.gz-dtb` from the latest release of [`spacekomet/android_kernel_mmo_msm8994`](https://github.com/spacekomet/android_kernel_mmo_msm8994/releases) (`abootimg`; the build checks the SHA256 and that the image size is unchanged) |
| `vendor_firmware/` | `venus*`, `widevine*` and `adsp*` from `proprietary/vendor/firmware` of [`spacekomet/android_vendor_msft_talkman`](https://github.com/spacekomet/android_vendor_msft_talkman), pinned to a commit in the workflow |

The workflow runs on a push to `main`, on a tag `v*`, or by hand
(Actions > Build TWRP zip > Run workflow) with optional inputs `vendor_ref` and `kernel_tag`
(empty = latest kernel release).

### Making a release

```
git tag v1
git push origin v1
```

A tag run publishes the zip and its `.sha256` under Releases. Use a new tag name each time.

### Building locally

```
git clone https://github.com/spacekomet/android_vendor_msft_talkman ../android_vendor_msft_talkman
cp <your boot.img> boot.img
FW_SRC=../android_vendor_msft_talkman sh ./build.sh      # creates ../lumia-flash.zip
```

## Repository layout

```
META-INF/com/google/android/update-binary   the installer (see above)
META-INF/com/google/android/updater-script  placeholder
base/boot.img                               base image, only its kernel is replaced in CI
build.sh                                    collects the firmware and zips everything
.github/workflows/build-zip.yml             CI
```

Keep `update-binary` with Unix (LF) line endings (see `.gitattributes`).


## Credits

This zip only packages other people's work. Thanks to:

- **Lorenzo Giannoccaro ([giannoccarol](https://github.com/giannoccarol))** – the Lumia 950 XL
  (cityman) LineageOS port this build is based on: the
  [kernel](https://github.com/giannoccarol/android_kernel_mmo_msm8994) and the
  [device tree](https://github.com/giannoccarol/android_device_msft_cityman).
- **The Android4Lumia950 project** – the talkman (Lumia 950) device tree and earlier
  LineageOS work that the talkman firmware and hardware details were checked against.

