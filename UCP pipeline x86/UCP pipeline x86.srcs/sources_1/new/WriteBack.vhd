----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.01.2024 00:37:47
-- Design Name: 
-- Module Name: WriteBack - Behavioral
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

entity WriteBack is
    Port ( 
           ALURes : in STD_LOGIC_VECTOR(7 downto 0);
           DataOut : in STD_LOGIC_VECTOR(7 downto 0);
           WriteSelect : in STD_LOGIC; 
           RegWriteData : out STD_LOGIC_VECTOR(7 downto 0)
           );
end WriteBack;

architecture Behavioral of WriteBack is

begin
    -- Write Back logic
    process(ALURes, DataOut, WriteSelect)
    begin
        if WriteSelect = '1' then
            RegWriteData <= DataOut; -- Datele din Data Memory sunt scrise în registre
        else
            RegWriteData <= ALURes; -- Rezultatul ALU este scris în registre
        end if;
    end process;


end Behavioral;
