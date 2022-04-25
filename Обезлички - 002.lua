Run = true;		-- ���� ����������� ������ �������
 
TradeNums = {};	-- ������ ��� �������� ������� ���������� � ���� ������ (��� �������������� ������������)
 FILE_TEMP = getScriptPath().."/MyTrades11.dat"  -- "C:\\SBERBANK\\QUIK_x64\\Lua\\MyTrades.dat"
-- ���������� ���������� QUIK � ������ ������� �������
function OnInit()
	if table.load(FILE_TEMP) ~= nil then	TradeNums = table.load(FILE_TEMP) end
	-- �������, ��� ��������� ��� ������/���������� ���� CSV � ��� �� �����, ��� ��������� ������ ������
	CSV = io.open(getScriptPath().."/MyTrades11.csv", "a+");
	-- ������ � ����� �����, �������� ����� �������
	local Position = CSV:seek("end",0);
	-- ���� ���� ��� ������
	if Position == 0 then
		-- ������� ������ � ����������� ��������
		local Header = "���� � �����;��� ������;��� ������;��� �����;order_num;��������;����;����������\n"
		-- ��������� ������ ���������� � ����
		CSV:write(Header);
		-- ��������� ��������� � �����
		CSV:flush();
	end;	
	--OnAllTradeMy()
end; 
 
-- �������� ������� ������� (���� �������� ���, �������� ������)
CLASS_CODE  = "SPBFUT"      -- ��� ������
SEC_CODE  	= "SiM2"     -- ��� �����������
 
 
-- ���������� ���������� QUIK � ������ ��������� �������
function OnStop()
	--table.save(TradeNums,FILE_TEMP)  -- �����	
	-- ��������� ����, ����� ���������� ���� while ������ main
	Run = false;
	-- ��������� �������� CSV-���� 
	CSV:close();	
	is_run = false  
end;

function main() 
	if Subscribe_Level_II_Quotes(CLASS_CODE, SEC_CODE)==true then		
					while Run do sleep(100)
						--quik_price_tick_1 = CreateDataSource(CLASS_CODE, SEC_CODE, INTERVAL_TICK)
						--quik_price_tick_4 = CreateDataSource(CLASS_CODE, SEC_CODE_4, INTERVAL_TICK)
						MainLoop()
						--message("������")
					end 				
	else is_run = false end	
end

function MainLoop()  -- ������� ����������� ��� ������ �������� ����� while � ������� main	
		
		
		
		
		
end
 
