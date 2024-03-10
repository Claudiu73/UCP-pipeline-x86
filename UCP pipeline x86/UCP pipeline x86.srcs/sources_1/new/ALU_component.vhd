----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2023 00:56:43
-- Design Name: 
-- Module Name: ALU_component - Behavioral
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
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.numeric_std.ALL;

entity ALU_component is
    Port ( 
           RD1 : in STD_LOGIC_VECTOR(7 downto 0);
           RD2 : in STD_LOGIC_VECTOR(7 downto 0);
           ALUOp : in STD_LOGIC_VECTOR(7 downto 0);
           ALURes : out STD_LOGIC_VECTOR(7 downto 0)
           );
end ALU_Component;

architecture Behavioral of ALU_component is

signal ALUIn : STD_LOGIC_VECTOR(7 downto 0);
signal ALUCtrl : STD_LOGIC_VECTOR(7 downto 0);
signal ALUResAux : STD_LOGIC_VECTOR(7 downto 0);

begin
			  
    -- ALU Control
    process(ALUOp)
    begin
        case ALUOp is
           when X"89" => ALUCtrl <= X"89"; -- mov
           when X"83" => ALUCtrl <= X"83"; -- cmp
           when X"FE" => ALUCtrl <= X"FE"; -- je
           when X"3B" => ALUCtrl <= X"3B"; -- add
           when X"3C" => ALUCtrl <= X"3C"; -- sub
           when others => ALUCtrl <= (others => '0'); -- unknown operation
        end case;
    end process;

    -- ALU

    process(ALUCtrl, RD1, RD2, ALUIn)
    begin
        case ALUCtrl  is
            when X"3B" => -- add
                ALUResAux <= std_logic_vector(unsigned(RD1) + unsigned(RD2));
            when X"89" => -- mov 
                ALUResAux <= RD1; -- presupunem c� doar vrem s� transfer�m RD1 �n ALUResAux
            when X"3C" => -- sub
                ALUResAux <= std_logic_vector(unsigned(RD1) - unsigned(RD2));
            when X"83" => -- cmp
            -- Compar�m RD1 si ALUIn si set�m ALUResAux �n functie de rezultat
                if unsigned(RD1) < unsigned(RD2) then
                    ALUResAux <= (others => '1'); -- O reprezentare simpl� care indic� RD1 < ALUIn
                else
                    ALUResAux <= (others => '0'); -- O reprezentare simpl� care indic� RD1 >= ALUIn
                end if;
            when others =>
        end case;
    end process;

    ALURes <= ALUResAux;

end Behavioral;