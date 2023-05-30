extends Node

#The 'Database' for all cards, exported from the Spreadsheet as a JSON.
#https://docs.google.com/spreadsheets/d/1NybVl2qLhytQnB4JVBlZz0kkX2xKVqMYhyLlgzmmw-A/

#Pool of general cards to be used for basic deck building and duel rewards
var general_card_pool = ["00000", "00001", "00002", "00003", "00005", "00008", "00009", "00010", "00011", "00014", "00015", "00016", "00018", "00020", "00021", "00022", "00023", "00024", "00026", "00027", "00030", "00031", "00032", "00033", "00036", "00037", "00038", "00039", "00040", "00041", "00042", "00043", "00044", "00046", "00047", "00048", "00049", "00051", "00053", "00056", "00057", "00058", "00061", "00062", "00065", "00069", "00070", "00077", "00078", "00081", "00082", "00083", "00084", "00085", "00086", "00087", "00088", "00089", "00092", "00093", "00094", "00095", "00096", "00097", "00098", "00099", "00100", "00105", "00106", "00107", "00108", "00109", "00110", "00111", "00112", "00113", "00114", "00115", "00116", "00121", "00122", "00123", "00124", "00125", "00126", "00127", "00128", "00129", "00130", "00131", "00132", "00133", "00134", "00135", "00136", "00137", "00138", "00139", "00141", "00142", "00143", "00144", "00145", "00146", "00147", "00148", "00149", "00150", "00151", "00152", "00153", "00155", "00162", "00163", "00167", "00172", "00173", "00175", "00176", "00180", "00181", "00196", "00197", "00198", "00199", "00200", "00201", "00202", "00203", "00204", "00205", "00206", "00207", "00208", "00209", "00210", "00215", "00220", "00221", "00222", "00223", "00224", "00225", "00226", "00227", "00228", "00229", "00230", "00237", "00247", "00248", "00250", "00251", "00253", "00254", "00255", "00260", "00261", "00262", "00267", "00268", "00269", "00274", "00275", "00276", "00281", "00282", "00283", "00284", "00285", "00286", "00287", "00288", "00289", "00290", "00291", "00292", "00299", "00302", "00305", "00308", "00311", "00314", "00319", "00322", "00323", "00324", "00325", "00326", "00327", "00328", "00329", "00330", "00331", "00332", "00335", "00336", "00337", "00338", "00339", "00343", "00350", "00351", "00354", "00356", "00359", "00364", "00365", "00366", "00367", "00368", "00370", "00371", "00374", "00377", "00378", "00394", "00407", "00417", "00419", "00420", "00422", "00440", "00441", "00442", "00443", "00457", "00458", "00465", "00466", "00467", "00468", "00469", "00470", "00472", "00473", "00476", "00477", "00478", "00479", "00480", "00481", "00482", "00507", "00508", "00509", "00512", "00513", "00514", "00516", "00518", "00525", "00526", "00527", "00528", "00530", "00531", "00533", "00542", "00543", "00546", "00547", "00548", "00568", "00571", "00574", "00584", "00588", "00591", "00595", "00596", "00597", "00599", "00602", "00613", "00615", "00617", "00624", "00626", "00653", "00654", "00655", "00656", "00670", "00671", "00672", "00673", "00674", "00676", "00677", "00678", "00679", "00744", "00749", "00752", "00753", "00754", "00755", "00756"]

