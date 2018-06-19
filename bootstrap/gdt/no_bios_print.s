[bits 32]; compile the instructions in 32 bit format
%define VGA_START 0xb8000; video graphics array beginning address
%define WHITE_ON_BLACK 0x0f; the second byte, which is the mode
no_bios_print_string: ; prints at the start of the screen - the only arg is the start address of the string
push ebp
mov ebp, esp
mov edx, VGA_START
mov ah, WHITE_ON_BLACK
mov ebx, dword [ebp + 8]
no_bios_lp:
mov  al, byte [ebx]
test al, al
jz no_bios_endlp
mov [edx], al
add edx, 2; moving across the screen
inc ebx; moving to the next character
jmp no_bios_lp
no_bios_endlp:
pop ebp
ret
no_bios_print_char: ; first arg - row, second - column, third - ascii char
push ebp
mov ebp, esp
mov eax, [ebp + 8]; now we need to multiply by 80, to get the right address (text mode is 80*25)
mov ebx, eax
shl eax, 6; times 64
shl ebx, 4; times 16
add eax, ebx; eax is 70 the input currently
shr ebx, 1; times 8
add eax, ebx
shr ebx, 2; times 2
add eax, ebx; now eax has what we need
add eax, [ebp+12]; add the column
mov edx, VGA_START
add edx, eax; edx has the proper address now
mov al, byte [ebp+16]; the ascii code
mov ah, WHITE_ON_BLACK
mov [edx], ax
pop ebp
ret
