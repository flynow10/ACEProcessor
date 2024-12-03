namespace Assembler;

public class SymbolTable
{
    public Dictionary<string, uint> Labels { get; } = new();
}