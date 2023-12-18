; Multiboot v1 - Compliant Header for QEMU (doesn't support v2)
; https://www.gnu.org/software/grub/manual/multiboot/multiboot.html

PAGE_ALIGN    equ  1<<0
MEMORY_INFO   equ  1<<1
HEADER_FLAGS  equ  PAGE_ALIGN | MEMORY_INFO
HEADER_MAGIC  equ  0x1BADB002
CHECKSUM      equ  -(HEADER_MAGIC + HEADER_FLAGS)

ALIGN 4
section .multiboot
    dd HEADER_MAGIC
    dd HEADER_FLAGS
    dd CHECKSUM

section .data
    db "Hello"

section .text
    nop
    halt
