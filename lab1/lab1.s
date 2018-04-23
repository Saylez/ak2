.data
STDIN = 0
STDOUT = 1
SYSREAD = 3
SYSWRITE = 4
SYSEXIT = 1
EXIT_SUCCESS = 0

#.data
#BUF: .space 3
#BUF_SIZE = .-BUF
#OUT: .space 2
#OUT_SIZE = .-OUT

.bss
.comm BUF, 3
BUF_SIZE = 3
.comm OUT, 1
OUT_SIZE = 1

.text

.global _start

_start:
loop:
	movl $SYSREAD, %eax
	movl $STDIN, %ebx
	movl $BUF, %ecx
	movl $BUF_SIZE, %edx
	int $0x80
	
	cmp $0, %eax
	je wyjscie

	movl $0, %edi

	movb BUF(,%edi,1), %al
	subb $64, %al
	cmp $0, %al
	jge char
	jmp digit

next:
	incl %edi
	movb BUF(,%edi,1), %cl
	subb $64, %cl
	cmp $0, %cl
	jge char1
	jmp digit1

char:
	addb $9, %al
	jmp next
digit:
	addb $16, %al

jmp next
char1:
	addb $9, %cl
	jmp to_out
digit1:
	addb $16, %cl

to_out:
	shlb $4, %al
	or %al, %cl
	mov %cl, OUT

write:
	movl $SYSWRITE, %eax
	movl $STDOUT, %ebx
	movl $OUT, %ecx
	movl $OUT_SIZE, %edx
	int $0x80

	jmp loop
wyjscie:
movl $SYSEXIT, %eax
movl $EXIT_SUCCESS, %ebx
int $0x80
