print_string:
push bp
mov bp, sp
mov bx, word [bp + 4]
mov ah, tty
lp:
mov al, byte [bx]
test al, al
jz endlp
int 0x10
inc bx
jmp lp
endlp:
pop bp
ret

print_hex_char: ; prints one char (half a byte) in al in hexadecimal
mov ah, tty
cmp al, 9
ja letter; assume it is number
add al, '0'
int 0x10
ret
letter:
sub al, 10
add al, 'a'
int 0x10
ret

print_512_hex:
push bp
mov bp, sp
mov bx, [bp+4]
mov cx, 512
print_512_hex_lp:
mov al, byte [bx]
shr al, 4
call print_hex_char
mov al, byte [bx]
shl al, 4
shr al, 4
call print_hex_char
inc bx
loop print_512_hex_lp
pop bp
ret
