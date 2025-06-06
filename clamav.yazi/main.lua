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

local function err_notify(status, err, content, level, timeout)
    if not status or not status.succes then
        ya.notify {
            title = "ClamAV",
            content = string.format(content .. " %s", status and status.code or err),
            level = level,
            timeout = timeout
        }
    end
end

local function run_cmd(cmd, file)
    ya.emit("shell", {
        cmd .. ya.quote(file, true) .. "; echo -en '\nPress [Enter] to continue'; read;", block = true, confirm = true })
end

return {
    entry = function(self, jobs)
        local action = jobs.args[1]
        local hovered = get_hovered_path()
        if action == "clamdscan" then
            run_cmd("clamdscan --fdpass ", hovered)
        elseif action == "clamscan" then
            run_cmd("clamscan ", hovered)
        end
    end
}
