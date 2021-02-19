.text
outputstr: .asciz "Raymond Hoogervorst: 2691516\nErik Vunš: 2696857\n"

.global main

main: #entry point
   pushq %rbp        #setup base pointer
   movq %rsp, %rbp 

   movq $0, %rax           #no vector registers used
   movq $outputstr, %rdi   #set adress of string
   call printf             #call subroutine
end:
   mov $0, %rdi
   call exit
