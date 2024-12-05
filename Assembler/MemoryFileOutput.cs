namespace Assembler;

public class MemoryFileOutput
{
    private DataFormat _format;
    private uint[] _machineCode;

    public MemoryFileOutput(uint[] machineCode, DataFormat format = DataFormat.HEX)
    {
        _machineCode = machineCode;
        _format = format;
    }

    private string GetAddresses()
    {
        string addresses = "";
        int toBase = _format switch
        {
            DataFormat.HEX => 16,
            DataFormat.BIN => 2,
            _ => 10
        };
        for (int i = 0; i < _machineCode.Length; i++)
        {
            addresses += "  " + i.ToString("D") + " : " + Convert.ToString(_machineCode[i], toBase) + ";\n";
        }

        addresses += "  [" + _machineCode.Length.ToString("D") + "..65535] : 0;";

        return addresses;
    }
    
    public override string ToString()
    {
        return $"""
                WIDTH=32;
                DEPTH=65536;
                
                ADDRESS_RADIX=UNS;
                DATA_RADIX={_format switch
                {
                    DataFormat.HEX => "HEX",
                    DataFormat.DEC => "UNS",
                    _ => "BIN"
                }};

                CONTENT BEGIN
                {GetAddresses()}
                END;
                """;
    }

    public enum DataFormat
    {
        HEX,
        BIN,
        DEC
    }
}