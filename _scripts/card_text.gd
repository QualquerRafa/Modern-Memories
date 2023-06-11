extends Node

#[key] can fuse with [values]
var fusion_friends = {
			"aqua"  : ["dinosaur", "dragon", "fish", "pyro", "reptile", "sea serpent", "thunder", "winged beast"],
			"beast-warrior" : ["fairy", "fiend", "machine", "reptile", "winged beast"],
			"beast" : ["fish", "machine", "plant", "pyro", "reptile", "thunder", "warrior", "winged beast"],
			"dinosaur" : ["aqua", "fiend", "machine", "sea serpent", ],
			"dragon" : ["aqua", "fiend", "machine", "plant", "pyro", "rock", "sea serpent", "thunder", "warrior", "zombie"],
			"fairy" : ["beast-warrior", "insect", "plant", "spellcaster", "warrior", "winged beast"],
			"fiend" : ["beast-warrior", "dinosaur", "dragon", "machine", "reptile", "spellcaster", "warrior", "winged beast"],
			"fish" : ["aqua", "beast", "insect", "machine", "warrior", "zombie"],
			"insect" : ["fairy", "fish", "pyro", "rock", "warrior"],
			"machine" : ["beast-warrior", "beast", "dinosaur", "dragon", "fiend", "fish", "spellcaster", "thunder", "warrior"],
			"plant" : ["beast", "dragon", "fairy", "warrior", "zombie"],
			"pyro" : ["aqua", "beast", "dragon", "insect", "warrior", "winged beast", "zombie"],
			"reptile" : ["aqua", "beast-warrior", "beast", "fiend", "warrior",],
			"rock" : ["dragon", "insect", "warrior", "zombie"],
			"sea serpent" : ["aqua", "dinosaur", "dragon", "winged beast"],
			"spellcaster" : ["fairy", "fiend", "machine", "thunder", "zombie"],
			"thunder" : ["aqua", "beast", "dragon", "machine", "spellcaster", "zombie"],
			"warrior" : ["beast", "dragon", "fairy", "fiend", "fish", "insect", "machine", "plant", "pyro", "reptile", "rock", "zombie"],
			"winged beast": ["aqua", "beast-warrior", "beast", "fairy", "fiend", "pyro", "sea serpent"],
			"zombie" : ["dragon", "fish", "plant", "pyro", "rock", "spellcaster", "thunder", "warrior"],
		}

