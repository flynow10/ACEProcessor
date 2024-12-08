using Assembler;

class Program
{
    static void Main(string[] args)
    {
        foreach (string filePath in args)
        {
            ReadBin(filePath);
        }
    }

    static void ReadBin(string filePath)
    {
        byte[] bin = File.ReadAllBytes(filePath);
        uint[] values = new uint[bin.Length / 4];
        for (int i = 0; i < bin.Length; i+=4)
        {
            values[i/4] = (uint)(bin[i] | (bin[i + 1] << 8) | (bin[i + 2] << 16) | (bin[i + 3] << 24));
        }
        MemoryFileOutput memoryFileOutput = new MemoryFileOutput(values);

        Console.WriteLine(memoryFileOutput.ToString());
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