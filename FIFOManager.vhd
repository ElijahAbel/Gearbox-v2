----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/28/2019 12:39:03 PM
-- Design Name: 
-- Module Name: FIFOManager - Behavioral
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
use work.state_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIFOManager is
	generic(
		constant DATA_WIDTH : positive := 64;
		constant INPUT_WIDTH : positive := 68
	);
	port ( 
		CLK       : in STD_LOGIC;
		RST       : in STD_LOGIC;
		ReadEn      : in STD_LOGIC;
		WriteEn     : in STD_LOGIC;
		PacketIn  : in STD_LOGIC_VECTOR(INPUT_WIDTH - 1 DOWNTO 0);
		PacketOut : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
	);
end FIFOManager;

architecture Behavioral of FIFOManager is

component FIFO is
	port(
		CLK		: in  STD_LOGIC;
		RST		: in  STD_LOGIC;
		WriteEn	: in  STD_LOGIC;
		PacketIn	: in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		ReadEn	: in  STD_LOGIC;
		DataOut	: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		Empty		: out STD_LOGIC
		--Full		: out STD_LOGIC
	);
end component;

FUNCTION Is_Valid ( s : std_logic_vector  ) RETURN std_logic IS
    BEGIN
        FOR i IN s'RANGE LOOP
            CASE s(i) IS
                WHEN 'U' | 'X' | 'Z' | 'W' | '-' => RETURN '0';
                WHEN OTHERS => NULL;
            END CASE;
        END LOOP;
        RETURN '1';
    END function;

signal Lvl0a_WriteEn0, Lvl0a_WriteEn1, Lvl0a_WriteEn2, Lvl0a_WriteEn3, Lvl0a_WriteEn4, Lvl0a_WriteEn5, Lvl0a_WriteEn6, Lvl0a_WriteEn7, Lvl0a_WriteEn8, Lvl0a_WriteEn9 : std_logic := '0';
signal Lvl0a_ReadEn0, Lvl0a_ReadEn1, Lvl0a_ReadEn2, Lvl0a_ReadEn3, Lvl0a_ReadEn4, Lvl0a_ReadEn5, Lvl0a_ReadEn6, Lvl0a_ReadEn7, Lvl0a_ReadEn8, Lvl0a_ReadEn9 : std_logic := '0';
signal Lvl0a_DataOut0, Lvl0a_DataOut1, Lvl0a_DataOut2, Lvl0a_DataOut3, Lvl0a_DataOut4, Lvl0a_DataOut5, Lvl0a_DataOut6, Lvl0a_DataOut7, Lvl0a_DataOut8, Lvl0a_DataOut9 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
signal Lvl0a_Empty0, Lvl0a_Empty1, Lvl0a_Empty2, Lvl0a_Empty3, Lvl0a_Empty4, Lvl0a_Empty5, Lvl0a_Empty6, Lvl0a_Empty7, Lvl0a_Empty8, Lvl0a_Empty9 : STD_LOGIC;
--signal Lvl0a_Full0, Lvl0a_Full1, Lvl0a_Full2, Lvl0a_Full3, Lvl0a_Full4, Lvl0a_Full5, Lvl0a_Full6, Lvl0a_Full7, Lvl0a_Full8, Lvl0a_Full9 : STD_LOGIC;

