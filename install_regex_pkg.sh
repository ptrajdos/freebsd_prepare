#!/usr/bin/env bash
# Check if the user provided an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <regex_pattern>"
    echo "Example: $0 'py311-torch(vision)?'"
    exit 1
fi

REGEX_PATTERN=$1

echo "--- Searching for packages matching: '$REGEX_PATTERN' ---"

# 1. Find the packages using Case-Insensitive Regex (-ix)
# We store them in a variable to check if anything was found
PACKAGES=$(pkg search -ix "$REGEX_PATTERN" | awk '{print $1}')

if [ -z "$PACKAGES" ]; then
    echo "No packages found matching that pattern."
    exit 0
fi

echo "Found the following packages:"
echo "$PACKAGES"
echo "--------------------------------------------------------"

# 2. Ask for confirmation
read -p "Do you want to install these packages? (y/n): " CONFIRM

if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    # 3. Pass the list to pkg install
    # We use -ix again during install to ensure the pattern is interpreted correctly
    echo "Starting installation..."
    sudo pkg install ${PACKAGES}
else
    echo "Installation cancelled."
fi
