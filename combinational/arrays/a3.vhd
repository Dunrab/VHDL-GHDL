entity a3 is
end;

architecture a of a3 is
  signal x : bit_vector(1 downto 0);
  type arr is array (0 to 1) of bit_vector(1 downto 0);
  type arr2 is array (0 to 1) of arr;
  type arr22 is array (0 to 1, 0 to 1) of bit_vector (1 downto 0);
  type arr3 is array (0 to 1) of arr22;
  --constant xx : arr := (('1','1'),('1','0'));
  constant xx : arr := ("11","10");
  constant xx2 : arr2 := (("00","01"),("10","11"));
  constant xxx : arr22 := (("00","01"),("10","11"));
  signal xxxx : arr3;
  begin
    xxxx <= (xxx,xxx);
    process
      variable i : integer;
      begin
        x <= xx2(1)(0);
        wait for 10 ns;
        x <= xxx(1,0);
        wait for 10 ns;
        x <= xxxx(0)(1,0);
        wait for 10 ns;
      end process;
  end;