--signal Lvl0b_WriteEn0, Lvl0b_WriteEn1, Lvl0b_WriteEn2, Lvl0b_WriteEn3, Lvl0b_WriteEn4, Lvl0b_WriteEn5, Lvl0b_WriteEn6, Lvl0b_WriteEn7, Lvl0b_WriteEn8, Lvl0b_WriteEn9 : std_logic := '0';
--signal Lvl0b_ReadEn0, Lvl0b_ReadEn1, Lvl0b_ReadEn2, Lvl0b_ReadEn3, Lvl0b_ReadEn4, Lvl0b_ReadEn5, Lvl0b_ReadEn6, Lvl0b_ReadEn7, Lvl0b_ReadEn8, Lvl0b_ReadEn9 : std_logic := '0';
--signal Lvl0b_DataOut0, Lvl0b_DataOut1, Lvl0b_DataOut2, Lvl0b_DataOut3, Lvl0b_DataOut4, Lvl0b_DataOut5, Lvl0b_DataOut6, Lvl0b_DataOut7, Lvl0b_DataOut8, Lvl0b_DataOut9 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
--signal Lvl0b_Empty0, Lvl0b_Empty1, Lvl0b_Empty2, Lvl0b_Empty3, Lvl0b_Empty4, Lvl0b_Empty5, Lvl0b_Empty6, Lvl0b_Empty7, Lvl0b_Empty8, Lvl0b_Empty9 : STD_LOGIC;
--signal Lvl0b_Full0, Lvl0b_Full1, Lvl0b_Full2, Lvl0b_Full3, Lvl0b_Full4, Lvl0b_Full5, Lvl0b_Full6, Lvl0b_Full7, Lvl0b_Full8, Lvl0b_Full9 : STD_LOGIC;
--
--signal Lvl1a_WriteEn0, Lvl1a_WriteEn1, Lvl1a_WriteEn2, Lvl1a_WriteEn3, Lvl1a_WriteEn4, Lvl1a_WriteEn5, Lvl1a_WriteEn6, Lvl1a_WriteEn7, Lvl1a_WriteEn8, Lvl1a_WriteEn9 : std_logic := '0';
--signal Lvl1a_ReadEn0, Lvl1a_ReadEn1, Lvl1a_ReadEn2, Lvl1a_ReadEn3, Lvl1a_ReadEn4, Lvl1a_ReadEn5, Lvl1a_ReadEn6, Lvl1a_ReadEn7, Lvl1a_ReadEn8, Lvl1a_ReadEn9 : std_logic := '0';
--signal Lvl1a_DataOut0, Lvl1a_DataOut1, Lvl1a_DataOut2, Lvl1a_DataOut3, Lvl1a_DataOut4, Lvl1a_DataOut5, Lvl1a_DataOut6, Lvl1a_DataOut7, Lvl1a_DataOut8, Lvl1a_DataOut9 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
--signal Lvl1a_Empty0, Lvl1a_Empty1, Lvl1a_Empty2, Lvl1a_Empty3, Lvl1a_Empty4, Lvl1a_Empty5, Lvl1a_Empty6, Lvl1a_Empty7, Lvl1a_Empty8, Lvl1a_Empty9 : STD_LOGIC;
--signal Lvl1a_Full0, Lvl1a_Full1, Lvl1a_Full2, Lvl1a_Full3, Lvl1a_Full4, Lvl1a_Full5, Lvl1a_Full6, Lvl1a_Full7, Lvl1a_Full8, Lvl1a_Full9 : STD_LOGIC;
--
--signal Lvl1b_WriteEn0, Lvl1b_WriteEn1, Lvl1b_WriteEn2, Lvl1b_WriteEn3, Lvl1b_WriteEn4, Lvl1b_WriteEn5, Lvl1b_WriteEn6, Lvl1b_WriteEn7, Lvl1b_WriteEn8, Lvl1b_WriteEn9 : std_logic := '0';
--signal Lvl1b_ReadEn0, Lvl1b_ReadEn1, Lvl1b_ReadEn2, Lvl1b_ReadEn3, Lvl1b_ReadEn4, Lvl1b_ReadEn5, Lvl1b_ReadEn6, Lvl1b_ReadEn7, Lvl1b_ReadEn8, Lvl1b_ReadEn9 : std_logic := '0';
--signal Lvl1b_DataOut0, Lvl1b_DataOut1, Lvl1b_DataOut2, Lvl1b_DataOut3, Lvl1b_DataOut4, Lvl1b_DataOut5, Lvl1b_DataOut6, Lvl1b_DataOut7, Lvl1b_DataOut8, Lvl1b_DataOut9 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
--signal Lvl1b_Empty0, Lvl1b_Empty1, Lvl1b_Empty2, Lvl1b_Empty3, Lvl1b_Empty4, Lvl1b_Empty5, Lvl1b_Empty6, Lvl1b_Empty7, Lvl1b_Empty8, Lvl1b_Empty9 : STD_LOGIC;
--signal Lvl1b_Full0, Lvl1b_Full1, Lvl1b_Full2, Lvl1b_Full3, Lvl1b_Full4, Lvl1b_Full5, Lvl1b_Full6, Lvl1b_Full7, Lvl1b_Full8, Lvl1b_Full9 : STD_LOGIC;
--
--signal Lvl2_WriteEn0, Lvl2_WriteEn1, Lvl2_WriteEn2, Lvl2_WriteEn3, Lvl2_WriteEn4, Lvl2_WriteEn5, Lvl2_WriteEn6, Lvl2_WriteEn7, Lvl2_WriteEn8, Lvl2_WriteEn9 : std_logic := '0';
--signal Lvl2_ReadEn0, Lvl2_ReadEn1, Lvl2_ReadEn2, Lvl2_ReadEn3, Lvl2_ReadEn4, Lvl2_ReadEn5, Lvl2_ReadEn6, Lvl2_ReadEn7, Lvl2_ReadEn8, Lvl2_ReadEn9 : std_logic := '0';
--signal Lvl2_DataOut0, Lvl2_DataOut1, Lvl2_DataOut2, Lvl2_DataOut3, Lvl2_DataOut4, Lvl2_DataOut5, Lvl2_DataOut6, Lvl2_DataOut7, Lvl2_DataOut8, Lvl2_DataOut9 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
--signal Lvl2_Empty0, Lvl2_Empty1, Lvl2_Empty2, Lvl2_Empty3, Lvl2_Empty4, Lvl2_Empty5, Lvl2_Empty6, Lvl2_Empty7, Lvl2_Empty8, Lvl2_Empty9 : STD_LOGIC;
--signal Lvl2_Full0, Lvl2_Full1, Lvl2_Full2, Lvl2_Full3, Lvl2_Full4, Lvl2_Full5, Lvl2_Full6, Lvl2_Full7, Lvl2_Full8, Lvl2_Full9 : STD_LOGIC;

signal VC : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => 0);
signal VCC_Round : STD_LOGIC_VECTOR(3 DOWNTO 0); --tells us which queue we should place a packet in
signal Packet_Addr : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
signal Packet_Out_Temp : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0); 
signal State : GBStateType := HEAD_QUEUE_0;
signal Vld, VldVector : std_logic := '0';
signal Lvl0a_EmptyVector : STD_LOGIC_VECTOR(9 DOWNTO 0);
--signal CurrFIFOLvl0a_Empty : std_logic := '0'; 

