#!/usr/bin/env bash

LLVM_VERSION=16
LLVM_LITE_VERSION=0.44.0

export PATH="/usr/local/llvm${LLVM_VERSION}/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/llvm${LLVM_VERSION}/lib:$LD_LIBRARY_PATH"

python -m pip install llvmlite=="${LLVM_LITE_VERSION}"
