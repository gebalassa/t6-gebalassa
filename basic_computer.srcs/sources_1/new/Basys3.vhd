library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity Basys3 is
    Port (
        sw          : in   std_logic_vector (15 downto 0); -- Señales de entrada de los interruptores -- Arriba   = '1'   -- Los 3 swiches de la derecha: 2, 1 y 0.
        btn         : in   std_logic_vector (4 downto 0);  -- Señales de entrada de los botones       -- Apretado = '1'   -- 0 central, 1 arriba, 2 izquierda, 3 derecha y 4 abajo.
        led         : out  std_logic_vector (3 downto 0);  -- Señales de salida  a  los leds          -- Prendido = '1'   -- Los 4 leds de la derecha: 3, 2, 1 y 0.
        clk         : in   std_logic;                      -- No Tocar - Señal de entrada del clock   -- Frecuencia = 100Mhz.
        seg         : out  std_logic_vector (7 downto 0);  -- No Tocar - Salida de las señales de segmentos.
        an          : out  std_logic_vector (3 downto 0)   -- No Tocar - Salida del selector de diplay.
          );
end Basys3;

architecture Behavioral of Basys3 is

-- Inicio de la declaración de los componentes.

component Clock_Divider -- No Tocar
    Port (
        clk         : in    std_logic;
        speed       : in    std_logic_vector (1 downto 0);
        clock       : out   std_logic
          );
    end component;
    
component Display_Controller  -- No Tocar
    Port (  
        dis_a       : in    std_logic_vector (3 downto 0);
        dis_b       : in    std_logic_vector (3 downto 0);
        dis_c       : in    std_logic_vector (3 downto 0);
        dis_d       : in    std_logic_vector (3 downto 0);
        clk         : in    std_logic;
        seg         : out   std_logic_vector (7 downto 0);
        an          : out   std_logic_vector (3 downto 0)
          );
    end component;

component Debouncer
    Port (
        clk         : in    std_logic;
        datain      : in    std_logic_vector (4 downto 0);
        dataout     : out   std_logic_vector (4 downto 0));
    end component;
    
component Reg
    Port (
        clock       : in    std_logic;
        load        : in    std_logic;
        up          : in    std_logic;
        down        : in    std_logic;
        datain      : in    std_logic_vector (15 downto 0);
        dataout     : out   std_logic_vector (15 downto 0)
          );
    end component;

component ALU
    Port ( 
        a           : in    std_logic_vector (15 downto 0);
        b           : in    std_logic_vector (15 downto 0);
        sop         : in    std_logic_vector (2 downto 0);
        c           : out   std_logic;
        z           : out   std_logic;
        n           : out   std_logic;
        result      : out   std_logic_vector (15 downto 0)
          );
    end component;

component PC 
    Port (  
        clock       : in    std_logic;
        load        : in    std_logic;
        datain      : in    std_logic_vector (11 downto 0);
        dataout     : out   std_logic_vector (11 downto 0)
          );
    end component;

component ROM
    Port (  
        address     : in    std_logic_vector (11 downto 0);
        dataout     : out   std_logic_vector (32 downto 0)
          );
    end component;

component RAM
    Port (  
        clock       : in    std_logic;
        write       : in    std_logic;
        address     : in    std_logic_vector (11 downto 0);
        datain      : in    std_logic_vector (15 downto 0);
        dataout     : out   std_logic_vector (15 downto 0)
          );
    end component;

component CU 
    Port (  
        op          : in    std_logic_vector (16 downto 0);
        status      : in    std_logic_vector (2 downto 0);
        mux_a       : out   std_logic_vector (1 downto 0);
        mux_b       : out   std_logic_vector (1 downto 0);
        load_a      : out   std_logic;
        load_b      : out   std_logic;
        write_ram   : out   std_logic;
        load_out    : out   std_logic;
        mux_datain  : out   std_logic;
        mux_address : out   std_logic_vector (1 downto 0);
        mux_pc      : out   std_logic;
        alu_sop     : out   std_logic_vector (2 downto 0);
        load_pc     : out   std_logic;
        sp_up       : out   std_logic;
        sp_down     : out   std_logic
          );
    end component;

component Status
    Port (  
        clock       : in    std_logic;
        c           : in    std_logic;
        z           : in    std_logic;
        n           : in    std_logic;
        dataout     : out   std_logic_vector (2 downto 0)
          );
    end component;

component SP 
    Port (
        clock       : in    std_logic;
        up          : in    std_logic;
        down        : in    std_logic;
        dataout     : out   std_logic_vector (11 downto 0)
          );
    end component;

-- Fin de la declaración de los componentes.

-- Inicio de la declaración de señales.

signal clock            : std_logic;                     -- Señal del clock reducido.                 
            
signal dis_a            : std_logic_vector(3 downto 0);  -- Señales de salida al display A.    
signal dis_b            : std_logic_vector(3 downto 0);  -- Señales de salida al display B.     
signal dis_c            : std_logic_vector(3 downto 0);  -- Señales de salida al display C.    
signal dis_d            : std_logic_vector(3 downto 0);  -- Señales de salida al display D.  

signal d_btn            : std_logic_vector(4 downto 0);

signal load_a           : std_logic;
signal load_b           : std_logic;
signal reg_a            : std_logic_vector(15 downto 0);
signal reg_b            : std_logic_vector(15 downto 0);

signal mux_select_a     : std_logic_vector(1 downto 0);
signal mux_select_b     : std_logic_vector(1 downto 0);
signal mux_a            : std_logic_vector(15 downto 0);
signal mux_b            : std_logic_vector(15 downto 0);

