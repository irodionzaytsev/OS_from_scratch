; this routine performs the switch from 16 bit real to 32 bit protected mode
switch_to_pm:
[bits 16]; not yet in 32 bit mode

cli ; clear interrupts - bios instructions may be misinterpreted in different mode
lgdt [gdt_descriptor] ; load gdt descriptor
mov eax, cr0
or eax, 0x1; setting the first bit of cr0 - switching on the protected mode
mov cr0, eax ; after calling this routine
 ; a long jump must be executed to flush the prefetch input queue (finish off 16 bit instructions in the pipe) and
 ; not prefetch 32 bit instructions and interpret them as if they were 16
jmp CODE_SEG:initialize_pm
[bits 32] ; now we are in 32 bit mode
initialize_pm: 
mov ax, DATA_SEG
mov ss, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ds, ax; initialize the data segment
mov ebp, 0x90000
mov esp, ebp ; set the stack
jmp pm
