# ICS3203-CAT2-Assembly-KariukiMaryAnne-147735

## Overview
This repository contains assembly programs created for the ICS3203 CAT2 assignment. Each program demonstrates key assembly language concepts and solutions to the tasks provided in the assessment.

Each program file is thoroughly documented with detailed comments explaining the purpose, functionality, and logic of key sections and functions. These comments provide clarity on the program's flow, decision-making processes, and technical implementation, ensuring the code is easy to understand and maintain.

## Program 1: Control Flow and Conditional Logic

### Overview
`classify_number` determines whether a user-provided integer is positive, negative, or zero. This program uses basic branching to compare values and produce the correct classification.

### Compilation and Execution
1. Assemble the program:
   ```bash
   nasm -f elf32 classify_number.asm -o classify_number.o
2. Link the object file:
   ```bash
   gcc -m32 classify_number.o -o classify_number -nostartfiles
3. Run the program:
   ```bash
   ./classify_number

### Insights and Challenges
- **Signed comparison:** Managing signed values was essential for accurate classification.
- **Branching logic:** Writing clear and efficient jump instructions was critical to avoid overlapping conditions.
- Debugging revealed the need for careful management of registers to prevent overwriting values during classification.

## Program 2: Array Manipulation with Looping and Reversal

### Overview
`reverse_array` takes an array of integers as input and outputs the reversed version of the array. It uses loops, indexing, and in-place reversal to optimize memory usage.

### Compilation and Execution
1. Assemble the program:
   ```bash
   nasm -f elf32 reverse_array.asm -o reverse_array.o
2. Link the object file:
   ```bash
   gcc -m32 reverse_array.o -o reverse_array -nostartfiles
3. Run the program:
   ```bash
   ./reverse_array

### Insights and Challenges
- **Memory indexing:** Properly calculating offsets for array elements was challenging and required careful management of registers.
- **Loop control:** Ensuring correct termination of the reversal loop was critical to avoid out-of-bounds errors.
- Encountered a segmentation fault during debugging, which underscored the importance of bounds checking.

## Program 3: Modular Program with Subroutines for Factorial Calculation

### Overview
`factorial` computes the factorial of a user-provided integer using a modular subroutine. The program demonstrates the use of the stack for saving and restoring registers.

### Compilation and Execution
1. Assemble the program:
   ```bash
    nasm -f elf32 factorial.asm -o factorial.o
2. Link the object file:
   ```bash
   gcc -m32 factorial.o -o factorial -nostartfiles
3. Run the program:
   ```bash
   ./factorial

### Insights and Challenges
- **Stack operations:** Correctly saving and restoring registers was crucial to maintain modularity and avoid overwriting data.
- **Base case handling:** Factorial(0) = 1 required explicit initialization to ensure correctness.
- Debugging recursive logic involved carefully managing return addresses on the stack to prevent infinite loops or crashes.

## Program 4: Data Monitoring and Control Using Port-Based Simulation

### Overview
`control_program` simulates a control system that:
- Reads a simulated "sensor value" from a memory location.
- Activates a "motor" if the sensor value indicates a moderate level.
- Triggers an "alarm" if the value is too high.
- Stops the motor if the value is low.

The program demonstrates control flow, decision-making, and memory manipulation.

### Compilation and Execution
1. Assemble the program:
   ```bash
   nasm -f elf32 control_program.asm -o control_program.o
2. Link the object file:
   ```bash
   gcc -m32 control_program.o -o control_program -nostartfiles
3. Run the program:
   ```bash
   ./control_program

### Insights and Challenges
- **Signed comparison:** Managing signed values was essential for accurate classification.
- **Branching logic:** Writing clear and efficient jump instructions was critical to avoid overlapping conditions.
- Debugging revealed the need for careful management of registers to prevent overwriting values during classification.

### Expected Behavior
**Example Inputs and expected Outputs:**

- **Input: 80**  
  **Output:**  
  ```bash
  ALARM TRIGGERED! Water level too high.

- **Input: 50**  
  **Output:**  
  ```bash
  Motor turned ON.

- **Input: 20**  
  **Output:**  
  ```bash
  Motor turned OFF.

