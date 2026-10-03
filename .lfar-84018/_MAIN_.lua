--lfrt launcher--
local fs = class:getAPI("filesystem", 0)

--config--
local config = {

	prgp = fs.paths.lfrtBin, -- path to search for LFARs

	title = "Genaric LuaFox Runtime Application Launcher", --Title Of Launcher
	
	id="LuaFoxYT:GenaricLauncher",
	
	version = 000100000,
	
	terminal = "exo-open --launch terminalEmulator %q",
	
	extraInfoForLaunch = {},
}
--end--
local launchinfo = config.extraInfoForLaunch
launchinfo.lversion = config.version 
launchinfo.ltitle=config.title
launchinfo.lid= config.title
class.lfui.window.window({
title = config.title,
width=800,
height=400,
id="LuaFoxYT:window",
})
class.lfui.label.label({
label="loading...",
align={"CENTER", "CENTER"},
expand={true, true},
id="LuaFoxYT:Label0",
})
local win = class:getById("window", "LuaFoxYT:window")
local label = class:getById("label", "LuaFoxYT:Label0")
win:appendChild(label)
local list = {}
local files = ""
for i, f in ipairs(fs.list(config.prgp)) do
	if f:sub(-5, -1) == '.lfar' then
		list[i] = f
		files = files .. "[" .. i .. "]: " .. f:sub(1, -4) .. "\n"
	end
end
label.label = "apps to launch\n" .. files
label.align = {"CENTER", "CENTER"}
label.expand = {true, true}
label:update()
class.lfui.entry.entry({
	id="LuaFoxYT:num",
	text="1",
	align={"START", "END"},
	expand={false, true},
})
class.lfui.button.button({
	id="LuaFoxYT:launchAsGFX",
	label="Launch As Graphical Application",
	align={"START", "START"},
	expand={false, false},
})
class.lfui.button.button({
	id="LuaFoxYT:launchAsTerm",
	label="Launch As Terminal Application",
	align={"START", "START"},
	expand={false, false},
})
local num = class:getById("entry", "LuaFoxYT:num")
local lagfx = class:getById("button", "LuaFoxYT:launchAsGFX")
local latm = class:getById("button", "LuaFoxYT:launchAsTerm")
num.onSubmit = function()
	-- ("submited")
end
latm.onClick = function()
	num:fetch()
	os.execute(string.format(config.terminal, "lfrt lfar " .. string.format("%q", config.prgp .. list[tonumber(num.text)])) .. " &")
	win:destroy()
end
lagfx.onClick = function()
	num:fetch()
	os.execute("lfrt lfar " .. string.format("%q", config.prgp .. list[tonumber(num.text)]) .. " &")
	win:destroy()
end
class.lfui.label.label({
	id="LuaFoxYT:lfrt-v-dsp",
	label = "LuaFox-Runtime Version: ?",
	align={},
	expand={},
})
local vdsp = class:getById("label", "LuaFoxYT:lfrt-v-dsp")
num:update()
latm:update()
lagfx:update()
win:appendChild(num)
win:appendChild(vdsp)
--display current lfrt version--
local rt = class:getAPI("runtime", 1)
local text = vdsp.label:sub(1, -2)
local n = tostring(rt.version)
for i=1, 9 - #n do
	n = "0" .. n
end

if rt.isARelease then
	text = text .. "V"
elseif rt.isBeta then
	text = text .. "Beta "
elseif rt.isAlpha then
	text = text .. "Alpha "
vdsp.label = text
end
text = text .. tonumber(n:sub(1, 3)) .. "." .. tonumber(n:sub(4, 6)) .. "." .. tonumber(n:sub(7, 9))
vdsp.label = text
vdsp:update()
win:appendChild(lagfx)
win:appendChild(latm)
win:show()
win:loop()
