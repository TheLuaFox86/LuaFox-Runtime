local buffer = ''
local function buff(data, ch)
	return '--[[' .. ch .. ']]--\n local f, r = load(' .. string.format('%q, %q, ', data .. "\nfor k, v in pairs(_G) do\n--log(k)\n if not _ENV[k] or k == \"class\" then _ENV[k] = v\n--log(true)\nelse\n--log(false)\nend end", '=' .. ch) .. '"t", _ENV)\nif f then ok, re =  pcall(f, ...)\n if not ok then log(re) end else log(tostring(r)) end\n'
end
local lfpp = require('lfpp')(function()
print('adding MAIN.lua to buffer')
buffer = buffer .. buff(fs.readAll("./src/MAIN.lua"), "ENGINE")
print('classtypes')
for i=0, 356 do
  for _, fn in ipairs(fs.list('./src/classtypes')) do
    if tonumber(fn:sub(1, 3)) == i then
    	print(fn)
      local f = fs.open('./src/classtypes/' .. fn, 'r')
      buffer = buffer .. buff(f:read('*all'), 'classtype: ' .. fn)
      f:close()
      break
    end
  end
end
print('classes:')
for i=0, 356 do
  for _, fn in ipairs(fs.list('./src/classes')) do
    if tonumber(fn:sub(1, 3)) == i then
    	print(fn)
      local f = fs.open('./src/classes/' .. fn, 'r')
      buffer = buffer .. buff(f:read('*all'), 'classtype: ' .. fn)
      f:close()
      break
    end
  end
end

print('building byte escaped strings')
local a = buffer
print(buffer)
fs.writeAll('./lfrt/buffer.lua', string.format("return %q", a))
a = 'local BuiltBuffer = require("lfrt.buffer") '
a = a .. fs.readAll("src/interface.lua")
local f = fs.open('./lfrt/init.lua', 'w+')
f:write(a)
f:flush()
f:close()
end)
