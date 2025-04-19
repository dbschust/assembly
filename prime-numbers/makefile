#Author: Daniel Schuster

CC = gcc
AS = nasm

ADEBUG = -g3 -O0
ARCH = -m32
PIE = -no-pie -fno-pie
LDFLAGS = $(ARCH) $(PIE)
ASFLAGS = $(ADEBUG) -f elf32 -F dwarf

PROG0 = sieve

PROGS = $(PROG0) $(PROG1) $(PROG2) $(PROG3) $(PROG4) $(PROG5)

#  $@ is the target filename
#  $* is the basename of the target filename
#  $^ is the names of all the prerequisites
#  $< is the name of the first dependency
#  $? is the names of all prerequisites that are newer than the target

all: $(PROGS)

$(PROG0): $(PROG0).o
	$(CC) $(LDFLAGS) -o $@ $^

$(PROG0).o: $(PROG0).asm
	$(AS) $(ASFLAGS) -l $(PROG0).lst $<

.PHONY: clean cls ci git get tar

clean cls:
	rm -f $(PROGS) *.s *.o *.lst *~ \#*

git:
	if [ ! -d .git ] ; then git init; fi
	git add *.asm ?akefile
	git commit -m "lazy commit"

TAR_FILE = ${LOGNAME}_sieve.tar.gz

tar:
	rm -f $(TAR_FILE)
	tar cvfz $(TAR_FILE) *.asm [Mm]akefile
	tar tvfz $(TAR_FILE)