const card_list = {
  "00000": {
	"card_name": "Shiny Black \"C\" Squadder",
	"attribute": "earth",
	"level": 4,
	"atk": 2000,
	"def": 0,
	"type": "insect",
	"count_as": "warrior",
	"effect": [],
	"passcode": "04148264"
  },
  "00001": {
	"card_name": "Dragon Statue",
	"attribute": "earth",
	"level": 3,
	"atk": 1100,
	"def": 900,
	"type": "warrior",
	"count_as": "dragon",
	"effect": [],
	"passcode": "09197735"
  },
  "00002": {
	"card_name": "Dragoness the Wicked Knight",
	"attribute": "wind",
	"level": 3,
	"atk": 1200,
	"def": 900,
	"type": "warrior",
	"count_as": "dragon",
	"effect": [],
	"passcode": "70681994"
  },
  "00003": {
	"card_name": "D. Human",
	"attribute": "earth",
	"level": 4,
	"atk": 1300,
	"def": 1100,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "81057959"
  },
  "00004": {
	"card_name": "Sword Arm of Dragon",
	"attribute": "earth",
	"level": 6,
	"atk": 1750,
	"def": 2030,
	"type": "dinosaur",
	"count_as": "dragon",
	"effect": [],
	"passcode": "13069066"
  },
  "00005": {
	"card_name": "Charubin the Fire Knight",
	"attribute": "fire",
	"level": 3,
	"atk": 1100,
	"def": 800,
	"type": "pyro",
	"count_as": "warrior",
	"effect": [],
	"passcode": "37421579"
  },
  "00006": {
	"card_name": "Flame Swordsman",
	"attribute": "fire",
	"level": 5,
	"atk": 1800,
	"def": 1600,
	"type": "warrior",
	"count_as": "pyro",
	"effect": [],
	"passcode": "45231177"
  },
  "00007": {
	"card_name": "Vermillion Sparrow",
	"attribute": "fire",
	"level": 5,
	"atk": 1900,
	"def": 1500,
	"type": "pyro",
	"count_as": null,
	"effect": [],
	"passcode": "35752363"
  },
  "00008": {
	"card_name": "Zombie Warrior",
	"attribute": "dark",
	"level": 3,
	"atk": 1200,
	"def": 900,
	"type": "zombie",
	"count_as": "warrior",
	"effect": [],
	"passcode": "31339260"
  },
  "00009": {
	"card_name": "Armored Zombie",
	"attribute": "dark",
	"level": 3,
	"atk": 1500,
	"def": 0,
	"type": "zombie",
	"count_as": "warrior",
	"effect": [],
	"passcode": "20277860"
  },
  "00010": {
	"card_name": "Koumori Dragon",
	"attribute": "dark",
	"level": 4,
	"atk": 1500,
	"def": 1200,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "67724379"
  },
  "00011": {
	"card_name": "Dragon Zombie",
	"attribute": "dark",
	"level": 3,
	"atk": 1600,
	"def": 0,
	"type": "zombie",
	"count_as": "dragon",
	"effect": [],
	"passcode": "66672569"
  },
  "00012": {
	"card_name": "Skelgon",
	"attribute": "dark",
	"level": 6,
	"atk": 1700,
	"def": 1900,
	"type": "zombie",
	"count_as": "dragon",
	"effect": [],
	"passcode": "32355828"
  },
  "00013": {
	"card_name": "Curse of Dragon",
	"attribute": "dark",
	"level": 5,
	"atk": 2000,
	"def": 1500,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "28279543"
  },
  "00014": {
	"card_name": "Celtic Guardian",
	"attribute": "earth",
	"level": 4,
	"atk": 1400,
	"def": 1200,
	"type": "warrior",
	"count_as": "fairy",
	"effect": [],
	"passcode": "91152256"
  },
  "00015": {
	"card_name": "Tiger Axe",
	"attribute": "earth",
	"level": 4,
	"atk": 1300,
	"def": 1100,
	"type": "beast-warrior",
	"count_as": null,
	"effect": [],
	"passcode": "49791927"
  },
  "00016": {
	"card_name": "Spike Seadra",
	"attribute": "water",
	"level": 5,
	"atk": 1600,
	"def": 1300,
	"type": "sea serpent",
	"count_as": "dragon",
	"effect": [],
	"passcode": "85326399"
  },
  "00017": {
	"card_name": "Kairyu-Shin",
	"attribute": "water",
	"level": 5,
	"atk": 1800,
	"def": 1500,
	"type": "sea serpent",
	"count_as": "dragon",
	"effect": [],
	"passcode": "76634149"
  },
  "00018": {
	"card_name": "Wood Remains",
	"attribute": "dark",
	"level": 3,
	"atk": 1000,
	"def": 900,
	"type": "zombie",
	"count_as": "plant",
	"effect": [],
	"passcode": "17733394"
  },
  "00019": {
	"card_name": "Pumpking the King of Ghosts",
	"attribute": "dark",
	"level": 6,
	"atk": 1800,
	"def": 2000,
	"type": "zombie",
	"count_as": "plant",
	"effect": [
	  "on_summon",
	  "friends_power_up",
	  300
	],
	"passcode": "29155212"
  },
  "00020": {
	"card_name": "Fire Reaper",
	"attribute": "dark",
	"level": 2,
	"atk": 700,
	"def": 500,
	"type": "zombie",
	"count_as": "pyro",
	"effect": [],
	"passcode": "53581214"
  },
  "00021": {
	"card_name": "Flame Ghost",
	"attribute": "dark",
	"level": 3,
	"atk": 1000,
	"def": 800,
	"type": "zombie",
	"count_as": "pyro",
	"effect": [],
	"passcode": "58528964"
  },
  "00022": {
	"card_name": "Firegrass",
	"attribute": "earth",
	"level": 2,
	"atk": 700,
	"def": 600,
	"type": "plant",
	"count_as": "pyro",
	"effect": [],
	"passcode": "53293545"
  },
  "00023": {
	"card_name": "Tatsunootoshigo",
	"attribute": "earth",
	"level": 5,
	"atk": 1350,
	"def": 1600,
	"type": "beast",
	"count_as": "fish",
	"effect": [],
	"passcode": "47922711"
  },
  "00024": {
	"card_name": "Rare Fish",
	"attribute": "water",
	"level": 4,
	"atk": 1500,
	"def": 1200,
	"type": "fish",
	"count_as": "beast",
	"effect": [],
	"passcode": "80516007"
  },
  "00025": {
	"card_name": "Marine Beast",
	"attribute": "water",
	"level": 5,
	"atk": 1700,
	"def": 1600,
	"type": "fish",
	"count_as": "beast",
	"effect": [],
	"passcode": "29929832"
  },
  "00026": {
	"card_name": "Dissolverock",
	"attribute": "earth",
	"level": 3,
	"atk": 900,
	"def": 1000,
	"type": "rock",
	"count_as": "pyro",
	"effect": [],
	"passcode": "40826495"
  },
  "00027": {
	"card_name": "Mavelus",
	"attribute": "wind",
	"level": 4,
	"atk": 1300,
	"def": 900,
	"type": "winged beast",
	"count_as": "pyro",
	"effect": [],
	"passcode": "59036972"
  },
  "00028": {
	"card_name": "Crimson Sunbird",
	"attribute": "fire",
	"level": 6,
	"atk": 2300,
	"def": 1800,
	"type": "winged beast",
	"count_as": "pyro",
	"effect": [],
	"passcode": "46696593"
  },
  "00029": {
	"card_name": "Metal Dragon",
	"attribute": "wind",
	"level": 6,
	"atk": 1850,
	"def": 1700,
	"type": "machine",
	"count_as": "dragon",
	"effect": [],
	"passcode": "09293977"
  },
  "00030": {
	"card_name": "Giga-Tech Wolf",
	"attribute": "fire",
	"level": 4,
	"atk": 1200,
	"def": 1400,
	"type": "machine",
	"count_as": "beast",
	"effect": [],
	"passcode": "08471389"
  },
  "00031": {
	"card_name": "Dice Armadillo",
	"attribute": "earth",
	"level": 5,
	"atk": 1650,
	"def": 1800,
	"type": "machine",
	"count_as": "beast",
	"effect": [],
	"passcode": "69893315"
  },
  "00032": {
	"card_name": "Cyber Soldier",
	"attribute": "dark",
	"level": 5,
	"atk": 1500,
	"def": 1700,
	"type": "machine",
	"count_as": "warrior",
	"effect": [],
	"passcode": "44865098"
  },
  "00033": {
	"card_name": "Thunder Dragon",
	"attribute": "light",
	"level": 5,
	"atk": 1600,
	"def": 1500,
	"type": "thunder",
	"count_as": "dragon",
	"effect": [],
	"passcode": "31786629"
  },
  "00034": {
	"card_name": "Twin-Headed Thunder Dragon",
	"attribute": "light",
	"level": 7,
	"atk": 2800,
	"def": 2100,
	"type": "thunder",
	"count_as": "dragon",
	"effect": [],
	"passcode": "54752875"
  },
  "00035": {
	"card_name": "Stone Dragon",
	"attribute": "earth",
	"level": 7,
	"atk": 2000,
	"def": 2300,
	"type": "rock",
	"count_as": "dragon",
	"effect": [],
	"passcode": "68171737"
  },
  "00036": {
	"card_name": "Ice Water",
	"attribute": "water",
	"level": 3,
	"atk": 1150,
	"def": 900,
	"type": "aqua",
	"count_as": "female",
	"effect": [],
	"passcode": "20848593"
  },
  "00037": {
	"card_name": "Enchanting Mermaid",
	"attribute": "water",
	"level": 3,
	"atk": 1200,
	"def": 900,
	"type": "fish",
	"count_as": "female",
	"effect": [],
	"passcode": "75376965"
  },
  "00038": {
	"card_name": "Amazon of the Seas",
	"attribute": "water",
	"level": 4,
	"atk": 1300,
	"def": 1400,
	"type": "fish",
	"count_as": "female",
	"effect": [],
	"passcode": "17968114"
  },
  "00039": {
	"card_name": "Misairuzame",
	"attribute": "water",
	"level": 5,
	"atk": 1400,
	"def": 1600,
	"type": "fish",
	"count_as": "machine",
	"effect": [],
	"passcode": "33178416"
  },
  "00040": {
	"card_name": "Metal Fish",
	"attribute": "water",
	"level": 5,
	"atk": 1600,
	"def": 1900,
	"type": "machine",
	"count_as": "fish",
	"effect": [],
	"passcode": "55998462"
  },
  "00041": {
	"card_name": "7 Colored Fish",
	"attribute": "water",
	"level": 4,
	"atk": 1800,
	"def": 800,
	"type": "fish",
	"count_as": null,
	"effect": [],
	"passcode": "23771716"
  },
  "00042": {
	"card_name": "Minomushi Warrior",
	"attribute": "earth",
	"level": 4,
	"atk": 1300,
	"def": 1200,
	"type": "rock",
	"count_as": "warrior",
	"effect": [],
	"passcode": "46864967"
  },
  "00043": {
	"card_name": "Stone Ghost",
	"attribute": "earth",
	"level": 4,
	"atk": 1200,
	"def": 1000,
	"type": "rock",
	"count_as": "zombie",
	"effect": [],
	"passcode": "72269672"
  },
  "00044": {
	"card_name": "The Immortal of Thunder",
	"attribute": "light",
	"level": 4,
	"atk": 1500,
	"def": 1300,
	"type": "thunder",
	"count_as": "spellcaster",
	"effect": [
	  "on_flip",
	  "lifepoint_up",
	  1000
	],
	"passcode": "84926738"
  },
  "00045": {
	"card_name": "Kaminari Attack",
	"attribute": "wind",
	"level": 5,
	"atk": 1900,
	"def": 1400,
	"type": "thunder",
	"count_as": "spellcaster",
	"effect": [],
	"passcode": "09653271"
  },
  "00046": {
	"card_name": "Tripwire Beast",
	"attribute": "earth",
	"level": 4,
	"atk": 1200,
	"def": 1300,
	"type": "thunder",
	"count_as": "beast",
	"effect": [],
	"passcode": "45042329"
  },
  "00047": {
	"card_name": "Bolt Escargot",
	"attribute": "water",
	"level": 5,
	"atk": 1400,
	"def": 1500,
	"type": "thunder",
	"count_as": "aqua",
	"effect": [],
	"passcode": "12146024"
  },
  "00048": {
	"card_name": "Magical Ghost",
	"attribute": "dark",
	"level": 4,
	"atk": 1300,
	"def": 1400,
	"type": "zombie",
	"count_as": "spellcaster",
	"effect": [],
	"passcode": "46474915"
  },
  "00049": {
	"card_name": "Cockroach Knight",
	"attribute": "earth",
	"level": 3,
	"atk": 800,
	"def": 900,
	"type": "insect",
	"count_as": "warrior",
	"effect": [],
	"passcode": "33413638"
  },
  "00050": {
	"card_name": "Garvas",
	"attribute": "earth",
	"level": 6,
	"atk": 2000,
	"def": 1700,
	"type": "beast",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "69780745"
  },
  "00051": {
	"card_name": "Flower Wolf",
	"attribute": "earth",
	"level": 5,
	"atk": 1800,
	"def": 1400,
	"type": "beast",
	"count_as": "plant",
	"effect": [],
	"passcode": "95952802"
  },
  "00052": {
	"card_name": "Cyber Saurus",
	"attribute": "earth",
	"level": 5,
	"atk": 1800,
	"def": 1400,
	"type": "machine",
	"count_as": "dinosaur",
	"effect": [],
	"passcode": "89112729"
  },
  "00053": {
	"card_name": "Bean Soldier",
	"attribute": "earth",
	"level": 4,
	"atk": 1400,
	"def": 1300,
	"type": "plant",
	"count_as": "warrior",
	"effect": [],
	"passcode": "84990171"
  },
  "00054": {
	"card_name": "Flame Cerebrus",
	"attribute": "fire",
	"level": 6,
	"atk": 2100,
	"def": 1800,
	"type": "pyro",
	"count_as": "beast",
	"effect": [],
	"passcode": "60862676"
  },
  "00055": {
	"card_name": "Mystical Sand",
	"attribute": "earth",
	"level": 6,
	"atk": 2100,
	"def": 1700,
	"type": "rock",
	"count_as": "female",
	"effect": [],
	"passcode": "32751480"
  },
  "00056": {
	"card_name": "Corroding Shark",
	"attribute": "dark",
	"level": 3,
	"atk": 1100,
	"def": 700,
	"type": "zombie",
	"count_as": "fish",
	"effect": [],
	"passcode": "34290067"
  },
  "00057": {
	"card_name": "Wow Warrior",
	"attribute": "water",
	"level": 4,
	"atk": 1250,
	"def": 900,
	"type": "fish",
	"count_as": "warrior",
	"effect": [],
	"passcode": "69750536"
  },
  "00058": {
	"card_name": "Dark Elf",
	"attribute": "dark",
	"level": 4,
	"atk": 2000,
	"def": 800,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "lifepoint_cost",
	  1000
	],
	"passcode": "21417692"
  },
  "00059": {
	"card_name": "B. Dragon Jungle King",
	"attribute": "earth",
	"level": 6,
	"atk": 2100,
	"def": 1800,
	"type": "dragon",
	"count_as": "plant",
	"effect": [],
	"passcode": "89832901"
  },
  "00060": {
	"card_name": "Dark Witch",
	"attribute": "light",
	"level": 5,
	"atk": 1800,
	"def": 1700,
	"type": "fairy",
	"count_as": "female",
	"effect": [],
	"passcode": "35565537"
  },
  "00061": {
	"card_name": "Electric Lizard",
	"attribute": "earth",
	"level": 3,
	"atk": 850,
	"def": 800,
	"type": "thunder",
	"count_as": "reptile",
	"effect": [],
	"passcode": "55875323"
  },
  "00062": {
	"card_name": "Snakeyashi",
	"attribute": "earth",
	"level": 4,
	"atk": 1000,
	"def": 1200,
	"type": "plant",
	"count_as": "reptile",
	"effect": [],
	"passcode": "29802344"
  },
  "00063": {
	"card_name": "Nekogal #2",
	"attribute": "earth",
	"level": 6,
	"atk": 1900,
	"def": 2000,
	"type": "beast-warrior",
	"count_as": "female",
	"effect": [],
	"passcode": "43352213"
  },
  "00064": {
	"card_name": "Queen of Autumn Leaves",
	"attribute": "earth",
	"level": 5,
	"atk": 1800,
	"def": 1500,
	"type": "plant",
	"count_as": "female",
	"effect": [],
	"passcode": "04179849"
  },
  "00065": {
	"card_name": "Disk Magician",
	"attribute": "dark",
	"level": 4,
	"atk": 1350,
	"def": 1000,
	"type": "machine",
	"count_as": "spellcaster",
	"effect": [],
	"passcode": "76446915"
  },
  "00066": {
	"card_name": "Gaia the Dragon Champion",
	"attribute": "wind",
	"level": 7,
	"atk": 2600,
	"def": 2100,
	"type": "dragon",
	"count_as": "warrior",
	"effect": [],
	"passcode": "66889139"
  },
  "00067": {
	"card_name": "Gaia The Fierce Knight",
	"attribute": "earth",
	"level": 7,
	"atk": 2300,
	"def": 2100,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "06368038"
  },
  "00068": {
	"card_name": "Rabid Horseman",
	"attribute": "earth",
	"level": 6,
	"atk": 2000,
	"def": 1700,
	"type": "beast-warrior",
	"count_as": null,
	"effect": [],
	"passcode": "94905343"
  },
  "00069": {
	"card_name": "Battle Ox",
	"attribute": "earth",
	"level": 4,
	"atk": 1700,
	"def": 1000,
	"type": "beast-warrior",
	"count_as": null,
	"effect": [],
	"passcode": "05053103"
  },
  "00070": {
	"card_name": "Mystic Horseman",
	"attribute": "earth",
	"level": 4,
	"atk": 1300,
	"def": 1550,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "68516705"
  },
  "00071": {
	"card_name": "Black Skull Dragon",
	"attribute": "dark",
	"level": 9,
	"atk": 3200,
	"def": 2500,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "11901678"
  },
  "00072": {
	"card_name": "Summoned Skull",
	"attribute": "dark",
	"level": 6,
	"atk": 2500,
	"def": 1200,
	"type": "fiend",
	"count_as": "zombie",
	"effect": [],
	"passcode": "70781052"
  },
  "00073": {
	"card_name": "Red-Eyes Black Dragon",
	"attribute": "dark",
	"level": 7,
	"atk": 2400,
	"def": 2000,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "74677422"
  },
  "00074": {
	"card_name": "Meteor Black Dragon",
	"attribute": "fire",
	"level": 8,
	"atk": 3500,
	"def": 2000,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "90660762"
  },
  "00075": {
	"card_name": "Meteor Dragon",
	"attribute": "earth",
	"level": 6,
	"atk": 1800,
	"def": 2000,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "64271667"
  },
  "00076": {
	"card_name": "Thousand Dragon",
	"attribute": "wind",
	"level": 7,
	"atk": 2400,
	"def": 2000,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "41462083"
  },
  "00077": {
	"card_name": "Baby Dragon",
	"attribute": "wind",
	"level": 3,
	"atk": 1200,
	"def": 700,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "88819587"
  },
  "00078": {
	"card_name": "Time Wizard",
	"attribute": "light",
	"level": 2,
	"atk": 500,
	"def": 400,
	"type": "spellcaster",
	"count_as": null,
	"effect": [
	  "special_description"
	],
	"passcode": "71625222"
  },
  "00079": {
	"card_name": "Dark Sage",
	"attribute": "dark",
	"level": 9,
	"atk": 2800,
	"def": 3200,
	"type": "spellcaster",
	"count_as": null,
	"effect": [],
	"passcode": "92377303"
  },
  "00080": {
	"card_name": "Dark Magician",
	"attribute": "dark",
	"level": 7,
	"atk": 2500,
	"def": 2100,
	"type": "spellcaster",
	"count_as": null,
	"effect": [],
	"passcode": "46986414"
  },
  "00081": {
	"card_name": "Fiend Kraken",
	"attribute": "water",
	"level": 4,
	"atk": 1200,
	"def": 1400,
	"type": "aqua",
	"count_as": null,
	"effect": [],
	"passcode": "77456781"
  },
  "00082": {
	"card_name": "Jellyfish",
	"attribute": "water",
	"level": 4,
	"atk": 1200,
	"def": 1500,
	"type": "aqua",
	"count_as": "thunder",
	"effect": [],
	"passcode": "14851496"
  },
  "00083": {
	"card_name": "Catapult Turtle",
	"attribute": "water",
	"level": 5,
	"atk": 1000,
	"def": 2000,
	"type": "aqua",
	"count_as": "turtle",
	"effect": [
	  "on_attack",
	  "burn",
	  1000
	],
	"passcode": "95727991"
  },
  "00084": {
	"card_name": "Octoberser",
	"attribute": "water",
	"level": 5,
	"atk": 1600,
	"def": 1400,
	"type": "aqua",
	"count_as": null,
	"effect": [],
	"passcode": "74637266"
  },
  "00085": {
	"card_name": "Turtle Tiger",
	"attribute": "water",
	"level": 4,
	"atk": 1000,
	"def": 1500,
	"type": "aqua",
	"count_as": "turtle",
	"effect": [],
	"passcode": "37313348"
  },
  "00086": {
	"card_name": "Mammoth Graveyard",
	"attribute": "earth",
	"level": 3,
	"atk": 1200,
	"def": 800,
	"type": "dinosaur",
	"count_as": "zombie",
	"effect": [],
	"passcode": "40374923"
  },
  "00087": {
	"card_name": "Uraby",
	"attribute": "earth",
	"level": 4,
	"atk": 1500,
	"def": 800,
	"type": "dinosaur",
	"count_as": null,
	"effect": [],
	"passcode": "01784619"
  },
  "00088": {
	"card_name": "Crawling Dragon #2",
	"attribute": "earth",
	"level": 4,
	"atk": 1600,
	"def": 1200,
	"type": "dinosaur",
	"count_as": "dragon",
	"effect": [],
	"passcode": "38289717"
  },
  "00089": {
	"card_name": "Doma the Angel of Silence",
	"attribute": "dark",
	"level": 5,
	"atk": 1600,
	"def": 1400,
	"type": "fairy",
	"count_as": null,
	"effect": [],
	"passcode": "16972957"
  },
  "00090": {
	"card_name": "Gyakutenno Megami",
	"attribute": "light",
	"level": 6,
	"atk": 1800,
	"def": 2000,
	"type": "fairy",
	"count_as": "female",
	"effect": [],
	"passcode": "31122090"
  },
  "00091": {
	"card_name": "Orion the Battle King",
	"attribute": "light",
	"level": 5,
	"atk": 1800,
	"def": 1500,
	"type": "fairy",
	"count_as": "female",
	"effect": [],
	"passcode": "02971090"
  },
  "00092": {
	"card_name": "LaMoon",
	"attribute": "light",
	"level": 5,
	"atk": 1200,
	"def": 1700,
	"type": "fairy",
	"count_as": "female",
	"effect": [],
	"passcode": "75850803"
  },
  "00093": {
	"card_name": "Big Insect",
	"attribute": "earth",
	"level": 4,
	"atk": 1200,
	"def": 1500,
	"type": "insect",
	"count_as": null,
	"effect": [],
	"passcode": "53606874"
  },
  "00094": {
	"card_name": "Basic Insect",
	"attribute": "earth",
	"level": 2,
	"atk": 500,
	"def": 700,
	"type": "insect",
	"count_as": null,
	"effect": [],
	"passcode": "89091579"
  },
  "00095": {
	"card_name": "Hercules Beetle",
	"attribute": "earth",
	"level": 5,
	"atk": 1500,
	"def": 2000,
	"type": "insect",
	"count_as": null,
	"effect": [],
	"passcode": "52584282"
  },
  "00096": {
	"card_name": "Killer Needle",
	"attribute": "wind",
	"level": 4,
	"atk": 1200,
	"def": 1000,
	"type": "insect",
	"count_as": null,
	"effect": [],
	"passcode": "88979991"
  },
  "00097": {
	"card_name": "Gokibore",
	"attribute": "earth",
	"level": 4,
	"atk": 1200,
	"def": 1400,
	"type": "insect",
	"count_as": null,
	"effect": [],
	"passcode": "15367030"
  },
  "00098": {
	"card_name": "Ancient Elf",
	"attribute": "light",
	"level": 4,
	"atk": 1450,
	"def": 1200,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "93221206"
  },
  "00099": {
	"card_name": "The Stern Mystic",
	"attribute": "light",
	"level": 4,
	"atk": 1500,
	"def": 1200,
	"type": "spellcaster",
	"count_as": null,
	"effect": [],
	"passcode": "87557188"
  },
  "00100": {
	"card_name": "Neo the Magic Swordsman",
	"attribute": "light",
	"level": 4,
	"atk": 1700,
	"def": 1000,
	"type": "spellcaster",
	"count_as": "warrior",
	"effect": [],
	"passcode": "50930991"
  },
  "00101": {
	"card_name": "Megamorph",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  1000,
	  "any"
	],
	"passcode": "22046459"
  },
  "00102": {
	"card_name": "Axe of Despair",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "atk_up",
	  1000,
	  "any"
	],
	"passcode": "40619825"
  },
  "00103": {
	"card_name": "Horn of the Unicorn",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "atk_up",
	  700,
	  "any"
	],
	"passcode": "64047146"
  },
  "00104": {
	"card_name": "Black Pendant",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "atk_up",
	  500,
	  "any"
	],
	"passcode": "65169794"
  },
  "00105": {
	"card_name": "Sword of Dark Destruction",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "atk_up",
	  500,
	  "dark"
	],
	"passcode": "37120512"
  },
  "00106": {
	"card_name": "Invigoration",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "atk_up",
	  500,
	  "earth"
	],
	"passcode": "98374133"
  },
  "00107": {
	"card_name": "Burning Spear",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "atk_up",
	  500,
	  "fire"
	],
	"passcode": "18937875"
  },
  "00108": {
	"card_name": "Elf's Light",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "atk_up",
	  500,
	  "light"
	],
	"passcode": "39897277"
  },
  "00109": {
	"card_name": "Steel Shell",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "atk_up",
	  500,
	  "water"
	],
	"passcode": "02370081"
  },
  "00110": {
	"card_name": "Gust Fan",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "atk_up",
	  500,
	  "wind"
	],
	"passcode": "55321970"
  },
  "00111": {
	"card_name": "Mystic Plasma Zone",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "field",
	"count_as": null,
	"effect": [
	  "dark"
	],
	"passcode": "18161786"
  },
  "00112": {
	"card_name": "Gaia Power",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "field",
	"count_as": null,
	"effect": [
	  "earth"
	],
	"passcode": "56594520"
  },
  "00113": {
	"card_name": "Molten Destruction",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "field",
	"count_as": null,
	"effect": [
	  "fire"
	],
	"passcode": "19384334"
  },
  "00114": {
	"card_name": "Luminous Spark",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "field",
	"count_as": null,
	"effect": [
	  "light"
	],
	"passcode": "81777047"
  },
  "00115": {
	"card_name": "Umiiruka",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "field",
	"count_as": null,
	"effect": [
	  "water"
	],
	"passcode": "82999629"
  },
  "00116": {
	"card_name": "Rising Air Current",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "field",
	"count_as": null,
	"effect": [
	  "wind"
	],
	"passcode": "45778932"
  },
  "00117": {
	"card_name": "Raigeki",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "destroy_card",
	  "enemy_monsters"
	],
	"passcode": "12580477"
  },
  "00118": {
	"card_name": "Harpie's Feather Duster",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "destroy_card",
	  "enemy_spelltraps"
	],
	"passcode": "18144506"
  },
  "00119": {
	"card_name": "Negate Attack",
	"attribute": "trap",
	"level": null,
	"atk": null,
	"def": null,
	"type": "trap",
	"count_as": null,
	"effect": [
	  "negate_attacker",
	  9999
	],
	"passcode": "14315573"
  },
  "00120": {
	"card_name": "Widespread Ruin",
	"attribute": "trap",
	"level": null,
	"atk": null,
	"def": null,
	"type": "trap",
	"count_as": null,
	"effect": [
	  "destroy_attacker",
	  9999
	],
	"passcode": "77754944"
  },
  "00121": {
	"card_name": "Armaill",
	"attribute": "earth",
	"level": 3,
	"atk": 700,
	"def": 1300,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "53153481"
  },
  "00122": {
	"card_name": "One-Eyed Shield Dragon",
	"attribute": "wind",
	"level": 3,
	"atk": 700,
	"def": 1300,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "33064647"
  },
  "00123": {
	"card_name": "Monster Egg",
	"attribute": "earth",
	"level": 3,
	"atk": 600,
	"def": 900,
	"type": "warrior",
	"count_as": "egg",
	"effect": [],
	"passcode": "36121917"
  },
  "00124": {
	"card_name": "Hinotama Soul",
	"attribute": "fire",
	"level": 2,
	"atk": 600,
	"def": 500,
	"type": "pyro",
	"count_as": null,
	"effect": [],
	"passcode": "96851799"
  },
  "00125": {
	"card_name": "Flame Manipulator",
	"attribute": "fire",
	"level": 3,
	"atk": 900,
	"def": 1000,
	"type": "spellcaster",
	"count_as": "pyro",
	"effect": [],
	"passcode": "34460851"
  },
  "00126": {
	"card_name": "Masaki the Legendary Swordsman",
	"attribute": "earth",
	"level": 4,
	"atk": 1100,
	"def": 1100,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "44287299"
  },
  "00127": {
	"card_name": "Rhaimundos of the Red Sword",
	"attribute": "earth",
	"level": 4,
	"atk": 1200,
	"def": 1300,
	"type": "warrior",
	"count_as": "pyro",
	"effect": [],
	"passcode": "62403074"
  },
  "00128": {
	"card_name": "Fireyarou",
	"attribute": "fire",
	"level": 4,
	"atk": 1300,
	"def": 1000,
	"type": "pyro",
	"count_as": null,
	"effect": [],
	"passcode": "71407486"
  },
  "00129": {
	"card_name": "Skull Servant",
	"attribute": "dark",
	"level": 1,
	"atk": 300,
	"def": 200,
	"type": "zombie",
	"count_as": null,
	"effect": [],
	"passcode": "32274490"
  },
  "00130": {
	"card_name": "Battle Warrior",
	"attribute": "earth",
	"level": 3,
	"atk": 700,
	"def": 1000,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "55550921"
  },
  "00131": {
	"card_name": "The Snake Hair",
	"attribute": "dark",
	"level": 4,
	"atk": 1500,
	"def": 1200,
	"type": "zombie",
	"count_as": "female",
	"effect": [],
	"passcode": "29491031"
  },
  "00132": {
	"card_name": "Blackland Fire Dragon",
	"attribute": "dark",
	"level": 4,
	"atk": 1500,
	"def": 800,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "87564352"
  },
  "00133": {
	"card_name": "Fusionist",
	"attribute": "earth",
	"level": 3,
	"atk": 900,
	"def": 700,
	"type": "beast",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "01641882"
  },
  "00134": {
	"card_name": "Petit Angel",
	"attribute": "light",
	"level": 3,
	"atk": 600,
	"def": 900,
	"type": "fairy",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "38142739"
  },
  "00135": {
	"card_name": "Mystical Sheep #2",
	"attribute": "earth",
	"level": 3,
	"atk": 800,
	"def": 1000,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "83464209"
  },
  "00136": {
	"card_name": "Mystical Sheep #1",
	"attribute": "earth",
	"level": 3,
	"atk": 1150,
	"def": 900,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "30451366"
  },
  "00137": {
	"card_name": "Water Magician",
	"attribute": "water",
	"level": 4,
	"atk": 1400,
	"def": 1000,
	"type": "aqua",
	"count_as": "spellcaster",
	"effect": [],
	"passcode": "93343894"
  },
  "00138": {
	"card_name": "Behegon",
	"attribute": "water",
	"level": 4,
	"atk": 1350,
	"def": 1000,
	"type": "aqua",
	"count_as": "beast",
	"effect": [],
	"passcode": "94022093"
  },
  "00139": {
	"card_name": "Tyhone",
	"attribute": "wind",
	"level": 4,
	"atk": 1200,
	"def": 1400,
	"type": "winged beast",
	"count_as": null,
	"effect": [],
	"passcode": "72842870"
  },
  "00140": {
	"card_name": "Tyhone #2",
	"attribute": "fire",
	"level": 6,
	"atk": 1700,
	"def": 1900,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "56789759"
  },
  "00141": {
	"card_name": "Wings of Wicked Flame",
	"attribute": "fire",
	"level": 2,
	"atk": 700,
	"def": 600,
	"type": "pyro",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "92944626"
  },
  "00142": {
	"card_name": "Steel Ogre Grotto #1",
	"attribute": "earth",
	"level": 5,
	"atk": 1400,
	"def": 1800,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "29172562"
  },
  "00143": {
	"card_name": "Rock Ogre Grotto #1",
	"attribute": "earth",
	"level": 3,
	"atk": 800,
	"def": 1200,
	"type": "rock",
	"count_as": null,
	"effect": [],
	"passcode": "68846917"
  },
  "00144": {
	"card_name": "Steel Ogre Grotto #2",
	"attribute": "earth",
	"level": 6,
	"atk": 1900,
	"def": 2200,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "90908427"
  },
  "00145": {
	"card_name": "Rock Ogre Grotto #2",
	"attribute": "earth",
	"level": 3,
	"atk": 700,
	"def": 1400,
	"type": "rock",
	"count_as": null,
	"effect": [],
	"passcode": "62193699"
  },
  "00146": {
	"card_name": "Lesser Dragon",
	"attribute": "wind",
	"level": 4,
	"atk": 1200,
	"def": 1000,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "55444629"
  },
  "00147": {
	"card_name": "Ocubeam",
	"attribute": "light",
	"level": 5,
	"atk": 1550,
	"def": 1650,
	"type": "fairy",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "86088138"
  },
  "00148": {
	"card_name": "Mega Thunderball",
	"attribute": "wind",
	"level": 2,
	"atk": 750,
	"def": 600,
	"type": "thunder",
	"count_as": null,
	"effect": [],
	"passcode": "21817254"
  },
  "00149": {
	"card_name": "Silver Fang",
	"attribute": "earth",
	"level": 3,
	"atk": 1200,
	"def": 800,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "90357090"
  },
  "00150": {
	"card_name": "Darkworld Thorns",
	"attribute": "earth",
	"level": 3,
	"atk": 1200,
	"def": 900,
	"type": "plant",
	"count_as": null,
	"effect": [],
	"passcode": "43500484"
  },
  "00151": {
	"card_name": "Blast Juggler",
	"attribute": "fire",
	"level": 3,
	"atk": 800,
	"def": 900,
	"type": "machine",
	"count_as": "pyro",
	"effect": [],
	"passcode": "70138455"
  },
  "00152": {
	"card_name": "Two-Headed King Rex",
	"attribute": "earth",
	"level": 4,
	"atk": 1600,
	"def": 1200,
	"type": "dinosaur",
	"count_as": null,
	"effect": [],
	"passcode": "94119974"
  },
  "00153": {
	"card_name": "Giant Soldier of Stone",
	"attribute": "earth",
	"level": 3,
	"atk": 1300,
	"def": 2000,
	"type": "rock",
	"count_as": "warrior",
	"effect": [],
	"passcode": "13039848"
  },
  "00154": {
	"card_name": "Great Mammoth of Goldfine",
	"attribute": "dark",
	"level": 6,
	"atk": 2200,
	"def": 1800,
	"type": "zombie",
	"count_as": null,
	"effect": [],
	"passcode": "54622031"
  },
  "00155": {
	"card_name": "Metalmorph",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "special_description"
	],
	"passcode": "68540058"
  },
  "00156": {
	"card_name": "Super Armored Robot Armed Black Iron \"C\"",
	"attribute": "earth",
	"level": 8,
	"atk": 2400,
	"def": 2800,
	"type": "insect",
	"count_as": "machine",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "atk_highest"
	],
	"passcode": "77754169"
  },
  "00157": {
	"card_name": "Metalzoa",
	"attribute": "dark",
	"level": 8,
	"atk": 3000,
	"def": 2300,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "50705071"
  },
  "00158": {
	"card_name": "Zoa",
	"attribute": "dark",
	"level": 7,
	"atk": 2600,
	"def": 1900,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "24311372"
  },
  "00159": {
	"card_name": "Red-Eyes Black Metal Dragon",
	"attribute": "dark",
	"level": 8,
	"atk": 2800,
	"def": 2400,
	"type": "machine",
	"count_as": "dragon",
	"effect": [],
	"passcode": "64335804"
  },
  "00160": {
	"card_name": "Launcher Spider",
	"attribute": "fire",
	"level": 7,
	"atk": 2200,
	"def": 2500,
	"type": "machine",
	"count_as": "insect",
	"effect": [],
	"passcode": "87322377"
  },
  "00161": {
	"card_name": "Jirai Gumo",
	"attribute": "earth",
	"level": 4,
	"atk": 2200,
	"def": 100,
	"type": "insect",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "lifepoint_cost",
	  1000
	],
	"passcode": "94773007"
  },
  "00162": {
	"card_name": "Level Up!",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "special_description"
	],
	"passcode": "25290459"
  },
  "00163": {
	"card_name": "Armed Dragon LV3",
	"attribute": "wind",
	"level": 3,
	"atk": 1200,
	"def": 900,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "00980973"
  },
  "00164": {
	"card_name": "Armed Dragon LV5",
	"attribute": "wind",
	"level": 5,
	"atk": 2400,
	"def": 1700,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "46384672"
  },
  "00165": {
	"card_name": "Armed Dragon LV7",
	"attribute": "wind",
	"level": 7,
	"atk": 2800,
	"def": 1000,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "73879377"
  },
  "00166": {
	"card_name": "Armed Dragon LV10",
	"attribute": "wind",
	"level": 10,
	"atk": 3000,
	"def": 2000,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "atk_highest"
	],
	"passcode": "59464593"
  },
  "00167": {
	"card_name": "Silent Magician LV4",
	"attribute": "light",
	"level": 4,
	"atk": 1000,
	"def": 1000,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "73665146"
  },
  "00168": {
	"card_name": "Silent Magician LV8",
	"attribute": "light",
	"level": 8,
	"atk": 3500,
	"def": 1000,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "72443568"
  },
  "00169": {
	"card_name": "Silent Swordsman LV3",
	"attribute": "light",
	"level": 3,
	"atk": 1000,
	"def": 1000,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "01995985"
  },
  "00170": {
	"card_name": "Silent Swordsman LV5",
	"attribute": "light",
	"level": 5,
	"atk": 2300,
	"def": 1000,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "74388798"
  },
  "00171": {
	"card_name": "Silent Swordsman LV7",
	"attribute": "light",
	"level": 7,
	"atk": 2800,
	"def": 1000,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "37267041"
  },
  "00172": {
	"card_name": "Dark Lucius LV4",
	"attribute": "earth",
	"level": 4,
	"atk": 1000,
	"def": 300,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "85313220"
  },
  "00173": {
	"card_name": "Dark Lucius LV6",
	"attribute": "earth",
	"level": 6,
	"atk": 1700,
	"def": 600,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "12817939"
  },
  "00174": {
	"card_name": "Dark Lucius LV8",
	"attribute": "earth",
	"level": 8,
	"atk": 2800,
	"def": 900,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "58206034"
  },
  "00175": {
	"card_name": "Ultimate Insect LV1",
	"attribute": "wind",
	"level": 1,
	"atk": 0,
	"def": 0,
	"type": "insect",
	"count_as": null,
	"effect": [],
	"passcode": "49441499"
  },
  "00176": {
	"card_name": "Ultimate Insect LV3",
	"attribute": "wind",
	"level": 3,
	"atk": 1400,
	"def": 900,
	"type": "insect",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "friends_power_up",
	  300
	],
	"passcode": "34088136"
  },
  "00177": {
	"card_name": "Ultimate Insect LV5",
	"attribute": "wind",
	"level": 5,
	"atk": 2300,
	"def": 900,
	"type": "insect",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "friends_power_up",
	  500
	],
	"passcode": "34830502"
  },
  "00178": {
	"card_name": "Ultimate Insect LV7",
	"attribute": "wind",
	"level": 7,
	"atk": 2600,
	"def": 1200,
	"type": "insect",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "friends_power_up",
	  700
	],
	"passcode": "19877898"
  },
  "00179": {
	"card_name": "Cocoon of Evolution",
	"attribute": "earth",
	"level": 3,
	"atk": 0,
	"def": 2000,
	"type": "insect",
	"count_as": null,
	"effect": [
	  "special_description"
	],
	"passcode": "40240595"
  },
  "00180": {
	"card_name": "Petit Moth",
	"attribute": "earth",
	"level": 1,
	"atk": 300,
	"def": 200,
	"type": "insect",
	"count_as": null,
	"effect": [],
	"passcode": "58192742"
  },
  "00181": {
	"card_name": "Larvae Moth",
	"attribute": "earth",
	"level": 2,
	"atk": 500,
	"def": 400,
	"type": "insect",
	"count_as": null,
	"effect": [],
	"passcode": "87756343"
  },
  "00182": {
	"card_name": "Greath Moth",
	"attribute": "earth",
	"level": 8,
	"atk": 2600,
	"def": 2500,
	"type": "insect",
	"count_as": null,
	"effect": [],
	"passcode": "14141448"
  },
  "00183": {
	"card_name": "Perfectly Ultimate Great Moth",
	"attribute": "earth",
	"level": 8,
	"atk": 3500,
	"def": 3000,
	"type": "insect",
	"count_as": null,
	"effect": [],
	"passcode": "48579379"
  },
  "00184": {
	"card_name": "X-Head Cannon",
	"attribute": "light",
	"level": 4,
	"atk": 1800,
	"def": 1500,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "62651957"
  },
  "00185": {
	"card_name": "Y-Dragon Head",
	"attribute": "light",
	"level": 4,
	"atk": 1500,
	"def": 1600,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "65622692"
  },
  "00186": {
	"card_name": "Z-Metal Tank",
	"attribute": "light",
	"level": 4,
	"atk": 1500,
	"def": 1300,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "64500000"
  },
  "00187": {
	"card_name": "XY-Dragon Cannon",
	"attribute": "light",
	"level": 6,
	"atk": 2200,
	"def": 1900,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "02111707"
  },
  "00188": {
	"card_name": "YZ-Tank Dragon",
	"attribute": "light",
	"level": 6,
	"atk": 2100,
	"def": 2200,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "25119460"
  },
  "00189": {
	"card_name": "XZ-Tank Cannon",
	"attribute": "light",
	"level": 6,
	"atk": 2400,
	"def": 2100,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "99724761"
  },
  "00190": {
	"card_name": "XYZ-Dragon Cannon",
	"attribute": "light",
	"level": 8,
	"atk": 2800,
	"def": 2600,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "91998119"
  },
  "00191": {
	"card_name": "V-Tiger Jet",
	"attribute": "light",
	"level": 4,
	"atk": 1600,
	"def": 1800,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "51638941"
  },
  "00192": {
	"card_name": "W-Wing Catapult",
	"attribute": "light",
	"level": 4,
	"atk": 1300,
	"def": 1500,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "96300057"
  },
  "00193": {
	"card_name": "VW-Tiger Catapult",
	"attribute": "light",
	"level": 6,
	"atk": 2000,
	"def": 2100,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "58859575"
  },
  "00194": {
	"card_name": "VWXYZ-Dragon Catapult Cannon",
	"attribute": "light",
	"level": 8,
	"atk": 3000,
	"def": 2800,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "84243274"
  },
  "00195": {
	"card_name": "Armed Dragon Catapult Cannon",
	"attribute": "light",
	"level": 10,
	"atk": 3500,
	"def": 3000,
	"type": "machine",
	"count_as": "dragon",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "atk_highest"
	],
	"passcode": "75906310"
  },
  "00196": {
	"card_name": "Beast Fangs",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  300,
	  "beast"
	],
	"passcode": "46009906"
  },
  "00197": {
	"card_name": "Book of Secret Arts",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  300,
	  "spellcaster"
	],
	"passcode": "91595718"
  },
  "00198": {
	"card_name": "Dragon Treasure",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  300,
	  "dragon"
	],
	"passcode": "01435851"
  },
  "00199": {
	"card_name": "Electro-Whip",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  300,
	  "thunder"
	],
	"passcode": "37820550"
  },
  "00200": {
	"card_name": "Follow Wind",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  300,
	  "winged beast"
	],
	"passcode": "98252586"
  },
  "00201": {
	"card_name": "Laser Cannon Armor",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  300,
	  "insect"
	],
	"passcode": "77007920"
  },
  "00202": {
	"card_name": "Legendary Sword",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  300,
	  "warrior"
	],
	"passcode": "61854111"
  },
  "00203": {
	"card_name": "Machine Conversion Factory",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  300,
	  "machine"
	],
	"passcode": "25769732"
  },
  "00204": {
	"card_name": "Mystical Moon",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  300,
	  "beast-warrior"
	],
	"passcode": "36607978"
  },
  "00205": {
	"card_name": "Power of Kaishin",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  300,
	  "aqua"
	],
	"passcode": "77027445"
  },
  "00206": {
	"card_name": "Raise Body Heat",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  300,
	  "dinosaur"
	],
	"passcode": "51267887"
  },
  "00207": {
	"card_name": "Silver Bow and Arrow",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  300,
	  "fairy"
	],
	"passcode": "01557499"
  },
  "00208": {
	"card_name": "Vile Germs",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  300,
	  "plant"
	],
	"passcode": "39774685"
  },
  "00209": {
	"card_name": "Violet Crystal",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  300,
	  "zombie"
	],
	"passcode": "15052462"
  },
  "00210": {
	"card_name": "Dark Energy",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "stats_up",
	  300,
	  "fiend"
	],
	"passcode": "04614116"
  },
  "00211": {
	"card_name": "Noble Knight Joan",
	"attribute": "light",
	"level": 4,
	"atk": 1900,
	"def": 1300,
	"type": "warrior",
	"count_as": "female",
	"effect": [],
	"passcode": "18426196"
  },
  "00212": {
	"card_name": "St. Joan",
	"attribute": "light",
	"level": 7,
	"atk": 2800,
	"def": 2000,
	"type": "fairy",
	"count_as": "female",
	"effect": [],
	"passcode": "21175632"
  },
  "00213": {
	"card_name": "Darklord Marie",
	"attribute": "dark",
	"level": 5,
	"atk": 1700,
	"def": 1200,
	"type": "fiend",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "lifepoint_up",
	  200
	],
	"passcode": "57579381"
  },
  "00214": {
	"card_name": "Oracle King d'Arc",
	"attribute": "dark",
	"level": 7,
	"atk": 2800,
	"def": 2000,
	"type": "fiend",
	"count_as": "female",
	"effect": [],
	"passcode": "82956492"
  },
  "00215": {
	"card_name": "The Forgiving Maiden",
	"attribute": "light",
	"level": 4,
	"atk": 850,
	"def": 2000,
	"type": "fairy",
	"count_as": "female",
	"effect": [],
	"passcode": "84080938"
  },
  "00216": {
	"card_name": "Amaterasu",
	"attribute": "light",
	"level": 9,
	"atk": 3000,
	"def": 3000,
	"type": "fairy",
	"count_as": "female",
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "all_enemy_monsters"
	],
	"passcode": "20073910"
  },
  "00217": {
	"card_name": "Magician's Rod",
	"attribute": "dark",
	"level": 3,
	"atk": 1600,
	"def": 100,
	"type": "spellcaster",
	"count_as": null,
	"effect": [],
	"passcode": "07084129"
  },
  "00218": {
	"card_name": "Magician's Robe",
	"attribute": "dark",
	"level": 2,
	"atk": 700,
	"def": 2000,
	"type": "spellcaster",
	"count_as": null,
	"effect": [],
	"passcode": "71696014"
  },
  "00219": {
	"card_name": "Magician of Dark Illusion",
	"attribute": "dark",
	"level": 7,
	"atk": 2100,
	"def": 2500,
	"type": "spellcaster",
	"count_as": null,
	"effect": [],
	"passcode": "35191415"
  },
  "00220": {
	"card_name": "Airknight Parshath",
	"attribute": "light",
	"level": 5,
	"atk": 1900,
	"def": 1400,
	"type": "fairy",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "18036057"
  },
  "00221": {
	"card_name": "Warrior Elimination",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "destroy_card",
	  "warrior"
	],
	"passcode": "90873992"
  },
  "00222": {
	"card_name": "Exile of the Wicked",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "destroy_card",
	  "fiend"
	],
	"passcode": "26725158"
  },
  "00223": {
	"card_name": "Acid Rain",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "destroy_card",
	  "machine"
	],
	"passcode": "21323861"
  },
  "00224": {
	"card_name": "Breath of Light",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "destroy_card",
	  "rock"
	],
	"passcode": "20101223"
  },
  "00225": {
	"card_name": "Eradicating Aerosol",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "destroy_card",
	  "insect"
	],
	"passcode": "94716515"
  },
  "00226": {
	"card_name": "Eternal Drought",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "destroy_card",
	  "fish"
	],
	"passcode": "56606928"
  },
  "00227": {
	"card_name": "Eternal Rest",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "destroy_card",
	  "zombie"
	],
	"passcode": "95051344"
  },
  "00228": {
	"card_name": "Cold Wave",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "destroy_card",
	  "dinosaur"
	],
	"passcode": "60682203"
  },
  "00229": {
	"card_name": "Dragon Capture Jar",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "destroy_card",
	  "dragon"
	],
	"passcode": "50045299"
  },
  "00230": {
	"card_name": "Last Day of Witch",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "destroy_card",
	  "spellcaster"
	],
	"passcode": "90330453"
  },
  "00231": {
	"card_name": "Dark Magician Girl",
	"attribute": "dark",
	"level": 6,
	"atk": 2000,
	"def": 1700,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "self_power_up",
	  200
	],
	"passcode": "38033121"
  },
  "00232": {
	"card_name": "Dark Magician Girl the Dragon Knight",
	"attribute": "dark",
	"level": 7,
	"atk": 2600,
	"def": 1700,
	"type": "dragon",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "atk_highest"
	],
	"passcode": "43892408"
  },
  "00233": {
	"card_name": "Dark Magician the Dragon Knight",
	"attribute": "dark",
	"level": 8,
	"atk": 3000,
	"def": 2500,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "atk_highest"
	],
	"passcode": "41721210"
  },
  "00234": {
	"card_name": "The Dark Magicians",
	"attribute": "dark",
	"level": 8,
	"atk": 2800,
	"def": 2300,
	"type": "spellcaster",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "50237654"
  },
  "00235": {
	"card_name": "Buster Blader",
	"attribute": "earth",
	"level": 7,
	"atk": 2600,
	"def": 2300,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  "buster_blader"
	],
	"passcode": "78193831"
  },
  "00236": {
	"card_name": "Dark Paladin",
	"attribute": "dark",
	"level": 8,
	"atk": 2900,
	"def": 2400,
	"type": "spellcaster",
	"count_as": "warrior",
	"effect": [
	  "on_summon",
	  "self_power_up",
	  "buster_blader"
	],
	"passcode": "98502113"
  },
  "00237": {
	"card_name": "Magician's Valkyria",
	"attribute": "light",
	"level": 4,
	"atk": 1600,
	"def": 1800,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "80304126"
  },
  "00238": {
	"card_name": "Red-Eyes Dark Dragoon",
	"attribute": "dark",
	"level": 8,
	"atk": 3000,
	"def": 2500,
	"type": "spellcaster",
	"count_as": "dragon",
	"effect": [
	  "on_attack",
	  "burn",
	  "enemy_atk"
	],
	"passcode": "37818794"
  },
  "00239": {
	"card_name": "Dark Cavalry",
	"attribute": "dark",
	"level": 8,
	"atk": 2800,
	"def": 2300,
	"type": "spellcaster",
	"count_as": "warrior",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "73452089"
  },
  "00240": {
	"card_name": "Blue-Eyes White Dragon",
	"attribute": "light",
	"level": 8,
	"atk": 3000,
	"def": 2500,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "89631139"
  },
  "00241": {
	"card_name": "Blue-Eyes Twin Burst Dragon",
	"attribute": "light",
	"level": 10,
	"atk": 3000,
	"def": 2500,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "02129638"
  },
  "00242": {
	"card_name": "Blue-Eyes Ultimate Dragon",
	"attribute": "light",
	"level": 12,
	"atk": 4500,
	"def": 3800,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "23995346"
  },
  "00243": {
	"card_name": "Blue-Eyes Shining Dragon",
	"attribute": "light",
	"level": 10,
	"atk": 3000,
	"def": 2500,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  300
	],
	"passcode": "53347303"
  },
  "00244": {
	"card_name": "Dragon Spirit of White",
	"attribute": "light",
	"level": 8,
	"atk": 2500,
	"def": 2000,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "45467446"
  },
  "00245": {
	"card_name": "Kaibaman",
	"attribute": "light",
	"level": 3,
	"atk": 200,
	"def": 700,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "special_description"
	],
	"passcode": "34627841"
  },
  "00246": {
	"card_name": "Silent Magician LV6",
	"attribute": "light",
	"level": 6,
	"atk": 2500,
	"def": 1000,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "41175645"
  },
  "00247": {
	"card_name": "Lyna the Light Charmer",
	"attribute": "light",
	"level": 3,
	"atk": 500,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "73318863"
  },
  "00248": {
	"card_name": "Happy Lover",
	"attribute": "light",
	"level": 2,
	"atk": 800,
	"def": 500,
	"type": "fairy",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "99030164"
  },
  "00249": {
	"card_name": "Lyna - Familiar-Possessed",
	"attribute": "light",
	"level": 4,
	"atk": 1850,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "40542825"
  },
  "00250": {
	"card_name": "Dharc the Dark Charmer",
	"attribute": "dark",
	"level": 3,
	"atk": 500,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "19327348"
  },
  "00251": {
	"card_name": "Meda Bat",
	"attribute": "dark",
	"level": 2,
	"atk": 800,
	"def": 400,
	"type": "fiend",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "76211194"
  },
  "00252": {
	"card_name": "Dharc - Familiar-Possessed",
	"attribute": "dark",
	"level": 4,
	"atk": 1850,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "21390858"
  },
  "00253": {
	"card_name": "Aussa the Earth Charmer",
	"attribute": "earth",
	"level": 3,
	"atk": 500,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "37970940"
  },
  "00254": {
	"card_name": "Archfiend Marmot of Nefariousness",
	"attribute": "earth",
	"level": 2,
	"atk": 400,
	"def": 600,
	"type": "beast",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "75889523"
  },
  "00255": {
	"card_name": "Avalanching Aussa",
	"attribute": "earth",
	"level": 4,
	"atk": 800,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "29139104"
  },
  "00256": {
	"card_name": "Nefarious Archfiend Eater of Nefariousness",
	"attribute": "earth",
	"level": 4,
	"atk": 1500,
	"def": 200,
	"type": "beast",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "60666820"
  },
  "00257": {
	"card_name": "Nefariouser Archfiend - Awakening",
	"attribute": "earth",
	"level": 5,
	"atk": 2000,
	"def": 200,
	"type": "beast",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "65268179"
  },
  "00258": {
	"card_name": "Aussa - Familiar-Possessed",
	"attribute": "earth",
	"level": 4,
	"atk": 1850,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "31887905"
  },
  "00259": {
	"card_name": "Cataclysmic Crusted Calcifida",
	"attribute": "earth",
	"level": 8,
	"atk": 2600,
	"def": 200,
	"type": "fairy",
	"count_as": null,
	"effect": [],
	"passcode": "09028399"
  },
  "00260": {
	"card_name": "Hiita the Fire Charmer",
	"attribute": "fire",
	"level": 3,
	"atk": 500,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "00759393"
  },
  "00261": {
	"card_name": "Fox Fire",
	"attribute": "fire",
	"level": 2,
	"atk": 300,
	"def": 200,
	"type": "pyro",
	"count_as": "beast",
	"effect": [],
	"passcode": "88753985"
  },
  "00262": {
	"card_name": "Blazing Hiita",
	"attribute": "fire",
	"level": 4,
	"atk": 800,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "92518817"
  },
  "00263": {
	"card_name": "Inari Fire",
	"attribute": "fire",
	"level": 4,
	"atk": 1500,
	"def": 200,
	"type": "pyro",
	"count_as": "beast",
	"effect": [],
	"passcode": "62953041"
  },
  "00264": {
	"card_name": "Greater Inari Fire - Awakening",
	"attribute": "fire",
	"level": 5,
	"atk": 2000,
	"def": 200,
	"type": "pyro",
	"count_as": "beast",
	"effect": [],
	"passcode": "92652813"
  },
  "00265": {
	"card_name": "Hiita - Familiar-Possessed",
	"attribute": "fire",
	"level": 4,
	"atk": 1850,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "04376658"
  },
  "00266": {
	"card_name": "Cataclysmic Scorching Sunburner",
	"attribute": "fire",
	"level": 8,
	"atk": 2600,
	"def": 200,
	"type": "fairy",
	"count_as": null,
	"effect": [],
	"passcode": "39505816"
  },
  "00267": {
	"card_name": "Eria the Water Charmer",
	"attribute": "water",
	"level": 3,
	"atk": 500,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "74364659"
  },
  "00268": {
	"card_name": "Gigobyte",
	"attribute": "water",
	"level": 1,
	"atk": 350,
	"def": 300,
	"type": "reptile",
	"count_as": null,
	"effect": [],
	"passcode": "53776525"
  },
  "00269": {
	"card_name": "Raging Eria",
	"attribute": "water",
	"level": 4,
	"atk": 800,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "56524813"
  },
  "00270": {
	"card_name": "Jigabyte",
	"attribute": "water",
	"level": 4,
	"atk": 1500,
	"def": 200,
	"type": "reptile",
	"count_as": "thunder",
	"effect": [],
	"passcode": "40894584"
  },
  "00271": {
	"card_name": "Gagigobyte - Awakening",
	"attribute": "water",
	"level": 5,
	"atk": 2000,
	"def": 200,
	"type": "reptile",
	"count_as": "thunder",
	"effect": [],
	"passcode": "74426895"
  },
  "00272": {
	"card_name": "Eria - Familiar-Possessed",
	"attribute": "water",
	"level": 4,
	"atk": 1850,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "68881649"
  },
  "00273": {
	"card_name": "Cataclysmic Circumpolar Chilblainia",
	"attribute": "water",
	"level": 8,
	"atk": 2600,
	"def": 200,
	"type": "fairy",
	"count_as": "female",
	"effect": [],
	"passcode": "62850093"
  },
  "00274": {
	"card_name": "Wynn the Wind Charmer",
	"attribute": "wind",
	"level": 3,
	"atk": 500,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "37744402"
  },
  "00275": {
	"card_name": "Petit Dragon",
	"attribute": "wind",
	"level": 2,
	"atk": 600,
	"def": 700,
	"type": "dragon",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "75356564"
  },
  "00276": {
	"card_name": "Storming Wynn",
	"attribute": "wind",
	"level": 4,
	"atk": 800,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "29013526"
  },
  "00277": {
	"card_name": "Ranryu",
	"attribute": "wind",
	"level": 4,
	"atk": 1500,
	"def": 200,
	"type": "dragon",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "44680819"
  },
  "00278": {
	"card_name": "Rasenryu - Awakening",
	"attribute": "wind",
	"level": 5,
	"atk": 2000,
	"def": 200,
	"type": "dragon",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "00410904"
  },
  "00279": {
	"card_name": "Wynn - Familiar-Possessed",
	"attribute": "wind",
	"level": 4,
	"atk": 1850,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "31764353"
  },
  "00280": {
	"card_name": "Cataclysmic Cryonic Coldo",
	"attribute": "wind",
	"level": 8,
	"atk": 2600,
	"def": 200,
	"type": "fairy",
	"count_as": null,
	"effect": [],
	"passcode": "19420830"
  },
  "00281": {
	"card_name": "Hoshiningen",
	"attribute": "light",
	"level": 2,
	"atk": 500,
	"def": 700,
	"type": "fairy",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "attribute_booster"
	],
	"passcode": "67629977"
  },
  "00282": {
	"card_name": "Witch's Apprentice",
	"attribute": "dark",
	"level": 2,
	"atk": 550,
	"def": 500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "attribute_booster"
	],
	"passcode": "80741828"
  },
  "00283": {
	"card_name": "Milus Radiant",
	"attribute": "earth",
	"level": 1,
	"atk": 300,
	"def": 250,
	"type": "beast",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "attribute_booster"
	],
	"passcode": "07489323"
  },
  "00284": {
	"card_name": "Little Chimera",
	"attribute": "fire",
	"level": 2,
	"atk": 600,
	"def": 550,
	"type": "beast",
	"count_as": "pyro",
	"effect": [
	  "on_summon",
	  "attribute_booster"
	],
	"passcode": "68658728"
  },
  "00285": {
	"card_name": "Star Boy",
	"attribute": "water",
	"level": 2,
	"atk": 550,
	"def": 500,
	"type": "aqua",
	"count_as": "fiend",
	"effect": [
	  "on_summon",
	  "attribute_booster"
	],
	"passcode": "08201910"
  },
  "00286": {
	"card_name": "Bladefly",
	"attribute": "wind",
	"level": 2,
	"atk": 600,
	"def": 700,
	"type": "insect",
	"count_as": "winged beast",
	"effect": [
	  "on_summon",
	  "attribute_booster"
	],
	"passcode": "28470714"
  },
  "00287": {
	"card_name": "Dawn Knight",
	"attribute": "light",
	"level": 4,
	"atk": 1400,
	"def": 1200,
	"type": "warrior",
	"count_as": "fairy",
	"effect": [],
	"passcode": "06351548"
  },
  "00288": {
	"card_name": "Armageddon Knight",
	"attribute": "dark",
	"level": 4,
	"atk": 1400,
	"def": 1200,
	"type": "warrior",
	"count_as": "fiend",
	"effect": [],
	"passcode": "28985331"
  },
  "00289": {
	"card_name": "Dust Knight",
	"attribute": "earth",
	"level": 4,
	"atk": 1400,
	"def": 1200,
	"type": "warrior",
	"count_as": "rock",
	"effect": [],
	"passcode": "35195612"
  },
  "00290": {
	"card_name": "Brushfire Knight",
	"attribute": "fire",
	"level": 4,
	"atk": 1400,
	"def": 1200,
	"type": "warrior",
	"count_as": "pyro",
	"effect": [],
	"passcode": "36569343"
  },
  "00291": {
	"card_name": "Shore Knight",
	"attribute": "water",
	"level": 4,
	"atk": 1400,
	"def": 1200,
	"type": "warrior",
	"count_as": "aqua",
	"effect": [],
	"passcode": "14771222"
  },
  "00292": {
	"card_name": "Altitude Knight",
	"attribute": "wind",
	"level": 4,
	"atk": 1400,
	"def": 1200,
	"type": "warrior",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "27632240"
  },
  "00293": {
	"card_name": "Radiant Spirit",
	"attribute": "light",
	"level": 7,
	"atk": 2000,
	"def": 1500,
	"type": "reptile",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "attribute_reptile"
	],
	"passcode": "12624008"
  },
  "00294": {
	"card_name": "Umbral Soul",
	"attribute": "dark",
	"level": 7,
	"atk": 2000,
	"def": 1500,
	"type": "reptile",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "attribute_reptile"
	],
	"passcode": "86229493"
  },
  "00295": {
	"card_name": "Raging Earth",
	"attribute": "earth",
	"level": 7,
	"atk": 2000,
	"def": 1500,
	"type": "reptile",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "attribute_reptile"
	],
	"passcode": "50957346"
  },
  "00296": {
	"card_name": "Firestorm Prominence",
	"attribute": "fire",
	"level": 7,
	"atk": 2000,
	"def": 1500,
	"type": "reptile",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "attribute_reptile"
	],
	"passcode": "13846680"
  },
  "00297": {
	"card_name": "Silent Abyss",
	"attribute": "water",
	"level": 7,
	"atk": 2000,
	"def": 1500,
	"type": "reptile",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "attribute_reptile"
	],
	"passcode": "86442081"
  },
  "00298": {
	"card_name": "Destruction Cyclone",
	"attribute": "wind",
	"level": 7,
	"atk": 2000,
	"def": 1500,
	"type": "reptile",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "attribute_reptile"
	],
	"passcode": "59235795"
  },
  "00299": {
	"card_name": "Mithra the Thunder Vassal",
	"attribute": "light",
	"level": 2,
	"atk": 800,
	"def": 1000,
	"type": "thunder",
	"count_as": "warrior",
	"effect": [],
	"passcode": "22404675"
  },
  "00300": {
	"card_name": "Zaborg the Thunder Monarch",
	"attribute": "light",
	"level": 5,
	"atk": 2400,
	"def": 1000,
	"type": "thunder",
	"count_as": null,
	"effect": [],
	"passcode": "51945556"
  },
  "00301": {
	"card_name": "Zaborg the Mega Monarch",
	"attribute": "light",
	"level": 8,
	"atk": 2800,
	"def": 1000,
	"type": "thunder",
	"count_as": null,
	"effect": [],
	"passcode": "87602890"
  },
  "00302": {
	"card_name": "Lucius the Shadow Vassal",
	"attribute": "dark",
	"level": 1,
	"atk": 800,
	"def": 1000,
	"type": "fiend",
	"count_as": "warrior",
	"effect": [],
	"passcode": "58786132"
  },
  "00303": {
	"card_name": "Caius the Shadow Monarch",
	"attribute": "dark",
	"level": 6,
	"atk": 2400,
	"def": 1000,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "09748752"
  },
  "00304": {
	"card_name": "Caius the Mega Monarch",
	"attribute": "dark",
	"level": 8,
	"atk": 2800,
	"def": 1000,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "87288189"
  },
  "00305": {
	"card_name": "Landrobe the Rock Vassal",
	"attribute": "earth",
	"level": 4,
	"atk": 800,
	"def": 1000,
	"type": "rock",
	"count_as": "warrior",
	"effect": [],
	"passcode": "95993388"
  },
  "00306": {
	"card_name": "Granmarg the Rock Monarch",
	"attribute": "earth",
	"level": 6,
	"atk": 2400,
	"def": 1000,
	"type": "rock",
	"count_as": null,
	"effect": [],
	"passcode": "60229110"
  },
  "00307": {
	"card_name": "Granmarg the Mega Monarch",
	"attribute": "earth",
	"level": 8,
	"atk": 2800,
	"def": 1000,
	"type": "rock",
	"count_as": null,
	"effect": [],
	"passcode": "15545291"
  },
  "00308": {
	"card_name": "Berlineth the Firestorm Vassal",
	"attribute": "fire",
	"level": 3,
	"atk": 800,
	"def": 1000,
	"type": "pyro",
	"count_as": "warrior",
	"effect": [],
	"passcode": "59808784"
  },
  "00309": {
	"card_name": "Thestalos the Firestorm Monarch",
	"attribute": "fire",
	"level": 6,
	"atk": 2400,
	"def": 1000,
	"type": "pyro",
	"count_as": null,
	"effect": [],
	"passcode": "26205777"
  },
  "00310": {
	"card_name": "Thestalos the Mega Monarch",
	"attribute": "fire",
	"level": 8,
	"atk": 2800,
	"def": 1000,
	"type": "pyro",
	"count_as": null,
	"effect": [],
	"passcode": "69230391"
  },
  "00311": {
	"card_name": "Escher the Frost Vassal",
	"attribute": "water",
	"level": 4,
	"atk": 800,
	"def": 1000,
	"type": "aqua",
	"count_as": "warrior",
	"effect": [],
	"passcode": "24326617"
  },
  "00312": {
	"card_name": "Mobius the Frost Monarch",
	"attribute": "water",
	"level": 6,
	"atk": 2400,
	"def": 1000,
	"type": "aqua",
	"count_as": null,
	"effect": [],
	"passcode": "04929256"
  },
  "00313": {
	"card_name": "Mobius the Mega Monarch",
	"attribute": "water",
	"level": 8,
	"atk": 2800,
	"def": 1000,
	"type": "aqua",
	"count_as": null,
	"effect": [],
	"passcode": "23689697"
  },
  "00314": {
	"card_name": "Garum the Storm Vassal",
	"attribute": "wind",
	"level": 3,
	"atk": 800,
	"def": 1000,
	"type": "winged beast",
	"count_as": "warrior",
	"effect": [],
	"passcode": "22382087"
  },
  "00315": {
	"card_name": "Raiza the Storm Monarch",
	"attribute": "wind",
	"level": 6,
	"atk": 2400,
	"def": 1000,
	"type": "winged beast",
	"count_as": null,
	"effect": [],
	"passcode": "73125233"
  },
  "00316": {
	"card_name": "Raiza the Mega Monarch",
	"attribute": "wind",
	"level": 8,
	"atk": 2800,
	"def": 1000,
	"type": "winged beast",
	"count_as": null,
	"effect": [],
	"passcode": "69327790"
  },
  "00317": {
	"card_name": "Sengenjin",
	"attribute": "earth",
	"level": 8,
	"atk": 2750,
	"def": 2500,
	"type": "beast-warrior",
	"count_as": null,
	"effect": [],
	"passcode": "76232340"
  },
  "00318": {
	"card_name": "Millennium Golem",
	"attribute": "earth",
	"level": 6,
	"atk": 2000,
	"def": 2200,
	"type": "rock",
	"count_as": null,
	"effect": [],
	"passcode": "47986555"
  },
  "00319": {
	"card_name": "Destroyer Golem",
	"attribute": "earth",
	"level": 4,
	"atk": 1500,
	"def": 1000,
	"type": "rock",
	"count_as": null,
	"effect": [],
	"passcode": "73481154"
  },
  "00320": {
	"card_name": "Millennium Shield",
	"attribute": "earth",
	"level": 5,
	"atk": 0,
	"def": 3000,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "32012841"
  },
  "00321": {
	"card_name": "Alexandrite Dragon",
	"attribute": "light",
	"level": 4,
	"atk": 2000,
	"def": 100,
	"type": "dragon",
	"count_as": "rock",
	"effect": [],
	"passcode": "43096270"
  },
  "00322": {
	"card_name": "Lord of the Lamp",
	"attribute": "dark",
	"level": 4,
	"atk": 1400,
	"def": 1200,
	"type": "fiend",
	"count_as": "spellcaster",
	"effect": [],
	"passcode": "99510761"
  },
  "00323": {
	"card_name": "Key Mace",
	"attribute": "light",
	"level": 1,
	"atk": 400,
	"def": 300,
	"type": "fairy",
	"count_as": "female",
	"effect": [],
	"passcode": "01929294"
  },
  "00324": {
	"card_name": "Key Mace #2",
	"attribute": "dark",
	"level": 4,
	"atk": 1050,
	"def": 1200,
	"type": "fiend",
	"count_as": "female",
	"effect": [],
	"passcode": "20541432"
  },
  "00325": {
	"card_name": "Barrel Rock",
	"attribute": "earth",
	"level": 4,
	"atk": 1000,
	"def": 1300,
	"type": "rock",
	"count_as": null,
	"effect": [],
	"passcode": "10476868"
  },
  "00326": {
	"card_name": "Ray & Temperature",
	"attribute": "light",
	"level": 3,
	"atk": 1000,
	"def": 1000,
	"type": "fairy",
	"count_as": null,
	"effect": [],
	"passcode": "85309439"
  },
  "00327": {
	"card_name": "The Melting Red Shadow",
	"attribute": "water",
	"level": 2,
	"atk": 500,
	"def": 700,
	"type": "aqua",
	"count_as": "fiend",
	"effect": [],
	"passcode": "98898173"
  },
  "00328": {
	"card_name": "Shadow Specter",
	"attribute": "dark",
	"level": 1,
	"atk": 500,
	"def": 200,
	"type": "zombie",
	"count_as": null,
	"effect": [],
	"passcode": "40575313"
  },
  "00329": {
	"card_name": "Change Slime",
	"attribute": "water",
	"level": 1,
	"atk": 400,
	"def": 300,
	"type": "aqua",
	"count_as": null,
	"effect": [],
	"passcode": "18914778"
  },
  "00330": {
	"card_name": "Bone Mouse",
	"attribute": "dark",
	"level": 1,
	"atk": 400,
	"def": 300,
	"type": "zombie",
	"count_as": null,
	"effect": [],
	"passcode": "21239280"
  },
  "00331": {
	"card_name": "Fungi of the Musk",
	"attribute": "dark",
	"level": 1,
	"atk": 400,
	"def": 300,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "53830602"
  },
  "00332": {
	"card_name": "Dark Plant",
	"attribute": "dark",
	"level": 1,
	"atk": 300,
	"def": 400,
	"type": "plant",
	"count_as": null,
	"effect": [],
	"passcode": "13193642"
  },
  "00333": {
	"card_name": "Goblin Attack Force",
	"attribute": "earth",
	"level": 4,
	"atk": 2300,
	"def": 0,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "change_position"
	],
	"passcode": "78658564"
  },
  "00334": {
	"card_name": "Slate Warrior",
	"attribute": "wind",
	"level": 4,
	"atk": 1900,
	"def": 400,
	"type": "fiend",
	"count_as": "warrior",
	"effect": [
	  "on_flip",
	  "slate_warrior"
	],
	"passcode": "78636495"
  },
  "00335": {
	"card_name": "Serpentine Princess",
	"attribute": "water",
	"level": 4,
	"atk": 1400,
	"def": 2000,
	"type": "reptile",
	"count_as": "female",
	"effect": [],
	"passcode": "71829750"
  },
  "00336": {
	"card_name": "Needle Worm",
	"attribute": "earth",
	"level": 2,
	"atk": 750,
	"def": 600,
	"type": "insect",
	"count_as": null,
	"effect": [
	  "on_flip",
	  "mill",
	  5
	],
	"passcode": "81843628"
  },
  "00337": {
	"card_name": "Mystic Lamp",
	"attribute": "dark",
	"level": 1,
	"atk": 400,
	"def": 300,
	"type": "spellcaster",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "98049915"
  },
  "00338": {
	"card_name": "Leghul",
	"attribute": "earth",
	"level": 1,
	"atk": 300,
	"def": 350,
	"type": "insect",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "12472242"
  },
  "00339": {
	"card_name": "Alligator's Sword",
	"attribute": "earth",
	"level": 4,
	"atk": 1500,
	"def": 1200,
	"type": "beast",
	"count_as": "reptile",
	"effect": [],
	"passcode": "64428736"
  },
  "00340": {
	"card_name": "Alligator's Sword Dragon",
	"attribute": "wind",
	"level": 5,
	"atk": 1700,
	"def": 1500,
	"type": "dragon",
	"count_as": "reptile",
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "03366982"
  },
  "00341": {
	"card_name": "Cyber-Tech Alligator",
	"attribute": "wind",
	"level": 5,
	"atk": 2500,
	"def": 1600,
	"type": "machine",
	"count_as": "reptile",
	"effect": [],
	"passcode": "48766543"
  },
  "00342": {
	"card_name": "Spawn Alligator",
	"attribute": "water",
	"level": 5,
	"atk": 2200,
	"def": 1000,
	"type": "reptile",
	"count_as": "warrior",
	"effect": [],
	"passcode": "39984786"
  },
  "00343": {
	"card_name": "Oshaleon",
	"attribute": "water",
	"level": 3,
	"atk": 1400,
	"def": 800,
	"type": "reptile",
	"count_as": "aqua",
	"effect": [],
	"passcode": "71519605"
  },
  "00344": {
	"card_name": "Majioshaleon",
	"attribute": "water",
	"level": 5,
	"atk": 2000,
	"def": 800,
	"type": "reptile",
	"count_as": "aqua",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "67211766"
  },
  "00345": {
	"card_name": "Granadora",
	"attribute": "water",
	"level": 4,
	"atk": 1900,
	"def": 700,
	"type": "reptile",
	"count_as": "fiend",
	"effect": [],
	"passcode": "13944422"
  },
  "00346": {
	"card_name": "Lion Alligator",
	"attribute": "water",
	"level": 4,
	"atk": 1900,
	"def": 200,
	"type": "reptile",
	"count_as": "beast",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "04611269"
  },
  "00347": {
	"card_name": "Archfiend Soldier",
	"attribute": "dark",
	"level": 4,
	"atk": 1900,
	"def": 1500,
	"type": "fiend",
	"count_as": "warrior",
	"effect": [],
	"passcode": "49881766"
  },
  "00348": {
	"card_name": "Beast of Talwar",
	"attribute": "dark",
	"level": 6,
	"atk": 2400,
	"def": 2150,
	"type": "fiend",
	"count_as": "warrior",
	"effect": [],
	"passcode": "11761845"
  },
  "00349": {
	"card_name": "Belial - Marquis of Darkness",
	"attribute": "dark",
	"level": 8,
	"atk": 2800,
	"def": 2400,
	"type": "fiend",
	"count_as": "warrior",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "33655493"
  },
  "00350": {
	"card_name": "Possessed Dark Soul",
	"attribute": "dark",
	"level": 3,
	"atk": 1200,
	"def": 800,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "52860176"
  },
  "00351": {
	"card_name": "Frontier Wiseman",
	"attribute": "earth",
	"level": 3,
	"atk": 1600,
	"def": 800,
	"type": "spellcaster",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "38742075"
  },
  "00352": {
	"card_name": "Dark Balter the Terrible",
	"attribute": "dark",
	"level": 5,
	"atk": 2000,
	"def": 1200,
	"type": "fiend",
	"count_as": "spellcaster",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "80071763"
  },
  "00353": {
	"card_name": "Dark Ruler Ha Des",
	"attribute": "dark",
	"level": 6,
	"atk": 2450,
	"def": 1600,
	"type": "fiend",
	"count_as": "spellcaster",
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "53982768"
  },
  "00354": {
	"card_name": "Des Feral Imp",
	"attribute": "dark",
	"level": 4,
	"atk": 1600,
	"def": 1800,
	"type": "reptile",
	"count_as": "fiend",
	"effect": [],
	"passcode": "81985784"
  },
  "00355": {
	"card_name": "Archfiend Giant",
	"attribute": "dark",
	"level": 6,
	"atk": 2400,
	"def": 1600,
	"type": "fiend",
	"count_as": "beast-warrior",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "84341431"
  },
  "00356": {
	"card_name": "Element Doom",
	"attribute": "dark",
	"level": 4,
	"atk": 1500,
	"def": 1200,
	"type": "fiend",
	"count_as": "winged beast",
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "23118924"
  },
  "00357": {
	"card_name": "Archfiend of Gilfer",
	"attribute": "dark",
	"level": 6,
	"atk": 2200,
	"def": 2500,
	"type": "fiend",
	"count_as": null,
	"effect": [
	  "on_defend",
	  "debuff",
	  500
	],
	"passcode": "50287060"
  },
  "00358": {
	"card_name": "Dragon Seeker",
	"attribute": "dark",
	"level": 6,
	"atk": 2000,
	"def": 2100,
	"type": "fiend",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "dragon"
	],
	"passcode": "28563545"
  },
  "00359": {
	"card_name": "Gil Garth",
	"attribute": "dark",
	"level": 4,
	"atk": 1800,
	"def": 1200,
	"type": "fiend",
	"count_as": "machine",
	"effect": [],
	"passcode": "38445524"
  },
  "00360": {
	"card_name": "Divine Dragon Aquabizarre",
	"attribute": "water",
	"level": 5,
	"atk": 2100,
	"def": 1500,
	"type": "sea serpent",
	"count_as": "aqua",
	"effect": [],
	"passcode": "67964209"
  },
  "00361": {
	"card_name": "Spiral Serpent",
	"attribute": "water",
	"level": 8,
	"atk": 2900,
	"def": 2900,
	"type": "sea serpent",
	"count_as": "aqua",
	"effect": [],
	"passcode": "32626733"
  },
  "00362": {
	"card_name": "Aqua Dragon",
	"attribute": "water",
	"level": 6,
	"atk": 2250,
	"def": 1900,
	"type": "sea serpent",
	"count_as": "dragon",
	"effect": [],
	"passcode": "86164529"
  },
  "00363": {
	"card_name": "Water Dragon",
	"attribute": "water",
	"level": 8,
	"atk": 2800,
	"def": 2600,
	"type": "sea serpent",
	"count_as": "dragon",
	"effect": [
	  "on_summon",
	  "attribute_booster"
	],
	"passcode": "85066822"
  },
  "00364": {
	"card_name": "The Dragon Dwelling in the Deep",
	"attribute": "water",
	"level": 4,
	"atk": 1700,
	"def": 1400,
	"type": "sea serpent",
	"count_as": "dragon",
	"effect": [
	  "on_summon",
	  "friends_power_up",
	  200
	],
	"passcode": "04404099"
  },
  "00365": {
	"card_name": "Airorca",
	"attribute": "wind",
	"level": 3,
	"atk": 1400,
	"def": 300,
	"type": "sea serpent",
	"count_as": "winged beast",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "84747429"
  },
  "00366": {
	"card_name": "Denko Sekka",
	"attribute": "light",
	"level": 4,
	"atk": 1700,
	"def": 1000,
	"type": "thunder",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "13974207"
  },
  "00367": {
	"card_name": "Lightning Rod Lord",
	"attribute": "light",
	"level": 4,
	"atk": 1800,
	"def": 100,
	"type": "thunder",
	"count_as": "zombie",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "40672993"
  },
  "00368": {
	"card_name": "Thunder Sea Horse",
	"attribute": "light",
	"level": 4,
	"atk": 1600,
	"def": 1200,
	"type": "thunder",
	"count_as": "aqua",
	"effect": [],
	"passcode": "48049769"
  },
  "00369": {
	"card_name": "Thunderclap Skywolf",
	"attribute": "light",
	"level": 7,
	"atk": 2500,
	"def": 2000,
	"type": "thunder",
	"count_as": "beast",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "atk_highest"
	],
	"passcode": "13683298"
  },
  "00370": {
	"card_name": "Batteryman Micro-Cell",
	"attribute": "light",
	"level": 1,
	"atk": 100,
	"def": 100,
	"type": "thunder",
	"count_as": "machine",
	"effect": [],
	"passcode": "56839613"
  },
  "00371": {
	"card_name": "Batteryman 9-Volt",
	"attribute": "light",
	"level": 4,
	"atk": 1000,
	"def": 1000,
	"type": "thunder",
	"count_as": "machine",
	"effect": [
	  "on_summon",
	  "self_power_up",
	  200
	],
	"passcode": "60549248"
  },
  "00372": {
	"card_name": "Batteryman Charger",
	"attribute": "light",
	"level": 5,
	"atk": 1800,
	"def": 1200,
	"type": "thunder",
	"count_as": "machine",
	"effect": [
	  "on_summon",
	  "self_power_up",
	  300
	],
	"passcode": "83446909"
  },
  "00373": {
	"card_name": "Batteryman Industrial Strength",
	"attribute": "light",
	"level": 8,
	"atk": 2600,
	"def": 0,
	"type": "thunder",
	"count_as": "machine",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "atk_highest"
	],
	"passcode": "19441018"
  },
  "00374": {
	"card_name": "Hunter of Black Feathers",
	"attribute": "light",
	"level": 4,
	"atk": 1700,
	"def": 1000,
	"type": "beast-warrior",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "73018302"
  },
  "00375": {
	"card_name": "Manticore of Darkness",
	"attribute": "fire",
	"level": 6,
	"atk": 2300,
	"def": 1000,
	"type": "beast-warrior",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "77121851"
  },
  "00376": {
	"card_name": "Garoozis",
	"attribute": "fire",
	"level": 5,
	"atk": 1800,
	"def": 1500,
	"type": "beast-warrior",
	"count_as": "reptile",
	"effect": [],
	"passcode": "14977074"
  },
  "00377": {
	"card_name": "Woodland Archer",
	"attribute": "earth",
	"level": 3,
	"atk": 1400,
	"def": 1300,
	"type": "beast-warrior",
	"count_as": "fairy",
	"effect": [],
	"passcode": "09848939"
  },
  "00378": {
	"card_name": "Cybernetic Cyclopean",
	"attribute": "earth",
	"level": 4,
	"atk": 1400,
	"def": 200,
	"type": "beast-warrior",
	"count_as": "machine",
	"effect": [],
	"passcode": "96428622"
  },
  "00379": {
	"card_name": "Cyber Dinosaur",
	"attribute": "light",
	"level": 7,
	"atk": 2500,
	"def": 1900,
	"type": "machine",
	"count_as": "dinosaur",
	"effect": [],
	"passcode": "39439590"
  },
  "00380": {
	"card_name": "Super Conductor Tyranno",
	"attribute": "light",
	"level": 8,
	"atk": 3300,
	"def": 1400,
	"type": "dinosaur",
	"count_as": "machine",
	"effect": [],
	"passcode": "85520851"
  },
  "00381": {
	"card_name": "Bracchio-raidus",
	"attribute": "water",
	"level": 6,
	"atk": 2200,
	"def": 2000,
	"type": "dinosaur",
	"count_as": null,
	"effect": [],
	"passcode": "16507828"
  },
  "00382": {
	"card_name": "Destroyersaurus",
	"attribute": "earth",
	"level": 4,
	"atk": 1800,
	"def": 1100,
	"type": "dinosaur",
	"count_as": null,
	"effect": [],
	"passcode": "80186010"
  },
  "00383": {
	"card_name": "Black Tyranno",
	"attribute": "earth",
	"level": 7,
	"atk": 2600,
	"def": 1800,
	"type": "dinosaur",
	"count_as": null,
	"effect": [],
	"passcode": "38670435"
  },
  "00384": {
	"card_name": "Ultimate Tyranno",
	"attribute": "earth",
	"level": 8,
	"atk": 3000,
	"def": 2200,
	"type": "dinosaur",
	"count_as": null,
	"effect": [],
	"passcode": "15894048"
  },
  "00385": {
	"card_name": "Megalosmasher X",
	"attribute": "water",
	"level": 4,
	"atk": 2000,
	"def": 0,
	"type": "dinosaur",
	"count_as": "sea serpent",
	"effect": [],
	"passcode": "81823360"
  },
  "00386": {
	"card_name": "Oxygeddon",
	"attribute": "wind",
	"level": 4,
	"atk": 1800,
	"def": 800,
	"type": "dinosaur",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "58071123"
  },
  "00387": {
	"card_name": "Hydrogeddon",
	"attribute": "water",
	"level": 4,
	"atk": 1600,
	"def": 1000,
	"type": "dinosaur",
	"count_as": "aqua",
	"effect": [],
	"passcode": "22587018"
  },
  "00388": {
	"card_name": "Duoterion",
	"attribute": "water",
	"level": 5,
	"atk": 2000,
	"def": 1400,
	"type": "dinosaur",
	"count_as": "aqua",
	"effect": [],
	"passcode": "43017476"
  },
  "00389": {
	"card_name": "Spirit of the Fall Wind",
	"attribute": "wind",
	"level": 4,
	"atk": 1800,
	"def": 900,
	"type": "fairy",
	"count_as": "female",
	"effect": [],
	"passcode": "26517393"
  },
  "00390": {
	"card_name": "Iris the Earth Mother",
	"attribute": "light",
	"level": 6,
	"atk": 2400,
	"def": 1200,
	"type": "fairy",
	"count_as": "female",
	"effect": [],
	"passcode": "09628664"
  },
  "00391": {
	"card_name": "Hysteric Fairy",
	"attribute": "light",
	"level": 4,
	"atk": 1800,
	"def": 500,
	"type": "fairy",
	"count_as": "female",
	"effect": [],
	"passcode": "21297224"
  },
  "00392": {
	"card_name": "Soul of Purity and Light",
	"attribute": "light",
	"level": 6,
	"atk": 2000,
	"def": 1800,
	"type": "fairy",
	"count_as": "female",
	"effect": [],
	"passcode": "77527210"
  },
  "00393": {
	"card_name": "Wingweaver",
	"attribute": "light",
	"level": 7,
	"atk": 2750,
	"def": 2400,
	"type": "fairy",
	"count_as": "female",
	"effect": [],
	"passcode": "31447217"
  },
  "00394": {
	"card_name": "Deep Sweeper",
	"attribute": "water",
	"level": 4,
	"atk": 1600,
	"def": 1300,
	"type": "fish",
	"count_as": "insect",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "08649148"
  },
  "00395": {
	"card_name": "Cyber Shark",
	"attribute": "water",
	"level": 5,
	"atk": 2100,
	"def": 2000,
	"type": "fish",
	"count_as": "machine",
	"effect": [],
	"passcode": "32393580"
  },
  "00396": {
	"card_name": "Hyper-Ancient Shark Megalodon",
	"attribute": "water",
	"level": 8,
	"atk": 2900,
	"def": 1300,
	"type": "fish",
	"count_as": "machine",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "10532969"
  },
  "00397": {
	"card_name": "Aztekipede the Worm Warrior",
	"attribute": "earth",
	"level": 4,
	"atk": 1900,
	"def": 400,
	"type": "insect",
	"count_as": "rock",
	"effect": [
	  "on_attack",
	  "mill",
	  1
	],
	"passcode": "75081613"
  },
  "00398": {
	"card_name": "Hundred-Footed Horror",
	"attribute": "dark",
	"level": 7,
	"atk": 2600,
	"def": 1300,
	"type": "insect",
	"count_as": "rock",
	"effect": [
	  "on_attack",
	  "mill",
	  1
	],
	"passcode": "36029076"
  },
  "00399": {
	"card_name": "Doom Dozer",
	"attribute": "earth",
	"level": 8,
	"atk": 2800,
	"def": 2600,
	"type": "insect",
	"count_as": "rock",
	"effect": [
	  "on_attack",
	  "mill",
	  1
	],
	"passcode": "76039636"
  },
  "00400": {
	"card_name": "Millennium Scorpion",
	"attribute": "earth",
	"level": 5,
	"atk": 2000,
	"def": 1800,
	"type": "insect",
	"count_as": null,
	"effect": [],
	"passcode": "82482194"
  },
  "00401": {
	"card_name": "Mystical Beast of Serket",
	"attribute": "earth",
	"level": 6,
	"atk": 2500,
	"def": 2000,
	"type": "fairy",
	"count_as": null,
	"effect": [],
	"passcode": "89194033"
  },
  "00402": {
	"card_name": "Insect Princess",
	"attribute": "wind",
	"level": 6,
	"atk": 1900,
	"def": 1200,
	"type": "insect",
	"count_as": "female",
	"effect": [],
	"passcode": "37957847"
  },
  "00403": {
	"card_name": "Insect Queen",
	"attribute": "earth",
	"level": 7,
	"atk": 2200,
	"def": 2400,
	"type": "insect",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "self_power_up",
	  200
	],
	"passcode": "91512835"
  },
  "00404": {
	"card_name": "Cybernetic Magician",
	"attribute": "light",
	"level": 6,
	"atk": 2400,
	"def": 1000,
	"type": "spellcaster",
	"count_as": "machine",
	"effect": [],
	"passcode": "59023523"
  },
  "00405": {
	"card_name": "Boar Soldier",
	"attribute": "earth",
	"level": 4,
	"atk": 2000,
	"def": 500,
	"type": "beast-warrior",
	"count_as": null,
	"effect": [],
	"passcode": "21340051"
  },
  "00406": {
	"card_name": "Garnecia Elefantis",
	"attribute": "earth",
	"level": 7,
	"atk": 2400,
	"def": 2000,
	"type": "beast-warrior",
	"count_as": null,
	"effect": [],
	"passcode": "49888191"
  },
  "00407": {
	"card_name": "Takriminos",
	"attribute": "water",
	"level": 4,
	"atk": 1500,
	"def": 1200,
	"type": "sea serpent",
	"count_as": "fish",
	"effect": [],
	"passcode": "44073668"
  },
  "00408": {
	"card_name": "Amphibian Beast",
	"attribute": "water",
	"level": 6,
	"atk": 2400,
	"def": 2000,
	"type": "fish",
	"count_as": null,
	"effect": [],
	"passcode": "67371383"
  },
  "00409": {
	"card_name": "Gearfried the Iron Knight",
	"attribute": "earth",
	"level": 4,
	"atk": 1800,
	"def": 1600,
	"type": "warrior",
	"count_as": "machine",
	"effect": [],
	"passcode": "00423705"
  },
  "00410": {
	"card_name": "Jerry Beans Man",
	"attribute": "earth",
	"level": 3,
	"atk": 1750,
	"def": 0,
	"type": "plant",
	"count_as": "warrior",
	"effect": [],
	"passcode": "23635815"
  },
  "00411": {
	"card_name": "Master Kyonshee",
	"attribute": "earth",
	"level": 4,
	"atk": 1750,
	"def": 1000,
	"type": "zombie",
	"count_as": "warrior",
	"effect": [],
	"passcode": "24530661"
  },
  "00412": {
	"card_name": "Heavy Knight of the Flame",
	"attribute": "fire",
	"level": 4,
	"atk": 1800,
	"def": 200,
	"type": "zombie",
	"count_as": "pyro",
	"effect": [],
	"passcode": "34761062"
  },
  "00413": {
	"card_name": "Skull Flame",
	"attribute": "fire",
	"level": 8,
	"atk": 2600,
	"def": 2000,
	"type": "zombie",
	"count_as": "pyro",
	"effect": [],
	"passcode": "99899504"
  },
  "00414": {
	"card_name": "Great Dezard",
	"attribute": "dark",
	"level": 6,
	"atk": 1900,
	"def": 2300,
	"type": "spellcaster",
	"count_as": "zombie",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "88989706"
  },
  "00415": {
	"card_name": "Fushioh Richie",
	"attribute": "dark",
	"level": 7,
	"atk": 2600,
	"def": 2900,
	"type": "zombie",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "39711336"
  },
  "00416": {
	"card_name": "Skelesaurus",
	"attribute": "dark",
	"level": 4,
	"atk": 1700,
	"def": 1400,
	"type": "zombie",
	"count_as": "rock",
	"effect": [],
	"passcode": "89362180"
  },
  "00417": {
	"card_name": "Darkfire Dragon",
	"attribute": "dark",
	"level": 4,
	"atk": 1500,
	"def": 1250,
	"type": "dragon",
	"count_as": "pyro",
	"effect": [],
	"passcode": "17881964"
  },
  "00418": {
	"card_name": "Twin-Headed Fire Dragon",
	"attribute": "fire",
	"level": 6,
	"atk": 2200,
	"def": 1700,
	"type": "pyro",
	"count_as": "dragon",
	"effect": [],
	"passcode": "78984772"
  },
  "00419": {
	"card_name": "High Tide Gyojin",
	"attribute": "water",
	"level": 4,
	"atk": 1650,
	"def": 1300,
	"type": "aqua",
	"count_as": "fish",
	"effect": [],
	"passcode": "54579801"
  },
  "00420": {
	"card_name": "Fire Kraken",
	"attribute": "fire",
	"level": 4,
	"atk": 1600,
	"def": 1500,
	"type": "aqua",
	"count_as": "pyro",
	"effect": [],
	"passcode": "46534755"
  },
  "00421": {
	"card_name": "Rare Metal Dragon",
	"attribute": "dark",
	"level": 4,
	"atk": 2400,
	"def": 1200,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "25236056"
  },
  "00422": {
	"card_name": "Blazewing Butterfly",
	"attribute": "fire",
	"level": 4,
	"atk": 1500,
	"def": 1500,
	"type": "insect",
	"count_as": "pyro",
	"effect": [],
	"passcode": "16984449"
  },
  "00423": {
	"card_name": "Arcana Knight Joker",
	"attribute": "light",
	"level": 9,
	"atk": 3800,
	"def": 2500,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "06150044"
  },
  "00424": {
	"card_name": "Valkyrion the Magna Warrior",
	"attribute": "earth",
	"level": 8,
	"atk": 3500,
	"def": 3850,
	"type": "rock",
	"count_as": "warrior",
	"effect": [],
	"passcode": "75347539"
  },
  "00425": {
	"card_name": "Sorcerer of Dark Magic",
	"attribute": "dark",
	"level": 9,
	"atk": 3200,
	"def": 2800,
	"type": "spellcaster",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "88619463"
  },
  "00426": {
	"card_name": "Black Luster Soldier",
	"attribute": "earth",
	"level": 8,
	"atk": 3000,
	"def": 2500,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "05405694"
  },
  "00427": {
	"card_name": "Dark Master of Chaos",
	"attribute": "dark",
	"level": 8,
	"atk": 3000,
	"def": 2500,
	"type": "spellcaster",
	"count_as": "warrior",
	"effect": [],
	"passcode": "85059922"
  },
  "00428": {
	"card_name": "Magician of Black Chaos",
	"attribute": "dark",
	"level": 8,
	"atk": 2800,
	"def": 2600,
	"type": "spellcaster",
	"count_as": null,
	"effect": [],
	"passcode": "30208479"
  },
  "00429": {
	"card_name": "Mirror Force",
	"attribute": "trap",
	"level": null,
	"atk": null,
	"def": null,
	"type": "trap",
	"count_as": null,
	"effect": [
	  "mirror_force"
	],
	"passcode": "44095762"
  },
  "00430": {
	"card_name": "Magic Cylinder",
	"attribute": "trap",
	"level": null,
	"atk": null,
	"def": null,
	"type": "trap",
	"count_as": null,
	"effect": [
	  "magic_cylinder"
	],
	"passcode": "62279055"
  },
  "00431": {
	"card_name": "Mirage Knight",
	"attribute": "light",
	"level": 8,
	"atk": 2800,
	"def": 2000,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "burn",
	  "enemy_atk"
	],
	"passcode": "49217579"
  },
  "00432": {
	"card_name": "Des Volstgalph",
	"attribute": "earth",
	"level": 6,
	"atk": 2200,
	"def": 1700,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "burn",
	  500
	],
	"passcode": "81059524"
  },
  "00433": {
	"card_name": "Dark Flare Knight",
	"attribute": "dark",
	"level": 6,
	"atk": 2200,
	"def": 800,
	"type": "warrior",
	"count_as": "pyro",
	"effect": [
	  "on_defend",
	  "no_damage"
	],
	"passcode": "13722870"
  },
  "00434": {
	"card_name": "Chimera the Flying Mythical Beast",
	"attribute": "wind",
	"level": 6,
	"atk": 2100,
	"def": 1800,
	"type": "beast",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "04796100"
  },
  "00435": {
	"card_name": "Gandora the Dragon of Destruction",
	"attribute": "dark",
	"level": 8,
	"atk": 0,
	"def": 0,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "gandora"
	],
	"passcode": "64681432"
  },
  "00436": {
	"card_name": "Black Luster Ritual",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "ritual",
	"count_as": null,
	"effect": [
	  "ritual",
	  426
	],
	"passcode": "55761792"
  },
  "00437": {
	"card_name": "Black Magic Ritual",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "ritual",
	"count_as": null,
	"effect": [
	  "ritual",
	  428
	],
	"passcode": "76792184"
  },
  "00438": {
	"card_name": "Face Card Fusion",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "ritual",
	"count_as": null,
	"effect": [
	  "ritual",
	  423
	],
	"passcode": "29062925"
  },
  "00439": {
	"card_name": "Magnetic Field",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "ritual",
	"count_as": null,
	"effect": [
	  "ritual",
	  424
	],
	"passcode": "04740489"
  },
  "00440": {
	"card_name": "Mystical Elf",
	"attribute": "light",
	"level": 4,
	"atk": 800,
	"def": 2000,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "15025844"
  },
  "00441": {
	"card_name": "Kuriboh",
	"attribute": "dark",
	"level": 1,
	"atk": 300,
	"def": 200,
	"type": "fiend",
	"count_as": null,
	"effect": [
	  "on_defend",
	  "no_damage"
	],
	"passcode": "40640057"
  },
  "00442": {
	"card_name": "Gazelle the King of Mythical Beasts",
	"attribute": "earth",
	"level": 4,
	"atk": 1500,
	"def": 1200,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "05818798"
  },
  "00443": {
	"card_name": "Berfomet",
	"attribute": "dark",
	"level": 5,
	"atk": 1400,
	"def": 1800,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "77207191"
  },
  "00444": {
	"card_name": "Big Shield Gardna",
	"attribute": "earth",
	"level": 4,
	"atk": 100,
	"def": 2600,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_defend",
	  "change_position"
	],
	"passcode": "65240384"
  },
  "00445": {
	"card_name": "Alpha The Magnet Warrior",
	"attribute": "earth",
	"level": 4,
	"atk": 1400,
	"def": 1700,
	"type": "rock",
	"count_as": "warrior",
	"effect": [],
	"passcode": "99785935"
  },
  "00446": {
	"card_name": "Beta The Magnet Warrior",
	"attribute": "earth",
	"level": 4,
	"atk": 1700,
	"def": 1600,
	"type": "rock",
	"count_as": "warrior",
	"effect": [],
	"passcode": "39256679"
  },
  "00447": {
	"card_name": "Gamma The Magnet Warrior",
	"attribute": "earth",
	"level": 4,
	"atk": 1500,
	"def": 1800,
	"type": "rock",
	"count_as": "warrior",
	"effect": [],
	"passcode": "11549357"
  },
  "00448": {
	"card_name": "Jack's Knight",
	"attribute": "light",
	"level": 5,
	"atk": 1900,
	"def": 1000,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "90876561"
  },
  "00449": {
	"card_name": "Queen's Knight",
	"attribute": "light",
	"level": 4,
	"atk": 1500,
	"def": 1600,
	"type": "warrior",
	"count_as": "female",
	"effect": [],
	"passcode": "25652259"
  },
  "00450": {
	"card_name": "King's Knight",
	"attribute": "light",
	"level": 4,
	"atk": 1600,
	"def": 1400,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "64788463"
  },
  "00451": {
	"card_name": "Green Gadget",
	"attribute": "earth",
	"level": 4,
	"atk": 1400,
	"def": 600,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "41172955"
  },
  "00452": {
	"card_name": "Red Gadget",
	"attribute": "earth",
	"level": 4,
	"atk": 1300,
	"def": 1500,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "86445415"
  },
  "00453": {
	"card_name": "Yellow Gadget",
	"attribute": "earth",
	"level": 4,
	"atk": 1200,
	"def": 1200,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "13839120"
  },
  "00454": {
	"card_name": "Gold Gadget",
	"attribute": "light",
	"level": 4,
	"atk": 1700,
	"def": 800,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "55010259"
  },
  "00455": {
	"card_name": "Silver Gadget",
	"attribute": "light",
	"level": 4,
	"atk": 1500,
	"def": 1000,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "29021114"
  },
  "00456": {
	"card_name": "Marshmallon",
	"attribute": "light",
	"level": 3,
	"atk": 300,
	"def": 500,
	"type": "fairy",
	"count_as": null,
	"effect": [
	  "on_defend",
	  "cant_die"
	],
	"passcode": "31305911"
  },
  "00457": {
	"card_name": "Watapon",
	"attribute": "light",
	"level": 1,
	"atk": 200,
	"def": 300,
	"type": "fairy",
	"count_as": null,
	"effect": [],
	"passcode": "87774234"
  },
  "00458": {
	"card_name": "Breaker the Magical Warrior",
	"attribute": "dark",
	"level": 4,
	"atk": 1600,
	"def": 1000,
	"type": "spellcaster",
	"count_as": "warrior",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "71413901"
  },
  "00459": {
	"card_name": "Zombyra the Dark",
	"attribute": "dark",
	"level": 4,
	"atk": 2100,
	"def": 500,
	"type": "warrior",
	"count_as": "fiend",
	"effect": [],
	"passcode": "88472456"
  },
  "00460": {
	"card_name": "Kuribabylon",
	"attribute": "dark",
	"level": 5,
	"atk": 1500,
	"def": 1000,
	"type": "fiend",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  300
	],
	"passcode": "70914287"
  },
  "00461": {
	"card_name": "Kuribandit",
	"attribute": "dark",
	"level": 3,
	"atk": 1000,
	"def": 700,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "16404809"
  },
  "00462": {
	"card_name": "The Tricky",
	"attribute": "wind",
	"level": 5,
	"atk": 2000,
	"def": 1200,
	"type": "spellcaster",
	"count_as": null,
	"effect": [],
	"passcode": "14778250"
  },
  "00463": {
	"card_name": "Beginning Knight",
	"attribute": "light",
	"level": 4,
	"atk": 500,
	"def": 2000,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "06628343"
  },
  "00464": {
	"card_name": "Evening Twilight Knight",
	"attribute": "dark",
	"level": 4,
	"atk": 500,
	"def": 2000,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "32013448"
  },
  "00465": {
	"card_name": "Beaver Warrior",
	"attribute": "earth",
	"level": 4,
	"atk": 1200,
	"def": 1500,
	"type": "beast-warrior",
	"count_as": null,
	"effect": [],
	"passcode": "32452818"
  },
  "00466": {
	"card_name": "Feral Imp",
	"attribute": "dark",
	"level": 4,
	"atk": 1300,
	"def": 1400,
	"type": "fiend",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "41392891"
  },
  "00467": {
	"card_name": "Mushroom Man",
	"attribute": "earth",
	"level": 2,
	"atk": 800,
	"def": 600,
	"type": "plant",
	"count_as": null,
	"effect": [],
	"passcode": "14181608"
  },
  "00468": {
	"card_name": "Griffore",
	"attribute": "earth",
	"level": 4,
	"atk": 1200,
	"def": 1500,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "53829412"
  },
  "00469": {
	"card_name": "Man-Eater Bug",
	"attribute": "earth",
	"level": 2,
	"atk": 450,
	"def": 600,
	"type": "insect",
	"count_as": null,
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "54652250"
  },
  "00470": {
	"card_name": "Great White",
	"attribute": "water",
	"level": 4,
	"atk": 1600,
	"def": 800,
	"type": "fish",
	"count_as": null,
	"effect": [],
	"passcode": "13429800"
  },
  "00471": {
	"card_name": "Maha Vailo",
	"attribute": "light",
	"level": 4,
	"atk": 1550,
	"def": 1400,
	"type": "spellcaster",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "equip_boost"
	],
	"passcode": "93013676"
  },
  "00472": {
	"card_name": "Blockman",
	"attribute": "earth",
	"level": 4,
	"atk": 1000,
	"def": 1500,
	"type": "rock",
	"count_as": null,
	"effect": [],
	"passcode": "48115277"
  },
  "00473": {
	"card_name": "Alchemist of Black Spells",
	"attribute": "wind",
	"level": 4,
	"atk": 1200,
	"def": 1800,
	"type": "spellcaster",
	"count_as": null,
	"effect": [],
	"passcode": "78121572"
  },
  "00474": {
	"card_name": "Toy Magician",
	"attribute": "light",
	"level": 4,
	"atk": 1600,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "machine",
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_enemy_spelltrap"
	],
	"passcode": "58132856"
  },
  "00475": {
	"card_name": "Dunames Dark Witch",
	"attribute": "light",
	"level": 4,
	"atk": 1800,
	"def": 1050,
	"type": "fairy",
	"count_as": "female",
	"effect": [],
	"passcode": "12493482"
  },
  "00476": {
	"card_name": "Battle Steer",
	"attribute": "earth",
	"level": 5,
	"atk": 1800,
	"def": 1300,
	"type": "beast-warrior",
	"count_as": null,
	"effect": [],
	"passcode": "18246479"
  },
  "00477": {
	"card_name": "Rude Kaiser",
	"attribute": "earth",
	"level": 5,
	"atk": 1800,
	"def": 1600,
	"type": "beast-warrior",
	"count_as": null,
	"effect": [],
	"passcode": "26378150"
  },
  "00478": {
	"card_name": "Torike",
	"attribute": "earth",
	"level": 3,
	"atk": 1200,
	"def": 600,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "80813021"
  },
  "00479": {
	"card_name": "Skull Stalker",
	"attribute": "dark",
	"level": 3,
	"atk": 900,
	"def": 800,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "54844990"
  },
  "00480": {
	"card_name": "Ryu-Kishin",
	"attribute": "dark",
	"level": 3,
	"atk": 1000,
	"def": 500,
	"type": "fiend",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "15303296"
  },
  "00481": {
	"card_name": "Terra the Terrible",
	"attribute": "dark",
	"level": 4,
	"atk": 1200,
	"def": 1300,
	"type": "fiend",
	"count_as": "beast-warrior",
	"effect": [],
	"passcode": "63308047"
  },
  "00482": {
	"card_name": "Ansatsu",
	"attribute": "earth",
	"level": 5,
	"atk": 1700,
	"def": 1200,
	"type": "warrior",
	"count_as": "ninja",
	"effect": [],
	"passcode": "48365709"
  },
  "00483": {
	"card_name": "Blue-Eyes Tyrant Dragon",
	"attribute": "light",
	"level": 8,
	"atk": 3400,
	"def": 2900,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "11443677"
  },
  "00484": {
	"card_name": "Mirror Force Dragon",
	"attribute": "light",
	"level": 8,
	"atk": 2800,
	"def": 1200,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "atk_highest"
	],
	"passcode": "84687358"
  },
  "00485": {
	"card_name": "Tyrant Burst Dragon",
	"attribute": "light",
	"level": 8,
	"atk": 2900,
	"def": 2500,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  400
	],
	"passcode": "58293343"
  },
  "00486": {
	"card_name": "Chaos Emperor Dragon - Envoy of the End",
	"attribute": "dark",
	"level": 8,
	"atk": 3000,
	"def": 2500,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "all_enemy_monsters"
	],
	"passcode": "82301904"
  },
  "00487": {
	"card_name": "Mosaic Manticore",
	"attribute": "earth",
	"level": 8,
	"atk": 2800,
	"def": 2500,
	"type": "beast",
	"count_as": "machine",
	"effect": [],
	"passcode": "08483333"
  },
  "00488": {
	"card_name": "Pandemic Dragon",
	"attribute": "dark",
	"level": 7,
	"atk": 2500,
	"def": 1000,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_defend",
	  "debuff",
	  1000
	],
	"passcode": "68299524"
  },
  "00489": {
	"card_name": "Blue-Eyes Chaos MAX Dragon",
	"attribute": "dark",
	"level": 8,
	"atk": 4000,
	"def": 0,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "55410871"
  },
  "00490": {
	"card_name": "Chaos Form",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "ritual",
	"count_as": null,
	"effect": [
	  "ritual",
	  489
	],
	"passcode": "21082832"
  },
  "00491": {
	"card_name": "Cyber-Stein",
	"attribute": "dark",
	"level": 2,
	"atk": 700,
	"def": 500,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "cyber_stein"
	],
	"passcode": "69015963"
  },
  "00492": {
	"card_name": "White-Horned Dragon",
	"attribute": "dark",
	"level": 6,
	"atk": 2200,
	"def": 1400,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "white_horned"
	],
	"passcode": "73891874"
  },
  "00493": {
	"card_name": "Thunder Dragon Titan",
	"attribute": "light",
	"level": 10,
	"atk": 3200,
	"def": 3200,
	"type": "thunder",
	"count_as": "dragon",
	"effect": [],
	"passcode": "41685633"
  },
  "00494": {
	"card_name": "Doom Virus Dragon",
	"attribute": "dark",
	"level": 4,
	"atk": 1900,
	"def": 1500,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "22804644"
  },
  "00495": {
	"card_name": "Destruction Dragon",
	"attribute": "fire",
	"level": 8,
	"atk": 2000,
	"def": 3000,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "burn",
	  "enemy_atk"
	],
	"passcode": "44373896"
  },
  "00496": {
	"card_name": "Crush Card Virus",
	"attribute": "trap",
	"level": null,
	"atk": null,
	"def": null,
	"type": "trap",
	"count_as": null,
	"effect": [
	  "destroy_attacker",
	  1500
	],
	"passcode": "57728570"
  },
  "00497": {
	"card_name": "Ring of Destruction",
	"attribute": "trap",
	"level": null,
	"atk": null,
	"def": null,
	"type": "trap",
	"count_as": null,
	"effect": [
	  "ring_of_destruction"
	],
	"passcode": "83555666"
  },
  "00498": {
	"card_name": "Hyozanryu",
	"attribute": "light",
	"level": 7,
	"atk": 2100,
	"def": 2800,
	"type": "dragon",
	"count_as": "gem",
	"effect": [],
	"passcode": "62397231"
  },
  "00499": {
	"card_name": "Kaiser Glider",
	"attribute": "light",
	"level": 6,
	"atk": 2400,
	"def": 2200,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "52824910"
  },
  "00500": {
	"card_name": "Luster Dragon #2",
	"attribute": "wind",
	"level": 6,
	"atk": 2400,
	"def": 1400,
	"type": "dragon",
	"count_as": "rock",
	"effect": [],
	"passcode": "17658803"
  },
  "00501": {
	"card_name": "Vampire Lord",
	"attribute": "dark",
	"level": 5,
	"atk": 2000,
	"def": 1500,
	"type": "zombie",
	"count_as": "vampire",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "atk_highest"
	],
	"passcode": "53839837"
  },
  "00502": {
	"card_name": "Victory Dragon",
	"attribute": "dark",
	"level": 8,
	"atk": 2400,
	"def": 3000,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "44910027"
  },
  "00503": {
	"card_name": "Kaiser Dragon",
	"attribute": "light",
	"level": 7,
	"atk": 2300,
	"def": 2000,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "94566432"
  },
  "00504": {
	"card_name": "Blue-Eyes Jet Dragon",
	"attribute": "light",
	"level": 8,
	"atk": 3000,
	"def": 0,
	"type": "dragon",
	"count_as": "machine",
	"effect": [],
	"passcode": "30576089"
  },
  "00505": {
	"card_name": "Blue-Eyes Solid Dragon",
	"attribute": "light",
	"level": 8,
	"atk": 2500,
	"def": 2000,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "57043986"
  },
  "00506": {
	"card_name": "The Fang of Critias",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "special_description"
	],
	"passcode": "11082056"
  },
  "00507": {
	"card_name": "Hitotsu-Me Giant",
	"attribute": "earth",
	"level": 4,
	"atk": 1200,
	"def": 1000,
	"type": "beast-warrior",
	"count_as": null,
	"effect": [],
	"passcode": "76184692"
  },
  "00508": {
	"card_name": "Saggi the Dark Clown",
	"attribute": "dark",
	"level": 3,
	"atk": 600,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "clown",
	"effect": [],
	"passcode": "66602787"
  },
  "00509": {
	"card_name": "The Dragon Dwelling in the Cave",
	"attribute": "wind",
	"level": 4,
	"atk": 1300,
	"def": 2000,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "93346024"
  },
  "00510": {
	"card_name": "Empress Judge",
	"attribute": "earth",
	"level": 6,
	"atk": 2100,
	"def": 1700,
	"type": "warrior",
	"count_as": "female",
	"effect": [],
	"passcode": "15237615"
  },
  "00511": {
	"card_name": "Judge Man",
	"attribute": "earth",
	"level": 6,
	"atk": 2200,
	"def": 1500,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "30113682"
  },
  "00512": {
	"card_name": "The Judgement Hand",
	"attribute": "earth",
	"level": 3,
	"atk": 1400,
	"def": 700,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "28003512"
  },
  "00513": {
	"card_name": "La Jinn the Mystical Genie of the Lamp",
	"attribute": "dark",
	"level": 4,
	"atk": 1800,
	"def": 1000,
	"type": "fiend",
	"count_as": "spellcaster",
	"effect": [],
	"passcode": "97590747"
  },
  "00514": {
	"card_name": "Ryu-Kishin Powered",
	"attribute": "dark",
	"level": 4,
	"atk": 1600,
	"def": 1200,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "24611934"
  },
  "00515": {
	"card_name": "Cyber Jar",
	"attribute": "dark",
	"level": 3,
	"atk": 900,
	"def": 900,
	"type": "rock",
	"count_as": null,
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "all_enemy_monsters"
	],
	"passcode": "34124316"
  },
  "00516": {
	"card_name": "Lord of D.",
	"attribute": "dark",
	"level": 4,
	"atk": 1200,
	"def": 1100,
	"type": "spellcaster",
	"count_as": null,
	"effect": [],
	"passcode": "17985575"
  },
  "00517": {
	"card_name": "Divine Dragon Ragnarok",
	"attribute": "light",
	"level": 4,
	"atk": 1500,
	"def": 1000,
	"type": "dragon",
	"count_as": "thunder",
	"effect": [],
	"passcode": "62113340"
  },
  "00518": {
	"card_name": "Lady of D.",
	"attribute": "dark",
	"level": 4,
	"atk": 1500,
	"def": 1100,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "67511500"
  },
  "00519": {
	"card_name": "King Dragun",
	"attribute": "dark",
	"level": 7,
	"atk": 2400,
	"def": 1100,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "13756293"
  },
  "00520": {
	"card_name": "Thunder Dragondark",
	"attribute": "dark",
	"level": 5,
	"atk": 1600,
	"def": 1500,
	"type": "thunder",
	"count_as": "dragon",
	"effect": [],
	"passcode": "56713174"
  },
  "00521": {
	"card_name": "Kaiser Sea Horse",
	"attribute": "light",
	"level": 4,
	"atk": 1700,
	"def": 1650,
	"type": "sea serpent",
	"count_as": "warrior",
	"effect": [],
	"passcode": "17444133"
  },
  "00522": {
	"card_name": "Vorse Raider",
	"attribute": "dark",
	"level": 4,
	"atk": 1900,
	"def": 1200,
	"type": "beast-warrior",
	"count_as": "fiend",
	"effect": [],
	"passcode": "14898066"
  },
  "00523": {
	"card_name": "Luster Dragon",
	"attribute": "wind",
	"level": 4,
	"atk": 1900,
	"def": 1600,
	"type": "dragon",
	"count_as": "rock",
	"effect": [],
	"passcode": "11091375"
  },
  "00524": {
	"card_name": "Spear Dragon",
	"attribute": "wind",
	"level": 4,
	"atk": 1900,
	"def": 0,
	"type": "dragon",
	"count_as": "dinosaur",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "31553716"
  },
  "00525": {
	"card_name": "Block Attack",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "block_attack"
	],
	"passcode": "25880422"
  },
  "00526": {
	"card_name": "Stop Defense",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "stop_defense"
	],
	"passcode": "63102017"
  },
  "00527": {
	"card_name": "De-Fusion",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "destroy_card",
	  "fusion"
	],
	"passcode": "95286165"
  },
  "00528": {
	"card_name": "Ritual Sealing",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "destroy_card",
	  "ritual"
	],
	"passcode": "09145181"
  },
  "00529": {
	"card_name": "Swordstalker",
	"attribute": "dark",
	"level": 6,
	"atk": 2000,
	"def": 1600,
	"type": "warrior",
	"count_as": "fiend",
	"effect": [],
	"passcode": "50005633"
  },
  "00530": {
	"card_name": "Trap Master",
	"attribute": "earth",
	"level": 3,
	"atk": 500,
	"def": 1100,
	"type": "warrior",
	"count_as": "machine",
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_enemy_spelltrap"
	],
	"passcode": "46461247"
  },
  "00531": {
	"card_name": "Dark Zebra",
	"attribute": "earth",
	"level": 4,
	"atk": 1800,
	"def": 400,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "59784896"
  },
  "00532": {
	"card_name": "Gadget Soldier",
	"attribute": "fire",
	"level": 6,
	"atk": 1800,
	"def": 2000,
	"type": "machine",
	"count_as": "warrior",
	"effect": [],
	"passcode": "86281779"
  },
  "00533": {
	"card_name": "Blade Knight",
	"attribute": "light",
	"level": 4,
	"atk": 1600,
	"def": 1000,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "39507162"
  },
  "00534": {
	"card_name": "Cave Dragon",
	"attribute": "wind",
	"level": 4,
	"atk": 2000,
	"def": 100,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "93220472"
  },
  "00535": {
	"card_name": "Fiend Skull Dragon",
	"attribute": "wind",
	"level": 5,
	"atk": 2000,
	"def": 1200,
	"type": "dragon",
	"count_as": "fiend",
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "66235877"
  },
  "00536": {
	"card_name": "Giant Germ",
	"attribute": "dark",
	"level": 2,
	"atk": 1000,
	"def": 100,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "95178994"
  },
  "00537": {
	"card_name": "Paladin of White Dragon",
	"attribute": "light",
	"level": 4,
	"atk": 1900,
	"def": 1200,
	"type": "dragon",
	"count_as": "warrior",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "73398797"
  },
  "00538": {
	"card_name": "White Dragon Ritual",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "ritual",
	"count_as": null,
	"effect": [
	  "ritual",
	  537
	],
	"passcode": "09786492"
  },
  "00539": {
	"card_name": "Thunder Dragonhawk",
	"attribute": "light",
	"level": 6,
	"atk": 1800,
	"def": 2200,
	"type": "thunder",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "83107873"
  },
  "00540": {
	"card_name": "Spirit Ryu",
	"attribute": "wind",
	"level": 4,
	"atk": 1000,
	"def": 1000,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  1000
	],
	"passcode": "67957315"
  },
  "00541": {
	"card_name": "Twin-Headed Behemoth",
	"attribute": "wind",
	"level": 3,
	"atk": 1500,
	"def": 1200,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "43586926"
  },
  "00542": {
	"card_name": "Pitch-Dark Dragon",
	"attribute": "dark",
	"level": 3,
	"atk": 900,
	"def": 600,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "47415292"
  },
  "00543": {
	"card_name": "Dark Blade",
	"attribute": "dark",
	"level": 4,
	"atk": 1800,
	"def": 1500,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "11321183"
  },
  "00544": {
	"card_name": "Dark Blade the Dragon Knight",
	"attribute": "dark",
	"level": 6,
	"atk": 2200,
	"def": 1500,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "86805855"
  },
  "00545": {
	"card_name": "Acrobat Monkey",
	"attribute": "earth",
	"level": 3,
	"atk": 1000,
	"def": 1800,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "47372349"
  },
  "00546": {
	"card_name": "Familiar Knight",
	"attribute": "dark",
	"level": 3,
	"atk": 1200,
	"def": 1400,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "89731911"
  },
  "00547": {
	"card_name": "Axe Dragonute",
	"attribute": "dark",
	"level": 4,
	"atk": 2000,
	"def": 1200,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "change_position"
	],
	"passcode": "84914462"
  },
  "00548": {
	"card_name": "Electric Virus",
	"attribute": "light",
	"level": 3,
	"atk": 1000,
	"def": 1000,
	"type": "thunder",
	"count_as": null,
	"effect": [],
	"passcode": "24725825"
  },
  "00549": {
	"card_name": "Blue-Eyes Toon Dragon",
	"attribute": "light",
	"level": 8,
	"atk": 3000,
	"def": 2500,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "53183600"
  },
  "00550": {
	"card_name": "Toon Summoned Skull",
	"attribute": "dark",
	"level": 6,
	"atk": 2500,
	"def": 1200,
	"type": "fiend",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "91842653"
  },
  "00551": {
	"card_name": "Toon Ancient Gear Golem",
	"attribute": "earth",
	"level": 8,
	"atk": 3000,
	"def": 3000,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "07171149"
  },
  "00552": {
	"card_name": "Toon Barrel Dragon",
	"attribute": "dark",
	"level": 7,
	"atk": 2600,
	"def": 2200,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "28112535"
  },
  "00553": {
	"card_name": "Toon Black Luster Soldier",
	"attribute": "earth",
	"level": 8,
	"atk": 3000,
	"def": 2500,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "28711704"
  },
  "00554": {
	"card_name": "Toon Buster Blader",
	"attribute": "earth",
	"level": 7,
	"atk": 2600,
	"def": 2300,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "61190918"
  },
  "00555": {
	"card_name": "Toon Dark Magician",
	"attribute": "dark",
	"level": 7,
	"atk": 2500,
	"def": 2100,
	"type": "spellcaster",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "21296502"
  },
  "00556": {
	"card_name": "Relinquished",
	"attribute": "dark",
	"level": 1,
	"atk": 0,
	"def": 0,
	"type": "spellcaster",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "copy_atk"
	],
	"passcode": "64631466"
  },
  "00557": {
	"card_name": "Black Illusion Ritual",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "ritual",
	"count_as": null,
	"effect": [
	  "ritual",
	  556
	],
	"passcode": "41426869"
  },
  "00558": {
	"card_name": "Thousand-Eyes Restrict",
	"attribute": "dark",
	"level": 1,
	"atk": 0,
	"def": 0,
	"type": "spellcaster",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "copy_atk"
	],
	"passcode": "63519819"
  },
  "00559": {
	"card_name": "Ryu-Ran",
	"attribute": "fire",
	"level": 7,
	"atk": 2200,
	"def": 2600,
	"type": "dragon",
	"count_as": "egg",
	"effect": [],
	"passcode": "02964201"
  },
  "00560": {
	"card_name": "Manga Ryu-Ran",
	"attribute": "fire",
	"level": 7,
	"atk": 2200,
	"def": 2600,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "38369349"
  },
  "00561": {
	"card_name": "Toon Gemini Elf",
	"attribute": "earth",
	"level": 4,
	"atk": 1900,
	"def": 900,
	"type": "spellcaster",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "42386471"
  },
  "00562": {
	"card_name": "Toon Dark Magician Girl",
	"attribute": "dark",
	"level": 6,
	"atk": 2000,
	"def": 1700,
	"type": "spellcaster",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "90960358"
  },
  "00563": {
	"card_name": "Red-Eyes Toon Dragon",
	"attribute": "dark",
	"level": 7,
	"atk": 2400,
	"def": 2000,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "31733941"
  },
  "00564": {
	"card_name": "Toon Goblin Attack Force",
	"attribute": "earth",
	"level": 4,
	"atk": 2300,
	"def": 0,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "15270885"
  },
  "00565": {
	"card_name": "Toon Cyber Dragon",
	"attribute": "light",
	"level": 5,
	"atk": 2100,
	"def": 1600,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "83629030"
  },
  "00566": {
	"card_name": "Bickuribox",
	"attribute": "dark",
	"level": 7,
	"atk": 2300,
	"def": 2000,
	"type": "fiend",
	"count_as": "clown",
	"effect": [],
	"passcode": "25655502"
  },
  "00567": {
	"card_name": "Neo Aqua Madoor",
	"attribute": "water",
	"level": 6,
	"atk": 1200,
	"def": 3000,
	"type": "spellcaster",
	"count_as": null,
	"effect": [],
	"passcode": "49563947"
  },
  "00568": {
	"card_name": "Red Archery Girl",
	"attribute": "water",
	"level": 4,
	"atk": 1400,
	"def": 1500,
	"type": "aqua",
	"count_as": "female",
	"effect": [],
	"passcode": "65570596"
  },
  "00569": {
	"card_name": "Toon Mermaid",
	"attribute": "water",
	"level": 4,
	"atk": 1400,
	"def": 1500,
	"type": "aqua",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "65458948"
  },
  "00570": {
	"card_name": "Gemini Elf",
	"attribute": "earth",
	"level": 4,
	"atk": 1900,
	"def": 900,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "69140098"
  },
  "00571": {
	"card_name": "Masked Sorcerer",
	"attribute": "dark",
	"level": 4,
	"atk": 900,
	"def": 1400,
	"type": "spellcaster",
	"count_as": "machine",
	"effect": [],
	"passcode": "10189126"
  },
  "00572": {
	"card_name": "Toon Masked Sorcerer",
	"attribute": "dark",
	"level": 4,
	"atk": 900,
	"def": 1400,
	"type": "spellcaster",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "16392422"
  },
  "00573": {
	"card_name": "Toon Cannon Soldier",
	"attribute": "dark",
	"level": 4,
	"atk": 1400,
	"def": 1300,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "79875176"
  },
  "00574": {
	"card_name": "Cannon Soldier",
	"attribute": "dark",
	"level": 4,
	"atk": 1400,
	"def": 1300,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "burn",
	  500
	],
	"passcode": "11384280"
  },
  "00575": {
	"card_name": "Cannon Soldier MK-2",
	"attribute": "earth",
	"level": 5,
	"atk": 1900,
	"def": 1200,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "burn",
	  1500
	],
	"passcode": "14702066"
  },
  "00576": {
	"card_name": "Toon Harpie Lady",
	"attribute": "wind",
	"level": 4,
	"atk": 1300,
	"def": 1400,
	"type": "winged beast",
	"count_as": "harpie",
	"effect": [
	  "on_attack",
	  "toon"
	],
	"passcode": "64116319"
  },
  "00577": {
	"card_name": "Toon Alligator",
	"attribute": "water",
	"level": 4,
	"atk": 800,
	"def": 1600,
	"type": "reptile",
	"count_as": null,
	"effect": [],
	"passcode": "59383041"
  },
  "00578": {
	"card_name": "Crass Clown",
	"attribute": "dark",
	"level": 4,
	"atk": 1350,
	"def": 1400,
	"type": "fiend",
	"count_as": "clown",
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "93889755"
  },
  "00579": {
	"card_name": "Dream Clown",
	"attribute": "earth",
	"level": 3,
	"atk": 1200,
	"def": 900,
	"type": "warrior",
	"count_as": "clown",
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "13215230"
  },
  "00580": {
	"card_name": "Hungry Burger",
	"attribute": "dark",
	"level": 6,
	"atk": 2000,
	"def": 1850,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "30243636"
  },
  "00581": {
	"card_name": "Hamburger Recipe",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "ritual",
	"count_as": null,
	"effect": [
	  "ritual",
	  579
	],
	"passcode": "80811661"
  },
  "00582": {
	"card_name": "Toon World",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "special_description"
	],
	"passcode": "15259703"
  },
  "00583": {
	"card_name": "Dark-Eyes Illusionist",
	"attribute": "dark",
	"level": 2,
	"atk": 0,
	"def": 1400,
	"type": "spellcaster",
	"count_as": null,
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "38247752"
  },
  "00584": {
	"card_name": "Dragon Piper",
	"attribute": "fire",
	"level": 3,
	"atk": 200,
	"def": 1800,
	"type": "pyro",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "dragon"
	],
	"passcode": "55763552"
  },
  "00585": {
	"card_name": "Jigen Bakudan",
	"attribute": "fire",
	"level": 2,
	"atk": 200,
	"def": 1000,
	"type": "pyro",
	"count_as": "machine",
	"effect": [
	  "on_flip",
	  "jigen_bakudan"
	],
	"passcode": "90020065"
  },
  "00586": {
	"card_name": "Aqua Madoor",
	"attribute": "water",
	"level": 4,
	"atk": 1200,
	"def": 2000,
	"type": "spellcaster",
	"count_as": null,
	"effect": [],
	"passcode": "85639257"
  },
  "00587": {
	"card_name": "Soul Hunter",
	"attribute": "dark",
	"level": 6,
	"atk": 2200,
	"def": 1800,
	"type": "fiend",
	"count_as": "clown",
	"effect": [],
	"passcode": "72869010"
  },
  "00588": {
	"card_name": "Mystic Clown",
	"attribute": "dark",
	"level": 4,
	"atk": 1500,
	"def": 1000,
	"type": "fiend",
	"count_as": "clown",
	"effect": [],
	"passcode": "47060154"
  },
  "00589": {
	"card_name": "Parrot Dragon",
	"attribute": "wind",
	"level": 5,
	"atk": 2000,
	"def": 1300,
	"type": "dragon",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "62762898"
  },
  "00590": {
	"card_name": "Illusionist Faceless Mage",
	"attribute": "dark",
	"level": 5,
	"atk": 1200,
	"def": 2200,
	"type": "spellcaster",
	"count_as": null,
	"effect": [],
	"passcode": "28546905"
  },
  "00591": {
	"card_name": "Rogue Doll",
	"attribute": "light",
	"level": 4,
	"atk": 1600,
	"def": 1000,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "91939608"
  },
  "00592": {
	"card_name": "Dark Rabbit",
	"attribute": "dark",
	"level": 4,
	"atk": 1100,
	"def": 1500,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "99261403"
  },
  "00593": {
	"card_name": "Harpie Lady",
	"attribute": "wind",
	"level": 4,
	"atk": 1300,
	"def": 1400,
	"type": "winged beast",
	"count_as": "harpie",
	"effect": [],
	"passcode": "76812113"
  },
  "00594": {
	"card_name": "Phantom Skyblaster",
	"attribute": "dark",
	"level": 4,
	"atk": 1100,
	"def": 800,
	"type": "fiend",
	"count_as": "winged beast",
	"effect": [
	  "on_attack",
	  "burn",
	  300
	],
	"passcode": "12958919"
  },
  "00595": {
	"card_name": "Genin",
	"attribute": "light",
	"level": 3,
	"atk": 600,
	"def": 900,
	"type": "spellcaster",
	"count_as": "clown",
	"effect": [],
	"passcode": "49370026"
  },
  "00596": {
	"card_name": "Niwatori",
	"attribute": "earth",
	"level": 3,
	"atk": 900,
	"def": 800,
	"type": "winged beast",
	"count_as": null,
	"effect": [],
	"passcode": "07805359"
  },
  "00597": {
	"card_name": "Stuffed Animal",
	"attribute": "earth",
	"level": 3,
	"atk": 1200,
	"def": 900,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "71068263"
  },
  "00598": {
	"card_name": "Thousand-Eyes Idol",
	"attribute": "dark",
	"level": 1,
	"atk": 0,
	"def": 0,
	"type": "spellcaster",
	"count_as": null,
	"effect": [],
	"passcode": "27125110"
  },
  "00599": {
	"card_name": "Wattkid",
	"attribute": "light",
	"level": 3,
	"atk": 1000,
	"def": 500,
	"type": "thunder",
	"count_as": null,
	"effect": [],
	"passcode": "27324313"
  },
  "00600": {
	"card_name": "Flying Elephant",
	"attribute": "wind",
	"level": 4,
	"atk": 1850,
	"def": 1300,
	"type": "beast",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "66765023"
  },
  "00601": {
	"card_name": "Sonic Bird",
	"attribute": "wind",
	"level": 4,
	"atk": 1400,
	"def": 1000,
	"type": "winged beast",
	"count_as": null,
	"effect": [],
	"passcode": "57617178"
  },
  "00602": {
	"card_name": "Wood Clown",
	"attribute": "earth",
	"level": 3,
	"atk": 800,
	"def": 1200,
	"type": "warrior",
	"count_as": "clown",
	"effect": [],
	"passcode": "17511156"
  },
  "00603": {
	"card_name": "Tyrant Dragon",
	"attribute": "fire",
	"level": 8,
	"atk": 2900,
	"def": 2500,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "94568601"
  },
  "00604": {
	"card_name": "Dark Dust Spirit",
	"attribute": "earth",
	"level": 6,
	"atk": 2200,
	"def": 1800,
	"type": "zombie",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "all_enemy_monsters"
	],
	"passcode": "89111398"
  },
  "00605": {
	"card_name": "Mystical Knight of Jackal",
	"attribute": "light",
	"level": 7,
	"atk": 2700,
	"def": 1200,
	"type": "beast-warrior",
	"count_as": null,
	"effect": [],
	"passcode": "98745000"
  },
  "00606": {
	"card_name": "Firewing Pegasus",
	"attribute": "fire",
	"level": 6,
	"atk": 2250,
	"def": 1800,
	"type": "beast",
	"count_as": "pyro",
	"effect": [],
	"passcode": "27054370"
  },
  "00607": {
	"card_name": "Guardian Sphinx",
	"attribute": "earth",
	"level": 5,
	"atk": 1700,
	"def": 2400,
	"type": "rock",
	"count_as": null,
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "40659562"
  },
  "00608": {
	"card_name": "Hieracosphinx",
	"attribute": "earth",
	"level": 6,
	"atk": 2400,
	"def": 1200,
	"type": "rock",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "82260502"
  },
  "00609": {
	"card_name": "The End of Anubis",
	"attribute": "dark",
	"level": 6,
	"atk": 2500,
	"def": 0,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "65403020"
  },
  "00610": {
	"card_name": "Ra's Disciple",
	"attribute": "light",
	"level": 4,
	"atk": 1100,
	"def": 600,
	"type": "fairy",
	"count_as": null,
	"effect": [],
	"passcode": "74875003"
  },
  "00611": {
	"card_name": "Ghost Knight of Jackal",
	"attribute": "earth",
	"level": 5,
	"atk": 1700,
	"def": 1600,
	"type": "beast-warrior",
	"count_as": null,
	"effect": [],
	"passcode": "13386503"
  },
  "00612": {
	"card_name": "Emissary of the Afterlife",
	"attribute": "dark",
	"level": 4,
	"atk": 1600,
	"def": 600,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "75043725"
  },
  "00613": {
	"card_name": "Wandering Mummy",
	"attribute": "earth",
	"level": 4,
	"atk": 1500,
	"def": 1500,
	"type": "zombie",
	"count_as": null,
	"effect": [],
	"passcode": "42994702"
  },
  "00614": {
	"card_name": "Exploder Dragon",
	"attribute": "earth",
	"level": 3,
	"atk": 1000,
	"def": 0,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_defend",
	  "no_damage"
	],
	"passcode": "20586572"
  },
  "00615": {
	"card_name": "Pyramid Turtle",
	"attribute": "earth",
	"level": 4,
	"atk": 1200,
	"def": 1400,
	"type": "zombie",
	"count_as": "turtle",
	"effect": [],
	"passcode": "77044671"
  },
  "00616": {
	"card_name": "Royal Keeper",
	"attribute": "earth",
	"level": 4,
	"atk": 1600,
	"def": 1700,
	"type": "zombie",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  300
	],
	"passcode": "16509093"
  },
  "00617": {
	"card_name": "Poison Mummy",
	"attribute": "earth",
	"level": 4,
	"atk": 1000,
	"def": 1800,
	"type": "zombie",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "burn",
	  500
	],
	"passcode": "43716289"
  },
  "00618": {
	"card_name": "Guardian Statue",
	"attribute": "earth",
	"level": 4,
	"atk": 800,
	"def": 1400,
	"type": "rock",
	"count_as": null,
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "75209824"
  },
  "00619": {
	"card_name": "Swarm of Scarabs",
	"attribute": "dark",
	"level": 3,
	"atk": 500,
	"def": 1000,
	"type": "insect",
	"count_as": null,
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "15383415"
  },
  "00620": {
	"card_name": "Night Assailant",
	"attribute": "dark",
	"level": 3,
	"atk": 200,
	"def": 500,
	"type": "fiend",
	"count_as": null,
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "16226786"
  },
  "00621": {
	"card_name": "Swarm of Locusts",
	"attribute": "dark",
	"level": 3,
	"atk": 1000,
	"def": 500,
	"type": "insect",
	"count_as": null,
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_enemy_spelltrap"
	],
	"passcode": "41872150"
  },
  "00622": {
	"card_name": "Cobraman Sakuzy",
	"attribute": "earth",
	"level": 3,
	"atk": 800,
	"def": 1400,
	"type": "reptile",
	"count_as": null,
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_enemy_spelltrap"
	],
	"passcode": "75109441"
  },
  "00623": {
	"card_name": "Makyura the Destructor",
	"attribute": "dark",
	"level": 4,
	"atk": 1600,
	"def": 1200,
	"type": "warrior",
	"count_as": "fiend",
	"effect": [],
	"passcode": "21593977"
  },
  "00624": {
	"card_name": "Fairy Dragon",
	"attribute": "wind",
	"level": 4,
	"atk": 1100,
	"def": 1200,
	"type": "dragon",
	"count_as": "fairy",
	"effect": [],
	"passcode": "20315854"
  },
  "00625": {
	"card_name": "Sinister Serpent",
	"attribute": "water",
	"level": 1,
	"atk": 300,
	"def": 250,
	"type": "reptile",
	"count_as": null,
	"effect": [],
	"passcode": "08131171"
  },
  "00626": {
	"card_name": "Prisman",
	"attribute": "light",
	"level": 3,
	"atk": 800,
	"def": 1000,
	"type": "rock",
	"count_as": null,
	"effect": [],
	"passcode": "80234301"
  },
  "00627": {
	"card_name": "Gilford the Lightning",
	"attribute": "light",
	"level": 8,
	"atk": 2800,
	"def": 1400,
	"type": "warrior",
	"count_as": "thunder",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "all_enemy_monsters"
	],
	"passcode": "36354007"
  },
  "00628": {
	"card_name": "Red-Eyes Darkness Metal Dragon",
	"attribute": "dark",
	"level": 10,
	"atk": 2800,
	"def": 2400,
	"type": "dragon",
	"count_as": "machine",
	"effect": [],
	"passcode": "88264978"
  },
  "00629": {
	"card_name": "Red-Eyes Slash Dragon",
	"attribute": "dark",
	"level": 7,
	"atk": 2800,
	"def": 2400,
	"type": "dragon",
	"count_as": "warrior",
	"effect": [
	  "on_summon",
	  "self_power_up",
	  200
	],
	"passcode": "21140872"
  },
  "00630": {
	"card_name": "Gilti-Gearfried the Magical Steel Knight",
	"attribute": "light",
	"level": 8,
	"atk": 2700,
	"def": 1600,
	"type": "warrior",
	"count_as": "spellcaster",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "49161188"
  },
  "00631": {
	"card_name": "Jinzo - Lord",
	"attribute": "dark",
	"level": 8,
	"atk": 2600,
	"def": 1600,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "jinzo",
	  300
	],
	"passcode": "35803249"
  },
  "00632": {
	"card_name": "Red-Eyes Black Dragon Sword",
	"attribute": "dark",
	"level": 7,
	"atk": 2400,
	"def": 2000,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "friends_power_up",
	  500
	],
	"passcode": "19747827"
  },
  "00633": {
	"card_name": "Jinzo",
	"attribute": "dark",
	"level": 6,
	"atk": 2400,
	"def": 1500,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "jinzo",
	  0
	],
	"passcode": "77585513"
  },
  "00634": {
	"card_name": "Fortress Whale",
	"attribute": "water",
	"level": 7,
	"atk": 2350,
	"def": 2150,
	"type": "fish",
	"count_as": null,
	"effect": [],
	"passcode": "62337487"
  },
  "00635": {
	"card_name": "Fortress Whale's Oath",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "ritual",
	"count_as": null,
	"effect": [
	  "ritual",
	  634
	],
	"passcode": "77454922"
  },
  "00636": {
	"card_name": "Gearfried the Swordmaster",
	"attribute": "light",
	"level": 7,
	"atk": 2600,
	"def": 2200,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "57046845"
  },
  "00637": {
	"card_name": "Release Restraint",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "ritual",
	"count_as": null,
	"effect": [
	  "ritual",
	  636
	],
	"passcode": "75417459"
  },
  "00638": {
	"card_name": "Sword Hunter",
	"attribute": "earth",
	"level": 7,
	"atk": 2450,
	"def": 1700,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  200
	],
	"passcode": "51345461"
  },
  "00639": {
	"card_name": "Lord of the Red",
	"attribute": "fire",
	"level": 8,
	"atk": 2400,
	"def": 2100,
	"type": "dragon",
	"count_as": "warrior",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "19025379"
  },
  "00640": {
	"card_name": "Red-Eyes Transmigration",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "ritual",
	"count_as": null,
	"effect": [
	  "ritual",
	  639
	],
	"passcode": "45410988"
  },
  "00641": {
	"card_name": "Maximum Six",
	"attribute": "earth",
	"level": 6,
	"atk": 1900,
	"def": 1600,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  "random_dice"
	],
	"passcode": "30707994"
  },
  "00642": {
	"card_name": "Divine Knight Ishzark",
	"attribute": "light",
	"level": 6,
	"atk": 2300,
	"def": 1800,
	"type": "warrior",
	"count_as": "fairy",
	"effect": [],
	"passcode": "57902462"
  },
  "00643": {
	"card_name": "Red-Eyes Black Flare Dragon",
	"attribute": "dark",
	"level": 7,
	"atk": 2400,
	"def": 2000,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "burn",
	  2400
	],
	"passcode": "30079770"
  },
  "00644": {
	"card_name": "Time Wizard of Tomorrow",
	"attribute": "light",
	"level": 5,
	"atk": 2000,
	"def": 1900,
	"type": "spellcaster",
	"count_as": null,
	"effect": [
	  "special_description"
	],
	"passcode": "26273196"
  },
  "00645": {
	"card_name": "Red-Eyes Darkness Dragon",
	"attribute": "dark",
	"level": 9,
	"atk": 2400,
	"def": 2000,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  300
	],
	"passcode": "96561011"
  },
  "00646": {
	"card_name": "Red-Eyes Zombie Dragon",
	"attribute": "dark",
	"level": 7,
	"atk": 2400,
	"def": 2000,
	"type": "zombie",
	"count_as": "dragon",
	"effect": [],
	"passcode": "05186893"
  },
  "00647": {
	"card_name": "Copycat",
	"attribute": "light",
	"level": 1,
	"atk": 0,
	"def": 0,
	"type": "spellcaster",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "copy_atk"
	],
	"passcode": "26376390"
  },
  "00648": {
	"card_name": "Shield & Sword",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "sword_shield"
	],
	"passcode": "52097679"
  },
  "00649": {
	"card_name": "Graceful Dice",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "atk_up",
	  "random_dice",
	  "player_monsters"
	],
	"passcode": "74137509"
  },
  "00650": {
	"card_name": "Skull Dice",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "atk_down",
	  "random_dice",
	  "enemy_monsters"
	],
	"passcode": "00126218"
  },
  "00651": {
	"card_name": "Panther Warrior",
	"attribute": "earth",
	"level": 4,
	"atk": 2000,
	"def": 1600,
	"type": "beast-warrior",
	"count_as": null,
	"effect": [],
	"passcode": "42035044"
  },
  "00652": {
	"card_name": "Giltia the D. Knight",
	"attribute": "light",
	"level": 5,
	"atk": 1850,
	"def": 1500,
	"type": "warrior",
	"count_as": "spellcaster",
	"effect": [],
	"passcode": "51828629"
  },
  "00653": {
	"card_name": "Axe Raider",
	"attribute": "earth",
	"level": 4,
	"atk": 1700,
	"def": 1150,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "48305365"
  },
  "00654": {
	"card_name": "Armored Lizard",
	"attribute": "earth",
	"level": 4,
	"atk": 1500,
	"def": 1200,
	"type": "reptile",
	"count_as": null,
	"effect": [],
	"passcode": "15480588"
  },
  "00655": {
	"card_name": "Little-Winguard",
	"attribute": "wind",
	"level": 4,
	"atk": 1400,
	"def": 1800,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "90790253"
  },
  "00656": {
	"card_name": "Swordsman of Landstar",
	"attribute": "earth",
	"level": 3,
	"atk": 500,
	"def": 1200,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "03573512"
  },
  "00657": {
	"card_name": "The Legendary Fisherman",
	"attribute": "water",
	"level": 5,
	"atk": 1850,
	"def": 1600,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "03643300"
  },
  "00658": {
	"card_name": "Rocket Warrior",
	"attribute": "light",
	"level": 4,
	"atk": 1500,
	"def": 1300,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "rocket_warrior"
	],
	"passcode": "30860696"
  },
  "00659": {
	"card_name": "The Fiend Megacyber",
	"attribute": "dark",
	"level": 6,
	"atk": 2200,
	"def": 1200,
	"type": "warrior",
	"count_as": "fiend",
	"effect": [],
	"passcode": "66362965"
  },
  "00660": {
	"card_name": "Command Knight",
	"attribute": "fire",
	"level": 4,
	"atk": 1200,
	"def": 1900,
	"type": "warrior",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "friends_power_up",
	  400
	],
	"passcode": "10375182"
  },
  "00661": {
	"card_name": "D.D. Warrior Lady",
	"attribute": "light",
	"level": 4,
	"atk": 1500,
	"def": 1600,
	"type": "warrior",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "mutual_banish"
	],
	"passcode": "07572887"
  },
  "00662": {
	"card_name": "D.D. Warrior",
	"attribute": "earth",
	"level": 4,
	"atk": 1200,
	"def": 1000,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "mutual_banish"
	],
	"passcode": "37043180"
  },
  "00663": {
	"card_name": "Red-Eyes Baby Dragon",
	"attribute": "dark",
	"level": 3,
	"atk": 1200,
	"def": 700,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "58257569"
  },
  "00664": {
	"card_name": "Red-Eyes Wyvern",
	"attribute": "wind",
	"level": 4,
	"atk": 1800,
	"def": 1600,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "67300516"
  },
  "00665": {
	"card_name": "Red-Eyes Retro Dragon",
	"attribute": "dark",
	"level": 4,
	"atk": 1700,
	"def": 1600,
	"type": "dragon",
	"count_as": "machine",
	"effect": [],
	"passcode": "53485634"
  },
  "00666": {
	"card_name": "Paladin of Dark Dragon",
	"attribute": "dark",
	"level": 4,
	"atk": 1900,
	"def": 1200,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "71408082"
  },
  "00667": {
	"card_name": "Dark Dragon Ritual",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "ritual",
	"count_as": null,
	"effect": [
	  "ritual",
	  666
	],
	"passcode": "18803791"
  },
  "00668": {
	"card_name": "Hundred Dragon",
	"attribute": "wind",
	"level": 4,
	"atk": 1800,
	"def": 1000,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  100
	],
	"passcode": "90788081"
  },
  "00669": {
	"card_name": "Jinzo - Returner",
	"attribute": "dark",
	"level": 3,
	"atk": 600,
	"def": 1400,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "09418534"
  },
  "00670": {
	"card_name": "Karbonala Warrior",
	"attribute": "earth",
	"level": 4,
	"atk": 1500,
	"def": 1200,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "54541900"
  },
  "00671": {
	"card_name": "Kagemusha of the Blue Flame",
	"attribute": "earth",
	"level": 2,
	"atk": 800,
	"def": 400,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "15401633"
  },
  "00672": {
	"card_name": "M-Warrior #1",
	"attribute": "earth",
	"level": 3,
	"atk": 1000,
	"def": 500,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "56342351"
  },
  "00673": {
	"card_name": "M-Warrior #2",
	"attribute": "earth",
	"level": 3,
	"atk": 500,
	"def": 1000,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "92731455"
  },
  "00674": {
	"card_name": "Kojikocy",
	"attribute": "earth",
	"level": 4,
	"atk": 1500,
	"def": 1200,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "01184620"
  },
  "00675": {
	"card_name": "Marauding Captain",
	"attribute": "earth",
	"level": 3,
	"atk": 1200,
	"def": 400,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "02460565"
  },
  "00676": {
	"card_name": "Leogun",
	"attribute": "earth",
	"level": 5,
	"atk": 1750,
	"def": 1550,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "10538007"
  },
  "00677": {
	"card_name": "Anthrosaurus",
	"attribute": "earth",
	"level": 3,
	"atk": 1000,
	"def": 850,
	"type": "dinosaur",
	"count_as": null,
	"effect": [],
	"passcode": "89904598"
  },
  "00678": {
	"card_name": "Claw Reacher",
	"attribute": "dark",
	"level": 3,
	"atk": 1000,
	"def": 800,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "41218256"
  },
  "00679": {
	"card_name": "Armed Ninja",
	"attribute": "earth",
	"level": 1,
	"atk": 300,
	"def": 300,
	"type": "warrior",
	"count_as": "ninja",
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_enemy_spelltrap"
	],
	"passcode": "09076207"
  },
  "00680": {
	"card_name": "Easter Egg Controller",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "special_description"
	],
	"passcode": "40028922"
  },
  "00681": {
	"card_name": "Rainbow Neos",
	"attribute": "light",
	"level": 10,
	"atk": 4500,
	"def": 3000,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "all_enemy_monsters"
	],
	"passcode": "86346643"
  },
  "00682": {
	"card_name": "Elemental HERO Divine Neos",
	"attribute": "light",
	"level": 12,
	"atk": 3000,
	"def": 2500,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "monster_count_boost",
	  500
	],
	"passcode": "31111109"
  },
  "00683": {
	"card_name": "Elemental HERO Cosmo Neos",
	"attribute": "light",
	"level": 11,
	"atk": 3500,
	"def": 3000,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "90050480"
  },
  "00684": {
	"card_name": "Elemental HERO Magma Neos",
	"attribute": "fire",
	"level": 9,
	"atk": 3000,
	"def": 2500,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "monster_count_boost",
	  400
	],
	"passcode": "78512663"
  },
  "00685": {
	"card_name": "Elemental HERO Nebula Neos",
	"attribute": "earth",
	"level": 9,
	"atk": 3000,
	"def": 2500,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "40080312"
  },
  "00686": {
	"card_name": "Elemental HERO Chaos Neos",
	"attribute": "dark",
	"level": 9,
	"atk": 3000,
	"def": 2500,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "all_enemy_monsters"
	],
	"passcode": "17032740"
  },
  "00687": {
	"card_name": "Elemental HERO Electrum",
	"attribute": "light",
	"level": 10,
	"atk": 2900,
	"def": 2600,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "monster_count_boost",
	  300
	],
	"passcode": "29343734"
  },
  "00688": {
	"card_name": "Elemental HERO Core",
	"attribute": "earth",
	"level": 9,
	"atk": 2700,
	"def": 2200,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_defend",
	  "ehero_core"
	],
	"passcode": "95486586"
  },
  "00689": {
	"card_name": "Contrast HERO Chaos",
	"attribute": "dark",
	"level": 9,
	"atk": 3000,
	"def": 2600,
	"type": "warrior",
	"count_as": "masked",
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "23204029"
  },
  "00690": {
	"card_name": "Masked HERO Divine Wind",
	"attribute": "wind",
	"level": 8,
	"atk": 2700,
	"def": 1900,
	"type": "warrior",
	"count_as": "masked",
	"effect": [
	  "on_defend",
	  "cant_die"
	],
	"passcode": "22093873"
  },
  "00691": {
	"card_name": "Masked HERO Dian",
	"attribute": "earth",
	"level": 8,
	"atk": 2800,
	"def": 3000,
	"type": "warrior",
	"count_as": "masked",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "62624486"
  },
  "00692": {
	"card_name": "Masked HERO Koga",
	"attribute": "light",
	"level": 8,
	"atk": 2500,
	"def": 1800,
	"type": "warrior",
	"count_as": "masked",
	"effect": [
	  "on_summon",
	  "monster_count_boost",
	  500
	],
	"passcode": "50608164"
  },
  "00693": {
	"card_name": "Masked HERO Acid",
	"attribute": "water",
	"level": 8,
	"atk": 2600,
	"def": 2100,
	"type": "warrior",
	"count_as": "masked",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "all_enemy_spelltraps"
	],
	"passcode": "29095552"
  },
  "00694": {
	"card_name": "Masked HERO Anki",
	"attribute": "dark",
	"level": 8,
	"atk": 2800,
	"def": 1200,
	"type": "warrior",
	"count_as": "masked",
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "59642500"
  },
  "00695": {
	"card_name": "Mask Change",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "special_description"
	],
	"passcode": "21143940"
  },
  "00696": {
	"card_name": "Elemental HERO Terra Firma",
	"attribute": "earth",
	"level": 8,
	"atk": 2500,
	"def": 2000,
	"type": "warrior",
	"count_as": "rock",
	"effect": [
	  "on_summon",
	  "self_power_up",
	  300
	],
	"passcode": "74711057"
  },
  "00697": {
	"card_name": "Elemental HERO Thunder Giant",
	"attribute": "light",
	"level": 6,
	"atk": 2400,
	"def": 1500,
	"type": "warrior",
	"count_as": "thunder",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "61204971"
  },
  "00698": {
	"card_name": "Elemental HERO Mudballman",
	"attribute": "earth",
	"level": 6,
	"atk": 1900,
	"def": 3000,
	"type": "warrior",
	"count_as": "aqua",
	"effect": [],
	"passcode": "52031567"
  },
  "00699": {
	"card_name": "Elemental HERO Shining Flare Wingman",
	"attribute": "light",
	"level": 8,
	"atk": 2500,
	"def": 2100,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "burn",
	  "enemy_atk"
	],
	"passcode": "25366484"
  },
  "00700": {
	"card_name": "Elemental HERO Bladedge",
	"attribute": "earth",
	"level": 7,
	"atk": 2600,
	"def": 1800,
	"type": "warrior",
	"count_as": "machine",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "59793705"
  },
  "00701": {
	"card_name": "Elemental HERO Wildedge",
	"attribute": "earth",
	"level": 8,
	"atk": 2600,
	"def": 2300,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "10526791"
  },
  "00702": {
	"card_name": "Elemental HERO Plasma Vice",
	"attribute": "earth",
	"level": 8,
	"atk": 2600,
	"def": 2300,
	"type": "warrior",
	"count_as": "thunder",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "60493189"
  },
  "00703": {
	"card_name": "Elemental HERO Neos",
	"attribute": "light",
	"level": 7,
	"atk": 2500,
	"def": 2000,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "89943723"
  },
  "00704": {
	"card_name": "Elemental HERO Air Neos",
	"attribute": "wind",
	"level": 7,
	"atk": 2500,
	"def": 2000,
	"type": "warrior",
	"count_as": "winged beast",
	"effect": [
	  "on_summon",
	  "air_neos"
	],
	"passcode": "11502550"
  },
  "00705": {
	"card_name": "Elemental HERO Flare Neos",
	"attribute": "fire",
	"level": 7,
	"atk": 2500,
	"def": 2000,
	"type": "warrior",
	"count_as": "pyro",
	"effect": [
	  "on_summon",
	  "self_power_up",
	  "spelltrap_count"
	],
	"passcode": "81566151"
  },
  "00706": {
	"card_name": "Elemental HERO Grand Neos",
	"attribute": "earth",
	"level": 7,
	"atk": 2500,
	"def": 2000,
	"type": "warrior",
	"count_as": "rock",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "48996569"
  },
  "00707": {
	"card_name": "Elemental HERO Glow Neos",
	"attribute": "light",
	"level": 7,
	"atk": 2500,
	"def": 2000,
	"type": "warrior",
	"count_as": "fairy",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "85507811"
  },
  "00708": {
	"card_name": "Elemental HERO Aqua Neos",
	"attribute": "water",
	"level": 7,
	"atk": 2500,
	"def": 2000,
	"type": "warrior",
	"count_as": "fish",
	"effect": [
	  "on_attack",
	  "mill",
	  1
	],
	"passcode": "55171412"
  },
  "00709": {
	"card_name": "Elemental HERO Dark Neos",
	"attribute": "dark",
	"level": 7,
	"atk": 2500,
	"def": 2000,
	"type": "warrior",
	"count_as": "fiend",
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "28677304"
  },
  "00710": {
	"card_name": "Masked HERO Blast",
	"attribute": "wind",
	"level": 6,
	"atk": 2200,
	"def": 1800,
	"type": "warrior",
	"count_as": "masked",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "89870349"
  },
  "00711": {
	"card_name": "Masked HERO Goka",
	"attribute": "fire",
	"level": 6,
	"atk": 2200,
	"def": 1800,
	"type": "warrior",
	"count_as": "masked",
	"effect": [
	  "on_summon",
	  "self_power_up",
	  100
	],
	"passcode": "58147549"
  },
  "00712": {
	"card_name": "Masked HERO Vapor",
	"attribute": "water",
	"level": 6,
	"atk": 2400,
	"def": 2000,
	"type": "warrior",
	"count_as": "masked",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "10920352"
  },
  "00713": {
	"card_name": "Masked HERO Dark Law",
	"attribute": "dark",
	"level": 6,
	"atk": 2400,
	"def": 1800,
	"type": "warrior",
	"count_as": "masked",
	"effect": [
	  "on_attack",
	  "mill",
	  1
	],
	"passcode": "58481572"
  },
  "00714": {
	"card_name": "Elemental HERO Avian",
	"attribute": "wind",
	"level": 3,
	"atk": 1000,
	"def": 1000,
	"type": "warrior",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "21844576"
  },
  "00715": {
	"card_name": "Elemental HERO Burstinatrix",
	"attribute": "fire",
	"level": 3,
	"atk": 1200,
	"def": 800,
	"type": "warrior",
	"count_as": "female",
	"effect": [],
	"passcode": "58932615"
  },
  "00716": {
	"card_name": "Elemental HERO Clayman",
	"attribute": "earth",
	"level": 4,
	"atk": 800,
	"def": 2000,
	"type": "warrior",
	"count_as": "rock",
	"effect": [],
	"passcode": "84327329"
  },
  "00717": {
	"card_name": "Elemental HERO Sparkman",
	"attribute": "light",
	"level": 4,
	"atk": 1600,
	"def": 1400,
	"type": "warrior",
	"count_as": "thunder",
	"effect": [],
	"passcode": "20721928"
  },
  "00718": {
	"card_name": "Elemental HERO Bubbleman",
	"attribute": "water",
	"level": 4,
	"atk": 800,
	"def": 1200,
	"type": "warrior",
	"count_as": "aqua",
	"effect": [],
	"passcode": "79979666"
  },
  "00719": {
	"card_name": "Elemental HERO Shadow Mist",
	"attribute": "dark",
	"level": 4,
	"atk": 1000,
	"def": 1500,
	"type": "warrior",
	"count_as": "female",
	"effect": [],
	"passcode": "50720316"
  },
  "00720": {
	"card_name": "Elemental HERO Stratos",
	"attribute": "wind",
	"level": 4,
	"atk": 1800,
	"def": 300,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "40044918"
  },
  "00721": {
	"card_name": "Elemental HERO Blazeman",
	"attribute": "fire",
	"level": 4,
	"atk": 1200,
	"def": 1800,
	"type": "warrior",
	"count_as": "pyro",
	"effect": [],
	"passcode": "63060238"
  },
  "00722": {
	"card_name": "Elemental HERO Wildheart",
	"attribute": "earth",
	"level": 4,
	"atk": 1500,
	"def": 1600,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "86188410"
  },
  "00723": {
	"card_name": "Elemental HERO Prisma",
	"attribute": "light",
	"level": 4,
	"atk": 1700,
	"def": 1100,
	"type": "warrior",
	"count_as": "rock",
	"effect": [],
	"passcode": "89312388"
  },
  "00724": {
	"card_name": "Elemental HERO Necroshade",
	"attribute": "dark",
	"level": 5,
	"atk": 1600,
	"def": 1800,
	"type": "warrior",
	"count_as": "fiend",
	"effect": [],
	"passcode": "89252153"
  },
  "00725": {
	"card_name": "Elemental HERO Neos Alius",
	"attribute": "light",
	"level": 4,
	"atk": 1900,
	"def": 1300,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "69884162"
  },
  "00726": {
	"card_name": "Neo Space Connector",
	"attribute": "light",
	"level": 4,
	"atk": 800,
	"def": 1800,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "85840608"
  },
  "00727": {
	"card_name": "Winged Kuriboh",
	"attribute": "light",
	"level": 1,
	"atk": 300,
	"def": 200,
	"type": "fairy",
	"count_as": "winged beast",
	"effect": [
	  "on_defend",
	  "no_damage"
	],
	"passcode": "57116033"
  },
  "00728": {
	"card_name": "Elemental HERO Necroid Shaman",
	"attribute": "dark",
	"level": 6,
	"atk": 1900,
	"def": 1800,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "81003500"
  },
  "00729": {
	"card_name": "Elemental HERO Wild Wingman",
	"attribute": "earth",
	"level": 8,
	"atk": 1900,
	"def": 2300,
	"type": "warrior",
	"count_as": "winged beast",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "55615891"
  },
  "00730": {
	"card_name": "Elemental HERO Mariner",
	"attribute": "water",
	"level": 5,
	"atk": 1400,
	"def": 1000,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "14225239"
  },
  "00731": {
	"card_name": "Elemental HERO Steam Healer",
	"attribute": "water",
	"level": 5,
	"atk": 1800,
	"def": 1000,
	"type": "warrior",
	"count_as": "machine",
	"effect": [
	  "on_attack",
	  "lifepoint_up",
	  1000
	],
	"passcode": "81197327"
  },
  "00732": {
	"card_name": "Neo-Spacian Air Hummingbird",
	"attribute": "wind",
	"level": 3,
	"atk": 800,
	"def": 600,
	"type": "winged beast",
	"count_as": "warrior",
	"effect": [
	  "on_summon",
	  "lifepoint_up",
	  2000
	],
	"passcode": "54959865"
  },
  "00733": {
	"card_name": "Neo-Spacian Flare Scarab",
	"attribute": "fire",
	"level": 3,
	"atk": 500,
	"def": 500,
	"type": "insect",
	"count_as": "pyro",
	"effect": [
	  "on_summon",
	  "self_power_up",
	  "spelltrap_count"
	],
	"passcode": "89621922"
  },
  "00734": {
	"card_name": "Neo-Spacian Grand Mole",
	"attribute": "earth",
	"level": 3,
	"atk": 900,
	"def": 300,
	"type": "rock",
	"count_as": "beast",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "80344569"
  },
  "00735": {
	"card_name": "Neo-Spacian Glow Moss",
	"attribute": "light",
	"level": 3,
	"atk": 300,
	"def": 900,
	"type": "plant",
	"count_as": "fairy",
	"effect": [
	  "on_attack",
	  "change_position"
	],
	"passcode": "17732278"
  },
  "00736": {
	"card_name": "Neo-Spacian Aqua Dolphin",
	"attribute": "water",
	"level": 3,
	"atk": 600,
	"def": 800,
	"type": "warrior",
	"count_as": "fish",
	"effect": [
	  "on_attack",
	  "burn",
	  500
	],
	"passcode": "17955766"
  },
  "00737": {
	"card_name": "Neo-Spacian Dark Panther",
	"attribute": "dark",
	"level": 3,
	"atk": 1000,
	"def": 500,
	"type": "beast",
	"count_as": "fiend",
	"effect": [
	  "on_summon",
	  "copy_atk"
	],
	"passcode": "43237273"
  },
  "00738": {
	"card_name": "Elemental HERO Voltic",
	"attribute": "light",
	"level": 4,
	"atk": 1000,
	"def": 1500,
	"type": "thunder",
	"count_as": "warrior",
	"effect": [],
	"passcode": "09327502"
  },
  "00739": {
	"card_name": "Elemental HERO Ocean",
	"attribute": "water",
	"level": 4,
	"atk": 1500,
	"def": 1200,
	"type": "warrior",
	"count_as": "fish",
	"effect": [],
	"passcode": "37195861"
  },
  "00740": {
	"card_name": "Elemental HERO Woodsman",
	"attribute": "earth",
	"level": 4,
	"atk": 1000,
	"def": 2000,
	"type": "warrior",
	"count_as": "plant",
	"effect": [],
	"passcode": "75434695"
  },
  "00741": {
	"card_name": "Elemental HERO Poison Rose",
	"attribute": "earth",
	"level": 6,
	"atk": 1900,
	"def": 2000,
	"type": "plant",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "self_power_up",
	  200
	],
	"passcode": "51085303"
  },
  "00742": {
	"card_name": "Elemental HERO Heat",
	"attribute": "fire",
	"level": 4,
	"atk": 1600,
	"def": 1200,
	"type": "pyro",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  200
	],
	"passcode": "98266377"
  },
  "00743": {
	"card_name": "Elemental HERO Lady Heat",
	"attribute": "fire",
	"level": 4,
	"atk": 1300,
	"def": 1000,
	"type": "pyro",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "burn",
	  200
	],
	"passcode": "95362816"
  },
  "00744": {
	"card_name": "Honest",
	"attribute": "light",
	"level": 4,
	"atk": 1100,
	"def": 1900,
	"type": "fairy",
	"count_as": "winged beast",
	"effect": [
	  "on_summon",
	  "honest"
	],
	"passcode": "37742478"
  },
  "00745": {
	"card_name": "Elemental HERO Darkbright",
	"attribute": "dark",
	"level": 6,
	"atk": 2000,
	"def": 1000,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "41517968"
  },
  "00746": {
	"card_name": "Elemental HERO Inferno",
	"attribute": "fire",
	"level": 8,
	"atk": 2300,
	"def": 1600,
	"type": "pyro",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  400
	],
	"passcode": "68745629"
  },
  "00747": {
	"card_name": "Elemental HERO Rampart Blaster",
	"attribute": "earth",
	"level": 6,
	"atk": 2000,
	"def": 2500,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "change_position"
	],
	"passcode": "47737087"
  },
  "00748": {
	"card_name": "Elemental HERO Flame Wingman",
	"attribute": "wind",
	"level": 6,
	"atk": 2100,
	"def": 1200,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "burn",
	  "enemy_atk"
	],
	"passcode": "35809262"
  },
  "00749": {
	"card_name": "Dark Catapulter",
	"attribute": "earth",
	"level": 4,
	"atk": 1000,
	"def": 1500,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "33875961"
  },
  "00750": {
	"card_name": "Hero Kid",
	"attribute": "earth",
	"level": 2,
	"atk": 300,
	"def": 600,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "32679370"
  },
  "00751": {
	"card_name": "Wroughtweiler",
	"attribute": "earth",
	"level": 3,
	"atk": 800,
	"def": 1200,
	"type": "machine",
	"count_as": "beast",
	"effect": [],
	"passcode": "06480253"
  },
  "00752": {
	"card_name": "Card Blocker",
	"attribute": "earth",
	"level": 3,
	"atk": 400,
	"def": 400,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "deck_for_stat",
	  "def"
	],
	"passcode": "42256406"
  },
  "00753": {
	"card_name": "Spell Striker",
	"attribute": "earth",
	"level": 3,
	"atk": 600,
	"def": 200,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "93187568"
  },
  "00754": {
	"card_name": "Card Trooper",
	"attribute": "earth",
	"level": 3,
	"atk": 400,
	"def": 400,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "deck_for_stat",
	  "atk"
	],
	"passcode": "85087012"
  },
  "00755": {
	"card_name": "Rallis the Star Bird",
	"attribute": "wind",
	"level": 3,
	"atk": 800,
	"def": 800,
	"type": "winged beast",
	"count_as": null,
	"effect": [],
	"passcode": "41382147"
  },
  "00756": {
	"card_name": "Gallis the Star Beast",
	"attribute": "earth",
	"level": 3,
	"atk": 800,
	"def": 800,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "30915572"
  },
  "00757": {
	"card_name": "Chrysalis Dolphin",
	"attribute": "water",
	"level": 2,
	"atk": 400,
	"def": 600,
	"type": "fish",
	"count_as": null,
	"effect": [],
	"passcode": "42682609"
  },
  "00758": {
	"card_name": "Chrysalis Chicky",
	"attribute": "wind",
	"level": 2,
	"atk": 600,
	"def": 400,
	"type": "winged beast",
	"count_as": null,
	"effect": [],
	"passcode": "17363041"
  },
  "00759": {
	"card_name": "Chrysalis Larva",
	"attribute": "fire",
	"level": 2,
	"atk": 300,
	"def": 300,
	"type": "insect",
	"count_as": null,
	"effect": [],
	"passcode": "16241441"
  },
  "00760": {
	"card_name": "Chrysalis Mole",
	"attribute": "earth",
	"level": 2,
	"atk": 700,
	"def": 100,
	"type": "rock",
	"count_as": null,
	"effect": [],
	"passcode": "42239546"
  },
  "00761": {
	"card_name": "Chrysalis Pantail",
	"attribute": "dark",
	"level": 2,
	"atk": 800,
	"def": 300,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "43751755"
  },
  "00762": {
	"card_name": "Chrysalis Pinny",
	"attribute": "light",
	"level": 2,
	"atk": 100,
	"def": 700,
	"type": "plant",
	"count_as": null,
	"effect": [],
	"passcode": "29246354"
  },
  "00763": {
	"card_name": "Elemental HERO Knospe",
	"attribute": "earth",
	"level": 3,
	"atk": 600,
	"def": 1000,
	"type": "plant",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "62107981"
  },
  "00764": {
	"card_name": "Elemental HERO Ice Edge",
	"attribute": "water",
	"level": 3,
	"atk": 800,
	"def": 900,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "41077745"
  },
  "00765": {
	"card_name": "Elemental HERO Flash",
	"attribute": "light",
	"level": 4,
	"atk": 1100,
	"def": 1600,
	"type": "warrior",
	"count_as": "thunder",
	"effect": [],
	"passcode": "69572169"
  },
  "00766": {
	"card_name": "Elemental HERO Great Tornado",
	"attribute": "wind",
	"level": 8,
	"atk": 2800,
	"def": 2200,
	"type": "warrior",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "03642509"
  },
  "00767": {
	"card_name": "Elemental HERO Nova Master",
	"attribute": "fire",
	"level": 8,
	"atk": 2600,
	"def": 2100,
	"type": "warrior",
	"count_as": "pyro",
	"effect": [],
	"passcode": "01945387"
  },
  "00768": {
	"card_name": "Elemental HERO Gaia",
	"attribute": "earth",
	"level": 6,
	"atk": 2200,
	"def": 2600,
	"type": "warrior",
	"count_as": "rock",
	"effect": [],
	"passcode": "16304628"
  },
  "00769": {
	"card_name": "Elemental HERO The Shining",
	"attribute": "light",
	"level": 8,
	"atk": 2600,
	"def": 2100,
	"type": "warrior",
	"count_as": "fairy",
	"effect": [],
	"passcode": "22061412"
  },
  "00770": {
	"card_name": "Elemental HERO Absolute Zero",
	"attribute": "water",
	"level": 8,
	"atk": 2500,
	"def": 2000,
	"type": "warrior",
	"count_as": "aqua",
	"effect": [],
	"passcode": "40854197"
  },
  "00771": {
	"card_name": "Elemental HERO Escuridao",
	"attribute": "dark",
	"level": 8,
	"atk": 2500,
	"def": 2000,
	"type": "warrior",
	"count_as": "fiend",
	"effect": [],
	"passcode": "33574806"
  },
  "00772": {
	"card_name": "Elemental HERO Storm Neos",
	"attribute": "wind",
	"level": 9,
	"atk": 3000,
	"def": 2500,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "all_enemy_spelltraps"
	],
	"passcode": "49352945"
  },
  "00773": {
	"card_name": "Divine Neos Ritual",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "ritual",
	"count_as": null,
	"effect": [
	  "ritual",
	  682
	],
	"passcode": "69270537"
  },
  "00774": {
	"card_name": "Dark Honest",
	"attribute": "dark",
	"level": 4,
	"atk": 1100,
	"def": 1900,
	"type": "fairy",
	"count_as": "fiend",
	"effect": [
	  "on_summon",
	  "honest"
	],
	"passcode": "26914168"
  },
  "00775": {
	"card_name": "Rainbow Dragon",
	"attribute": "light",
	"level": 10,
	"atk": 4000,
	"def": 0,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "monster_count_boost",
	  250
	],
	"passcode": "79856792"
  },
  "00776": {
	"card_name": "Rainbow Dark Dragon",
	"attribute": "dark",
	"level": 10,
	"atk": 4000,
	"def": 0,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "monster_count_boost",
	  250
	],
	"passcode": "79407975"
  },
  "00777": {
	"card_name": "Rainbow Overdragon",
	"attribute": "light",
	"level": 12,
	"atk": 4000,
	"def": 0,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "monster_count_boost",
	  500
	],
	"passcode": "37440988"
  },
  "00778": {
	"card_name": "Gem-Knight Lady Brilliant Diamond",
	"attribute": "earth",
	"level": 10,
	"atk": 3400,
	"def": 2000,
	"type": "rock",
	"count_as": "female",
	"effect": [],
	"passcode": "19355597"
  },
  "00779": {
	"card_name": "Gem-Knight Master Diamond",
	"attribute": "earth",
	"level": 9,
	"atk": 2900,
	"def": 2500,
	"type": "rock",
	"count_as": "gem",
	"effect": [
	  "on_summon",
	  "self_power_up",
	  100
	],
	"passcode": "39512984"
  },
  "00780": {
	"card_name": "Gem-Knight Zirconia",
	"attribute": "earth",
	"level": 8,
	"atk": 2900,
	"def": 2500,
	"type": "rock",
	"count_as": "gem",
	"effect": [],
	"passcode": "08692301"
  },
  "00781": {
	"card_name": "The Tripper Mercury",
	"attribute": "water",
	"level": 8,
	"atk": 2000,
	"def": 2000,
	"type": "aqua",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "stop_defense"
	],
	"passcode": "03912064"
  },
  "00782": {
	"card_name": "Gem-Knight Citrine",
	"attribute": "earth",
	"level": 7,
	"atk": 2200,
	"def": 1950,
	"type": "pyro",
	"count_as": "gem",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "67985943"
  },
  "00783": {
	"card_name": "Gem-Knight Crystal",
	"attribute": "earth",
	"level": 7,
	"atk": 2450,
	"def": 1950,
	"type": "rock",
	"count_as": "gem",
	"effect": [],
	"passcode": "76908448"
  },
  "00784": {
	"card_name": "Gem-Knight Lady Lapis Lazuli",
	"attribute": "earth",
	"level": 5,
	"atk": 2400,
	"def": 1000,
	"type": "rock",
	"count_as": "gem",
	"effect": [
	  "on_attack",
	  "burn",
	  500
	],
	"passcode": "47611119"
  },
  "00785": {
	"card_name": "Gem-Knight Prismaura",
	"attribute": "earth",
	"level": 7,
	"atk": 2450,
	"def": 1400,
	"type": "thunder",
	"count_as": "gem",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "93379652"
  },
  "00786": {
	"card_name": "Gem-Knight Ruby",
	"attribute": "earth",
	"level": 6,
	"atk": 2500,
	"def": 1300,
	"type": "pyro",
	"count_as": "gem",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "76614340"
  },
  "00787": {
	"card_name": "Gem-Knight Seraphinite",
	"attribute": "earth",
	"level": 5,
	"atk": 2300,
	"def": 1400,
	"type": "fairy",
	"count_as": "gem",
	"effect": [],
	"passcode": "03113836"
  },
  "00788": {
	"card_name": "Crystal Beast Amber Mammoth",
	"attribute": "earth",
	"level": 4,
	"atk": 1700,
	"def": 1600,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "69937550"
  },
  "00789": {
	"card_name": "Crystal Beast Emerald Tortoise",
	"attribute": "water",
	"level": 3,
	"atk": 600,
	"def": 2000,
	"type": "aqua",
	"count_as": null,
	"effect": [],
	"passcode": "68215963"
  },
  "00790": {
	"card_name": "Crystal Beast Sapphire Pegasus",
	"attribute": "wind",
	"level": 4,
	"atk": 1800,
	"def": 1200,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "07093411"
  },
  "00791": {
	"card_name": "Crystal Beast Topaz Tiger",
	"attribute": "earth",
	"level": 4,
	"atk": 1600,
	"def": 1000,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "95600067"
  },
  "00792": {
	"card_name": "Crystal Beast Ruby Carbuncle",
	"attribute": "light",
	"level": 3,
	"atk": 300,
	"def": 300,
	"type": "fairy",
	"count_as": null,
	"effect": [],
	"passcode": "32710364"
  },
  "00793": {
	"card_name": "Crystal Beast Amethyst Cat",
	"attribute": "earth",
	"level": 3,
	"atk": 1200,
	"def": 400,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "32933942"
  },
  "00794": {
	"card_name": "Crystal Beast Cobalt Eagle",
	"attribute": "wind",
	"level": 4,
	"atk": 1400,
	"def": 800,
	"type": "winged beast",
	"count_as": null,
	"effect": [],
	"passcode": "21698716"
  },
  "00795": {
	"card_name": "4-Starred Ladybug of Doom",
	"attribute": "wind",
	"level": 3,
	"atk": 800,
	"def": 1200,
	"type": "insect",
	"count_as": null,
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "level4_enemy_monsters"
	],
	"passcode": "83994646"
  },
  "00796": {
	"card_name": "Primitive Butterfly",
	"attribute": "wind",
	"level": 5,
	"atk": 1200,
	"def": 900,
	"type": "insect",
	"count_as": null,
	"effect": [],
	"passcode": "98154550"
  },
  "00797": {
	"card_name": "Gem-Armadillo",
	"attribute": "earth",
	"level": 4,
	"atk": 1700,
	"def": 500,
	"type": "rock",
	"count_as": "gem",
	"effect": [],
	"passcode": "27004302"
  },
  "00798": {
	"card_name": "Gem-Elephant",
	"attribute": "earth",
	"level": 3,
	"atk": 400,
	"def": 1900,
	"type": "rock",
	"count_as": "gem",
	"effect": [],
	"passcode": "19019586"
  },
  "00799": {
	"card_name": "Gem-Merchant",
	"attribute": "earth",
	"level": 3,
	"atk": 1000,
	"def": 1000,
	"type": "spellcaster",
	"count_as": "gem",
	"effect": [
	  "on_summon",
	  "count_as_power_up",
	  500
	],
	"passcode": "53408006"
  },
  "00800": {
	"card_name": "Gem-Turtle",
	"attribute": "earth",
	"level": 4,
	"atk": 0,
	"def": 2000,
	"type": "rock",
	"count_as": "gem",
	"effect": [],
	"passcode": "64734090"
  },
  "00801": {
	"card_name": "Gem-Knight Alexandrite",
	"attribute": "earth",
	"level": 4,
	"atk": 1800,
	"def": 1200,
	"type": "rock",
	"count_as": "gem",
	"effect": [],
	"passcode": "90019393"
  },
  "00802": {
	"card_name": "Gem-Knight Amber",
	"attribute": "earth",
	"level": 4,
	"atk": 1600,
	"def": 1400,
	"type": "thunder",
	"count_as": "gem",
	"effect": [],
	"passcode": "72056560"
  },
  "00803": {
	"card_name": "Gem-Knight Amethyst",
	"attribute": "earth",
	"level": 7,
	"atk": 1950,
	"def": 2450,
	"type": "aqua",
	"count_as": "gem",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "all_enemy_spelltraps"
	],
	"passcode": "71616908"
  },
  "00804": {
	"card_name": "Gem-Knight Aquamarine",
	"attribute": "earth",
	"level": 6,
	"atk": 1400,
	"def": 2600,
	"type": "aqua",
	"count_as": "gem",
	"effect": [
	  "on_attack",
	  "change_position"
	],
	"passcode": "13108445"
  },
  "00805": {
	"card_name": "Gem-Knight Emerald",
	"attribute": "earth",
	"level": 4,
	"atk": 1800,
	"def": 800,
	"type": "rock",
	"count_as": "gem",
	"effect": [],
	"passcode": "69243722"
  },
  "00806": {
	"card_name": "Gem-Knight Garnet",
	"attribute": "earth",
	"level": 4,
	"atk": 1900,
	"def": 0,
	"type": "pyro",
	"count_as": "gem",
	"effect": [],
	"passcode": "91731841"
  },
  "00807": {
	"card_name": "Gem-Knight Iolite",
	"attribute": "earth",
	"level": 4,
	"atk": 1300,
	"def": 2000,
	"type": "aqua",
	"count_as": "gem",
	"effect": [],
	"passcode": "45662855"
  },
  "00808": {
	"card_name": "Gem-Knight Obsidian",
	"attribute": "earth",
	"level": 3,
	"atk": 1500,
	"def": 1200,
	"type": "rock",
	"count_as": "gem",
	"effect": [],
	"passcode": "19163116"
  },
  "00809": {
	"card_name": "Gem-Knight Sapphire",
	"attribute": "earth",
	"level": 4,
	"atk": 0,
	"def": 2100,
	"type": "aqua",
	"count_as": "gem",
	"effect": [],
	"passcode": "27126980"
  },
  "00810": {
	"card_name": "Gem-Knight Sardonyx",
	"attribute": "earth",
	"level": 4,
	"atk": 1800,
	"def": 900,
	"type": "pyro",
	"count_as": "gem",
	"effect": [],
	"passcode": "43114901"
  },
  "00811": {
	"card_name": "Gem-Knight Topaz",
	"attribute": "earth",
	"level": 6,
	"atk": 1800,
	"def": 1800,
	"type": "thunder",
	"count_as": "gem",
	"effect": [
	  "on_attack",
	  "burn",
	  "enemy_atk"
	],
	"passcode": "49597193"
  },
  "00812": {
	"card_name": "Gem-Knight Tourmaline",
	"attribute": "earth",
	"level": 4,
	"atk": 1600,
	"def": 1800,
	"type": "thunder",
	"count_as": "gem",
	"effect": [],
	"passcode": "54620698"
  },
  "00813": {
	"card_name": "Gem-Knight Lapis",
	"attribute": "earth",
	"level": 3,
	"atk": 1200,
	"def": 100,
	"type": "rock",
	"count_as": "gem",
	"effect": [],
	"passcode": "99645428"
  },
  "00814": {
	"card_name": "Gem-Knight Lazuli",
	"attribute": "earth",
	"level": 1,
	"atk": 600,
	"def": 100,
	"type": "rock",
	"count_as": "gem",
	"effect": [],
	"passcode": "81846636"
  },
  "00815": {
	"card_name": "Stealth Bird",
	"attribute": "dark",
	"level": 3,
	"atk": 700,
	"def": 1700,
	"type": "winged beast",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "lifepoint_up",
	  1000
	],
	"passcode": "03510565"
  },
  "00816": {
	"card_name": "Mobile Base - Super Vehicroid",
	"attribute": "earth",
	"level": 10,
	"atk": 0,
	"def": 5000,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_summon",
	  "count_as_power_up",
	  1000
	],
	"passcode": "17745969"
  },
  "00817": {
	"card_name": "Barbaroid, the Ultimate Battle Machine",
	"attribute": "earth",
	"level": 12,
	"atk": 4000,
	"def": 4000,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "54702678"
  },
  "00818": {
	"card_name": "Stealth Union - Super Vehicroid",
	"attribute": "earth",
	"level": 9,
	"atk": 3600,
	"def": 3000,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "03897065"
  },
  "00819": {
	"card_name": "Super Vehicroid Jumbo Drill",
	"attribute": "earth",
	"level": 8,
	"atk": 3000,
	"def": 2000,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "36256625"
  },
  "00820": {
	"card_name": "UFOroid Fighter",
	"attribute": "light",
	"level": 10,
	"atk": 0,
	"def": 0,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_summon",
	  "copy_atk"
	],
	"passcode": "32752319"
  },
  "00821": {
	"card_name": "Dragonroid",
	"attribute": "wind",
	"level": 8,
	"atk": 2900,
	"def": 1000,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "09069157"
  },
  "00822": {
	"card_name": "Ambulance Rescueroid",
	"attribute": "fire",
	"level": 6,
	"atk": 2300,
	"def": 1800,
	"type": "machine",
	"count_as": "roid",
	"effect": [],
	"passcode": "98927491"
  },
  "00823": {
	"card_name": "Cyber Dragon",
	"attribute": "light",
	"level": 5,
	"atk": 2100,
	"def": 1600,
	"type": "machine",
	"count_as": "dragon",
	"effect": [],
	"passcode": "70095154"
  },
  "00824": {
	"card_name": "Armoroid",
	"attribute": "earth",
	"level": 8,
	"atk": 2700,
	"def": 2000,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "all_enemy_spelltraps"
	],
	"passcode": "73333463"
  },
  "00825": {
	"card_name": "Machine King",
	"attribute": "earth",
	"level": 6,
	"atk": 2200,
	"def": 2000,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  100
	],
	"passcode": "46700124"
  },
  "00826": {
	"card_name": "Power Bond",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "spell",
	"count_as": null,
	"effect": [
	  "power_bond"
	],
	"passcode": "37630732"
  },
  "00827": {
	"card_name": "Drillroid",
	"attribute": "earth",
	"level": 4,
	"atk": 1600,
	"def": 1600,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_attack",
	  "mutual_banish"
	],
	"passcode": "71218746"
  },
  "00828": {
	"card_name": "Expressroid",
	"attribute": "earth",
	"level": 4,
	"atk": 400,
	"def": 1600,
	"type": "machine",
	"count_as": "roid",
	"effect": [],
	"passcode": "00984114"
  },
  "00829": {
	"card_name": "Jetroid",
	"attribute": "wind",
	"level": 4,
	"atk": 1200,
	"def": 1800,
	"type": "machine",
	"count_as": "roid",
	"effect": [],
	"passcode": "43697559"
  },
  "00830": {
	"card_name": "Kiteroid",
	"attribute": "wind",
	"level": 1,
	"atk": 200,
	"def": 400,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_defend",
	  "no_damage"
	],
	"passcode": "88284331"
  },
  "00831": {
	"card_name": "Patroid",
	"attribute": "earth",
	"level": 4,
	"atk": 1200,
	"def": 1200,
	"type": "machine",
	"count_as": "roid",
	"effect": [],
	"passcode": "71930383"
  },
  "00832": {
	"card_name": "Stealthroid",
	"attribute": "dark",
	"level": 4,
	"atk": 1200,
	"def": 0,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "98049038"
  },
  "00833": {
	"card_name": "Steamroid",
	"attribute": "earth",
	"level": 4,
	"atk": 1800,
	"def": 1800,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_summon",
	  "count_as_power_up",
	  100
	],
	"passcode": "44729197"
  },
  "00834": {
	"card_name": "Truckroid",
	"attribute": "earth",
	"level": 4,
	"atk": 1000,
	"def": 2000,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_summon",
	  "count_as_power_up",
	  100
	],
	"passcode": "61538782"
  },
  "00835": {
	"card_name": "UFOroid",
	"attribute": "light",
	"level": 6,
	"atk": 1200,
	"def": 1200,
	"type": "machine",
	"count_as": "roid",
	"effect": [],
	"passcode": "07602840"
  },
  "00836": {
	"card_name": "Pair Cycroid",
	"attribute": "earth",
	"level": 5,
	"atk": 1600,
	"def": 1200,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "16114248"
  },
  "00837": {
	"card_name": "Cyber Phoenix",
	"attribute": "fire",
	"level": 4,
	"atk": 1200,
	"def": 1600,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "03370104"
  },
  "00838": {
	"card_name": "Infernal Dragon",
	"attribute": "dark",
	"level": 4,
	"atk": 2000,
	"def": 0,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "change_position"
	],
	"passcode": "47754278"
  },
  "00839": {
	"card_name": "Rescueroid",
	"attribute": "fire",
	"level": 6,
	"atk": 1600,
	"def": 1800,
	"type": "machine",
	"count_as": "roid",
	"effect": [],
	"passcode": "24311595"
  },
  "00840": {
	"card_name": "Carrierroid",
	"attribute": "water",
	"level": 4,
	"atk": 1000,
	"def": 800,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "46848859"
  },
  "00841": {
	"card_name": "Shuttleroid",
	"attribute": "wind",
	"level": 4,
	"atk": 1000,
	"def": 1200,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_attack",
	  "burn",
	  1000
	],
	"passcode": "10449150"
  },
  "00842": {
	"card_name": "Steam Gyroid",
	"attribute": "earth",
	"level": 6,
	"atk": 2200,
	"def": 1600,
	"type": "machine",
	"count_as": "roid",
	"effect": [],
	"passcode": "05368615"
  },
  "00843": {
	"card_name": "Mixeroid",
	"attribute": "wind",
	"level": 4,
	"atk": 0,
	"def": 2200,
	"type": "machine",
	"count_as": "roid",
	"effect": [],
	"passcode": "71340250"
  },
  "00844": {
	"card_name": "Ambulanceroid",
	"attribute": "earth",
	"level": 3,
	"atk": 300,
	"def": 1200,
	"type": "machine",
	"count_as": "roid",
	"effect": [],
	"passcode": "36378213"
  },
  "00845": {
	"card_name": "Gyroid",
	"attribute": "wind",
	"level": 3,
	"atk": 1000,
	"def": 1000,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_defend",
	  "cant_die"
	],
	"passcode": "18325492"
  },
  "00846": {
	"card_name": "Submarineroid",
	"attribute": "water",
	"level": 4,
	"atk": 800,
	"def": 1800,
	"type": "machine",
	"count_as": "roid",
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "99861526"
  },
  "00847": {
	"card_name": "Cycroid",
	"attribute": "earth",
	"level": 3,
	"atk": 800,
	"def": 1000,
	"type": "machine",
	"count_as": "roid",
	"effect": [],
	"passcode": "45945685"
  },
  "00848": {
	"card_name": "Cyber Falcon",
	"attribute": "wind",
	"level": 4,
	"atk": 1400,
	"def": 1200,
	"type": "machine",
	"count_as": "winged beast",
	"effect": [],
	"passcode": "30655537"
  },
  "00849": {
	"card_name": "Bokoichi the Freightening Car",
	"attribute": "dark",
	"level": 2,
	"atk": 500,
	"def": 500,
	"type": "machine",
	"count_as": "train",
	"effect": [],
	"passcode": "08715625"
  },
  "00850": {
	"card_name": "Dekoichi the Battlechanted Locomotive",
	"attribute": "dark",
	"level": 4,
	"atk": 1400,
	"def": 1000,
	"type": "machine",
	"count_as": "train",
	"effect": [
	  "on_summon",
	  "count_as_power_up",
	  500
	],
	"passcode": "87621407"
  },
  "00851": {
	"card_name": "Heavy Mech Support Platform",
	"attribute": "dark",
	"level": 3,
	"atk": 500,
	"def": 500,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "friends_power_up",
	  200
	],
	"passcode": "23265594"
  },
  "00852": {
	"card_name": "Heavy Mech Support Armor",
	"attribute": "light",
	"level": 3,
	"atk": 500,
	"def": 500,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "39890958"
  },
  "00853": {
	"card_name": "Fossil Dragon Skullgios",
	"attribute": "earth",
	"level": 8,
	"atk": 3500,
	"def": 0,
	"type": "rock",
	"count_as": "dinosaur",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "21225115"
  },
  "00854": {
	"card_name": "Sauropod Brachion",
	"attribute": "earth",
	"level": 8,
	"atk": 1500,
	"def": 3000,
	"type": "dinosaur",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "flip_enemy_down"
	],
	"passcode": "41753322"
  },
  "00855": {
	"card_name": "Ultimate Conductor Tyranno",
	"attribute": "light",
	"level": 10,
	"atk": 3500,
	"def": 3200,
	"type": "dinosaur",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "burn",
	  1000
	],
	"passcode": "18940556"
  },
  "00856": {
	"card_name": "Overtex Qoatlus",
	"attribute": "dark",
	"level": 7,
	"atk": 2700,
	"def": 2100,
	"type": "dinosaur",
	"count_as": "fiend",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "41782653"
  },
  "00857": {
	"card_name": "Dark Driceratops",
	"attribute": "earth",
	"level": 6,
	"atk": 2400,
	"def": 1500,
	"type": "dinosaur",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "65287621"
  },
  "00858": {
	"card_name": "Giant Rex",
	"attribute": "earth",
	"level": 4,
	"atk": 2000,
	"def": 1200,
	"type": "dinosaur",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  200
	],
	"passcode": "80280944"
  },
  "00859": {
	"card_name": "Tyranno Infinity",
	"attribute": "earth",
	"level": 4,
	"atk": 0,
	"def": 0,
	"type": "dinosaur",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "graveyard_power_up",
	  100
	],
	"passcode": "83235263"
  },
  "00860": {
	"card_name": "Super-Ancient Dinobeast",
	"attribute": "earth",
	"level": 8,
	"atk": 2700,
	"def": 1400,
	"type": "dinosaur",
	"count_as": null,
	"effect": [],
	"passcode": "06849042"
  },
  "00861": {
	"card_name": "Frostosaurus",
	"attribute": "water",
	"level": 6,
	"atk": 2600,
	"def": 1700,
	"type": "dinosaur",
	"count_as": null,
	"effect": [],
	"passcode": "06631034"
  },
  "00862": {
	"card_name": "Sabersaurus",
	"attribute": "earth",
	"level": 4,
	"atk": 1900,
	"def": 500,
	"type": "dinosaur",
	"count_as": null,
	"effect": [],
	"passcode": "37265642"
  },
  "00863": {
	"card_name": "Megazowler",
	"attribute": "earth",
	"level": 6,
	"atk": 1800,
	"def": 2000,
	"type": "dinosaur",
	"count_as": null,
	"effect": [],
	"passcode": "75390004"
  },
  "00864": {
	"card_name": "Gilasaurus",
	"attribute": "earth",
	"level": 3,
	"atk": 1400,
	"def": 400,
	"type": "dinosaur",
	"count_as": null,
	"effect": [],
	"passcode": "45894482"
  },
  "00865": {
	"card_name": "Hyper Hammerhead",
	"attribute": "earth",
	"level": 4,
	"atk": 1500,
	"def": 1200,
	"type": "dinosaur",
	"count_as": null,
	"effect": [],
	"passcode": "02671330"
  },
  "00866": {
	"card_name": "Gale Lizard",
	"attribute": "water",
	"level": 4,
	"atk": 1400,
	"def": 700,
	"type": "reptile",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "77491079"
  },
  "00867": {
	"card_name": "Mad Sword Beast",
	"attribute": "earth",
	"level": 4,
	"atk": 1400,
	"def": 1200,
	"type": "dinosaur",
	"count_as": "beast",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "79870141"
  },
  "00868": {
	"card_name": "Souleating Oviraptor",
	"attribute": "dark",
	"level": 4,
	"atk": 1800,
	"def": 500,
	"type": "dinosaur",
	"count_as": "fiend",
	"effect": [],
	"passcode": "44335251"
  },
  "00869": {
	"card_name": "Kabazauls",
	"attribute": "water",
	"level": 4,
	"atk": 1700,
	"def": 1500,
	"type": "dinosaur",
	"count_as": "aqua",
	"effect": [],
	"passcode": "51934376"
  },
  "00870": {
	"card_name": "Black Stego",
	"attribute": "earth",
	"level": 4,
	"atk": 1200,
	"def": 2000,
	"type": "dinosaur",
	"count_as": "fiend",
	"effect": [
	  "on_defend",
	  "change_position"
	],
	"passcode": "79409334"
  },
  "00871": {
	"card_name": "Black Ptera",
	"attribute": "wind",
	"level": 3,
	"atk": 1000,
	"def": 500,
	"type": "dinosaur",
	"count_as": "fiend",
	"effect": [],
	"passcode": "90654356"
  },
  "00872": {
	"card_name": "Black Brachios",
	"attribute": "earth",
	"level": 4,
	"atk": 1800,
	"def": 1100,
	"type": "dinosaur",
	"count_as": "fiend",
	"effect": [
	  "on_attack",
	  "change_position"
	],
	"passcode": "50896944"
  },
  "00873": {
	"card_name": "Black Veloci",
	"attribute": "earth",
	"level": 4,
	"atk": 1800,
	"def": 300,
	"type": "dinosaur",
	"count_as": "fiend",
	"effect": [
	  "on_summon",
	  "self_power_up",
	  300
	],
	"passcode": "52319752"
  },
  "00874": {
	"card_name": "Balloon Lizard",
	"attribute": "earth",
	"level": 4,
	"atk": 500,
	"def": 1900,
	"type": "reptile",
	"count_as": null,
	"effect": [],
	"passcode": "39892082"
  },
  "00875": {
	"card_name": "Beatraptor",
	"attribute": "earth",
	"level": 4,
	"atk": 1400,
	"def": 2000,
	"type": "dinosaur",
	"count_as": "winged beast",
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "46924949"
  },
  "00876": {
	"card_name": "Stegocyber",
	"attribute": "dark",
	"level": 6,
	"atk": 1200,
	"def": 2400,
	"type": "dinosaur",
	"count_as": "machine",
	"effect": [
	  "on_defend",
	  "no_damage"
	],
	"passcode": "99733359"
  },
  "00877": {
	"card_name": "Re: EX",
	"attribute": "light",
	"level": 4,
	"atk": 1900,
	"def": 1200,
	"type": "dinosaur",
	"count_as": null,
	"effect": [],
	"passcode": "18000338"
  },
  "00878": {
	"card_name": "Babycerasaurus",
	"attribute": "earth",
	"level": 2,
	"atk": 500,
	"def": 500,
	"type": "dinosaur",
	"count_as": "egg",
	"effect": [],
	"passcode": "36042004"
  },
  "00879": {
	"card_name": "Petiteranodon",
	"attribute": "earth",
	"level": 2,
	"atk": 500,
	"def": 500,
	"type": "dinosaur",
	"count_as": "egg",
	"effect": [],
	"passcode": "82946847"
  },
  "00880": {
	"card_name": "Servant of Catabolism",
	"attribute": "light",
	"level": 3,
	"atk": 700,
	"def": 500,
	"type": "aqua",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "02792265"
  },
  "00881": {
	"card_name": "Mad Lobster",
	"attribute": "water",
	"level": 3,
	"atk": 1700,
	"def": 1000,
	"type": "aqua",
	"count_as": "fiend",
	"effect": [],
	"passcode": "97240270"
  },
  "00882": {
	"card_name": "Little D",
	"attribute": "earth",
	"level": 3,
	"atk": 1100,
	"def": 700,
	"type": "dinosaur",
	"count_as": null,
	"effect": [],
	"passcode": "42625254"
  },
  "00883": {
	"card_name": "Cyberdark End Dragon",
	"attribute": "dark",
	"level": 12,
	"atk": 5000,
	"def": 3800,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "37542782"
  },
  "00884": {
	"card_name": "Cyber End Dragon",
	"attribute": "light",
	"level": 10,
	"atk": 4000,
	"def": 2800,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "01546123"
  },
  "00885": {
	"card_name": "Chimeratech Overdragon",
	"attribute": "dark",
	"level": 9,
	"atk": 0,
	"def": 0,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "on_summon",
	  "monster_count_boost",
	  800
	],
	"passcode": "64599569"
  },
  "00886": {
	"card_name": "Cyber Twin Dragon",
	"attribute": "light",
	"level": 8,
	"atk": 2800,
	"def": 2100,
	"type": "machine",
	"count_as": "cyber",
	"effect": [],
	"passcode": "74157028"
  },
  "00887": {
	"card_name": "Cyber Eltanin",
	"attribute": "light",
	"level": 10,
	"atk": 0,
	"def": 0,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "on_summon",
	  "graveyard_power_up",
	  500
	],
	"passcode": "33093439"
  },
  "00888": {
	"card_name": "Chimeratech Fortress Dragon",
	"attribute": "dark",
	"level": 8,
	"atk": 0,
	"def": 0,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "on_summon",
	  "monster_count_boost",
	  1000
	],
	"passcode": "79229522"
  },
  "00889": {
	"card_name": "Chimeratech Megafleet Dragon",
	"attribute": "dark",
	"level": 10,
	"atk": 0,
	"def": 0,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "on_summon",
	  "monster_count_boost",
	  1200
	],
	"passcode": "87116928"
  },
  "00890": {
	"card_name": "Perfect Machine King",
	"attribute": "earth",
	"level": 8,
	"atk": 2700,
	"def": 1500,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  500
	],
	"passcode": "18891691"
  },
  "00891": {
	"card_name": "Cyber Barrier Dragon",
	"attribute": "light",
	"level": 6,
	"atk": 800,
	"def": 2800,
	"type": "machine",
	"count_as": "cyber",
	"effect": [],
	"passcode": "68774379"
  },
  "00892": {
	"card_name": "Cyber Laser Dragon",
	"attribute": "light",
	"level": 7,
	"atk": 2400,
	"def": 1800,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "atk_highest"
	],
	"passcode": "04162088"
  },
  "00893": {
	"card_name": "Cyberdark Dragon",
	"attribute": "dark",
	"level": 8,
	"atk": 1000,
	"def": 1000,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "on_summon",
	  "graveyard_power_up",
	  100
	],
	"passcode": "40418351"
  },
  "00894": {
	"card_name": "Chimeratech Rampage Dragon",
	"attribute": "dark",
	"level": 5,
	"atk": 2100,
	"def": 1600,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "all_enemy_spelltraps"
	],
	"passcode": "84058253"
  },
  "00895": {
	"card_name": "Cyberdarkness Dragon",
	"attribute": "dark",
	"level": 10,
	"atk": 2000,
	"def": 2000,
	"type": "machine",
	"count_as": "cyberdark",
	"effect": [
	  "on_summon",
	  "graveyard_power_up",
	  200
	],
	"passcode": "18967507"
  },
  "00896": {
	"card_name": "Cyber Ogre 2",
	"attribute": "earth",
	"level": 7,
	"atk": 2600,
	"def": 1900,
	"type": "machine",
	"count_as": "cyber",
	"effect": [],
	"passcode": "37057012"
  },
  "00897": {
	"card_name": "Cyber Ogre",
	"attribute": "earth",
	"level": 5,
	"atk": 1900,
	"def": 1200,
	"type": "machine",
	"count_as": "cyber",
	"effect": [],
	"passcode": "64268668"
  },
  "00898": {
	"card_name": "Cyber Kirin",
	"attribute": "light",
	"level": 3,
	"atk": 300,
	"def": 800,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "on_defend",
	  "no_damage"
	],
	"passcode": "76986005"
  },
  "00899": {
	"card_name": "Proto-Cyber Dragon",
	"attribute": "light",
	"level": 3,
	"atk": 1100,
	"def": 600,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "special_description"
	],
	"passcode": "26439287"
  },
  "00900": {
	"card_name": "Cyber Larva",
	"attribute": "light",
	"level": 1,
	"atk": 400,
	"def": 600,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "on_defend",
	  "no_damage"
	],
	"passcode": "35050257"
  },
  "00901": {
	"card_name": "Cyber Ouroboros",
	"attribute": "dark",
	"level": 2,
	"atk": 100,
	"def": 600,
	"type": "machine",
	"count_as": "cyber",
	"effect": [],
	"passcode": "30042158"
  },
  "00902": {
	"card_name": "Cyber Dragon Core",
	"attribute": "light",
	"level": 2,
	"atk": 400,
	"def": 1500,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "special_description"
	],
	"passcode": "23893227"
  },
  "00903": {
	"card_name": "Cyber Dragon Zwei",
	"attribute": "light",
	"level": 4,
	"atk": 1500,
	"def": 1000,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "on_summon",
	  "friends_power_up",
	  200
	],
	"passcode": "05373478"
  },
  "00904": {
	"card_name": "Cyber Dragon Drei",
	"attribute": "light",
	"level": 4,
	"atk": 1800,
	"def": 800,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "on_summon",
	  "friends_power_up",
	  300
	],
	"passcode": "59281922"
  },
  "00905": {
	"card_name": "Cyber Dragon Vier",
	"attribute": "light",
	"level": 4,
	"atk": 1100,
	"def": 1600,
	"type": "machine",
	"count_as": "cyber",
	"effect": [
	  "on_summon",
	  "friends_power_up",
	  400
	],
	"passcode": "29975188"
  },
  "00906": {
	"card_name": "Cyberdark Edge",
	"attribute": "dark",
	"level": 4,
	"atk": 800,
	"def": 800,
	"type": "machine",
	"count_as": "cyberdark",
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "77625948"
  },
  "00907": {
	"card_name": "Cyberdark Horn",
	"attribute": "dark",
	"level": 4,
	"atk": 800,
	"def": 800,
	"type": "machine",
	"count_as": "cyberdark",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "41230939"
  },
  "00908": {
	"card_name": "Cyberdark Keel",
	"attribute": "dark",
	"level": 4,
	"atk": 800,
	"def": 800,
	"type": "machine",
	"count_as": "cyberdark",
	"effect": [
	  "on_attack",
	  "burn",
	  300
	],
	"passcode": "03019642"
  },
  "00909": {
	"card_name": "Cyberdark Cannon",
	"attribute": "dark",
	"level": 3,
	"atk": 1600,
	"def": 800,
	"type": "dragon",
	"count_as": "cyberdark",
	"effect": [],
	"passcode": "45078193"
  },
  "00910": {
	"card_name": "Cyberdark Chimera",
	"attribute": "dark",
	"level": 4,
	"atk": 800,
	"def": 2100,
	"type": "machine",
	"count_as": "cyberdark",
	"effect": [],
	"passcode": "05370235"
  },
  "00911": {
	"card_name": "Cyberdark Claw",
	"attribute": "dark",
	"level": 3,
	"atk": 1600,
	"def": 800,
	"type": "dragon",
	"count_as": "cyberdark",
	"effect": [],
	"passcode": "82562802"
  },
  "00912": {
	"card_name": "Armored Cybern",
	"attribute": "wind",
	"level": 4,
	"atk": 0,
	"def": 2000,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "67159705"
  },
  "00913": {
	"card_name": "Attachment Cybern",
	"attribute": "light",
	"level": 3,
	"atk": 1600,
	"def": 800,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "79875526"
  },
  "00914": {
	"card_name": "Cyber Soldier of Darkworld",
	"attribute": "dark",
	"level": 4,
	"atk": 1400,
	"def": 1200,
	"type": "machine",
	"count_as": "warrior",
	"effect": [],
	"passcode": "75559356"
  },
  "00915": {
	"card_name": "Cyber Archfiend",
	"attribute": "dark",
	"level": 4,
	"atk": 1000,
	"def": 2000,
	"type": "fiend",
	"count_as": "machine",
	"effect": [],
	"passcode": "59907935"
  },
  "00916": {
	"card_name": "Cyber Esper",
	"attribute": "fire",
	"level": 4,
	"atk": 1200,
	"def": 1800,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "91663373"
  },
  "00917": {
	"card_name": "Mechanicalchaser",
	"attribute": "dark",
	"level": 4,
	"atk": 1850,
	"def": 800,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "07359741"
  },
  "00918": {
	"card_name": "Nanobreaker",
	"attribute": "earth",
	"level": 4,
	"atk": 1600,
	"def": 1800,
	"type": "machine",
	"count_as": "female",
	"effect": [],
	"passcode": "70948327"
  },
  "00919": {
	"card_name": "Infernal Incinerator",
	"attribute": "fire",
	"level": 6,
	"atk": 2800,
	"def": 1800,
	"type": "fiend",
	"count_as": "insect",
	"effect": [
	  "on_summon",
	  "monster_count_boost",
	  200
	],
	"passcode": "23309606"
  },
  "00920": {
	"card_name": "Despair from the Dark",
	"attribute": "dark",
	"level": 8,
	"atk": 2800,
	"def": 3000,
	"type": "zombie",
	"count_as": "fiend",
	"effect": [],
	"passcode": "71200730"
  },
  "00921": {
	"card_name": "Dark Armed Dragon",
	"attribute": "dark",
	"level": 7,
	"atk": 2800,
	"def": 1000,
	"type": "dragon",
	"count_as": "fiend",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "65192027"
  },
  "00922": {
	"card_name": "Light and Darkness Dragon",
	"attribute": "light",
	"level": 8,
	"atk": 2800,
	"def": 2400,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "47297616"
  },
  "00923": {
	"card_name": "Ojama King",
	"attribute": "light",
	"level": 6,
	"atk": 0,
	"def": 3000,
	"type": "beast",
	"count_as": "ojama",
	"effect": [
	  "on_summon",
	  "count_as_power_up",
	  1000
	],
	"passcode": "90140980"
  },
  "00924": {
	"card_name": "Ojama Knight",
	"attribute": "light",
	"level": 5,
	"atk": 0,
	"def": 2500,
	"type": "beast",
	"count_as": "ojama",
	"effect": [
	  "on_summon",
	  "count_as_power_up",
	  500
	],
	"passcode": "40391316"
  },
  "00925": {
	"card_name": "Mecha Ojama King",
	"attribute": "light",
	"level": 6,
	"atk": 0,
	"def": 3000,
	"type": "machine",
	"count_as": "ojama",
	"effect": [
	  "on_summon",
	  "count_as_power_up",
	  1000
	],
	"passcode": "08904109"
  },
  "00926": {
	"card_name": "Dragonic Knight",
	"attribute": "fire",
	"level": 7,
	"atk": 2800,
	"def": 2300,
	"type": "dragon",
	"count_as": "warrior",
	"effect": [],
	"passcode": "38109772"
  },
  "00927": {
	"card_name": "Chthonian Emperor Dragon",
	"attribute": "fire",
	"level": 6,
	"atk": 2400,
	"def": 1500,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "95888876"
  },
  "00928": {
	"card_name": "Ojama Yellow",
	"attribute": "light",
	"level": 2,
	"atk": 0,
	"def": 1000,
	"type": "beast",
	"count_as": "ojama",
	"effect": [],
	"passcode": "42941100"
  },
  "00929": {
	"card_name": "Ojama Black",
	"attribute": "light",
	"level": 2,
	"atk": 0,
	"def": 1000,
	"type": "beast",
	"count_as": "ojama",
	"effect": [],
	"passcode": "79335209"
  },
  "00930": {
	"card_name": "Ojama Green",
	"attribute": "light",
	"level": 2,
	"atk": 0,
	"def": 1000,
	"type": "beast",
	"count_as": "ojama",
	"effect": [],
	"passcode": "12482652"
  },
  "00931": {
	"card_name": "Ojama Blue",
	"attribute": "light",
	"level": 2,
	"atk": 0,
	"def": 1000,
	"type": "beast",
	"count_as": "ojama",
	"effect": [
	  "on_summon",
	  "count_as_power_up",
	  200
	],
	"passcode": "64627453"
  },
  "00932": {
	"card_name": "Ojama Red",
	"attribute": "light",
	"level": 2,
	"atk": 0,
	"def": 1000,
	"type": "beast",
	"count_as": "ojama",
	"effect": [
	  "on_summon",
	  "count_as_power_up",
	  400
	],
	"passcode": "37132349"
  },
  "00933": {
	"card_name": "Ojama Pink",
	"attribute": "light",
	"level": 2,
	"atk": 0,
	"def": 1000,
	"type": "beast",
	"count_as": "ojama",
	"effect": [
	  "on_summon",
	  "count_as_power_up",
	  100
	],
	"passcode": "42517468"
  },
  "00934": {
	"card_name": "Chaos Necromancer",
	"attribute": "dark",
	"level": 1,
	"atk": 0,
	"def": 0,
	"type": "fiend",
	"count_as": "spellcaster",
	"effect": [
	  "on_summon",
	  "graveyard_power_up",
	  300
	],
	"passcode": "01434352"
  },
  "00935": {
	"card_name": "Chthonian Soldier",
	"attribute": "dark",
	"level": 4,
	"atk": 1200,
	"def": 1400,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_defend",
	  "return_damage"
	],
	"passcode": "50916353"
  },
  "00936": {
	"card_name": "Mefist the Infernal General",
	"attribute": "dark",
	"level": 5,
	"atk": 1800,
	"def": 1700,
	"type": "fiend",
	"count_as": "warrior",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "46820049"
  },
  "00937": {
	"card_name": "Helpoemer",
	"attribute": "dark",
	"level": 5,
	"atk": 2000,
	"def": 1400,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "76052811"
  },
  "00938": {
	"card_name": "Reborn Zombie",
	"attribute": "dark",
	"level": 4,
	"atk": 1000,
	"def": 1600,
	"type": "zombie",
	"count_as": null,
	"effect": [
	  "on_defend",
	  "cant_die"
	],
	"passcode": "23421244"
  },
  "00939": {
	"card_name": "Knight of Armor Dragon",
	"attribute": "wind",
	"level": 4,
	"atk": 1900,
	"def": 1200,
	"type": "dragon",
	"count_as": "warrior",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "75901113"
  },
  "00940": {
	"card_name": "Golem Dragon",
	"attribute": "earth",
	"level": 4,
	"atk": 200,
	"def": 2000,
	"type": "dragon",
	"count_as": "rock",
	"effect": [],
	"passcode": "09666558"
  },
  "00941": {
	"card_name": "Lancer Lindwurm",
	"attribute": "wind",
	"level": 4,
	"atk": 1800,
	"def": 1200,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "46272804"
  },
  "00942": {
	"card_name": "Genesis Dragon",
	"attribute": "light",
	"level": 6,
	"atk": 2200,
	"def": 1800,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "31038159"
  },
  "00943": {
	"card_name": "Gemini Imps",
	"attribute": "dark",
	"level": 4,
	"atk": 1000,
	"def": 1000,
	"type": "fiend",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "67688478"
  },
  "00944": {
	"card_name": "Gyaku-Gire Panda",
	"attribute": "earth",
	"level": 3,
	"atk": 800,
	"def": 1600,
	"type": "beast",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "monster_count_boost",
	  500
	],
	"passcode": "09817927"
  },
  "00945": {
	"card_name": "KA-2 Des Scissors",
	"attribute": "dark",
	"level": 4,
	"atk": 1000,
	"def": 1000,
	"type": "machine",
	"count_as": "insect",
	"effect": [
	  "on_attack",
	  "burn",
	  500
	],
	"passcode": "52768103"
  },
  "00946": {
	"card_name": "Blood Sucker",
	"attribute": "dark",
	"level": 4,
	"atk": 1300,
	"def": 1500,
	"type": "zombie",
	"count_as": "vampire",
	"effect": [
	  "on_attack",
	  "mill",
	  1
	],
	"passcode": "97783659"
  },
  "00947": {
	"card_name": "Ultimate Baseball Kid",
	"attribute": "fire",
	"level": 3,
	"atk": 500,
	"def": 1000,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  "same_attribute"
	],
	"passcode": "67934141"
  },
  "00948": {
	"card_name": "Fear from the Dark",
	"attribute": "dark",
	"level": 4,
	"atk": 1700,
	"def": 1500,
	"type": "zombie",
	"count_as": "fiend",
	"effect": [],
	"passcode": "34193084"
  },
  "00949": {
	"card_name": "Mystic Dragon",
	"attribute": "wind",
	"level": 8,
	"atk": 3600,
	"def": 1600,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "85110220"
  },
  "00950": {
	"card_name": "House Dragonmaid",
	"attribute": "light",
	"level": 9,
	"atk": 3000,
	"def": 2000,
	"type": "dragon",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "41232647"
  },
  "00951": {
	"card_name": "Dragonmaid Sheou",
	"attribute": "light",
	"level": 10,
	"atk": 3500,
	"def": 2000,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "24799107"
  },
  "00952": {
	"card_name": "Injection Fairy Lily",
	"attribute": "earth",
	"level": 3,
	"atk": 400,
	"def": 1500,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "injection_fairy"
	],
	"passcode": "79575620"
  },
  "00953": {
	"card_name": "Splendid Venus",
	"attribute": "light",
	"level": 8,
	"atk": 2800,
	"def": 2400,
	"type": "fairy",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "friends_power_up",
	  500
	],
	"passcode": "05645210"
  },
  "00954": {
	"card_name": "Dragonmaid Ernus",
	"attribute": "earth",
	"level": 7,
	"atk": 2600,
	"def": 1600,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "76782778"
  },
  "00955": {
	"card_name": "Dragonmaid Tinkhec",
	"attribute": "fire",
	"level": 8,
	"atk": 2700,
	"def": 1700,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "42055234"
  },
  "00956": {
	"card_name": "Dragonmaid Nudyarl",
	"attribute": "water",
	"level": 7,
	"atk": 2600,
	"def": 1600,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "49575521"
  },
  "00957": {
	"card_name": "Dragonmaid Lorpar",
	"attribute": "wind",
	"level": 8,
	"atk": 2700,
	"def": 1700,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "15848542"
  },
  "00958": {
	"card_name": "Outstanding Dog Marron",
	"attribute": "light",
	"level": 1,
	"atk": 100,
	"def": 100,
	"type": "beast",
	"count_as": null,
	"effect": [],
	"passcode": "11548522"
  },
  "00959": {
	"card_name": "Maiden in Love",
	"attribute": "light",
	"level": 2,
	"atk": 400,
	"def": 300,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_defend",
	  "cant_die"
	],
	"passcode": "20060914"
  },
  "00960": {
	"card_name": "Mad Dog of Darkness",
	"attribute": "dark",
	"level": 4,
	"atk": 1900,
	"def": 1400,
	"type": "beast",
	"count_as": "fiend",
	"effect": [],
	"passcode": "79182538"
  },
  "00961": {
	"card_name": "Mecha-Dog Marron",
	"attribute": "light",
	"level": 4,
	"atk": 1000,
	"def": 1000,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "burn",
	  1000
	],
	"passcode": "94667532"
  },
  "00962": {
	"card_name": "Skull Dog Marron",
	"attribute": "earth",
	"level": 4,
	"atk": 1350,
	"def": 2000,
	"type": "beast",
	"count_as": "zombie",
	"effect": [],
	"passcode": "86652646"
  },
  "00963": {
	"card_name": "Mystic Baby Dragon",
	"attribute": "wind",
	"level": 4,
	"atk": 1200,
	"def": 1600,
	"type": "dragon",
	"count_as": "egg",
	"effect": [],
	"passcode": "85110219"
  },
  "00964": {
	"card_name": "Ebon Magician Curran",
	"attribute": "dark",
	"level": 2,
	"atk": 1200,
	"def": 0,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "damage_monster_count",
	  300
	],
	"passcode": "46128076"
  },
  "00965": {
	"card_name": "Princess Curran",
	"attribute": "dark",
	"level": 4,
	"atk": 2000,
	"def": 0,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "damage_monster_count",
	  600
	],
	"passcode": "02316186"
  },
  "00966": {
	"card_name": "White Magician Pikeru",
	"attribute": "light",
	"level": 2,
	"atk": 1200,
	"def": 0,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "lifeup_monster_count",
	  400
	],
	"passcode": "81383947"
  },
  "00967": {
	"card_name": "Princess Pikeru",
	"attribute": "light",
	"level": 4,
	"atk": 2000,
	"def": 0,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "lifeup_monster_count",
	  800
	],
	"passcode": "75917088"
  },
  "00968": {
	"card_name": "Fire Princess",
	"attribute": "fire",
	"level": 4,
	"atk": 1300,
	"def": 1500,
	"type": "pyro",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "burn",
	  500
	],
	"passcode": "64752646"
  },
  "00969": {
	"card_name": "Dancing Fairy",
	"attribute": "wind",
	"level": 4,
	"atk": 1700,
	"def": 1000,
	"type": "fairy",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "lifepoint_up",
	  1000
	],
	"passcode": "90925163"
  },
  "00970": {
	"card_name": "Darklord Nurse Reficule",
	"attribute": "dark",
	"level": 4,
	"atk": 1400,
	"def": 600,
	"type": "fairy",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "burn",
	  "enemy_atk"
	],
	"passcode": "67316075"
  },
  "00971": {
	"card_name": "Chamber Dragonmaid",
	"attribute": "dark",
	"level": 4,
	"atk": 500,
	"def": 1800,
	"type": "dragon",
	"count_as": "female",
	"effect": [],
	"passcode": "32600024"
  },
  "00972": {
	"card_name": "Nurse Dragonmaid",
	"attribute": "earth",
	"level": 2,
	"atk": 500,
	"def": 1600,
	"type": "dragon",
	"count_as": "female",
	"effect": [],
	"passcode": "40398073"
  },
  "00973": {
	"card_name": "Kitchen Dragonmaid",
	"attribute": "fire",
	"level": 3,
	"atk": 500,
	"def": 1700,
	"type": "dragon",
	"count_as": "female",
	"effect": [],
	"passcode": "16960120"
  },
  "00974": {
	"card_name": "Laundry Dragonmaid",
	"attribute": "water",
	"level": 2,
	"atk": 500,
	"def": 1600,
	"type": "dragon",
	"count_as": "female",
	"effect": [],
	"passcode": "13171876"
  },
  "00975": {
	"card_name": "Parlor Dragonmaid",
	"attribute": "wind",
	"level": 3,
	"atk": 500,
	"def": 1700,
	"type": "dragon",
	"count_as": "female",
	"effect": [],
	"passcode": "88453933"
  },
  "00976": {
	"card_name": "Cyber Angel Vrash",
	"attribute": "light",
	"level": 10,
	"atk": 3000,
	"def": 2000,
	"type": "fairy",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "all_enemy_monsters"
	],
	"passcode": "78316184"
  },
  "00977": {
	"card_name": "Cyber Angel Dakini",
	"attribute": "light",
	"level": 8,
	"atk": 2700,
	"def": 2400,
	"type": "fairy",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "39618799"
  },
  "00978": {
	"card_name": "White Night Dragon",
	"attribute": "water",
	"level": 8,
	"atk": 3000,
	"def": 2500,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "79473793"
  },
  "00979": {
	"card_name": "Ice Queen",
	"attribute": "water",
	"level": 8,
	"atk": 2900,
	"def": 2100,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "14462257"
  },
  "00980": {
	"card_name": "Blizzard Princess",
	"attribute": "water",
	"level": 8,
	"atk": 2800,
	"def": 2100,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "28348537"
  },
  "00981": {
	"card_name": "Snowdust Dragon",
	"attribute": "water",
	"level": 8,
	"atk": 2800,
	"def": 1800,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "67675300"
  },
  "00982": {
	"card_name": "Cosmo Queen",
	"attribute": "dark",
	"level": 8,
	"atk": 2900,
	"def": 2450,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "38999506"
  },
  "00983": {
	"card_name": "Cyber Prima",
	"attribute": "light",
	"level": 6,
	"atk": 2300,
	"def": 1600,
	"type": "warrior",
	"count_as": "female",
	"effect": [],
	"passcode": "02158562"
  },
  "00984": {
	"card_name": "Cyber Angel Izana",
	"attribute": "light",
	"level": 8,
	"atk": 2500,
	"def": 2600,
	"type": "fairy",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "91668401"
  },
  "00985": {
	"card_name": "Cyber Blader",
	"attribute": "earth",
	"level": 7,
	"atk": 2100,
	"def": 800,
	"type": "warrior",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "10248389"
  },
  "00986": {
	"card_name": "Inferno Hammer",
	"attribute": "dark",
	"level": 6,
	"atk": 2400,
	"def": 0,
	"type": "fiend",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "flip_enemy_down"
	],
	"passcode": "17185260"
  },
  "00987": {
	"card_name": "Cyber Angel Idaten",
	"attribute": "light",
	"level": 6,
	"atk": 1600,
	"def": 2000,
	"type": "fairy",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "friends_power_up",
	  1000
	],
	"passcode": "03629090"
  },
  "00988": {
	"card_name": "Ice Master",
	"attribute": "water",
	"level": 8,
	"atk": 2500,
	"def": 2000,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "atk_highest"
	],
	"passcode": "32750510"
  },
  "00989": {
	"card_name": "The Suppression Pluto",
	"attribute": "dark",
	"level": 8,
	"atk": 2600,
	"def": 2000,
	"type": "fiend",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "24413299"
  },
  "00990": {
	"card_name": "Machine Angel Ritual",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "ritual",
	"count_as": null,
	"effect": [
	  "ritual",
	  987,
	  984,
	  977,
	  976
	],
	"passcode": "39996157"
  },
  "00991": {
	"card_name": "Ritual Weapon",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "atk_up",
	  1500,
	  "ritual"
	],
	"passcode": "54351224"
  },
  "00992": {
	"card_name": "Blade Skater",
	"attribute": "earth",
	"level": 4,
	"atk": 1400,
	"def": 1500,
	"type": "warrior",
	"count_as": "female",
	"effect": [],
	"passcode": "97023549"
  },
  "00993": {
	"card_name": "Cyber Gymnast",
	"attribute": "earth",
	"level": 4,
	"atk": 800,
	"def": 1800,
	"type": "warrior",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "76763417"
  },
  "00994": {
	"card_name": "Cyber Tutu",
	"attribute": "earth",
	"level": 3,
	"atk": 1000,
	"def": 800,
	"type": "warrior",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "49375719"
  },
  "00995": {
	"card_name": "Etoile Cyber",
	"attribute": "earth",
	"level": 4,
	"atk": 1200,
	"def": 1600,
	"type": "warrior",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "11460577"
  },
  "00996": {
	"card_name": "Cyber Tutubon",
	"attribute": "earth",
	"level": 5,
	"atk": 1800,
	"def": 1600,
	"type": "warrior",
	"count_as": "female",
	"effect": [],
	"passcode": "42600274"
  },
  "00997": {
	"card_name": "Cyber Angel Benten",
	"attribute": "light",
	"level": 6,
	"atk": 1800,
	"def": 1500,
	"type": "fairy",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "burn",
	  "enemy_atk"
	],
	"passcode": "77235086"
  },
  "00998": {
	"card_name": "Cyber Angel Natasha",
	"attribute": "light",
	"level": 5,
	"atk": 1000,
	"def": 1000,
	"type": "fairy",
	"count_as": "female",
	"effect": [
	  "on_attack",
	  "lifepoint_up",
	  1000
	],
	"passcode": "99427357"
  },
  "00999": {
	"card_name": "White Night Queen",
	"attribute": "light",
	"level": 7,
	"atk": 2100,
	"def": 800,
	"type": "fairy",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "20193924"
  },
  "01000": {
	"card_name": "Cold Enchanter",
	"attribute": "water",
	"level": 4,
	"atk": 1600,
	"def": 1200,
	"type": "aqua",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "self_power_up",
	  200
	],
	"passcode": "24661486"
  },
  "01001": {
	"card_name": "Aquarian Alessa",
	"attribute": "water",
	"level": 4,
	"atk": 1500,
	"def": 500,
	"type": "aqua",
	"count_as": "female",
	"effect": [],
	"passcode": "22377815"
  },
  "01002": {
	"card_name": "Crystal Girl",
	"attribute": "water",
	"level": 1,
	"atk": 200,
	"def": 100,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "93169863"
  },
  "01003": {
	"card_name": "Snow Dragon",
	"attribute": "water",
	"level": 4,
	"atk": 1400,
	"def": 900,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "03070049"
  },
  "01004": {
	"card_name": "Snowman Eater",
	"attribute": "water",
	"level": 3,
	"atk": 0,
	"def": 1900,
	"type": "aqua",
	"count_as": "fiend",
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "91133740"
  },
  "01005": {
	"card_name": "Freya, Spirit of Victory",
	"attribute": "light",
	"level": 1,
	"atk": 100,
	"def": 100,
	"type": "fairy",
	"count_as": "female",
	"effect": [
	  "on_summon",
	  "friends_power_up",
	  400
	],
	"passcode": "12398280"
  },
  "01006": {
	"card_name": "Cyber Petit Angel",
	"attribute": "light",
	"level": 2,
	"atk": 300,
	"def": 200,
	"type": "fairy",
	"count_as": "machine",
	"effect": [],
	"passcode": "76103404"
  },
  "01007": {
	"card_name": "Mind on Air",
	"attribute": "dark",
	"level": 6,
	"atk": 1000,
	"def": 1600,
	"type": "spellcaster",
	"count_as": "female",
	"effect": [],
	"passcode": "66690411"
  },
  "01008": {
	"card_name": "Warrior Lady of the Wasteland",
	"attribute": "earth",
	"level": 4,
	"atk": 1100,
	"def": 1200,
	"type": "warrior",
	"count_as": "female",
	"effect": [],
	"passcode": "05438492"
  },
  "01009": {
	"card_name": "Beautiful Headhuntress",
	"attribute": "earth",
	"level": 4,
	"atk": 1600,
	"def": 800,
	"type": "warrior",
	"count_as": "female",
	"effect": [],
	"passcode": "16899564"
  },
  "01010": {
	"card_name": "Chaos Ancient Gear Giant",
	"attribute": "dark",
	"level": 10,
	"atk": 4500,
	"def": 3000,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "51788412"
  },
  "01011": {
	"card_name": "Ultimate Ancient Gear Golem",
	"attribute": "earth",
	"level": 10,
	"atk": 4400,
	"def": 3400,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "12652643"
  },
  "01012": {
	"card_name": "Ancient Gear Megaton Golem",
	"attribute": "earth",
	"level": 9,
	"atk": 3300,
	"def": 3300,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "37663536"
  },
  "01013": {
	"card_name": "Ancient Gear Golem",
	"attribute": "earth",
	"level": 8,
	"atk": 3000,
	"def": 3000,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "83104731"
  },
  "01014": {
	"card_name": "Ancient Gear Reactor Dragon",
	"attribute": "earth",
	"level": 9,
	"atk": 3000,
	"def": 3000,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "44874522"
  },
  "01015": {
	"card_name": "Ancient Gear Gadjiltron Dragon",
	"attribute": "earth",
	"level": 8,
	"atk": 3000,
	"def": 2000,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "50933533"
  },
  "01016": {
	"card_name": "Emes the Infinity",
	"attribute": "light",
	"level": 7,
	"atk": 2500,
	"def": 2000,
	"type": "machine",
	"count_as": "warrior",
	"effect": [
	  "on_summon",
	  "self_power_up",
	  300
	],
	"passcode": "43580269"
  },
  "01017": {
	"card_name": "Ancient Gear Gadjiltron Chimera",
	"attribute": "earth",
	"level": 6,
	"atk": 2300,
	"def": 1300,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "burn",
	  700
	],
	"passcode": "86321248"
  },
  "01018": {
	"card_name": "Ancient Gear Hydra",
	"attribute": "earth",
	"level": 7,
	"atk": 2700,
	"def": 1700,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "81269231"
  },
  "01019": {
	"card_name": "The Big Saturn",
	"attribute": "dark",
	"level": 8,
	"atk": 2800,
	"def": 2200,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "burn",
	  "enemy_atk"
	],
	"passcode": "34004470"
  },
  "01020": {
	"card_name": "Ancient Gear Beast",
	"attribute": "earth",
	"level": 6,
	"atk": 2000,
	"def": 2000,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "10509340"
  },
  "01021": {
	"card_name": "Ancient Gear Engineer",
	"attribute": "earth",
	"level": 5,
	"atk": 1500,
	"def": 1500,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "01953925"
  },
  "01022": {
	"card_name": "Ancient Gear Soldier",
	"attribute": "earth",
	"level": 4,
	"atk": 1300,
	"def": 1300,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "56094445"
  },
  "01023": {
	"card_name": "Ancient Gear Knight",
	"attribute": "earth",
	"level": 4,
	"atk": 1800,
	"def": 500,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "39303359"
  },
  "01024": {
	"card_name": "Ancient Gear Frame",
	"attribute": "earth",
	"level": 4,
	"atk": 1600,
	"def": 500,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "01278431"
  },
  "01025": {
	"card_name": "Ancient Gear Wyvern",
	"attribute": "earth",
	"level": 4,
	"atk": 1700,
	"def": 1200,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "17663375"
  },
  "01026": {
	"card_name": "Ancient Gear Gadget",
	"attribute": "earth",
	"level": 4,
	"atk": 500,
	"def": 2000,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "ignore_spelltrap"
	],
	"passcode": "18486927"
  },
  "01027": {
	"card_name": "Ancient Gear Howitzer",
	"attribute": "earth",
	"level": 8,
	"atk": 1000,
	"def": 1800,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "burn",
	  1000
	],
	"passcode": "87182127"
  },
  "01028": {
	"card_name": "Ancient Gear Hunting Hound",
	"attribute": "earth",
	"level": 3,
	"atk": 1000,
	"def": 1000,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_attack",
	  "burn",
	  600
	],
	"passcode": "42878636"
  },
  "01029": {
	"card_name": "Ancient Gear",
	"attribute": "earth",
	"level": 2,
	"atk": 100,
	"def": 800,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "special_description"
	],
	"passcode": "31557782"
  },
  "01030": {
	"card_name": "Robotic Knight",
	"attribute": "fire",
	"level": 4,
	"atk": 1600,
	"def": 1800,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "44203504"
  },
  "01031": {
	"card_name": "Gear Golem the Moving Fortress",
	"attribute": "earth",
	"level": 4,
	"atk": 800,
	"def": 2200,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "change_position"
	],
	"passcode": "30190809"
  },
  "01032": {
	"card_name": "Boot-Up Soldier - Dread Dynamo",
	"attribute": "earth",
	"level": 4,
	"atk": 0,
	"def": 2000,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  1000
	],
	"passcode": "13316346"
  },
  "01033": {
	"card_name": "Jumbo Drill",
	"attribute": "earth",
	"level": 4,
	"atk": 1800,
	"def": 100,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "change_position"
	],
	"passcode": "42851643"
  },
  "01034": {
	"card_name": "Ancient Gear Box",
	"attribute": "earth",
	"level": 4,
	"atk": 500,
	"def": 2000,
	"type": "machine",
	"count_as": "gear",
	"effect": [],
	"passcode": "60953949"
  },
  "01035": {
	"card_name": "Ancient Gear Cannon",
	"attribute": "earth",
	"level": 2,
	"atk": 500,
	"def": 500,
	"type": "machine",
	"count_as": "gear",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "80045583"
  },
  "01036": {
	"card_name": "Geargiauger",
	"attribute": "earth",
	"level": 4,
	"atk": 500,
	"def": 500,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "47687766"
  },
  "01037": {
	"card_name": "Minefieldriller",
	"attribute": "earth",
	"level": 4,
	"atk": 1500,
	"def": 1500,
	"type": "machine",
	"count_as": null,
	"effect": [],
	"passcode": "24419823"
  },
  "01038": {
	"card_name": "Mecha Bunny",
	"attribute": "earth",
	"level": 2,
	"atk": 800,
	"def": 100,
	"type": "machine",
	"count_as": null,
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "10110717"
  },
  "01039": {
	"card_name": "Mighty Guard",
	"attribute": "earth",
	"level": 4,
	"atk": 500,
	"def": 1200,
	"type": "machine",
	"count_as": "warrior",
	"effect": [],
	"passcode": "62327910"
  },
  "01040": {
	"card_name": "Five-Headed Dragon",
	"attribute": "dark",
	"level": 12,
	"atk": 5000,
	"def": 5000,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_defend",
	  "cant_die",
	  "light"
	],
	"passcode": "99267150"
  },
  "01041": {
	"card_name": "Darkness Neosphere",
	"attribute": "dark",
	"level": 10,
	"atk": 4000,
	"def": 4000,
	"type": "fiend",
	"count_as": null,
	"effect": [
	  "on_defend",
	  "cant_die",
	  "light"
	],
	"passcode": "60417395"
  },
  "01042": {
	"card_name": "Gate Guardian",
	"attribute": "dark",
	"level": 11,
	"atk": 3750,
	"def": 3400,
	"type": "warrior",
	"count_as": null,
	"effect": [],
	"passcode": "25833572"
  },
  "01043": {
	"card_name": "Zera the Mant",
	"attribute": "dark",
	"level": 8,
	"atk": 2800,
	"def": 2300,
	"type": "fiend",
	"count_as": null,
	"effect": [],
	"passcode": "69123138"
  },
  "01044": {
	"card_name": "Zera Ritual",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "ritual",
	"count_as": null,
	"effect": [
	  "ritual",
	  1043
	],
	"passcode": "81756897"
  },
  "01045": {
	"card_name": "Sanga of the Thunder",
	"attribute": "light",
	"level": 7,
	"atk": 2600,
	"def": 2200,
	"type": "thunder",
	"count_as": "spellcaster",
	"effect": [
	  "on_defend",
	  "debuff",
	  500
	],
	"passcode": "25955164"
  },
  "01046": {
	"card_name": "Suijin",
	"attribute": "water",
	"level": 7,
	"atk": 2500,
	"def": 2400,
	"type": "aqua",
	"count_as": "spellcaster",
	"effect": [
	  "on_defend",
	  "debuff",
	  500
	],
	"passcode": "98434877"
  },
  "01047": {
	"card_name": "Kazejin",
	"attribute": "wind",
	"level": 7,
	"atk": 2400,
	"def": 2200,
	"type": "spellcaster",
	"count_as": "winged beast",
	"effect": [
	  "on_defend",
	  "debuff",
	  500
	],
	"passcode": "62340868"
  },
  "01048": {
	"card_name": "Tri-Horned Dragon",
	"attribute": "dark",
	"level": 8,
	"atk": 2850,
	"def": 2350,
	"type": "dragon",
	"count_as": null,
	"effect": [],
	"passcode": "39111158"
  },
  "01049": {
	"card_name": "Skull Knight",
	"attribute": "dark",
	"level": 7,
	"atk": 2650,
	"def": 2250,
	"type": "spellcaster",
	"count_as": "warrior",
	"effect": [],
	"passcode": "02504891"
  },
  "01050": {
	"card_name": "Darkness Destroyer",
	"attribute": "dark",
	"level": 7,
	"atk": 2300,
	"def": 1800,
	"type": "fiend",
	"count_as": null,
	"effect": [
	  "on_attack",
	  "piercing"
	],
	"passcode": "93709215"
  },
  "01051": {
	"card_name": "Dragon Master Knight",
	"attribute": "light",
	"level": 12,
	"atk": 5000,
	"def": 5000,
	"type": "dragon",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  500
	],
	"passcode": "62873545"
  },
  "01052": {
	"card_name": "Gren Maju Da Eiza",
	"attribute": "fire",
	"level": 3,
	"atk": 0,
	"def": 0,
	"type": "fiend",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "graveyard_power_up",
	  400
	],
	"passcode": "36584821"
  },
  "01053": {
	"card_name": "Buster Blader, the Dragon Destroyer Swordsman",
	"attribute": "light",
	"level": 8,
	"atk": 2800,
	"def": 500,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "self_power_up",
	  "buster_blader"
	],
	"passcode": "86240887"
  },
  "01054": {
	"card_name": "Elemental HERO Shining Neos Wingman",
	"attribute": "light",
	"level": 8,
	"atk": 3100,
	"def": 2500,
	"type": "warrior",
	"count_as": null,
	"effect": [
	  "on_summon",
	  "graveyard_power_up",
	  300
	],
	"passcode": "56733747"
  },
  "01055": {
	"card_name": "Vampire Baby",
	"attribute": "dark",
	"level": 3,
	"atk": 700,
	"def": 1000,
	"type": "zombie",
	"count_as": "vampire",
	"effect": [],
	"passcode": "56387350"
  },
  "01056": {
	"card_name": "Vampire Retainer",
	"attribute": "dark",
	"level": 2,
	"atk": 1200,
	"def": 0,
	"type": "zombie",
	"count_as": "vampire",
	"effect": [],
	"passcode": "70645913"
  },
  "01057": {
	"card_name": "Vampire Dragon",
	"attribute": "dark",
	"level": 5,
	"atk": 2400,
	"def": 0,
	"type": "zombie",
	"count_as": "vampire",
	"effect": [],
	"passcode": "36352429"
  },
  "01058": {
	"card_name": "Vampire Lady",
	"attribute": "dark",
	"level": 4,
	"atk": 1550,
	"def": 1550,
	"type": "zombie",
	"count_as": "vampire",
	"effect": [
	  "on_attack",
	  "mill",
	  1
	],
	"passcode": "26495087"
  },
  "01059": {
	"card_name": "Vampire Genesis",
	"attribute": "dark",
	"level": 8,
	"atk": 3000,
	"def": 2100,
	"type": "zombie",
	"count_as": "vampire",
	"effect": [
	  "on_summon",
	  "count_as_power_up",
	  300
	],
	"passcode": "22056710"
  },
  "01060": {
	"card_name": "Vampire Sorcerer",
	"attribute": "dark",
	"level": 4,
	"atk": 1500,
	"def": 1500,
	"type": "zombie",
	"count_as": "vampire",
	"effect": [],
	"passcode": "88728507"
  },
  "01061": {
	"card_name": "Vampire Vamp",
	"attribute": "dark",
	"level": 7,
	"atk": 2000,
	"def": 2000,
	"type": "zombie",
	"count_as": "vampire",
	"effect": [
	  "on_summon",
	  "copy_atk"
	],
	"passcode": "82962242"
  },
  "01062": {
	"card_name": "Lady Ninja Yae",
	"attribute": "wind",
	"level": 3,
	"atk": 1100,
	"def": 200,
	"type": "warrior",
	"count_as": "ninja",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "82005435"
  },
  "01063": {
	"card_name": "Masked Ninja Ebisu",
	"attribute": "wind",
	"level": 4,
	"atk": 1200,
	"def": 1800,
	"type": "warrior",
	"count_as": "ninja",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "22512406"
  },
  "01064": {
	"card_name": "Kunoichi",
	"attribute": "wind",
	"level": 4,
	"atk": 1800,
	"def": 1000,
	"type": "warrior",
	"count_as": "ninja",
	"effect": [
	  "on_attack",
	  "mill",
	  1
	],
	"passcode": "56514812"
  },
  "01065": {
	"card_name": "Nin-Ken Dog",
	"attribute": "wind",
	"level": 4,
	"atk": 1800,
	"def": 1000,
	"type": "beast-warrior",
	"count_as": "ninja",
	"effect": [],
	"passcode": "11987744"
  },
  "01066": {
	"card_name": "Crimson Ninja",
	"attribute": "earth",
	"level": 1,
	"atk": 300,
	"def": 300,
	"type": "warrior",
	"count_as": "ninja",
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_enemy_spelltrap"
	],
	"passcode": "14618326"
  },
  "01067": {
	"card_name": "Red Dragon Ninja",
	"attribute": "fire",
	"level": 6,
	"atk": 2400,
	"def": 1200,
	"type": "winged beast",
	"count_as": "ninja",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "58165765"
  },
  "01068": {
	"card_name": "White Ninja",
	"attribute": "light",
	"level": 4,
	"atk": 1500,
	"def": 800,
	"type": "warrior",
	"count_as": "ninja",
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_monster"
	],
	"passcode": "01571945"
  },
  "01069": {
	"card_name": "White Dragon Ninja",
	"attribute": "light",
	"level": 7,
	"atk": 2700,
	"def": 1200,
	"type": "dragon",
	"count_as": "ninja",
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "99212922"
  },
  "01070": {
	"card_name": "Yellow Ninja",
	"attribute": "wind",
	"level": 4,
	"atk": 1900,
	"def": 1800,
	"type": "warrior",
	"count_as": "ninja",
	"effect": [
	  "on_flip",
	  "destroy_card",
	  "random_enemy_spelltrap"
	],
	"passcode": "64749612"
  },
  "01071": {
	"card_name": "Yellow Dragon Ninja",
	"attribute": "wind",
	"level": 8,
	"atk": 3000,
	"def": 1500,
	"type": "dinosaur",
	"count_as": "ninja",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "90247311"
  },
  "01072": {
	"card_name": "Senior Silver Ninja",
	"attribute": "earth",
	"level": 6,
	"atk": 2300,
	"def": 2200,
	"type": "warrior",
	"count_as": "ninja",
	"effect": [],
	"passcode": "87483942"
  },
  "01073": {
	"card_name": "War Ninja Meisen",
	"attribute": "dark",
	"level": 6,
	"atk": 2500,
	"def": 1500,
	"type": "warrior",
	"count_as": "ninja",
	"effect": [
	  "on_attack",
	  "can_direct"
	],
	"passcode": "11825276"
  },
  "01074": {
	"card_name": "Cyber Harpie Lady",
	"attribute": "wind",
	"level": 4,
	"atk": 1800,
	"def": 1300,
	"type": "winged beast",
	"count_as": "harpie",
	"effect": [],
	"passcode": "80316585"
  },
  "01075": {
	"card_name": "Harpie Girl",
	"attribute": "wind",
	"level": 2,
	"atk": 500,
	"def": 500,
	"type": "winged beast",
	"count_as": "harpie",
	"effect": [],
	"passcode": "34100324"
  },
  "01076": {
	"card_name": "Harpie Lady 1",
	"attribute": "wind",
	"level": 4,
	"atk": 1300,
	"def": 1400,
	"type": "winged beast",
	"count_as": "harpie",
	"effect": [
	  "on_summon",
	  "attribute_booster"
	],
	"passcode": "91932350"
  },
  "01077": {
	"card_name": "Harpie Lady 2",
	"attribute": "wind",
	"level": 4,
	"atk": 1300,
	"def": 1400,
	"type": "winged beast",
	"count_as": "harpie",
	"effect": [
	  "on_attack",
	  "anti_flip"
	],
	"passcode": "27927359"
  },
  "01078": {
	"card_name": "Harpie Lady 3",
	"attribute": "wind",
	"level": 4,
	"atk": 1300,
	"def": 1400,
	"type": "winged beast",
	"count_as": "harpie",
	"effect": [
	  "on_defend",
	  "no_damage"
	],
	"passcode": "54415063"
  },
  "01079": {
	"card_name": "Harpie Lady Sisters",
	"attribute": "wind",
	"level": 6,
	"atk": 1950,
	"def": 2100,
	"type": "winged beast",
	"count_as": "harpie",
	"effect": [],
	"passcode": "12206212"
  },
  "01080": {
	"card_name": "Harpie's Pet Baby Dragon",
	"attribute": "wind",
	"level": 4,
	"atk": 1200,
	"def": 600,
	"type": "dragon",
	"count_as": "harpie",
	"effect": [
	  "on_summon",
	  "count_as_power_up",
	  200
	],
	"passcode": "06924874"
  },
  "01081": {
	"card_name": "Harpie's Pet Dragon",
	"attribute": "wind",
	"level": 7,
	"atk": 2000,
	"def": 2500,
	"type": "dragon",
	"count_as": "harpie",
	"effect": [
	  "on_summon",
	  "count_as_power_up",
	  300
	],
	"passcode": "52040216"
  },
  "01082": {
	"card_name": "Swift Birdman Joe",
	"attribute": "wind",
	"level": 6,
	"atk": 2300,
	"def": 1400,
	"type": "winged beast",
	"count_as": "harpie",
	"effect": [
	  "on_summon",
	  "destroy_card",
	  "random_spelltrap"
	],
	"passcode": "81896370"
  },
  "01083": {
	"card_name": "Cyber Shield",
	"attribute": "spell",
	"level": null,
	"atk": null,
	"def": null,
	"type": "equip",
	"count_as": null,
	"effect": [
	  "atk_up",
	  500,
	  "harpie"
	],
	"passcode": "63224564"
  }
}
