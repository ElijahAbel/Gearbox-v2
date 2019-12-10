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
use IEEE.numeric_std.ALL;
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

signal Lvl0b_WriteEn0, Lvl0b_WriteEn1, Lvl0b_WriteEn2, Lvl0b_WriteEn3, Lvl0b_WriteEn4, Lvl0b_WriteEn5, Lvl0b_WriteEn6, Lvl0b_WriteEn7, Lvl0b_WriteEn8, Lvl0b_WriteEn9 : std_logic := '0';
signal Lvl0b_ReadEn0, Lvl0b_ReadEn1, Lvl0b_ReadEn2, Lvl0b_ReadEn3, Lvl0b_ReadEn4, Lvl0b_ReadEn5, Lvl0b_ReadEn6, Lvl0b_ReadEn7, Lvl0b_ReadEn8, Lvl0b_ReadEn9 : std_logic := '0';
signal Lvl0b_DataOut0, Lvl0b_DataOut1, Lvl0b_DataOut2, Lvl0b_DataOut3, Lvl0b_DataOut4, Lvl0b_DataOut5, Lvl0b_DataOut6, Lvl0b_DataOut7, Lvl0b_DataOut8, Lvl0b_DataOut9 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
signal Lvl0b_Empty0, Lvl0b_Empty1, Lvl0b_Empty2, Lvl0b_Empty3, Lvl0b_Empty4, Lvl0b_Empty5, Lvl0b_Empty6, Lvl0b_Empty7, Lvl0b_Empty8, Lvl0b_Empty9 : STD_LOGIC;
--signal Lvl0b_Full0, Lvl0b_Full1, Lvl0b_Full2, Lvl0b_Full3, Lvl0b_Full4, Lvl0b_Full5, Lvl0b_Full6, Lvl0b_Full7, Lvl0b_Full8, Lvl0b_Full9 : STD_LOGIC;

signal Lvl1a_WriteEn0, Lvl1a_WriteEn1, Lvl1a_WriteEn2, Lvl1a_WriteEn3, Lvl1a_WriteEn4, Lvl1a_WriteEn5, Lvl1a_WriteEn6, Lvl1a_WriteEn7, Lvl1a_WriteEn8, Lvl1a_WriteEn9 : std_logic := '0';
signal Lvl1a_ReadEn0, Lvl1a_ReadEn1, Lvl1a_ReadEn2, Lvl1a_ReadEn3, Lvl1a_ReadEn4, Lvl1a_ReadEn5, Lvl1a_ReadEn6, Lvl1a_ReadEn7, Lvl1a_ReadEn8, Lvl1a_ReadEn9 : std_logic := '0';
signal Lvl1a_DataOut0, Lvl1a_DataOut1, Lvl1a_DataOut2, Lvl1a_DataOut3, Lvl1a_DataOut4, Lvl1a_DataOut5, Lvl1a_DataOut6, Lvl1a_DataOut7, Lvl1a_DataOut8, Lvl1a_DataOut9 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
signal Lvl1a_Empty0, Lvl1a_Empty1, Lvl1a_Empty2, Lvl1a_Empty3, Lvl1a_Empty4, Lvl1a_Empty5, Lvl1a_Empty6, Lvl1a_Empty7, Lvl1a_Empty8, Lvl1a_Empty9 : STD_LOGIC;
--signal Lvl1a_Full0, Lvl1a_Full1, Lvl1a_Full2, Lvl1a_Full3, Lvl1a_Full4, Lvl1a_Full5, Lvl1a_Full6, Lvl1a_Full7, Lvl1a_Full8, Lvl1a_Full9 : STD_LOGIC;

