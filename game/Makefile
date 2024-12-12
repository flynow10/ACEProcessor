CC = riscv64-unknown-elf-gcc
LDFLAGS = -march=rv32i -g -ggdb -mabi=ilp32 -Wl,-Map,progmem.map -ffreestanding -nostartfiles -Wl,--no-relax -Wl,--start-group,--end-group
CFLAGS = -march=rv32i -g -ggdb -mno-div -mabi=ilp32 -ffunction-sections -fdata-sections -Wall -Wextra -pedantic -DCPU_FREQ=50000000 -Os
objects = chess.o board.o gamestate.o move.o movegen.o utils.o print.o
chess-binary.txt: chess_rv.mif
	cd build; riscv64-unknown-elf-objdump -D chess > chess-binary.txt
chess_rv.mif: build $(objects)
	cd build; $(CC) $(LDFLAGS) -T ../riscv.ld -o chess $(objects)
	riscv64-unknown-elf-objcopy -O binary build/chess build/chess-binary
	cd ../Assembler; dotnet run ../game/build/chess-binary > ../game/build/chess_rv.mif

mac: build
	gcc chess.c board.c gamestate.c move.c movegen.c utils.c print.c -o build/chess-mac

$(objects): %.o: %.c
	$(CC) $(CFLAGS) -c $^ -o build/$@

build:
	mkdir -p $@