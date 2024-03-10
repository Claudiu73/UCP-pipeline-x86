----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.11.2023 06:27:55
-- Design Name: 
-- Module Name: IFetch - Behavioral
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

entity IFetch is
Port 
(
    clk: in std_logic;
    rst: in std_logic;
    en: in std_logic;
    PCinc: out std_logic_vector(31 downto 0);
    instruction: out std_logic_vector(31 downto 0)
 );
end IFetch;

architecture Behavioral of IFetch is

--Instruction Memory

type tROM is array (0 to 1023) of std_logic_vector(31 downto 0);
signal ROM : tROM := (
 
X"89A3_0500",    -- mov ecx, 5        
X"89A5_0012",    -- mov esi, v        
X"89A1_A500",    -- mov eax, [esi]    
--find_max:
X"83A3_0002",    -- cmp ecx, 0
X"FE00_0001",    -- je end_loop  
X"3CA3_0100",    -- sub ecx, 1             
X"3BA5_0400",    -- add esi, 4        
X"83A1_A500",    -- cmp eax, [esi]    
X"FE00_0002",    -- jge find_max      
X"89A1_A500",    -- mov eax, [esi]    
X"FE00_0002",    -- jmp find_max      
--end_loop:
X"8901_0001",    -- mov eax, 1        
others => X"00000000"

);

signal ProgCounter: std_logic_vector(31 downto 0):= (others => '0');
signal PCAux, NextAdress: std_logic_vector(31 downto 0);

begin

-- Program Counter

process(clk)
begin
    if rising_edge(clk) then
        if rst = '1' then
            ProgCounter <= (others => '0');
        elsif en = '1' then
            ProgCounter <= NextAdress;
        end if;
    end if;
end process;

instruction <= ROM(conv_integer(ProgCounter(31 downto 0))); 

-- Program Counter incremented

PCAux <= ProgCounter + 4;
PCinc <= PCAux;

end Behavioral;