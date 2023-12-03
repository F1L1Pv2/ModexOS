@echo off
nasm -f bin -o bios-htc.bin boot.asm
qemu-system-x86_64 .\bios-htc.bin