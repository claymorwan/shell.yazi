-- Makes the box and run the command
function run_shell(isblock)
  local value, event = ya.input({
    title = "Shell" .. (isblock and " (block)" or ""),
    position = { "top-center", y = 3, w = 40 },
  })

  if event == 1 then
    ya.manager_emit("shell", {
      "YAZI_SHELL_SKIP_CMD=true $SHELL -ic " .. ya.quote(value .. "; exit", true),
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
      run_shell(true)
    -- No block
    elseif action == "noblock" then
      run_shell(false)
    end
  end,
}
