# **********************************#
# register reference for sha1_chunk #
# %rdi = index of h0                #
# %rsi = index of first word        #
# %rdx = index of any loop          #
# %r8 = f                           #
# %r9 = k                           #
# %r10 to %r14 = a to e             #
# %r15 = temp                       # 
# **********************************#

sha1_chunk:

   # first loop: extend words array


   # initialize hash value


   # main loop


   # Add hash results

   ret
