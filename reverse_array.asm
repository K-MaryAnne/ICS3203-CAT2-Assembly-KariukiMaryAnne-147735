section .data
    prompt_msg db "Enter five integers separated by spaces: ", 0
    input_fmt db "%d %d %d %d %d", 0  ; format for scanf to read 5 integers
    output_msg db "Reversed array: ", 0
    output_fmt db "%d ", 0            ; format for printf to display each integer

section .bss
    array resd 5                      ; Reserve space for 5 integers

section .text
    extern printf, scanf
    global _start

_start:
    ; Prompt user to enter integers
    push prompt_msg
    call printf
    add esp, 4                        ; Clean up stack after printf call

    ; Read integers into array using scanf
    push array + 16                   ; Pushing addresses of each array element
    push array + 12
    push array + 8
    push array + 4
    push array
    push input_fmt
    call scanf
    add esp, 24                       ; Clean up stack after scanf call

    ; Initialize pointers and indices for in-place reversal
    mov ecx, 2                        ; Loop counter, array length / 2
    mov esi, array                    ; Start of array
    mov edi, array + 16               ; End of array (4-byte elements, so 4 * 4)

reverse_loop:
    ; Swap array[esi] and array[edi]
    mov eax, [esi]                    ; Load element at start into eax
    mov ebx, [edi]                    ; Load element at end into ebx
    mov [esi], ebx                    ; Store end element at start
    mov [edi], eax                    ; Store start element at end

    ; Move pointers closer to the center
    add esi, 4                        ; Move start pointer to the next element
    sub edi, 4                        ; Move end pointer to the previous element

    ; Decrement counter and loop if not done
    loop reverse_loop

    ; Output the reversed array
    push output_msg
    call printf
    add esp, 4                        ; Clean up stack after printf call

    ; Print each integer in reversed array using a loop
    mov ecx, 5                        ; Set loop counter for array length
    mov esi, array                    ; Set pointer to start of array

print_loop:
    push dword [esi]                  ; Push the current element for printf
    push output_fmt
    call printf
    add esp, 8                        ; Clean up stack after printf call

    add esi, 4                        ; Move pointer to next element
    loop print_loop                   ; Repeat until all elements printed

    ; Exit program
    mov eax, 1                        ; sys_exit
    xor ebx, ebx                      ; exit code 0
    int 0x80                          ; call kernel
