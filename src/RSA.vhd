library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RSA is
    port(
        clk                 : in std_logic;
        reset               : in std_logic;
        start               : in std_logic;
        busy                : out std_logic;
        done                : out std_logic;
        instruction         : in std_logic_vector(1 downto 0);
        message             : in std_logic_vector(7 downto 0);
        key                 : in std_logic_vector(7 downto 0);
        modulus             : in std_logic_vector(7 downto 0);
        result              : out std_logic_vector(7 downto 0)
    );
end RSA;

architecture internal of RSA is

    -- COMPONENTS USED
    component Modular_Exponentiator is
        port(
            base            : in std_logic_vector(7 downto 0);
            exponent        : in std_logic_vector(7 downto 0);
            modulus         : in std_logic_vector(7 downto 0);
            clk             : in std_logic;
            reset           : in std_logic;
            start           : in std_logic;
            busy            : out std_logic;
            result          : out std_logic_vector(7 downto 0);
            done            : out std_logic
        );
    end component;

    component MRT is
        port(
            numberToCheck               : in std_logic_vector (7 downto 0);
            clk                         : in std_logic;
            reset                       : in std_logic;
            start                       : in std_logic;
            isPrime                     : out std_logic;
            busy                        : out std_logic;
            done                        : out std_logic
        );
    end component;

    component PRNG is 
        port(
            clk		: in std_logic;
            rst		: in std_logic;
            enable	: in std_logic;
            output	: out std_logic_vector(7 downto 0)
        );
    end component;

    -- SIGNALS USED

begin

end architecture;