#!/bin/bash

# 1. Force-source luaver directly from its install directory
if [ -s "$HOME/.luaver/luaver" ]; then
    . "$HOME/.luaver/luaver" > $HOME/.config/lfrt/lvlog0.txt
else
    echo "❌ Error: luaver not found at $HOME/.luaver/luaver"
    exit 1
fi

# 2. Force luaver to select the targeted version
luaver use 5.3.6 > $HOME/.config/lfrt/lvlog1.txt

# 3. Execute your Lua program and pass down any arguments
lua $HOME/.config/lfrt/lfrtcl.lua "$@"
