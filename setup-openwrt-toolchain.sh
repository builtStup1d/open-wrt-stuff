#!/bin/bash

OPENWRT_SDK="/home/builtstupid/Documents/wrt/openwrt-sdk-24.10.0-x86-generic_gcc-13.3.0_musl.Linux-x86_64"

# Export necessary environment variables
export STAGING_DIR="$OPENWRT_SDK/staging_dir"
export PATH="$STAGING_DIR/toolchain-i386_pentium4_gcc-13.3.0_musl/bin:$PATH"
export CROSS_COMPILE=i486-openwrt-linux-musl-
export CC="${CROSS_COMPILE}gcc"

echo "OpenWrt toolchain setup complete."
echo "Use ${CC} to compile for OpenWrt."

