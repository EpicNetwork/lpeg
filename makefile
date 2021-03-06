# Assumes compilation on Linux or OSX.
# Supports Win32, Win64, Linux, and OSX as targets.

BUILD_FOLDER_MASTER=$(abspath .)/../../build
PREFIX=$(BUILD_FOLDER_MASTER)

# System's libraries directory (where binary libraries are installed)
LUA_LIBDIR?= $(PREFIX)/lib/lua/5.1

# Lua includes directory
LUA_INC =  -I$(PREFIX)/include
LUA_INC += -I$(PREFIX)/include/luajit-2.1
LUA_INC += -I$(PREFIX)/lua/5.1

LIBNAME = lpeg
LUADIR ?= ../lua/

COPT = -O2
# COPT = -DLPEG_DEBUG -g

CWARNS = -Wall -Wextra -pedantic \
	-Waggregate-return \
	-Wcast-align \
	-Wcast-qual \
	-Wdisabled-optimization \
	-Wpointer-arith \
	-Wshadow \
	-Wsign-compare \
	-Wundef \
	-Wwrite-strings \
	-Wbad-function-cast \
	-Wdeclaration-after-statement \
	-Wmissing-prototypes \
	-Wnested-externs \
	-Wstrict-prototypes \
# -Wunreachable-code \


CFLAGS = $(CWARNS) $(COPT) -std=c99 $(LUA_INC) -fPIC

FILES = lpvm.o lpcap.o lptree.o lpcode.o lpprint.o

# For Linux
linux:
	make lpeg.so "DLLFLAGS = -shared -fPIC"

# For Mac OS
macosx:
	make lpeg.so "DLLFLAGS = -bundle -undefined dynamic_lookup"

lpeg.so: $(FILES)
	env $(CC) $(DLLFLAGS) $(FILES) -o $(LUA_LIBDIR)/lpeg.so

# For 32-bit Windows
win32:
	make lpeg.dll "DLLFLAGS = -shared -fPIC"

# For 64-bit Windows
win64:
	make lpeg.dll "DLLFLAGS = -shared -fPIC"

lpeg.dll: $(FILES)
	env $(CC) $(DLLFLAGS) $(FILES) -o $(LUA_LIBDIR)/lpeg.dll

$(FILES): makefile

clean:
	rm -f $(FILES) lpeg.so lpeg.dll


lpcap.o: lpcap.c lpcap.h lptypes.h
lpcode.o: lpcode.c lptypes.h lpcode.h lptree.h lpvm.h lpcap.h
lpprint.o: lpprint.c lptypes.h lpprint.h lptree.h lpvm.h lpcap.h
lptree.o: lptree.c lptypes.h lpcap.h lpcode.h lptree.h lpvm.h lpprint.h
lpvm.o: lpvm.c lpcap.h lptypes.h lpvm.h lpprint.h lptree.h

