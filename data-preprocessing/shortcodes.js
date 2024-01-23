const fs = require('fs').promises;

async function readFile(filepath) {
	try {
		const data = await fs.readFile(filepath);
		return data.toString();
	} catch (error) {
		console.error(`Got an error trying to read the file: ${error.message}`)
	}
}

let shortcodeStandards = {
	"cldr": "",
	// "cldr-native": "", //Falls back to cldr? Can't handle yet
	"emojibase": "",
	"emojibase-legacy": "", //Don't use because deprecated?
	"github": "",
	"iamcal": "",
	"joypixels": "",
}

// HACK: translation table for the few emoji represented differently in twemoji
let translation = {
	"002A-FE0F-20E3": "2a-20e3",
	"0023-FE0F-20E3": "23-20e3",
	"0030-FE0F-20E3": "30-20e3",
	"0031-FE0F-20E3": "31-20e3",
	"0032-FE0F-20E3": "32-20e3",
	"0033-FE0F-20E3": "33-20e3",
	"0034-FE0F-20E3": "34-20e3",
	"0035-FE0F-20E3": "35-20e3",
	"0036-FE0F-20E3": "36-20e3",
	"0037-FE0F-20E3": "37-20e3",
	"0038-FE0F-20E3": "38-20e3",
	"0039-FE0F-20E3": "39-20e3",
}

let promises = [];
for (let standard in shortcodeStandards) {
	promises[promises.length] = new Promise(resolve => {
		readFile(`./data-preprocessing/shortcodes-source/${standard}.raw.json`).then(file => {
			let reverseDict = JSON.parse(file)

			let output = "return{"
			for (let code in reverseDict) {
				let shortcodes = reverseDict[code]

				if (translation[code] !== undefined) {code = translation[code]}
				code = code.replace(/^0+/, "")
				
				if (typeof(shortcodes) == "string") {
					shortcodes = [shortcodes]
				} 
				
				for (let shortcode of shortcodes) {
					output += `["${shortcode}"]="[img=virtual-signal.twemoji-${code.toLowerCase()}]",\n`
				}
			}
			output += "}"
			shortcodeStandards[standard] = output;
			resolve()
		})
	});
}

(async () => {
	await Promise.all(promises)
	
	for (let standard in shortcodeStandards) {
		fs.writeFile(`./assets/shortcodes/${standard}.lua`, shortcodeStandards[standard])
	}
})();