begin

Lvl_0a_QUEUE_0: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0a_WriteEn0, PacketIn => Packet_Addr, ReadEn => Lvl0a_ReadEn0, DataOut => Lvl0a_DataOut0, Empty => Lvl0a_Empty0);
Lvl_0a_QUEUE_1: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0a_WriteEn1, PacketIn => Packet_Addr, ReadEn => Lvl0a_ReadEn1, DataOut => Lvl0a_DataOut1, Empty => Lvl0a_Empty1);
Lvl_0a_QUEUE_2: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0a_WriteEn2, PacketIn => Packet_Addr, ReadEn => Lvl0a_ReadEn2, DataOut => Lvl0a_DataOut2, Empty => Lvl0a_Empty2);
Lvl_0a_QUEUE_3: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0a_WriteEn3, PacketIn => Packet_Addr, ReadEn => Lvl0a_ReadEn3, DataOut => Lvl0a_DataOut3, Empty => Lvl0a_Empty3);
Lvl_0a_QUEUE_4: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0a_WriteEn4, PacketIn => Packet_Addr, ReadEn => Lvl0a_ReadEn4, DataOut => Lvl0a_DataOut4, Empty => Lvl0a_Empty4);
Lvl_0a_QUEUE_5: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0a_WriteEn5, PacketIn => Packet_Addr, ReadEn => Lvl0a_ReadEn5, DataOut => Lvl0a_DataOut5, Empty => Lvl0a_Empty5);
Lvl_0a_QUEUE_6: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0a_WriteEn6, PacketIn => Packet_Addr, ReadEn => Lvl0a_ReadEn6, DataOut => Lvl0a_DataOut6, Empty => Lvl0a_Empty6);
Lvl_0a_QUEUE_7: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0a_WriteEn7, PacketIn => Packet_Addr, ReadEn => Lvl0a_ReadEn7, DataOut => Lvl0a_DataOut7, Empty => Lvl0a_Empty7);
Lvl_0a_QUEUE_8: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0a_WriteEn8, PacketIn => Packet_Addr, ReadEn => Lvl0a_ReadEn8, DataOut => Lvl0a_DataOut8, Empty => Lvl0a_Empty8);
Lvl_0a_QUEUE_9: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0a_WriteEn9, PacketIn => Packet_Addr, ReadEn => Lvl0a_ReadEn9, DataOut => Lvl0a_DataOut9, Empty => Lvl0a_Empty9);
--
--Lvl_0b_QUEUE_0: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn0, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn0, DataOut => Lvl0b_DataOut0, Empty => Lvl0b_Empty0, Full => Lvl0b_Full0);
--Lvl_0b_QUEUE_1: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn1, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn1, DataOut => Lvl0b_DataOut1, Empty => Lvl0b_Empty1, Full => Lvl0b_Full1);
--Lvl_0b_QUEUE_2: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn2, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn2, DataOut => Lvl0b_DataOut2, Empty => Lvl0b_Empty2, Full => Lvl0b_Full2);
--Lvl_0b_QUEUE_3: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn3, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn3, DataOut => Lvl0b_DataOut3, Empty => Lvl0b_Empty3, Full => Lvl0b_Full3);
--Lvl_0b_QUEUE_4: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn4, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn4, DataOut => Lvl0b_DataOut4, Empty => Lvl0b_Empty4, Full => Lvl0b_Full4);
--Lvl_0b_QUEUE_5: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn5, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn5, DataOut => Lvl0b_DataOut5, Empty => Lvl0b_Empty5, Full => Lvl0b_Full5);
--Lvl_0b_QUEUE_6: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn6, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn6, DataOut => Lvl0b_DataOut6, Empty => Lvl0b_Empty6, Full => Lvl0b_Full6);
--Lvl_0b_QUEUE_7: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn7, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn7, DataOut => Lvl0b_DataOut7, Empty => Lvl0b_Empty7, Full => Lvl0b_Full7);
--Lvl_0b_QUEUE_8: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn8, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn8, DataOut => Lvl0b_DataOut8, Empty => Lvl0b_Empty8, Full => Lvl0b_Full8);
--Lvl_0b_QUEUE_9: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn9, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn9, DataOut => Lvl0b_DataOut9, Empty => Lvl0b_Empty9, Full => Lvl0b_Full9);
--
--Lvl_1a_QUEUE_0: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn0, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn0, DataOut => Lvl1a_DataOut0, Empty => Lvl1a_Empty0, Full => Lvl1a_Full0);
--Lvl_1a_QUEUE_1: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn1, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn1, DataOut => Lvl1a_DataOut1, Empty => Lvl1a_Empty1, Full => Lvl1a_Full1);
--Lvl_1a_QUEUE_2: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn2, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn2, DataOut => Lvl1a_DataOut2, Empty => Lvl1a_Empty2, Full => Lvl1a_Full2);
--Lvl_1a_QUEUE_3: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn3, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn3, DataOut => Lvl1a_DataOut3, Empty => Lvl1a_Empty3, Full => Lvl1a_Full3);
--Lvl_1a_QUEUE_4: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn4, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn4, DataOut => Lvl1a_DataOut4, Empty => Lvl1a_Empty4, Full => Lvl1a_Full4);
--Lvl_1a_QUEUE_5: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn5, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn5, DataOut => Lvl1a_DataOut5, Empty => Lvl1a_Empty5, Full => Lvl1a_Full5);
--Lvl_1a_QUEUE_6: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn6, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn6, DataOut => Lvl1a_DataOut6, Empty => Lvl1a_Empty6, Full => Lvl1a_Full6);
--Lvl_1a_QUEUE_7: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn7, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn7, DataOut => Lvl1a_DataOut7, Empty => Lvl1a_Empty7, Full => Lvl1a_Full7);
--Lvl_1a_QUEUE_8: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn8, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn8, DataOut => Lvl1a_DataOut8, Empty => Lvl1a_Empty8, Full => Lvl1a_Full8);
--Lvl_1a_QUEUE_9: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn9, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn9, DataOut => Lvl1a_DataOut9, Empty => Lvl1a_Empty9, Full => Lvl1a_Full9);
--
--Lvl_1b_QUEUE_0: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn0, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn0, DataOut => Lvl1b_DataOut0, Empty => Lvl1b_Empty0, Full => Lvl1b_Full0);
--Lvl_1b_QUEUE_1: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn1, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn1, DataOut => Lvl1b_DataOut1, Empty => Lvl1b_Empty1, Full => Lvl1b_Full1);
--Lvl_1b_QUEUE_2: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn2, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn2, DataOut => Lvl1b_DataOut2, Empty => Lvl1b_Empty2, Full => Lvl1b_Full2);
--Lvl_1b_QUEUE_3: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn3, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn3, DataOut => Lvl1b_DataOut3, Empty => Lvl1b_Empty3, Full => Lvl1b_Full3);
--Lvl_1b_QUEUE_4: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn4, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn4, DataOut => Lvl1b_DataOut4, Empty => Lvl1b_Empty4, Full => Lvl1b_Full4);
--Lvl_1b_QUEUE_5: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn5, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn5, DataOut => Lvl1b_DataOut5, Empty => Lvl1b_Empty5, Full => Lvl1b_Full5);
--Lvl_1b_QUEUE_6: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn6, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn6, DataOut => Lvl1b_DataOut6, Empty => Lvl1b_Empty6, Full => Lvl1b_Full6);
--Lvl_1b_QUEUE_7: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn7, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn7, DataOut => Lvl1b_DataOut7, Empty => Lvl1b_Empty7, Full => Lvl1b_Full7);
--Lvl_1b_QUEUE_8: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn8, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn8, DataOut => Lvl1b_DataOut8, Empty => Lvl1b_Empty8, Full => Lvl1b_Full8);
--Lvl_1b_QUEUE_9: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn9, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn9, DataOut => Lvl1b_DataOut9, Empty => Lvl1b_Empty9, Full => Lvl1b_Full9);
--
--Lvl_2_QUEUE_0: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn0, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn0, DataOut => Lvl2_DataOut0, Empty => Lvl2_Empty0, Full => Lvl2_Full0);
--Lvl_2_QUEUE_1: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn1, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn1, DataOut => Lvl2_DataOut1, Empty => Lvl2_Empty1, Full => Lvl2_Full1);
--Lvl_2_QUEUE_2: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn2, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn2, DataOut => Lvl2_DataOut2, Empty => Lvl2_Empty2, Full => Lvl2_Full2);
--Lvl_2_QUEUE_3: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn3, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn3, DataOut => Lvl2_DataOut3, Empty => Lvl2_Empty3, Full => Lvl2_Full3);
--Lvl_2_QUEUE_4: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn4, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn4, DataOut => Lvl2_DataOut4, Empty => Lvl2_Empty4, Full => Lvl2_Full4);
--Lvl_2_QUEUE_5: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn5, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn5, DataOut => Lvl2_DataOut5, Empty => Lvl2_Empty5, Full => Lvl2_Full5);
--Lvl_2_QUEUE_6: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn6, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn6, DataOut => Lvl2_DataOut6, Empty => Lvl2_Empty6, Full => Lvl2_Full6);
--Lvl_2_QUEUE_7: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn7, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn7, DataOut => Lvl2_DataOut7, Empty => Lvl2_Empty7, Full => Lvl2_Full7);
--Lvl_2_QUEUE_8: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn8, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn8, DataOut => Lvl2_DataOut8, Empty => Lvl2_Empty8, Full => Lvl2_Full8);
--Lvl_2_QUEUE_9: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn9, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn9, DataOut => Lvl2_DataOut9, Empty => Lvl2_Empty9, Full => Lvl2_Full9);

