
do
	local L = require("linenoise")
	local reading = false
	local latest = ""
	local term = {
		write = function(txt)
			a = tostring(txt)
			latest = a
			io.write(a)
		end,
		read = function(callback, cont, text)
			argc(type(callback) == 'function', 'invalid argument #1, function expected got ' .. type(callback))
			argc(type(cont) == 'boolean', 'invalid argument #2, boolean expected got ' .. type(cont))
			--coroutine.resume(coroutine.create(function()
				--reading = true
				if cont then
					repeat
					ok, go = pcall(callback, L.linenoise((text or latest)))
					until not ok or go == true
				else
					local ok, r pcall(callback, L.linenoise((text or latest)))
					if ok == false then
						log('term.read error: ', r)
					end
				end
			--end))
		end,
		clear = function()
			return L.clearscreen()
		end
	}
	class.lfrt.api.api(term, 'lfrt:term', 0)
end
do
	local L = require("linenoise")
	local reading = false
	local latest = ""
	local term = {
		write = function(txt)
			a = tostring(txt)
			latest = a
			io.write(a)
		end,
		read = function(callback, cont, text)
			argc(type(callback) == 'function', 'invalid argument #1, function expected got ' .. type(callback))
			argc(type(cont) == 'boolean', 'invalid argument #2, boolean expected got ' .. type(cont))
			--coroutine.resume(coroutine.create(function()
				--reading = true
				if cont then
					repeat
					ok, go = pcall(callback, L.linenoise((text or latest)))
					until not ok or go == true
				else
					local ok, r pcall(callback, L.linenoise((text or latest)))
					if ok == false then
						log('term.read error: ', r)
					end
				end
			--end))
		end,
		clear = function()
			return L.clearscreen()
		end
	}
	class.lfrt.api.api(term, 'lfrt:term', 1)
end
do
	local L = require("linenoise")
	local t = require("term")
	local reading = false
	local full = ""
	local x, y = 0, 0
	local function get_terminal_size()
    -- Read terminal width and height via system tput utility
    local handle_w = io.popen("tput cols 2>/dev/null")
    local handle_h = io.popen("tput lines 2>/dev/null")
    
    local cols = tonumber(handle_w:read("*a"))
    local rows = tonumber(handle_h:read("*a"))
    
    handle_w:close()
    handle_h:close()
    
    -- Fallback to standard 80x24 layout if nil (e.g. non-TTY execution)
    return rows or 24, cols or 80
	end
	local term = {
		setcursor = t.cursor['goto'],
		colors = t.colors,
		write = function(txt)
			a = tostring(txt)
			full = full .. a
			io.write(a)
		  --update()	
		end,
		history = {
			load = function(...)
				return L.historyload(...)
			end,
			save = function(...)
				return L.historysave(...)
			end,
			add = function(...)
				return L.historyadd(...)
			end
		},
		
		read = function(callback, cont, text)
			argc(type(callback) == 'function', 'invalid argument #1, function expected got ' .. type(callback))
			argc(type(cont) == 'boolean', 'invalid argument #2, boolean expected got ' .. type(cont))
			--coroutine.resume(coroutine.create(function()
				--reading = true
				if cont then
					repeat
					local txt = L.linenoise((text or latest))
					full = full .. txt .. "\n"
					ok, go = pcall(callback, txt)
					until not ok or go == true
				else
					local txt = L.linenoise((text or latest))
					full = full .. txt .. "\n"
					local ok, r pcall(callback, txt)
					if ok == false then
						log('term.read error: ', r)
					end
				end
			--end))
		end,
		clear = function()
		  full = ""
			return L.clearscreen()
		end
	}
	class.lfrt.api.api(term, 'lfrt:term', 2)
end
