local update_name = "updateV7"


local git_url = "WPg3HSiU"
local gui_url = "4W4TKHmM"
local farm_url = "WSZF4MYJ"
local goto_url = "PX672x3m"
local launcherargs = {...}


if launcherargs[1] == "-dev_enable" then
    fs.makeDir("AndysPrograms/farm/dev_mode")
elseif launcherargs[1] == "-dev_disable" then
    fs.delete("AndysPrograms/farm/dev_mode")
end
_G.farm_devmode = false
if fs.exists "AndysPrograms/farm/dev_mode" then
    local farm_update = {"BPplays","CC-Farm","dev","farm.lua","farm","AndysPrograms/farm"}
    _G.farm_devmode = true
else
    local farm_update = {"BPplays","CC-Farm","main","farm.lua","farm","AndysPrograms/farm"}
    _G.farm_devmode = false
end
if fs.exists("AndysPrograms/api/git/git") == false then
    fs.makeDir("AndysPrograms/api/git")
    shell.run("cd","AndysPrograms/api/git")
    shell.run("pastebin","get","WPg3HSiU","git")
    shell.run("cd ","//")
end
if fs.exists("AndysPrograms/api"..update_name) == false then
    fs.makeDir("AndysPrograms/api")
    shell.run("cd","AndysPrograms/api")
    shell.run("pastebin","get","uBa2UnVT",update_name)
    shell.run("cd","..")
    shell.run("cd","..")
end
shell.run("AndysPrograms/api/"..update_name, "gui", gui_url, "AndysPrograms/api/gui", "none", "none")
if fs.exists("AndysPrograms/api/pastebin_silent/ps") == false then
    fs.makeDir("AndysPrograms/api/pastebin_silent")
    shell.run("cd","AndysPrograms/api/pastebin_silent")
    shell.run("pastebin","get","Zp2CC5qM","ps")
    shell.run("cd","..")
    shell.run("cd","..")
    shell.run("cd","..")
end


local farm_prog_progress = "init"
while loadedguilib ~= 1 do
    if os.loadAPI("AndysPrograms/api/gui/gui") then
        --print("loaded gui lib")
        loadedguilib = 1
    else
        print(" NOTloaded gui lib")
    end
end

function get_running()
	return andy_farm_program_running
end
function set_running(n)
	andy_farm_program_running = n
end


fudargs = "sleep(5)\nshell.run(\"farm\", \"noset\")"
--print (fudargs)
--sleep (5)
farmlauncherloop = 1
stopfarm = 0 
errhnd = 0
function call_farm()
    farm.startfarm(launcherargs)
end
function running_check()
    while _G.andy_farm_program_running == 1 do
        sleep(0.03)
    end
end
function para_farm()
    parallel.waitForAny(call_farm,running_check)
end

function error_handler(err)
    if err == "Terminated" then
        stopfarm = 1
    else
        local dot = 0
        -- term.setCursorPos(1, 1) 
        -- term.clear()
        -- print("Error, Retrying"..dot)
        -- term.setCursorPos(1, 3) 
        -- print( "Error:",err)
        -- term.setCursorPos(1, 4)
        -- errhnd = 1
        --sleep(2 / 3)
        sleep(0)
    end
end


local function ud()
    shell.run("AndysPrograms/api/"..update_name, "gt", goto_url, "AndysPrograms/api", "none", "none")
    shell.run("AndysPrograms/api/"..update_name, "farm", farm_url, "AndysPrograms/farm", "none", "no", unpack(launcherargs))
end
ud()



function update_start_farm()
    loadedguilib = 0
    while loadedguilib ~= 1 do
        if os.loadAPI("AndysPrograms/api/gui/gui") then
            --print("loaded gui lib")
            loadedguilib = 1
        else
            print(" NOTloaded gui lib")
        end
    end
    farm_prog_progress = "not not even start"
    print(farm_prog_progress)
    while stopfarm == 0 do
        if _G.andy_farm_program_running == 0 then
            sleep(0)
            farm_prog_progress = "not even start"
            --print(farm_prog_progress)
            --print(get_running())
            -- while _G.init_gui ~= 1 do
                
            --     sleep(0.1)
            -- end
        end
        while _G.andy_farm_program_running == 1 do
            farm_prog_progress = "little even start"
            --print(farm_prog_progress)
            if stopfarm == 0 then
                farm_prog_progress = "little more start"
                --print(farm_prog_progress)
                local stu = fs.open("startup.lua", "w")
                stu.write(fudargs)
                stu.close()
                if errhnd == 0 then

                end
                os.loadAPI("AndysPrograms/farm/farm")
                if farmlauncherloop > 1 then 
                    launcherargs = {"noset"}
                end
                
                if xpcall(para_farm,error_handler) then
                    ud()
                else
                    -- sleep(2)
                    sleep(0)
                    errhnd = 0
                    ud()
                end

                
                if errhnd ~= 0 then
                    sleep(0)
                    errhnd = 0
                end
                sleep(0) 
                if farmlauncherloop < 10000 then
                    farmlauncherloop = farmlauncherloop + 1
                end
            else
                break
            end
        end
    end
end



local function farm_gui()
    gui.start_farm_gui(launcherargs)
end
local function farm_gui_lau()
    while _G.stopfarm ~= 1 do
        xpcall(farm_gui,error_handler)
    end
end

local function start_farm_lau()
    farm_prog_progress = "not not not(3) even start"
    --print(farm_prog_progress)
    update_start_farm()
end
local function start_para_lau()
    farm_prog_progress = "not not not not(4) even start"
    --print(farm_prog_progress)
    parallel.waitForAny(farm_gui_lau, start_farm_lau)
end


while _G.stopfarm ~= 1 do
    --update_start_farm()
    _G.andy_farm_program_running = 0
    if launcherargs[1] == "noset" then
        _G.andy_farm_program_running = 1
    end


    start_para_lau()
    stopfarm = 1
    --parallel.waitForAny(farm_gui_lau, start_farm_lau)
end