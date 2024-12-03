namespace Assembler;

public class Instruction
{
    // Load
    public static readonly Instruction LoadByte = new("Load Byte", "lb", false,
        [Argument.Register, Argument.RegisterImmediate], 0b0000011, InstructionFormat.I);

    public static readonly Instruction LoadHalfWord = new("Load Half Word", "lh", false,
        [Argument.Register, Argument.RegisterImmediate], 0b0000011, InstructionFormat.I);

    public static readonly Instruction LoadWord = new("Load Word", "lw", false,
        [Argument.Register, Argument.RegisterImmediate], 0b0000011, InstructionFormat.I);

    public static readonly Instruction LoadByteUnsigned = new("Load Byte Unsigned", "lbu", false,
        [Argument.Register, Argument.RegisterImmediate], 0b0000011, InstructionFormat.I);

    public static readonly Instruction LoadHalfUnsigned = new("Load Half Unsigned", "lhu", false,
        [Argument.Register, Argument.RegisterImmediate], 0b0000011, InstructionFormat.I);

    // public static readonly Instruction LoadAddress = new("Load Address", "la", true,
    //     [Argument.Register, Argument.Immediate], 0, InstructionFormat.P);

    public static readonly Instruction LoadImm = new("Load Immediate", "li", true,
        [Argument.Register, Argument.Immediate], 0, InstructionFormat.P);

    // Store
    public static readonly Instruction StoreByte = new("Store Byte", "sb", false,
        [Argument.Register, Argument.RegisterImmediate], 0b0100011, InstructionFormat.S);

    public static readonly Instruction StoreHalfWord = new("Store Half Word", "sh", false,
        [Argument.Register, Argument.RegisterImmediate], 0b0100011, InstructionFormat.S);

    public static readonly Instruction StoreWord = new("Store Word", "sw", false,
        [Argument.Register, Argument.RegisterImmediate], 0b0100011, InstructionFormat.S);

    // Shift
    public static readonly Instruction ShiftLeft = new("Shift Left", "sll", false,
        [Argument.Register, Argument.Register, Argument.Register], 0b0110011, InstructionFormat.R);

    public static readonly Instruction ShiftLeftImm = new("Shift Left Immediate", "slli", false,
        [Argument.Register, Argument.Register, Argument.ShiftAmount], 0b0010011, InstructionFormat.I);

    public static readonly Instruction ShiftRight = new("Shift Right", "srl", false,
        [Argument.Register, Argument.Register, Argument.Register], 0b0110011, InstructionFormat.R);

    public static readonly Instruction ShiftRightImm = new("Shift Right Immediate", "srli", false,
        [Argument.Register, Argument.Register, Argument.ShiftAmount], 0b0010011, InstructionFormat.I);

    public static readonly Instruction ShiftRightArith = new("Shift Right Arithmetic", "sra", false,
        [Argument.Register, Argument.Register, Argument.Register], 0b0110011, InstructionFormat.R);

    public static readonly Instruction ShiftRightArithImm = new("Shift Right Arithmetic Immediate", "srai", false,
        [Argument.Register, Argument.Register, Argument.ShiftAmount], 0b0010011, InstructionFormat.I);

    // Arithmetic
    public static readonly Instruction Add = new("Add", "add", false,
        [Argument.Register, Argument.Register, Argument.Register], 0b0110011, InstructionFormat.R);

    public static readonly Instruction AddImm = new("Add Immediate", "addi", false,
        [Argument.Register, Argument.Register, Argument.Immediate], 0b0010011, InstructionFormat.I);

    public static readonly Instruction Sub = new("Subtract", "sub", false,
        [Argument.Register, Argument.Register, Argument.Register], 0b0110011, InstructionFormat.R);

    public static readonly Instruction LoadUpperImm = new("Load Upper Immediate", "lui", false,
        [Argument.Register, Argument.Immediate], 0b0110111, InstructionFormat.U);

    public static readonly Instruction AddUpperImmPC = new("Add Upper Immediate to PC", "auipc", false,
        [Argument.Register, Argument.Immediate], 0b0010111, InstructionFormat.U);

    public static readonly Instruction Negate = new("Two's Complement Invert", "neg", true,
        [Argument.Register, Argument.Register], 0, InstructionFormat.P);

    // Logical
    public static readonly Instruction Xor = new("Bitwise XOR", "xor", false,
        [Argument.Register, Argument.Register, Argument.Register],
        0b0110011, InstructionFormat.R);

    public static readonly Instruction XorImm = new("Bitwise XOR Immediate", "xori", false,
        [Argument.Register, Argument.Register, Argument.Immediate],
        0b0010011, InstructionFormat.I);

    public static readonly Instruction Or = new("Bitwise OR", "or", false,
        [Argument.Register, Argument.Register, Argument.Register],
        0b0110011, InstructionFormat.R);

    public static readonly Instruction OrImm = new("Bitwise OR Immediate", "ori", false,
        [Argument.Register, Argument.Register, Argument.Immediate],
        0b0010011, InstructionFormat.I);

