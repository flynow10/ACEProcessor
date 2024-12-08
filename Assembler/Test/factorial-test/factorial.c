int factorial(int n);

int main()
{
    int a = factorial(6);
    return a;
}

int factorial(int n)
{
    if (n <= 0)
    {
        return 1;
    }

    return n * factorial(n - 1);
}