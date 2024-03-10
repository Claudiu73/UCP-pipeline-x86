----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.11.2023 02:01:22
-- Design Name: 
-- Module Name: main - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is  -- configuratie placa Nexys4(A7)
Port 
(
    clk: in std_logic;
    sw: out std_logic_vector(15 downto 0);
    btn: in std_logic_vector(4 downto 0);
    led: out std_logic_vector(15 downto 0);
    cat: out std_logic_vector(6 downto 0);
    an: out std_logic_vector(7 downto 0)
 );
end main;

architecture Behavioral of main is

component IFetch is
Port 
(
    clk: in std_logic;
    rst: in std_logic;
    en: in std_logic;
    PCinc: out std_logic_vector(31 downto 0);
    instruction: out std_logic_vector(31 downto 0)
 );
end component;


component MPG is
    Port ( en : out STD_LOGIC;
           D : in STD_LOGIC;
           clock : in STD_LOGIC);
end component;

component SSD is
Port 
(
    clk: in std_logic;
    cat: out std_logic_vector(6 downto 0);
    an: out std_logic_vector(7 downto 0);
    digits: in std_logic_vector(31 downto 0)
 );
end component;
    
    component Decode
        port (
            clk         : in STD_LOGIC;
            reset       : in STD_LOGIC;
            instruction : in STD_LOGIC_VECTOR(31 downto 0);
            RD1         : out STD_LOGIC_VECTOR(7 downto 0);
            RD2         : out STD_LOGIC_VECTOR(7 downto 0);
            we          : in STD_LOGIC;
            data_in     : in STD_LOGIC_VECTOR(7 downto 0);
            data_out    : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
    
    component ALU_component is
    Port ( 
           RD1 : in STD_LOGIC_VECTOR(7 downto 0);
           RD2 : in STD_LOGIC_VECTOR(7 downto 0);
           ALUOp : in STD_LOGIC_VECTOR(7 downto 0);
           ALURes : out STD_LOGIC_VECTOR(7 downto 0)
           );
    end component;
    
    component WriteBack is
    Port ( 
           ALURes : in STD_LOGIC_VECTOR(7 downto 0);
           DataOut : in STD_LOGIC_VECTOR(7 downto 0);
           WriteSelect : in STD_LOGIC; 
           RegWriteData : out STD_LOGIC_VECTOR(7 downto 0)
           );
    end component;

    signal en, rst: std_logic;
    signal Instruction, PCinc, digits: std_logic_vector(31 downto 0);
    
    signal tb_clk       : STD_LOGIC := '0';
    signal tb_reset     : STD_LOGIC := '0';
    
    signal tb_en : std_logic;
    signal tb_PCinc : std_logic_vector(31 downto 0);
    
    signal tb_instruction: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal tb_RD1       : STD_LOGIC_VECTOR(7 downto 0);
    signal tb_RD2       : STD_LOGIC_VECTOR(7 downto 0);
    signal tb_we        : STD_LOGIC;
    signal tb_data_in   : STD_LOGIC_VECTOR(7 downto 0);
    signal tb_data_out  : STD_LOGIC_VECTOR(7 downto 0);
    
    signal tb_ALUOp : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_ALURes : std_logic_vector(7 downto 0);
    
    signal tb_DataOut : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_WriteSelect : std_logic := '0';
    signal tb_RegWriteData : std_logic_vector(7 downto 0);
    
    signal RD1, RD2: STD_LOGIC_VECTOR(7 downto 0);
    signal data_out, ALUOp, ALURes: std_logic_vector(7 downto 0);
    signal RegWriteBack, memSauAlu: std_logic;
    
    --semnale pentru registru IF-ID
    signal PCincIfId: std_logic_vector(31 downto 0);
    signal InstrIfId: std_logic_vector(31 downto 0);
    
    --semnale pentru registru ID-EX
    signal RD1IdEx: std_logic_vector(7 downto 0);
    signal RD2IdEx: std_logic_vector(7 downto 0);
    signal ALUOpIdEx, addressIdEx, data_outIdEx, source_regIdEx, target_regIdEx, opcodeIdEx: std_logic_vector(7 downto 0);
    signal RegWriteBackIdEx, memSauAluIdEx: std_logic;
    
    --semnale pentru registru EX-WB
    signal ALUResExWb: std_logic_vector(7 downto 0);
    signal RegWriteDataExWb: std_logic;
    
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                -- IF-ID
                PCincIfId <= PCinc;
                InstrIfId <= Instruction;
                --ID-EX
                RD1IdEx <= RD1;
                RD2IdEx <= RD2;
                RegWriteBackIdEx <= RegWriteBack;
                opcodeIdEx <= instruction(31 downto 24);
                target_regIdEx <= instruction(23 downto 16);
                source_regIdEx <= instruction(15 downto 8);
                addressIdEx <= instruction(7 downto 0);
                memSauAluIdEx <= memSauAlu;
                data_outIdEx <= data_out;
                ALUOpIdEx <= ALUOp;
                --EX-WB 
                ALUResExWb <= ALURes;
                RegWriteDataExWb <= RegWriteBack;
            end if;
        end if;
    end process;

    InstructionButton: MPG port map(en, btn(0), clk);
    ResetButton: MPG port map (rst, btn(1), clk);

    --Instruction <= PCinc;
    digits <= Instruction;

    display: SSD port map (clk, cat, an, digits);

    IF_sim: IFetch port map (tb_clk, tb_reset, tb_en, tb_PCinc, Instruction);

    clk_process :process
    begin
        tb_clk <= '0';
        wait for 10 ns;
        tb_clk <= '1';
        wait for 10 ns;
    end process;

    stimuli_process: process
    begin

        tb_reset <= '1';
        wait for 20 ns;
        tb_reset <= '0';
        
        tb_en <= '1';
        
        wait for 100 ns;
        
    end process;
      


D_sim: Decode port map(tb_clk, tb_reset, tb_instruction, tb_RD1, tb_RD2, tb_we, tb_data_in, tb_data_out);

 clk_process_d : process
    begin
        tb_clk <= '0';
        wait for 10 ns; 
        tb_clk <= '1';
        wait for 10 ns;
    end process;
    
    test_process : process
    begin
        
        tb_reset <= '1';
        wait for 20 ns;
        tb_reset <= '0';
        
        tb_instruction <= x"89A3_0500";
        tb_data_in <= x"05"; 
        wait for 20 ns; 

        wait;
    end process;
    
    EX_sim: ALU_component port map (tb_RD1, tb_RD2, tb_ALUOp, tb_ALURes);
    
    stim_proc: process
   begin		

    wait for 10 ns;	

    -- Test 1 - ADD
    tb_RD1 <= "00000101"; -- 5
    tb_RD2 <= "00000010"; -- 2
    tb_ALUOp <= X"3B";    -- Opcode for ADD
    wait for 100 ns;  
      
      -- Test 2 - SUB
    tb_RD1 <= "00000101"; -- 5
    tb_RD2 <= "00000011"; -- 3
    tb_ALUOp <= X"3C";    -- Opcode for SUB
    wait for 100 ns;
      
    -- Test 3 - MOV
    tb_RD1 <= "00000101";
    tb_RD2 <= "00000000"; 
    tb_ALUOp <= X"89";    -- Opcode for MOV
    wait for 100 ns;

  -- Test 4 - CMP 
    tb_RD1 <= "00000100"; -- 4
    tb_RD2 <= "00000100"; -- 4
    tb_ALUOp <= X"83";    -- Opcode for CMP
    wait for 100 ns;

    -- Test 5 - Unknown Operation
    tb_RD1 <= "00000001"; -- 1
    tb_RD2 <= "00000010"; -- 2
    tb_ALUOp <= X"FF";    -- Unknown Opcode
    wait for 100 ns;

    wait;
    end process;
    
    WB_sim: WriteBack port map (tb_ALURes, tb_DataOut, tb_WriteSelect, tb_RegWriteData);
    
    stim_proc_2: process
    begin		

      wait for 100 ns;	

      tb_DataOut <= "11110000"; 
      tb_WriteSelect <= '1';    
      wait for 100 ns;

      tb_WriteSelect <= '0';  
      wait for 100 ns;

      tb_DataOut <= "01010101";
      tb_WriteSelect <= '1';  
      wait for 100 ns;

      tb_WriteSelect <= '0'; 
      wait for 100 ns;
      
      wait;
   end process;
    
end Behavioral;
