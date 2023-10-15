OUTPUT_FORMAT(elf32-i386)

MEMORY
{
	RAM (RWX) : ORIGIN = 0x100000, LENGTH = 0x10000
}

SECTIONS
{
    .multiboot : {
        _load_addr = .;
        multiboot_header = .;
		KEEP(*(.multiboot*))
    } > RAM

    .text : {
        KEEP(*(._start))
		*(.text*)
    } > RAM

    .rodata : {
        *(.rodata*)
    } > RAM

    .data : {
        *(.data)
    } > RAM

    .bss (NOLOAD) : {
        . = ALIGN(4K);
		_bss_addr = .;
        *(.bss COMMON)
    } > RAM

    .stack (NOLOAD) : {
		. = ALIGN(4K);
		_stack = .;
		. += 4K;
		_estack = .;
	}

    /DISCARD/ : {
		*(.comment)
		*(.note.*)
		*(.eh_frame)
	}
}
