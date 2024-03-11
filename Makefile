ASM=fasm
SRC_DIR=src
BUILD_DIR=build

.PHONY: all bios-htc kernel bootloader stage2 clean always

bios-htc: $(BUILD_DIR)/modex.img

$(BUILD_DIR)/modex.img: bootloader kernel stage2
	dd if=/dev/zero of=$(BUILD_DIR)/modex.img bs=1024 count=10240
	mkfs.fat -R 10 -F 16 -n "MXOS" $(BUILD_DIR)/modex.img
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/modex.img conv=notrunc bs=1 count=3
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/modex.img conv=notrunc bs=1 skip=62 seek=62
	dd if=$(BUILD_DIR)/stage2.bin of=$(BUILD_DIR)/modex.img conv=notrunc bs=1 seek=512 conv=notrunc
	mcopy -i $(BUILD_DIR)/modex.img $(BUILD_DIR)/kernel.bin "::kernel.bin"

stage2: $(BUILD_DIR)/stage2.bin

$(BUILD_DIR)/stage2.bin: always
	$(ASM) $(SRC_DIR)/bootloader/stage2.asm $(BUILD_DIR)/stage2.bin


bootloader: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: always
	$(ASM) $(SRC_DIR)/bootloader/boot.asm $(BUILD_DIR)/bootloader.bin 

kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/main.asm $(BUILD_DIR)/kernel.bin

always:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)/*