# Main Program
    # This program uses a stack pointer to track subroutine calls and save data
    # The stack pointer is in r7. It is initialized to the last location in RAM
    movia r7, 319

    movia r2, MSG1          # load message 1
    movi r3, 0              # print at location 0 (line 1)
    call PrintString        # call the PrintString subroutine (defined below)

    movia r2, MSG2          # load message 2
    movi r3, 8              # print at location 8 (line 2)
    call PrintString

    exit # Stop execution

# Subroutine. Prints a string to the output
# r2 = pointer to a string
# r3 = base output offset
PrintString:
    subi r7, r7, 3          # stack positions for 3 words
    stw r2, 0(r7)           # store r2
    stw r3, 1(r7)           # store r3
    stw r4, 2(r7)           # store r4

    movia r4, 320           # base memory address. Using movia because 320 is larger than 6-bit signed
    add r3, r3, r4          # total memory address
    ldw r4, 0(r2)           # load the first character
ps_loop:
    stw r4, 0(r3)           # send character to output display
    addi r2, r2, 1          # increment string pointer
    addi r3, r3, 1          # increment memory address
    ldw r4, 0(r2)           # load the next character
    bne r4, r0, ps_loop     # break while not found a null character

    ldw r2, 0(r7)           # load original r2
    ldw r3, 1(r7)           # load original r3
    ldw r4, 2(r7)           # load original r4
    addi r7, r7, 3          # un-reserve space in stack
    ret                     # exit the subroutine

# Program data. The address is calculated by the compiler, using the 'movia' instruction
MSG1:
    .asciz hello
MSG2:
    .asciz world