signal Lvl1b_WriteEn0, Lvl1b_WriteEn1, Lvl1b_WriteEn2, Lvl1b_WriteEn3, Lvl1b_WriteEn4, Lvl1b_WriteEn5, Lvl1b_WriteEn6, Lvl1b_WriteEn7, Lvl1b_WriteEn8, Lvl1b_WriteEn9 : std_logic := '0';
signal Lvl1b_ReadEn0, Lvl1b_ReadEn1, Lvl1b_ReadEn2, Lvl1b_ReadEn3, Lvl1b_ReadEn4, Lvl1b_ReadEn5, Lvl1b_ReadEn6, Lvl1b_ReadEn7, Lvl1b_ReadEn8, Lvl1b_ReadEn9 : std_logic := '0';
signal Lvl1b_DataOut0, Lvl1b_DataOut1, Lvl1b_DataOut2, Lvl1b_DataOut3, Lvl1b_DataOut4, Lvl1b_DataOut5, Lvl1b_DataOut6, Lvl1b_DataOut7, Lvl1b_DataOut8, Lvl1b_DataOut9 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
signal Lvl1b_Empty0, Lvl1b_Empty1, Lvl1b_Empty2, Lvl1b_Empty3, Lvl1b_Empty4, Lvl1b_Empty5, Lvl1b_Empty6, Lvl1b_Empty7, Lvl1b_Empty8, Lvl1b_Empty9 : STD_LOGIC;
--signal Lvl1b_Full0, Lvl1b_Full1, Lvl1b_Full2, Lvl1b_Full3, Lvl1b_Full4, Lvl1b_Full5, Lvl1b_Full6, Lvl1b_Full7, Lvl1b_Full8, Lvl1b_Full9 : STD_LOGIC;

signal Lvl2_WriteEn0, Lvl2_WriteEn1, Lvl2_WriteEn2, Lvl2_WriteEn3, Lvl2_WriteEn4, Lvl2_WriteEn5, Lvl2_WriteEn6, Lvl2_WriteEn7, Lvl2_WriteEn8, Lvl2_WriteEn9 : std_logic := '0';
signal Lvl2_ReadEn0, Lvl2_ReadEn1, Lvl2_ReadEn2, Lvl2_ReadEn3, Lvl2_ReadEn4, Lvl2_ReadEn5, Lvl2_ReadEn6, Lvl2_ReadEn7, Lvl2_ReadEn8, Lvl2_ReadEn9 : std_logic := '0';
signal Lvl2_DataOut0, Lvl2_DataOut1, Lvl2_DataOut2, Lvl2_DataOut3, Lvl2_DataOut4, Lvl2_DataOut5, Lvl2_DataOut6, Lvl2_DataOut7, Lvl2_DataOut8, Lvl2_DataOut9 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
signal Lvl2_Empty0, Lvl2_Empty1, Lvl2_Empty2, Lvl2_Empty3, Lvl2_Empty4, Lvl2_Empty5, Lvl2_Empty6, Lvl2_Empty7, Lvl2_Empty8, Lvl2_Empty9 : STD_LOGIC;
--signal Lvl2_Full0, Lvl2_Full1, Lvl2_Full2, Lvl2_Full3, Lvl2_Full4, Lvl2_Full5, Lvl2_Full6, Lvl2_Full7, Lvl2_Full8, Lvl2_Full9 : STD_LOGIC;

