# A terminal calculator
#
# Reads a line of input, interprets it as a simple arithmetic expression,
# and prints the result. The input format is
# <long_integer> <operation> <long_integer>

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

main:
  # Function prologue
  enter $0, $0

  # Use scanf to retrieve and process a line of input
  # This block implements the following line of C code: 
  #   scanf("%ld %c %ld", &a, &op, &b);
  # Take a look at the man page for scanf and ask questions. You can also look 
  # at scanf_example.c
  movq $scanf_fmt, %rdi
  movq $a, %rsi
  movq $op, %rdx
  movq $b, %rcx
  xorb %al, %al
  call scanf

  movb op, %r8b
  movq a, %r9

cmpb $'+', %r8b
je add_op

cmpb $'-', %r8b
je sub_op

cmpb $'*', %r8b
je mul_op

cmpb $'/', %r8b
je div_op

jmp unknown_op

add_op:
	addq b, %r9
	jmp print_result

sub_op:
	subq b, %r9
	jmp print_result
mul_op:
	imulq b, %r9
	jmp print_result

div_op:
	cmpq $0, b
	je division_error

	movq %r9, %rax
	cqto

	idivq b

	movq %rax, %r9
	jmp print_result

print_result:
	movq  $output_fmt, %rdi
	movq %r9, %rsi
	xorb %al, %al
	call printf

	movq $0, %rax
	leave
	ret

unknown_op:
	movq $unknown_msg, %rdi
        xorb %al, %al
        call printf

        movq $1, %rax
        leave
        ret

division_error:
	movq $division_msg, %rdi
	xorb %al, %al
	call printf

	movq $1, %rax
	leave
	ret

  # if (op_char == '+') {
  #   ...
  # }
  # else if (op_char == '-') {
  #  ...
  # }
  # ...
  # else {
  #   // print error
  #   // return 1 from main
  # }

  # Function epilogue
  leave
  ret


# Start of the data section
.data

output_fmt: 
  .asciz "%ld\n"
unknown_msg:
  .asciz "Unknown operation\n"
division_msg:
  .asciz "Divided by 0\n"
scanf_fmt: 
  .asciz "%ld %c %ld"  # TODO: modify as needed

# "Slots" for scanf
a:  .quad 0
b:  .quad 0
op: .byte 0

