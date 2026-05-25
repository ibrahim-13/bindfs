#!/bin/sh
set -e

if command -v dnf > /dev/null 2>&1; then
    MISSING=""
    for pkg in fuse3 fuse3-devel gcc make automake autoconf libtool pkg-config; do
        if ! rpm -q "$pkg" > /dev/null 2>&1; then
            MISSING="$MISSING $pkg"
        fi
    done
    if [ -n "$MISSING" ]; then
        echo "Installing:$MISSING"
        sudo dnf install -y $MISSING
    else
        echo "All packages already installed."
    fi

elif command -v apt-get > /dev/null 2>&1; then
    MISSING=""
    for pkg in build-essential pkg-config libfuse3-dev autoconf automake libtool; do
        if ! dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed"; then
            MISSING="$MISSING $pkg"
        fi
    done
    if [ -n "$MISSING" ]; then
        echo "Installing:$MISSING"
        sudo apt-get update -qq
        sudo apt-get install -y $MISSING
    else
        echo "All packages already installed."
    fi

else
    echo "Error: neither dnf nor apt-get found. Install dependencies manually." >&2
    exit 1
fi
