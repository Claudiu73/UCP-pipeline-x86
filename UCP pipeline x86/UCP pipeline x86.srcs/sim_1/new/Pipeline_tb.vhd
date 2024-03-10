----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.01.2024 02:52:09
-- Design Name: 
-- Module Name: Pipeline_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Pipeline_tb is
--  Port ( );
end Pipeline_tb;

architecture Behavioral of Pipeline_tb is

-- Clock signal
    signal clk_s : std_logic := '0';
    signal rst_s : std_logic := '0';
    -- Enable signal
    signal en_s : std_logic;

    -- IF/ID pipeline registers signals
    signal PCincIfId_s : std_logic_vector(31 downto 0);
    signal InstrIfId_s : std_logic_vector(31 downto 0);

    -- ID/EX pipeline registers signals
    signal RD1IdEx_s : std_logic_vector(31 downto 0);
    signal RD2IdEx_s : std_logic_vector(31 downto 0);
    signal RegWriteBackIdEx_s : std_logic_vector(7 downto 0);
    signal opcodeIdEx_s : std_logic_vector(7 downto 0);
    signal target_regIdEx_s : std_logic_vector(7 downto 0);
    signal source_regIdEx_s : std_logic_vector(7 downto 0);
    signal addressIdEx_s : std_logic_vector(7 downto 0);
    signal memSauAluIdEx_s : std_logic;
    signal data_outIdEx_s : std_logic_vector(31 downto 0);
    signal ALUOpIdEx_s : std_logic_vector(7 downto 0);

    -- EX/MEM pipeline registers signals
    signal ALUResExWb_s : std_logic_vector(31 downto 0);
    signal RegWriteDataExWb_s : std_logic_vector(31 downto 0);

begin

-- Clock process definitions
    clk_process :process
    begin
        while true loop
            clk_s <= '0';
            wait for 10 ns;
            clk_s <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Stimuli process definitions
    stimuli_process: process
    begin
    -- Set the enable signal
    en_s <= '1';

    -- Initial Reset
    rst_s <= '1';
    wait for 20 ns; -- Wait for the system to reset
    rst_s <= '0';
    
    -- Initialize the IF/ID pipeline registers
    PCincIfId_s <= X"00000004"; -- Start with the second instruction address
    InstrIfId_s <= X"00000000"; -- No operation (NOP) instruction

    -- Wait for the clock to process inputs
    wait for 40 ns;

    -- Change the inputs to simulate fetching a new instruction
    PCincIfId_s <= X"00000008"; -- Next instruction address
    InstrIfId_s <= X"12345678"; -- Some operation, e.g., load or add

    -- Wait for the changes to propagate through the pipeline
    wait for 100 ns;

    -- Simulate another instruction fetch
    PCincIfId_s <= X"0000000C"; -- Continue to the next instruction address
    InstrIfId_s <= X"87654321"; -- Another operation, e.g., store or subtract
    
    -- Wait some time to observe the behavior
    wait for 100 ns;

    -- Simulate a pipeline disable (stall)
    en_s <= '0';
    wait for 40 ns;

    -- Re-enable the pipeline to see if it continues correctly
    en_s <= '1';
    wait for 100 ns;
    
    -- End simulation
    wait;
end process;



end Behavioral;
