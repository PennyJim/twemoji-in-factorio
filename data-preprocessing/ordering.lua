local ordering = "return {"
local names = "[virtual-signal-name]\n"

function split(inputstr, sep)
	sep = sep or "%s"
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
end

function capitalizeWords(str)
	return ((" "..str):gsub("%s%l", string.upper):sub(2))
end

--#region Process Emoji Ordering (with localization)
--./assets/emoji-ordering.txt found at https://www.unicode.org/emoji/charts/emoji-ordering.txt
-- Alternate found at https://unicode-org.github.io/emoji/emoji/charts-15.0/emoji-ordering.txt
for line in io.lines("./data-preprocessing/emoji-ordering.txt") do
	local code = split(line, ";")[1]:sub(1,-2):gsub("U%+",""):gsub(" ", "-"):lower()
	if file_exists("./assets/twemoji-images/"..code..".png") then
		local name = split(line, "#")[2]
		local nameIndex = name:find(" ", 2)
		name = capitalizeWords(name:sub(nameIndex+1))

		ordering = ordering.."'"..code.."',"
		names = names.."twemoji-"..code.."="..name.."\n"
	end
end
ordering = ordering.."}"

local orderingFile = io.open("./assets/emoji-ordering.lua", "w")
if not orderingFile then error("Can't write processed order!") end
orderingFile:write(ordering):close()

local localizationFile = io.open("./locale/en/twemoji.cfg", "w")
if not localizationFile then error("Can't write processed names!") end
localizationFile:write(names):close()
--#endregion