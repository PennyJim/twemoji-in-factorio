local shortcodes = {
	["cldr"] = require("assets.shortcodes.cldr"),
	["emojibase"] = require("assets.shortcodes.emojibase"),
	["emojibase-legacy"] = require("assets.shortcodes.emojibase-legacy"),
	["github"] = require("assets.shortcodes.github"),
	["iamcal"] = require("assets.shortcodes.iamcal"),
	["joypixels"] = require("assets.shortcodes.joypixels"),
}

local function register_shortcodes()
	-- Register with better-chat if it was activated after twemoji
	-- And mark it as unregistered if better-chat no longer exists
	if script.active_mods["better-chat"] then
		remote.call("emojipack registration", "add", script.mod_name, shortcodes[
			settings.global["shortcode-standard"].value
		])
	elseif not script.active_mods["better-chat"] then
		shortcodes = nil
	end
end

script.on_init(function ()
	register_shortcodes()
end)
script.on_configuration_changed(function (change_data)
	local change = change_data.mod_changes["better-chat"]
	if change then
		register_shortcodes()
	end
end)

script.on_event(defines.events.on_runtime_mod_setting_changed ,function (change)
	if change.setting == "shortcode-standard" then
		register_shortcodes()
	end
end)