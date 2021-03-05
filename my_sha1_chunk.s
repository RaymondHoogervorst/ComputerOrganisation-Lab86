# **********************************#
# register reference for sha1_chunk #
# %rdi = index of h0                #
# %rsi = index of first word        #
# %rcx = index of any loop          #
# %r8 = f                           #
# %r9 = k                           #
# %r10d to %r14d = a to e           #
# %rax = temp values                #
# **********************************#

.global sha1_chunk

sha1_chunk:
   # extend words to 80
   movq $16, %rcx
   extensionloop:


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

         jmp repeat
      second:

         jmp repeat
      third:

         jmp repeat
      fourth:

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
