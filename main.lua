return {
  entry = function()
    local value, event = ya.input({
      title = "Shell block:",
      position = { "top-center", y = 3, w = 40 },
    })
    if event == 1 then
      ya.manager_emit("shell", {
        "YAZI_SHELL_SKIP_CMD=true $SHELL -ic " .. ya.quote(value .. "; exit", true),
        block = true,
        confirm = true,
      })
    end
  end,
}
