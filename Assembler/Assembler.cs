namespace Assembler;

public class Assembler
{
    readonly List<Lexer.Token> _tokens;
    List<uint> _output = new();

    private int _currentTokenIndex;
    
    private Lexer.Token CurrentToken => _tokens[_currentTokenIndex];
    
    public Assembler(string inputFile)
    {
        _tokens = Lexer.Tokenize(inputFile);
    }

    public uint[] Assemble()
    {
        _output = new List<uint>();
        while (CurrentToken.TokenType != Lexer.TokenType.EOF)
        {
            switch (CurrentToken.TokenType)
            {
                case Lexer.TokenType.Directive:
                    ParseDirective();
                    break;
                case Lexer.TokenType.Instruction:
                    ParseInstruction();
                    break;
                case Lexer.TokenType.Label:
                    break;
                default: throw new Exception($"Failed to parse statement on line {CurrentToken.Line}");
            }
        }

        return _output.ToArray();
    }

    private Lexer.Token EatToken(params Lexer.TokenType[] tokenTypes)
    {
        if (!tokenTypes.Contains(CurrentToken.TokenType))
        {
            throw new Exception($"Unexpected token on line {CurrentToken.Line}");
        }
        Lexer.Token current = _tokens[_currentTokenIndex];
        _currentTokenIndex++;
        return current;
    }

    private void ParseDirective()
    {
        EatToken(Lexer.TokenType.Directive);
        EatToken(Lexer.TokenType.EOL);
    }

    private void ParseInstruction()
    {
        Lexer.Token instruction = EatToken(Lexer.TokenType.Instruction);
        Instruction instructionType = Instruction.GetByKeyword(instruction.Value);
        uint assemBinary = instructionType.Opcode;
        switch (instructionType.Format)
        {
            case Instruction.InstructionFormat.R:
                ParseRFormat(ref assemBinary, instructionType);
                break;
            case Instruction.InstructionFormat.I:
                ParseIFormat(ref assemBinary, instructionType);
                break;
            default:
                throw new NotImplementedException();
        }
        _output.Add(assemBinary);
        EatToken(Lexer.TokenType.EOL);
    }

    private void ParseRFormat(ref uint assemBinary, Instruction instruction)
    {
        ushort destReg = ParseRegister();
        EatToken(Lexer.TokenType.Separator);
        ushort src1Reg = ParseRegister();
        EatToken(Lexer.TokenType.Separator);
        ushort src2Reg = ParseRegister();

        // Set ALU code
        switch (instruction.Keyword)
        {
            case "sub":
                assemBinary |= 0b01 << 30;
                break;
            case "sll":
                assemBinary |= 0b001 << 12;
                break;
            case "slt":
                assemBinary |= 0b010 << 12;
                break;
            case "sltu":
                assemBinary |= 0b011 << 12;
                break;
            case "xor":
                assemBinary |= 0b100 << 12;
                break;
            case "srl":
                assemBinary |= 0b101 << 12;
                break;
            case "sra":
                assemBinary |= 0b101 << 12;
                assemBinary |= 0b01 << 30;
                break;
            case "or":
                assemBinary |= 0b110 << 12;
                break;
            case "and":
                assemBinary |= 0b111 << 12;
                break;
        }

        assemBinary |= (uint) (destReg << 7);
        assemBinary |= (uint) (src1Reg << 15);
        assemBinary |= (uint) (src2Reg << 20);
    }
    
    private void ParseIFormat(ref uint assemBinary, Instruction instruction)
    {
        ushort destReg = ParseRegister();
        EatToken(Lexer.TokenType.Separator);
        ushort src1Reg = ParseRegister();
        EatToken(Lexer.TokenType.Separator);
        short immediate = ParseImmediate();
        

        // Set ALU code
        switch (instruction.Keyword)
        {
            case "sll":
                assemBinary |= 0b001 << 12;
                break;
            case "slt":
                assemBinary |= 0b010 << 12;
                break;
            case "sltu":
                assemBinary |= 0b011 << 12;
                break;
            case "xor":
                assemBinary |= 0b100 << 12;
                break;
            case "srl":
                assemBinary |= 0b101 << 12;
                break;
            case "sra":
                assemBinary |= 0b101 << 12;
                assemBinary |= 0b01 << 30;
                break;
            case "or":
                assemBinary |= 0b110 << 12;
                break;
            case "and":
                assemBinary |= 0b111 << 12;
                break;
        }

        assemBinary |= (uint) (destReg << 7);
        assemBinary |= (uint) (src1Reg << 15);
        assemBinary |= (uint) (immediate << 20);
    }

    private ushort ParseRegister()
    {
        Lexer.Token regToken = EatToken(Lexer.TokenType.Register);
        return Register.GetRegisterNumber(regToken.Value);
    }

    private short ParseImmediate()
    {
        Lexer.Token immediateToken = EatToken(Lexer.TokenType.Literal, Lexer.TokenType.Identifier);
        if (immediateToken.TokenType == Lexer.TokenType.Identifier)
        {
            throw new NotImplementedException();
        }

        int fromBase = immediateToken.Value.Contains('x') ? 16 : 10;
        return Convert.ToInt16(immediateToken.Value, fromBase);
    }

    private void CheckFit(int value, int bits, bool signed)
    {
        
    }
    
    public static uint[] Assemble(string input)
    {
        return new Assembler(input).Assemble();
    }
}