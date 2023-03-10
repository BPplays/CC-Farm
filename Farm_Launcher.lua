local update_name = "updateV7.2"


local git_url = "WPg3HSiU"
local gui_url = "4W4TKHmM"
local farm_url = "WSZF4MYJ"
local goto_url = "PX672x3m"
local launcherargs = {...}
local load_update = "AndysPrograms/api".."/"..update_name
local run_update = load_update.."/".."ud"





local update_url = {}
local goto_update = {}
local gui_update = {}
local startup_update = {}
local farm_update = {}
if launcherargs[1] == "-dev_enable" then
    fs.makeDir("AndysPrograms/farm/dev_mode")
elseif launcherargs[1] == "-dev_disable" then
    fs.delete("AndysPrograms/farm/dev_mode")
end

_G.farm_devmode = false
local dev_or_main = "main"
if fs.exists "AndysPrograms/farm/dev_mode" then
    update_url = {"BPplays","CC-Update","dev","Update.lua","ud",tostring(load_update)}
    goto_update = {"BPplays","CC-Goto","dev","Goto.lua","gt","AndysPrograms/api"}
    gui_update = {"BPplays","CC-Farm","dev","lib/Farm_GUI.lua","gui","AndysPrograms/api/gui"}
    startup_update = {"BPplays","CC-Farm","dev","lib/startup.lua","startup.lua",""}
    farm_update = {"BPplays","CC-Farm","dev","lib/Farm_lib.lua","farm","AndysPrograms/farm"}
    dev_or_main = "dev"
    _G.farm_devmode = true
else
    update_url = {"BPplays","CC-Update","main","Update.lua","ud",tostring(load_update)}
    goto_update = {"BPplays","CC-Goto","main","Goto.lua","gt","AndysPrograms/api"}
    gui_update = {"BPplays","CC-Farm","main","lib/Farm_GUI.lua","gui","AndysPrograms/api/gui"}
    startup_update = {"BPplays","CC-Farm","main","lib/startup.lua","startup.lua",""}
    farm_update = {"BPplays","CC-Farm","main","lib/Farm_lib.lua","farm","AndysPrograms/farm"}
    dev_or_main = "main"
    _G.farm_devmode = false
end

if fs.exists("AndysPrograms/api/git/git") == false then
    fs.makeDir("AndysPrograms/api/git")
    shell.run("cd","AndysPrograms/api/git")
    shell.run("git","get","BPplays","CC-git-api","main","git","git")
    shell.run("cd ","//")
end
if fs.exists("AndysPrograms/api/git/git") == false then
    fs.makeDir("AndysPrograms/api/git")
    shell.run("cd","AndysPrograms/api/git")
    shell.run("pastebin","get","WPg3HSiU","git")
    shell.run("cd ","//")
end


local loadedgitlib = 0
while loadedgitlib ~= 1 do
    if os.loadAPI("AndysPrograms/api/git/git") then
        print("loaded git lib")
        loadedgitlib = 1
    else
        print(" NOTloaded git lib")
    end
end

-- if fs.exists(run_update) == false then
--     fs.makeDir(load_update)
--     shell.run("cd",load_update)
--     shell.run("pastebin","get","uBa2UnVT","ud")
--     shell.run("cd","//")
-- end
if fs.exists(run_update) == false then
    local i = 1
    -- while fs.exists(run_update) == false and i < 12 do
    fs.makeDir(load_update)
    print("get ud start")
    git.get(update_url)
    print("get ud end")
        -- shell.run("git","get",update_url[1],update_url[2],update_url[3],update_url[4],update_url[5])
        -- print(table.concat(update_url,", "))
        -- if i > 10 then
        --     sleep(1)
        -- elseif i > 12 then
        --     break 
        -- end
    -- end
end
-- shell.run(run_update, "gui", gui_url, "AndysPrograms/api/gui", "none", "none")

-- shell.run(run_update, gui_update)
os.loadAPI(run_update)
print("gui ud start")

print("gui ud end")

-- if fs.exists("AndysPrograms/api/pastebin_silent/ps") == false then
--     fs.makeDir("AndysPrograms/api/pastebin_silent")
--     shell.run("cd","AndysPrograms/api/pastebin_silent")
--     shell.run("pastebin","get","Zp2CC5qM","ps")
--     shell.run("cd","..")
--     shell.run("cd","..")
--     shell.run("cd","..")
-- end


local farm_prog_progress = "init"


