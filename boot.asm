; boot.asm - Kernel entry point with Multiboot header

MULTIBOOT_MAGIC equ 0x1BADB002
MULTIBOOT_FLAGS equ 0x0
MULTIBOOT_CHECKSUM equ -(MULTIBOOT_MAGIC + MULTIBOOT_FLAGS)

section .multiboot
align 4
    dd MULTIBOOT_MAGIC
    dd MULTIBOOT_FLAGS
    dd MULTIBOOT_CHECKSUM

section .bss
align 16
stack_bottom:
    resb 16384  ; 16 KB stack
stack_top:

section .text
global _start
extern kernel_main

_start:
    mov esp, stack_top  ; Set up stack
    
    push ebx            ; Multiboot info structure
    push eax            ; Multiboot magic number
    
    call kernel_main    ; Jump to C++ kernel
    
    cli                 ; Disable interrupts
.hang:
    hlt                 ; Halt CPU
    jmp .hang          ; In case of NMI