    public static readonly Instruction And = new("Bitwise AND", "and", false,
        [Argument.Register, Argument.Register, Argument.Register],
        0b0110011, InstructionFormat.R);

    public static readonly Instruction AndImm = new("Bitwise AND Immediate", "andi", false,
        [Argument.Register, Argument.Register, Argument.Immediate],
        0b0010011, InstructionFormat.I);

    public static readonly Instruction Not = new("One's Complement Invert", "not", true,
        [Argument.Register, Argument.Register], 0, InstructionFormat.P);

    // Compare
    public static readonly Instruction SetLess = new("Set Less Than", "slt", false,
        [Argument.Register, Argument.Register, Argument.Register], 0b0110011, InstructionFormat.R);

    public static readonly Instruction SetLessImm = new("Set Less Than Immediate", "slti", false,
        [Argument.Register, Argument.Register, Argument.Immediate], 0b0010011, InstructionFormat.I);

    public static readonly Instruction SetLessUnsigned = new("Set Less Than Unsigned", "sltu", false,
        [Argument.Register, Argument.Register, Argument.Register], 0b0110011, InstructionFormat.R);

    public static readonly Instruction SetLessImmUnsigned = new("Set Less Than Immediate Unsigned", "sltiu", false,
        [Argument.Register, Argument.Register, Argument.Immediate], 0b0010011, InstructionFormat.I);

    public static readonly Instruction SetEqualZero = new("Set If rs = zero", "seqz", true,
        [Argument.Register, Argument.Register], 0, InstructionFormat.P);

    public static readonly Instruction SetNotEqualZero = new("Set If rs != zero", "snez", true,
        [Argument.Register, Argument.Register], 0, InstructionFormat.P);

    public static readonly Instruction SetLessZero = new("Set If rs < zero", "sltz", true,
        [Argument.Register, Argument.Register], 0, InstructionFormat.P);

    public static readonly Instruction SetGreaterZero = new("Set If rs > zero", "sgtz", true,
        [Argument.Register, Argument.Register], 0, InstructionFormat.P);

    // Branches
    public static readonly Instruction BranchEq = new("Branch Equal", "beq", false,
        [Argument.Register, Argument.Register, Argument.Immediate], 0b1100011, InstructionFormat.B);

    public static readonly Instruction BranchNeq = new("Branch Not Equal", "bne", false,
        [Argument.Register, Argument.Register, Argument.Immediate], 0b1100011, InstructionFormat.B);

    public static readonly Instruction BranchLess = new("Branch Less Than", "blt", false,
        [Argument.Register, Argument.Register, Argument.Immediate], 0b1100011, InstructionFormat.B);

    public static readonly Instruction BranchGreaterEq = new("Branch Greater Than Equal", "bge", false,
        [Argument.Register, Argument.Register, Argument.Immediate], 0b1100011, InstructionFormat.B);

    public static readonly Instruction BranchLessUnsigned = new("Branch Less Than Unsigned", "bltu", false,
        [Argument.Register, Argument.Register, Argument.Immediate], 0b1100011, InstructionFormat.B);

    public static readonly Instruction BranchGreaterEqUnsigned = new("Branch Greater Than Equal Unsigned", "bgeu",
        false,
        [Argument.Register, Argument.Register, Argument.Immediate], 0b1100011, InstructionFormat.B);
    
    public static readonly Instruction BranchEqZero = new("Branch If rs = 0", "beqz", true,
        [Argument.Register, Argument.Immediate], 0, InstructionFormat.P);

    public static readonly Instruction BranchNeqZero = new("Branch If rs != 0", "bnez", true,
        [Argument.Register, Argument.Immediate], 0, InstructionFormat.P);

    public static readonly Instruction BranchLessZero = new("Branch If rs < 0", "bltz", true,
        [Argument.Register, Argument.Immediate], 0, InstructionFormat.P);
    
    public static readonly Instruction BranchLessEqZero = new("Branch If rs <= 0", "blez", true,
        [Argument.Register, Argument.Immediate], 0, InstructionFormat.P);
    
    public static readonly Instruction BranchGreaterZero = new("Branch If rs > 0", "bgez", true,
        [Argument.Register, Argument.Immediate], 0, InstructionFormat.P);
    
    public static readonly Instruction BranchGreaterEqZero = new("Branch If rs >= 0", "bgtz", true,
        [Argument.Register, Argument.Immediate], 0, InstructionFormat.P);
    
    public static readonly Instruction BranchGreater = new("Branch If > ", "bgt", true,
        [Argument.Register, Argument.Register, Argument.Immediate], 0, InstructionFormat.P);
    
    public static readonly Instruction BranchLessEq = new("Branch If <= ", "ble", true,
        [Argument.Register, Argument.Register, Argument.Immediate], 0, InstructionFormat.P);
    
