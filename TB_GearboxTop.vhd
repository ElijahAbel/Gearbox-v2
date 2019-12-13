LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_GearboxTop IS
    constant DATA_WIDTH : positive := 48;
    constant INPUT_WIDTH : positive := 48;
END TB_GearboxTop;

ARCHITECTURE behavior OF TB_GearboxTop IS 
	
	-- Component Declaration for the Unit Under Test (UUT)
	component GearboxTop
        port ( 
            CLK       : in STD_LOGIC;
            RST       : in STD_LOGIC;
            PacketOut  : out STD_LOGIC_VECTOR(INPUT_WIDTH - 1 DOWNTO 0)
        );
	end component;
	
	--Inputs
	signal CLK		: std_logic := '0';
	signal RST		: std_logic := '0';
	
	--Outputs
	signal PacketOut	: std_logic_vector(INPUT_WIDTH - 1 downto 0);
	
	
	-- Clock period definitions
	constant CLK_period : time := 10 ns;
	
	--Additional signals
	

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: GearboxTop
		PORT MAP (
			CLK		   => CLK,
			RST		   => RST,
			PacketOut	=> PacketOut
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
	wait for CLK_period / 2;
		
		RST <= '1';
		
		wait for CLK_period * 5;
		
		RST <= '0';
		
		wait;
	end process;


END;