CC = riscv64-unknown-elf-gcc
LDFLAGS = -march=rv32i -g -ggdb -mabi=ilp32 -Wl,-Map,progmem.map -ffreestanding -nostartfiles -Wl,--no-relax -Wl,--start-group,--end-group -mstrict-align
CFLAGS = -march=rv32i -g -ggdb -mno-div -mabi=ilp32 -ffunction-sections -fdata-sections -Wall -Wextra -pedantic -DCPU_FREQ=50000000 -Os -mstrict-align
objects = fibonacci.o print.o input.o utils.o
fibonacci-binary.txt: fibonacci_rv.mif
	cd build; riscv64-unknown-elf-objdump -D fibonacci > fibonacci-binary.txt
fibonacci_rv.mif: build $(objects)
	cd build; $(CC) $(LDFLAGS) -T ../riscv.ld -o fibonacci $(objects)
	riscv64-unknown-elf-objcopy -O binary build/fibonacci build/fibonacci-binary
	cd ../Assembler; dotnet run ../fibonacci/build/fibonacci-binary > ../fibonacci/build/fibonacci_rv.mif

$(objects): %.o: %.c
	$(CC) $(CFLAGS) -c $^ -o build/$@

build:
	mkdir -p $@