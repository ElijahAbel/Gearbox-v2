library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity FIFO is
	Generic (
		constant DATA_WIDTH  : positive := 48;--64 bits for mem address of packet
		constant FIFO_DEPTH	: positive := 256 --holding 256 packets per queue
	);
	Port ( 
		CLK		: in  STD_LOGIC;
		RST		: in  STD_LOGIC;
		WriteEn	: in  STD_LOGIC;
		PacketIn	: in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		ReadEn	: in  STD_LOGIC;
		DataOut	: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		Empty	: out STD_LOGIC
		--NextEmpty : out STD_LOGIC;
		--Full	: out STD_LOGIC
	);
end FIFO;

architecture Behavioral of FIFO is
        type FIFO_Memory is array (0 to FIFO_DEPTH - 1) of STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		signal Memory : FIFO_Memory;
	    signal Head : natural range 0 to FIFO_DEPTH - 1;
		signal Tail : natural range 0 to FIFO_DEPTH - 1;
		signal Looped : boolean;
		signal Full : std_logic := '0';
		--signal prevVal : std_logic_vector (DATA_WIDTH - 1 downto 0);
begin

    DataOut <= Memory(Tail);
    --Memory(Head) <= (others => '0') when RST='1' else
    --             prevVal(DATA_WIDTH - 1 downto 0) when Head=Tail and Looped=True else --we refuse to write if full
    --             PacketIn(DATA_WIDTH - 1 downto 0) when WriteEn='1' else
    --             prevVal(DATA_WIDTH - 1 downto 0);
    
    
--    store_prev_val : process (CLK)
--    begin
--        if rising_edge(CLK) then 
--            if(Head=FIFO_DEPTH-1) then
--                prevVal <= Memory(0);
--            else
--                prevVal <= Memory(Head);
--            end if;
--        end if;
--    end process;

	-- Memory Pointer Process
	fifo_proc : process (CLK,WriteEn,ReadEn)
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				Head <= 0;
				Tail <= 0;
				
				Looped <= false;
				
				--Full  <= '0';
				--NextEmpty <= '0';
				Empty <= '1';
			else
				if (ReadEn = '1') then
					if ((Looped = true) or (Head /= Tail)) then --logical equivalent of not empty
						-- Update data output
						--DataOut <= Memory(Tail);
						
						-- Update Tail pointer as needed
						if (Tail = FIFO_DEPTH - 1) then
							Tail <= 0;
							
							Looped <= false;
						else
							Tail <= Tail + 1;
						end if;
						
						
					end if;
				end if;
				
				if (WriteEn = '1') then
					if ((Looped = false) or (Head /= Tail)) then --logical equivalent of not full
						-- Write Data to Memory
						Memory(Head) <= PacketIn;
						
						-- Increment Head pointer as needed
						if (Head = FIFO_DEPTH - 1) then
							Head <= 0;
							
							Looped  <= true;
						else
							Head <= Head + 1;
						end if;
					end if;
				end if;
				
				-- Update Empty and Full output flags
--				if (Head = Tail) then
--					if Looped then
--						Full <= '1';
--					else
--						Empty <= '1';
--					end if;
			    if((Head = Tail and Looped=false) or (Head=(Tail+1) and ReadEn='1' and WriteEn='0') or (Head=0 and Tail=FIFO_DEPTH-1 and ReadEn='1' and WriteEn='0')) then 
			       Empty<= '1';
			       --Full <= '0';
				else
					Empty	<= '0';
					--Full	<= '0';
				end if;
				
				--if((Head=(Tail+1) and ReadEn='1' and WriteEn='0') or (Head=0 and Tail=FIFO_DEPTH-1 and ReadEn='1' and WriteEn='0')) then 
                    --NextEmpty<= '1';
                    --Full <= '0';
                --end if;
			end if;
		end if;
	end process;
		
end Behavioral;