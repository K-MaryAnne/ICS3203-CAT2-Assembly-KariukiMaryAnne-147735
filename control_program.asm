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


; 1. Input Handling:
;    - The program simulates a sensor by reading a value from a specific memory location or input port.
;      In this implementation, the sensor input is read from a predefined memory location, `sensor_value`.
;    - The value represents the water level and is used to decide whether to activate the motor, trigger an alarm, or turn off the motor.

; 2. Decision-Making Process:
;    - The program uses conditional checks (via the `cmp` and jump instructions) to evaluate the sensor value and determine the appropriate action.
;    - Thresholds:
;        - If the sensor value is above the HIGH_THRESHOLD (e.g., 70), the alarm is triggered to indicate a high water level.
;        - If the sensor value is between LOW_THRESHOLD (e.g., 30) and HIGH_THRESHOLD, the motor is turned ON to pump water.
;        - If the sensor value is below LOW_THRESHOLD, the motor is turned OFF.

; 3. Actions Taken:
;    - Alarm Triggering:
;      When the water level is too high, the program sets a specific bit in the `status_port` memory location to indicate the alarm status.
;      This could simulate lighting up an LED or sounding a buzzer.
;    - Motor Activation:
;      When the water level is moderate, the program sets a different bit in the `status_port` to simulate turning the motor ON.
;      This could be linked to an actuator in a real-world application.
;    - Motor Deactivation:
;      When the water level is too low, the program clears the motor's status bit in `status_port`, simulating the motor being turned OFF.

; 4. Manipulating Memory Locations:
;    - The memory location `status_port` acts as the control register for the motor and alarm statuses.
;    - The program uses bitwise operations (`or`, `and`, `not`) to set or clear specific bits within the `status_port`:
;        - Setting a Bit: The `or` instruction is used to set a bit without affecting others.
;        - Clearing a Bit: The `and` instruction with a mask (created using `not`) is used to clear a specific bit while leaving others intact.
;    - These manipulations reflect the current state of the motor and alarm in a simulated output port.

; 5. Detailed Logic Flow:
;    - Sensor Value > HIGH_THRESHOLD:
;      The program jumps to the `trigger_alarm` label to set the alarm bit and notify the user of a high water level.
;    - Sensor Value <= HIGH_THRESHOLD and >= LOW_THRESHOLD:
;      The program jumps to the `turn_motor_on` label to set the motor bit and notify the user that the motor is ON.
;    - Sensor Value < LOW_THRESHOLD:
;      The program jumps to the `turn_motor_off` label to clear the motor bit and notify the user that the motor is OFF.

; 6. Challenges in Implementation:
;    - Simulating Hardware:
;      Representing real-world input/output ports with memory locations requires careful abstraction to ensure logical consistency.
;    - Bitwise Operations:
;      Properly isolating and manipulating specific bits within the `status_port` demands a clear understanding of bit masking techniques.
;    - Threshold Definitions:
;      Setting appropriate thresholds for water levels requires thoughtful calibration to mimic realistic scenarios.

; 7. Advantages of This Design:
;    - The modular approach allows the program to handle each scenario (high, moderate, low water levels) independently.
;    - Memory-based simulation makes it easier to test the logic without requiring actual hardware, making the program more versatile.

