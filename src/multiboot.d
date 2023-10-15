module multiboot;

// https://github.com/mborgerson/baremetal/blob/master/src/multiboot.h

enum MAGIC = 0x1badb002;

enum INFO_FLAG {
    MEM = (1 << 0),
    BOOT_DEVICE = (1 << 1),
    CMDLINE = (1 << 2),
    MODS = (1 << 3),
    SYMS = ((1 << 4) | (1 << 5)),
    MMAP = (1 << 6),
    DRIVES = (1 << 7),
    CONFIG_TABLE = (1 << 8),
    BOOT_LOADER_NAME = (1 << 9),
    APM_TABLE = (1 << 10),
    VBE_CONTROL_INFO = (1 << 11)
}

struct Header {
    uint magic;
    uint flags;
    uint checksum;
    uint header_addr;
    uint load_addr;
    uint load_end_addr;
    uint bss_end_addr;
    uint entry_addr;
    uint mode_type;
    uint width;
    uint height;
    uint depth;
}

extern (C) Header* multiboot_header;
