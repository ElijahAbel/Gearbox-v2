----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/28/2019 12:39:03 PM
-- Design Name: 
-- Module Name: GearboxTop - Behavioral
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
use IEEE.numeric_std.ALL;
use work.state_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GearboxTop is
	port ( 
		CLK			: in STD_LOGIC;
		RST			: in STD_LOGIC;
		PacketOut	: out STD_LOGIC_VECTOR(47 DOWNTO 0)
	);
end GearboxTop;

architecture Behavioral of GearboxTop is
component FIFOManager is
    port(
        CLK         : in STD_LOGIC;
        RST         : in STD_LOGIC;
        ReadEn      : in STD_LOGIC;
        WriteEn     : in STD_LOGIC;
        PacketIn    : in STD_LOGIC_VECTOR(47 DOWNTO 0);
        StateOut    : out GBStateType;
        VC_Out      : out STD_LOGIC_VECTOR(15 DOWNTO 0);
        PacketOut   : out STD_LOGIC_VECTOR(47 DOWNTO 0)
    );
end component;

component InputData is
    port ( 
		CLK			: in STD_LOGIC;
		RST			: in STD_LOGIC;
		VC			: in STD_LOGIC_VECTOR(15 DOWNTO 0);
		State       : in GBStateType;
		PacketIn	: out STD_LOGIC_VECTOR(47 DOWNTO 0);
		Vld         : out std_logic
	);
end component;

signal Vld : STD_LOGIC; --Set to true if VC matches with the VC arrival of our input data
signal VC : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal ReadEn, WriteEn : STD_LOGIC := '0';
signal packet_to_sched : STD_LOGIC_VECTOR(47 DOWNTO 0);
signal flowID, VC_arrival, VC_depart : STD_LOGIC_VECTOR(15 downto 0);
signal State : GBStateType;
begin

scheduler : FIFOManager PORT MAP ( CLK => CLK, RST => RST, ReadEn => ReadEn, WriteEn => WriteEn, PacketIn => packet_to_sched, StateOut => State, VC_Out => VC, PacketOut => PacketOut);
inputSrc  : InputData PORT MAP ( CLK => CLK, RST => RST, VC => VC, State => State, PacketIn => packet_to_sched, Vld => Vld);

flowID <= packet_to_sched(47 DOWNTO 32);
VC_arrival <= packet_to_sched(31 DOWNTO 16);
VC_depart <= packet_to_sched(15 DOWNTO 0);

ReadEn <= '0' when Vld='1' or RST='1' else '1'; --Because we need our packets inserted at a specific round, we won't read at the start of a round while there are packets to write
WriteEn <= '1' when Vld='1' else '0';

--SetReadWrite : process(CLK, RST, Vld)
--begin
--if rising_edge(CLK) then
--    if RST='1' then
--        ReadEn <= '0';
--        WriteEn <= '0';
--    else
--        if Vld='1' then
--            ReadEn <='0';
--            WriteEn <='1';
--        else
--            ReadEn <='1';
--            WriteEn <='0';
--        end if;
--    end if;

--end if;

end process;

end Behavioral;
