--data.lua
---Pads left side of string
---@param inputstr string
---@param length integer
---@param pad string
function lpad(inputstr, length, pad)
	pad = pad or " "
	return pad:rep(length - inputstr:len())..inputstr;
end

-- Make new group
data:extend{
	{
		type = 'item-group',
		name = 'twemoji',
		icon = '__twemoji-in-factorio__/assets/twemoji-images/1f0cf.png',
		icon_size = 72,
		order = 'zzz'
	},
	{
		type = 'item-subgroup',
		name = 'twemoji-main',
		group = 'twemoji',
		order = '0'
	},
}

local ordering = require("assets/emoji-ordering.lua")
local baseTwemoji = {
	type = 'virtual-signal',
	name = 'twemoji-',
	icon = "__twemoji-in-factorio__/assets/twemoji-images/",
	icon_size = 72,
	subgroup = 'twemoji-main'
}

for index,code in ipairs(ordering) do
	local newTwemoji = util.table.deepcopy(baseTwemoji)
	newTwemoji.icon = newTwemoji.icon..code..".png"
	newTwemoji.name = newTwemoji.name..code
	newTwemoji.order = lpad(tostring(index), 5, "0")
	data:extend{newTwemoji}
end