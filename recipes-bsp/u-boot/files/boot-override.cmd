# test usb and boot on it

echo "Boot for H3 script"

machine_name='suni8'
boottool='bootm'
default_kernel_img='uImage'
default_devicetree='sun8i-h3-nanopi-neo.dtb'
default_storage='mmc'
default_partition='1:1'
default_rootfsdev='/dev/mmcblk1p2'
default_usb_rootfsdev='/dev/sda2'
default_kernel_addr=0x40080000
default_devicetree_addr=0x4FA00000
default_env_addr=${default_kernel_addr}
default_console='ttyS0,115200'

echo "Starting USB"

usb start

if usb storage ; then
   echo "USB storage detected"
   
   if load usb 0:2 ${default_kernel_addr} ${default_kernel_img} ||  load usb 1:2 ${default_kernel_addr} ${default_kernel_img} ; then
      if load usb 0:2 ${default_devicetree_addr} ${default_devicetree} || load usb 1:2 ${default_devicetree_addr} ${default_devicetree} ; then
            echo "booting on USB 0"
            setenv kernel_options "console=${default_console} rootwait panic=10"
            setenv bootargs "root=${default_usb_rootfsdev} roottype=ext4 ${kernel_options} ${bootopts}"
            ${boottool} ${default_kernel_addr} - ${default_devicetree_addr}
      else
          echo "no device tree found on USB 0"
      fi
   else
      echo "not kernel found on USB 0"
   fi
fi

if mmc dev 0 ; then
   echo "SD storage detected"
   if load mmc 0:1 ${default_kernel_addr} /${default_kernel_img} ; then
      echo "kernel image loaded"
      if load mmc 0:1 ${default_devicetree_addr} /${default_devicetree} ; then
            setenv kernel_options "console=${default_console} rootwait panic=10"
            setenv bootargs "root=/dev/mmcblk0p2 roottype=ext4 ${kernel_options} ${bootopts}"
            echo "booting on SD"
            ${boottool} ${default_kernel_addr} - ${default_devicetree_addr}
      else
          echo "no device tree found on SD"
      fi
   else
      echo "not kernel found on SD"
   fi
else
   echo "no SD found"
fi

echo "booting from eMMC"

mmc dev 1

setenv storage "${default_storage}"
setenv rootfsdev "${default_rootfsdev}"
setenv partition "${default_partition}"

echo "booting on ${storage} with rootfs ${rootfsdev}"

setenv kernel_options "console=${default_console} rootwait panic=10 fsck.mode=force fsck.repair=yes audit=0"
setenv bootargs "root=${rootfsdev} ${kernel_options} ${bootopts}"

if load ${storage} ${partition} ${default_kernel_addr} ${default_kernel_img} ; then
   if load ${storage} ${partition} ${default_devicetree_addr} ${default_devicetree} ; then
      echo "booting from eMMC"
      saveenv
      ${boottool} ${default_kernel_addr} - ${default_devicetree_addr}
   else
      echo "no device tree found on eMMC"
   fi
else
   echo "no kernel found on eMMC"
fi