signal VC : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
signal VCC_Round : STD_LOGIC_VECTOR(3 DOWNTO 0); --tells us which queue we should place a packet in
signal Packet_Addr : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
signal Packet_Out_Temp : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0); 
signal State : GBStateType := LVL_0A;
signal Vld, VldVector : std_logic := '0';
signal Lvl0a_EmptyVector : STD_LOGIC_VECTOR(9 DOWNTO 0);
signal arrivalUpperBound : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000001001";
signal arrivalLowerBound : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000001001";
signal lvl1Counter, lvl2Counter : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000"; --To keep track of how many packets have been dequeued each round
--signal Tens, Hundreds, Thousands : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => 0);
signal Tens, Hundreds, Thousands, Aggregate : integer := 0;
signal VC_In, VC_In_Adj, queue_sel_lvl1_adj, queue_sel_lvl2_adj : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal queue_sel_lvl0, queue_sel_lvl1, queue_sel_lvl2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal empty : std_logic;
signal counter_to_ten : std_logic_vector(3 DOWNTO 0) := (others => '0');
signal counter_to_hundred : std_logic_vector(6 DOWNTO 0) := (others => '0');
signal counter_to_thousand : std_logic_vector(9 DOWNTO 0) := (others => '0');
signal tens_counter, hundreds_counter : std_logic_vector(3 DOWNTO 0) := (others => '0');
signal twenties_counter, two_hundreds_counter : integer := 1;
signal every_twenty, every_two_hundred : integer := 0;
signal state_sel_0_adj, state_sel_1_adj : integer;
signal state_sel_lvl0, state_sel_lvl1 : std_logic := '0'; --if '0' then a, if '1' then b
--signal curr_queue_empty : std_logic;

--signal CurrFIFOLvl0a_Empty : std_logic := '0'; 

begin
--Aggregate <= Tens + Hundreds + Thousands;
VC_In_Adj <= std_logic_vector(to_unsigned(Tens + Hundreds + Thousands, VC_In_Adj'length)); --adjustment value based on current VC
VC_In <= std_logic_vector(unsigned(VC) - unsigned(VC_In_Adj)); --signal for determining in which queue an incoming backet should be placed relative to VC
queue_sel_lvl0 <= counter_to_ten;
--queue_sel_lvl1_adj <= VC - Thousands - Hundreds;
queue_sel_lvl1 <= tens_counter;
--queue_sel_lvl2_adj <= VC - Thousands;
queue_sel_lvl2 <= hundreds_counter;

state_sel_0_adj <= to_integer(unsigned(VC)) - every_twenty;
state_sel_1_adj <= to_integer(unsigned(VC)) - every_two_hundred;

state_sel_lvl0 <= '0' when state_sel_0_adj < 10 else '1';
state_sel_lvl1 <= '0' when state_sel_1_adj < 100 else '1';



VCC_Round <= PacketIn(INPUT_WIDTH - 1 downto DATA_WIDTH);
Packet_Addr <= PacketIn(DATA_WIDTH - 1 downto 0);
--Vld <= ReadEn and VldVector and (not Lvl0a_Empty0 or not Lvl0a_Empty1 or not Lvl0a_Empty2 or not Lvl0a_Empty3 or not Lvl0a_Empty4 or not Lvl0a_Empty5 or not Lvl0a_Empty6 or not Lvl0a_Empty7 or not Lvl0a_Empty8 or not Lvl0a_Empty9);
--VldVector <= Is_Valid(s => Packet_Out_Temp(DATA_WIDTH - 1 Downto 0));

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
Lvl_0b_QUEUE_0: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn0, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn0, DataOut => Lvl0b_DataOut0, Empty => Lvl0b_Empty0);
Lvl_0b_QUEUE_1: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn1, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn1, DataOut => Lvl0b_DataOut1, Empty => Lvl0b_Empty1);
Lvl_0b_QUEUE_2: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn2, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn2, DataOut => Lvl0b_DataOut2, Empty => Lvl0b_Empty2);
Lvl_0b_QUEUE_3: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn3, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn3, DataOut => Lvl0b_DataOut3, Empty => Lvl0b_Empty3);
Lvl_0b_QUEUE_4: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn4, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn4, DataOut => Lvl0b_DataOut4, Empty => Lvl0b_Empty4);
Lvl_0b_QUEUE_5: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn5, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn5, DataOut => Lvl0b_DataOut5, Empty => Lvl0b_Empty5);
Lvl_0b_QUEUE_6: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn6, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn6, DataOut => Lvl0b_DataOut6, Empty => Lvl0b_Empty6);
Lvl_0b_QUEUE_7: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn7, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn7, DataOut => Lvl0b_DataOut7, Empty => Lvl0b_Empty7);
Lvl_0b_QUEUE_8: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn8, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn8, DataOut => Lvl0b_DataOut8, Empty => Lvl0b_Empty8);
Lvl_0b_QUEUE_9: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl0b_WriteEn9, PacketIn => Packet_Addr, ReadEn => Lvl0b_ReadEn9, DataOut => Lvl0b_DataOut9, Empty => Lvl0b_Empty9);

