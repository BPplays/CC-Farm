-- local andy_farm_program_running = 0
function start_farm_gui(args)
    local fgui_exit = 0
    local sel_screen_pos = 6
	farm_prog_progress = "initgui"
    local extra_space = true

    local draw_queue = 1
    local extra_next_select_spaces = 2
    local epoch_mul = 72000 / 1000
    --in milisecs
    local trans_time = 175 * epoch_mul
    local extra_next_string = ""
    local extra_next_string_output = ""
    local prev_extra_next_string = ""
    local col_prev_time = os.epoch() - trans_time
    col_prev_time = col_prev_time - trans_time
    local next_string_lines = 2
    local upper_curve
    
    selitem = 1
    --input lists
    con_up = {keys.up,keys.w}
    con_down = {keys.down,keys.s}
    con_left = {keys.left,keys.a}
    con_right = {keys.right,keys.d}
    con_select = {keys.enter,keys.space}
    con_back = {keys.leftShift,keys.b}
    con_quick_quit = {keys.q}



    local function match_list(var,list)
        for i = 1,#list do
            if var == list[i] then
                return true
            end
        end
        return false
    end

    local function set_menu(menu)
    end
    local cur_menu = "init"
    local prev_menu = "init"
    function menu_init()

        function set_menu(menu)
            if menu ~= cur_menu then
                prev_menu = cur_menu
            end
            cur_menu = menu
			selitem = 1
        end
        set_menu(main_menu)
    end




    while fgui_exit == 0 do

		local function setmain_start()
			if _G.andy_farm_program_running == 0 then
				main_menu[1].options = "Start"
			elseif _G.andy_farm_program_running == 1 then
				main_menu[1].options = "Cancel"
			else
				main_menu[1].options = "What???"
			end
		end

        if fs.exists("AndysPrograms/Farm/settings") then
            settings.load("AndysPrograms/Farm/settings")
        end
        local maxW, maxH = term.getSize()

        function menu_back()
            set_menu(prev_menu)
        end

        function start_stop_farm()
            if andy_farm_program_running == 1 then
				andy_farm_program_running = 0
                _G.andy_farm_program_running = 0
				set_running(0)
				setmain_start()
            else
				andy_farm_program_running = 1
                _G.andy_farm_program_running = 1
				set_running(1)
				setmain_start()
            end
        end

        function options_farm()
            extra_space = true
            set_menu(setmenu)
        end

        function mainmenu_farm()
            extra_space = true
            set_menu(main_menu) 
        end

        function exit()
            term.clear()
            term.setCursorPos(1, 1)
            print("EXIT")
            fgui_exit = 1
			farmexit = 1
			stopfarm = 1
            _G.stopfarm = 1

        end
        function chngset()
            chngsel = 1
        end

        function savesets()
            settings.save("AndysPrograms/Farm/settings")
        end
        gpstab = {}
        local stgpsx, stgpsy, stgpsz = gps.locate(5)
        table.insert(gpstab, stgpsx)
        table.insert(gpstab, stgpsy)
        table.insert(gpstab, stgpsz)
        table.insert(gpstab, "n")
        if fs.exists("AndysPrograms/Farm/settings") == false then
            if fs.exists("AndysPrograms/Farm") == false then
            fs.makeDir("AndysPrograms/Farm")
            end




            srtbk = {"minecraft:pumpkin", "minecraft:reeds"}
            settings.set("Farm Lenth", 1)
            settings.set("Farm Width", 1)
            settings.set("Mode", 2)
            settings.set("Start Location", gpstab)
            settings.set("Chest Location", gpstab)
            settings.set("Sort Block Names", srtbk)
            settings.set("Sort Blocks", 1)
            settings.set("Chest Direction", 0)
            savesets()
        
            
            
        end

		main_menu = {}
		main_menu = {
			{text = "AFarm V12", options = "Start", handler = start_stop_farm},
			{options = "Options", handler = options_farm},
			{options = "Exit", handler = exit}
		}
        function resetmenu()
            deftab = {}



            local setmenu = {}
            setmenu = {
                {options = "Finish editing", handler = mainmenu_farm},
                {text = "Farm Lenth", setname = "Farm Lenth", options = settings.get("Farm Lenth"), type = "num", handler = chngset},
                {text = "Farm Width", setname = "Farm Width", options = settings.get("Farm Width"), type = "num", handler = chngset},
                {text = "Mode, 1 = Nrml, 2 = Pumpkin/Melon/Sugarcane", setname = "Mode", options = settings.get("Mode"), type = "num", handler = chngset},
                {text = "Start Location", setname = "Start Location", options = settings.get("Start Location"), type = deftab, handler = chngset},
                {text = "Chest Location", setname = "Chest Location", options = settings.get("Chest Location"), type = deftab, handler = chngset},
                {text = "Chest Direction 0=fwd 2=up 1=dn", setname = "Chest Direction", options = settings.get("Chest Direction"), type = "num", handler = chngset},
                {text = "Sort Blocks", setname = "Sort Blocks", options = settings.get("Sort Blocks"), type = "num", handler = chngset},
                {text = "Sort Block Names", setname = "Sort Block Names", options = settings.get("Sort Block Names"), type = deftab, handler = chngset}
            }
			_G.setmenu = setmenu
			setmenu_set = 1
			setmain_start()
        end
        resetmenu()

        function addsettings(num, value)
            settings.set(setmenu[num].setname, value)
            savesets()
        end

        openset = 1
        while fgui_exit == 0 do
        if fgui_exit == 0 then
            chngsel = 0
            term.clear()
            setsoffset = 1
            selitem = 1

        local function press_input()
            settingsinputtable = {}
            input2 = string.gsub(input, ", ", ",")
            --print(input)
            for i in string.gmatch(input2, '([^,]+)') do
                table.insert(settingsinputtable, i)
            end
            --print(input)
            addsettings(selitem, settingsinputtable)
        end

        local function print_prep(i)
            if i ~= nil then
                if (type(i) == "table") then
                    return table.concat(i, ", ")
                else
                    return i
                end
            end
        end

        local function error()
            
        end
        local item_list = {}
        local preped_item_list = {}
        local shifted_list = {}
        local item_list_sel = 1
        local function shift_list(list,up_down,amount)
            local templist = {}
            if amount == nil then
                amount = 1
            end
            if amount < 0 then
                amount = amount * -1
            end
            -- print(amount)
            if up_down == nil then
                return list
            end
            if up_down == "up" then
                -- print("up")
                for i=1,#list - amount do
                    
                    table.insert(templist,list[i+amount])
                end
            elseif up_down == "down" then
                
                for i=1,#list + amount do
                    -- print("down")
                    if i-amount < 1 then
                        table.insert(templist," ")
                    else
                        table.insert(templist,list[i-amount])
                    end
                    
                end
            end
            return templist
            
        end
        local stoplistloop = 0
        local dif = 0
        local function prep_list_for_draw(list)
            local shift_dir = ""
            preped_item_list = {}
            dif = item_list_sel - sel_screen_pos
            if dif < 0 then
                shift_dir = "down"
            elseif dif >= 0 then
                shift_dir = "up"
            end
            if #list < maxH then
                return list
            end
            shifted_list = shift_list(list,shift_dir, dif)
            -- print(shifted_list[1])
            -- print(list[1])
            stoplistloop = 0
            for ipl=1,#shifted_list do
                if #preped_item_list > maxH then
                    break
                end
                table.insert(preped_item_list,shifted_list[ipl])
            end
            -- print(preped_item_list[1])
            return preped_item_list
            -- return shifted_list
        end

        local function draw_to_screen(ds_list)
            for i=1,maxH do
                term.setCursorPos(1,i)
                term.clearLine()
                if ds_list[i] ~= nil then
                    term.write(ds_list[i])
                end
            end
        end
        function set_print()

            local function if_overflow(i)
                local temp_over
                local break_loop = 0
                local i2 = 1
                local over_list = {}
                while true do
                    local lower = ((maxW * i2) + 1) - maxW
                    local upper = maxW * i2
                    if upper > #i then
                        upper = #i
                        break_loop = 1
                    end
                    temp_over = string.sub(i,lower,upper)
                    table.insert(over_list,temp_over)
                    i2 = i2 + 1
                    if break_loop == 1 then
                        break
                    end
                end
                for i3=1,#over_list do
                    table.insert(item_list,over_list[i3])
                end
            end
            local pos_inc = 1
            item_list = {}
            local inc_ext = 0
            local function add_list(i)
                -- item_list = item_list .."\n"..i
                if #i > maxW then
                    if_overflow(i)
                else
                    table.insert(item_list,i)
                end
                
            end
            local function inc_extra(i)
                local inc_ext = i
                while inc_ext > 0 do
                    pos_inc = pos_inc + 1
                    inc_ext = inc_ext - 1
                end
            end
            for sets=1,#cur_menu do
                function add_sum(n)
                    if sets < selitem then
                        -- sum_ext_to_sel = sum_ext_to_sel + n
                    end
                end

                setsmul = (sets * 2) - 1
                if (setsmul + setsoffset) <= maxH or true then
                    -- term.setCursorPos(1, ((setsmul + setsoffset) +text_plus)+sum_ext_to_sel - selitem) 
					if cur_menu[sets].text ~= nil then
						add_list(print_prep(cur_menu[sets].text))
						if #cur_menu[sets].text / maxW > 1 then
                            inc_extra(#cur_menu[sets].text / maxW)
                            -- add_sum(#cur_menu[sets].text / maxW)
						end
                        -- text_plus = text_plus + 1

					end

                    pos_inc = pos_inc + 1
                    -- term.setCursorPos(1, ((setsmul + setsoffset)+text_plus) + sum_ext_to_sel - selitem) 
                    if cur_menu[sets].options ~= nil then
                        -- term.clearLine()
                        prntset = print_prep(cur_menu[sets].options)
                        if #tostring(prntset) / maxW > 1 then
                            -- add_sum(#tostring(prntset) / maxW)
                        end
                        if selitem == sets then
                            if chngsel == 1 then 
                                input = read()
                                if input then
                                    press_input()
                                end

                            else
                                add_list(">  "..extra_next_string_output..prntset)
                                if #tostring(prntset) / maxW > 1 then
                                    -- add_sum(#tostring(prntset) / maxW)
                                end
                                item_list_sel = #item_list
                            end
                        else
                            add_list("   "..prntset)
                            if #tostring(prntset) / maxW > 1 then
                                -- add_sum(#tostring(prntset) / maxW)
                            end
                        end
                        if extra_space == true then
                            if sets <= #cur_menu then
                                add_list(" ")
                            end
                        end
                    end
                end
            end
            return item_list
        end
        function printmenu(menu)
            local sum_ext_to_sel = 0

			setmain_start()
            local text_plus = 0

            local temp_set = set_print()
            local temp_prep = prep_list_for_draw(temp_set)
            print(temp_prep[1])
            draw_to_screen(temp_prep)
            -- draw_to_screen(set_print())
        end
            function onsel(menu, selected)
                menu[selected].handler()
            end

            function onkeypress(key, menu, selected)
                if match_list(key,con_select) then
                    if chngsel == 0 then
                        onsel(menu, selected)
                    end
                -- if chngsel == 1 and (key == keys.enter or key == keys.space) then
                    --   chngsel = 0
                -- end
                elseif match_list(key,con_up) then
                    if selitem > 1 then
                        --setsoffset = setsoffset + 2.1
                        -- setsoffset = math.floor(setsoffset)
                        selitem = selitem - 1
                        col_prev_time = os.epoch()
                        extra_next_select_spaces = 0
                    end
                elseif match_list(key,con_down) then
                    if selitem < (#menu) then
                        --setsoffset = setsoffset - 1.9
                        -- setsoffset = math.floor(setsoffset)
                        selitem = selitem + 1
                        col_prev_time = os.epoch()
                        extra_next_select_spaces = 0
                    end
                elseif match_list(key,con_back) then
                    menu_back()
                elseif match_list(key,con_quick_quit) then
                    exit()
                end
                if key ~= nil then
                    draw_queue = draw_queue + 1
                end
            end

		menu_init()

        local function OutQuadBlend(t)
            local temp_blend = 0
            if t <= 0.5 then
                temp_blend = t
                -- return 2.0 * t * t;
            else --t == 0.5
                temp_blend = 2.0 * t * (1.0 - t) + 0.5;
            end
            if temp_blend <= 1 then
                return temp_blend
            else
                return 1
            end
        end
		local function fancy_extra_next_sel_curve()
            while true do
                local temp_num = 0
                extra_next_string = ""
                local down_proc = false
                local extra_next_select_spaces = (((os.epoch() - (col_prev_time - trans_time)) / trans_time) - 1)
                if extra_next_select_spaces >= 1 then
                    extra_next_string = ""
                else
                    
                    if extra_next_select_spaces <= 0.5 then
                        -- extra_next_select_spaces = extra_next_select_spaces + mix_cache_eq
                    elseif extra_next_select_spaces > 0.5 then
                        -- extra_next_select_spaces = extra_next_select_spaces + mix_cache_eq
                        -- extra_next_select_spaces = 2 * extra_next_select_spaces * (1 - extra_next_select_spaces) + 0.5
                        down_proc = true
                    end
                    OutQuadBlend(extra_next_select_spaces)
                    if extra_next_select_spaces < 0.25 then
                        extra_next_select_spaces = extra_next_select_spaces * 2
                    elseif extra_next_select_spaces < 0.5 then
                        extra_next_select_spaces = 0.5
                    end
                    temp_num = extra_next_select_spaces * (next_string_lines * 2)
                    -- if extra_next_select_spaces > 0.4 and extra_next_select_spaces < 0.6 then
                        -- temp_num = next_string_lines
                    -- end


                    if down_proc == false then
                        upper_curve = math.floor(temp_num + 0.5)
                        -- for i=1,math.floor(temp_num + 0.5) do
                            -- extra_next_string = extra_next_string.." "
                        -- end
                    else
                        upper_curve = next_string_lines
                        for i=1,temp_num - next_string_lines do
                            upper_curve = upper_curve - 1
                        end
                        -- upper_curve = next_string_lines + math.floor((-(temp_num - next_string_lines)) + 0.5)
                        -- for i=1,math.floor(((next_string_lines * 2)+((next_string_lines - (temp_num - next_string_lines))) + 0.5)) do
                            -- extra_next_string = extra_next_string.." "
                        -- end
                    end
                    for i=1,upper_curve do
                        extra_next_string = extra_next_string.." "
                    end
                end
                extra_next_string_output = extra_next_string
                if extra_next_string_output ~= prev_extra_next_string then
                    draw_queue = draw_queue + 1
                end
                prev_extra_next_string = extra_next_string_output
                
                sleep(0)
            end
        end
		--os.loadAPI("farm")
		--os.loadAPI("AndysPrograms/Farm/farm")
        local function main_input_loop()
            while fgui_exit == 0 do
                if setmenu_set == 1 then
                    init_gui = 1
                    _G.init_gui = 1
                end
                -- term.setCursorPos(1, 1) 
                -- term.clear()
                -- printmenu(cur_menu)
                event, key = os.pullEvent("key")
                onkeypress(key, cur_menu, selitem)
                setmain_start()
                sleep(0.01)
            end            
        end
        local function draw_wait_loop()
            while draw_queue > 0 do
                printmenu(cur_menu)
                sleep(0.01)
            end
        end
        parallel.waitForAny(main_input_loop,fancy_extra_next_sel_curve,draw_wait_loop)

        end
        end
    end
end
function get_running()
	return andy_farm_program_running
end
function set_running(n)
	andy_farm_program_running = n
end
function get_setmenu()
	return setmenu
end