function get_running()
	return andy_farm_program_running
end
function set_running(n)
	andy_farm_program_running = n
end


local fudargs = "sleep(5)\nshell.run(\"farm\", \"noset\")"
--print (fudargs)
--sleep (5)
farmlauncherloop = 1
_G.stopfarm = 0 
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
        _G.stopfarm = 1
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

local function update_gui_para()
    -- ud.update(gui_update)
end
ud.update(gui_update)
local function update_farm_api()
    ud.update(farm_update)
end
local function update_goto()
    ud.update(goto_update)
end

local function update_farm()
    -- shell.run(run_update, goto_update)
    
    -- shell.run(run_update, farm_update)
    update_goto()
    sleep(0)
    update_farm_api()
    -- parallel.waitForAll(update_farm_api,update_goto)
    -- ud.update(goto_update)
    -- ud.update(farm_update)
end
print("farm update start")
update_farm()
-- parallel.waitForAll(update_farm,update_gui_para)
-- update_gui_para()
-- update_farm()
print("farm update end")

local loadedguilib = 0
while loadedguilib ~= 1 do
    if os.loadAPI("AndysPrograms/api/gui/gui") then
        --print("loaded gui lib")
        loadedguilib = 1
    else
        print(" NOTloaded gui lib")
    end
end

local function farm_exit_watcher()
    while _G.farmexit ~= 1 do
        sleep(0.05)
        if _G.farmexit == 1 then
            break
        end
    end
end

local function call_farm_error_risist()
    xpcall(para_farm,error_handler)
end

function update_start_farm()
    farm_prog_progress = "not not even start"
    -- print(farm_prog_progress)
    while _G.stopfarm == 0 do
        if _G.andy_farm_program_running == 0 then
            sleep(0)
            farm_prog_progress = "not even start"
            --print(farm_prog_progress)
            --print(get_running())
            -- while _G.init_gui ~= 1 do
                
                sleep(0.05)
            -- end
        end
        while _G.andy_farm_program_running == 1 do
            farm_prog_progress = "little even start"
            --print(farm_prog_progress)
            if _G.stopfarm == 0 then
                farm_prog_progress = "little more start"
                --print(farm_prog_progress)

                if farmlauncherloop > 1 then 
                    launcherargs = {"noset"}
                end
                _G.farmexit = 0
                -- parallel.waitForAny(call_farm_error_risist,farm_exit_watcher)
                xpcall(para_farm,error_handler)
                -- while _G.farmexit ~= 1 do
                
                    -- if xpcall(para_farm,error_handler) then
                    --     print("start reloop")
                    --     update_farm()
                    --     sleep(0)
                    --     print("end ud")
                    -- else
                    --     print("start fail")
                    --     -- sleep(2)
                    --     sleep(0)
                    --     errhnd = 0
                    --     update_farm()
                    --     print("end ud")
                    -- end
                -- end
                -- print("start reloop")
                update_farm()
                -- sleep(0)
                -- print("end ud")
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
    -- print("farm_gui")
    gui.start_farm_gui(launcherargs)
end
local function farm_gui_lau()
    -- print("farm_gui_lau")
    while _G.stopfarm ~= 1 do
        xpcall(farm_gui,error_handler)
    end
end

local function start_farm_lau()
    -- print("start_farm_lau")
    farm_prog_progress = "not not not(3) even start"
    --print(farm_prog_progress)
    while _G.stopfarm ~= 1 do
        xpcall(update_start_farm,error_handler)
    end
    -- update_start_farm()
end
local function start_para_lau()
    farm_prog_progress = "not not not not(4) even start"
    -- print("start_para_lau")
    --print(farm_prog_progress)
    parallel.waitForAny(farm_gui_lau, start_farm_lau)
end

_G.stopfarm = 0
while _G.stopfarm ~= 1 do
    --update_start_farm()
    if not fs.exists("startup.lua") then
    --     local startup_farm = io.open("startup.lua", "w")
    --     startup_farm.write("sleep(5)\nshell.run(\"farm\", \"noset\")")
    --     startup_farm.close()
        ud.update(startup_update)
    end
    os.loadAPI("AndysPrograms/farm/farm")
    _G.andy_farm_program_running = 0
    if launcherargs[1] == "noset" then
        _G.andy_farm_program_running = 1
    end

    print("start")
    start_para_lau()
    _G.stopfarm = 1
    --parallel.waitForAny(farm_gui_lau, start_farm_lau)
end