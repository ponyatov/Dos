module io;

extern (C) {
    void port_write_b(ushort port, ubyte val);
    ubyte port_read_b(ushort port);
    int putchar(int c);
    int puts(const char* s);
    void* memset(void* ptr, int data, size_t len);
}
