; parameters are passed on the stack
; parameters passed from big to little
; 1) drive 2) cylinder 3) head 4) sector 5) number of sectors (each 512 bytes) 6)7) return address - es:bx
; destroys all registers (save al to compare the number of sectors read)
%macro _read_ 0
mov ah, 0x02; this indicates to read
int 0x13 ; bios disk interrupt
%endmacro
%define sector cl ; where the sector number is placed
%define number_of_sectors al
%define cylinder ch
%define head dh; i.e. the platter 
%define drive dl
; the return address is [es:bx] (macro is useless here)
%define param(i) [bp + i*2 + 2]; the ith parameter (1 is the base)
disk_read:
push bp
mov bp, sp
mov drive, param(1)
mov cylinder, param(2)
mov head, param(3)
mov sector, param(4)
mov number_of_sectors, param(5)
mov es, param(6)
mov bx, param(7)
_read_
pop bp
ret
