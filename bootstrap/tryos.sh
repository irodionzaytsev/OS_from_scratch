nasm boot_sector.s -o s_kernel.bin
cat s_kernel.bin c_kernel.bin padding > os_img.img
qemu-system-i386 os_img.img
