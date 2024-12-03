int factorial(int n);

int main()
{
  int sum = 0;
  for (int i = 0; i < 10; i = i + 1)
  {
    sum = sum + factorial(i);
  }
}

int factorial(int n)
{
  if (n <= 0)
  {
    return 1;
  }

  return n * factorial(n - 1);
}