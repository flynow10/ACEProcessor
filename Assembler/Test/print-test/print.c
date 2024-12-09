void print(char c, int pos);
int main()
{
  print('G', 0);
  print('a', 1);
  print('b', 2);
  print('e', 3);
  return 0;
}

void print(char c, int pos)
{
  int asciiVal = (int)c;
  __asm__("lui t0, 0x10000;"
          "add t0, t0, %1;"
          "mv t1, %0;"
          "lui t2, 0x00fff;"
          "slli t1, t1, 24;"
          "add t1, t1, t2;"
          "addi t1,t1, 0xfff;"
          "sw t1, 0(t0);"
          :
          : "r"(asciiVal), "r"(pos)
          :);
}