CC = riscv64-unknown-elf-gcc
LDFLAGS = -march=rv32i -g -ggdb -mabi=ilp32 -Wl,-Map,progmem.map -ffreestanding -Wl,--no-relax -Wl,--start-group,--end-group -mstrict-align
CFLAGS = -march=rv32i -g -ggdb -mno-div -mabi=ilp32 -ffunction-sections -fdata-sections -Wall -Wextra -pedantic -DCPU_FREQ=50000000 -Os -mstrict-align
objects = rainbow.o print.o
rainbow-binary.txt: rainbow.mif
	cd build; riscv64-unknown-elf-objdump -D rainbow > rainbow-binary.txt
rainbow.mif: build $(objects)
	cd build; $(CC) $(LDFLAGS) -T ../riscv.ld -o rainbow $(objects)
	riscv64-unknown-elf-objcopy -O binary build/rainbow build/rainbow-binary
	cd ../Assembler; dotnet run ../rainbow/build/rainbow-binary > ../rainbow/build/rainbow.mif
	cp ./build/rainbow.mif ../processor/memory/rainbow.mif
	cp ./build/rainbow.mif ../processor/memory/memory.mif

mac: build
	gcc rainbow.c print.c -o build/rainbow-mac

$(objects): %.o: %.c
	$(CC) $(CFLAGS) -c $^ -o build/$@

build:
	mkdir -p $@