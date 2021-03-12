.global main

increment:
   incq (%rbx)

decrement:
   decq (%rbx)

incPointer:
   incq %rbx

decPointer:
   decq %rbx

BFprint:
   movq (%rbx), %rax
   pushq %rax
   call putchar

BFscan:
   call getchar
   popq %rax
   movq %rax, (%rbx)

main:

   call exit
   