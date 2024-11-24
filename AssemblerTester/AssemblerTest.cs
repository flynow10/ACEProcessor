using Assembler;

namespace AssemblerTester;

[TestFixture]
public class AssemblerTest
{
    [SetUp]
    public void Setup()
    {
    }

    [Test]
    public void TestSimpleAddition()
    {
        string inputText = """
                           .text
                           addi x1, x0, 10
                           addi x2, zero, 3
                           add x3, x1, x2
                           """;

        uint[] expected =
        [
            0b00000000101000000000000010010011,
            0b00000000001100000000000100010011,
            0b00000000001000001000000110110011
        ];
        
        uint[] output = Assembler.Assembler.Assemble(inputText);

        Assert.That(output, Is.EquivalentTo(expected));
    }
}