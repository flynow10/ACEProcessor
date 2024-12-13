CC = riscv64-unknown-elf-gcc
LDFLAGS = -march=rv32i -g -ggdb -mabi=ilp32 -Wl,-Map,progmem.map -ffreestanding -nostartfiles -Wl,--no-relax -Wl,--start-group,--end-group -mstrict-align
CFLAGS = -march=rv32i -g -ggdb -mno-div -mabi=ilp32 -ffunction-sections -fdata-sections -Wall -Wextra -pedantic -DCPU_FREQ=50000000 -Os -mstrict-align
objects = fibonacci.o print.o input.o utils.o
chess-binary.txt: chess_rv.mif
	cd build; riscv64-unknown-elf-objdump -D chess > chess-binary.txt
chess_rv.mif: build $(objects)
	cd build; $(CC) $(LDFLAGS) -T ../riscv.ld -o chess $(objects)
	riscv64-unknown-elf-objcopy -O binary build/chess build/chess-binary
	cd ../Assembler; dotnet run ../fibonacci/build/chess-binary > ../fibonacci/build/chess_rv.mif

mac: build
	gcc chess.c board.c gamestate.c move.c movegen.c utils.c print.c -o build/chess-mac

$(objects): %.o: %.c
	$(CC) $(CFLAGS) -c $^ -o build/$@

build:
	mkdir -p $@