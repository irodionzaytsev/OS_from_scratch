%define tty 0x0e ; teletype scrolling
%define newline 0x0a
%define magic_boot_number 0xaa55
%define start_address 0x7c00
%define cr 13 ; carriage return
[org 0x7c00]
[bits 16]
KERNEL_OFFSET equ 0x1000
mov ax, 0
mov ds, ax
mov ss, ax
mov [BOOT_DRIVE], dl ; bios knows which drive it is and places it in dl
mov bp, 0xf000
mov sp, bp
;push MSG_RM
;call print_string
;add sp, 2
call load_kernel
jmp switch_to_pm
[bits 32]
pm:
push MSG_PM
call no_bios_print_string
add esp, 4
; now we need to execute the kernel
mov eax, KERNEL_OFFSET
add eax, 0x7c00
call  far eax  ; that's where our kernel has been loaded
jmp $
%include "./gdt/gdt.s"
%include "./gdt/switch.s"
%include "./gdt/no_bios_print.s"
%include "./gdt/print.s"
%include "kernel_loader.s"

MSG_PM db "...Landed in protected mode",  0
MSG_RM db "Taking off from real mode...", cr, newline, 0
BOOT_DRIVE db 0
times 510- ($-$$) db 0
dw magic_boot_number
