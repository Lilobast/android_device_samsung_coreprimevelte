#!/bin/bash
# Apply the coreprimevelte framework patches to a LineageOS 14.1 tree.
# Run from anywhere: device/samsung/coreprimevelte/coreprimevelte_patchs/apply.sh
# Each patch becomes one local commit; a patch is skipped when its commit message is already in
# the project's history, so re-running is safe.
set -e
P=$(cd "$(dirname "$0")" && pwd)
T=$(cd "$P/../../../.." && pwd)
cd "$T"

# patch_project <project dir> <commit message> <patch files...>
patch_project() {
  local proj=$1 msg="coreprimevelte: $2"; shift 2
  if git -C $proj log --format=%s -n 50 | grep -qxF "$msg"; then
    echo "already applied: $msg"; return
  fi
  for p in "$@"; do
    patch -p0 -N -s -f --no-backup-if-mismatch < $p || { echo "FAILED: $p"; exit 1; }
  done
  git -C $proj add -A && git -C $proj commit -q -m "$msg"
  echo "applied: $msg"
}

patch_project frameworks/base "skip zygote fd table (Samsung blobs keep fds open)" \
  $P/com_android_internal_os_Zygote.cpp.patch
patch_project frameworks/native "GraphicBuffer: legacy 4-arg constructor for Vivante blobs" \
  $P/GraphicBuffer.h.patch $P/GraphicBuffer.cpp.patch
patch_project system/core "mkbootimg: allow board-provided mkbootimg" \
  $P/mkbootimg_Android.mk.patch
patch_project packages/apps/FMRadio "fmr jni: skip on Marvell hardware" \
  $P/FMRadio_jni_fmr_Android.mk.patch
patch_project frameworks/av "ACodec: software renderer for Marvell HW decoders" \
  $P/ACodec_mrvl_sw_renderer.patch
patch_project frameworks/base "hwui: optionally take buffer age from the window" \
  $P/hwui_window_buffer_age.patch
patch_project frameworks/av "SoftwareRenderer: NV12 gralloc buffers for Marvell decoders" \
  $P/SoftwareRenderer_mrvl_nv12.patch
patch_project frameworks/native 'binder: Marvell ION support for MemoryHeapBase("/dev/ion")' \
  $P/MemoryHeapBase_mrvl_ion.patch
patch_project frameworks/native "surfaceflinger: apply the HWC LiveDisplay tint to GLES-only frames" \
  $P/SurfaceFlinger_hwc_tint.patch
patch_project frameworks/av "stagefright: zero-copy Marvell decoder output + 2D-engine copy in SoftwareRenderer" \
  $P/Stagefright_mrvl_video_2d.patch

# system/extras/mkimage: same guard as mkbootimg (no patch file needed)
MK=system/extras/mkimage/Android.mk
MSG="coreprimevelte: mkimage: allow board-provided mkimage"
if [ -f $MK ] && ! git -C system/extras log --format=%s -n 50 | grep -qxF "$MSG"; then
  { echo 'ifneq ($(BOARD_PROVIDES_MKIMAGE),true)'; cat $MK; echo 'endif'; } > $MK.new && mv $MK.new $MK
  git -C system/extras add -A && git -C system/extras commit -q -m "$MSG" && echo "applied: $MSG"
fi
echo DONE
