library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_RSA is

end tb_RSA;

architecture test of tb_RSA is 

    component RSA is
        port(
            clk                 : in std_logic;
            reset               : in std_logic;
            start               : in std_logic;
            busy                : out std_logic;
            done                : out std_logic;
            instruction         : in std_logic_vector(1 downto 0);
            message             : in std_logic_vector(7 downto 0);
            key                 : in std_logic_vector(7 downto 0);
            in_modulus          : in std_logic_vector(7 downto 0);
            result              : out std_logic_vector(7 downto 0)
        );
    end component;