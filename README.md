Device Tree For Samsung Galaxy Core Prime VE LTE
=================================================

Basic   | Spec Sheet
-------:|:-------------------------
CPU     | Quad-core 1.2 GHz Cortex-A53
CHIPSET | PXA1908
GPU     | Vivante GC7000UL
Memory  | 1GB RAM
Shipped Android Version | 5.1
Storage | 8GB
MicroSD | Up to 64GB
Battery | 2600 mAh
Display | 4.5"

LineageOS 16.0 (Android 9) for the SM-G361F (`coreprimevelte`), ported from the `lineage-14.1`
branch. The 3.14 kernel carries backports for Pie: android-3.18 binder, ambient capabilities,
FunctionFS for adb, getrandom(2) and mmap_rnd_bits.

## Building
Local manifest, `.repo/local_manifests/coreprimevelte.xml`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <remote name="port" fetch="https://github.com/Lilobast" revision="lineage-16.0" />
  <remote name="pxa" fetch="https://github.com/pxa1908-devices" revision="lineage-14.1" />

  <project path="device/samsung/coreprimevelte" name="android_device_samsung_coreprimevelte" remote="port" />
  <project path="device/samsung/pxa1908-common" name="android_device_samsung_pxa1908-common" remote="port" />
  <project path="device/samsung/mrvl-common" name="android_device_samsung_mrvl-common" remote="port" />
  <project path="device/marvell/sepolicy" name="android_device_marvell_sepolicy" remote="pxa" />
  <project path="kernel/samsung/coreprimevelte" name="android_kernel_samsung_coreprimevelte" remote="port" clone-depth="1" />
  <project path="vendor/samsung/coreprimevelte" name="android_vendor_samsung_coreprimevelte" remote="port" clone-depth="1" />

  <project path="hardware/marvell/audio" name="android_hardware_marvell_audio" remote="port" />
  <project path="hardware/marvell/bootimage" name="android_hardware_marvell_bootimage" remote="port" />
  <project path="hardware/marvell/display" name="android_hardware_marvell_display" remote="port" />
  <project path="hardware/marvell/fm" name="android_hardware_marvell_fm" remote="port" />
  <project path="hardware/marvell/gps" name="android_hardware_marvell_gps" remote="port" />
  <project path="hardware/marvell/keymaster" name="android_hardware_marvell_keymaster" remote="port" />
  <project path="hardware/marvell/libMarvellWireless" name="android_hardware_marvell_libMarvellWireless" remote="port" />
  <project path="hardware/marvell/MarvellWirelessDaemon" name="android_hardware_marvell_MarvellWirelessDaemon" remote="port" />
  <project path="hardware/marvell/libmvmem" name="android_hardware_marvell_libmvmem" remote="port" />
  <project path="hardware/marvell/libprebuilt" name="android_hardware_marvell_libprebuilt" remote="port" />
  <project path="hardware/marvell/media" name="android_hardware_marvell_media" remote="port" />
  <project path="hardware/marvell/pxa1908" name="android_hardware_marvell_pxa1908" remote="pxa" />
  <project path="hardware/marvell/vendor-libs" name="android_hardware_marvell_vendor-libs" remote="port" />
  <project path="hardware/marvell/wlan" name="android_hardware_marvell_wlan" remote="port" />

  <project path="hardware/samsung" name="LineageOS/android_hardware_samsung" remote="github" revision="lineage-16.0" clone-depth="1" />
</manifest>
```
Then:
```
repo init -u https://github.com/LineageOS/android.git -b lineage-16.0
repo sync -c -j8
device/samsung/coreprimevelte/coreprimevelte_patchs/apply.sh
source build/envsetup.sh && lunch lineage_coreprimevelte-userdebug && mka bacon
```
`coreprimevelte_patchs/<project>/*.patch` are 36 commits on 13 LineageOS projects (art, bionic,
frameworks/av, base, native, hardware/interfaces, hardware/marvell/bt, hardware/ril, FMRadio,
Settings, system/core, system/nfc, vendor/lineage). `apply.sh` applies them with `git am` and
checks the result against the trees of the release (`release-trees.txt`); re-running is safe.

The update-binary of a Pie zip cannot read TWRP 3.0.2's property format, so its
`getprop("ro.product.device")` assert fails there. Flash with a newer TWRP, or remove that assert
line from `META-INF/com/google/android/updater-script`.

## Status (2026-11-17 build)
Works: GPU UI with HWC composition, 720p/1080p hardware video, audio, both cameras, Wi-Fi,
Bluetooth, NFC, sensors, GPS engine, MTP, modem (baseband, IMEI, SIM state), offline charging,
zram swap, LiveDisplay, secure adb, SELinux enforcing (the Marvell modem/GPS/wireless daemons are
permissive domains). Not tested: calls, SMS and mobile data (no SIM was available), GPS outdoors,
FM with a headset, NFC tags, deep-sleep drain. Widevine is not included (the stock L3 blobs don't
load on Pie). The Skia GL HWUI pipeline is broken on this GPU: `debug.hwui.renderer=opengl`.

## Credits
notnoelchannel and Nemirtingas for the original pxa1908 / coreprimevelte trees
([pxa1908-devices](https://github.com/pxa1908-devices)), and the LineageOS project.
