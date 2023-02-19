function startfarm(funfarmargs)
    while _G.andy_farm_program_running == 1 do
        local setmenu = _G.setmenu
        version = "5"
        done = 0
        local farm_prog_progress = "init"
        farm_prog_progress = 0
        farm_prog_progress = farm_prog_progress + 1
        farmapiloadedguilib = 0                         
        
        local farm_rescan = true

        os.loadAPI("AndysPrograms/api/gt")  
        while farmapiloadedguilib ~= 1 do
            if os.loadAPI("AndysPrograms/api/gui/gui") then
                --print("loaded gui farmapi lib")
                farmapiloadedguilib = 1
            else
                print(" NOTloaded gui lib")
            end
        end

        local setmenu = gui.get_setmenu()
        --andy_farm_program_running = 0

        if fs.exists("AndysPrograms/Farm/settings") then
            settings.load("AndysPrograms/Farm/settings")
        end
        local maxW, maxH = term.getSize()

        farmexit = 0
        while farmexit ~= 1 do

        local setmenu = _G.setmenu



        --CHANGE HERE START--

        --"1" is Normal, "2" is Pumpkin/Melon/Probably Sugar Cane
        farm_prog_progress = farm_prog_progress + 1
        Mode = tonumber(settings.get(setmenu[4].setname))
        
        if Mode > 2 or Mode < 1 then
            Mode = 2
        end


        Farm_Lenth = tonumber(settings.get(setmenu[2].setname))
        Farm_Width = tonumber(settings.get(setmenu[3].setname))




        -- sort for specific crop

        --whether or not to sort, 1 is yes, 0 is no
        sortblock = tonumber(settings.get(setmenu[8].setname))
        if sortblock > 1 or sortblock < 0 then
            sortblock = 1
        end

        --name of the crop
        crop_name = settings.get(setmenu[9].setname)

        --max age of crop should probably be left at 7
        crop_max_age = 7



        --setup location
            setuploc = settings.get(setmenu[5].setname)



        --chest location
            chestloc = settings.get(setmenu[6].setname)

        farmsleeptime = 0
        
        --chest 2 = "up", 1 = "down", or 0 = "forward"
        chestdirection = tonumber(settings.get(setmenu[7].setname))
            
        if chestdirection > 2 or chestdirection < 0 then
            chestdirection = 2
        end
            --misc
                                
                            --ignore if a crop has no age value should be set at 1 for Pumpkin/Melon and 0 for Normal
                                Override_ignore_nil_age = 0
                                ignore_nil_age = 1

                                override_stages = 0
                                turnleftchest = 0
                                totalstages = 1

        --CHANGE HERE END--


        farm_prog_progress = farm_prog_progress + 1



        local function farm_move_foward()
            turtle.forward()
            farm_rescan = true
        end

        function scrlnum(a,b,st,cl)
            if a == b then
                return a, 1
            else
                local clend = cl + st
                local cldiv = cl - clend
                local clenddiv = clend - cl
                scrlnumper = (os.clock() - cl) / clenddiv
                scrlnumper = scrlnumper ^ 2

                return math.floor(((scrlnumper * (b - a)) + a) + 0.1), scrlnumper
                --return ((scrlnumper * (b - a)) + a) + 0.1, scrlnumper
            end
        end





        --unused!!!! Recenter Values
        turn_right_recenter_times = 0
        forward_recenter_times = 0

        if Override_ignore_nil_age == 0 then
        if Mode == 2 then
                ignore_nil_age = 1
        elseif Mode == 1 then
                ignore_nil_age = 0
        end
        end

        st_width = Farm_Width
        lenth = Farm_Lenth
        if override_stages == 1 then
            totalsteps = totalstages
            if Mode == 2 then
                grabstage = 5
            elseif Mode == 1 then
                grabstage = 2
            end
        elseif Mode == 2 then
        if override_stages == 0 then
                grabstage = 5
                totalstages = 1
                totalsteps = 1
            end
        elseif  Mode == 1 then
            if override_stages == 0 then
                grabstage = 2
                totalstages = 2
                totalsteps = 2
            end
        end


        totalsteps = totalstages
        endsteps = totalsteps + 1
        sub_lenth = lenth - 1
        function chest()

            gt.goto(chestloc)
            if Mode == 2 then
                chest = 1
            elseif  Mode == 1 then
                chest = 2
            end

            
                
            while chest <= 16 do
                turtle.select(chest)
                if chestdirection == 0 then
                    turtle.drop()
                elseif chestdirection == 1 then
                    turtle.dropDown()
                elseif chestdirection == 2 then
                    turtle.dropUp()
                end                     
                chest = chest + 1
            end
            if turnleftchest == 1 then
                turtle.turnLeft()
            end
            farm_rescan = true
            farmexit = 1
        end


        function turn()
            if width >= 2 then
                if right == 1 then
                    turtle.turnRight()
                    farm_move_foward()
                    turtle.turnRight()
                    dist = sub_lenth
                    width = width - 1
                    right = 0
                else
                    turtle.turnLeft()
                    farm_move_foward()
                    turtle.turnLeft()
                    dist = sub_lenth
                    width = width - 1
                    right = 1
                end
            elseif width < 2 then
                dist = sub_lenth
                width = width - 1
                if width <= 0 then
                    turtle.turnLeft()
                    turtle.turnLeft()
                end
            end
        end


        function recenter()                             
            working_turn_right_recenter_times = turn_right_recenter_times

            working_forward_recenter_times = forward_recenter_times
            gt.goto(setuploc)
                if turn_right_recenter_times ~= 0 then
                    while working_turn_right_recenter_times ~= 0 do
                        turtle.turnRight()
                        working_turn_right_recenter_times = working_turn_right_recenter_times - 1
                    end
                end

            right = 1
            turtle.select(1)
            dist = lenth - 1
            if forward_recenter_times ~= 0 then
                while working_forward_recenter_times ~= 0 do
                    turtle.forward()
                    working_forward_recenter_times = working_forward_recenter_times - 1
                end
            end
            farm_rescan = true
        end

        if percentageold == nil then
            percentageold = 0
        end
        if dopnt == nil then
            dopnt = 1
        end
        if tnstm == nil then
            tnstm = 0.01
        end
        if scagtm == nil then
            scagtm = 0.01
        end
        function stage1()
            ttmst = os.clock()

            if totalstages <= 1 then
                --print ("Stage: " .. done .. "/" .. totalsteps.. " Harvest")
            elseif totalstages >= 2 then
                --print ("Stage: " .. done .. "/" .. totalsteps.. " Harvest and Plant")
            end
            -- for i=1,#crop_name do
            success, data = turtle.inspectDown()
            if success then
                -- if dopnt == 6 then
                -- if data.state.age ~= nil then
                --     -- scnmpnt = 0
                --     -- dlprns1 = 0
                --     -- percentagefloat = (data.state.age - 0) / (7 - 0) * 100
                --     -- percentage = math.floor(percentagefloat+0.5)
                --     -- scnmtmst = os.clock()

                --     -- scagl = 0
                --     -- while dlprns1 < 1 do
                --         -- scagtmst = os.clock()
                --         --scnmpnt, dlprns1 = scrlnum(percentageold,percentage,tnstm,scnmtmst)
                --         -- scnmpnt = 1
                --         -- if dlprns1 == nil then
                --             -- dlprns1 = 0
                --         -- end

                --         -- if scagl > 25 then
                --         --     sleep()
                --         --     scagl = 0
                --         -- end
                --         -- scagl = scagl + 1
                --         -- scagtmen = os.clock()
                --         -- scagtm = scagtmen - scagtmst
                --         -- end
                --     -- percentageold = percentage
                    
                    
                -- end
                -- end
                for i=1,#crop_name do
                    if (data.name == crop_name[i]) or (sortblock == 0) then
                        if data.state.age == crop_max_age or ignore_nil_age == 1 then
                            turtle.digDown()


                        end 
                    end 
                end
                turtle.suckDown()
                if Mode == 1 then
                    turtle.placeDown()
                end
            end
            -- end
            ttmen = os.clock()
            tnstm = ttmen - ttmst
            tnstm = tnstm - scagtm
            tnstm = tnstm / 2
            if tnstm < 0 then
                tnstm = 0.02
            end
            farm_rescan = false
        end

        function scrlage()
            -- for i=1,#crop_name do
            --     success, data = turtle.inspectDown()
            --     if success then
            --         if dopnt == 1 then
            --         if data.state.age ~= nil then
            --             scnmpnt = 0
            --             dlprns1 = 0
            --             percentagefloat = (data.state.age - 0) / (7 - 0) * 100
            --             percentage = math.floor(percentagefloat+0.5)
            --             scnmtmst = os.clock()

                        
            --             while dlprns1 < 1 do
            --                 -- scnmpnt, dlprns1 = scrlnum(percentageold,percentage,0.5,scnmtmst)
            --                 scnmpnt = 1
            --                 if dlprns1 == nil then
            --                     dlprns1 = 0
            --                 end

            --                     sleep()
            --                 end
            --             percentageold = percentage
                        
                        
            --         end
            --         end
            --     end
            -- end
        end



                
        function stage2()
            turtle.suckDown()
        end

        function stg1tg()
        if dist ~= 0 then
            if done == 1 then
                while width ~= 0 do
                    while dist ~= 0 do
                        dopnt = 1
                        -- parallel.waitForAll(stage1,scrlage)
                        if farm_rescan == true then
                            stage1()
                        end
                        --stage1()
                        dopnt = 1
                        farm_move_foward()
                        --parallel.waitForAll(stage1,scrlage)
                        -- stage1()
                        if farm_rescan == true then
                            stage1()
                        end
                        dist = dist - 1
                    end
                    turn()
                end
            end
        end
        end


        if width == 0 or width == nil  then
            done = done + 1
            if done == endsteps then
                chest()
                done = 0
                farmexit = 1
            end
            width = st_width
            if farmexit ~= 1 then
                recenter()
            end

        elseif width ~= 0 then

            if dist ~= 0 then
                if done == 1 then
                    -- term.clear()
                    while width ~= 0 do
                        while dist ~= 0 do
                            dopnt = 1
                            -- parallel.waitForAll(stage1,scrlage)
                            if farm_rescan then
                                stage1()
                            end
                            dopnt = 1
                            farm_move_foward()
                            -- parallel.waitForAll(stage1,scrlage)
                            if farm_rescan then
                                stage1()
                            end
                            dist = dist - 1
                        end
                        turn()
                    end

                elseif done == grabstage then
                    -- term.clear()
                    while width ~= 0 do
                        while dist ~= 0 do
                            if farm_rescan then
                                stage2()
                            end
                            farm_move_foward()
                            if farm_rescan then
                                stage2()
                            end
                            dist = dist - 1
                        end
                        turn()
                    end
            end

        end
        end
        end
    end
end