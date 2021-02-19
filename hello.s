.bss
NUMBERS:
   .skip 1000

.text
outputstr: .asciz "Raymond Hoogervorst: 2691516\nErik Vunš: 2696857"

.global main

main: #entry point
   movq $0, %rax           #no vector registers used
   movq $outputstr, %rdi   #set adress of string
   call printf             #call subroutine
end:
   mov $0, %rdi
   call exit
