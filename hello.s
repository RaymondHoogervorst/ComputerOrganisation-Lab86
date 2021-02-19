.bss NUMBERS:
   .skip 1000

.text
formatstr: "Raymond Hoogervorst\nErik Vunš"

.global main

main:
   movq $0, %rax
   movq $outputstr, %rdi

end:
   mov $0, %rdi
   call exit
