LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_FIFO IS
    constant DATA_WIDTH : positive := 64;
    constant INPUT_WIDTH : positive := 68;
END TB_FIFO;

ARCHITECTURE behavior OF TB_FIFO IS 
	
	-- Component Declaration for the Unit Under Test (UUT)
	component FIFO
		Generic (
			constant DATA_WIDTH  : positive := 64;
			constant FIFO_DEPTH	: positive := 256
		);
		port (
			CLK		: in std_logic;
			RST		: in std_logic;
			PacketIn	: in std_logic_vector(DATA_WIDTH - 1 downto 0);
			WriteEn	: in std_logic;
			ReadEn	: in std_logic;
			DataOut	: out std_logic_vector(DATA_WIDTH - 1 downto 0);
			Full	: out std_logic;
			Empty	: out std_logic
		);
	end component;
	
	--Inputs
	signal CLK		: std_logic := '0';
	signal RST		: std_logic := '0';
	signal PacketIn	: std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
	signal ReadEn	: std_logic := '0';
	signal WriteEn	: std_logic := '0';
	
	--Outputs
	signal DataOut	: std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal Empty	: std_logic;
	signal Full		: std_logic;
	
	-- Clock period definitions
	constant CLK_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: FIFO
		PORT MAP (
			CLK		=> CLK,
			RST		=> RST,
			PacketIn	=> PacketIn,
			WriteEn	=> WriteEn,
			ReadEn	=> ReadEn,
			DataOut	=> DataOut,
			Full	=> Full,
			Empty	=> Empty
		);
	
	-- Clock process definitions
	CLK_process :process
	begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;
	
	-- Reset process
	rst_proc : process
	begin
	wait for CLK_period * 5;
		
		RST <= '1';
		
		wait for CLK_period * 5;
		
		RST <= '0';
		
		wait;
	end process;
	
	-- Write process
	wr_proc : process
		variable counter : unsigned (DATA_WIDTH - 1 downto 0) := (others => '0');
	begin		
		wait for CLK_period * 20;

		for i in 1 to 32 loop
			counter := counter + 1;
			
			PacketIn <= std_logic_vector(counter);
			
			wait for CLK_period * 1;
			
			WriteEn <= '1';
			
			--wait for CLK_period * 1;
		
			--WriteEn <= '0';
		end loop;
		
		wait for clk_period * 20;
		
		for i in 1 to 32 loop
			counter := counter + 1;
			
			PacketIn <= std_logic_vector(counter);
			
			wait for CLK_period * 1;
			
			WriteEn <= '1';
			
			wait for CLK_period * 1;
			
			WriteEn <= '0';
		end loop;
		
		wait;
	end process;
	
	-- Read process
	rd_proc : process
	begin
		wait for CLK_period * 20;
		
		wait for CLK_period * 40;
			
		ReadEn <= '1';
		
		wait for CLK_period * 60;
		
		ReadEn <= '0';
		
		wait for CLK_period * 256 * 2;
		
		ReadEn <= '1';
		
		wait;
	end process;

END;