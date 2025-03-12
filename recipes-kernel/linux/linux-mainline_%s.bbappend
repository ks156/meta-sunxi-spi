SRC_URI:append:sun8i = " file://h3-emmc.patch"
SRC_URI:append:sun8i = " file://dt-spi.patch"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux:"

PR = "r0"
