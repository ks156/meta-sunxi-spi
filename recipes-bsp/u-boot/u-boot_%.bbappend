SRC_URI:append = " file://usb.cfg"
SRC_URI:append = " file://emmc.cfg"
SRC_URI:append = " file://prompt.cfg"
SRC_URI:append = " file://version.cfg"
SRC_URI:append = " file://h3-devtree.patch"
SRC_URI:append = " file://uboot-env.cfg"
SRC_URI:append = " file://boot-override.cmd"
SRC_URI:append = " file://uEnv.txt"

PR = "r0"

do_replace_script() {
    bbwarn "Overriding the default script"
    ${B}/tools/mkimage -C none -A arm -T script -d ${WORKDIR}/boot-override.cmd ${WORKDIR}/${UBOOT_ENV_BINARY}
}

addtask do_replace_script after do_compile before do_deploy

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
ERROR_QA:remove = "patch-status"
WARN_QA:append = " patch-status"
