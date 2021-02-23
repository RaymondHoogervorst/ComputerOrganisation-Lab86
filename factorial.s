.data
outputstr: .asciz "Assignment 2: inout\n"
inputlabel: .asciz "Please enter a number: "
inputformat: .asciz "%d"
outputformat: .asciz "%d\n"

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

   movq %rdx, %rdi            #printing input message
   movq $0, %rax
   call printf

   popq %rdi                  #taking back scanf parameters
   popq %rsi

   movq $0, %rax
   call scanf                 #calling scanf

   movq %rbp, %rsp            #stack restoring for scanf (not included in subroutine itself)
   popq %rbp          
   ret

# ***********************************************************
# * Subroutine : inout                                      *
# * Description: asks for user input and returns increment  *
# ***********************************************************
inout:
   pushq %rbp;             #storing old base pointer
   movq %rsp, %rbp         #setting new base pointer

   subq $16, %rsp             #calling input
   leaq -16(%rbp), %rsi         
   movq $inputformat, %rdi
   movq $inputlabel, %rdx
   call scangood

   popq %rdi               #computing value
   call factorial
   movq %rax, %rsi

   movq $0, %rax              #no vector registers used
   movq $outputformat, %rdi      #set adress of string
   call printf                #call subroutine to display message

   movq %rbp, %rsp         #placing back stack pointer
   popq %rbp               #placing back base pointer      
   ret


# ***********************************************************
# * Subroutine : factorial                                   *
# * Arguments :                                             *
#        =number: the number to create the factorial of     *
# * Description: calculates and returns a factorial         *
# ***********************************************************
factorial:
   cmpq $1, %rdi
   jle basecase

   pushq %rdi        #executing factorial with decremented input
   decq %rdi
   call factorial
   popq %rdi

   mulq %rdi        #multipling decremented factorial with input
   ret

basecase:
   movq $1, %rax
   ret


main: #entry point
   pushq %rbp                 #storing old base pointer
   movq %rsp, %rbp            #setting new base pointer

   movq $0, %rax              #no vector registers used
   movq $outputstr, %rdi      #set adress of string
   call printf                #call subroutine to display message

   call inout

   popq %rdi                  #storing input in register
   popq %rsi         


end:
   mov $0, %rdi
   call exit
