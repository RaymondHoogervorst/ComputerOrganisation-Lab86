# **********************************#
# register reference for sha1_chunk #
# %rdi = index of h0                #
# %rsi = index of first word        #
# %rdx = index of any loop          #
# %r8 = f                           #
# %r9 = k                           #
# %r10 to %r14 = a to e             #
# %rax = temp values                #
# **********************************#

.global sha1_chunk

sha1_chunk:
   # extend words to 80
   movq $16, %rdx
   extensionloop:

      incq %rdx
      cmpq $79, %rdx
      jle extensionloop

   # initialize hash value


   # main loop
   movq $0, %rdx
   mainloop:
      # determine quarter
      cmpq $19, %rdx
      jle first
      cmpq $39, %rdx
      jle second
      cmpq $59, %rdx
      jle third
      cmpq $79, %rdx
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
         incq %rdx
         jmp mainloop
   endloop:


   # Add hash results

   ret
