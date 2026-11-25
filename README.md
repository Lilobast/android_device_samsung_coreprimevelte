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

LineageOS 14.1 (Android 7.1) for the SM-G361F (`coreprimevelte`). A LineageOS 16.0 port is on the
`lineage-16.0` branch.

## Building
Local manifest, `.repo/local_manifests/coreprimevelte.xml`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <remote name="port" fetch="https://github.com/Lilobast" revision="lineage-14.1" />
  <remote name="pxa" fetch="https://github.com/pxa1908-devices" revision="lineage-14.1" />

  <project path="device/samsung/coreprimevelte" name="android_device_samsung_coreprimevelte" remote="port" />
  <project path="device/samsung/pxa1908-common" name="android_device_samsung_pxa1908-common" remote="port" />
  <project path="device/samsung/mrvl-common" name="android_device_samsung_mrvl-common" remote="pxa" />
  <project path="device/marvell/sepolicy" name="android_device_marvell_sepolicy" remote="pxa" />
  <project path="kernel/samsung/coreprimevelte" name="android_kernel_samsung_coreprimevelte" remote="port" clone-depth="1" />
  <project path="vendor/samsung/coreprimevelte" name="android_vendor_samsung_coreprimevelte" remote="port" clone-depth="1" />

  <remove-project name="LineageOS/android_hardware_marvell_wlan" />
  <project path="hardware/marvell/audio" name="android_hardware_marvell_audio" remote="port" />
  <project path="hardware/marvell/bootimage" name="android_hardware_marvell_bootimage" remote="pxa" />
  <project path="hardware/marvell/display" name="android_hardware_marvell_display" remote="port" />
  <project path="hardware/marvell/fm" name="android_hardware_marvell_fm" remote="pxa" />
  <project path="hardware/marvell/gps" name="android_hardware_marvell_gps" remote="port" />
  <project path="hardware/marvell/keymaster" name="android_hardware_marvell_keymaster" remote="pxa" />
  <project path="hardware/marvell/libMarvellWireless" name="android_hardware_marvell_libMarvellWireless" remote="pxa" />
  <project path="hardware/marvell/MarvellWirelessDaemon" name="android_hardware_marvell_MarvellWirelessDaemon" remote="pxa" />
  <project path="hardware/marvell/libmvmem" name="android_hardware_marvell_libmvmem" remote="pxa" />
  <project path="hardware/marvell/libprebuilt" name="android_hardware_marvell_libprebuilt" remote="pxa" />
  <project path="hardware/marvell/media" name="android_hardware_marvell_media" remote="port" />
  <project path="hardware/marvell/pxa1908" name="android_hardware_marvell_pxa1908" remote="pxa" />
  <project path="hardware/marvell/vendor-libs" name="android_hardware_marvell_vendor-libs" remote="pxa" />
  <project path="hardware/marvell/wlan" name="android_hardware_marvell_wlan" remote="pxa" />

  <project path="hardware/samsung" name="LineageOS/android_hardware_samsung" remote="github" revision="cm-14.1" />
</manifest>
```
Then:
```
repo init -u https://github.com/LineageOS/android.git -b cm-14.1
repo sync -c -j8
device/samsung/coreprimevelte/coreprimevelte_patchs/apply.sh
source build/envsetup.sh && lunch lineage_coreprimevelte-userdebug && mka bacon
```
`coreprimevelte_patchs/apply.sh` commits the framework changes (frameworks/av, base, native,
system/core, system/extras, FMRadio) in their projects; re-running it is safe.

## Status
Works: GPU UI with HWC composition, 720p/1080p hardware video, audio, both cameras, Wi-Fi,
Bluetooth, NFC, sensors, GPS, MTP, modem (baseband, IMEI, SIM state, airplane mode), LiveDisplay,
SELinux enforcing. Not tested: calls, SMS and mobile data (no SIM was available), GPS outdoors,
FM with a headset, NFC tags, deep-sleep drain.

## Credits
notnoelchannel and Nemirtingas for the original pxa1908 / coreprimevelte trees
([pxa1908-devices](https://github.com/pxa1908-devices)), and the LineageOS project.
