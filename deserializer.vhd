library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity deserializer is
    port(clk, valid_in, reset, data_in : in std_logic;  --valid_in is activated on 1 for the deserializer
         data_out : out std_logic_vector(7 downto 0);
         valid_out : out std_logic);
     end deserializer;

     architecture logic of deserializer is
         signal shift_reg : std_logic_vector(7 downto 0);

         signal counter : std_logic_vector(2 downto 0);




        begin




            --counter

            process(clk)
            begin
                if rising_edge(clk) then
                    if reset='0' then
                        counter <= (others => '0');
                    elsif valid_in='1' then
                        counter  <= counter + 1;
                    end if;
                end if;
            end process;

            --shift reg

            process(clk)
            begin
                if rising_edge(clk) then
                    if reset='0' then
                        shift_reg <= (others=>'0');
                    elsif valid_in='1' then                           --while the data_in are valid, shift them
                        shift_reg(6 downto 0) <= shift_reg(7 downto 1);
                        shift_reg(7) <= data_in;
                    end if;
                end if;
            end process;

            valid_out <= '1' when counter = "000" else '0';  --if the shift process is complete, mark the out data as valid

            data_out <= shift_reg;
        end logic;
