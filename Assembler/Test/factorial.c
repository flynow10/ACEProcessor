int factorial(int n);

int main()
{
    int a = factorial(5);
}

int factorial(int n)
{
    if (n <= 0)
    {
        return 1;
    }

    return n * factorial(n - 1);
}