signal alu_sop          : std_logic_vector(2 downto 0);
signal alu_result       : std_logic_vector(15 downto 0);
signal alu_c            : std_logic;
signal alu_z            : std_logic;
signal alu_n            : std_logic;

signal load_pc          : std_logic;
signal mux_pc           : std_logic;
signal pc_datain        : std_logic_vector(11 downto 0);
signal rom_address      : std_logic_vector(11 downto 0);
signal word             : std_logic_vector(32 downto 0);

signal mux_ram_address  : std_logic_vector(1 downto 0);
signal mux_ram_datain   : std_logic;
signal ram_address      : std_logic_vector(11 downto 0);
signal write_ram        : std_logic;
signal ram_datain       : std_logic_vector(15 downto 0);
signal ram_dataout      : std_logic_vector(15 downto 0);

signal status_dataout   : std_logic_vector(2 downto 0);

signal sp_up            : std_logic;
signal sp_down          : std_logic;
signal sp_dataout       : std_logic_vector(11 downto 0);

signal input            : std_logic_vector(15 downto 0);

-- Fin de la declaración de los señales.

begin

-- Inicio de declaración de comportamientos.

led(0) <= clock;
led(1) <= alu_c;
led(2) <= alu_z;
led(3) <= alu_n;

dis_a  <= reg_a(7 downto 4);
dis_b  <= reg_a(3 downto 0);
dis_c  <= reg_b(7 downto 4);
dis_d  <= reg_b(3 downto 0);

with word(32 downto 17) select
    input <=    sw  when "0000000000000000",
                "00000000000" & d_btn when "0000000000000001",
                (others => '0') when others;

with mux_pc select
    pc_datain <= word(28 downto 17) when '0',
                ram_dataout(11 downto 0) when '1';
                            
with mux_ram_address select
    ram_address <= word(28 downto 17) when "00",
                reg_b(11 downto 0) when "01",
                (others => '0') when "10",
                sp_dataout when "11";

with mux_ram_datain select
    ram_datain <=  alu_result when '0',
                std_logic_vector(resize(unsigned(rom_address + 1), 16)) when '1';

with mux_select_a select
    mux_a <=    reg_a when "00",
                input    when "01",
                std_logic_vector(to_unsigned(1,16)) when "10",
                (others => '0') when others ;

with mux_select_b select
    mux_b <=    reg_b when "00",
                word(32 downto 17) when "01",
                ram_dataout when "10",
                (others => '0') when "11" ;

-- Inicio de declaración de instancias.

inst_Clock_Divider: Clock_Divider port map( -- No Tocar - Intancia de Clock_Divider.
    clk         => clk,  -- No Tocar - Entrada del clock completo (100Mhz).
    speed       => "01", -- Selector de velocidad: "00" full, "01" fast, "10" normal y "11" slow. 
    clock       => clock -- No Tocar - Salida del clock reducido: 25Mhz, 8hz, 2hz y 0.5hz.
    );

inst_Display_Controller: Display_Controller port map( -- No Tocar - Intancia de Led_Driver.
    dis_a       => dis_a,-- No Tocar - Entrada de señales para el display A.
    dis_b       => dis_b,-- No Tocar - Entrada de señales para el display B.
    dis_c       => dis_c,-- No Tocar - Entrada de señales para el display C.
    dis_d       => dis_d,-- No Tocar - Entrada de señales para el display D.
    clk         => clk,  -- No Tocar - Entrada del clock completo (100Mhz).
    seg         => seg,  -- No Tocar - Salida de las señales de segmentos.
    an          => an    -- No Tocar - Salida del selector de diplay.
	);

inst_Debouncer: Debouncer port map(
    clk         => clk,
    datain      => btn,
    dataout     => d_btn
    );

inst_Reg_A: Reg port map(
    clock       => clock,
    load        => load_a,
    up          => '0',
    down        => '0',
    datain      => alu_result,
    dataout     => reg_a
    );

inst_Reg_B: Reg port map(
    clock       => clock,
    load        => load_b,
    up          => '0',
    down        => '0',
    datain      => alu_result,
    dataout     => reg_b
    );   

inst_ALU: ALU port map(
    a           => mux_a,
    b           => mux_b,
    sop         => alu_sop,
    c           => alu_c,
    n           => alu_n,
    z           => alu_z,
    result      => alu_result
    );
    
inst_PC: PC port map(
    clock       => clock,
    load        => load_pc,
    datain      => pc_datain,
    dataout     => rom_address
    );

inst_ROM: ROM port map(
    address     => rom_address,
    dataout     => word
    );

inst_RAM: RAM port map(
    clock       => clock,
    write       => write_ram,
    address     => ram_address,
    datain      => ram_datain,
    dataout     => ram_dataout
    );

inst_CU: CU port map(
    op          => word(16 downto 0),
    status      => status_dataout,
    mux_a       => mux_select_a,
    mux_b       => mux_select_b,
    load_a      => load_a,
    load_b      => load_b,
    write_ram   => write_ram,
    mux_datain  => mux_ram_datain,
    mux_address => mux_ram_address,
    mux_pc      => mux_pc,
    alu_sop     => alu_sop,            
    load_pc     => load_pc,
    sp_up       => sp_up,
    sp_down     => sp_down
    );

inst_Status: Status port map(
    clock       => clock,
    c           => alu_c,
    z           => alu_z,
    n           => alu_n,
    dataout     => status_dataout
    );

inst_SP: SP port map(
    clock       => clock,
    up          => sp_up,
    down        => sp_down,
    dataout     => sp_dataout
    );   
	
-- Fin de declaración de instancias.

-- Fin de declaración de comportamientos.
  
end Behavioral;
