# Resources

- Tiny RISCV
- RARS (RISC-V Assembler and Runtime Simulator)

# Processer Specification

This is an implementation of the RISC-V 32-bit instruction set architecture (ISA) in Verilog.

## RISC-V Instruction Set Architecture

<table>
  <thead>
    <tr>
      <th rowspan=2>Format</th>
      <th colspan=32>Bits</th>
    </tr>
    <tr>
      <th>31</th>
      <th>30</th>
      <th>29</th>
      <th>28</th>
      <th>27</th>
      <th>26</th>
      <th>25</th>
      <th>24</th>
      <th>23</th>
      <th>22</th>
      <th>21</th>
      <th>20</th>
      <th>19</th>
      <th>18</th>
      <th>17</th>
      <th>16</th>
      <th>15</th>
      <th>14</th>
      <th>13</th>
      <th>12</th>
      <th>11</th>
      <th>10</th>
      <th>9</th>
      <th>8</th>
      <th>7</th>
      <th>6</th>
      <th>5</th>
      <th>4</th>
      <th>3</th>
      <th>2</th>
      <th>1</th>
      <th>0</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Register</th>
      <td colspan=7>funct7</td>
      <td colspan=5>rs2</td>
      <td colspan=5>rs1</td>
      <td colspan=3>funct3</td>
      <td colspan=5>rd</td>
      <td colspan=7>opcode</td>
    </tr>
    <tr>
      <th>Immediate</th>
      <td colspan=12>imm[11:0]</td>
      <td colspan=5>rs1</td>
      <td colspan=3>funct3</td>
      <td colspan=5>rd</td>
      <td colspan=7>opcode</td>
    </tr>
    <tr>
      <th>Store</th>
      <td colspan=7>imm[11:5]</td>
      <td colspan=5>rs2</td>
      <td colspan=5>rs1</td>
      <td colspan=3>funct3</td>
      <td colspan=5>imm[4:0]</td>
      <td colspan=7>opcode</td>
    </tr>
    <tr>
      <th>Branch</th>
      <td>[12]</td>
      <td colspan=6>imm[10:5]</td>
      <td colspan=5>rs2</td>
      <td colspan=5>rs1</td>
      <td colspan=3>funct3</td>
      <td colspan=4>imm[4:1]</td>
      <td>[11]</td>
      <td colspan=7>opcode</td>
    </tr>
    <tr>
      <th>Upper Immediate</th>
      <td colspan=20>imm[31:12]</td>
      <td colspan=5>rd</td>
      <td colspan=7>opcode</td>
    </tr>
    <tr>
      <th>Jump</th>
      <td>[20]</td>
      <td colspan=10>imm[10:1]</td>
      <td>[11]</td>
      <td colspan=8>imm[19:12]</td>
      <td colspan=5>rd</td>
      <td colspan=7>opcode</td>
    </tr>
  </tbody>
</table>