-- ������� ���������� ���������� QUIK ��� ���������� ���� ����� ������
-- (������ ���������� �� 2 ���� ��� ������ ������)
function OnAllTrade(alltrade)
	-- ���������� ������ � �������� ���������� ������ (� �������� �������)
			
	for i=#TradeNums,1,-1 do
		-- ���� ������ ������ ��� ���� ��������, ������� �� �������
		if (TradeNums[i] == alltrade.trade_num) or (alltrade.qty < 301) then return; end;
	end;
 
	-- ���� �� �����, ������ ������ �� ���� ������� � ����� ��� ����������
	-- ��������� � ������ ����� ����� ������
	TradeNums[#TradeNums + 1] = alltrade.trade_num;
	-- ��������� �������� ������
	local Operation = "";
	if CheckBit(alltrade.flags, 2) == 1 then Operation = "SELL"; else Operation = "BUY"; end;
	-- ������� ������ ������ ��� ������ � ���� ("���� � �����;��� ������;��� ������;��������;����;����������\n")
	local TradeLine = 	os.date("%d.%m.%Y | %X", os.time(alltrade.datetime))..";"..
						alltrade.class_code..";"..
						alltrade.sec_code..";"..
						--alltrade.account..";"..
						alltrade.trade_num..";"..
						Operation..";"..
						--trade.price..";"..
						string.gsub(alltrade.price, "%.", ",")..";"..
						string.gsub(alltrade.qty, "%.", ",").."\n";	
	
	-- ���������� ������ � ����
	CSV:write(TradeLine);
	-- ��������� ��������� � �����
	CSV:flush();
end;

function OnAllTradeMy()
	-- ���������� ������ � �������� ���������� ������ (� �������� �������)
	for i = 0, getNumberOf("all_trades") - 1 do
	local item = getItem("all_trades", i)
	
	sleep(1000)
	--if then message(item.sec_code)  -- ���� ����
	message(item.sec_code)
	
	if (item.qty > 100) and (item.sec_code == SEC_CODE)  then -- ���� �� ����, �� ����� ������
		for i=#TradeNums,1,-1 do
			-- ���� ������ ������ ��� ���� ��������, ������� �� �������
			--if TradeNums[i] == item.trade_num then return; end;
			if (TradeNums[i] == item.trade_num) then return; end;
		end
		
		-- ���� �� �����, ������ ������ �� ���� ������� � ����� ��� ����������
		-- ��������� � ������ ����� ����� ������
		TradeNums[#TradeNums + 1] = item.trade_num;
		-- ��������� �������� ������
		local Operation = "";
		if CheckBit(item.flags, 2) == 1 then Operation = "SELL"; else Operation = "BUY"; end;
		
				
	message(item.sec_code)
	
	
	-- ������� ������ ������ ��� ������ � ���� ("���� � �����;��� ������;��� ������;����� ������;����� ������;��������;����;����������\n")
		local TradeLine = 	os.date("%d.%m.%Y | %X", os.time(item.datetime))..";"..
							item.class_code..";"..
							item.sec_code..";"..
							item.open_interest..";"..
							item.trade_num..";"..
							Operation..";"..
							--item.price..";"..
							string.gsub(item.price, "%.", ",")..";"..
							string.gsub(item.qty, "%.", ",").."\n";	
		--message("11"..tostring(TradeNums))
		
		-- ���������� ������ � ����
	
	
		--CSV:write(TradeLine);
		--message(tostring(item.sec_code))
		--message(tostring(item.SEC_CODE))
		--message('-')
		-- ��������� ��������� � �����
		--table.save(TradeNums,FILE_TEMP)  -- �����	
		--CSV:flush();	
		--message(item.sec_code) return end
		end 
		
	end	
	end
  
-- ������� ���������� �������� ���� (����� 0, ��� 1) ��� ������� bit (���������� � 0) � ����� flags, ���� ������ ���� ���, ���������� nil
function CheckBit(flags, bit)
   -- ���������, ��� ���������� ��������� �������� �������
   if type(flags) ~= "number" then error("������!!! Checkbit: 1-� �������� �� �����!"); end;
   if type(bit) ~= "number" then error("������!!! Checkbit: 2-� �������� �� �����!"); end;
   local RevBitsStr  = ""; -- ������������ (����� �������) ��������� ������������� ��������� ������������� ����������� ����������� ����� (flags)
   local Fmod = 0; -- ������� �� ������� 
   local Go = true; -- ���� ������ �����
   while Go do
      Fmod = math.fmod(flags, 2); -- ������� �� �������
      flags = math.floor(flags/2); -- ��������� ��� ��������� �������� ����� ������ ����� ����� �� �������           
      RevBitsStr = RevBitsStr ..tostring(Fmod); -- ��������� ������ ������� �� �������
      if flags == 0 then Go = false; end; -- ���� ��� ��������� ���, ��������� ����
   end;
   -- ���������� �������� ����
   local Result = RevBitsStr :sub(bit+1,bit+1);
   if Result == "0" then return 0;     
   elseif Result == "1" then return 1;
   else return nil;
   end;
end;

	
function table.save(tbl,file)
        -- recursively saves table data to a file, human-readable and indented
        -- supported types: number, string, boolean, tables of the same
        local f,err = io.open(file,"w")
        if err then
                print("Error: Unable to open file for writing: "..file.."\nDetails: "..err)
                return
        end
        local indent = 1
 
        -- local functions to make things easier
        local function exportstring(s)
                s=string.format("%q",s)
                s=s:gsub("\\\n","\\n")
                s=s:gsub("\r","")
                s=s:gsub(string.char(26),""..string.char(26).."")
                return s
        end
        local function serialize(o)
                if type(o) == "number" then
                        f:write(o)
                elseif type(o) == "boolean" then
                        if o then f:write("true") else f:write("false") end
                elseif type(o) == "string" then
                        f:write(exportstring(o))
                elseif type(o) == "table" then
                        f:write("{\n")
                        indent = indent + 1
                        local tab = ""
                        for i=1,indent do tab = tab .. "        " end
                        for k,v in pairs(o) do
                                f:write(tab .. "[")
                                serialize(k)
                                f:write("] = ")
                                serialize(v)
                                f:write(",\n")
                        end
                        indent = indent - 1
                        tab = ""
                        for i=1,indent do tab = tab .. "        " end
                        f:write(tab .. "}")
                else
                        print("unable to serialzie data: " .. tostring(o))
                        f:write("nil, -- ***ERROR: unsupported data type!***")
                end
        end
 
        -- here's the actual save process
        f:write("return {\n")
        for k,v in pairs(tbl) do
                f:write("       [")
                serialize(k)
                f:write("] = ")
                serialize(v)
                f:write(",\n")
        end
        f:write("}")
        f:close()
end
function table.load(file)
        local data,err = loadfile(file)
        if err then return nil,err else return data() end
end