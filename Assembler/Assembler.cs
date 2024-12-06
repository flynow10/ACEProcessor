namespace Assembler;

public class Assembler
{
    public const int START_ADDRESS = 0;
    readonly List<Lexer.Token> _tokens;
    private SymbolTable _symbolTable;
    List<uint> _output = new();

    private int _currentTokenIndex;

    private Lexer.Token CurrentToken => _tokens[_currentTokenIndex];

    public Assembler(string inputFile)
    {
        _symbolTable = new SymbolTable();
        _tokens = Lexer.Tokenize(inputFile);
    }

    public uint[] Assemble()
    {
        PopulateSymbolTable();
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
                    EatToken(Lexer.TokenType.Label);
                    EatToken(Lexer.TokenType.EOL);
                    break;
                default: throw new Exception($"Failed to parse statement on line {CurrentToken.Line}");
            }
        }

        return _output.ToArray();
    }

    private void PopulateSymbolTable()
    {
        _symbolTable = new SymbolTable();
        int address = START_ADDRESS - 4;
        int currentTokenIndex = 0;
        while (currentTokenIndex < _tokens.Count)
        {
            Lexer.Token token = _tokens[currentTokenIndex];

            if (token.TokenType == Lexer.TokenType.Label)
            {
                _symbolTable.Labels.Add(token.Value, (uint)(address + 4));
                currentTokenIndex++;
            }
            else if (token.TokenType == Lexer.TokenType.Instruction || token.TokenType == Lexer.TokenType.Directive)
            {
                if (token.TokenType == Lexer.TokenType.Instruction)
                {
                    Instruction instructionType = Instruction.GetByKeyword(token.Value);
                    if (new[] { "call", "tail" }.Contains(instructionType.Keyword))
                    {
                        address += 4;
                    }
                    address += 4;
                }

                while (currentTokenIndex < _tokens.Count && _tokens[currentTokenIndex].TokenType != Lexer.TokenType.EOL)
                {
                    currentTokenIndex++;
                }
            }
            else if (token.TokenType == Lexer.TokenType.EOF)
            {
                break;
            }
            else
            {
                throw new Exception($"Unexpected token when creating Symbol Table {token.TokenType} at line {CurrentToken.Line}");
            }

            currentTokenIndex++;
        }
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

        if (instructionType.IsPseudo)
        {
            ParsePseudoOperation(instructionType);
        }
        else
        {
            uint assemBinary = instructionType.Opcode;
            switch (instructionType.Format)
            {
                case Instruction.InstructionFormat.R:
                    ParseRFormat(ref assemBinary, instructionType);
                    break;
                case Instruction.InstructionFormat.I:
                    ParseIFormat(ref assemBinary, instructionType);
                    break;
                case Instruction.InstructionFormat.S:
                    ParseSFormat(ref assemBinary, instructionType);
                    break;
                case Instruction.InstructionFormat.U:
                    ParseUFormat(ref assemBinary);
                    break;
                case Instruction.InstructionFormat.B:
                    ParseBFormat(ref assemBinary, instructionType);
                    break;
                case Instruction.InstructionFormat.J:
                    ParseJFormat(ref assemBinary);
                    break;
                default:
                    throw new NotImplementedException();
            }

            _output.Add(assemBinary);
        }

        EatToken(Lexer.TokenType.EOL);
    }

    private void ParseRFormat(ref uint assemBinary, Instruction instruction)
    {
        ushort destReg = ParseRegister();
        EatToken(Lexer.TokenType.Separator);
        ushort src1Reg = ParseRegister();
        EatToken(Lexer.TokenType.Separator);
        ushort src2Reg = ParseRegister();
        ushort aluCode = 0;
        ushort func7 = 0;

        // Set ALU code
        switch (instruction.Keyword)
        {
            case "sub":
                func7 = 0b0100000;
                break;
            case "sll":
                aluCode = 0b001;
                break;
            case "slt":
                aluCode = 0b010;
                break;
            case "sltu":
                aluCode = 0b011;
                break;
            case "xor":
                aluCode = 0b100;
                break;
            case "srl":
                aluCode = 0b101;
                break;
            case "sra":
                aluCode = 0b101;
                func7 = 0b0100000;
                break;
            case "or":
                aluCode = 0b110;
                break;
            case "and":
                aluCode = 0b111;
                break;
        }

        StoreRFormat(ref assemBinary, destReg, src1Reg, src2Reg, aluCode, func7);
    }

    private void StoreRFormat(ref uint assemBinary, ushort destReg, ushort src1Reg, ushort src2Reg, ushort aluCode,
        ushort func7)
    {
        assemBinary |= (uint)(destReg << 7);
        assemBinary |= (uint)(aluCode << 12);
        assemBinary |= (uint)(src1Reg << 15);
        assemBinary |= (uint)(src2Reg << 20);
        assemBinary |= (uint)(func7 << 25);
    }

    private void ParseIFormat(ref uint assemBinary, Instruction instruction)
    {
        ushort destReg = ParseRegister();
        EatToken(Lexer.TokenType.Separator);
        ushort src1Reg;
        int immediate;
        if (instruction.Arguments[1] == Instruction.Argument.RegisterImmediate)
        {
            (src1Reg, immediate) = ParseSymbol();
        }
        else
        {
            src1Reg = ParseRegister();
            EatToken(Lexer.TokenType.Separator);
            immediate = ParseImmediate();
        }

        ushort func3 = 0;

        // Set ALU code
        switch (instruction.Keyword)
        {
            case "slli":
                func3 = 0b001;
                break;
            case "slti":
                func3 = 0b010;
                break;
            case "sltiu":
                func3 = 0b011;
                break;
            case "xori":
                func3 = 0b100;
                break;
            case "srli":
                func3 = 0b101;
                break;
            case "srai":
                func3 = 0b101;
                immediate |= 0b1 << 10;
                break;
            case "ori":
                func3 = 0b110;
                break;
            case "andi":
                func3 = 0b111;
                break;
            case "lh":
                func3 = 0b001;
                break;
            case "lw":
                func3 = 0b010;
                break;
            case "lbu":
                func3 = 0b100;
                break;
            case "lhu":
                func3 = 0b101;
                break;
        }

        StoreIFormat(ref assemBinary, destReg, src1Reg, func3, immediate);
    }

    private void StoreIFormat(ref uint assemBinary, ushort destReg, ushort src1Reg, ushort func3,
        int immediate)
    {
        assemBinary |= (uint)(destReg << 7);
        assemBinary |= (uint)(func3 << 12);
        assemBinary |= (uint)(src1Reg << 15);
        assemBinary |= (uint)(immediate << 20);
    }

    private void ParseSFormat(ref uint assemBinary, Instruction instruction)
    {
        ushort storeReg = ParseRegister();
        EatToken(Lexer.TokenType.Separator);
        (ushort destReg, int immediate) = ParseSymbol();

        switch (instruction.Keyword)
        {
            case "sh":
                assemBinary |= 0b001 << 12;
                break;
            case "sw":
                assemBinary |= 0b010 << 12;
                break;
        }

        assemBinary |= (uint)(storeReg << 20);
        assemBinary |= (uint)(destReg << 15);
        assemBinary |= (uint)((immediate & 0b11111) << 7);
        assemBinary |= (uint)(((immediate >> 5) & 0b1111111) << 25);
    }

    private void ParseUFormat(ref uint assemBinary)
    {
        ushort destReg = ParseRegister();
        EatToken(Lexer.TokenType.Separator);
        int immediate = ParseImmediate();
        StoreUFormat(ref assemBinary, destReg, immediate);
    }

    private void StoreUFormat(ref uint assemBinary, ushort destReg, int immediate)
    {
        assemBinary |= (uint)(destReg << 7);
        assemBinary |= (uint)(immediate << 12);
    }

    private void ParseBFormat(ref uint assemBinary, Instruction instruction)
    {
        ushort src1Reg = ParseRegister();
        EatToken(Lexer.TokenType.Separator);
        ushort src2Reg = ParseRegister();
        EatToken(Lexer.TokenType.Separator);
        int immediate = ParseImmediate();

        ushort func3 = 0;

        switch (instruction.Keyword)
        {
            case "bne":
                func3 = 0b001;
                break;
            case "blt":
                func3 = 0b100;
                break;
            case "bge":
                func3 = 0b101;
                break;
            case "bltu":
                func3 = 0b110;
                break;
            case "bgeu":
                func3 = 0b111;
                break;
        }

        StoreBFormat(ref assemBinary, src1Reg, src2Reg, func3, immediate);
    }

    private void StoreBFormat(ref uint assemBinary, ushort src1Reg, ushort src2Reg, ushort func3, int immediate)
    {
        assemBinary |= (uint)(func3 << 12);
        assemBinary |= (uint)(src1Reg << 15);
        assemBinary |= (uint)(src2Reg << 20);
        assemBinary |= (uint)((immediate >> 11) & 0b1) << 7;
        assemBinary |= (uint)((immediate >> 1) & 0b1111) << 8;
        assemBinary |= (uint)((immediate >> 5) & 0b111111) << 25;
        assemBinary |= (uint)((immediate >> 12) & 0b1) << 31;
    }

    private void ParseJFormat(ref uint assemBinary)
    {
        ushort destReg = ParseRegister();
        EatToken(Lexer.TokenType.Separator);
        int immediate = ParseImmediate();
        StoreJFormat(ref assemBinary, destReg, immediate);
    }

    private void StoreJFormat(ref uint assemBinary, ushort destReg, int immediate)
    {
        assemBinary |= (uint)(((immediate >> 12) & 0b1111_1111) << 12);
        assemBinary |= (uint)(((immediate >> 11) & 0b1) << 20);
        assemBinary |= (uint)(((immediate >> 1) & 0b11_1111_1111) << 21);
        assemBinary |= (uint)(((immediate >> 20) & 0b1) << 31);
        assemBinary |= (uint)(destReg << 7);
    }

    private void ParsePseudoOperation(Instruction instruction)
    {
        uint assemBinary = 0;
        switch (instruction.Keyword)
        {
            case "nop":
            {
                assemBinary = Instruction.AddImm.Opcode;
                StoreIFormat(ref assemBinary, 0, 0, 0, 0);
                break;
            }
            case "li":
            {
                assemBinary = Instruction.AddImm.Opcode;
                ushort destReg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                int immediate = ParseImmediate();
                StoreIFormat(ref assemBinary, destReg, 0, 0, immediate);
                break;
            }
            case "mv":
            {
                assemBinary = Instruction.AddImm.Opcode;
                ushort destReg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                ushort srcReg = ParseRegister();
                StoreIFormat(ref assemBinary, destReg, srcReg, 0, 0);
                break;
            }
            case "not":
            {
                assemBinary = Instruction.XorImm.Opcode;
                ushort destReg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                ushort srcReg = ParseRegister();
                StoreIFormat(ref assemBinary, destReg, srcReg, 0b100, 0);
                break;
            }
            case "neg":
            {
                assemBinary = Instruction.Sub.Opcode;
                ushort destReg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                ushort srcReg = ParseRegister();
                StoreRFormat(ref assemBinary, destReg, 0, srcReg, 0, 0b0100000);
                break;
            }
            case "seqz":
            {
                assemBinary = Instruction.SetLessImmUnsigned.Opcode;
                ushort destReg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                ushort srcReg = ParseRegister();
                StoreIFormat(ref assemBinary, destReg, srcReg, 0b011, 1);
                break;
            }
            case "snez":
            {
                assemBinary = Instruction.SetLessUnsigned.Opcode;
                ushort destReg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                ushort srcReg = ParseRegister();
                StoreRFormat(ref assemBinary, destReg, 0, srcReg, 0b011, 0);
                break;
            }
            case "sltz":
            {
                assemBinary = Instruction.SetLess.Opcode;
                ushort destReg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                ushort srcReg = ParseRegister();
                StoreRFormat(ref assemBinary, destReg, srcReg, 0, 0b010, 0);
                break;
            }
            case "sgtz":
            {
                assemBinary = Instruction.SetLess.Opcode;
                ushort destReg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                ushort srcReg = ParseRegister();
                StoreRFormat(ref assemBinary, destReg, 0, srcReg, 0b010, 0);
                break;
            }
            case "beqz":
            {
                assemBinary = Instruction.BranchEq.Opcode;
                ushort srcReg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                int offset = ParseImmediate();
                StoreBFormat(ref assemBinary, srcReg, 0, 0, offset);
                break;
            }
            case "bnez":
            {
                assemBinary = Instruction.BranchNeq.Opcode;
                ushort srcReg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                int offset = ParseImmediate();
                StoreBFormat(ref assemBinary, srcReg, 0, 0b001, offset);
                break;
            }
            case "blez":
            {
                assemBinary = Instruction.BranchGreaterEq.Opcode;
                ushort srcReg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                int offset = ParseImmediate();
                StoreBFormat(ref assemBinary, 0, srcReg, 0b101, offset);
                break;
            }
            case "bgez":
            {
                assemBinary = Instruction.BranchGreaterEq.Opcode;
                ushort srcReg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                int offset = ParseImmediate();
                StoreBFormat(ref assemBinary, srcReg, 0, 0b101, offset);
                break;
            }
            case "bltz":
            {
                assemBinary = Instruction.BranchLess.Opcode;
                ushort srcReg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                int offset = ParseImmediate();
                StoreBFormat(ref assemBinary, srcReg, 0, 0b100, offset);
                break;
            }
            case "bgtz":
            {
                assemBinary = Instruction.BranchLess.Opcode;
                ushort srcReg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                int offset = ParseImmediate();
                StoreBFormat(ref assemBinary, 0, srcReg, 0b100, offset);
                break;
            }
            case "bgt":
            {
                assemBinary = Instruction.BranchLess.Opcode;
                ushort src1Reg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                ushort src2Reg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                int offset = ParseImmediate();
                StoreBFormat(ref assemBinary, src2Reg, src1Reg, 0b100, offset);
                break;
            }
            case "ble":
            {
                assemBinary = Instruction.BranchGreaterEq.Opcode;
                ushort src1Reg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                ushort src2Reg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                int offset = ParseImmediate();
                StoreBFormat(ref assemBinary, src2Reg, src1Reg, 0b101, offset);
                break;
            }
            case "bgtu":
            {
                assemBinary = Instruction.BranchLessUnsigned.Opcode;
                ushort src1Reg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                ushort src2Reg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                int offset = ParseImmediate();
                StoreBFormat(ref assemBinary, src2Reg, src1Reg, 0b110, offset);
                break;
            }
            case "bleu":
            {
                assemBinary = Instruction.BranchGreaterEqUnsigned.Opcode;
                ushort src1Reg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                ushort src2Reg = ParseRegister();
                EatToken(Lexer.TokenType.Separator);
                int offset = ParseImmediate();
                StoreBFormat(ref assemBinary, src2Reg, src1Reg, 0b111, offset);
                break;
            }
            case "j":
            {
                assemBinary = Instruction.JumpLink.Opcode;
                int offset = ParseImmediate();
                StoreJFormat(ref assemBinary, 0, offset);
                break;
            }
            case "jr":
            {
                assemBinary = Instruction.JumpLinkRegister.Opcode;
                ushort srcReg = ParseRegister();
                StoreIFormat(ref assemBinary, 0, srcReg, 0, 0);
                break;
            }
            case "ret":
            {
                assemBinary = Instruction.JumpLinkRegister.Opcode;
                StoreIFormat(ref assemBinary, 0, 1, 0, 0);
                break;
            }
            case "call":
            {
                assemBinary = Instruction.AddUpperImmPC.Opcode;
                int offset = ParseImmediate();
                StoreUFormat(ref assemBinary, 6, (offset >> 12) + (1 & (offset >> 11)));
                _output.Add(assemBinary);
                assemBinary = Instruction.JumpLinkRegister.Opcode;
                StoreIFormat(ref assemBinary, 1, 6, 0, offset & 0xfffff);
                break;
            }
            case "tail":
            {
                assemBinary = Instruction.AddUpperImmPC.Opcode;
                int offset = ParseImmediate();
                StoreUFormat(ref assemBinary, 6, (offset >> 12) + (1 & (offset >> 11)));
                _output.Add(assemBinary);
                assemBinary = Instruction.JumpLinkRegister.Opcode;
                StoreIFormat(ref assemBinary, 0, 6, 0, offset & 0xfffff);
                break;
            }
        }

        _output.Add(assemBinary);
    }

    private ushort ParseRegister()
    {
        Lexer.Token regToken = EatToken(Lexer.TokenType.Register);
        return Register.GetRegisterNumber(regToken.Value);
    }

    private int ParseImmediate()
    {
        Lexer.Token immediateToken = EatToken(Lexer.TokenType.Literal, Lexer.TokenType.Identifier);
        if (immediateToken.TokenType == Lexer.TokenType.Identifier)
        {
            if (_symbolTable.Labels.TryGetValue(immediateToken.Value, out var label))
            {
                return (int)label - _output.Count * 4;;
            }
            else
            {
                throw new Exception($"Undefined label: {immediateToken.Value}");
            }
        }

        int fromBase = immediateToken.Value.Contains('x') ? 16 : 10;
        return Convert.ToInt32(immediateToken.Value, fromBase);
    }

    private (ushort, int) ParseSymbol()
    {
        ushort reg = 0;
        int immediate = ParseImmediate();
        if (CurrentToken.TokenType == Lexer.TokenType.LParam)
        {
            EatToken(Lexer.TokenType.LParam);
            reg = ParseRegister();
            EatToken(Lexer.TokenType.RParam);
        }

        return (reg, immediate);
    }

    private void CheckFit(int value, int bits, bool signed)
    {
    }

    public static uint[] Assemble(string input)
    {
        return new Assembler(input).Assemble();
    }
}