----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2023 12:59:49
-- Design Name: 
-- Module Name: Decode - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Definirea entitã?ii pentru etapa de decodare.

entity Decode is
    Port (
        clk: in STD_LOGIC;
        reset: in STD_LOGIC;
        instruction : in  STD_LOGIC_VECTOR(31 downto 0); 
        RD1: out STD_LOGIC_VECTOR(7 downto 0);
        RD2: out STD_LOGIC_VECTOR(7 downto 0);
        we: in STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(7 downto 0);
        data_out: out STD_LOGIC_VECTOR(7 downto 0)
    );
end Decode;


architecture Behavioral of Decode is

signal target_reg: STD_LOGIC_VECTOR(7 downto 0);
signal source_reg: STD_LOGIC_VECTOR(7 downto 0);

signal RegWriteData: STD_LOGIC_VECTOR(7 downto 0);
signal RegWriteBack: STD_LOGIC;

signal we_local : STD_LOGIC := '0';
signal opcode :  STD_LOGIC_VECTOR(7 downto 0);   
signal RD1_aux: STD_LOGIC_VECTOR(7 downto 0);
signal address: STD_LOGIC_VECTOR(7 downto 0);

signal reg_data_out: STD_LOGIC_VECTOR(7 downto 0);
signal mem_address: STD_LOGIC_VECTOR(7 downto 0);
signal mem_data_in: STD_LOGIC_VECTOR(7 downto 0);
signal mem_write_en: STD_LOGIC;
signal mem_data_out: STD_LOGIC_VECTOR(7 downto 0);

signal memSauAlu: STD_LOGIC;
signal RD2_aux: STD_LOGIC_VECTOR(7 downto 0);

component X86_Registers is
    Port (
        clk : in STD_LOGIC;
        we : in STD_LOGIC;
        reset : in STD_LOGIC; 
        target_reg : in STD_LOGIC_VECTOR(7 downto 0); 
        source_reg : in STD_LOGIC_VECTOR(7 downto 0); 
        data_in : in STD_LOGIC_VECTOR(7 downto 0); 
        data_out : out STD_LOGIC_VECTOR(7 downto 0);
        RegWriteData: in STD_LOGIC_VECTOR(7 downto 0);
        RegWriteBack: in STD_LOGIC 
        );
    end component;
    
component DataMemory is
    Port (
         clk      : in  STD_LOGIC;
         address  : in  STD_LOGIC_VECTOR(7 downto 0);
         data_in  : in  STD_LOGIC_VECTOR(7 downto 0);
         write_en : in  STD_LOGIC;
         data_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

begin
    
    process(clk, reset)
    begin
        if rising_edge(clk) then
            opcode     <= instruction(31 downto 24);
            source_reg <= instruction(23 downto 16);
            target_reg <= instruction(15 downto 8);
            address    <= instruction(7 downto 0);

            if target_reg = x"A1" or source_reg = x"A1" then 
                we_local <= '1';
            else
                we_local <= '0';
            end if;            
            
            if target_reg = x"A2" or source_reg = x"A2" then 
                we_local <= '1';
            else
                we_local <= '0';
            end if; 
            
            if target_reg = x"A3" or source_reg = x"A3" then 
                we_local <= '1';
            else
                we_local <= '0';
            end if; 
            
            if target_reg = x"A4" or source_reg = x"A4" then 
                we_local <= '1';
            else
                we_local <= '0';
            end if; 
            
            if target_reg = x"A5" or source_reg = x"A5" then 
                we_local <= '1';
            else
                we_local <= '0';
            end if; 
            
            if target_reg = x"A6" or source_reg = x"A6" then 
                we_local <= '1';
            else
                we_local <= '0';
            end if; 
            
            if target_reg = x"A7" or source_reg = x"A7" then 
                we_local <= '1';
            else
                we_local <= '0';
            end if; 
            
            if target_reg = x"A8" or source_reg = x"A8" then 
                we_local <= '1';
            else
                we_local <= '0';
            end if; 
            
        end if;
    end process;
    
    registers: X86_Registers port map(clk, we_local, reset, target_reg, source_reg, data_in, data_out, RegWriteData, RegWriteBack);
    
    process(clk, reset)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                RD1_aux <= (others => '0');
                RD2_aux <= (others => '0');
                we_local <= '0';
                target_reg <= (others => '0');
                source_reg <= (others => '0');
                data_out <= (others => '0');
             else
                target_reg <= instruction(23 downto 16);
                data_out <= instruction(15 downto 8);
                RD1_aux <= data_in;
                RD2_aux <= instruction(15 downto 8);
                we_local <= '1';
             end if;  
        end if; 
    end process;
    
    process(clk)
    begin
        if falling_edge(clk) then
            we_local <= '0';
        end if;
    end process;

--    RD1 <= RD1_aux;
    
    data_memory_instance: DataMemory port map (clk, mem_address, mem_data_in, mem_write_en, mem_data_out);
    
    process(clk)
    begin
        if rising_edge(clk) then
            memSauAlu <= '1';
        else
            memSauAlu <= '0';
        end if;
    end process;
    
    process(RD1_aux, memSauAlu)
    begin
        if memSauAlu = '1' then
            address <= instruction(7 downto 0);
            RD1 <= (others => '0');
        else
            address <= (others => '0');
            RD1 <= RD1_aux;
        end if;
    end process;
    
    process(RD2_aux, memSauAlu)
    begin
        if memSauAlu = '1' then
            mem_data_in <= instruction(15 downto 8);
            RD2 <= (others => '0');
        else
            mem_data_in <= (others => '0');
            RD2 <= RD2_aux;
        end if;
    end process;
    
end Behavioral;

