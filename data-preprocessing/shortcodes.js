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

let promises = [];
for (let standard in shortcodeStandards) {
	promises[promises.length] = new Promise(resolve => {
		readFile(`./assets/shortcodes-source/${standard}.raw.json`).then(file => {
			let reverseDict = JSON.parse(file)

			let output = "return{"
			for (let code in reverseDict) {
				let shortcodes = reverseDict[code]
			//     console.log(code, typeof(shortcodes))
				
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