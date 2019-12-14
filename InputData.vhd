----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/28/2019 12:39:03 PM
-- Design Name: 
-- Module Name: InputData - Behavioral
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
---------------------------------------------------------------------------------


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

entity InputData is
	port ( 
		CLK			: in STD_LOGIC;
		RST			: in STD_LOGIC;
		index       : in integer;
		PacketIn	: out STD_LOGIC_VECTOR(47 DOWNTO 0);
		NextPacketArrival : out STD_LOGIC_VECTOR(15 DOWNTO 0)
		--Vld         : out std_logic
	);
end InputData;

architecture Behavioral of InputData is
type internalMem is array(0 to 153) of STD_LOGIC_VECTOR(47 DOWNTO 0);
signal Mem : internalMem; 
signal Output : STD_LOGIC_VECTOR(47 DOWNTO 0);
--signal index : integer := 0;
signal currentPacket : STD_LOGIC_VECTOR(47 DOWNTO 0);
signal PacketArrival : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal PacketFinish : STD_LOGIC_VECTOR(15 DOWNTO 0);

begin
Mem <= ("0000000000000100" & "0000000000000000" & "0000000000000010",
"0000000000000010" & "0000000000000000" & "0000000000000101",
"0000000000000011" & "0000000000000000" & "0000000000000101",
"0000000000000001" & "0000000000000000" & "0000000000001010",
"0000000000000010" & "0000000000000001" & "0000000000001010",
"0000000000000010" & "0000000000000001" & "0000000000001111",
"0000000000000010" & "0000000000000001" & "0000000000010100",
"0000000000000010" & "0000000000000001" & "0000000000011001",
"0000000000000100" & "0000000000000010" & "0000000000000100",
"0000000000000100" & "0000000000000011" & "0000000000000110",
"0000000000000010" & "0000000000000011" & "0000000000011110",
"0000000000000100" & "0000000000000101" & "0000000000001000",
"0000000000000010" & "0000000000000101" & "0000000000100011",
"0000000000000100" & "0000000000000110" & "0000000000001010",
"0000000000000011" & "0000000000000110" & "0000000000001011",
"0000000000000010" & "0000000000000110" & "0000000000101000",
"0000000000000100" & "0000000000000111" & "0000000000001100",
"0000000000000011" & "0000000000000111" & "0000000000010000",
"0000000000000011" & "0000000000000111" & "0000000000010101",
"0000000000000100" & "0000000000001000" & "0000000000001110",
"0000000000000010" & "0000000000001000" & "0000000000101101",
"0000000000000010" & "0000000000001000" & "0000000000110010",
"0000000000000100" & "0000000000001001" & "0000000000010000",
"0000000000000011" & "0000000000001001" & "0000000000011010",
"0000000000000010" & "0000000000001010" & "0000000000110111",
"0000000000000001" & "0000000000001011" & "0000000000010101",
"0000000000000010" & "0000000000001011" & "0000000000111100",
"0000000000000100" & "0000000000001100" & "0000000000010010",
"0000000000000010" & "0000000000001101" & "0000000001000001",
"0000000000000100" & "0000000000001110" & "0000000000010100",
"0000000000000010" & "0000000000001110" & "0000000001000110",
"0000000000000100" & "0000000000001111" & "0000000000010110",
"0000000000000011" & "0000000000001111" & "0000000000011111",
"0000000000000010" & "0000000000010000" & "0000000001001011",
"0000000000000010" & "0000000000010000" & "0000000001010000",
"0000000000000010" & "0000000000010001" & "0000000001010101",
"0000000000000010" & "0000000000010001" & "0000000001011010",
"0000000000000100" & "0000000000010010" & "0000000000011000",
"0000000000000010" & "0000000000010010" & "0000000001011111",
"0000000000000001" & "0000000000010011" & "0000000000011111",
"0000000000000001" & "0000000000010100" & "0000000000101001",
"0000000000000001" & "0000000000010100" & "0000000000110011",
"0000000000000010" & "0000000000010100" & "0000000001100100",
"0000000000000100" & "0000000000010101" & "0000000000011010",
"0000000000000011" & "0000000000010101" & "0000000000100100",
"0000000000000001" & "0000000000010111" & "0000000000111101",
"0000000000000100" & "0000000000011000" & "0000000000011100",
"0000000000000100" & "0000000000011001" & "0000000000011110",
"0000000000000011" & "0000000000011011" & "0000000000101001",
"0000000000000011" & "0000000000011011" & "0000000000101110",
"0000000000000001" & "0000000000011100" & "0000000001000111",
"0000000000000100" & "0000000000011101" & "0000000000100000",
"0000000000000011" & "0000000000011111" & "0000000000110011",
"0000000000000011" & "0000000000011111" & "0000000000111000",
"0000000000000100" & "0000000000100001" & "0000000000100011",
"0000000000000001" & "0000000000100001" & "0000000001010001",
"0000000000000011" & "0000000000100010" & "0000000000111101",
"0000000000000100" & "0000000000100101" & "0000000000100111",
"0000000000000100" & "0000000000100101" & "0000000000101001",
"0000000000000100" & "0000000000100110" & "0000000000101011",
"0000000000000011" & "0000000000101000" & "0000000001000010",
"0000000000000001" & "0000000000101000" & "0000000001011011",
"0000000000000100" & "0000000000101001" & "0000000000101101",
"0000000000000100" & "0000000000101001" & "0000000000101111",
"0000000000000011" & "0000000000101001" & "0000000001000111",
"0000000000000100" & "0000000000101010" & "0000000000110001",
"0000000000000001" & "0000000000101010" & "0000000001100101",
"0000000000000011" & "0000000000101011" & "0000000001001100",
"0000000000000100" & "0000000000101101" & "0000000000110011",
"0000000000000100" & "0000000000101110" & "0000000000110101",
"0000000000000100" & "0000000000101111" & "0000000000110111",
"0000000000000001" & "0000000000110000" & "0000000001101111",
"0000000000000100" & "0000000000110001" & "0000000000111001",
"0000000000000100" & "0000000000110001" & "0000000000111011",
"0000000000000011" & "0000000000110001" & "0000000001010001",
"0000000000000001" & "0000000000110010" & "0000000001111001",
"0000000000000100" & "0000000000110011" & "0000000000111101",
"0000000000000001" & "0000000000110011" & "0000000010000011",
"0000000000000100" & "0000000000110110" & "0000000000111111",
"0000000000000100" & "0000000000110110" & "0000000001000001",
"0000000000000011" & "0000000000110110" & "0000000001010110",
"0000000000000001" & "0000000000110110" & "0000000010001101",
"0000000000000100" & "0000000000111000" & "0000000001000011",
"0000000000000100" & "0000000000111011" & "0000000001000101",
"0000000000000011" & "0000000000111011" & "0000000001011011",
"0000000000000100" & "0000000000111101" & "0000000001000111",
"0000000000000100" & "0000000001000000" & "0000000001001001",
"0000000000000100" & "0000000001000001" & "0000000001001011",
"0000000000000011" & "0000000001000001" & "0000000001100000",
"0000000000000001" & "0000000001000001" & "0000000010010111",
"0000000000000100" & "0000000001000100" & "0000000001001101",
"0000000000000100" & "0000000001000100" & "0000000001001111",
"0000000000000011" & "0000000001000100" & "0000000001100101",
"0000000000000011" & "0000000001000110" & "0000000001101010",
"0000000000000100" & "0000000001000111" & "0000000001010001",
"0000000000000011" & "0000000001001001" & "0000000001101111",
"0000000000000100" & "0000000001001011" & "0000000001010011",
"0000000000000100" & "0000000001001100" & "0000000001010101",
"0000000000000001" & "0000000001001100" & "0000000010100001",
"0000000000000011" & "0000000001001110" & "0000000001110100",
"0000000000000100" & "0000000001001111" & "0000000001010111",
"0000000000000001" & "0000000001010000" & "0000000010101011",
"0000000000000100" & "0000000001010010" & "0000000001011001",
"0000000000000100" & "0000000001010110" & "0000000001011011",
"0000000000000100" & "0000000001011001" & "0000000001011101",
"0000000000000001" & "0000000001011011" & "0000000010110101",
"0000000000000001" & "0000000001011011" & "0000000010111111",
"0000000000000100" & "0000000001011100" & "0000000001011111",
"0000000000000001" & "0000000001011100" & "0000000011001001",
"0000000000000100" & "0000000001011101" & "0000000001100001",
"0000000000000100" & "0000000001100001" & "0000000001100011",
"0000000000000001" & "0000000001100001" & "0000000011010011",
"0000000000000100" & "0000000001100101" & "0000000001100111",
"0000000000000001" & "0000000001100101" & "0000000011011101",
"0000000000000100" & "0000000001101001" & "0000000001101011",
"0000000000000100" & "0000000001101100" & "0000000001101110",
"0000000000000100" & "0000000001101101" & "0000000001110000",
"0000000000000100" & "0000000001101110" & "0000000001110010",
"0000000000000001" & "0000000001110000" & "0000000011100111",
"0000000000000100" & "0000000001110001" & "0000000001110100",
"0000000000000100" & "0000000001110100" & "0000000001110110",
"0000000000000100" & "0000000001110101" & "0000000001111000",
"0000000000000100" & "0000000001111000" & "0000000001111010",
"0000000000000001" & "0000000001111001" & "0000000011110001",
"0000000000000100" & "0000000001111010" & "0000000001111100",
"0000000000000100" & "0000000001111010" & "0000000001111110",
"0000000000000100" & "0000000001111100" & "0000000010000000",
"0000000000000001" & "0000000001111110" & "0000000011111011",
"0000000000000001" & "0000000010000011" & "0000000100000101",
"0000000000000001" & "0000000010001010" & "0000000100001111",
"0000000000000001" & "0000000010001111" & "0000000100011001",
"0000000000000001" & "0000000010010000" & "0000000100100011",
"0000000000000001" & "0000000010010110" & "0000000100101101",
"0000000000000001" & "0000000010100000" & "0000000100110111",
"0000000000000001" & "0000000010100111" & "0000000101000001",
"0000000000000001" & "0000000010101001" & "0000000101001011",
"0000000000000001" & "0000000010101010" & "0000000101010101",
"0000000000000001" & "0000000010110011" & "0000000101011111",
"0000000000000001" & "0000000010111110" & "0000000101101001",
"0000000000000001" & "0000000011000001" & "0000000101110011",
"0000000000000001" & "0000000011001001" & "0000000101111101",
"0000000000000001" & "0000000011001001" & "0000000110000111",
"0000000000000001" & "0000000011001011" & "0000000110010001",
"0000000000000001" & "0000000011010100" & "0000000110011011",
"0000000000000001" & "0000000011010101" & "0000000110100101",
"0000000000000001" & "0000000011011001" & "0000000110101111",
"0000000000000001" & "0000000011100000" & "0000000110111001",
"0000000000000001" & "0000000011100110" & "0000000111000011",
"0000000000000001" & "0000000011101011" & "0000000111001101",
"0000000000000001" & "0000000011101111" & "0000000111010111",
"0000000000000001" & "0000000011110001" & "0000000111100001",
"0000000000000001" & "0000000011111000" & "0000000111101011",
"0000000000000001" & "0000000011111010" & "0000000111110101",
"0000000000000000" & "0000000000000000" & "0000000000000000");

