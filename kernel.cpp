// kernel.cpp - Main kernel code

// VGA text mode buffer
volatile unsigned short* vga_buffer = (unsigned short*)0xB8000;
const int VGA_WIDTH = 80;
const int VGA_HEIGHT = 25;

int cursor_x = 0;
int cursor_y = 0;

void clear_screen() {
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga_buffer[i] = 0x0F00 | ' ';  // White on black
    }
    cursor_x = 0;
    cursor_y = 0;
}

void print_char(char c) {
    if (c == '\n') {
        cursor_x = 0;
        cursor_y++;
        return;
    }
    
    int index = cursor_y * VGA_WIDTH + cursor_x;
    vga_buffer[index] = 0x0F00 | c;  // White on black
    
    cursor_x++;
    if (cursor_x >= VGA_WIDTH) {
        cursor_x = 0;
        cursor_y++;
    }
}

void print(const char* str) {
    for (int i = 0; str[i] != '\0'; i++) {
        print_char(str[i]);
    }
}

// Kernel entry point
extern "C" void kernel_main(unsigned int magic, unsigned int addr) {
    clear_screen();
    
    print("Welcome to MyOS!\n");
    print("Kernel is running...\n");
    
    if (magic != 0x2BADB002) {
        print("ERROR: Invalid Multiboot magic number!\n");
    } else {
        print("Multiboot successful!\n");
    }
    
    // Kernel main loop
    while (1) {
        // Halt CPU until next interrupt
        asm volatile("hlt");
    }
}