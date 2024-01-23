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
	if script.active_mods["better-chat"] and not global["better-chat"] then
		global["better-chat"] = true
		remote.call("emojipack registration", "add", script.mod_name, shortcodes[
			settings.global["shortcode-standard"].value
		])
	elseif not script.active_mods["better-chat"] and global["better-chat"] then
		global["better-chat"] = nil
	end
end

script.on_init(function ()
	register_shortcodes()
end)
script.on_load(function ()
	script.on_nth_tick(5, function ()
		register_shortcodes()
		script.on_nth_tick(5, nil) -- Unregister
	end)
end)

script.on_event(defines.events.on_runtime_mod_setting_changed ,function (change)
	if change.setting == "shortcode-standard" then register_shortcodes() end
end)