PacketIn(47 DOWNTO 0) <= Mem(index)(47 DOWNTO 0); --Output of this module, PacketIn for Gearbox
NextPacketArrival(15 DOWNTO 0) <= Mem(index+1)(31 DOWNTO 16) when index<153;
---NextPacketArrival <= Mem(index)(31 DOWNTO 16);
---NextPacketFinish <= Mem(index)(15 DOWNTO 0);

--Vld <= '1' when VC(15 DOWNTO 0)=Mem(index)(31 DOWNTO 16) else
--        '0';

--Next_packet : process(CLK,RST,VC)
--begin
--if(RST='1') then
--    index <= 0;
--    --Vld <= '0';
--elsif rising_edge(CLK) then
--    if (VC(15 downto 0)=Mem(index)(31 DOWNTO 16)) then
--        --PacketIn(47 DOWNTO 0) <= Mem(index)(47 DOWNTO 0); --Output of this module, PacketIn for Gearbox
--        --NextPacketArrival <= Mem(index)(31 DOWNTO 16);
--        --NextPacketFinish <= Mem(index)(15 DOWNTO 0);
--        if(State/=INIT) then
--            index <= index + 1;
--        end if;
--       -- Vld <= '1';
----    else
--  --      Vld <= '0';
--    end if;
--end if;

--end process;

end Behavioral;
