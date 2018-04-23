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

.comm HORNER_BUF, OUT_SIZE
.comm WYNIK_BUF, 255

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
	movl $0, %esi
	movl $OUT_SIZE, %ecx
	movb $2, %bl #baza
	
	movb BUF(,%edi,1), %ah 	#1 bit do ah
	incl %edi
	#movb BUF(,%edi,1), %al 	#2 bit do al
	div %bl 		#dziele ax przez bl, wynik w al, reszta w ah
	
	movb %ah, HORNER_BUF(,%esi,1) #reszta z dzielenia do bufora
	incl %edi
	
	horner:
		#shl $8, %ah	#przesuwamy al do ah
		movb BUF(,%edi,1), %al
		#div %bl
		#add $48, %ah
		incl %esi
		movb %ah, HORNER_BUF(,%esi,1)
		incl %edi
		cmp %ecx, %edi
		jne horner
		
next2:	
	movl $SYSWRITE, %eax
	movl $STDOUT, %ebx
	movl $HORNER_BUF, %ecx
	movl $OUT_SIZE, %edx
	int $0x80
	jmp runrun

wyjscie:
movl $SYSEXIT, %eax
movl $EXIT_SUCCESS, %ebx
int $0x80

