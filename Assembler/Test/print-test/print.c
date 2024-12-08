void print(char c);
int main()
{
  print('A');
  return 0;
}

void print(char c)
{
  int asciiVal = (int)c;
  __asm__("mv t0, %0;"
          "li t1, 0x00030000;"
          "sw t0, 0(t1);"
          :
          : "r"(asciiVal)
          :);
}