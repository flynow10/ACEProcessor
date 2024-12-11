CC = riscv64-unknown-elf-gcc
CFLAGS = -march=rv32i -mabi=ilp32 -ffreestanding
objects = chess.o board.o gamestate.o move.o movegen.o utils.o print.o
chess-binary.txt: chess_rv.mif
	cd build; riscv64-unknown-elf-objdump -D chess > chess-binary.txt
chess_rv.mif: build $(objects)
	cd build; $(CC) $(CFLAGS) -T ../riscv.ld -o chess $(objects)
	riscv64-unknown-elf-objcopy -O binary build/chess build/chess-binary
	cd ../Assembler; dotnet run ../game/build/chess-binary > ../game/build/chess_rv.mif

$(objects): %.o: %.c
	$(CC) $(CFLAGS) -c $^ -o build/$@

build:
	mkdir -p $@