Issutracker : #i49680#
CWS         : N/A
Author      : NAKATA Maho <maho@openoffice.org> (JCA)
Description : catch up recent version of cpp_uno

--- bridges/source/cpp_uno/gcc3_freebsd_intel.old/call.s	Thu Jan  1 09:00:00 1970
+++ bridges/source/cpp_uno/gcc3_freebsd_intel/call.s	Fri May 20 11:21:13 2005
@@ -0,0 +1,262 @@
+    .text
+
+.globl privateSnippetExecutorGeneral
+    .type   privateSnippetExecutorGeneral,@function
+privateSnippetExecutorGeneral:
+.LFBg:
+    movl    %esp,%ecx
+    pushl   %ebp              # proper stack frame needed for exception handling
+.LCFIg0:
+    movl    %esp,%ebp
+.LCFIg1:
+    subl    $0x8,%esp         # 64bit nRegReturn
+    pushl   %ecx              # 32bit pCallStack
+    pushl   %edx              # 32bit nVtableOffset
+    pushl   %eax              # 32bit nFunctionIndex
+    call    cpp_vtable_call
+    movl    12(%esp),%eax     # 64 bit nRegReturn, lower half
+    leave
+    ret
+.LFEg:
+    .size   privateSnippetExecutorGeneral,.-privateSnippetExecutorGeneral
+
+.globl privateSnippetExecutorVoid
+    .type   privateSnippetExecutorVoid,@function
+privateSnippetExecutorVoid:
+.LFBv:
+    movl    %esp,%ecx
+    pushl   %ebp              # proper stack frame needed for exception handling
+.LCFIv0:
+    movl    %esp,%ebp
+.LCFIv1:
+    subl    $0x8,%esp         # 64bit nRegReturn
+    pushl   %ecx              # 32bit pCallStack
+    pushl   %edx              # 32bit nVtableOffset
+    pushl   %eax              # 32bit nFunctionIndex
+    call    cpp_vtable_call
+    leave
+    ret
+.LFEv:
+    .size   privateSnippetExecutorVoid,.-privateSnippetExecutorVoid
+
+.globl privateSnippetExecutorHyper
+    .type   privateSnippetExecutorHyper,@function
+privateSnippetExecutorHyper:
+.LFBh:
+    movl    %esp,%ecx
+    pushl   %ebp              # proper stack frame needed for exception handling
+.LCFIh0:
+    movl    %esp,%ebp
+.LCFIh1:
+    subl    $0x8,%esp         # 64bit nRegReturn
+    pushl   %ecx              # 32bit pCallStack
+    pushl   %edx              # 32bit nVtableOffset
+    pushl   %eax              # 32bit nFunctionIndex
+    call    cpp_vtable_call
+    movl    12(%esp),%eax     # 64 bit nRegReturn, lower half
+    movl    16(%esp),%edx     # 64 bit nRegReturn, upper half
+    leave
+    ret
+.LFEh:
+    .size   privateSnippetExecutorHyper,.-privateSnippetExecutorHyper
+
+.globl privateSnippetExecutorFloat
+    .type   privateSnippetExecutorFloat,@function
+privateSnippetExecutorFloat:
+.LFBf:
+    movl    %esp,%ecx
+    pushl   %ebp              # proper stack frame needed for exception handling
+.LCFIf0:
+    movl    %esp,%ebp
+.LCFIf1:
+    subl    $0x8,%esp         # 64bit nRegReturn
+    pushl   %ecx              # 32bit pCallStack
+    pushl   %edx              # 32bit nVtableOffset
+    pushl   %eax              # 32bit nFunctionIndex
+    call    cpp_vtable_call
+    flds    12(%esp)          # 64 bit nRegReturn, lower half
+    leave
+    ret
+.LFEf:
+    .size   privateSnippetExecutorFloat,.-privateSnippetExecutorFloat
+
+.globl privateSnippetExecutorDouble
+    .type   privateSnippetExecutorDouble,@function
+privateSnippetExecutorDouble:
+.LFBd:
+    movl    %esp,%ecx
+    pushl   %ebp              # proper stack frame needed for exception handling
+.LCFId0:
+    movl    %esp,%ebp
+.LCFId1:
+    subl    $0x8,%esp         # 64bit nRegReturn
+    pushl   %ecx              # 32bit pCallStack
+    pushl   %edx              # 32bit nVtableOffset
+    pushl   %eax              # 32bit nFunctionIndex
+    call    cpp_vtable_call
+    fldl    12(%esp)          # 64 bit nRegReturn
+    leave
+    ret
+.LFEd:
+    .size   privateSnippetExecutorDouble,.-privateSnippetExecutorDouble
+
+.globl privateSnippetExecutorClass
+    .type   privateSnippetExecutorClass,@function
+privateSnippetExecutorClass:
+.LFBc:
+    movl    %esp,%ecx
+    pushl   %ebp              # proper stack frame needed for exception handling
+.LCFIc0:
+    movl    %esp,%ebp
+.LCFIc1:
+    subl    $0x8,%esp         # 64bit nRegReturn
+    pushl   %ecx              # 32bit pCallStack
+    pushl   %edx              # 32bit nVtableOffset
+    pushl   %eax              # 32bit nFunctionIndex
+    call    cpp_vtable_call
+    movl    12(%esp),%eax     # 64 bit nRegReturn, lower half
+    leave
+    ret     $4
+.LFEc:
+    .size   privateSnippetExecutorClass,.-privateSnippetExecutorClass
+
+    .section .eh_frame,"a",@progbits
+.Lframe1:
+    .long   .LECIE1-.LSCIE1   # length
+.LSCIE1:
+    .long   0                 # CIE_ID
+    .byte   1                 # version
+    .string "zR"              # augmentation
+    .uleb128 1                # code_alignment_factor
+    .sleb128 -4               # data_alignment_factor
+    .byte   8                 # return_address_register
+    .uleb128 1                # augmentation size 1:
+    .byte   0x1B              #  FDE Encoding (pcrel sdata4)
+                              # initial_instructions:
+    .byte   0x0C              #  DW_CFA_def_cfa %esp, 4
+    .uleb128 4
+    .uleb128 4
+    .byte   0x88              #  DW_CFA_offset ret, 1
+    .uleb128 1
+    .align 4
+.LECIE1:
+.LSFDEg:
+    .long   .LEFDEg-.LASFDEg  # length
+.LASFDEg:
+    .long   .LASFDEg-.Lframe1 # CIE_pointer
+    .long   .LFBg-.           # initial_location
+    .long   .LFEg-.LFBg       # address_range
+    .uleb128 0                # augmentation size 0
+                              # instructions:
+    .byte   0x04              #  DW_CFA_advance_loc4
+    .long   .LCFIg0-.LFBg
+    .byte   0x0E              #  DW_CFA_def_cfa_offset 8
+    .uleb128 8
+    .byte   0x85              #  DW_CFA_offset %ebp, 2
+    .uleb128 2
+    .byte   0x04              #  DW_CFA_advance_loc4
+    .long   .LCFIg1-.LCFIg0
+    .byte   0x0D              #  DW_CFA_def_cfa_register %ebp
+    .uleb128 5
+    .align 4
+.LEFDEg:
+.LSFDEv:
+    .long   .LEFDEv-.LASFDEv  # length
+.LASFDEv:
+    .long   .LASFDEv-.Lframe1 # CIE_pointer
+    .long   .LFBv-.           # initial_location
+    .long   .LFEv-.LFBv       # address_range
+    .uleb128 0                # augmentation size 0
+                              # instructions:
+    .byte   0x04              #  DW_CFA_advance_loc4
+    .long   .LCFIv0-.LFBv
+    .byte   0x0E              #  DW_CFA_def_cfa_offset 8
+    .uleb128 8
+    .byte   0x85              #  DW_CFA_offset %ebp, 2
+    .uleb128 2
+    .byte   0x04              #  DW_CFA_advance_loc4
+    .long   .LCFIv1-.LCFIv0
+    .byte   0x0D              #  DW_CFA_def_cfa_register %ebp
+    .uleb128 5
+    .align 4
+.LEFDEv:
+.LSFDEh:
+    .long   .LEFDEh-.LASFDEh  # length
+.LASFDEh:
+    .long   .LASFDEh-.Lframe1 # CIE_pointer
+    .long   .LFBh-.           # initial_location
+    .long   .LFEh-.LFBh       # address_range
+    .uleb128 0                # augmentation size 0
+                              # instructions:
+    .byte   0x04              #  DW_CFA_advance_loc4
+    .long   .LCFIh0-.LFBh
+    .byte   0x0E              #  DW_CFA_def_cfa_offset 8
+    .uleb128 8
+    .byte   0x85              #  DW_CFA_offset %ebp, 2
+    .uleb128 2
+    .byte   0x04              #  DW_CFA_advance_loc4
+    .long   .LCFIh1-.LCFIh0
+    .byte   0x0D              #  DW_CFA_def_cfa_register %ebp
+    .uleb128 5
+    .align 4
+.LEFDEh:
+.LSFDEf:
+    .long   .LEFDEf-.LASFDEf  # length
+.LASFDEf:
+    .long   .LASFDEf-.Lframe1 # CIE_pointer
+    .long   .LFBf-.           # initial_location
+    .long   .LFEf-.LFBf       # address_range
+    .uleb128 0                # augmentation size 0
+                              # instructions:
+    .byte   0x04              #  DW_CFA_advance_loc4
+    .long   .LCFIf0-.LFBf
+    .byte   0x0E              #  DW_CFA_def_cfa_offset 8
+    .uleb128 8
+    .byte   0x85              #  DW_CFA_offset %ebp, 2
+    .uleb128 2
+    .byte   0x04              #  DW_CFA_advance_loc4
+    .long   .LCFIf1-.LCFIf0
+    .byte   0x0D              #  DW_CFA_def_cfa_register %ebp
+    .uleb128 5
+    .align 4
+.LEFDEf:
+.LSFDEd:
+    .long   .LEFDEd-.LASFDEd  # length
+.LASFDEd:
+    .long   .LASFDEd-.Lframe1 # CIE_pointer
+    .long   .LFBd-.           # initial_location
+    .long   .LFEd-.LFBd       # address_range
+    .uleb128 0                # augmentation size 0
+                              # instructions:
+    .byte   0x04              #  DW_CFA_advance_loc4
+    .long   .LCFId0-.LFBd
+    .byte   0x0E              #  DW_CFA_def_cfa_offset 8
+    .uleb128 8
+    .byte   0x85              #  DW_CFA_offset %ebp, 2
+    .uleb128 2
+    .byte   0x04              #  DW_CFA_advance_loc4
+    .long   .LCFId1-.LCFId0
+    .byte   0x0D              #  DW_CFA_def_cfa_register %ebp
+    .uleb128 5
+    .align 4
+.LEFDEd:
+.LSFDEc:
+    .long   .LEFDEc-.LASFDEc  # length
+.LASFDEc:
+    .long   .LASFDEc-.Lframe1 # CIE_pointer
+    .long   .LFBc-.           # initial_location
+    .long   .LFEc-.LFBc       # address_range
+    .uleb128 0                # augmentation size 0
+                              # instructions:
+    .byte   0x04              #  DW_CFA_advance_loc4
+    .long   .LCFIc0-.LFBc
+    .byte   0x0E              #  DW_CFA_def_cfa_offset 8
+    .uleb128 8
+    .byte   0x85              #  DW_CFA_offset %ebp, 2
+    .uleb128 2
+    .byte   0x04              #  DW_CFA_advance_loc4
+    .long   .LCFIc1-.LCFIc0
+    .byte   0x0D              #  DW_CFA_def_cfa_register %ebp
+    .uleb128 5
+    .align 4
+.LEFDEc:
