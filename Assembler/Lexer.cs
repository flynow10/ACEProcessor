using System.Text.RegularExpressions;

namespace Assembler;

public class Lexer
{
    public static List<Token> Tokenize(string input)
    {
        Dictionary<char, TokenType> singleCharTokens = new Dictionary<char, TokenType>
        {
            {',', TokenType.Separator},
            {'(', TokenType.LParam},
            {')', TokenType.RParam}
        };
        List<Token> tokens = new List<Token>();

        int position = 0;
        int line = 0;
        int linePosition = 0;
        while (position < input.Length)
        {
            char c = input[position];
            
            if (c == '\n' || c == '\r')
            {
                if (tokens.Count > 0 && tokens.Last().TokenType != TokenType.EOL)
                {
                    tokens.Add(new Token(TokenType.EOL, c.ToString(), line));
                }
                position++;
                line++;
                linePosition = 0;
                continue;
            }

            if (char.IsWhiteSpace(c))
            {
                position++;
                linePosition++;
                continue;
            }

            if (c == '#')
            {
                while (position < input.Length && input[position] != '\n' && input[position] != '\r')
                {
                    position++;
                    linePosition++;
                }
                continue;
            }

            if (char.IsDigit(c) || c == '-')
            {
                string remainingInput = input.Substring(position);
                string number = new Regex("^-?(0x[0-9a-fA-F]+|[0-9]+)\\b").Match(remainingInput).Value;
                if (number.Length == 0)
                {
                    throw new FormatException("Could not parse number!");
                }
                tokens.Add(new Token(TokenType.Literal, number, line));
                position += number.Length;
                linePosition += number.Length;
                continue;
            }
            bool matched = false;
            foreach (KeyValuePair<char,TokenType> singleCharToken in singleCharTokens)
            {
                if (c == singleCharToken.Key)
                {
                    tokens.Add(new Token(singleCharToken.Value, c.ToString(), line));
                    matched = true;
                    break;
                }
            }

            if (matched)
            {
                position++;
                linePosition++;
                continue;
            }

            if (c == '.')
            {
                position++;
                linePosition++;
                string remainingInput = input.Substring(position);
                string directive = new Regex("^[A-Za-z]+").Match(remainingInput).Value;
                tokens.Add(new Token(TokenType.Directive, directive, line));
                position += directive.Length;
                linePosition += directive.Length;
                continue;
            }
            

            if (char.IsLetter(c))
            {
                string remainingInput = input.Substring(position);
                Regex labelMatch = new Regex("^[A-Za-z][A-Za-z0-9_]*(?=:)");
                if (labelMatch.IsMatch(remainingInput))
                {
                    string label = labelMatch.Match(remainingInput).Value;
                    tokens.Add(new Token(TokenType.Label, label, line));
                    position += label.Length + 1;
                    linePosition += label.Length + 1;
                    continue;
                }

                matched = false;
                foreach (Instruction instruction in Instruction.AllInstructions)
                {
                    if (remainingInput.ToLower().StartsWith(instruction.Keyword + " "))
                    {
                        tokens.Add(new Token(TokenType.Instruction, instruction.Keyword, line));
                        position += instruction.Keyword.Length;
                        linePosition += instruction.Keyword.Length;
                        matched = true;
                    }
                }

                if (matched)
                    continue;
                
                Regex defaultRegisterMatch = new Regex("^x[0-9]{1,2}\\b");
                if (defaultRegisterMatch.IsMatch(remainingInput))
                {
                    string register = defaultRegisterMatch.Match(remainingInput).Value;
                    tokens.Add(new Token(TokenType.Register, register, line));
                    position += register.Length;
                    linePosition += register.Length;
                    continue;
                }
                
                foreach (string regName in Register.RegisterNames.Keys)
                {
                    if (remainingInput.ToLower().StartsWith(regName))
                    {
                        tokens.Add(new Token(TokenType.Register, regName, line));
                        position += regName.Length;
                        linePosition += regName.Length;
                        matched = true;
                    }
                }
                
                if(matched)
                    continue;

                string matchedLabel = new Regex("^[A-Za-z][A-Za-z0-9_]*").Match(remainingInput).Value;
                tokens.Add(new Token(TokenType.Identifier, matchedLabel, line));
                position += matchedLabel.Length;
                linePosition += matchedLabel.Length;
                continue;
            }
            
            throw new Exception($"Unrecognized character '{c}'");
        }

        if (tokens.Count > 0 && tokens.Last().TokenType != TokenType.EOL)
        {
            tokens.Add(new Token(TokenType.EOL, string.Empty, line));
        }
        tokens.Add(new Token(TokenType.EOF, string.Empty, line + 1));
        return tokens;
    }
    
    public static string Stringify(List<Token> tokens) => string.Join(", ", tokens.Select(t => t.ToString()));
    public enum TokenType
    {
        Instruction,
        Register,
        Literal,
        Identifier,
        Separator,
        Label,
        Directive,
        LParam,
        RParam,
        EOL,
        EOF
    }
    
    public class Token(TokenType tokenType, string value, int line)
    {
        public TokenType TokenType { get; protected set; } = tokenType;
        public string Value { get; protected set; } = value;
        public int Line { get; protected set; } = line;

        public override string ToString()
        {
            return $"{TokenType}({Value.Trim()},{Line})";
        }
    }
}