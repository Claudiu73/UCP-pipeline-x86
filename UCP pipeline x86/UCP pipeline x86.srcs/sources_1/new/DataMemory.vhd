----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2023 03:42:11
-- Design Name: 
-- Module Name: DataMemory - Behavioral
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


entity DataMemory is
    Port (
        clk      : in  STD_LOGIC;
        address  : in  STD_LOGIC_VECTOR(7 downto 0); -- Adresa
        data_in  : in  STD_LOGIC_VECTOR(7 downto 0); -- Date de intrare pentru scriere
        write_en : in  STD_LOGIC; -- Semnal pentru activarea scrierii
        data_out : out STD_LOGIC_VECTOR(7 downto 0)  -- Date de iesire 
    );
end DataMemory;

architecture Behavioral of DataMemory is

    -- functioneaza ca o memorie de tip RAM cu scriere si citire de date.
    -- daca semnalul de scriere e activ atunci se va scrie in memoria de date.
    -- memoria e initializata la inceput cu 0, ca sa fie goala unitatea si sa se poata adauga date in ea

    type memory_array is array (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
    signal memory : memory_array := (others => (others => '0'));
    
begin
    -- Procesul de citire/scriere în memoria de date
    process(clk)
    begin
        if rising_edge(clk) then
            if write_en = '1' then
                -- Scrierea în memorie la adresa specificatã
                memory(to_integer(unsigned(address))) <= data_in;
            end if;
            -- Citirea din memorie
            data_out <= memory(to_integer(unsigned(address)));
        end if;
    end process;

end Behavioral;