VCC_Round <= PacketIn(INPUT_WIDTH - 1 downto DATA_WIDTH);
Packet_Addr <= PacketIn(DATA_WIDTH - 1 downto 0);
--Vld <= ReadEn and VldVector and (not Lvl0a_Empty0 or not Lvl0a_Empty1 or not Lvl0a_Empty2 or not Lvl0a_Empty3 or not Lvl0a_Empty4 or not Lvl0a_Empty5 or not Lvl0a_Empty6 or not Lvl0a_Empty7 or not Lvl0a_Empty8 or not Lvl0a_Empty9);
--VldVector <= Is_Valid(s => Packet_Out_Temp(DATA_WIDTH - 1 Downto 0));

Packet_Out_Temp(DATA_WIDTH - 1 Downto 0) <= Lvl0a_DataOut0(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_0 else
                                      Lvl0a_DataOut1(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_1 else
                                      Lvl0a_DataOut2(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_2 else
                                      Lvl0a_DataOut3(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_3 else
                                      Lvl0a_DataOut4(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_4 else
                                      Lvl0a_DataOut5(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_5 else
                                      Lvl0a_DataOut6(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_6 else
                                      Lvl0a_DataOut7(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_7 else
                                      Lvl0a_DataOut8(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_8 else
                                      Lvl0a_DataOut9(DATA_WIDTH - 1 Downto 0);

PacketOut(DATA_WIDTH - 1 Downto 0) <= Packet_Out_Temp(DATA_WIDTH - 1 Downto 0); 

Lvl0a_ReadEn0 <= '0' when RST='1' else '1' when State = HEAD_QUEUE_0 and ReadEn='1' else '0';
Lvl0a_ReadEn1 <= '0' when RST='1' else '1' when State = HEAD_QUEUE_1 and ReadEn='1' else '0';
Lvl0a_ReadEn2 <= '0' when RST='1' else '1' when State = HEAD_QUEUE_2 and ReadEn='1' else '0';
Lvl0a_ReadEn3 <= '0' when RST='1' else '1' when State = HEAD_QUEUE_3 and ReadEn='1' else '0';
Lvl0a_ReadEn4 <= '0' when RST='1' else '1' when State = HEAD_QUEUE_4 and ReadEn='1' else '0';
Lvl0a_ReadEn5 <= '0' when RST='1' else '1' when State = HEAD_QUEUE_5 and ReadEn='1' else '0';
Lvl0a_ReadEn6 <= '0' when RST='1' else '1' when State = HEAD_QUEUE_6 and ReadEn='1' else '0';
Lvl0a_ReadEn7 <= '0' when RST='1' else '1' when State = HEAD_QUEUE_7 and ReadEn='1' else '0';
Lvl0a_ReadEn8 <= '0' when RST='1' else '1' when State = HEAD_QUEUE_8 and ReadEn='1' else '0';
Lvl0a_ReadEn9 <= '0' when RST='1' else '1' when State = HEAD_QUEUE_9 and ReadEn='1' else '0';

Lvl0a_WriteEn0 <= '0' when RST='1' else
            '1' when WriteEn='1' and State = HEAD_QUEUE_0 and VCC_Round="0000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_1 and VCC_Round="1001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_2 and VCC_Round="1000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_3 and VCC_Round="0111" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_4 and VCC_Round="0110" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_5 and VCC_Round="0101" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_6 and VCC_Round="0100" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_7 and VCC_Round="0011" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_8 and VCC_Round="0010" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_9 and VCC_Round="0001" else
            '0';
       
Lvl0a_WriteEn1 <= '0' when RST='1' else
            '1' when WriteEn='1' and State = HEAD_QUEUE_0 and VCC_Round="0001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_1 and VCC_Round="0000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_2 and VCC_Round="1001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_3 and VCC_Round="1000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_4 and VCC_Round="0111" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_5 and VCC_Round="0110" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_6 and VCC_Round="0101" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_7 and VCC_Round="0100" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_8 and VCC_Round="0011" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_9 and VCC_Round="0010" else
            '0';

Lvl0a_WriteEn2 <= '0' when RST='1' else
            '1' when WriteEn='1' and State = HEAD_QUEUE_0 and VCC_Round="0010" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_1 and VCC_Round="0001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_2 and VCC_Round="0000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_3 and VCC_Round="1001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_4 and VCC_Round="1000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_5 and VCC_Round="0111" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_6 and VCC_Round="0110" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_7 and VCC_Round="0101" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_8 and VCC_Round="0100" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_9 and VCC_Round="0011" else
            '0';

Lvl0a_WriteEn3 <= '0' when RST='1' else
            '1' when WriteEn='1' and State = HEAD_QUEUE_0 and VCC_Round="0011" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_1 and VCC_Round="0010" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_2 and VCC_Round="0001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_3 and VCC_Round="0000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_4 and VCC_Round="1001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_5 and VCC_Round="1000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_6 and VCC_Round="0111" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_7 and VCC_Round="0110" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_8 and VCC_Round="0101" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_9 and VCC_Round="0100" else
            '0';

Lvl0a_WriteEn4 <= '0' when RST='1' else
            '1' when WriteEn='1' and State = HEAD_QUEUE_0 and VCC_Round="0100" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_1 and VCC_Round="0011" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_2 and VCC_Round="0010" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_3 and VCC_Round="0001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_4 and VCC_Round="0000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_5 and VCC_Round="1001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_6 and VCC_Round="1000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_7 and VCC_Round="0111" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_8 and VCC_Round="0110" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_9 and VCC_Round="0101" else
            '0';

Lvl0a_WriteEn5 <= '0' when RST='1' else 
            '1' when WriteEn='1' and State = HEAD_QUEUE_0 and VCC_Round="0101" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_1 and VCC_Round="0100" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_2 and VCC_Round="0011" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_3 and VCC_Round="0010" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_4 and VCC_Round="0001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_5 and VCC_Round="0000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_6 and VCC_Round="1001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_7 and VCC_Round="1000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_8 and VCC_Round="0111" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_9 and VCC_Round="0110" else
            '0';

Lvl0a_WriteEn6 <= '0' when RST='1' else
            '1' when WriteEn='1' and State = HEAD_QUEUE_0 and VCC_Round="0110" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_1 and VCC_Round="0101" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_2 and VCC_Round="0100" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_3 and VCC_Round="0011" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_4 and VCC_Round="0010" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_5 and VCC_Round="0001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_6 and VCC_Round="0000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_7 and VCC_Round="1001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_8 and VCC_Round="1000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_9 and VCC_Round="0111" else
            '0';

Lvl0a_WriteEn7 <= '0' when RST='1' else
            '1' when WriteEn='1' and State = HEAD_QUEUE_0 and VCC_Round="0111" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_1 and VCC_Round="0110" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_2 and VCC_Round="0101" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_3 and VCC_Round="0100" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_4 and VCC_Round="0011" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_5 and VCC_Round="0010" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_6 and VCC_Round="0001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_7 and VCC_Round="0000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_8 and VCC_Round="1001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_9 and VCC_Round="1000" else
            '0';

Lvl0a_WriteEn8 <= '0' when RST='1' else
            '1' when WriteEn='1' and State = HEAD_QUEUE_0 and VCC_Round="1000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_1 and VCC_Round="0111" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_2 and VCC_Round="0110" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_3 and VCC_Round="0101" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_4 and VCC_Round="0100" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_5 and VCC_Round="0011" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_6 and VCC_Round="0010" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_7 and VCC_Round="0001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_8 and VCC_Round="0000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_9 and VCC_Round="1001" else
            '0';

Lvl0a_WriteEn9 <= '0' when RST='1' else
            '1' when WriteEn='1' and State = HEAD_QUEUE_0 and VCC_Round="1001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_1 and VCC_Round="1000" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_2 and VCC_Round="0111" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_3 and VCC_Round="0110" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_4 and VCC_Round="0101" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_5 and VCC_Round="0100" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_6 and VCC_Round="0011" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_7 and VCC_Round="0010" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_8 and VCC_Round="0001" else
            '1' when WriteEn='1' and State = HEAD_QUEUE_9 and VCC_Round="0000" else
            '0';



--Lvl0a_EmptyVector <= Lvl0a_Empty0 & Lvl0a_Empty1 & Lvl0a_Empty2 & Lvl0a_Empty3 & Lvl0a_Empty4 & Lvl0a_Empty5 & Lvl0a_Empty6 & Lvl0a_Empty7 & Lvl0a_Empty8 & Lvl0a_Empty9;  


--pkt_out : process(CLK,State)
--begin
--if rising_edge(CLK) then 
--    case State is
--        when HEAD_QUEUE_0 => PacketOut(DATA_WIDTH - 1 Downto 0) <= Lvl0a_DataOut0(DATA_WIDTH - 1 Downto 0);
--        when HEAD_QUEUE_1 => PacketOut(DATA_WIDTH - 1 Downto 0) <= Lvl0a_DataOut1(DATA_WIDTH - 1 Downto 0);
--        when HEAD_QUEUE_2 => PacketOut(DATA_WIDTH - 1 Downto 0) <= Lvl0a_DataOut2(DATA_WIDTH - 1 Downto 0);
--        when HEAD_QUEUE_3 => PacketOut(DATA_WIDTH - 1 Downto 0) <= Lvl0a_DataOut3(DATA_WIDTH - 1 Downto 0);
--        when HEAD_QUEUE_4 => PacketOut(DATA_WIDTH - 1 Downto 0) <= Lvl0a_DataOut4(DATA_WIDTH - 1 Downto 0);
--        when HEAD_QUEUE_5 => PacketOut(DATA_WIDTH - 1 Downto 0) <= Lvl0a_DataOut5(DATA_WIDTH - 1 Downto 0);
--        when HEAD_QUEUE_6 => PacketOut(DATA_WIDTH - 1 Downto 0) <= Lvl0a_DataOut6(DATA_WIDTH - 1 Downto 0);
--        when HEAD_QUEUE_7 => PacketOut(DATA_WIDTH - 1 Downto 0) <= Lvl0a_DataOut7(DATA_WIDTH - 1 Downto 0);
--        when HEAD_QUEUE_8 => PacketOut(DATA_WIDTH - 1 Downto 0) <= Lvl0a_DataOut8(DATA_WIDTH - 1 Downto 0);
--        when HEAD_QUEUE_9 => PacketOut(DATA_WIDTH - 1 Downto 0) <= Lvl0a_DataOut9(DATA_WIDTH - 1 Downto 0); 
--    end case;
--end if;
--end process;                                
                                      

state_machine : process(CLK,RST,State,Lvl0a_Empty0,Lvl0a_Empty1,Lvl0a_Empty2,Lvl0a_Empty3,Lvl0a_Empty4,Lvl0a_Empty5,Lvl0a_Empty6,Lvl0a_Empty7,Lvl0a_Empty8,Lvl0a_Empty9) 
begin
--if rising_edge(CLK) then
    if(RST='1') then
        State <= HEAD_QUEUE_0;
    else
        case State is
            when HEAD_QUEUE_0 => if Lvl0a_Empty0='1' then
                                    if Lvl0a_Empty1='0' then State <= HEAD_QUEUE_1;
                                    elsif Lvl0a_Empty2='0' then State <=HEAD_QUEUE_2;
                                    elsif Lvl0a_Empty3='0' then State <=HEAD_QUEUE_3;
                                    elsif Lvl0a_Empty4='0' then State <=HEAD_QUEUE_4;
                                    elsif Lvl0a_Empty5='0' then State <=HEAD_QUEUE_5;
                                    elsif Lvl0a_Empty6='0' then State <=HEAD_QUEUE_6;
                                    elsif Lvl0a_Empty7='0' then State <=HEAD_QUEUE_7;
                                    elsif Lvl0a_Empty8='0' then State <=HEAD_QUEUE_8;
                                    elsif Lvl0a_Empty9='0' then State <=HEAD_QUEUE_9;
                                    else State <= HEAD_QUEUE_0;
                                    end if;
											else State <= HEAD_QUEUE_0;
                                end if;
            when HEAD_QUEUE_1 => if Lvl0a_Empty1='1' then
                                    if Lvl0a_Empty2='0' then State <= HEAD_QUEUE_2;
                                    elsif Lvl0a_Empty3='0' then State <=HEAD_QUEUE_3;
                                    elsif Lvl0a_Empty4='0' then State <=HEAD_QUEUE_4;
                                    elsif Lvl0a_Empty5='0' then State <=HEAD_QUEUE_5;
                                    elsif Lvl0a_Empty6='0' then State <=HEAD_QUEUE_6;
                                    elsif Lvl0a_Empty7='0' then State <=HEAD_QUEUE_7;
                                    elsif Lvl0a_Empty8='0' then State <=HEAD_QUEUE_8;
                                    elsif Lvl0a_Empty9='0' then State <=HEAD_QUEUE_9;
                                    elsif Lvl0a_Empty0='0' then State <=HEAD_QUEUE_0;
                                    else State <= HEAD_QUEUE_1; 
                                    end if;
											else State <= HEAD_QUEUE_1;
                               end if;
            when HEAD_QUEUE_2 => if Lvl0a_Empty2='1' then
                                   if Lvl0a_Empty3='0' then State <= HEAD_QUEUE_3;
                                   elsif Lvl0a_Empty4='0' then State <=HEAD_QUEUE_4;
                                   elsif Lvl0a_Empty5='0' then State <=HEAD_QUEUE_5;
                                   elsif Lvl0a_Empty6='0' then State <=HEAD_QUEUE_6;
                                   elsif Lvl0a_Empty7='0' then State <=HEAD_QUEUE_7;
                                   elsif Lvl0a_Empty8='0' then State <=HEAD_QUEUE_8;
                                   elsif Lvl0a_Empty9='0' then State <=HEAD_QUEUE_9;
                                   elsif Lvl0a_Empty0='0' then State <=HEAD_QUEUE_0;
                                   elsif Lvl0a_Empty1='0' then State <=HEAD_QUEUE_1;
                                   else State <= HEAD_QUEUE_2; 
                                   end if;
											else State <= HEAD_QUEUE_2;
                              end if;
            when HEAD_QUEUE_3 => if Lvl0a_Empty3='1' then
                                     if Lvl0a_Empty4='0' then State <=HEAD_QUEUE_4;
                                     elsif Lvl0a_Empty5='0' then State <=HEAD_QUEUE_5;
                                     elsif Lvl0a_Empty6='0' then State <=HEAD_QUEUE_6;
                                     elsif Lvl0a_Empty7='0' then State <=HEAD_QUEUE_7;
                                     elsif Lvl0a_Empty8='0' then State <=HEAD_QUEUE_8;
                                     elsif Lvl0a_Empty9='0' then State <=HEAD_QUEUE_9;
                                     elsif Lvl0a_Empty0='0' then State <=HEAD_QUEUE_0;
                                     elsif Lvl0a_Empty1='0' then State <=HEAD_QUEUE_1;
                                     elsif Lvl0a_Empty2='0' then State <=HEAD_QUEUE_2;
                                     else State <= HEAD_QUEUE_3; 
                                     end if;
											else State <= HEAD_QUEUE_3;
                                end if;
             when HEAD_QUEUE_4 => if Lvl0a_Empty4='1' then
                                     if Lvl0a_Empty5='0' then State <=HEAD_QUEUE_5;
                                     elsif Lvl0a_Empty6='0' then State <=HEAD_QUEUE_6;
                                     elsif Lvl0a_Empty7='0' then State <=HEAD_QUEUE_7;
                                     elsif Lvl0a_Empty8='0' then State <=HEAD_QUEUE_8;
                                     elsif Lvl0a_Empty9='0' then State <=HEAD_QUEUE_9;
                                     elsif Lvl0a_Empty0='0' then State <=HEAD_QUEUE_0;
                                     elsif Lvl0a_Empty1='0' then State <=HEAD_QUEUE_1;
                                     elsif Lvl0a_Empty2='0' then State <=HEAD_QUEUE_2;
                                     elsif Lvl0a_Empty3='0' then State <=HEAD_QUEUE_3;
                                     else State <= HEAD_QUEUE_4; 
                                     end if;
											else State <= HEAD_QUEUE_4;
                                end if;
             when HEAD_QUEUE_5 => if Lvl0a_Empty5='1' then
                                     if Lvl0a_Empty6='0' then State <=HEAD_QUEUE_6;
                                     elsif Lvl0a_Empty7='0' then State <=HEAD_QUEUE_7;
                                     elsif Lvl0a_Empty8='0' then State <=HEAD_QUEUE_8;
                                     elsif Lvl0a_Empty9='0' then State <=HEAD_QUEUE_9;
                                     elsif Lvl0a_Empty0='0' then State <=HEAD_QUEUE_0;
                                     elsif Lvl0a_Empty1='0' then State <=HEAD_QUEUE_1;
                                     elsif Lvl0a_Empty2='0' then State <=HEAD_QUEUE_2;
                                     elsif Lvl0a_Empty3='0' then State <=HEAD_QUEUE_3;
                                     elsif Lvl0a_Empty4='0' then State <=HEAD_QUEUE_4;
                                     else State <= HEAD_QUEUE_5;
                                     end if;
											else State <= HEAD_QUEUE_5;
                                end if;                                      
             when HEAD_QUEUE_6 => if Lvl0a_Empty6='1' then
                                     if Lvl0a_Empty7='0' then State <=HEAD_QUEUE_7;
                                     elsif Lvl0a_Empty8='0' then State <=HEAD_QUEUE_8;
                                     elsif Lvl0a_Empty9='0' then State <=HEAD_QUEUE_9;
                                     elsif Lvl0a_Empty0='0' then State <=HEAD_QUEUE_0;
                                     elsif Lvl0a_Empty1='0' then State <=HEAD_QUEUE_1;
                                     elsif Lvl0a_Empty2='0' then State <=HEAD_QUEUE_2;
                                     elsif Lvl0a_Empty3='0' then State <=HEAD_QUEUE_3;
                                     elsif Lvl0a_Empty4='0' then State <=HEAD_QUEUE_4;
                                     elsif Lvl0a_Empty5='0' then State <=HEAD_QUEUE_5;
                                     else State <= HEAD_QUEUE_6;
                                     end if;
											else State <= HEAD_QUEUE_6;
                                end if;                                      
             when HEAD_QUEUE_7 => if Lvl0a_Empty7='1' then
                                     if Lvl0a_Empty8='0' then State <=HEAD_QUEUE_8;
                                     elsif Lvl0a_Empty9='0' then State <=HEAD_QUEUE_9;
                                     elsif Lvl0a_Empty0='0' then State <=HEAD_QUEUE_0;
                                     elsif Lvl0a_Empty1='0' then State <=HEAD_QUEUE_1;
                                     elsif Lvl0a_Empty2='0' then State <=HEAD_QUEUE_2;
                                     elsif Lvl0a_Empty3='0' then State <=HEAD_QUEUE_3;
                                     elsif Lvl0a_Empty4='0' then State <=HEAD_QUEUE_4;
                                     elsif Lvl0a_Empty5='0' then State <=HEAD_QUEUE_5;
                                     elsif Lvl0a_Empty6='0' then State <=HEAD_QUEUE_6;
                                     else State <= HEAD_QUEUE_7;
                                     end if;
											else State <= HEAD_QUEUE_7;
                                end if;
             when HEAD_QUEUE_8 => if Lvl0a_Empty8='1' then
                                     if Lvl0a_Empty9='0' then State <=HEAD_QUEUE_9;
                                      elsif Lvl0a_Empty0='0' then State <=HEAD_QUEUE_0;
                                      elsif Lvl0a_Empty1='0' then State <=HEAD_QUEUE_1;
                                      elsif Lvl0a_Empty2='0' then State <=HEAD_QUEUE_2;
                                      elsif Lvl0a_Empty3='0' then State <=HEAD_QUEUE_3;
                                      elsif Lvl0a_Empty4='0' then State <=HEAD_QUEUE_4;
                                      elsif Lvl0a_Empty5='0' then State <=HEAD_QUEUE_5;
                                      elsif Lvl0a_Empty6='0' then State <=HEAD_QUEUE_6;
                                      elsif Lvl0a_Empty7='0' then State <=HEAD_QUEUE_7;
                                      else State <= HEAD_QUEUE_8;
                                      end if;
												else State <= HEAD_QUEUE_8;
                                 end if;
            when HEAD_QUEUE_9 => if Lvl0a_Empty9='1' then
                                      if Lvl0a_Empty0='0' then State <=HEAD_QUEUE_0;
                                       elsif Lvl0a_Empty1='0' then State <=HEAD_QUEUE_1;
                                       elsif Lvl0a_Empty2='0' then State <=HEAD_QUEUE_2;
                                       elsif Lvl0a_Empty3='0' then State <=HEAD_QUEUE_3;
                                       elsif Lvl0a_Empty4='0' then State <=HEAD_QUEUE_4;
                                       elsif Lvl0a_Empty5='0' then State <=HEAD_QUEUE_5;
                                       elsif Lvl0a_Empty6='0' then State <=HEAD_QUEUE_6;
                                       elsif Lvl0a_Empty7='0' then State <=HEAD_QUEUE_7;
                                       elsif Lvl0a_Empty8='0' then State <=HEAD_QUEUE_8;
                                       else State <= HEAD_QUEUE_9;
                                       end if;
											  else State <= HEAD_QUEUE_9;
                                  end if;
				--when others			=> State <= HEAD_QUEUE_0;
           end case;
      end if;
--end if;
end process;

end Behavioral;
