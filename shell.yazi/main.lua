-- Makes the box and run the command
local function run_shell(isblock, noskip)
	local value, event = ya.input({
		title = "Shell" .. (isblock and (noskip and " (block no skip)" or " (block)") or ""),
		position = { "top-center", y = 3, w = 40 },
	})

	local noskip_cmd = (noskip and "echo -en '\nPress [Enter] to continue'; read;" or "")

	if event == 1 then
		ya.manager_emit("shell", {
			"YAZI_SHELL_SKIP_CMD=true $SHELL -ic " .. ya.quote(value .. ";" .. noskip_cmd .. "exit", true),
			block = isblock,
			confirm = true,
		})
	end
end

return {
	entry = function(self, jobs)
		local action = jobs.args[1]
		if not action then
			return
		end
		-- Block
		if action == "block" then
			run_shell(true, false)
			-- No block
		elseif action == "noblock" then
			run_shell(false, false)
			-- Block, no skip
		elseif action == "noskip" then
			run_shell(true, true)
		end
	end,
}
