library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX is
	--generic(N:positive:=32);
	port ( A,B : in std_logic_vector(31 downto 0);
        COM : in std_logic; -- Chip Select
        S : out std_logic_vector(31 downto 0) 
		);
end entity;

architecture Behaviour of MUX is 

begin 
	process (A,B,COM) 
	begin 
        case COM is
            when '0' =>
            S<=A;
            when '1' =>
            S<=B;
            when others=>
            S<=(others=>'0');
        end case;
	end process; 
end architecture;
	