Lvl_1a_QUEUE_0: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn0, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn0, DataOut => Lvl1a_DataOut0, Empty => Lvl1a_Empty0);
Lvl_1a_QUEUE_1: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn1, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn1, DataOut => Lvl1a_DataOut1, Empty => Lvl1a_Empty1);
Lvl_1a_QUEUE_2: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn2, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn2, DataOut => Lvl1a_DataOut2, Empty => Lvl1a_Empty2);
Lvl_1a_QUEUE_3: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn3, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn3, DataOut => Lvl1a_DataOut3, Empty => Lvl1a_Empty3);
Lvl_1a_QUEUE_4: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn4, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn4, DataOut => Lvl1a_DataOut4, Empty => Lvl1a_Empty4);
Lvl_1a_QUEUE_5: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn5, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn5, DataOut => Lvl1a_DataOut5, Empty => Lvl1a_Empty5);
Lvl_1a_QUEUE_6: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn6, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn6, DataOut => Lvl1a_DataOut6, Empty => Lvl1a_Empty6);
Lvl_1a_QUEUE_7: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn7, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn7, DataOut => Lvl1a_DataOut7, Empty => Lvl1a_Empty7);
Lvl_1a_QUEUE_8: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn8, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn8, DataOut => Lvl1a_DataOut8, Empty => Lvl1a_Empty8);
Lvl_1a_QUEUE_9: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1a_WriteEn9, PacketIn => Packet_Addr, ReadEn => Lvl1a_ReadEn9, DataOut => Lvl1a_DataOut9, Empty => Lvl1a_Empty9);

Lvl_1b_QUEUE_0: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn0, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn0, DataOut => Lvl1b_DataOut0, Empty => Lvl1b_Empty0);
Lvl_1b_QUEUE_1: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn1, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn1, DataOut => Lvl1b_DataOut1, Empty => Lvl1b_Empty1);
Lvl_1b_QUEUE_2: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn2, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn2, DataOut => Lvl1b_DataOut2, Empty => Lvl1b_Empty2);
Lvl_1b_QUEUE_3: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn3, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn3, DataOut => Lvl1b_DataOut3, Empty => Lvl1b_Empty3);
Lvl_1b_QUEUE_4: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn4, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn4, DataOut => Lvl1b_DataOut4, Empty => Lvl1b_Empty4);
Lvl_1b_QUEUE_5: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn5, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn5, DataOut => Lvl1b_DataOut5, Empty => Lvl1b_Empty5);
Lvl_1b_QUEUE_6: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn6, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn6, DataOut => Lvl1b_DataOut6, Empty => Lvl1b_Empty6);
Lvl_1b_QUEUE_7: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn7, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn7, DataOut => Lvl1b_DataOut7, Empty => Lvl1b_Empty7);
Lvl_1b_QUEUE_8: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn8, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn8, DataOut => Lvl1b_DataOut8, Empty => Lvl1b_Empty8);
Lvl_1b_QUEUE_9: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl1b_WriteEn9, PacketIn => Packet_Addr, ReadEn => Lvl1b_ReadEn9, DataOut => Lvl1b_DataOut9, Empty => Lvl1b_Empty9);

