global asm_get_cpu
section .text
asm_get_cpu:
  push ebp
  mov ebp, esp

  mov edi, [ebp + 8]

  mov eax, 0
  cpuid
  mov [edi], ebx ; Vendor entre 1-3
  mov [edi + 4], edx ; Vendor entre 4-7
  mov [edi + 8], ecx ; Vendor entre 8-11

  mov eax, 1
  cpuid
  mov [edi + 12], eax ; Modelo e outros
  mov [edi + 16], ebx ; Flags
  mov [edi + 20], ecx ; Flags

  xor eax, eax
  mov [edi + 24], eax
  mov [edi + 28], eax

  pop ebp
  ret

