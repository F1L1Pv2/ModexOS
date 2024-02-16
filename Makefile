ASM=nasm
SRC_DIR=src
BUILD_DIR=build

.PHONY: all bios-htc kernel bootloader clean always

bios-htc: $(BUILD_DIR)/bios-htc.img

$(BUILD_DIR)/bios-htc.img: bootloader kernel
	dd if=/dev/zero of=$(BUILD_DIR)/bios-htc.img bs=1024 count=10240
	mkfs.fat -F 16 -n "NBOS" $(BUILD_DIR)/bios-htc.img
	# dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/bios-htc.img conv=notrunc
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/bios-htc.img conv=notrunc bs=1 count=3
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/bios-htc.img conv=notrunc bs=1 skip=62 seek=62
	mcopy -i $(BUILD_DIR)/bios-htc.img $(BUILD_DIR)/kernel.bin "::kernel.bin"

bootloader: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: always
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin 

kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin -I $(SRC_DIR)/kernel

always:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)/*