library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity serializer is
    port(clk, valid_in, reset : in std_logic;  --valid_in and reset are activated when 0
         data_in : in std_logic_vector(7 downto 0);
         valid_out, data_out, ready : out std_logic);
     end serializer;

architecture logic of serializer is
    signal shift_reg : std_logic_vector(7 downto 0);
    signal enable, idle, shift : std_logic;
    signal counter : std_logic_vector(2 downto 0);

    type state_fsm is (idleS,shiftS);
    signal state : state_fsm;


    begin

        enable <= idle and not(valid_in); --if the data are valid and the system is idle, then receive the new data

        --fsm states
        process(clk)
        begin
            if rising_edge(clk) then
                if reset='0' then
                    state <= idleS;
                else
                    case state is
                        when idleS =>
                            if valid_in='0' then --if the data are valid then start shifting
                                state <= shiftS;
                            else
                                state <= idleS;
                            end if;
                        when others =>
                            if counter = "111" then  --if the data have been shifted 7 times, move back to receive new data
                                state <= idleS;
                            else
                                state <= shiftS;
                            end if;
                    end case;
                end if;
            end if;
        end process;


        --counter

        process(clk)
        begin
            if rising_edge(clk) then
                if reset='0' or shift='0' then
                    counter <= (others => '0');
                else
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
                elsif enable = '1' then
                    shift_reg <= data_in;
                elsif shift='1' then
                    shift_reg(6 downto 0) <= shift_reg(7 downto 1); --the right shift
                    shift_reg(7) <= '0';
                end if;
            end if;
        end process;

        --control signals
        process(state)
        begin
            if state=idleS then
                valid_out <= '0';  --not valid output
                ready <= '1';      --ready to receive new data
                idle <= '1';      --the system is idle
                shift <= '0';     --no reason to shift since we don't have valid input
            else
                valid_out<='1';  --the opposite signals
                ready <= '0';
                idle <= '0';
                shift <= '1';
            end if;
        end process;

        data_out <= shift_reg(0);  --the output is the LSB of the shift register
    end logic;
