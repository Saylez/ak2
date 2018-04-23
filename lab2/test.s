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
.comm OUT2, OUT_SIZE

.comm HORNER_BUF, OUT_SIZE
.comm WYNIK_BUF, OUT_SIZE
.comm WYNIK_BUF2, OUT_SIZE
.comm WYNIK_BUF3, OUT_SIZE

.text
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
	movl $3, %esi
	loop:	
		movb BUF(,%edi,1), %al
		subb $48, %al
		movb %al, OUT(,%edi,1)
		incl %edi
		cmp %edi, %esi
		jne loop

	movl $0, %edi
	movl $3, %esi
	loop2:
		movb OUT(,%edi,1), %al
		movb %al, OUT2(,%edi,1)
		incl %edi
		cmp %edi, %esi
		jne loop2
		
		
next:
	movl $0, %edi #licznik
	movl $3, %esi
	movl $16, %ebx
	movl $0, %edx
	
	movl $0, %eax
	movb OUT2(,%edi,1), %al
	incl %edi
	
	horner:
		mul %bl
		movb OUT2(,%edi,1), %dl	
		add %dx, %ax	
		
		incl %edi	
		cmp %esi, %edi
		jne horner
		
next2:	
	mov %ax, WYNIK_BUF 

	movl $0, %edi
	movl $3, %esi
	last_loop:
		movb WYNIK_BUF(,%edi,1), %al
		add $48, %al
		movb %al, WYNIK_BUF2(,%edi,1)
		incl %edi
		cmp %edi, %esi
		jne last_loop

	movl $0, %edi
	movl $3, %esi
	last_loop2:
		movb WYNIK_BUF2(,%edi,1), %al
		movb %al, WYNIK_BUF3(,%edi,1)
		incl %edi
		cmp %edi, %esi
		jne last_loop2	
_t:
	movl $SYSWRITE, %eax
	movl $STDOUT, %ebx
	movl $WYNIK_BUF2, %ecx
	movl $OUT_SIZE, %edx
	int $0x80
	jmp runrun

wyjscie:
movl $SYSEXIT, %eax
movl $EXIT_SUCCESS, %ebx
int $0x80

