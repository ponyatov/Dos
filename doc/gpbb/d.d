import std.range;
import std.stdio;

void main() {
    foreach (i; 1.iota(70.1)) {
        // writefln("gpbb%s.pdf:\n\t$(CURL) $@ https://web.archive.org/web/20190706123029/http://twimgs.com/ddj/abrashblackbook/gpbb%s.pdf",i,i);}
        writef("gpbb%s.pdf ", i);
    }
}
