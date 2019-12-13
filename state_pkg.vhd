library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

PACKAGE state_pkg IS
    TYPE GBStateType is (INIT,
					LVL_0A,
					LVL_0B,
					LVL_1A,
					LVL_1B,
					LVL_2);
END state_pkg;
