namespace Assembler;

public class Register
{
    public static Dictionary<string, ushort> RegisterNames { get; set; } = new()
    {
        { "zero", 0b00000 },
        { "ra", 0b00001 },
        { "sp", 0b00010 },
        { "gp", 0b00011 },
        { "tp", 0b00100 },
        { "t0", 0b00101 },
        { "t1", 0b00110 },
        { "t2", 0b00111 },
        { "fp", 0b01000 }, 
        { "s1", 0b01001 },
        { "a0", 0b01010 },
        { "a1", 0b01011 },
        { "a2", 0b01100 },
        { "a3", 0b01101 },
        { "a4", 0b01110 },
        { "a5", 0b01111 },
        { "a6", 0b10000 },
        { "a7", 0b10001 },
        { "s2", 0b10010 },
        { "s3", 0b10011 },
        { "s4", 0b10100 },
        { "s5", 0b10101 },
        { "s6", 0b10110 },
        { "s7", 0b10111 },
        { "s8", 0b11000 },
        { "s9", 0b11001 },
        { "s10", 0b11010 },
        { "s11", 0b11011 },
        { "t3", 0b11100 },
        { "t4", 0b11101 },
        { "t5", 0b11110 },
        { "t6", 0b11111 }
    };

    public static ushort GetRegisterNumber(string registerName)
    {
        if (registerName.StartsWith("x"))
            return ushort.Parse(registerName.Substring(1));

        return RegisterNames[registerName];
    }
}