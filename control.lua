local shortcodes = require("assets.shortcodes")

script.on_init(function ()
	if script.active_mods["better-chat"] then
		global["better-chat"] = true
		remote.call("emojipack registration", "add", script.mod_name, shortcodes)
	else
	end
	shortcodes = nil -- unnecessary memory ussage
end)
script.on_load(function ()
	script.on_nth_tick(5, function (p1)
		-- Register with better-chat if it was activated after twemoji
		-- And mark it as unregistered if better-chat no longer exists
		if script.active_mods["better-chat"] and not global["better-chat"] then
			remote.call("emojipack registration", "add", script.mod_name, shortcodes)
		elseif not script.active_mods["better-chat"] and global["better-chat"] then
			global["better-chat"] = nil
		end
		script.on_nth_tick() -- Unregister
		shortcodes = nil -- unnecessary memory ussage
	end)
end)
