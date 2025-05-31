local current_dir = fs.cwd()

-- Get path of hovered file path
local path_sep = package.config:sub(1, 1)
local get_hovered_path = ya.sync(function(state)
	local h = cx.active.current.hovered
	if h then
		local path = tostring(h.url)
		if h.cha.is_dir then
			return path .. path_sep
		end
		return path
	else
		return 0
	end
end)

-- Get file name
local function get_file_name(url)
	return url:match("^.+/(.+)$")
end

-- makes the install file (probably a better way to do it but i don't car)
local function mk_yml_file(name, game_id, exe, pfx, is_wine)
	local runner = (is_wine and "wine" or "linux")
	local yml_file = io.open(game_id .. ".yml", "w")
	yml_lines = {
		"name: " .. name,
		"game_slug: " .. game_id,
		"version: Installer",
		"slug: " .. game_id .. "-installer",
		"runner: " .. runner .. "\n",
		"script:",
		" game:",
		"  exe: " .. exe,
		(is_wine and ("  prefix: " .. pfx) or ""),
	}
	for _, line in ipairs(yml_lines) do
		yml_file:write(line .. "\n")
	end
	yml_file:close()
end

local function err_notifier(status, err)
    if not status or not status.success then
        ya.notify {
            title = "Lutris",
            content = string.format("Failed to install, error: %s", status and status.code or err),
            level = "error",
            timeout = 5
        }
    end

end

local function make()
   	local exe_path = get_hovered_path()
   	-- Check if exe_path isn't a directory
   	if string.sub(exe_path, -1) == path_sep then
  		return ya.notify({ title = "Lutris", content = "No file selected", level = "warn", timeout = 5 })
   	else

  		-- Game name
  		local game_name = ya.input({
 			title = "Game name",
 			position = { "top-center", y = 3, w = 40 },
  		})


  		local is_win_game = (string.sub(exe_path, -4) == ".exe" and true or false)

  		if is_win_game then
 			pfx_path = ya.input({
    				title = "Wine prefix",
    				position = { "top-center", y = 3, w = 40 },
 			})
  		end

  		-- Make the game's identifier
  		Game_identifier = string.lower(game_name):gsub("% ", "-")

  		-- Makes the install file
  		mk_yml_file(game_name, Game_identifier, exe_path, pfx_path, is_win_game)
end

end

local function install(file)
    if  string.sub(file, -4) == ".yml" then
        -- Install script
        local status, err = Command("lutris")
        :arg("-i")
        :arg(file)
        :spawn()
        :wait()
        err_notifier(status, err)
        -- Removes it
        fs.remove("file", Url(file))
    else
        ya.notify({ title = "Lutris", content = "No install script", level = "warn", timeout = 5 })
    end
end

return {
    setup = setup,
	entry = function(self, jobs)
	    local action = jobs.args[1]
    	if action == "make" then
            make()
        elseif action == "install" then
            install(get_hovered_path())
        elseif action == "add" then
            make()
            install(current_dir .. path_sep .. Game_identifier .. ".yml")
		end
	end,
}