Lvl_2_QUEUE_0: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn0, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn0, DataOut => Lvl2_DataOut0, Empty => Lvl2_Empty0);
Lvl_2_QUEUE_1: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn1, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn1, DataOut => Lvl2_DataOut1, Empty => Lvl2_Empty1);
Lvl_2_QUEUE_2: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn2, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn2, DataOut => Lvl2_DataOut2, Empty => Lvl2_Empty2);
Lvl_2_QUEUE_3: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn3, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn3, DataOut => Lvl2_DataOut3, Empty => Lvl2_Empty3);
Lvl_2_QUEUE_4: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn4, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn4, DataOut => Lvl2_DataOut4, Empty => Lvl2_Empty4);
Lvl_2_QUEUE_5: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn5, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn5, DataOut => Lvl2_DataOut5, Empty => Lvl2_Empty5);
Lvl_2_QUEUE_6: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn6, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn6, DataOut => Lvl2_DataOut6, Empty => Lvl2_Empty6);
Lvl_2_QUEUE_7: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn7, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn7, DataOut => Lvl2_DataOut7, Empty => Lvl2_Empty7);
Lvl_2_QUEUE_8: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn8, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn8, DataOut => Lvl2_DataOut8, Empty => Lvl2_Empty8);
Lvl_2_QUEUE_9: FIFO PORT MAP(CLK => CLK, RST => RST, WriteEn => Lvl2_WriteEn9, PacketIn => Packet_Addr, ReadEn => Lvl2_ReadEn9, DataOut => Lvl2_DataOut9, Empty => Lvl2_Empty9);

