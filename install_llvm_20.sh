#!/usr/bin/env bash

LLVM_VERSION=20
LLVM_LITE_VERSION=0.46.0
LOGFILE="./install.log"

export PATH="/usr/local/llvm${LLVM_VERSION}/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/llvm${LLVM_VERSION}/lib:$LD_LIBRARY_PATH"

export CFLAGS="-Wl,--warn-unresolved-symbols $CFLAGS"
export CXXFLAGS="-Wl,--warn-unresolved-symbols $CXXFLAGS"

python -m pip install llvmlite=="${LLVM_LITE_VERSION}" --log "${LOGFILE}"
