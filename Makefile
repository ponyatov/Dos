# var
MODULE  = $(notdir $(CURDIR))
NOW     = $(shell date +%d%m%y)
REL     = $(shell git rev-parse --short=4 HEAD)
BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)

# version
## debian 12 libc 2.29 since 1.32.1
LDC_VER = 1.32.0

# dir
CWD = $(CURDIR)
BIN = $(CWD)/bin
SRC = $(CWD)/src
TMP = $(CWD)/tmp
GZ  = $(HOME)/gz

# package
LDC    = ldc2-$(LDC_VER)
LDC_OS = $(LDC)-linux-x86_64
LDC_GZ = $(LDC_OS).tar.xz

# tool
CURL = curl -L -o
LDC2 = $(CWD)/ldc/$(LDC_OS)/bin/ldc2

# src
D   = $(wildcard src/*.d)
OSD = $(subst src/app.d,,$(D))
OBJ = $(subst src/,lib/,$(subst .d,.o,$(OSD)))

# all
.PHONY: all
all: fw/kernel.elf

fw/kernel.elf: lib/qemu386.ld $(OBJ) 
	ld -m elf_i386 -Tlib/qemu386.ld -o $@ $(OBJ) && objdump -x $@ > $@.objdump

# format
format: tmp/format_d
tmp/format_d: $(D)
	dub run dfmt -- -i $? && touch $@

# rule
lib/%.o: src/%.d
	dmd -m32 -c $< -of=$@ && objdump -x $@ > $@.objdump

# install
APT_SRC = /etc/apt/sources.list.d
ETC_APT = $(APT_SRC)/d-apt.list $(APT_SRC)/llvm.list
.PHONY: install update gz ref
install: doc gz $(ETC_APT)
	sudo apt update && sudo apt --allow-unauthenticated install -yu d-apt-keyring
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -yu `cat apt.txt`
$(APT_SRC)/%: tmp/%
	sudo cp $< $@
tmp/d-apt.list:
	$(CURL) $@ http://master.dl.sourceforge.net/project/d-apt/files/d-apt.list

gz: ref

ref: ref/minimal-d/BARE ref/book/chapter_01/01/hello.d

ref/minimal-d/BARE: tmp/minimal.zip
	unzip -x $< -d ref && touch $@
ref/book/chapter_01/01/hello.d: tmp/book.zip
	unzip -x $< -d ref && touch $@

tmp/minimal.zip:
	$(CURL) $@ http://arsdnet.net/dcode/minimal.zip
tmp/book.zip:
	$(CURL) $@ http://arsdnet.net/dcode/book.zip
