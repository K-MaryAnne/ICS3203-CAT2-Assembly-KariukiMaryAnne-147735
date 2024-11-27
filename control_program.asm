section .data
    sensor_value db 0 ; Simulated memory location for the sensor value
    motor_status db 0 ; Memory location for motor status: 0=OFF, 1=ON
    alarm_status db 0 ; Memory location for alarm status: 0=OFF, 1=ON

    prompt db "Enter sensor value (0-100): ", 0
    motor_on_msg db "Motor turned ON.", 10, 0
    motor_off_msg db "Motor turned OFF.", 10, 0
    alarm_msg db "ALARM TRIGGERED! Water level too high.", 10, 0
    format_in db "%d", 0

section .text
    extern printf, scanf
    global _start

_start:
    ; Prompt user for input
    push prompt
    call printf
    add esp, 4

    ; Read input into sensor_value
    push sensor_value
    push format_in
    call scanf
    add esp, 8

    ; Load sensor value into al
    movzx eax, byte [sensor_value] ; Load sensor value into eax (zero-extended)

    ; Check sensor value ranges and act accordingly
    cmp eax, 70        ; If sensor value > 70
    jg .trigger_alarm  ; Trigger alarm

    cmp eax, 30        ; If sensor value <= 70 and > 30
    jg .motor_on       ; Turn on motor if water level is moderate

    ; Otherwise, stop motor
    jmp .motor_off

.trigger_alarm:
    mov byte [alarm_status], 1 ; Set alarm status to ON
    mov byte [motor_status], 0 ; Turn motor OFF
    push alarm_msg
    call printf
    add esp, 4
    jmp .exit

.motor_on:
    mov byte [motor_status], 1 ; Set motor status to ON
    push motor_on_msg
    call printf
    add esp, 4
    jmp .exit

.motor_off:
    mov byte [motor_status], 0 ; Set motor status to OFF
    push motor_off_msg
    call printf
    add esp, 4

.exit:
    ; Exit program
    mov eax, 1          ; syscall: exit
    xor ebx, ebx        ; status: 0
    int 0x80            ; invoke syscall
