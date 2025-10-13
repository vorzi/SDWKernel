#!/bin/sh

set -e

unset LD_PRELOAD
: ${CC=cc}
: ${LD=ld}
: ${ASM=nasm}

case "$1" in
clean | c)
  echo "[BUILD.SH] Entering directory $(dirname "$0") ..."
  cd "$(dirname "$0")"
  echo "[BUILD.SH] Cleaning..."
  rm -rf build
  mkdir -p build/assembely/utils build/utils build/sh build/iso/boot/grub
  exit 0
  ;;

start | s)
  SECONDS=0
  echo "[BUILD.SH] Entering directory $(dirname "$0") ..."
  cd "$(dirname "$0")"

  echo "[     ASM] -f elf32 ./src/assembely/boot.asm -o ./build/assembely/boot.o"
  $ASM -f elf32 ./src/assembely/boot.asm -o ./build/assembely/boot.o

  echo "[     ASM] -f elf32 ./src/assembely/utils/getSystem.asm -o ./build/assembely/utils/getSystem.o"
  $ASM -f elf32 ./src/assembely/utils/getSystem.asm -o ./build/assembely/utils/getSystem.o

  echo "[      CC] -m32 -I./include -c ./src/main.c -o ./build/main.o"
  $CC -m32 -I./include -c ./src/main.c -o ./build/main.o

  echo "[      CC] -m32 -I./include -c ./src/utils/print.c -o ./build/utils/print.o"
  $CC -m32 -I./include -c ./src/utils/print.c -o ./build/utils/print.o

  echo "[      CC] -m32 -I./include -c ./src/utils/clear.c -o ./build/utils/clear.o"
  $CC -m32 -I./include -c ./src/utils/clear.c -o ./build/utils/clear.o

  echo "[      CC] -m32 -I./include -c ./src/utils/getSystem.c -o ./build/utils/getSystem.o"
  $CC -m32 -I./include -c ./src/utils/getSystem.c -o ./build/utils/getSystem.o

  echo "[      CC] -m32 -I./include -c ./src/utils/input.c -o ./build/utils/input.o"
  $CC -m32 -I./include -c ./src/utils/input.c -o ./build/utils/input.o

  echo "[      CC] -m32 -I./include -c ./src/sh/sh.c -o ./build/sh/sh.o"
  $CC -m32 -I./include -c ./src/sh/sh.c -o ./build/sh/sh.o

  echo "[      LD] -m elf_i386 -T link.ld -o ./kernel ./build/assembely/boot.o ./build/assembely/utils/getSystem.o ./build/main.o ./build/utils/print.o ./build/utils/clear.o ./build/utils/getSystem.o ./build/utils/input.o ./build/sh/sh.o"
  $LD -m elf_i386 -T link.ld -o ./kernel ./build/assembely/boot.o ./build/assembely/utils/getSystem.o ./build/main.o ./build/utils/print.o ./build/utils/clear.o ./build/utils/getSystem.o ./build/utils/input.o ./build/sh/sh.o

  echo "[    COPY] Copying kernel and grub into a iso"
  cp kernel ./build/iso/boot/
  rm kernel

  cp ./grub/grub.cfg ./build/iso/boot/grub/
  grub-mkrescue -o ./build/iso/boot/kernel.iso ./build/iso

  echo "[BUILD.SH] Build finished in $SECONDS seconds."
  exit 0
  ;;

test | t | qemu | q)
  if command -v qemu-system-i386 >/dev/null 2>&1; then
    echo "[BUILD.SH] Entering directory $(dirname "$0") ..."
    cd "$(dirname "$0")"
    echo "[    QEMU] -cdrom ./build/iso/boot/kernel.iso"
    qemu-system-i386 -cdrom ./build/iso/boot/kernel.iso
    exit 0
  else
    echo "[BUILD.SH] qemu-system-i386 was not found in PATH!"
    exit 1
  fi
  ;;

help | h)
  cat <<EOF

    Argumentos:
    build.sh start | Inicia a compilação do kernel.
    build.sh clean | Limpa arquivos compilados.
    build.sh test  | Roda o kernel com qemu-system-i386.
    build.sh help  | Mostra esta mensagem.

EOF
  ;;
*)
  cd "$(dirname "$0")"
  exec ./build.sh help
  ;;
esac
