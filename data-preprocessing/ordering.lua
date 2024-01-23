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
local function replace_all(text, pattern, replace)
	local output = text
	for match in text:gmatch(pattern) do
		local front, back = output:find(match, 1, true)
		local firsthalf = output:sub(1, front-1)
		local secondHalf = output:sub(back+1)
		output = firsthalf..replace..secondHalf
	end
	return output
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
	-- Extract code from "U+<code> U+<code> ;" to "<code>-<code>"
	local code = split(line, ";")[1]:sub(1,-2):gsub("U%+",""):gsub(" ", "-"):lower()

	-- Remove leading zeros
	local _,leadingZero = code:find("^0+")
	if leadingZero then code = code:sub(1, leadingZero) end

	local exists = file_exists("./assets/twemoji-images/"..code..".png")
	-- Only add it if twemoji has an image for it
	if exists then
		if unregistered_emoji[code] then unregistered_emoji[code] = nil
		else print(code.." exists twice??") end

		-- Extract and capitalize the name from "# <emoji> emoji name here"
		local name = split(line, "#")[2]
		local nameIndex = name:find(" ", 2)
		name = capitalizeWords(name:sub(nameIndex+1))

		ordering = ordering.."'"..code.."',"
		names = names.."twemoji-"..code.."="..name.."\n"
	end
end

--#region -- HACK: Lazily add the ones that don't work properly
missing_codes = {
	-- Missing in emoji-ordering.txt
	{"1f1e6", "Regional Indicator A"},
	{"1f1e7", "Regional Indicator B"},
	{"1f1e8", "Regional Indicator C"},
	{"1f1e9", "Regional Indicator D"},
	{"1f1ea", "Regional Indicator E"},
	{"1f1eb", "Regional Indicator F"},
	{"1f1ec", "Regional Indicator G"},
	{"1f1ed", "Regional Indicator H"},
	{"1f1ee", "Regional Indicator I"},
	{"1f1ef", "Regional Indicator J"},
	{"1f1f0", "Regional Indicator K"},
	{"1f1f1", "Regional Indicator L"},
	{"1f1f2", "Regional Indicator M"},
	{"1f1f3", "Regional Indicator N"},
	{"1f1f4", "Regional Indicator O"},
	{"1f1f5", "Regional Indicator P"},
	{"1f1f6", "Regional Indicator Q"},
	{"1f1f7", "Regional Indicator R"},
	{"1f1f8", "Regional Indicator S"},
	{"1f1f9", "Regional Indicator T"},
	{"1f1fa", "Regional Indicator U"},
	{"1f1fb", "Regional Indicator V"},
	{"1f1fc", "Regional Indicator W"},
	{"1f1fd", "Regional Indicator X"},
	{"1f1fe", "Regional Indicator Y"},
	{"1f1ff", "Regional Indicator Z"},
	-- Twemoji skips the fe0f
	{"2a-20e3", "Keycap: *"},
	{"23-20e3", "Keycap: #"},
	{"30-20e3", "Keycap: 0"},
	{"31-20e3", "Keycap: 1"},
	{"32-20e3", "Keycap: 2"},
	{"33-20e3", "Keycap: 3"},
	{"34-20e3", "Keycap: 4"},
	{"35-20e3", "Keycap: 5"},
	{"36-20e3", "Keycap: 6"},
	{"37-20e3", "Keycap: 7"},
	{"38-20e3", "Keycap: 8"},
	{"39-20e3", "Keycap: 9"},
}
for _, missing_item in ipairs(missing_codes) do
	local code = missing_item[1]
	local name = missing_item[2]
	if unregistered_emoji[code] then
		unregistered_emoji[code] = nil
		ordering = ordering.."'"..code.."',"
		names = names.."twemoji-"..code.."="..name.."\n"
	else
		print(code.." hacked in unnecessarily. Using version from file")
	end
end
--#endregion

ordering = ordering.."}"

local orderingFile = io.open("./assets/emoji-ordering.lua", "w")
if not orderingFile then error("Can't write processed order!") end
orderingFile:write(ordering):close()

local localizationFile = io.open("./locale/en/twemoji.cfg", "w")
if not localizationFile then error("Can't write processed names!") end
localizationFile:write(names):close()
--#endregion