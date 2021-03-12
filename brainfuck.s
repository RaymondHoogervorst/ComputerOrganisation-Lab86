.global main

increment:
   incq (%rbx)
   ret

decrement:
   decq (%rbx)
   ret

incPointer:
   incq %rbx
   ret

decPointer:
   decq %rbx
   ret

BFprint:
   movq (%rbx), %rdi
   call putchar
   ret

BFscan:
   call getchar
   movq %rax, (%rbx)
   ret

main:

   movq $0, %rdi
   call exit
   