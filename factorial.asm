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


; Explanation of Register Management and Stack Usage in the Factorial Program:

; 1. Purpose of Register Usage:
;    - `eax`: Acts as the primary register for intermediate and final results during the factorial calculation.
;    - `ebx`: Holds the current multiplier in the recursive calculation.
;    - `ecx`: Stores the input number whose factorial is being calculated.
;    - `edx`: Reserved for general use in certain instructions or system calls.

; 2. Preserving Register Values:
;    The program uses the stack to ensure that critical register values are preserved across recursive calls.
;    This is crucial because recursive calls inherently overwrite registers, leading to loss of data without proper handling.

; 3. Stack Operations:
;    - Push: Before making a recursive call, the program pushes the values of registers (`eax`, `ebx`, `ecx`) onto the stack.
;      This saves their current state, allowing the program to restore them later.
;    - Pop: After the recursive call returns, the program pops the saved values off the stack to restore the previous state of the registers.
;      This ensures that each level of recursion operates independently without interfering with others.

; 4. Key Steps for Stack Management:
;    - Before Recursive Call:
;      The program pushes the current values of `eax`, `ebx`, and `ecx` to preserve the state of these registers.
;      This allows the program to use these registers freely during the recursive calculation without losing critical data.
;    - Recursive Execution:
;      During each recursive call, the function decrements `ecx` to calculate the factorial of `n-1`. The result is multiplied by the current
;      value of `ecx` to compute the factorial.
;    - After Recursive Call:
;      Once the recursive call returns, the program restores the original values of `eax`, `ebx`, and `ecx` from the stack using the `pop` instruction.
;      This ensures that the parent call can resume execution with its original context.

; 5. Stack Frame Structure:
;    - At each recursive level:
;      - The current state of registers is pushed onto the stack.
;      - After the recursive call, the stack is unwound using `pop` to restore the register states.
;      - The stack remains balanced, as every `push` has a corresponding `pop`.

; 6. Challenges of Stack Management:
;    - Balancing the Stack:
;      Failing to maintain a balanced stack (e.g., mismatched `push` and `pop` operations) can result in undefined behavior or program crashes.
;    - Recursive Depth:
;      Each recursive call consumes stack space. Deep recursion risks stack overflow if the input number is very large.
;    - Register Overwriting:
;      Without proper preservation, registers used during recursion might overwrite values needed in the parent call, causing incorrect results.

; 7. Benefits of This Approach:
;    - By preserving and restoring registers via the stack, the program achieves modularity, allowing each recursive call to operate independently.
;    - This method aligns with the principles of structured programming, ensuring clarity and correctness in handling recursive operations.


