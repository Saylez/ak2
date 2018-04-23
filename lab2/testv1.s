.data
STDIN = 0
STDOUT = 1
SYSREAD = 3
SYSWRITE = 4
SYSEXIT = 1
EXIT_SUCCESS = 0

.bss
BUF_SIZE = 255
.comm BUF, BUF_SIZE

OUT_SIZE = 255
.comm OUT, OUT_SIZE

.comm OUT2, OUT_SIZE

.text
kom: .ascii "Hello\n"
roz = .- kom
.global _start

_start:

runrun:
	movl $SYSREAD, %eax
	movl $STDIN, %ebx
	movl $BUF, %ecx
	movl $BUF_SIZE, %edx
	int $0x80
	
	cmp $0, %eax
	je wyjscie
	
	movl $0, %edi
	movl $OUT_SIZE, %esi

	wpr:
		movb BUF(,%edi,1), %al
		mov %al, OUT(,%edi,1)	
		incl %edi
		cmp %edi, %esi
		je next
		jmp wpr
		

next:
	movl $0, %edi #licznik
	movl $OUT_SIZE, %esi
	movl $2, %ebx #baza
	
	horner:
		movl $0, %eax
		movb BUF(,%edi,1), %al
		div %bl
		#add $48, %ah
		movb %ah, OUT2(,%edi,1)
		incl %edi
		cmp %esi, %edi
		jne horner
		
next2:	
	movl $SYSWRITE, %eax
	movl $STDOUT, %ebx
	movl $OUT2, %ecx
	movl $OUT_SIZE, %edx
	int $0x80
	jmp runrun

wyjscie:
movl $SYSEXIT, %eax
movl $EXIT_SUCCESS, %ebx
int $0x80

