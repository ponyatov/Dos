# var
MODULE  = $(notdir $(CURDIR))
NOW     = $(shell date +%d%m%y)
REL     = $(shell git rev-parse --short=4 HEAD)
BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)

# target
CPU    = i486
ARCH   = x86
TRIPLE = i386-elf
# -m32 -mcpu=i686 -mattr=sse2

# version
# LDC_VER = 1.32.0
# ## debian 12 libc 2.29 since 1.32.1

# dir
CWD = $(CURDIR)
BIN = $(CWD)/bin
SRC = $(CWD)/src
TMP = $(CWD)/tmp
GZ  = $(HOME)/gz

# # package
# LDC    = ldc2-$(LDC_VER)
# LDC_OS = $(LDC)-linux-x86_64
# LDC_GZ = $(LDC_OS).tar.xz

# tool
CURL = curl -L -o
DUB  = /usr/bin/dub
LDC  = /usr/bin/ldc2
LLC  = /usr/bin/llc-14

# src
L += lib/qemu386.ld
S += $(wildcard src/*.s)
D += $(wildcard src/*.d)
# OSD = $(subst src/app.d,,$(D))

OBJ += $(subst src/,tmp/,$(subst .s,.o,$(S)))
OBJ += $(subst src/,tmp/,$(subst .d,.o,$(D)))
# OBJ = $(subst src/,lib/,$(subst .d,.o,$(OSD))) lib/multiboot1.o

# cfg
TARGET   = -mtriple $(TRIPLE) -march=$(ARCH) -mcpu=$(CPU)
LDCFLAGS = $(TARGET) -defaultlib= -betterC
LLCFLAGS = $(subst -,--,$(TARGET))

# all
.PHONY: all
all: bin/kernel.elf

.PHONY: qemu
qemu: bin/kernel.elf
	qemu-system-i386 -kernel $<

# format
format: tmp/format_d
tmp/format_d: $(D)
	dub run dfmt -- -i $? && touch $@

# rule
bin/kernel.elf: $(L) $(OBJ)
	echo $(OBJ)
	ld -melf_i386 -T$(L) -o $@ $(OBJ)
	objdump -x $@ > $@.objdump
tmp/%.o: src/%.s
	nasm -felf32 -o $@ $<
	objdump -x $@ > $@.objdump
tmp/%.o: tmp/%.ll Makefile
	$(LLC) $(LLCFLAGS) -filetype=obj -o $@ $<
	objdump -x $@ > $@.objdump
tmp/%.ll: src/%.d Makefile
	$(LDC) $(LDCFLAGS) --output-ll -of=$@ -c $<

# .PRECIOUS: tmp/%.s tmp/%.ll
# tmp/%.s: tmp/%.ll
# 	$(LLC) $(LLCFLAGS) -filetype=asm -o $@ $<

# doc
.PHONY: doc
doc: doc/yazyk_programmirovaniya_d.pdf doc/Programming_in_D.pdf

doc/yazyk_programmirovaniya_d.pdf:
	$(CURL) $@ https://www.k0d.cc/storage/books/D/yazyk_programmirovaniya_d.pdf
doc/Programming_in_D.pdf:
	$(CURL) $@ http://ddili.org/ders/d.en/Programming_in_D.pdf

# install
# APT_SRC = /etc/apt/sources.list.d
# ETC_APT = $(APT_SRC)/d-apt.list $(APT_SRC)/llvm.list
# .PHONY: install update gz ref
install: doc gz
	$(MAKE) update
# 	sudo apt update && sudo apt --allow-unauthenticated install -yu d-apt-keyring
update:
	sudo apt update
	sudo apt install -yu `cat apt.txt`
# $(APT_SRC)/%: tmp/%
# 	sudo cp $< $@
# tmp/d-apt.list:
# 	$(CURL) $@ http://master.dl.sourceforge.net/project/d-apt/files/d-apt.list

gz:
# ref $(LDC2)

# $(LDC2): $(GZ)/$(LDC_GZ)
# 	cd bin ; xzcat $< | tar -x && touch $@
# $(GZ)/$(LDC_GZ):
# 	$(CURL) $@ https://github.com/ldc-developers/ldc/releases/download/v$(LDC_VER)/$(LDC_GZ)

# ref: ref/minimal-d/BARE ref/book/chapter_01/01/hello.d \
# 	ref/syslinux/README

# ref/minimal-d/BARE: tmp/minimal.zip
# 	unzip -x $< -d ref && touch $@
# ref/book/chapter_01/01/hello.d: tmp/book.zip
# 	unzip -x $< -d ref && touch $@

# tmp/minimal.zip:
# 	$(CURL) $@ http://arsdnet.net/dcode/minimal.zip
# tmp/book.zip:
# 	$(CURL) $@ http://arsdnet.net/dcode/book.zip

# ref/syslinux/README:
# 	git clone --depth 1 https://github.com/geneC/syslinux.git ref/syslinux
