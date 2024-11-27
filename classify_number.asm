section .data
    prompt_msg db "Enter a number: ", 0
    pos_msg db "The number is POSITIVE", 0
    neg_msg db "The number is NEGATIVE", 0
    zero_msg db "The number is ZERO", 0

section .bss
    input resb 4   ; Reserve 4 bytes for user input

section .text
    global _start

_start:
    ; Prompt user to enter a number
    mov eax, 4                ; sys_write
    mov ebx, 1                ; file descriptor (stdout)
    mov ecx, prompt_msg       ; message to write
    mov edx, 15               ; message length
    int 0x80                  ; call kernel

    ; Read user input
    mov eax, 3                ; sys_read
    mov ebx, 0                ; file descriptor (stdin)
    mov ecx, input            ; buffer to store input
    mov edx, 4                ; maximum input length
    int 0x80                  ; call kernel

    ; Convert input from ASCII to integer
    mov eax, [input]          ; move input into eax
    sub eax, '0'              ; convert ASCII to integer

    ; Classification: Check if the number is positive, negative, or zero
    cmp eax, 0                ; compare input with zero
    je is_zero                ; jump to is_zero if eax == 0
    jl is_negative            ; jump to is_negative if eax < 0
    jg is_positive            ; jump to is_positive if eax > 0

is_positive:
    ; Print "The number is POSITIVE"
    mov eax, 4                ; sys_write
    mov ebx, 1                ; file descriptor (stdout)
    mov ecx, pos_msg          ; message to write
    mov edx, 22               ; message length
    int 0x80                  ; call kernel
    jmp done                  ; unconditional jump to done

is_negative:
    ; Print "The number is NEGATIVE"
    mov eax, 4                ; sys_write
    mov ebx, 1                ; file descriptor (stdout)
    mov ecx, neg_msg          ; message to write
    mov edx, 22               ; message length
    int 0x80                  ; call kernel
    jmp done                  ; unconditional jump to done

is_zero:
    ; Print "The number is ZERO"
    mov eax, 4                ; sys_write
    mov ebx, 1                ; file descriptor (stdout)
    mov ecx, zero_msg         ; message to write
    mov edx, 18               ; message length
    int 0x80                  ; call kernel

done:
    ; Exit program
    mov eax, 1                ; sys_exit
    xor ebx, ebx              ; exit code 0
    int 0x80                  ; call kernel


; ---
; Explanation of the Jump Instructions:
; ---
; cmp eax, 0: This instruction compares the value of eax (the user input, converted to an integer) with 0.
; Based on the comparison, the program will determine whether the number is positive, negative, or zero.
;
; je is_zero: The je (jump if equal) instruction is used here because if the comparison cmp eax, 0 finds that eax is equal to 0 
; (i.e., the input number is zero), it will jump to the is_zero label to print the "ZERO" message.
;
; jl is_negative: The jl (jump if less) instruction is used if the comparison shows that eax is less than 0 (i.e., 
; the input number is negative). This jump leads the program to the is_negative label where the "NEGATIVE" message will be printed.
;
; jg is_positive: The jg (jump if greater) instruction is used if the number is positive (i.e., if eax is greater than 0). 
; This leads to the is_positive label where the "POSITIVE" message will be printed.
;
; jmp done: The jmp (unconditional jump) instruction is used to skip over the other labels and jump to the done label, which ends the program. 
; This ensures that after printing the appropriate message, the program exits cleanly without checking other conditions unnecessarily.
;
; Why use these jump instructions:
; The je, jl, and jg instructions are specifically used to control the flow based on the result of the comparison (cmp eax, 0),
; and they allow the program to branch to different sections to print the appropriate message for positive, negative, or zero numbers.
;
; The jmp done instruction is used to avoid redundant checks after the message has been printed,
; thereby preventing the program from executing unnecessary code and ensuring an efficient flow of control.
