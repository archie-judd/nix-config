hs.window.animationDuration = 0

local hyper = { "ctrl", "alt", "cmd" }
local shiftHyper = { "ctrl", "alt", "cmd", "shift" }

local apps = {
	t = "Alacritty",
	c = "Claude",
	b = "Safari",
	o = "Obsidian",
	f = "Finder",
}

for key, name in pairs(apps) do
	hs.hotkey.bind(hyper, key, function()
		hs.application.launchOrFocus(name)
	end)
end

-- Fractions of the focused screen, as {x, y, w, h}.
local tiles = {
	h = { 0, 0, 0.5, 1 },
	l = { 0.5, 0, 0.5, 1 },
	k = { 0, 0, 1, 0.5 },
	j = { 0, 0.5, 1, 0.5 },
	z = { 0, 0, 1, 1 },
}

for key, unit in pairs(tiles) do
	hs.hotkey.bind(hyper, key, function()
		local win = hs.window.focusedWindow()
		if win then
			win:moveToUnit(unit)
		end
	end)
end

local displays = {
	h = "toWest",
	j = "toSouth",
	k = "toNorth",
	l = "toEast",
}

for key, direction in pairs(displays) do
	hs.hotkey.bind(shiftHyper, key, function()
		local win = hs.window.focusedWindow()
		if not win then
			return
		end
		local screen = win:screen()
		local target = screen[direction](screen)
		if target then
			win:moveToScreen(target)
		end
	end)
end

-- Mirrors GNOME's cycle-windows, which is scoped to the current workspace.
-- Front-to-back order reshuffles on every focus, which would strand the cycle
-- between two windows, so step through a ring ordered by window id instead.
local function cycleWindows(step)
	local windows = hs.window.orderedWindows()
	if #windows < 2 then
		return
	end
	table.sort(windows, function(a, b)
		return a:id() < b:id()
	end)
	local focused = hs.window.focusedWindow()
	local index = 1
	for i, win in ipairs(windows) do
		if focused and win:id() == focused:id() then
			index = i
			break
		end
	end
	windows[(index - 1 + step) % #windows + 1]:focus()
end

hs.hotkey.bind(hyper, "n", function()
	cycleWindows(1)
end)

hs.hotkey.bind(hyper, "p", function()
	cycleWindows(-1)
end)

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", hs.reload):start()
