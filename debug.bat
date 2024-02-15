@echo off
wsl make
wsl rm "build/bios-htc.img.lock"
bochsdbg -q -f .\bochs_config