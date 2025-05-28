-- local shell = os.getenv("SHELL")

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

-- Get current dir (ts not work for sum reason)
-- local current_dir = ya.sync(function()
--     return tostring(cx.active.current.cwd)
-- end)

-- Get file name
local function get_file_name(url)
    return url:match("^.+/(.+)$")
end

-- check if selected is a dir
local function isdir(path)
    return exists(path .. "/")
end

-- makes the install file (probably a better way to do it but i don't car)
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

-- runs ts cmd (unused rn until i fix the auto install)
-- local function run_command(cmd, args)
--     local cwd = current_dir()
--     local cmd_err = Command(cmd)
--         :args(args)
--         -- :cwd(cwd)
--         :stdin(Command.INHERIT)
--         :stdout(Command.PIPED)
--         :stderr(Command.PIPED)
--         :spawn()
-- end

return {
    entry = function()
        ya.mgr_emit("escape", { visual = true })

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
            local mk_status, mk_err = ya.sync(mk_yml_file(game_name, game_identifier, exe_path, pfx_path, is_win_game))
            -- this don't work either idk why
            -- if not mk_status or not mk_status.success then
            --     ya.notify({
            --         title = "Lutris",
            --         content = string.format("Ts not making: %s", mk_status and mk_status.code or mk_err),
            --         level = "error",
            --         timeout = 5
            --     })
            -- end
            ya.notify({
                title = "Lutris",
                content = 'Install by running "lutris -i ' .. game_identifier .. '.yml" or directly in the app',
                timeout = "10"
            })
        end
    end,
}
