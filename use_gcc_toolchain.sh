#!/usr/bin/env bash

# ==========================================
 # Switch to GCC and GNU Binutils on FreeBSD
 # ==========================================

 # 1. Set the GCC Compiler suite
 # (Assumes standard /usr/local/bin installation via pkg)
 export CC=/usr/local/bin/gcc
 export CXX=/usr/local/bin/g++
 export CPP=/usr/local/bin/cpp14

 # 2. Set GNU Binutils and force GCC to use the GNU BFD linker
 export LD=/usr/local/bin/ld
 export LDFLAGS="-fuse-ld=bfd"

 # 3. Set standard GNU archiving and object tools
 export AR=/usr/local/bin/ar
 export NM=/usr/local/bin/nm
 export OBJCOPY=/usr/local/bin/objcopy
 export OBJDUMP=/usr/local/bin/objdump
 export RANLIB=/usr/local/bin/ranlib

 # 4. Print confirmation to the terminal
 echo "=========================================="
 echo " Toolchain switched to GCC + GNU Binutils "
 echo "=========================================="
 echo "Compiler (CC) : $CC"
 echo "C++      (CXX): $CXX"
 echo "Linker   (LD) : $LD"
 echo "LDFLAGS       : $LDFLAGS"
 echo "=========================================="
