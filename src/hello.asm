; DOS simple program
use16
org 0x100

	mov ah, 0x9
	mov dx, hello
	int 21h

	mov ax, 0x4c00
	int 21h

hello:
db "Hello world", "$"

