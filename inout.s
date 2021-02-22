.data
outputstr: .asciz "Assignment 2: inout\n"
inputformat: .asciz "%d"
outputformat: .asciz "%d\n"

.global main

.text
# ***********************************************************
# * Subroutine : inout                                      *
# * Description: asks for user input and returns increment  *
# ***********************************************************
inout:
   pushq %rbp;             #storing old base pointer
   movq %rsp, %rbp         #setting new base pointer

   subq $8, %rsp           #setting parameters for scanf
   leaq -8(%rbp), %rsi
   movq $inputformat, %rdi
   movq $0, %rax
   pushq %rbp;             #stack preparation for scanf (not included in subroutine itself)
   movq %rsp, %rbp         
   call scanf              #calling scanf
   movq %rbp, %rsp         #stack restoring for scanf (not included in subroutine itself)
   popq %rbp                   

   popq %rsi               #computing output value
   incq %rsi

   movq $0, %rax           #printing output
   movq $outputformat, %rdi
   call printf

   movq %rbp, %rsp         #placing back stack pointer
   popq %rbp               #placing back base pointer      
   ret


main: #entry point
   pushq %rbp              #storing old base pointer
   movq %rsp, %rbp         #setting new base pointer

   movq $0, %rax           #no vector registers used
   movq $outputstr, %rdi   #set adress of string
   call printf             #call subroutine to display message

   call inout              #calling selfmade function


end:
   mov $0, %rdi
   call exit
