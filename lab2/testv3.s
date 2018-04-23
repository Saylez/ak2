.data
STDIN = 0
STDOUT = 1
SYSREAD = 3
SYSWRITE = 4
SYSEXIT = 1
EXIT_SUCCESS = 0

.bss
BUF_SIZE = 3
.comm BUF, BUF_SIZE

OUT_SIZE = 3
.comm OUT, OUT_SIZE

.comm HORNER_BUF, OUT_SIZE
.comm WYNIK_BUF, OUT_SIZE

.text
kom: .ascii "Hello\n"
roz = .- kom

.global main 
main:

runrun:
	movl $SYSREAD, %eax
	movl $STDIN, %ebx
	movl $BUF, %ecx
	movl $BUF_SIZE, %edx
	int $0x80
	
	cmp $0, %eax
	je wyjscie
	
	
		movl $0, %edi
		movl $2, %esi
	movb OUT(,%edi,1), %al
	incl %edi
	loop:	
		movb BUF(,%edi,1), %al
		subb $48, %al
		movb %al, OUT(,%edi,1)
		incl %edi
		cmp %edi, %esi
		jne loop

next:
	movl $0, %edi #licznik
	movl $0, %esi
	movl $3, %ecx
	movl $16, %ebx
	movl $0, %edx
	
	movl $0, %eax
	movb OUT(,%edi,1), %al
	incl %edi
	
	horner:
		mul %bl
		movb OUT(,%edi,1), %dl	
		add %dx, %ax	
		
		incl %edi	
		cmp %ecx, %edi
		jne horner
		
next2:	
	mov %ax, WYNIK_BUF 
	
	movl $SYSWRITE, %eax
	movl $STDOUT, %ebx
	movl $WYNIK_BUF, %ecx
	movl $OUT_SIZE, %edx
	int $0x80
	jmp runrun

wyjscie:
movl $SYSEXIT, %eax
movl $EXIT_SUCCESS, %ebx
int $0x80

