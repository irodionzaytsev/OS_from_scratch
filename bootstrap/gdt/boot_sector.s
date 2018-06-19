%define tty 0x0e ; teletype scrolling
%define newline 0x0a
%define magic_boot_number 0xaa55
%define start_address 0x7c00
%define cr 13 ; carriage return
[org 0x7c00]
mov bp, 0xf000
mov sp, bp
push MSG_RM
call print_string
add sp, 2
jmp switch_to_pm
[bits 32]
pm:
push MSG_PM
call no_bios_print_string
add esp, 4
jmp $
%include "gdt.s"
%include "switch.s"
%include "no_bios_print.s"
%include "print.s"
MSG_PM db "...Landed in protected mode", 0
MSG_RM db "Taking off from real mode...", 0
times 510- ($-$$) db 0
dw magic_boot_number

