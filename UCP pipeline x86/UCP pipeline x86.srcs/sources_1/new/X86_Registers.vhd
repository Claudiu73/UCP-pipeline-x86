----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2023 03:30:06
-- Design Name: 
-- Module Name: X86_Registers - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity X86_Registers is
    Port (
        clk : in STD_LOGIC;
        we : in STD_LOGIC; -- semnal pentru scrierea de date
        reset : in STD_LOGIC; 
        target_reg : in STD_LOGIC_VECTOR(7 downto 0); -- operand 1
        source_reg : in STD_LOGIC_VECTOR(7 downto 0); -- operand 2
        data_in : in STD_LOGIC_VECTOR(7 downto 0); -- ceea ce primeste din target
        data_out : out STD_LOGIC_VECTOR(7 downto 0); -- ceea ce transmite
        RegWriteData: in STD_LOGIC_VECTOR(7 downto 0);  -- valorile care vin prin writeback
        RegWriteBack: in STD_LOGIC  -- permite rescrierea
    );
end X86_Registers;

architecture Behavioral of X86_Registers is
    type reg_array is array (0 to 7) of STD_LOGIC_VECTOR(7 downto 0); 
    signal registers : reg_array := (others => (others => '0')); 

    -- Codificarea pentru fiecare registru
    constant EAX_code : STD_LOGIC_VECTOR(7 downto 0) := x"A1";
    constant EBX_code : STD_LOGIC_VECTOR(7 downto 0) := x"A2";
    constant ECX_code : STD_LOGIC_VECTOR(7 downto 0) := x"A3";
    constant EDX_code : STD_LOGIC_VECTOR(7 downto 0) := x"A4";
    constant ESI_code : STD_LOGIC_VECTOR(7 downto 0) := x"A5";
    constant EDI_code : STD_LOGIC_VECTOR(7 downto 0) := x"A6";
    constant ESP_code : STD_LOGIC_VECTOR(7 downto 0) := x"A7";
    constant EBP_code : STD_LOGIC_VECTOR(7 downto 0) := x"A8";

begin
    process(clk, reset)
    begin
        if reset = '1' then
            
            registers <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if we = '1' then
                
                case target_reg is
                    when EAX_code => registers(0) <= data_in;
                    when EBX_code => registers(1) <= data_in;
                    when ECX_code => registers(2) <= data_in;
                    when EDX_code => registers(3) <= data_in;
                    when ESI_code => registers(4) <= data_in;
                    when EDI_code => registers(5) <= data_in;
                    when ESP_code => registers(6) <= data_in;
                    when EBP_code => registers(7) <= data_in;
                    when others => NULL;
                end case;
            end if;
            
            case source_reg is
                when EAX_code => data_out <= registers(0);
                when EBX_code => data_out <= registers(1);
                when ECX_code => data_out <= registers(2);
                when EDX_code => data_out <= registers(3);
                when ESI_code => data_out <= registers(4);
                when EDI_code => data_out <= registers(5);
                when ESP_code => data_out <= registers(6);
                when EBP_code => data_out <= registers(7);
                when others => data_out <= (others => '0'); 
            end case;
        end if;
    end process;
    
    process(RegWriteBack)
    begin
        if RegWriteBack = '1' then
            data_out <= RegWriteData;
        end if;
    end process;
    
end Behavioral;

