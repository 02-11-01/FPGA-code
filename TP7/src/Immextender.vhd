library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ImmediateExtender is
    port (
        immediat_in  : in  std_logic_vector(7 downto 0);  -- 8-bit input
        immediat_out : out std_logic_vector(31 downto 0)  -- 32-bit output
    );
end entity;

architecture Behavioral of ImmediateExtender is
begin
    process(immediat_in)
        variable temp_immediat_in : std_logic_vector(31 downto 0);
    begin
            
            --temp_offset := (others => offset(23));  -- 初始化高位部分为符号位
            for i in 0 to 7 loop
                temp_immediat_in(i) := immediat_in(i);  -- 复制 offset 的各位
            end loop;
            for j in 7 to 31 loop
                temp_immediat_in(j) := immediat_in(7);
            end loop;
                immediat_out <= temp_immediat_in;
    end process;
end architecture;
