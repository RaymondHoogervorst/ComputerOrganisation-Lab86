.data
outputstr: .asciz "Assignment 3: power\n"
baseask: .asciz "Please enter base: "
expoask: .asciz "Please enter exponent: "
inputformat: .asciz "%d"
outputformat: .asciz "The power is %d\n"

.global main

.text
# ***********************************************************
# * Subroutine : scangood                                   *
# * Arguments :                                             *
#        =inputformat: the format of the given input        *
#        =adress: the adress to store the input on          *
#        =guidetext: the text appearing before the input    *
# * Description: uses scanf to get user input onto adress   *
# ***********************************************************
scangood:
   pushq %rbp;                #stack preparation
   movq %rsp, %rbp         

   pushq %rsi                 #saving parameters for scanf
   pushq %rdi

   movq %rdx, %rdi
   call printf

   popq %rdi
   popq %rsi

   movq $0, %rax
   call scanf                 #calling scanf
   movq %rbp, %rsp            #stack restoring for scanf (not included in subroutine itself)
   popq %rbp          
   ret


# ***********************************************************
# * Subroutine : power                                      *
# * Arguments :                                             *
#        =base: the base of the power                       *
#        =exponent: the exponent of the power               *
# * Description: takes th  *                                *
# ***********************************************************
power:
   pushq %rbp;                #storing old base pointer
   movq %rsp, %rbp            #setting new base pointer

   movq $1, %rax              #setting product at 1

   startloop:
      cmpq $0, %rsi           #checking escape condition
      jle endloop

      mulq %rdi               #multiplying the product with the base
      decq %rsi               #counting down the exponent

      jmp startloop           #repeating loop
   endloop:

   movq $outputformat, %rdi
   movq %rax, %rsi
   movq $0, %rax
   call printf

   movq %rbp, %rsp            #placing back stack pointer
   popq %rbp                  #placing back base pointer      
   ret


main: #entry point
   pushq %rbp                 #storing old base pointer
   movq %rsp, %rbp            #setting new base pointer

   movq $0, %rax              #no vector registers used
   movq $outputstr, %rdi      #set adress of string
   call printf                #call subroutine to display message

   subq $16, %rsp             #reserving space
   leaq -16(%rbp), %rsi         
   movq $inputformat, %rdi
   movq $baseask, %rdx
   call scangood
   leaq -8(%rbp), %rsi         
   movq $inputformat, %rdi
   movq $expoask, %rdx
   call scangood

   popq %rdi                  #storing input in register
   popq %rsi                  

   call power

end:
   mov $0, %rdi
   call exit
