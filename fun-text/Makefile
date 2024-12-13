CC = riscv64-unknown-elf-gcc
LDFLAGS = -march=rv32i -g -ggdb -mabi=ilp32 -Wl,-Map,progmem.map -ffreestanding -Wl,--no-relax -Wl,--start-group,--end-group -mstrict-align
CFLAGS = -march=rv32i -g -ggdb -mno-div -mabi=ilp32 -ffunction-sections -fdata-sections -Wall -Wextra -pedantic -DCPU_FREQ=50000000 -Os -mstrict-align
objects = fun-text.o print.o
fun-text-binary.txt: fun-text_rv.mif
	cd build; riscv64-unknown-elf-objdump -D fun-text > fun-text-binary.txt
fun-text_rv.mif: build $(objects)
	cd build; $(CC) $(LDFLAGS) -T ../riscv.ld -o fun-text $(objects)
	riscv64-unknown-elf-objcopy -O binary build/fun-text build/fun-text-binary
	cd ../Assembler; dotnet run ../fun-text/build/fun-text-binary > ../fun-text/build/fun-text_rv.mif

$(objects): %.o: %.c
	$(CC) $(CFLAGS) -c $^ -o build/$@

build:
	mkdir -p $@