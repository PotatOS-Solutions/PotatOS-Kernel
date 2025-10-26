AS = nasm
CC = g++
LD = ld

ASFLAGS = -f elf32
CFLAGS = -m32 -ffreestanding -fno-exceptions -fno-rtti -nostdlib -Wall -Wextra
LDFLAGS = -m elf_i386 -T linker.ld

OBJECTS = boot.o kernel.o

all: myos.iso

boot.o: boot.asm
	$(AS) $(ASFLAGS) boot.asm -o boot.o

kernel.o: kernel.cpp
	$(CC) $(CFLAGS) -c kernel.cpp -o kernel.o

kernel.bin: $(OBJECTS)
	$(LD) $(LDFLAGS) $(OBJECTS) -o kernel.bin

myos.iso: kernel.bin
	mkdir -p isodir/boot/grub
	cp kernel.bin isodir/boot/kernel.bin
	echo 'set timeout=0' > isodir/boot/grub/grub.cfg
	echo 'set default=0' >> isodir/boot/grub/grub.cfg
	echo 'menuentry "MyOS" {' >> isodir/boot/grub/grub.cfg
	echo '    multiboot /boot/kernel.bin' >> isodir/boot/grub/grub.cfg
	echo '    boot' >> isodir/boot/grub/grub.cfg
	echo '}' >> isodir/boot/grub/grub.cfg
	grub-mkrescue -o myos.iso isodir

run: myos.iso
	qemu-system-i386 -cdrom myos.iso

clean:
	rm -f *.o kernel.bin myos.iso
	rm -rf isodir

.PHONY: all run clean