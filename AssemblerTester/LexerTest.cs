using Assembler;

namespace AssemblerTester;

public class LexerTest
{
    [SetUp]
    public void Setup()
    {
        
    }

    [Test]
    public void TestParseInstruction()
    {
        string assembly = "add x1, x2, x3";
        Lexer.TokenType[] expectedTokens =
        [
            Lexer.TokenType.Instruction, Lexer.TokenType.Register, Lexer.TokenType.Separator, Lexer.TokenType.Register,
            Lexer.TokenType.Separator, Lexer.TokenType.Register, Lexer.TokenType.EOL, Lexer.TokenType.EOF
        ];
        
        List<Lexer.Token> tokens = Lexer.Tokenize(assembly);
        
        Assert.That(tokens.Count, Is.EqualTo(expectedTokens.Length));
        
        for (var i = 0; i < expectedTokens.Length; i++)
        {
            Assert.That(tokens[i].TokenType, Is.EqualTo(expectedTokens[i]));
        }
    }
}