--Packet_Out_Temp(DATA_WIDTH - 1 Downto 0) <= Lvl0a_DataOut0(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_0 else
--                                      Lvl0a_DataOut1(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_1 else
--                                      Lvl0a_DataOut2(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_2 else
--                                      Lvl0a_DataOut3(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_3 else
--                                      Lvl0a_DataOut4(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_4 else
--                                      Lvl0a_DataOut5(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_5 else
--                                      Lvl0a_DataOut6(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_6 else
--                                      Lvl0a_DataOut7(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_7 else
--                                      Lvl0a_DataOut8(DATA_WIDTH - 1 Downto 0) when State = HEAD_QUEUE_8 else
--                                      Lvl0a_DataOut9(DATA_WIDTH - 1 Downto 0);

PacketOut(DATA_WIDTH - 1 Downto 0) <= Packet_Out_Temp(DATA_WIDTH - 1 Downto 0); 


--===========Set Read Signals===============--
Lvl0a_ReadEn0 <= '0' when RST='1' else '1' when State = LVL_0A and ReadEn='1' and queue_sel_lvl0="0000" else '0';
Lvl0a_ReadEn1 <= '0' when RST='1' else '1' when State = LVL_0A and ReadEn='1' and queue_sel_lvl0="0001" else '0';
Lvl0a_ReadEn2 <= '0' when RST='1' else '1' when State = LVL_0A and ReadEn='1' and queue_sel_lvl0="0010" else '0';
Lvl0a_ReadEn3 <= '0' when RST='1' else '1' when State = LVL_0A and ReadEn='1' and queue_sel_lvl0="0011" else '0';
Lvl0a_ReadEn4 <= '0' when RST='1' else '1' when State = LVL_0A and ReadEn='1' and queue_sel_lvl0="0100" else '0';
Lvl0a_ReadEn5 <= '0' when RST='1' else '1' when State = LVL_0A and ReadEn='1' and queue_sel_lvl0="0101" else '0';
Lvl0a_ReadEn6 <= '0' when RST='1' else '1' when State = LVL_0A and ReadEn='1' and queue_sel_lvl0="0110" else '0';
Lvl0a_ReadEn7 <= '0' when RST='1' else '1' when State = LVL_0A and ReadEn='1' and queue_sel_lvl0="0111" else '0';
Lvl0a_ReadEn8 <= '0' when RST='1' else '1' when State = LVL_0A and ReadEn='1' and queue_sel_lvl0="1000" else '0';
Lvl0a_ReadEn9 <= '0' when RST='1' else '1' when State = LVL_0A and ReadEn='1' and queue_sel_lvl0="1001" else '0';

Lvl0b_ReadEn0 <= '0' when RST='1' else '1' when State = LVL_0B and ReadEn='1' and queue_sel_lvl0="0000" else '0';
Lvl0b_ReadEn1 <= '0' when RST='1' else '1' when State = LVL_0B and ReadEn='1' and queue_sel_lvl0="0001" else '0';
Lvl0b_ReadEn2 <= '0' when RST='1' else '1' when State = LVL_0B and ReadEn='1' and queue_sel_lvl0="0010" else '0';
Lvl0b_ReadEn3 <= '0' when RST='1' else '1' when State = LVL_0B and ReadEn='1' and queue_sel_lvl0="0011" else '0';
Lvl0b_ReadEn4 <= '0' when RST='1' else '1' when State = LVL_0B and ReadEn='1' and queue_sel_lvl0="0100" else '0';
Lvl0b_ReadEn5 <= '0' when RST='1' else '1' when State = LVL_0B and ReadEn='1' and queue_sel_lvl0="0101" else '0';
Lvl0b_ReadEn6 <= '0' when RST='1' else '1' when State = LVL_0B and ReadEn='1' and queue_sel_lvl0="0110" else '0';
Lvl0b_ReadEn7 <= '0' when RST='1' else '1' when State = LVL_0B and ReadEn='1' and queue_sel_lvl0="0111" else '0';
Lvl0b_ReadEn8 <= '0' when RST='1' else '1' when State = LVL_0B and ReadEn='1' and queue_sel_lvl0="1000" else '0';
Lvl0b_ReadEn9 <= '0' when RST='1' else '1' when State = LVL_0B and ReadEn='1' and queue_sel_lvl0="1001" else '0';

--===========END Set Read Signals===============--

--===========Set Empty Signal=======--
empty <= Lvl0a_Empty0 when RST='1' or (State = LVL_0A and queue_sel_lvl0="0000") else
			Lvl0a_Empty1 when State = LVL_0A and queue_sel_lvl0="0001" else
			Lvl0a_Empty2 when State = LVL_0A and queue_sel_lvl0="0010" else
			Lvl0a_Empty3 when State = LVL_0A and queue_sel_lvl0="0011" else
			Lvl0a_Empty4 when State = LVL_0A and queue_sel_lvl0="0100" else
			Lvl0a_Empty5 when State = LVL_0A and queue_sel_lvl0="0101" else
			Lvl0a_Empty6 when State = LVL_0A and queue_sel_lvl0="0110" else
			Lvl0a_Empty7 when State = LVL_0A and queue_sel_lvl0="0111" else
			Lvl0a_Empty8 when State = LVL_0A and queue_sel_lvl0="1000" else
			Lvl0a_Empty9 when State = LVL_0A and queue_sel_lvl0="1001" else
			Lvl0b_Empty0 when State = LVL_0B and queue_sel_lvl0="0000" else
			Lvl0b_Empty1 when State = LVL_0B and queue_sel_lvl0="0001" else
			Lvl0b_Empty2 when State = LVL_0B and queue_sel_lvl0="0010" else
			Lvl0b_Empty3 when State = LVL_0B and queue_sel_lvl0="0011" else
			Lvl0b_Empty4 when State = LVL_0B and queue_sel_lvl0="0100" else
			Lvl0b_Empty5 when State = LVL_0B and queue_sel_lvl0="0101" else
			Lvl0b_Empty6 when State = LVL_0B and queue_sel_lvl0="0110" else
			Lvl0b_Empty7 when State = LVL_0B and queue_sel_lvl0="0111" else
			Lvl0b_Empty8 when State = LVL_0B and queue_sel_lvl0="1000" else
			Lvl0b_Empty9 when State = LVL_0B and queue_sel_lvl0="1001" else
			Lvl1a_Empty0 when State = LVL_1A and queue_sel_lvl1="0000" else
			Lvl1a_Empty1 when State = LVL_1A and queue_sel_lvl1="0001" else
			Lvl1a_Empty2 when State = LVL_1A and queue_sel_lvl1="0010" else
			Lvl1a_Empty3 when State = LVL_1A and queue_sel_lvl1="0011" else
			Lvl1a_Empty4 when State = LVL_1A and queue_sel_lvl1="0100" else
			Lvl1a_Empty5 when State = LVL_1A and queue_sel_lvl1="0101" else
			Lvl1a_Empty6 when State = LVL_1A and queue_sel_lvl1="0110" else
			Lvl1a_Empty7 when State = LVL_1A and queue_sel_lvl1="0111" else
			Lvl1a_Empty8 when State = LVL_1A and queue_sel_lvl1="1000" else
			Lvl1a_Empty9 when State = LVL_1A and queue_sel_lvl1="1001" else
			Lvl1b_Empty0 when State = LVL_1B and queue_sel_lvl1="0000" else
			Lvl1b_Empty1 when State = LVL_1B and queue_sel_lvl1="0001" else
			Lvl1b_Empty2 when State = LVL_1B and queue_sel_lvl1="0010" else
			Lvl1b_Empty3 when State = LVL_1B and queue_sel_lvl1="0011" else
			Lvl1b_Empty4 when State = LVL_1B and queue_sel_lvl1="0100" else
			Lvl1b_Empty5 when State = LVL_1B and queue_sel_lvl1="0101" else
			Lvl1b_Empty6 when State = LVL_1B and queue_sel_lvl1="0110" else
			Lvl1b_Empty7 when State = LVL_1B and queue_sel_lvl1="0111" else
			Lvl1b_Empty8 when State = LVL_1B and queue_sel_lvl1="1000" else
			Lvl1b_Empty9 when State = LVL_1B and queue_sel_lvl1="1001" else
			Lvl2_Empty0 when State = LVL_2 and queue_sel_lvl2="0000" else
			Lvl2_Empty1 when State = LVL_2 and queue_sel_lvl2="0001" else
			Lvl2_Empty2 when State = LVL_2 and queue_sel_lvl2="0010" else
			Lvl2_Empty3 when State = LVL_2 and queue_sel_lvl2="0011" else
			Lvl2_Empty4 when State = LVL_2 and queue_sel_lvl2="0100" else
			Lvl2_Empty5 when State = LVL_2 and queue_sel_lvl2="0101" else
			Lvl2_Empty6 when State = LVL_2 and queue_sel_lvl2="0110" else
			Lvl2_Empty7 when State = LVL_2 and queue_sel_lvl2="0111" else
			Lvl2_Empty8 when State = LVL_2 and queue_sel_lvl2="1000" else
			Lvl2_Empty9 when State = LVL_2 and queue_sel_lvl2="1001";
			


--===========End Set Empty Signal=======--
--===========Set Write Signals===============--

Lvl0a_WriteEn0 <= '0' when RST='1' else
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000000000" else
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000001010" else
						'0';
Lvl0a_WriteEn1 <= '0' when RST='1' else
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000000001" else
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000001011" else
						'0';
Lvl0a_WriteEn2 <= '0' when RST='1' else
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000000010" else
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000001100" else
						'0';
Lvl0a_WriteEn3 <= '0' when RST='1' else
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000000011" else
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000001101" else
						'0';                                               
Lvl0a_WriteEn4 <= '0' when RST='1' else                                    
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000000100" else
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000001110" else
						'0';                                               
Lvl0a_WriteEn5 <= '0' when RST='1' else                                    
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000000101" else
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000001111" else
						'0';                                               
Lvl0a_WriteEn6 <= '0' when RST='1' else                                    
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000000110" else
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000010000" else
						'0';                                               
Lvl0a_WriteEn7 <= '0' when RST='1' else                                    
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000000111" else
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000010001" else
						'0';                                               
Lvl0a_WriteEn8 <= '0' when RST='1' else                                    
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000001000" else
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000010010" else
						'0';                                               
Lvl0a_WriteEn9 <= '0' when RST='1' else                                    
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000001001" else
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000010011" else
						'0';


						
Lvl0b_WriteEn0 <= '0' when RST='1' else
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000000000" else
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000001010" else
						'0';

Lvl0b_WriteEn1 <= '0' when RST='1' else
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000000001" else
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000001011" else
						'0';

Lvl0b_WriteEn2 <= '0' when RST='1' else
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000000010" else
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000001100" else
						'0';
Lvl0b_WriteEn3 <= '0' when RST='1' else
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000000011" else
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000001101" else
						'0';                                               
Lvl0b_WriteEn4 <= '0' when RST='1' else                                    
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000000100" else
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000001110" else
						'0';                                               
Lvl0b_WriteEn5 <= '0' when RST='1' else                                    
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000000101" else
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000001111" else
						'0';                                               
Lvl0b_WriteEn6 <= '0' when RST='1' else                                    
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000000110" else
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000010000" else
						'0';                                               
Lvl0b_WriteEn7 <= '0' when RST='1' else                                    
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000000111" else
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000010001" else
						'0';                                               
Lvl0b_WriteEn8 <= '0' when RST='1' else                                    
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000001000" else
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000010010" else
						'0';                                               
Lvl0b_WriteEn9 <= '0' when RST='1' else                                    
						'1' when WriteEn='1' and State = LVL_0B and VC_In="0000000000001001" else
						'1' when WriteEn='1' and State = LVL_0A and VC_In="0000000000010011" else
						'0';

--===========END Set Write Signals===============--


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
                                      

state_machine : process(CLK,RST,State,empty) 
begin
if rising_edge(CLK) then
    if(RST='1') then
        State <= LVL_0A;
    else
        case State is
				when LVL_0A => if empty='1' then 
										if state_sel_lvl1='0' then State<=LVL_1A;
										else State<=LVL_1B;
										end if;
									end if;
				when LVL_0B => if empty='1' then 
										if state_sel_lvl1='0' then State<=LVL_1A;
										else State<=LVL_1B;
										end if;
									end if;
				when LVL_1A => if empty='1' then State <= LVL_2;
									end if;
				when LVL_1B => if empty='1' then State <= LVL_2;
									end if;
				when LVL_2 => if empty='1' then 
										if state_sel_lvl0='0' then State<=LVL_0A;
										else State<=LVL_0B;
										end if;
										VC <= std_logic_vector( unsigned(VC) + 1);
										if(counter_to_ten="1001") then
											counter_to_ten <= "0000";
											tens <= tens + 10;
											if(tens_counter="1001") then
												tens_counter <= "0000";
											else
												tens_counter <= std_logic_vector( unsigned(tens_counter) + 1);
											end if;
										else
											counter_to_ten <= std_logic_vector( unsigned(counter_to_ten) + 1);
										end if;
										if(counter_to_hundred="1100011") then
											counter_to_hundred <= "0000000";
											hundreds <= hundreds + 100;
											if(hundreds_counter="1001") then
												hundreds_counter <= "0000";
											else
												hundreds_counter <= std_logic_vector( unsigned(hundreds_counter) + 1);
											end if;
										else
											counter_to_hundred <= std_logic_vector( unsigned(counter_to_hundred) + 1);
										end if;
										if(counter_to_thousand="1111100111") then
											counter_to_thousand <= "0000000000";
											thousands <= thousands + 1000;
										else
											counter_to_thousand <= std_logic_vector( unsigned(counter_to_thousand) + 1);
										end if;
										if(twenties_counter=20) then 
											every_twenty <= every_twenty + 20;
											twenties_counter <= 0;
										else
											twenties_counter <=twenties_counter + 1;
										end if;
										if(two_hundreds_counter=20) then 
											every_two_hundred <= every_two_hundred + 200;
											two_hundreds_counter <= 0;
										else
											two_hundreds_counter <= two_hundreds_counter + 1;
										end if;
									end if;
        end case;
      end if;
end if;
end process;

end Behavioral;
