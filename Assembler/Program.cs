using Assembler;

class Program
{
    static void Main(string[] args)
    {
        foreach (string filePath in args)
        {
            ReadFromFile(filePath);
        }
    }
    static void ReadFromFile(string filePath)
    {
        string fileContents = File.ReadAllText(filePath);
        try
        {
            uint[] instructions = Assembler.Assembler.Assemble(fileContents);
            MemoryFileOutput memoryFileOutput = new MemoryFileOutput(instructions);

            Console.WriteLine(memoryFileOutput.ToString());
        }
        catch (Exception)
        {
            Console.WriteLine(fileContents);
            throw;
        }
    }
}