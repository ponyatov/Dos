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

struct Info {
    uint flags; /// (required)
    uint mem_lower; /// (present if MEM is set)
    uint mem_upper; /// (present if MEM)
    uint boot_device; /// BOOT_DEVICE
    uint cmdline; /// CMDLINE
    uint mods_count; /// MODS
    uint mods_addr; /// MODS
    uint[3] syms; /// any SYMC
    uint mmap_length; /// MMAP
    uint mmap_addr; /// MMAP
    uint drives_length; /// DRIVES
    uint drives_addr; /// DRIVES
    uint config_table; /// CONFIG_TABLE
    uint boot_loader_name; /// BOOT_LOADER_NAME
    uint apm_table; /// APM_TABLE
    uint vbe_control_info; /// VBE_CONTROL_INFO
    uint vbe_mode_info;
    ushort vbe_mode;
    uint vbe_interface_seg;
    uint vbe_interface_off;
    uint vbe_interface_len;
}

extern (C) Info* multiboot_info;
