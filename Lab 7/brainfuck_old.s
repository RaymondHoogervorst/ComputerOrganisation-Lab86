.bss
VARIABLES: .skip 400 # reserving space for BF numbers
LOOPRETURNS: .skip 100 # reserving space for loop return adresses


.data
strformat: .asciz "HELLO"
inputformat: .asciz "%d\n"

.global main

# Register use overview
# %rbx = the pointer used by brainfuck
# %rcx = program counter for the BF chars
# %r10 = pointer to loop returns

.text

BFincrement:
   incq VARIABLES(%rbx)
   jmp beginloop

BFdecrement:
   decq VARIABLES(%rbx)
   jmp beginloop

BFincPointer:
   incq %rbx
   jmp beginloop

BFdecPointer:
   decq %rbx
   jmp beginloop

BFprint:
   movq VARIABLES(%rbx), %rdi
   pushq %rcx
   pushq %rbx
   pushq %r10
   pushq %rbp
   movq %rsp, %rbp
   call putchar
   movq %rbp, %rsp
   popq %rbp
   popq %r10
   popq %rbx
   popq %rcx
   jmp beginloop

BFscan:
   pushq %rcx
   pushq %rbx
   pushq %r10
   pushq %rbp
   movq %rsp, %rbp
   call getchar
   movq %rbp, %rsp
   popq %rbp
   popq %r10
   popq %rbx
   popq %rcx
   movq %rax, VARIABLES(%rbx)
   jmp beginloop

# TODO make loop skip if value is already 0
BFstartloop:
   cmpq $0, VARIABLES(%rbx)
   movq $1, %r9
   je BFskiploop
   movq %rcx, LOOPRETURNS(%r10)
   addq $8, %r10
   jmp beginloop
BFskiploop:          # skipping loop if value is already zero
   subq $8, %rcx

   cmpq $91, (%rcx)
   je BFinloop

   cmpq $93, (%rcx)
   je BFoutloop

   jmp BFskiploop

BFskipcheck:
   cmpq $0, %r9
   je beginloop
   jmp BFskiploop

BFinloop:
   incq %r9
   jmp BFskipcheck

BFoutloop:
   decq %r9
   jmp BFskipcheck


BFendloop:
   cmpq $0, VARIABLES(%rbx)
   je BFexitloop
   movq LOOPRETURNS-8(%r10), %rcx
   jmp beginloop
BFexitloop:
   subq $8, %r10
   jmp beginloop

main:
   pushq %rbp
   movq %rsp, %rbp
   movq %rsp, %rcx

   # TODO push BF code onto stack
   pushq $62
   pushq $43
   pushq $43
   pushq $43
   pushq $43
   pushq $43
   pushq $43
   pushq $43
   pushq $43
   pushq $43
   pushq $91
   pushq $60
   pushq $43
   pushq $43
   pushq $43
   pushq $43
   pushq $43
   pushq $43
   pushq $43
   pushq $43
   pushq $62
   pushq $45
   pushq $93
   pushq $60
   pushq $46


   # checking if additional push is needed to prevent seg faults
   movb %spl, %dil
   shlb $4, %dil
   cmpb $0, %dil
   jne initialize
      subq $8, %rsp

   initialize:
   pushq %rbp
   movq %rsp, %rbp

   movq $0, %r10
   movq $0, %rbx  # initializing pointers
   
   beginloop:
      subq $8, %rcx

      # checking what char to execute
      movq (%rcx), %rax
      beforecomp:
      cmpq $46, (%rcx)
      je BFprint

      cmpq $44, (%rcx)
      je BFscan

      cmpq $43, (%rcx)
      je BFincrement
      
      cmpq $45, (%rcx)
      je BFdecrement

      cmpq $62, (%rcx)
      je BFincPointer

      cmpq $60, (%rcx)
      je BFdecPointer

      cmpq $91, (%rcx)
      je BFstartloop

      cmpq $93, (%rcx)
      je BFendloop

end:
   popq %rbp
   movq %rbp, %rsp

   movq $0, %rdi
   call exit
   