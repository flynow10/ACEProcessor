CC = riscv64-unknown-elf-gcc
LDFLAGS = -march=rv32i -g -ggdb -mabi=ilp32 -Wl,-Map,progmem.map -ffreestanding -Wl,--no-relax -Wl,--start-group,--end-group -mstrict-align
CFLAGS = -march=rv32i -g -ggdb -mno-div -mabi=ilp32 -ffunction-sections -fdata-sections -Wall -Wextra -pedantic -DCPU_FREQ=50000000 -Os -mstrict-align
objects = blackjack.o print.o input.o card.o random.o
blackjack-binary.txt: blackjack.mif
	cd build; riscv64-unknown-elf-objdump -D blackjack > blackjack-binary.txt
blackjack.mif: build $(objects)
	cd build; $(CC) $(LDFLAGS) -T ../riscv.ld -o blackjack $(objects)
	riscv64-unknown-elf-objcopy -O binary build/blackjack build/blackjack-binary
	cd ../Assembler; dotnet run ../blackjack/build/blackjack-binary > ../blackjack/build/blackjack.mif
	cp ./build/blackjack.mif ../processor/memory/memory.mif

mac: build
	gcc chess.c board.c gamestate.c move.c movegen.c utils.c print.c -o build/chess-mac

$(objects): %.o: %.c
	$(CC) $(CFLAGS) -c $^ -o build/$@

build:
	mkdir -p $@