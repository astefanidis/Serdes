library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity top is
    port(clk, valid_in, reset : in std_logic;
         data_in : in std_logic_vector(7 downto 0);
         data_out : out std_logic_vector(7 downto 0);
         valid_out, ready : out std_logic);
     end top;

architecture logic of top is

    component serializer
    port(clk, valid_in, reset : in std_logic;  --valid_in and reset are activated when 0
         data_in : in std_logic_vector(7 downto 0);
         valid_out, data_out, ready : out std_logic);
     end component;

     component deserializer
     port(clk, valid_in, reset, data_in : in std_logic;  --valid_in and reset are activated when 0
          data_out : out std_logic_vector(7 downto 0);
          valid_out : out std_logic);
      end component;

      signal valid_outSer: std_logic;
      signal data_outSer: std_logic;

      begin
          ser: serializer port map(clk, valid_in, reset, data_in, valid_outSer, data_outSer, ready);
          deser: deserializer port map(clk, valid_outSer, reset, data_outSer, data_out, valid_out);
      end logic;
