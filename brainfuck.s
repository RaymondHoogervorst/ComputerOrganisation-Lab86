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
   movq (%rbx), %rdi
   call putchar

BFscan:
   call getchar
   movq %rax, (%rbx)

main:

   movq $0, %rdi
   call exit
   