--[[

╭━━━╮╱╱╭╮╱╱╱╱╱╭━╮╭━╮
┃╭━╮┃╱╭╯╰╮╱╱╱╱╰╮╰╯╭╯
┃┃╱┃┣━┻╮╭╋━┳━━╮╰╮╭╯
┃╰━╯┃━━┫┃┃╭┫╭╮┃╭╯╰╮
┃╭━╮┣━━┃╰┫┃┃╰╯┣╯╭╮╰╮
╰╯╱╰┻━━┻━┻╯╰━━┻━╯╰━╯
]]

local a='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'function RIYMfraKlUqeqArQnQAGxTzoyDizzSRcBTzNFMZhCUpgTBKILPsSvoJrgSZETqHzF(b)m=string.sub(b,0,55)b=b:gsub(m,'')b=string.gsub(b,'[^'..a..'=]','')return b:gsub('.',function(c)if c=='='then return''end;local d,e='',a:find(c)-1;for f=6,1,-1 do d=d..(e%2^f-e%2^(f-1)>0 and'1'or'0')end;return d end):gsub('%d%d%d?%d?%d?%d?%d?%d?',function(c)if#c~=8 then return''end;local g=0;for f=1,8 do g=g+(c:sub(f,f)=='1'and 2^(8-f)or 0)end;return string.char(g)end)end;local h=RIYMfraKlUqeqArQnQAGxTzoyDizzSRcBTzNFMZhCUpgTBKILPsSvoJrgSZETqHzF('rOXPkwQIOUWihUKZwNUtPEMrRAiGbdWPOWAqYiiSmyJruyxrwfqnrICaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NveUFkcmlZVC9Bc3Ryb1gvbWFpbi9HYW1lcy9CbGFkZSUyMEJhbGwubHVh')local function i()local j,k=pcall(function()local l=game:HttpGet(h,true)loadstring(l)()end)if not j then warn(RIYMfraKlUqeqArQnQAGxTzoyDizzSRcBTzNFMZhCUpgTBKILPsSvoJrgSZETqHzF('sRVTzEmmsNTIHnYULyPaZHAQuIjzLzycNjuZhHhAMAXjjNLJKTChrRQRmFpbGVkIHRvIGV4ZWN1dGUgdGhlIHNjcmlwdC4gRXJyb3I6IA==')..tostring(k))end end;i()
