LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity dincenwenjian is
port	(
	clk0 : in std_logic;--输入时钟频率
	CLEAR:IN STD_LOGIC;--分频器置零
	switch7 : in std_LOGIC;--开关sw7
	bt7 : in std_logic;--按键btn7
	bt5,bt4,bt3,bt2,bt1,bt0:in std_logic;--按键btn5-btn0
	hang : out std_logic_vector(7 downto 0);--对应点阵行
	cat : out std_logic_vector(4 downto 0);--对应数码管控制器
	guan : out std_LOGIC_vector(6 downto 0);--对应数码管管脚
	lie : out std_logic_vector(7 downto 0));--对应点阵列
end dincenwenjian;
Architecture behave of dincenwenjian is

component fenpin1
port(
 clk : in std_logic;
 CLEAR:IN STD_LOGIC;
 clkout1 : out std_logic;--0.05s
 clkout2 : out std_logic;--0.08s
 clkout3 : out std_logic;--0.1s
 clkout4 : out std_logic;--0.2s
 clkout5 : out std_logic;--0.3s
 clkout6 : out std_logic);--0.5s;
end component;

component jianpanfangdou
port(clk:in std_logic;--50hz
			btn7,btn5,btn4,btn3,btn2,btn1,btn0:in std_logic;
			o7,o5,o4,o3,o2,o1,o0:out std_logic);
end component;

component kongzhiqi
port(clk,clk1,clk2,clk3,clk4,clk5,clk6 : IN STD_LOGIC;
			sw7 : in std_LOGIC;--开关sw7
			btn7 : in std_logic;
			btn : in std_logic_vector(5 downto 0);
			scan_dz: out std_logic_vector(2 downto 0);
			latch : out std_logic_vector(4 downto 0)--数字锁存
			);
end component;

component lattice
port(clk : IN STD_LOGIC;
			--d_mode : in std_logic
			d_scan : in std_logic_vector(2 downto 0);
			d_hang : out std_logic_vector(7 downto 0);
			d_lie : out std_logic_vector(7 downto 0)
			);
end component;

component shumaguan
port(clk,clk1,clk2,clk3,clk4,clk5 : IN STD_LOGIC;
			scan_number : in std_logic_vector(4 downto 0);
			d_cat : out std_logic_vector(4 downto 0);
			d_guan : out std_LOGIC_vector(6 downto 0) 
			);
end component;
signal clk_a:std_LOGIC;--0.05s
signal clk_b:std_LOGIC;--0.08s
signal clk_c:std_LOGIC;--0.1s
signal clk_d:std_LOGIC;--0.2s
signal clk_e:std_LOGIC;--0.3s
signal clk_f:std_LOGIC;--0.5s
signal b7:std_LOGIC;--btn7
signal bn:std_LOGIC_vector(5 downto 0);--btn5-btn0
signal scan:std_LOGIC_vector(2 downto 0);--显示字母
signal s_number:std_LOGIC_vector(4 downto 0);--数码管扫描
begin
U1:fenpin1 port map(clk0,CLEAR,clk_a,clk_b,clk_c,clk_d,clk_e,clk_f);
U2:kongzhiqi port map(clk0,clk_a,clk_b,clk_c,clk_d,clk_e,clk_f,switch7,b7,bn,scan,s_number);
U3:lattice port map(clk_f,scan,hang,lie);
U4:shumaguan port map(clk0,clk_a,clk_b,clk_c,clk_d,clk_e,s_number,cat,guan);
U5:jianpanfangdou port map(clk0,bt7,bt5,bt4,bt3,bt2,bt1,bt0,b7,bn(5),bn(4),bn(3),bn(2),bn(1),bn(0));
end architecture behave;