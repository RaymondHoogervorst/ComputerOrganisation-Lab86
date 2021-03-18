.bss
VARIABLES: .skip 4069 # reserving space for BF numbers
LOOPRETURNS: .skip 1024 # reserving space for loop return adresses

.global brainfuck

.text

# brainfuck functions
BFincrement:
   incq %rax
   jmp beginloop

BFdecrement:
   decq %rax
   jmp beginloop

BFincPointer:
   movq %rax, VARIABLES(%rbx)
BFincPointerRepeat:
   addq $8, %rbx
   movq VARIABLES(%rbx), %rax
   jmp BFpointermoveloop

BFdecPointer:
   movq %rax, VARIABLES(%rbx)
BFdecPointerRepeat:
   subq $8, %rbx
   movq VARIABLES(%rbx), %rax

BFpointermoveloop:
   incq %rdi

   cmpb $62, (%rdi)
   je BFincPointerRepeat

   cmpb $60, (%rdi)
   je BFdecPointerRepeat

BFpontermoveend:
   decq %rdi
   movq VARIABLES(%rbx), %rax
   jmp beginloop


BFprint:
	pushq %rdi
	movq %rax, %rdi
	pushq %rbx
	pushq %r10
	pushq %rbp
	movq %rsp, %rbp
	call putchar
	movq %rbp, %rsp
	popq %rbp
	popq %r10
	popq %rbx
	popq %rdi
	jmp beginloop

BFscan:
   pushq %rdi
   pushq %rbx
   pushq %r10
   pushq %rbp
   movq %rsp, %rbp
   call getchar
   movq %rbp, %rsp
   popq %rbp
   popq %r10
   popq %rbx
   popq %rdi
   jmp beginloop

BFstartloop:
	movq $1, %r8
   cmpq $0, %rax
   je BFskiploop
   break:
   movq %rdi, LOOPRETURNS(%r10)
   addq $8, %r10
   jmp beginloop
BFskiploop:             # skipping loop if value is already zero
   incq %rdi

   cmpb $91, (%rdi)
   je BFinloop

   cmpb $93, (%rdi)
   je BFoutloop

   jmp BFskiploop

BFskipcheck:            # checking if corresponding closing ']' has been found
   cmpq $0, %r8
   je beginloop
   jmp BFskiploop

BFinloop:
   incq %r8
   jmp BFskipcheck

BFoutloop:
   decq %r8
   jmp BFskipcheck


BFendloop:                             # checking if loop can be exited
   cmpq $0, %rax
   je BFexitloop
   movq LOOPRETURNS-8(%r10), %rdi
   jmp beginloop
BFexitloop:                            # exiting loop
   subq $8, %r10
   jmp beginloop

brainfuck:
	pushq %rbp
	movq %rsp, %rbp

	# initializing pointers and pointer value
   movq $0, %r10
   movq $0, %rbx
   movq $0, %rax
	decq %rdi

   # loop iteration over the Brainfuck characters
	beginloop:
		incq %rdi

      # checking if the char read corresponds to any of the instructions
      cmpb $43, (%rdi)
      je BFincrement

      cmpb $45, (%rdi)
      je BFdecrement

      cmpb $62, (%rdi)
      je BFincPointer

      cmpb $60, (%rdi)
      je BFdecPointer

		cmpb $0, (%rdi)
		je end

      cmpb $46, (%rdi)
      je BFprint

      cmpb $44, (%rdi)
      je BFscan

      cmpb $91, (%rdi)
      je BFstartloop

      cmpb $93, (%rdi)
      je BFendloop

      # moving on if character is not recognized
		jmp beginloop

   # exiting
	end:
	movq %rbp, %rsp
	popq %rbp
	ret



# To test the speed on the program we will use sierpinski and mandlebrot in the examples. We use multiple programs because the speed improvements may heavily rely on the type of code.
# We also tried using Hanoi but

# The null test (no improvements made) resulted in the following runtimes:
# sierpinski: 0.012 seconds 
# mandlebrot: 15.810 seconds
# hanoi: 9.939 seconds

# -------------------------------------------------------------------------------------------------------------------------------------------------------

# The first improvement we will try has to do with how we handle the pointer. We noticed that repeated '+' and '-' instructions are common.
# It is quite inefficient to adress the memory every time we want to increment and decrement the value, even with cache.
# We want to try to store the current pointer value into a register, and only access memory when we change the pointer %rbx
# We will store the pointer value into %rax

# After succesfully implementing these improvements, the runtimes were:
# sierpinski: 0.011 seconds
# mandelbrot: 16.048 seconds
# hanoi: 7.534 seconds

# It is clear that it depends quite a bit on the specific type of code on wether this adjustment improves runtime or not. Mandelbrot for example contained many pointer adjustments ('>' and '<').
# These pointer inc/decrements to get slower for having to access memory twice. The former '+' and '-' function also accessed memory twice, so this is mainly moving the stress.
# and was especially slow in the middle while being faster near the beginning and end. While hanoi, a program containing relativley many '+' and '-' instructions. In the end we agreed
# this adjustement is worth it since '>' and '<' are the only two instructions that are now slower while every other instruction has been improved.

# -------------------------------------------------------------------------------------------------------------------------------------------------------
# When looking at code, it stands out that the increment and decrement commands of both values and pointers often appear multiple times after eachother. We could try and scan these sequences of code
# and then add or subtract all at once. We will be using %r8 to keep track of the count and then just iterate until we find a different character.
# We quickly realised that doing this for '+' and '-' would not really be that beneficial. Since we still would have to increment %8 every time, and we might as well increment the value itself.
# This also changed the way we were going to improve '<' and '>' since we can just increase and decrease the pointer immediatley and only adjust the memory at the end. This does save
# time because it reduces memory stalls.

# After succesfully implementing these improvements, the runtimes were:
# sierpinski: 0.011 seconds
# mandelbrot: 14.609 seconds
# hanoi: 7.380 seconds
