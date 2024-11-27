section .data
    prompt db "Enter a number to calculate its factorial: ", 0
    result_msg db "The factorial is: %d", 10, 0 ; Print result with newline
    format_in db "%d", 0

section .bss
    number resd 1 ; Reserve space for input number

section .text
    extern printf, scanf
    global _start

_start:
    ; Prompt user for input
    push prompt
    call printf
    add esp, 4

    ; Read input
    push number
    push format_in
    call scanf
    add esp, 8

    ; Load the input number into eax
    mov eax, [number]

    ; Check for valid input
    cmp eax, 0
    jl .exit ; If number < 0, exit (no factorial for negative numbers)

    ; Call factorial subroutine
    push eax       ; Push input number onto the stack
    call factorial ; Call the subroutine
    add esp, 4     ; Clean up the stack after the call

    ; Print the result
    push eax       ; Push the factorial result
    push result_msg
    call printf
    add esp, 8

.exit:
    ; Exit program
    mov eax, 1          ; syscall: exit
    xor ebx, ebx        ; status: 0
    int 0x80            ; invoke syscall

; Factorial subroutine
factorial:
    push ebp          ; Preserve base pointer
    mov ebp, esp      ; Set up stack frame
    push ebx          ; Preserve ebx register (used for loop)

    mov eax, [ebp+8]  ; Get the input number from the stack
    cmp eax, 1        ; Check if the number is <= 1
    jle .base_case    ; If yes, return 1 as factorial(0) or factorial(1)

    ; Recursive case
    dec eax           ; Decrement eax (n - 1)
    push eax          ; Push n-1 onto the stack
    call factorial    ; Recursive call
    add esp, 4        ; Clean up the stack after the call

    mov ebx, [ebp+8]  ; Get the original number (n)
    mul ebx           ; Multiply eax (result of factorial(n-1)) by n
    jmp .end          ; Skip to the end

.base_case:
    mov eax, 1        ; Return 1 for factorial(0) or factorial(1)

.end:
    pop ebx           ; Restore ebx
    pop ebp           ; Restore base pointer
    ret               ; Return to caller
