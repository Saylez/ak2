test: test.o
	ld -m elf_i386 -o test test.o

test.o: test.s
	as --32 -o test.o test.s
