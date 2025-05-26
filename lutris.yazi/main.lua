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

local function get_file_name(url)
	return url:match("^.+/(.+)$")
end


local function isdir(path)
    return exists(path.."/")
end

local function mk_yml_file(name, game_id, exe, pfx, is_wine)
	local runner = (is_wine and "wine" or "linux")
    local yml_file = io.open(game_id .. ".yml", "w")
	yml_base_lines = {
	"name: " .. name,
	"game_slug: " .. game_id,
	"version: Installer",
	"slug: " .. game_id .. "-installer",
	"runner: " .. runner .. "\n",
	"script:", " game:",
	"  exe: " .. exe,
	(is_wine and ("  prefix: " .. pfx) or ""),
	}
	for _, line in ipairs(yml_base_lines) do
        yml_file:write(line .. "\n")
	end
	yml_file:close()
end

return {
	entry = function()
		ya.mgr_emit("escape", { visual = true })

		-- Check if directory exists

		local exe_path = get_hovered_path()
		-- Check if exe_path isn't a directory
		if string.sub(exe_path, -1) == path_sep then
			return ya.notify({ title = "Lutris", content = "No file selected", level = "warn", timeout = 5 })
		else
    		-- Input boxes
    		-- Game name
    		local game_name, event = ya.input({
    			title = "Game name",
    			position = { "top-center", y = 3, w = 40 },
    		})

            local is_win_game = (string.sub(exe_path, -4) == ".exe" and true or false)

    		if is_win_game then
      		pfx_path, event = ya.input({
      		    title = "Wine prefix",
     			position = { "top-center", y = 3, w = 40 },
      		})
    		end

    		-- Make the game's identifier
    		local game_identifier = string.lower(game_name):gsub("% ", "-")

    		-- Makes the install file
    		mk_yml_file(game_name, game_identifier,exe_path, pfx_path, is_win_game)

            ya.notify({ title = "Lutris", content = "install the fucking file now", level = "warn", timeout = 5 })
            -- os.execute("/usr/bin/lutris -i " .. game_identifier .. ".yml")
		end
	end,
}
