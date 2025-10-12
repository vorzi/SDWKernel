#!/bin/sh

set -e

unset LD_PRELOAD
: ${CC=cc}
: ${LD=ld}
: ${ASM=nasm}

case "$1" in
clean | c)
  echo "[BUILD.SH] Entering directory $(dirname $0) ..."
  cd "$(dirname $0)"
  echo "[BUILD.SH] Cleaning..."
  rm -rf build
  mkdir build build/assembely build/utils
  exit 0
  ;;

start | s)
  SECONDS=0
  echo "[BUILD.SH] Entering directory $(dirname $0) ..."
  cd "$(dirname $0)"
  echo "[     ASM] -f elf32 ./src/assembely/boot.asm -o ./build/assembely/boot.o"
  $ASM -f elf32 ./src/assembely/boot.asm -o ./build/assembely/boot.o
  echo "[      CC] -m32 -I./include -c ./src/main.c -o ./build/main.o"
  $CC -m32 -I./include -c ./src/main.c -o ./build/main.o
  echo "[      CC] -m32 -I./include -c ./src/utils/print.c -o ./build/utils/print.o"
  $CC -m32 -I./include -c ./src/utils/print.c -o ./build/utils/print.o
  echo "[      CC] -m32 -I./include -c ./src/utils/clear.c -o ./build/utils/clear.o"
  $CC -m32 -I./include -c ./src/utils/clear.c -o ./build/utils/clear.o
  echo "[      LD] -m elf_i386 -T link.ld -o ./kernel ./build/assembely/boot.o ./build/main.o ./build/utils/print.o ./build/utils/clear.o"
  $LD -m elf_i386 -T link.ld -o ./kernel ./build/assembely/boot.o ./build/main.o ./build/utils/print.o ./build/utils/clear.o
  echo "[BUILD.SH] Took $SECONDS to finish building."
  exit 0
  ;;

test | t | qemu | q)
  if command -v qemu-system-i386 >/dev/null 2>&1; then
    echo "[BUILD.SH] Entering directory $(dirname $0) ..."
    echo "[    QEMU] -kernel kernel"
    qemu-system-i386 -kernel kernel
    exit 0
  else
    echo "[BUILD.SH] qemu-system-i386 was not found in PATH!"
    exit 1
  fi
  ;;

help | h)
  cat <<EOF

    Arguements:
    build.sh start | starts building the kernel.
    build.sh clean | cleans compiled code.
    build.sh help  | show this message.
    build.sh test  | runs kernel with qemu-system-i386.

    If no arguemnets are given, this message will appear.

EOF
  ;;
*)
  cd "$(dirname $0)"
  exec ./build.sh help
  ;;
esac
