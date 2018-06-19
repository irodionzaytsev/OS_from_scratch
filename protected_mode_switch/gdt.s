;this is the global descriptor table
;just insert it in the appropriate place
global_descriptor_table:
dd 0 ; 8 null bytes (the invalid null descriptor - for protection against not loading the segment registers)
dd 0
; next comes the code descriptor
; segment limit (2B) , base address (2B) - the first double word
code_segment:
dw 0xffff
dw 0x0000; we want base set to min (i.e. 0)
; base address -continued (one more byte)
db 0
; the first four bits of the next byte define the type 
; code - 1 (not data)
; conforming - 0, code with  lower privilige can't execute this
; readable  - 1, we can read (e.g. constants), not only execute
; accessed (for debugging - when cpu accesses the segment, this bit is set) -set to 0
; so the half byte would be 1010 (code-conform.-read-access)
; then some flags
; present - 1 ( segment present in memory , as opposed to virtual memory)
; 2 bits for privilige - 0 ( highest privilige)
; descriptor type - 1 (this is code/data, not system)
; hence the half byte is 1001
db 10011010b
; then the segment limit (half a byte) - 0000
; granularity - 1 (multiply the limit by 4K)
; 32-bit default -1 (0 for 16)
; 64 bit segment - 0
; avl - 0 (available for software usage - e.g. debugging, it is user-defined)
; this half byte is 1100 (granularity-32bit_def-64bit-avl)
; then half a byte of segment limit - 1111 (we want ours set to max, also granularity will shl 12)
; this half byte is 1111
db 11001111b
db 0 ; base address continued
data_segment:
; basic flat model -> the same addresses as code
dw 0xffff; segment limit
dw 0 ; base address
db 0 ; base address
; type
; code - 0 (data)
; expand down - 0 (could be needed for stack)
; write - 1
; accessed -0
; 0010 (code - expand -write - accessed)
; flags - the same as for code
; 1001
db 10010010b
; the next part is also the same (in basic flat model, code and data segments are similar!)
db 11001111b
db 0 ; base address continued
global_descriptor_table_end:
; yay
; joke_mode=1
; the GDT - gdt descriptor table
; serious_mode=1
; gdt descriptor is passed to the cpu, it consists of gdt size (16 bits) and address (32 bits)
; 
gdt_descriptor:
dw global_descriptor_table_end - global_descriptor_table - 1; if the table is 16 bytes, the limit (maximum added to 
; the offset
dd global_descriptor_table
; constants
CODE_SEG equ code_segment - global_descriptor_table
DATA_SEG equ data_segment - global_descriptor_table
