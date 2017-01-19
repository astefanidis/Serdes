library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end tb;

architecture logic of tb is
component top
port(clk, valid_in, reset : in std_logic;
     data_in : in std_logic_vector(7 downto 0);
     data_out : out std_logic_vector(7 downto 0);
     valid_out, ready : out std_logic);
end component;

signal clk, valid_in ,reset , valid_out, ready: std_logic;
signal data_in, data_out: std_logic_vector(7 downto 0);

begin
	comp: top port map(clk, valid_in, reset, data_in, data_out, valid_out, ready);

	clock:process
	begin
		clk<='0';
		wait for 1 ns;
		clk<='1';
		wait for 1 ns;
	end process;

	values:process
	begin
		reset <= '0';
        valid_in <= '1';
        data_in <= "00011101";

		wait for 3 ns;
		reset <= '1';
        valid_in <= '0';
		wait for 15 ns;
		data_in <= "00001111";
		wait for 15 ns;
		data_in <= "11001100";
        wait for 30 ns;
	end process;
end logic;
