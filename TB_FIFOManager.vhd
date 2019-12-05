LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_FIFOManager IS
    constant DATA_WIDTH : positive := 64;
    constant INPUT_WIDTH : positive := 68;
END TB_FIFOManager;

ARCHITECTURE behavior OF TB_FIFOManager IS 
	
	-- Component Declaration for the Unit Under Test (UUT)
	component FIFOManager
		generic(
            constant DATA_WIDTH : positive := 64; --64 bit address
            constant INPUT_WIDTH : positive := 68 --4 bit VCC value + 64 bit address
        );
        port ( 
            CLK       : in STD_LOGIC;
            RST       : in STD_LOGIC;
            ReadEn      : in STD_LOGIC;
            WriteEn     : in STD_LOGIC;
            PacketIn  : in STD_LOGIC_VECTOR(INPUT_WIDTH - 1 DOWNTO 0);
            PacketOut : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
        );
	end component;
	
	--Inputs
	signal CLK		: std_logic := '0';
	signal RST		: std_logic := '0';
	signal PacketIn	: std_logic_vector(INPUT_WIDTH - 1 downto 0) := (others => '0');
	signal ReadEn	: std_logic := '0';
	signal WriteEn	: std_logic := '0';
	
	--Outputs
	signal PacketOut	: std_logic_vector(DATA_WIDTH - 1 downto 0);
	
	-- Clock period definitions
	constant CLK_period : time := 10 ns;
	
	--Additional signals
	signal VCC_Val : std_logic_vector(INPUT_WIDTH-DATA_WIDTH-1 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: FIFOManager
		PORT MAP (
			CLK		   => CLK,
			RST		   => RST,
			PacketIn	=> PacketIn,
			WriteEn  	=> WriteEn,
			ReadEn      => ReadEn,
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
		
		RST <= '1';
		
		wait for CLK_period * 5;
		
		RST <= '0';
		
		wait;
	end process;
	
	-- Write process
	wr_proc : process
		variable counter : unsigned (DATA_WIDTH - 1 downto 0) := (others => '0');
		variable vcc : unsigned (3 DOWNTO 0) := (others => '0');
	begin	




		--========Reading next cycle after the write=========--
		VCC_Val <= "0000";
        wait for CLK_period * 20;
        --wait for CLK_period/2;
        
        
        for i in 1 to 32 loop
        counter := counter + 1;
            
            PacketIn <=  VCC_Val(3 DOWNTO 0) & std_logic_vector(counter);
            WriteEn <= '1';
            
            wait for CLK_period * 1;
        end loop;
        
        WriteEn <= '0';
        
		--======== End Reading next cycle after the write=========--	
		
	   --========Testing writing to full FIFO=========--
--		VCC_Val <= "0000";
--        wait for CLK_period * 20;
--        --wait for CLK_period/2;
        
        
--        for i in 1 to 257 loop
--        counter := counter + 1;
            
--            PacketIn <=  VCC_Val(3 DOWNTO 0) & std_logic_vector(counter);
--            WriteEn <= '1';
            
--            wait for CLK_period * 1;
--        end loop;
        
--        WriteEn <= '0';
        
        --========End Testing writing to full FIFO=========--
        
        --========Testing writing/reading from looped FIFO=========--
--        VCC_Val <= "0000";
--        wait for CLK_period * 20;
--        --wait for CLK_period/2;
        
        
--        for i in 1 to 500 loop
--        counter := counter + 1;
            
--            PacketIn <=  VCC_Val(3 DOWNTO 0) & std_logic_vector(counter);
--            WriteEn <= '1';
            
--            wait for CLK_period * 1;
--        end loop;
        
--        WriteEn <= '0';
        
        --========End Testing writing/reading from looped FIFO=========--
        
         --========Testing State transitions, and writing to queues from other states=========--
--         VCC_Val<="1001";
--         wait for CLK_period * 20;
--         --wait for CLK_period/2; 
--         
--         PacketIn <= VCC_Val(3 DOWNTO 0) & std_logic_vector(counter);
--         WriteEn <= '1';
--         
--         wait for CLK_period * 1;
--         
--         WriteEn <= '0'; 
--         
--         wait for CLK_period * 1;
--         --Now in state HEAD_QUEUE_1
--        
--        for i in 1 to 32 loop
--         counter := counter + 1;
--         for k in 0 to 9 loop
--             
--             VCC_Val <= std_logic_vector(unsigned(vcc) + k);
--             
--             --PacketIn <=  VCC_Val(3 DOWNTO 0) & std_logic_vector(counter);
--             PacketIn <=  std_logic_vector(unsigned(vcc) + k) & std_logic_vector(counter);
--             WriteEn <= '1';
--             
--             wait for CLK_period * 1;
--         end loop;
--             vcc := (others => '0');
--         end loop;
--         
--         
--         WriteEn <= '0';

        
        
        
        --========End Testing State transitions, and writing to queues from other states=========--
		
		--========Testing cyclical writing to all 10 FIFOs=========--
--		VCC_Val <= "0000";
--		wait for CLK_period * 20;
--		--wait for CLK_period/2;
		
		
--		for i in 1 to 32 loop
--		counter := counter + 1;
--		for k in 0 to 9 loop
			
--			VCC_Val <= std_logic_vector(unsigned(vcc) + k);
			
--			--PacketIn <=  VCC_Val(3 DOWNTO 0) & std_logic_vector(counter);
--			PacketIn <=  std_logic_vector(unsigned(vcc) + k) & std_logic_vector(counter);
--			WriteEn <= '1';
			
--			wait for CLK_period * 1;
--		end loop;
--		    vcc := (others => '0');
--		end loop;
		
--		WriteEn <= '0';
		
		--========End Testing cyclical writing to all 10 FIFOs=========--
		
		wait;
	end process;
	
	-- Read process
	rd_proc : process
	begin
		wait for CLK_period * 20;
		--wait for CLK_period/2;
		
		--========Reading next cycle after the write=========--
		ReadEn <= '1';
		
		wait for CLK_period * 32;
		
		ReadEn <= '0';
		--======== End Reading next cycle after the write=========--
		
		 --========Testing writing/reading from looped FIFO=========--
--		 wait for CLK_period * 270;
		 
--		 ReadEn <= '1';
		 
--		 wait for CLK_period * 100;
		 
--		 ReadEn <='0';
		 
		 
		  --========End Testing writing/reading from looped FIFO=========--
		  
		  --========Testing State transitions, and writing to queues from other states=========--
--		  wait for CLK_period * 1;
--		  ReadEn <= '1';
--		  
--		  wait for CLK_period * 2;
--		  
--		  ReadEn <= '0';
--		  
--		  wait for CLK_period * 400;
--		  
--		  ReadEn <= '1'; 
--		  
--		  wait for CLK_period * 400;
--		  
--		  ReadEn <= '0';
		  
		  --========End Testing State transitions, and writing to queues from other states=========--
		
--		wait for CLK_period * 320;
			
--		ReadEn <= '1';
		
--		wait for CLK_period * 350;
		
--		ReadEn <= '0';
		
--		wait for CLK_period * 256 * 2;
		
--		ReadEn <= '1';
		
		wait;
	end process;

END;