local shortcodes = require("assets.shortcodes")
script.on_init(function ()
	remote.call("emojipack registration", "add", script.mod_name, shortcodes)
	shortcodes = nil
end)