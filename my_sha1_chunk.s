# **********************************#
# register reference for sha1_chunk #
# %rdi = index of h0                #
# %rsi = index of first word        #
# %rcx = index of any loop          #
# %rdx = data pointer               #
# %r8 = f                           #
# %r9 = k                           #
# %r10d to %r14d = a to e           #
# %rax = temp values                #
# **********************************#

.global sha1_chunk

sha1_chunk:
   # extend words to 80
   movq $16, %rcx
   movq %rsi, %rdx
   addq $64, %rdx

   extensionloop:
      movl -12(%rsi), %eax
      xorl -32(%rsi), %eax
      xorl -56(%rsi), %eax
      xorl -64(%rsi), %eax
      roll $1, %eax
      movl %eax, (%rsi)

      addq $4, %rdx
      incq %rcx
      cmpq $79, %rcx
      jle extensionloop

   # initialize hash value
   movl (%rdi), %r10d
   movl 4(%rdi), %r11d
   movl 8(%rdi), %r12d
   movl 12(%rdi), %r13d
   movl 16(%rdi), %r14d

   # main loop
   movq $0, %rcx
   mainloop:
   
      # determine quarter
      cmpq $19, %rcx
      jle first
      cmpq $39, %rcx
      jle second
      cmpq $59, %rcx
      jle third
      cmpq $79, %rcx
      jle fourth
      jmp endloop

      first:
         movl %r11d, %r8d
         andl %r12d, %r8d
         movl %r11d, %eax
         notl %eax
         andl %r13d, %eax
         orl  %eax, %r8d

         movl $0x5A827999, %r9d
         jmp repeat
      second:
         movl %r11d, %r8d
         xorl %r12d, %r8d
         xorl %r13d, %r8d

         movl $0x6ED9EBA1, %r9d
         jmp repeat
      third:
         movl %r11d, %r8d
         andl %r12d, %r8d
         movl %r11d, %eax
         andl %r13d, %eax
         orl  %eax, %r8d
         movl %r12d, %eax
         andl %r13d, %eax
         orl  %eax, %r8d

         movl $0x8F1BBCDC, %r9d
         jmp repeat
      fourth:
         movl %r11d, %r8d
         xorl %r12d, %r8d
         xorl %r13d, %r8d

         movl $0xCA62C1D6, %r9d
         jmp repeat

      repeat:
         incq %rcx
         jmp mainloop
   endloop:


   # Add hash results
   addl %r10d, (%rdi)
   addl %r11d, 4(%rdi)
   addl %r12d, 8(%rdi)
   addl %r13d, 12(%rdi)
   addl %r14d, 16(%rdi)

   ret
