#!/usr/bin/env bash
sudo tee /usr/local/include/alloca.h << 'EOF'
#ifndef _ALLOCA_H_
#define _ALLOCA_H_

#include <stdlib.h>

#endif /* _ALLOCA_H_ */
EOF