    public static readonly Instruction BranchGreaterUnsigned = new("Branch If > Unsigned", "bgtu", true,
        [Argument.Register, Argument.Register, Argument.Immediate], 0, InstructionFormat.P);
    
    public static readonly Instruction BranchLessEqUnsigned = new("Branch If <= Unsigned", "bleu", true,
        [Argument.Register, Argument.Register, Argument.Immediate], 0, InstructionFormat.P);

    // Move
    public static readonly Instruction Move = new("Copy Register", "mv", true, [Argument.Register, Argument.Register],
        0, InstructionFormat.P);

    // Jump & Link
    public static readonly Instruction JumpLink = new("Jump And Link", "jal", false,
        [Argument.Register, Argument.Immediate],
        0b1101111, InstructionFormat.J);

    public static readonly Instruction JumpLinkRegister = new("Jump And Link Register", "jalr", false,
        [Argument.Register, Argument.Register, Argument.Immediate], 0b1100111, InstructionFormat.I);
    
    public static readonly Instruction Jump = new("Jump", "j", true, [Argument.Immediate], 0, InstructionFormat.P);
    
    public static readonly Instruction JumpRegister = new ("Jump Register", "jr", true, [Argument.Register], 0, InstructionFormat.P);

    public static readonly Instruction Return = new("Return From Subroutine", "ret", true, [], 0, InstructionFormat.P);
    
    public static readonly Instruction Call = new ("Call Subroutine", "call", true, [Argument.Immediate], 0, InstructionFormat.P);
    
    public static readonly Instruction Tail = new ("Tail Call Far Away Subroutine", "tail", true, [Argument.Immediate], 0, InstructionFormat.P);

    // Sync
    public static readonly Instruction SynchThread =
        new("Synch Thread", "fence", false, [], 0b0001111, InstructionFormat.I);

    public static readonly Instruction SynchInstrAndData =
        new("Synch Instruction and Data", "fence.i", false, [], 0b0001111, InstructionFormat.I);

    // System
    public static readonly Instruction SystemCall = new("System Call", "scall", false, [], 0b1110011,
        InstructionFormat.I);

    public static readonly Instruction SystemBreak =
        new("System Break", "sbreak", false, [], 0b1110011, InstructionFormat.I);

    public static readonly Instruction NOP = new("No Operation", "nop", true, [], 0, InstructionFormat.P);

    public static Instruction[] AllInstructions =
    [
        LoadByte,
        LoadHalfWord,
        LoadWord,
        LoadByteUnsigned,
        LoadHalfUnsigned,
        LoadImm,
        StoreByte,
        StoreHalfWord,
        StoreWord,
        ShiftLeft,
        ShiftLeftImm,
        ShiftRight,
        ShiftRightImm,
        ShiftRightArith,
        ShiftRightArithImm,
        Add,
        AddImm,
        Sub,
        LoadUpperImm,
        AddUpperImmPC,
        Negate,
        Xor,
        XorImm,
        Or,
        OrImm,
        And,
        AndImm,
        Not,
        SetLess,
        SetLessImm,
        SetLessUnsigned,
        SetLessImmUnsigned,
        SetEqualZero,
        SetNotEqualZero,
        SetLessZero,
        SetGreaterZero,
        BranchEq,
        BranchNeq,
        BranchLess,
        BranchGreaterEq,
        BranchLessUnsigned,
        BranchGreaterEqUnsigned,
        BranchEqZero,
        BranchNeqZero,
        BranchLessZero,
        BranchLessEqZero,
        BranchGreaterZero,
        BranchGreaterEqZero,
        BranchGreater,
        BranchLessEq,
        BranchGreaterUnsigned,
        BranchLessEqUnsigned,
        Move,
        JumpLink,
        JumpLinkRegister,
        Jump,
        JumpRegister,
        Return,
        Call,
        Tail,
        SynchThread,
        SynchInstrAndData,
        SystemCall,
        SystemBreak,
        NOP,
    ];

    public string HumanName { get; private set; }
    public string Keyword { get; private set; }
    public bool IsPseudo { get; private set; }
    public Argument[] Arguments { get; private set; }
    public ushort Opcode { get; private set; }
    public InstructionFormat Format { get; private set; }

    private Instruction(string humanName, string keyword, bool isPseudo, Argument[] arguments, ushort opcode,
        InstructionFormat instructionFormat)
    {
        HumanName = humanName;
        Keyword = keyword;
        IsPseudo = isPseudo;
        Arguments = arguments;
        Opcode = opcode;
        Format = instructionFormat;
    }

    public static Instruction GetByKeyword(string keyword)
    {
        return AllInstructions.First(instruction => instruction.Keyword == keyword);
    }

    public static Instruction[] GetPseudoInstructions()
    {
        return AllInstructions.Where(instruction => instruction.IsPseudo).ToArray();
    }

    public enum Argument
    {
        Register,
        Immediate,
        ShiftAmount,
        RegisterImmediate,
    }

    public enum InstructionFormat
    {
        R,
        I,
        S,
        U,
        B,
        J,
        P
    }
}