func get_card_text(card_id : String):
	var card_on_CardList = CardList.card_list[card_id]
	var line1 : String #[card-type] can fuse with [types...].
	var line2 : String #This card can count as [count-as-type] for some fusions.
	var full_card_text : String = "Card text not Defined."
	
	#For a card WITHOUT effects, show the default text about fusions it can make
	if card_on_CardList.effect.size() == 0:
		var fusion_friends_as_String = String(fusion_friends[card_on_CardList.type]).lstrip("[").rstrip("]")
		line1 = card_on_CardList.type + " can fuse with " + fusion_friends_as_String + "."
		
	#For cards WITH effects, do a whole lot of checks to compose the text
	elif card_on_CardList.effect.size() > 0:
		match card_on_CardList.type:
			"equip":
				match card_on_CardList.effect[0]:
					"atk_up":
						line1 = "Increases " + card_on_CardList.effect[2] + " monster's ATK by " + String(card_on_CardList.effect[1]) + " points."
					"stats_up":
						line1 = "Increases " + card_on_CardList.effect[2] + " monster's stats by " + String(card_on_CardList.effect[1]) + " points."
			
			"field": 
				line1 = "Increases the ATK of all " + card_on_CardList.effect[0] + " monsters on the Field by 500 points and decreases their DEF by 400 points."
			
			"ritual":
				var ritual_type = CardList.card_list[String(card_on_CardList.effect[1]).pad_zeros(5)].type
				var ritual_name = CardList.card_list[String(card_on_CardList.effect[1]).pad_zeros(5)].card_name
				line1 = "If the requirements of level and offering a " + ritual_type + " monster are met, \"" + ritual_name + "\" will be Summoned to the Field."
			
			"spell":
				match card_on_CardList.effect[0]:
					"destroy_card":
						match card_on_CardList.effect[1]:
							"enemy_monsters": #raigeki
								line1 = "Destroys all oponnent's Monster cards on the Field."
							"enemy_spelltraps": #harpie's feather
								line1 = "Destroys all oponnent's Spell and Trap cards on the Field."
							"fusion", "ritual":
								line1 = "Destroys a random opponent's " + card_on_CardList.effect[1] + " Monster on the Field."
							_: #Raigeki for specific monster types
								line1 = "Destroys all oponnent's " + card_on_CardList.effect[1] + " monsters on the Field."
					"special_description":
						line1 = "This card fused with the correct monsters will unleash their unique powers."
					"block_attack":
						line1 = "Change all of your opponent's Attack position monsters to Defense position."
					"stop_defense":
						line1 = "Change all of your opponent's Defense position monsters to Attack position."
					"sword_shield":
						line1 = "Switch the ATK and DEF of all face-up monsters on the field."
					"atk_up":
						line1 = "Roll a dice and power up all your monsters by 100 times the dice result."
					"atk_down": 
						line1 = "Roll a dice and power down all your opposing monsters by 100 times the dice result."
					"power_bond":
						line1 = "Double the ATK of your Strongest Fusion Machine monster, at the cost of the same amount of Life Points."
			
			"trap":
				match card_on_CardList.effect[0]:
					"negate_attacker":
						line1 = "Negates the attack of an opposing monster."
					"magic_cylinder":
						line1 = "Negates the attack of an opposing monster and causes Life Point damage to your opponent equal to the ATK of that monster."
					"destroy_attacker":
						line1 = "Destroys the opposing attacking monster."
						if card_on_CardList.effect[1] != 9999:
							line1 = "Destroys the opposing attacking monster if it has less than " + String(card_on_CardList.effect[1]) + " ATK points."
					"mirror_force":
						line1 = "Destroys all of the opposing Attack position monsters."
					"ring_of_destruction":
						line1 = "Destroys the opposing attacking monster and causes Life Point damage to both players equal to the ATK of said monster."
			
			_: #anything else is just a monster effect
				match card_on_CardList.effect[0]:
					"special_description":
						line1 = "This card fused with the correct monsters will unleash their unique powers."
					"on_attack": #Effects triggered when a monster is attacking
						line1 = "When this Monster attacks, "
						match card_on_CardList.effect[1]:
							#Affect regular gameplay workflow
							"piercing":
								line1 += "it inflicts Piercing Battle Damage on Defense Position monsters."
							"anti_flip": 
								line1 += "it doesn't trigger Flip Effects from face-down monsters."
							"ignore_spelltrap":
								line1 += "it doesn't trigger opponent's Spell and Trap cards."
							"can_direct": 
								line1 += "it can do Direct Damage to the opponent's Life Points."
							"toon": 
								line1 += "it can do Direct Damage to the opponent's Life Points at the cost of 500 LP."
							#Happen at the start of the combat phase
							"lifepoint_cost":
								line1 += "it costs " + String(card_on_CardList.effect[2]) + " points of your own LP."
							"lifepoint_up":
								line1 += "you gain " + String(card_on_CardList.effect[2]) + " points to your own LP."
							#Happen at the end of combat phase
							"mill":
								var mill_quantity = card_on_CardList.effect[2]
								if mill_quantity > 1:
									line1 += "the opponent loses " + String(mill_quantity) + " cards from their deck." 
								else:
									line1 += "the opponent loses 1 card from their deck."
							"burn":
								var burn_damage = String(card_on_CardList.effect[2]) + " points."
								if typeof(card_on_CardList.effect[2]) == TYPE_STRING: burn_damage = "the base ATK of the destroyed monster."
								line1 += "it causes Life Point damage to the opponent equal to " + burn_damage
							"change_position":
								line1 += "it is changed to Defense Position at the end of battle."
							"mutual_banish":
								line1 += "it destroys the opponent's monster along with itself."
							#Special cases
							"injection_fairy":
								line1 += "at the cost of 2000 points of your own LP, it gains 3000 ATK points."
							"rocket_warrior":
								line1 += "it causes the opponent's monster to lose 500 ATK."
					
					"on_defend": #Effects triggered when a monster is attacked
						line1 = "When this Monster is attacked, "
						match card_on_CardList.effect[1]:
							#Before the combat starts
							"debuff":
								line1 += "it reduces the attacker's ATK by " + String(card_on_CardList.effect[2]) + " points."
							"ehero_core":
								line1 += "it doubles it's own current ATK for this battle only."
							#Happen at the end of combat phase
							"cant_die":
								if card_on_CardList.effect.size() == 3:
									line1 += "it cannot be destroyed by battle, unless it battles a " + card_on_CardList.effect[2] + " monster."
								else:
									line1 += "it cannot be destroyed by battle."
							"no_damage":
								line1 += "it negates any kind of Battle Damage."
							"return_damage":
								line1 += "your opponent takes the same Battle Damage as you do."
							"change_position":
								line1 += "it is changed to Attack Position at the end of battle."
					
					"on_flip": #Effects triggered when a monster is flip summoned
						line1 = "When this Monster is flip summoned, "
						match card_on_CardList.effect[1]:
							#Before combat starts
							"destroy_card":
								var target_to_destroy : String = ""
								match card_on_CardList.effect[2]:
									"all_enemy_monsters": target_to_destroy = "all of your opponent's monsters"
									"level4_enemy_monsters": target_to_destroy = "all of your opponent's Level 4 monsters"
									"random_spelltrap": target_to_destroy = "a random opponent's Spell or Trap card"
									"random_monster": target_to_destroy = "a random opponent's monster"
								line1 += "it destroys " + target_to_destroy + " on the field."
							"lifepoint_up":
								line1 += "you gain " + String(card_on_CardList.effect[2]) + " points to your own Life Points."
							"mill":
								var mill_quantity = card_on_CardList.effect[2]
								if mill_quantity > 1:
									line1 += "the opponent loses " + String(mill_quantity) + " cards from their deck." 
								else:
									line1 += "the opponent loses 1 card from their deck."
							"slate_warrior":
								line1 += "it gains 500 ATK and DEF."
							"jigen_bakudan":
								line1 += "it destroys all of your monsters and deal LP damage to the opponent equal to half the sum of all ATKs."
					
					"on_summon": #Effects triggered when a monster is summoned
						line1 = "When this Monster is summoned, "
						match card_on_CardList.effect[1]:
							#Card destruction
							"attribute_reptile":
								line1 += "all non-" + card_on_CardList.attribute + " monsters on the Field are destroyed."
							"destroy_card":
								var target_to_destroy : String = ""
								match card_on_CardList.effect[2]:
									"all_enemy_monsters": target_to_destroy = "all of your opponent's monsters"
									"all_enemy_spelltraps": target_to_destroy = "all of your opponent's Spell and Trap cards"
									"atk_highest": target_to_destroy = "your opponent's Monster with the highest ATK"
									"dragon": target_to_destroy = "a random opponent's Dragon monster"
									"random_monster": target_to_destroy = "a random opponent's monster"
									"random_spelltrap": target_to_destroy = "a random opponent's Spell or Trap card"
								line1 += "it destroys " + target_to_destroy + " on the field."
							#Stats changers
							"flip_enemy_down":
								line1 += "it sets a random opponent's monster to facedown defense position."
							"self_power_up":
								match card_on_CardList.effect[2]:
									"buster_blader": line1 += "it increases it's own Stats by 500 points for each Dragon monster on the field."
									"random_dice": line1 += "it rolls a dice and increases it's own Stats by 100 times the dice result."
									"same_attribute": line1 += "it increases it's own Stats by 500 points for each " + card_on_CardList.attribute + " monster on the field."
									"spelltrap_count": line1 += "it increases it's own Stats by 400 points for each Spell and Trap card on the field."
									_: line1 += "it increases it's own Stats by " + String(card_on_CardList.effect[2]) + " points for each monster with the same Type as it on the field."
							"friends_power_up":
								line1 += "it increases the Stats of monsters on the field with the same Type as it by " + String(card_on_CardList.effect[2]) + " points."
							"attribute_booster":
								var positive_att = card_on_CardList.attribute
								var negative_att = ""
								match card_on_CardList.attribute:
									"dark": negative_att = "LIGHT"
									"light": negative_att = "DARK"
									"water": negative_att = "FIRE"
									"fire": negative_att = "WATER"
									"earth": negative_att = "WIND"
									"wind": negative_att = "EARTH"
								line1 += positive_att + " monsters on the field gain 500 ATK points, and " + negative_att + " monsters lose 400 ATK points."
							"copy_atk":
								line1 += "it copies the Stats from the strongest monster on opponent's side of the field."
							"count_as_power_up":
								line1 += "it increases it's own ATK by " + String(card_on_CardList.effect[2]) + " points for each monster in the same Archetype as it on the field."
							"deck_for_stat":
								line1 += "by removing 3 cards from the Deck, it increases it's own " + card_on_CardList.effect[2].to_upper() + " by 1500 points."
							"monster_count_boost":
								line1 += "it increases it's own ATK by " + String(card_on_CardList.effect[2]) + " points for each monster on the field."
							"graveyard_power_up":
								line1 += "it increases it's own Stats by " + String(card_on_CardList.effect[2]) + " points for each card out of your Deck."
							#Lifepoints changers
							"damage_monster_count":
								line1 += " it deals LP damage to your opponent by " + String(card_on_CardList.effect[2]) + " times the number of monsters on the field."
							"lifeup_monster_count":
								line1 += " you gain LP equal to " + String(card_on_CardList.effect[2]) + " times the number of monsters on the field."
							"lifepoint_up":
								line1 += "you gain " + String(card_on_CardList.effect[2]) + " points to your own LP."
							#Special cases
							"air_neos":
								line1 += "it increases it's own ATK by the difference between both player's Life Points."
							"cyber_stein":
								line1 += "at the cost of 5000 LP, this card transforms into the strongest Monster still in the deck."
							"gandora":
								line1 += "at the cost of half your LP, it destroys all monsters on both fields, getting 300 ATK for each card destroyed."
							"honest":
								line1 += "a random " + card_on_CardList.attribute + " monster on your side of the field gains 1000 ATK points."
							"jinzo":
								if card_on_CardList.effect[2] == 0:
									line1 += "it destroys all of opponent's Spell and Trap Cards on the field."
								else:
									line1 += "it destroys all of opponent's Spell and Trap Cards on the field and deals " + String(card_on_CardList.effect[2]) + " LP damage for each card destroyed."
							"equip_boost":
								line1 += "it increases it's own ATK by 500 points for each Equipment used on it."
							"stop_defense":
								line1 += "all of your opponent's Defense position monsters are changed to Attack position."
							"white_horned":
								line1 += "it destroys all of opponent's Spell and Trap Cards, getting 300 ATK for each card destroyed."
	
	#Define the variable to be passed ahead
	full_card_text = line1
	
	#At the end of EVERY card, if it has a 'count_as' type, add it to 'full_card_text' to be shown
	if card_on_CardList.count_as != null:
		line2 = "This card can count as " + card_on_CardList.count_as + " for some fusions."
		full_card_text = line1 + "\n" + line2
	
	return full_card_text
