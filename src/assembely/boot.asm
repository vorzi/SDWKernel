bits 32 ;Legal, 32 bits
section .text
  align 4
  dd 0x1BADB002
  dd 0x00
  dd - (0x1BADB002 + 0x00)

global start
extern startkernel

start:
  cli
  call startkernel
  hlt
