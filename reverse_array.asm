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


; ---
; Explanation of the Array Reversal Process:
; ---
; 1. Loading the Array:
;    The program initializes the array in memory with predefined values. This setup is critical because it
;    provides the data that will be reversed. The array is stored in the `.data` section, which allows
;    direct access to its elements through memory addressing.

; 2. Initializing Pointers:
;    Two registers are used as pointers: one (`esi`) for the start of the array and another (`edi`) for
;    the end. The calculation for `edi` involves adding the size of the array to its base address and then
;    subtracting one element size (e.g., `byte` or `word`) to ensure `edi` points to the last valid element.

; 3. Looping Through the Array:
;    The program uses a loop to process the array from both ends simultaneously:
;    - The `esi` pointer increments from the start towards the middle.
;    - The `edi` pointer decrements from the end towards the middle.
;    The loop condition checks whether `esi` is less than `edi`. When `esi` meets or exceeds `edi`, the
;    reversal is complete.

; 4. Swapping Elements:
;    During each iteration of the loop:
;    - The value at the address pointed to by `esi` is loaded into a temporary register (`al` for bytes, for example).
;    - The value at the address pointed to by `edi` is moved into the address pointed to by `esi`.
;    - The temporary value (`al`) is then stored at the address pointed to by `edi`.
;    This swapping process ensures that the elements at the two ends of the array are exchanged.

; 5. Updating Pointers:
;    After each swap, `esi` is incremented, and `edi` is decremented to move towards the center of the array.
;    This ensures that all elements are processed in a single pass through the array.

; Challenges with Handling Memory Directly:
; 1. Memory Addressing:
;    Direct manipulation of memory addresses requires careful calculations to avoid overwriting unintended locations.
;    Errors in pointer arithmetic could lead to corrupting memory or accessing out-of-bounds areas, causing undefined behavior.

; 2. Data Alignment:
;    The array's data type determines the size of each element (e.g., `byte`, `word`, `dword`). All memory
;    accesses must respect this alignment to avoid issues with misaligned data.

; 3. Limited Debugging:
;    Debugging assembly code involving memory operations can be challenging since errors might not
;    manifest until the program runs. Tools like `gdb` or `objdump` can help, but interpreting raw
;    memory values is time-consuming.

; 4. Stack and Register Management:
;    Using temporary registers (like `al`) for swapping requires careful stack management to avoid overwriting
;    other data. It’s crucial to preserve important register values when switching between operations.

; 5. Logical End Condition:
;    Determining when to stop the loop involves comparing pointers (`esi` and `edi`). This requires precise
;    logic to ensure that the loop terminates when the array is fully reversed without skipping or repeating elements.
