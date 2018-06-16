%define tty 0x0e ; teletype scrolling
%define newline 0x0a
%define magic_boot_number 0xaa55
%define start_address 0x7c00
%define cr 13 ; carriage return
mov [BOOT_DRIVE], dl; bios will store the drive in dl after loading the boot sector
mov bp, 0xffff
mov sp, bp
; return address will be 0x8000
push 0x9000
push 0
push 2; two sectors to be read
push 2; the first sector is the boot sector, so the second is data (base 1)
push 0 ; head 0
push 0 ; cylinder 0
mov dl, byte [BOOT_DRIVE]
mov dh, 0
push dx
call disk_read
add sp, 14
jc fail
cmp al, 2
jne fail

success:
mov ax, 0
mov ds, ax
push 0x9000
call print_string
jmp end

fail:
mov ax, 0x7c0
mov ds, ax
push error_msg
call print_string
add sp, 2
jmp end

end:
jmp $
%include "disk_read.s"
%include "print.s"
BOOT_DRIVE: db 0
error_msg: db "Disk read error", 0
times 510- ($-$$) db 0
dw magic_boot_number
times 512 db "1"
times 511 db "2"
db 0
