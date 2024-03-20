@echo off
wsl make
wsl rm "build/modex.img.lock"
bochsdbg -q -f .\bochs_config