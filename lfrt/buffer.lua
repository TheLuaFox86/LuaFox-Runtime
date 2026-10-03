return "--[[ENGINE]]--\
 local f, r = load(\"_G.argc = function(value, msg, lv, ...)\\\
\\9for k, v in pairs({value, ...}) do\\\
    if not v then\\\
      error(msg, (lv or 3))\\\
    else\\\
      return value\\\
    end\\\
  end\\\
end\\\
_G.class =  {}\\\
class._searchers = {\\\
'lfrt',\\\
}\\\
class._types = {}\\\
function class:addSearcher(name, place)\\\
\\9local i = place\\\
\\9if place == nil then\\\
\\9\\9i = #self._searchers + 1\\\
\\9end\\\
\\9self._searchers[i] = name\\\
end\\\
function class:append(tb)\\\
\\9  argc(type(tb):match(\\\"ClassType \\\"), \\\"argument #1: expected ClassType got \\\", type(tb))\\\
  if not self[tb.domain] then self[tb.domain] = {} end\\\
  self[tb.domain][tb.type] = tb\\\
  self._types[tb.type] = tb\\\
end\\\
function class:getById(t, id)\\\
  argc(type(t) == \\\"string\\\", \\\"argument #1: expected string got \\\", type(t))\\\
  argc(type(id) == \\\"string\\\", \\\"argument #2: expected string got \\\", type(t))\\\
  local a = {}\\\
  for i, v in ipairs(id:split(\\\":\\\")) do\\\
    a[i]=v\\\
  end\\\
  if not a[2] then\\\
  \\9a[2] = a[1]\\\
    a[1] = self._searchers[1]\\\
    for i=1, #self._searchers do\\\
    \\9if self[self._searchers[i]] then\\\
    \\9\\9if self[self._searchers[i]][t] then\\\
    \\9\\9\\9if self[self._searchers[i]][t][a[2]] then\\\
    \\9\\9\\9\\9a[1] = self._searchers[i]\\\
    \\9\\9\\9\\9break\\\
    \\9\\9\\9end\\\
    \\9\\9end\\\
    \\9end\\\
    end\\\
  end\\\
  if not self[a[1]] then\\\
    return nil\\\
  elseif not self[a[1]][t] then\\\
    return nil\\\
  elseif not self[a[1]][t][a[2]] then\\\
    return nil\\\
  end\\\
  local b = {}\\\
  for k, v in pairs(self[a[1]][t][a[2]]) do\\\
    b[k] = v\\\
  end\\\
  return b\\\
end\\\
function class:setById(t, id, val)\\\
  argc(type(t) == \\\"string\\\", \\\"argument #1: expected string got \\\", type(t))\\\
  argc(type(id) == \\\"string\\\", \\\"argument #2: expected string got \\\", type(t))\\\
  argc(type(val):match(\\\"Class \\\"), \\\"argument #1: expected Class got \\\", type(t))\\\
  local a = {}\\\
  for i, v in ipairs(id:split(\\\":\\\")) do\\\
    a[i]=v\\\
  end\\\
  if not a[2] then\\\
    a[2] = a[1]\\\
    a[1] = self._searchers[1]\\\
    for i=1, #self._searchers do\\\
    \\9if self[self._searchers[i]] then\\\
    \\9\\9if self[self._searchers[i]][t] then\\\
    \\9\\9\\9if self[self._searchers[i]][t][a[2]] then\\\
    \\9\\9\\9\\9a[1] = self._searchers[i]\\\
    \\9\\9\\9\\9break\\\
    \\9\\9\\9end\\\
    \\9\\9end\\\
    \\9end\\\
    end\\\
  end\\\
  if not self[a[1]] then\\\
    self[a[1]] = {}\\\
  end\\\
  if not self[a[1]][t] then\\\
    self[a[1]][t] = self._types[t]\\\
  end\\\
  self[a[1]][t][a[2]] = val\\\
 end\\\
function class:newType(id, tb)\\\
  tb.domain = id:split(\\\":\\\")[1]\\\
  tb.type = id:split(\\\":\\\")[2]\\\
  tb.id = id\\\
  log(\\\"creating classtype: \\\" .. tb.type or \\\"?\\\")\\\
  local out = setmetatable(tb, {__index = function(s, k)\\\
    if k == id:split(\\\":\\\")[2] then\\\
      return function(...)\\\
        local a = tb.constructor(self, s, ...)\\\
        local obj = setmetatable(a, {__index = function(_s, _k)\\\
          if _k == \\\"push\\\" then\\\
            return function()\\\
              local c = {}\\\
              for k, _ in pairs(_s) do\\\
                c[k] = rawget(_s, k)\\\
              end\\\
              class:setById(tb.type, rawget(s, \\\"id\\\"), c)\\\
            end \\\
          elseif _k == \\\"pull\\\" then\\\
            return function()\\\
                for k, v in pairs(class:getById(tb.type, rawget(s, \\\"id\\\"))) do\\\
                  rawset(_s, k, v)\\\
                end\\\
            end\\\
          else\\\
            return rawget(_s, _k)\\\
          end\\\
        end, __newindex = function(_s, k, v)\\\
            rawset(_s, k, v)\\\
        end, __type=\\\"Class \\\" .. id})\\\
        class:setById(s.type, obj.id, obj)\\\
        log('added class: ' .. obj.id .. ' of type [' .. id:split(':')[2] .. ']')\\\
      end\\\
    else\\\
      return rawget(s, k)\\\
  \\9end\\\
  end, __type=\\\"ClassType \\\" .. id})\\\
  return out\\\
end\\\
function class:getAPI(id, version)\\\
  local a = self:getById(\\\"api\\\", id)\\\
  if not a then\\\
  \\9error('API not defined (API: ' .. id .. ' v' .. version, 2)\\\
  end\\\
  local b = a.VERSIONS[version]\\\
  if not b then\\\
  \\9error('API of that version not available (API: ' .. id .. ' v' .. version, 2)\\\
  end\\\
  b.version = version\\\
  setmetatable(b, {__index=function(s, k)\\\
    if k == \\\"pull\\\" then\\\
      return function()\\\
        s = _G.class:getById('api', id).VERSIONS[version]\\\
      end\\\
    elseif k == 'push' then\\\
      return function()\\\
        local c = _G.class:getById('api', id)\\\
        local d = {}\\\
        for _k, _v in pairs(s) do\\\
          d[_k] = rawget(s, _k)\\\
        end\\\
        c.VERSIONS[version] = d\\\
        _G.class:setById('api', id, c)\\\
      end\\\
    else\\\
    \\9return rawget(s, k)\\\
    end\\\
  end, __newindex = function(s, k, v)\\\
    rawset(s, k, v)\\\
  end, __type=\\\"Class lfrt:api\\\"})\\\
  return b\\\
end\\\
function class:config(key)\\\
\\9local cfg = {\\\
\\9\\9[\\\"Beta-Mode\\\"] = false,\\\
\\9}\\\
\\9return cfg[key]\\\
end\\\
\\\
for k, v in pairs(_G) do\\\
--log(k)\\\
 if not _ENV[k] or k == \\\"class\\\" then _ENV[k] = v\\\
--log(true)\\\
else\\\
--log(false)\\\
end end\", \"=ENGINE\", \"t\", _ENV)\
if f then ok, re =  pcall(f, ...)\
 if not ok then log(re) end else log(tostring(r)) end\
--[[classtype: 001-api.lua]]--\
 local f, r = load(\"--creation of api ClassType--\\\
class:append(class:newType(\\\"lfrt:api\\\", {\\\
  constructor = function(cls, clst, api, id, version)\\\
  \\9log('creating api: ' .. id .. ' version ' .. version)\\\
    local a = {VERSIONS={}, id=id}\\\
    if cls:getById(\\\"api\\\", id) then\\\
      a = (cls:getById(\\\"api\\\", id) or {VERSIONS={}, id=id})\\\
    end\\\
    a.VERSIONS[version] = api\\\
    return a\\\
  end\\\
}))\\\
\\\
for k, v in pairs(_G) do\\\
--log(k)\\\
 if not _ENV[k] or k == \\\"class\\\" then _ENV[k] = v\\\
--log(true)\\\
else\\\
--log(false)\\\
end end\", \"=classtype: 001-api.lua\", \"t\", _ENV)\
if f then ok, re =  pcall(f, ...)\
 if not ok then log(re) end else log(tostring(r)) end\
--[[classtype: 002-term.lua]]--\
 local f, r = load(\"\\\
do\\\
\\9local L = require(\\\"linenoise\\\")\\\
\\9local reading = false\\\
\\9local latest = \\\"\\\"\\\
\\9local term = {\\\
\\9\\9write = function(txt)\\\
\\9\\9\\9a = tostring(txt)\\\
\\9\\9\\9latest = a\\\
\\9\\9\\9io.write(a)\\\
\\9\\9end,\\\
\\9\\9read = function(callback, cont, text)\\\
\\9\\9\\9argc(type(callback) == 'function', 'invalid argument #1, function expected got ' .. type(callback))\\\
\\9\\9\\9argc(type(cont) == 'boolean', 'invalid argument #2, boolean expected got ' .. type(cont))\\\
\\9\\9\\9--coroutine.resume(coroutine.create(function()\\\
\\9\\9\\9\\9--reading = true\\\
\\9\\9\\9\\9if cont then\\\
\\9\\9\\9\\9\\9repeat\\\
\\9\\9\\9\\9\\9ok, go = pcall(callback, L.linenoise((text or latest)))\\\
\\9\\9\\9\\9\\9until not ok or go == true\\\
\\9\\9\\9\\9else\\\
\\9\\9\\9\\9\\9local ok, r pcall(callback, L.linenoise((text or latest)))\\\
\\9\\9\\9\\9\\9if ok == false then\\\
\\9\\9\\9\\9\\9\\9log('term.read error: ', r)\\\
\\9\\9\\9\\9\\9end\\\
\\9\\9\\9\\9end\\\
\\9\\9\\9--end))\\\
\\9\\9end,\\\
\\9\\9clear = function()\\\
\\9\\9\\9return L.clearscreen()\\\
\\9\\9end\\\
\\9}\\\
\\9class.lfrt.api.api(term, 'lfrt:term', 0)\\\
end\\\
do\\\
\\9local L = require(\\\"linenoise\\\")\\\
\\9local reading = false\\\
\\9local latest = \\\"\\\"\\\
\\9local term = {\\\
\\9\\9write = function(txt)\\\
\\9\\9\\9a = tostring(txt)\\\
\\9\\9\\9latest = a\\\
\\9\\9\\9io.write(a)\\\
\\9\\9end,\\\
\\9\\9read = function(callback, cont, text)\\\
\\9\\9\\9argc(type(callback) == 'function', 'invalid argument #1, function expected got ' .. type(callback))\\\
\\9\\9\\9argc(type(cont) == 'boolean', 'invalid argument #2, boolean expected got ' .. type(cont))\\\
\\9\\9\\9--coroutine.resume(coroutine.create(function()\\\
\\9\\9\\9\\9--reading = true\\\
\\9\\9\\9\\9if cont then\\\
\\9\\9\\9\\9\\9repeat\\\
\\9\\9\\9\\9\\9ok, go = pcall(callback, L.linenoise((text or latest)))\\\
\\9\\9\\9\\9\\9until not ok or go == true\\\
\\9\\9\\9\\9else\\\
\\9\\9\\9\\9\\9local ok, r pcall(callback, L.linenoise((text or latest)))\\\
\\9\\9\\9\\9\\9if ok == false then\\\
\\9\\9\\9\\9\\9\\9log('term.read error: ', r)\\\
\\9\\9\\9\\9\\9end\\\
\\9\\9\\9\\9end\\\
\\9\\9\\9--end))\\\
\\9\\9end,\\\
\\9\\9clear = function()\\\
\\9\\9\\9return L.clearscreen()\\\
\\9\\9end\\\
\\9}\\\
\\9class.lfrt.api.api(term, 'lfrt:term', 1)\\\
end\\\
do\\\
\\9local L = require(\\\"linenoise\\\")\\\
\\9local t = require(\\\"term\\\")\\\
\\9local reading = false\\\
\\9local full = \\\"\\\"\\\
\\9local x, y = 0, 0\\\
\\9local function get_terminal_size()\\\
    -- Read terminal width and height via system tput utility\\\
    local handle_w = io.popen(\\\"tput cols 2>/dev/null\\\")\\\
    local handle_h = io.popen(\\\"tput lines 2>/dev/null\\\")\\\
    \\\
    local cols = tonumber(handle_w:read(\\\"*a\\\"))\\\
    local rows = tonumber(handle_h:read(\\\"*a\\\"))\\\
    \\\
    handle_w:close()\\\
    handle_h:close()\\\
    \\\
    -- Fallback to standard 80x24 layout if nil (e.g. non-TTY execution)\\\
    return rows or 24, cols or 80\\\
\\9end\\\
\\9local term = {\\\
\\9\\9setcursor = t.cursor['goto'],\\\
\\9\\9colors = t.colors,\\\
\\9\\9write = function(txt)\\\
\\9\\9\\9a = tostring(txt)\\\
\\9\\9\\9full = full .. a\\\
\\9\\9\\9io.write(a)\\\
\\9\\9  --update()\\9\\\
\\9\\9end,\\\
\\9\\9history = {\\\
\\9\\9\\9load = function(...)\\\
\\9\\9\\9\\9return L.historyload(...)\\\
\\9\\9\\9end,\\\
\\9\\9\\9save = function(...)\\\
\\9\\9\\9\\9return L.historysave(...)\\\
\\9\\9\\9end,\\\
\\9\\9\\9add = function(...)\\\
\\9\\9\\9\\9return L.historyadd(...)\\\
\\9\\9\\9end\\\
\\9\\9},\\\
\\9\\9\\\
\\9\\9read = function(callback, cont, text)\\\
\\9\\9\\9argc(type(callback) == 'function', 'invalid argument #1, function expected got ' .. type(callback))\\\
\\9\\9\\9argc(type(cont) == 'boolean', 'invalid argument #2, boolean expected got ' .. type(cont))\\\
\\9\\9\\9--coroutine.resume(coroutine.create(function()\\\
\\9\\9\\9\\9--reading = true\\\
\\9\\9\\9\\9if cont then\\\
\\9\\9\\9\\9\\9repeat\\\
\\9\\9\\9\\9\\9local txt = L.linenoise((text or latest))\\\
\\9\\9\\9\\9\\9full = full .. txt .. \\\"\\\\n\\\"\\\
\\9\\9\\9\\9\\9ok, go = pcall(callback, txt)\\\
\\9\\9\\9\\9\\9until not ok or go == true\\\
\\9\\9\\9\\9else\\\
\\9\\9\\9\\9\\9local txt = L.linenoise((text or latest))\\\
\\9\\9\\9\\9\\9full = full .. txt .. \\\"\\\\n\\\"\\\
\\9\\9\\9\\9\\9local ok, r pcall(callback, txt)\\\
\\9\\9\\9\\9\\9if ok == false then\\\
\\9\\9\\9\\9\\9\\9log('term.read error: ', r)\\\
\\9\\9\\9\\9\\9end\\\
\\9\\9\\9\\9end\\\
\\9\\9\\9--end))\\\
\\9\\9end,\\\
\\9\\9clear = function()\\\
\\9\\9  full = \\\"\\\"\\\
\\9\\9\\9return L.clearscreen()\\\
\\9\\9end\\\
\\9}\\\
\\9class.lfrt.api.api(term, 'lfrt:term', 2)\\\
end\\\
\\\
for k, v in pairs(_G) do\\\
--log(k)\\\
 if not _ENV[k] or k == \\\"class\\\" then _ENV[k] = v\\\
--log(true)\\\
else\\\
--log(false)\\\
end end\", \"=classtype: 002-term.lua\", \"t\", _ENV)\
if f then ok, re =  pcall(f, ...)\
 if not ok then log(re) end else log(tostring(r)) end\
--[[classtype: 003-filesystem.lua]]--\
 local f, r = load(\"class.lfrt.api.api(fs, 'lfrt:filesystem', 0)\\\
do\\\
\\9local fsa = {}\\\
\\9for k, v in pairs(fs) do\\\
\\9\\9fsa[k] = rawget(fs, k)\\\
\\9end\\\
\\9--custom lfrt filesystem functions here (if i add)--\\\
\\9fsa.open = nil\\\
\\9--end--\\\
\\9class.lfrt.api.api(fsa, \\\"lfrt:filesystem\\\", 1)\\\
end\\\
\\\
for k, v in pairs(_G) do\\\
--log(k)\\\
 if not _ENV[k] or k == \\\"class\\\" then _ENV[k] = v\\\
--log(true)\\\
else\\\
--log(false)\\\
end end\", \"=classtype: 003-filesystem.lua\", \"t\", _ENV)\
if f then ok, re =  pcall(f, ...)\
 if not ok then log(re) end else log(tostring(r)) end\
--[[classtype: 004-tbfs.lua]]--\
 local f, r = load(\"do\\\
\\9local fs = class:getAPI(\\\"filesystem\\\", 0)\\\
  local tbfs = {}\\\
  tbfs.read = function(ap, fp)\\\
  \\9argc(type(ap) == 'string', 'invalid argument #1; expected string got ' .. type(ap))\\\
  \\9argc(type(fp) == 'string', 'invalid argument #2; expected string got ' .. type(fp))\\\
  \\9argc(fs.exists(ap), 'archive not found at ' .. ap)\\\
     local dat = table.parse(fs.readAll(ap))[fp]\\\
     argc(dat, 'file in archive not found at' .. fp)\\\
    return dat\\\
  end\\\
  function tbfs.extract(fr, to)\\\
  \\9argc(type(fr) == 'string', 'invalid argument #1; expected string got ' .. type(fr))\\\
  \\9argc(type(to) == 'string', 'invalid argument #2; expected string got ' .. type(to))\\\
  \\9argc(fs.exists(fr), 'file not found; ' .. fr)\\\
    local f = fs.open(fr, 'r')\\\
    local tb = table.parse(f:read('*all'))\\\
    f:close()\\\
    for path, stats in pairs(tb) do\\\
      fs.create(to .. path, stats.content)\\\
    end\\\
  end\\\
  function tbfs.compress(from, to)\\\
  \\9argc(type(from) == 'string', 'invalid argument #1; expected string got ' .. type(from))\\\
  \\9argc(type(to) == 'string', 'invalid argument #2; expected string got ' .. type(to))\\\
  \\9argc(fs.exists(from), 'file not found; ' .. from)\\\
  \\9local tb = {}\\\
  \\9for _, fn in ipairs(fs.list(from, false, true)) do\\\
  \\9\\9if fs.attributes(from .. fn).mode == 'file' then\\\
  \\9\\9\\9local f = fs.open(from .. fn, 'rb')\\\
  \\9\\9\\9local dat = f:read('*all')\\\
  \\9\\9\\9f:flush()\\\
  \\9\\9\\9f:close()\\\
  \\9\\9\\9tb[fn] = {type='file', content=dat, date=0}\\\
  \\9\\9else\\\
  \\9\\9\\9tb[fn] = {type='dir', date=0}\\\
  \\9\\9end\\\
  \\9end\\\
  \\9local f = fs.open(to, 'w+')\\\
  \\9f:write(table.stringify(tb))\\\
  \\9f:flush()\\\
  \\9f:close()\\\
  end\\\
\\9class.lfrt.api.api(tbfs, 'lfrt:tbfs', 0)\\\
end\\\
\\\
do\\\
\\9local fs = class:getAPI(\\\"filesystem\\\", 1)\\\
  local tbfs = {}\\\
  tbfs.read = function(ap, fp)\\\
  \\9argc(type(ap) == 'string', 'invalid argument #1; expected string got ' .. type(ap))\\\
  \\9argc(type(fp) == 'string', 'invalid argument #2; expected string got ' .. type(fp))\\\
  \\9argc(fs.exists(ap), 'archive not found at ' .. ap)\\\
     local dat = table.parse(fs.readAll(ap))[fp]\\\
     argc(dat, 'file in archive not found at' .. fp)\\\
    return dat\\\
  end\\\
  function tbfs.extract(fr, to)\\\
  \\9argc(type(fr) == 'string', 'invalid argument #1; expected string got ' .. type(fr))\\\
  \\9argc(type(to) == 'string', 'invalid argument #2; expected string got ' .. type(to))\\\
  \\9argc(fs.exists(fr), 'file not found; ' .. fr)\\\
    local tb = table.parse(fs.readAll(fr))\\\
    for path, stats in pairs(tb) do\\\
      fs.create(to .. path, stats.content)\\\
    end\\\
  end\\\
  function tbfs.compress(from, to)\\\
  \\9argc(type(from) == 'string', 'invalid argument #1; expected string got ' .. type(from))\\\
  \\9argc(type(to) == 'string', 'invalid argument #2; expected string got ' .. type(to))\\\
  \\9argc(fs.exists(from), 'file not found; ' .. from)\\\
  \\9local tb = {}\\\
  \\9for _, fn in ipairs(fs.list(from, false, true)) do\\\
  \\9\\9if fs.attributes(from .. fn).mode == 'file' then\\\
  \\9\\9\\9tb[fn] = {type='file', content=fs.readAll(from .. fn), date=0}\\\
  \\9\\9else\\\
  \\9\\9\\9tb[fn] = {type='dir', date=0}\\\
  \\9\\9end\\\
  \\9end\\\
  \\9fs.writeAll(table.stringify(tb))\\\
  end\\\
\\9class.lfrt.api.api(tbfs, 'lfrt:tbfs', 1)\\\
end\\\
\\\
\\\
for k, v in pairs(_G) do\\\
--log(k)\\\
 if not _ENV[k] or k == \\\"class\\\" then _ENV[k] = v\\\
--log(true)\\\
else\\\
--log(false)\\\
end end\", \"=classtype: 004-tbfs.lua\", \"t\", _ENV)\
if f then ok, re =  pcall(f, ...)\
 if not ok then log(re) end else log(tostring(r)) end\
--[[classtype: 005-json.lua]]--\
 local f, r = load(\"class.lfrt.api.api((require('lunajson') or {}), 'lfrt:json', 0)\\\
\\\
for k, v in pairs(_G) do\\\
--log(k)\\\
 if not _ENV[k] or k == \\\"class\\\" then _ENV[k] = v\\\
--log(true)\\\
else\\\
--log(false)\\\
end end\", \"=classtype: 005-json.lua\", \"t\", _ENV)\
if f then ok, re =  pcall(f, ...)\
 if not ok then log(re) end else log(tostring(r)) end\
--[[classtype: 006-lfpk.lua]]--\
 local f, r = load(\"do\\\
\\9local tbfs = class:getAPI(\\\"tbfs\\\", 0)\\\
\\9local fs = class:getAPI(\\\"filesystem\\\", 0)\\\
\\9local lfpk = {installed = {}}\\\
\\9if fs.exists(fs.paths.AppData .. 'lfpk-lfrt.installed') then\\\
\\9\\9lfpk.installed = table.parse(fs.readAll(fs.paths.AppData .. 'lfpk-lfrt.installed'))\\\
\\9end\\\
\\9function lfpk.update(self, obj, isRM)\\\
\\9\\9if not isRM then\\\
\\9\\9\\9local inf = obj.info\\\
\\9\\9\\9self.installed[inf.packageID] = inf\\\
\\9\\9else\\\
\\9\\9\\9self.installed[obj.info.packageID] = nil\\\
\\9\\9end\\\
\\9\\9fs.writeAll(fs.paths.AppData .. 'lfpk-lfrt.installed', table.stringify(self.installed))\\\
\\9end\\9\\9\\\
\\9function lfpk.parse(self, path)\\\
\\9\\9local obj = {}\\\
\\9\\9obj.info = table.parse(tbfs.read(path, \\\"/_INFO_.lua\\\").content)\\\
\\9\\9obj.files = {}\\\
\\9\\9local a = table.parse(tbfs.read(path, '/_FILES_.tbfs').content)\\\
\\9\\9for entryPath, entry in pairs(a) do\\\
\\9\\9\\9local b = entryPath\\\
\\9\\9\\9for template, templatePath in pairs(fs.paths) do\\\
\\9\\9\\9\\9local c = entryPath:split(\\\"/\\\")[2]\\\
\\9\\9\\9\\9log(b, c, template, templatePath, 1)\\\
\\9\\9\\9\\9if c == template then\\\
\\9\\9\\9\\9\\9b = templatePath:sub(1, -2)\\\
\\9\\9\\9\\9\\9for i, v in ipairs(entryPath:split('/')) do\\\
\\9\\9\\9\\9\\9\\9if i > 2 then b = b .. \\\"/\\\" .. v end\\\
\\9\\9\\9\\9\\9end\\\
\\9\\9\\9\\9end\\\
\\9\\9\\9\\9log(b, c, template, templatePath, 2)\\\
\\9\\9\\9end\\\
\\9\\9\\9obj.files[b] = entry\\\
\\9\\9end\\\
\\9\\9local d = obj.info.packageDependencies\\\
\\9\\9for entryPath, entry in pairs(d) do\\\
\\9\\9\\9local b = entryPath\\\
\\9\\9\\9for template, templatePath in pairs(fs.paths) do\\\
\\9\\9\\9\\9log(b, template, templatePath, 1)\\\
\\9\\9\\9\\9local f = b\\\
\\9\\9\\9\\9local e = f:sub(2, 26)\\\
\\9\\9\\9\\9local name = template .. (\\\"_\\\"):rep(25 - #template)\\\
\\9\\9\\9\\9if e == name then\\\
\\9\\9\\9\\9\\9b = '/' .. templatePath .. b:sub(27, #b)\\\
\\9\\9\\9\\9end\\\
\\9\\9\\9\\9log(b, template, templatePath, 2)\\\
\\9\\9\\9end\\\
\\9\\9\\9obj.info.packageDependencies[b] = entry\\\
\\9\\9end\\\
\\9\\9return obj\\\
\\9end\\\
\\9function lfpk.generate(self, obj, path)\\\
\\9\\9local tmp = fs.pwd() .. \\\"/.temp-\\\" .. math.random(99999) .. '/'\\\
\\9\\9fs.create(tmp .. '_INFO_.lua', table.stringify(obj.info))\\\
\\9\\9fs.create(tmp .. '_FILES_.tbfs', table.stringify(obj.files))\\\
\\9\\9tbfs.compress(tmp, path or './' .. obj.info.packageID .. '.lfpk')\\\
\\9\\9fs.remove(tmp)\\\
\\9end\\\
\\9lfpk.install = function(self, obj)\\\
\\9\\9fs.writeAll('./temp.tbfs', table.stringify(obj.files))\\\
\\9\\9tbfs.extract('./temp.tbfs', '/')\\\
\\9\\9self:update(obj, true)\\\
\\9end\\\
\\9function lfpk.uninstall(self, obj)\\\
\\9\\9for k, v in pairs(self.installed[obj.info.packageID].files) do\\\
\\9\\9\\9if v then\\\
\\9\\9\\9\\9log(\\\"removing \\\" .. v)\\\
\\9\\9\\9\\9fs.remove(k)\\\
\\9\\9\\9else\\\
\\9\\9\\9\\9log(\\\"skipping \\\" .. v)\\\
\\9\\9\\9end\\\
\\9\\9end\\\
\\9end\\\
\\9class.lfrt.api.api(lfpk, 'lfrt:lfpk', 0)\\\
end\\\
\\\
for k, v in pairs(_G) do\\\
--log(k)\\\
 if not _ENV[k] or k == \\\"class\\\" then _ENV[k] = v\\\
--log(true)\\\
else\\\
--log(false)\\\
end end\", \"=classtype: 006-lfpk.lua\", \"t\", _ENV)\
if f then ok, re =  pcall(f, ...)\
 if not ok then log(re) end else log(tostring(r)) end\
--[[classtype: 008-gui.lua]]--\
 local f, r = load(\"--luafox ui library--\\\
if true then\\\
\\9log(\\\"checking for luagoobject\\\")\\\
\\9local ok, lgi = pcall(require, \\\"LuaGObject\\\")\\\
\\9if lgi then log(\\\"found!\\\") else error(\\\"Could Not Load LFui: not found are you on linux if so make sure you installed LuaGObject and its dependancies\\\", 0) end\\\
\\9local Gtk = lgi.require(\\\"Gtk\\\", '3.0')\\\
\\9local gio = lgi.Gio\\\
\\9local glib = lgi.GLib\\\
\\9class:append(class:newType(\\\"lfui:window\\\", {\\\
\\9\\9constructor=function(cls, clst, obj0)\\\
\\9\\9\\9local obj = {}\\\
\\9\\9\\9obj.title = (obj0.title or \\\"Blank LuaFoxUI Window\\\")\\\
\\9\\9\\9obj.default_width=(obj0.width or 400)\\\
\\9\\9\\9obj.default_height=(obj0.height or 200)\\\
\\9\\9\\9obj.on_destroy = Gtk.main_quit\\\
\\9\\9\\9local win = obj0\\\
\\9\\9\\9win._window = Gtk.Window(obj)\\\
\\9\\9\\9win._obj = Gtk.Box({\\\
\\9\\9\\9\\9orientation = Gtk.Orientation.VERTICAL,\\\
\\9\\9\\9\\9spacing = 10,\\\
\\9\\9\\9})\\\
\\9\\9\\9win._window:add(win._obj)\\\
\\9\\9\\9function win:show()\\\
\\9\\9\\9\\9self._window:show_all()\\\
\\9\\9\\9end\\\
\\9\\9\\9function win:appendChild(v)\\\
\\9\\9\\9\\9self._obj:add(v._obj)\\\
\\9\\9\\9end\\\
\\9\\9\\9function win:loop()\\\
\\9\\9\\9\\9Gtk.main()\\\
\\9\\9\\9end\\\
\\9\\9\\9function win:destroy()\\\
\\9\\9\\9\\9self._window:close()\\\
\\9\\9\\9end\\\
\\9\\9\\9return win\\\
\\9\\9end\\\
\\9}))\\\
\\9--widget creator handler--\\\
\\9function whandle(func, props, obj0)\\\
\\9\\9local obj = {}\\\
\\9\\9for k, v in pairs(props) do\\\
\\9\\9\\9obj[v.rKey] = obj0[k]\\\
\\9\\9end \\\
\\9\\9obj.halign = Gtk.Align[(obj0.align[1] or \\\"START\\\")]\\\
\\9\\9obj.valign = Gtk.Align[(obj0.align[2] or \\\"START\\\")]\\\
\\9\\9obj.hexpand = obj0.expand[1]\\\
\\9\\9obj.vexpand = obj0.expand[2]\\\
\\9\\9local box = obj0\\\
\\9\\9box._obj = func(obj)\\\
\\9\\9function box:update()\\\
\\9\\9\\9local obj = {}\\\
\\9\\9\\9for k, v in pairs(props) do\\\
\\9\\9\\9\\9obj[v.rKey] = self[k]\\\
\\9\\9\\9end \\\
\\9\\9\\9obj.halign = Gtk.Align[(self.align[1] or \\\"START\\\")]\\\
\\9\\9\\9obj.valign = Gtk.Align[(self.align[2] or \\\"START\\\")]\\\
\\9\\9\\9obj.hexpand = self.expand[1]\\\
\\9\\9\\9obj.vexpand = self.expand[2]\\\
\\9\\9\\9for k, v in pairs(obj) do\\\
\\9\\9\\9\\9if k:sub(1, 3) == \\\"on_\\\" then\\\
\\9\\9\\9\\9\\9self._obj[k] = v\\\
\\9\\9\\9\\9else\\\
\\9\\9\\9\\9\\9self._obj[\\\"set_\\\" .. k](self._obj, v)\\\
\\9\\9\\9\\9end\\\
\\9\\9\\9end\\\
\\9\\9end\\\
\\9\\9function box:fetch()\\\
\\9\\9\\9for k, v in pairs(props) do\\\
\\9\\9\\9\\9if v.rKey:sub(1, 3) == \\\"on_\\\" then\\\
\\9\\9\\9\\9\\9self[k] = self._obj[v.rKey]\\\
\\9\\9\\9\\9else\\\
\\9\\9\\9\\9\\9self[k] = self._obj['get_' .. v.rKey](self._obj)\\\
\\9\\9\\9\\9end\\\
\\9\\9\\9end\\\
\\9\\9end\\\
\\9\\9function box:destroy()\\\
\\9\\9\\9self._obj:destroy()\\\
\\9\\9end\\\
\\9\\9return box\\\
\\9end\\\
\\\
\\9class:append(class:newType(\\\"lfui:label\\\", {\\\
\\9\\9constructor=function(cls, clst, obj0)\\\
\\9\\9\\9return whandle(Gtk.Label, {label = {rKey='label'}}, obj0)\\\
\\9\\9end\\\
\\9}))\\\
\\9class:append(class:newType(\\\"lfui:button\\\", {\\\
\\9\\9constructor=function(cls, clst, obj0)\\\
\\9\\9\\9return whandle(Gtk.Button, {label = {rKey='label'}, onClick={rKey=\\\"on_clicked\\\"}}, obj0)\\\
\\9\\9end\\\
\\9}))\\\
\\9class:append(class:newType(\\\"lfui:entry\\\", {\\\
\\9\\9constructor=function(cls, clst, obj0)\\\
\\9\\9\\9return whandle(Gtk.Entry, {onSubmit={rKey=\\\"on_activate\\\"}, text={rKey=\\\"text\\\"}}, obj0)\\\
\\9\\9end\\\
\\9}))\\\
else\\\
\\9log(\\\"not loading: unsupported platformn only works on luafoxOS\\\")\\\
end\\\
\\\
for k, v in pairs(_G) do\\\
--log(k)\\\
 if not _ENV[k] or k == \\\"class\\\" then _ENV[k] = v\\\
--log(true)\\\
else\\\
--log(false)\\\
end end\", \"=classtype: 008-gui.lua\", \"t\", _ENV)\
if f then ok, re =  pcall(f, ...)\
 if not ok then log(re) end else log(tostring(r)) end\
--[[classtype: 356-runtime.lua]]--\
 local f, r = load(\"local lfar = require(\\\"lfrt.lfar\\\")\\\
local tbfs = class:getAPI(\\\"tbfs\\\", 0)\\\
local fs = class:getAPI(\\\"filesystem\\\", 0)\\\
--local lfsp = require('lfsp')\\\
class.lfrt.api.api({\\\
  _searchers = {lfarP .. \\\"lib/\\\", fs.paths.lfrtLib, './_lib_'},\\\
  loadLib = function(self, name, ...)\\\
    local tb\\\
    local ok, reason\\\
    for _, path in ipairs(self._searchers) do\\\
      ok, reason = pcall(function(...)\\\
        for _, v in ipairs(fs.list(path)) do\\\
          if v:sub(#v - (#name + 6), #v) == '/' .. name .. '.lfar' then\\\
            tbfs.extract(path .. v, lfarP .. 'lib/' .. name .. '/')\\\
            local env = {}\\\
            for k, v in pairs(_ENV) do\\\
              if k == \\\"lfarP\\\" then\\\
                env.parentP = v\\\
                env.lfarP = lfarP .. 'lib/' .. name .. '/'\\\
              else\\\
                env[k] = v\\\
              end\\\
            end\\\
            env._G = env\\\
            local chunk, loadErr = loadfile(lfarP .. 'lib/' .. name .. '/_MAIN_.lua', 't', env)\\\
            if not chunk then\\\
              error(loadErr)\\\
            end\\\
            local ok_load, tb_loaded = pcall(chunk, ...)\\\
            if ok_load and type(tb_loaded) == 'table' then\\\
              class.api.api(tb_loaded, tb_loaded.moduleID, tb_loaded.moduleVersion)\\\
              tb = tb_loaded\\\
            end\\\
          end\\\
        end\\\
      end, ...)\\\
      if ok then\\\
        break\\\
      end\\\
    end\\\
    if tb then\\\
      return {tb.moduleID, tb.moduleVersion}\\\
    end\\\
    return nil, reason\\\
  end,\\\
  version=1,\\\
  isAlpha=true,\\\
  isBeta=false,\\\
  isRelease=false,\\\
}, 'lfrt:runtime', 0)\\\
local lfar = require(\\\"lfrt.lfar\\\")\\\
local tbfs = class:getAPI(\\\"tbfs\\\", 0)\\\
local fs = class:getAPI(\\\"filesystem\\\", 0)\\\
--local lfsp = require('lfsp')\\\
class.lfrt.api.api({\\\
  _searchers = {lfarP .. \\\"lib/\\\", fs.paths.lfrtLib, './_lib_'},\\\
  loadLib = function(self, name, ...)\\\
    local tb\\\
    local ok, reason\\\
    for _, path in ipairs(self._searchers) do\\\
      ok, reason = pcall(function(...)\\\
        for _, v in ipairs(fs.list(path)) do\\\
          if v:sub(#v - (#name + 6), #v) == '/' .. name .. '.lfar' then\\\
            tbfs.extract(path .. v, lfarP .. 'lib/' .. name .. '/')\\\
            local env = {}\\\
            for k, v in pairs(_ENV) do\\\
              if k == \\\"lfarP\\\" then\\\
                env.parentP = v\\\
                env.lfarP = lfarP .. 'lib/' .. name .. '/'\\\
              else\\\
                env[k] = v\\\
              end\\\
            end\\\
            env._G = env\\\
            local chunk, loadErr = loadfile(lfarP .. 'lib/' .. name .. '/_MAIN_.lua', 't', env)\\\
            if not chunk then\\\
              error(loadErr)\\\
            end\\\
            local ok_load, tb_loaded = pcall(chunk, ...)\\\
            if ok_load and type(tb_loaded) == 'table' then\\\
              class.api.api(tb_loaded, tb_loaded.moduleID, tb_loaded.moduleVersion)\\\
              tb = tb_loaded\\\
            end\\\
          end\\\
        end\\\
      end, ...)\\\
      if ok then\\\
        break\\\
      end\\\
    end\\\
    if tb then\\\
      return {tb.moduleID, tb.moduleVersion}\\\
\\9\\9end\\\
    return nil, reason\\\
  end,\\\
  version=1,\\\
  isAlpha=true,\\\
  isBeta=false,\\\
  isRelease=false,\\\
}, 'lfrt:runtime', 1)\\\
\\\
for k, v in pairs(_G) do\\\
--log(k)\\\
 if not _ENV[k] or k == \\\"class\\\" then _ENV[k] = v\\\
--log(true)\\\
else\\\
--log(false)\\\
end end\", \"=classtype: 356-runtime.lua\", \"t\", _ENV)\
if f then ok, re =  pcall(f, ...)\
 if not ok then log(re) end else log(tostring(r)) end\
"