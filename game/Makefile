CC = riscv64-unknown-elf-gcc
CFLAGS = -march=rv32i -mabi=ilp32
objects = chess.o board.o gamestate.o move.o movegen.o utils.o print.o
chess_rv.mif: build $(objects)
	cd build; $(CC) $(CFLAGS) -T ../riscv.ld -o chess $(objects)
	riscv64-unknown-elf-objcopy -O ihex build/chess build/chess-binary
	cd ../Assembler; dotnet run ../game/build/chess-binary > ../game/build/chess_rv.mif

$(objects): %.o: %.c
	$(CC) $(CFLAGS) -c $^ -o build/$@

build:
	mkdir -p $@