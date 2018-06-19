void main(void)
{
	char *vga =  0xb8000;
	*vga = 'X';
}
