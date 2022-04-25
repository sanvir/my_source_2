Run = true;		-- Флаг поддержания работы скрипта
 
TradeNums = {};	-- Массив для хранения номеров записанных в файл сделок (для предотвращения дублирования)
 FILE_TEMP = getScriptPath().."/MyTrades11.dat"  -- "C:\\SBERBANK\\QUIK_x64\\Lua\\MyTrades.dat"
-- Вызывается терминалом QUIK в момент запуска скрипта
function OnInit()
	if table.load(FILE_TEMP) ~= nil then	TradeNums = table.load(FILE_TEMP) end
	-- Создает, или открывает для чтения/добавления файл CSV в той же папке, где находится данный скрипт
	CSV = io.open(getScriptPath().."/MyTrades11.csv", "a+");
	-- Встает в конец файла, получает номер позиции
	local Position = CSV:seek("end",0);
	-- Если файл еще пустой
	if Position == 0 then
		-- Создает строку с заголовками столбцов
		local Header = "Дата и время;Код класса;Код бумаги;Код счёта;order_num;Операция;Цена;Количество\n"
		-- Добавляет строку заголовков в файл
		CSV:write(Header);
		-- Сохраняет изменения в файле
		CSV:flush();
	end;	
	--OnAllTradeMy()
end; 
 
-- Основная функция скрипта (пока работает она, работает скрипт)
CLASS_CODE  = "SPBFUT"      -- Код класса
SEC_CODE  	= "SiM2"     -- Код инструмента
 
 
-- Вызывается терминалом QUIK в момент остановки скрипта
function OnStop()
	--table.save(TradeNums,FILE_TEMP)  -- пишем	
	-- Выключает флаг, чтобы остановить цикл while внутри main
	Run = false;
	-- Закрывает открытый CSV-файл 
	CSV:close();	
	is_run = false  
end;

function main() 
	if Subscribe_Level_II_Quotes(CLASS_CODE, SEC_CODE)==true then		
					while Run do sleep(100)
						--quik_price_tick_1 = CreateDataSource(CLASS_CODE, SEC_CODE, INTERVAL_TICK)
						--quik_price_tick_4 = CreateDataSource(CLASS_CODE, SEC_CODE_4, INTERVAL_TICK)
						MainLoop()
						--message("Запуск")
					end 				
	else is_run = false end	
end

function MainLoop()  -- Функция выполняется при каждой итерации цикла while в функции main	
		
		
		
		
		
end
 
-- Функция вызывается терминалом QUIK при совершении Вами новой сделки
-- (обычно вызывается по 2 раза для каждой сделки)
function OnAllTrade(alltrade)
	-- Перебирает массив с номерами записанных сделок (в обратном порядке)
			
	for i=#TradeNums,1,-1 do
		-- Если данная сделка уже была записана, выходит из функции
		if (TradeNums[i] == alltrade.trade_num) or (alltrade.qty < 301) then return; end;
	end;
 
	-- Если мы здесь, значит сделка не была найдена в числе уже записанных
	-- Добавляет в массив номер новой сделки
	TradeNums[#TradeNums + 1] = alltrade.trade_num;
	-- Вычисляет операцию сделки
	local Operation = "";
	if CheckBit(alltrade.flags, 2) == 1 then Operation = "SELL"; else Operation = "BUY"; end;
	-- Создает строку сделки для записи в файл ("Дата и время;Код класса;Код бумаги;Операция;Цена;Количество\n")
	local TradeLine = 	os.date("%d.%m.%Y | %X", os.time(alltrade.datetime))..";"..
						alltrade.class_code..";"..
						alltrade.sec_code..";"..
						--alltrade.account..";"..
						alltrade.trade_num..";"..
						Operation..";"..
						--trade.price..";"..
						string.gsub(alltrade.price, "%.", ",")..";"..
						string.gsub(alltrade.qty, "%.", ",").."\n";	
	
	-- Записывает строку в файл
	CSV:write(TradeLine);
	-- Сохраняет изменения в файле
	CSV:flush();
end;

function OnAllTradeMy()
	-- Перебирает массив с номерами записанных сделок (в обратном порядке)
	for i = 0, getNumberOf("all_trades") - 1 do
	local item = getItem("all_trades", i)
	
	sleep(1000)
	--if then message(item.sec_code)  -- Если наша
	message(item.sec_code)
	
	if (item.qty > 100) and (item.sec_code == SEC_CODE)  then -- Если не наша, то сразу уходим
		for i=#TradeNums,1,-1 do
			-- Если данная сделка уже была записана, выходит из функции
			--if TradeNums[i] == item.trade_num then return; end;
			if (TradeNums[i] == item.trade_num) then return; end;
		end
		
		-- Если мы здесь, значит сделка не была найдена в числе уже записанных
		-- Добавляет в массив номер новой сделки
		TradeNums[#TradeNums + 1] = item.trade_num;
		-- Вычисляет операцию сделки
		local Operation = "";
		if CheckBit(item.flags, 2) == 1 then Operation = "SELL"; else Operation = "BUY"; end;
		
				
	message(item.sec_code)
	
	
	-- Создает строку сделки для записи в файл ("Дата и время;Код класса;Код бумаги;Номер сделки;Номер заявки;Операция;Цена;Количество\n")
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
		
		-- Записывает строку в файл
	
	
		--CSV:write(TradeLine);
		--message(tostring(item.sec_code))
		--message(tostring(item.SEC_CODE))
		--message('-')
		-- Сохраняет изменения в файле
		--table.save(TradeNums,FILE_TEMP)  -- пишем	
		--CSV:flush();	
		--message(item.sec_code) return end
		end 
		
	end	
	end
  
-- Функция возвращает значение бита (число 0, или 1) под номером bit (начинаются с 0) в числе flags, если такого бита нет, возвращает nil
function CheckBit(flags, bit)
   -- Проверяет, что переданные аргументы являются числами
   if type(flags) ~= "number" then error("Ошибка!!! Checkbit: 1-й аргумент не число!"); end;
   if type(bit) ~= "number" then error("Ошибка!!! Checkbit: 2-й аргумент не число!"); end;
   local RevBitsStr  = ""; -- Перевернутое (задом наперед) строковое представление двоичного представления переданного десятичного числа (flags)
   local Fmod = 0; -- Остаток от деления 
   local Go = true; -- Флаг работы цикла
   while Go do
      Fmod = math.fmod(flags, 2); -- Остаток от деления
      flags = math.floor(flags/2); -- Оставляет для следующей итерации цикла только целую часть от деления           
      RevBitsStr = RevBitsStr ..tostring(Fmod); -- Добавляет справа остаток от деления
      if flags == 0 then Go = false; end; -- Если был последний бит, завершает цикл
   end;
   -- Возвращает значение бита
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