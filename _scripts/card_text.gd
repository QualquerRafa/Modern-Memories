extends Node

#[key] can fuse with [values]
var fusion_friends = {
			"aqua"  : ["dinosaur", "dragon", "fish", "pyro", "reptile", "sea serpent", "thunder", "winged beast"],
			"beast-warrior" : ["fairy", "fiend", "machine", "reptile", "winged beast"],
			"beast" : ["fish", "machine", "plant", "psychic", "pyro", "reptile", "thunder", "warrior", "winged beast"],
			"dinosaur" : ["aqua", "fiend", "machine", "sea serpent", "rock"],
			"dragon" : ["aqua", "fairy", "fiend", "machine", "plant", "pyro", "rock", "sea serpent", "thunder", "warrior", "zombie"],
			"fairy" : ["beast-warrior", "dragon", "insect", "plant", "spellcaster", "warrior", "winged beast"],
			"fiend" : ["beast-warrior", "dinosaur", "dragon", "machine", "reptile", "spellcaster", "warrior", "winged beast"],
			"fish" : ["aqua", "beast", "insect", "machine", "warrior", "zombie"],
			"insect" : ["fairy", "fish", "machine", "pyro", "rock", "warrior"],
			"machine" : ["beast-warrior", "beast", "dinosaur", "dragon", "fiend", "fish", "insect", "psychic", "spellcaster", "thunder", "warrior"],
			"plant" : ["beast", "dragon", "fairy", "warrior", "zombie"],
			"psychic" : ["beast", "machine", "psychic", "spellcaster", "thunder", "warrior"],
			"pyro" : ["aqua", "beast", "dragon", "insect", "warrior", "winged beast", "zombie"],
			"reptile" : ["aqua", "beast-warrior", "beast", "fiend", "warrior",],
			"rock" : ["dinosaur", "dragon", "insect", "warrior", "zombie"],
			"sea serpent" : ["aqua", "dinosaur", "dragon", "winged beast"],
			"spellcaster" : ["fairy", "fiend", "machine", "psychic", "thunder", "zombie"],
			"thunder" : ["aqua", "beast", "dragon", "machine", "psychic", "spellcaster", "zombie"],
			"warrior" : ["beast", "dragon", "fairy", "fiend", "fish", "insect", "machine", "plant", "psychic", "pyro", "reptile", "rock", "zombie"],
			"winged beast": ["aqua", "beast-warrior", "beast", "fairy", "fiend", "pyro", "sea serpent"],
			"zombie" : ["dragon", "fish", "plant", "pyro", "rock", "spellcaster", "thunder", "warrior"],
		}

var types_reference = ["aqua", "beast-warrior", "beast", "dinosaur", "dragon", "fairy", "fiend", "fish", "insect", "machine", "plant", "psychic", "pyro", "reptile", "rock", "sea serpent", "spellcaster", "thunder", "warrior", "winged beast", "zombie"]
var attribute_reference = ["dark", "divine", "earth", "fire", "light", "water", "wind"]

func get_card_text(card_id : String):
	#Initialize the variable to be return at the end. By default, it displays an error message that should be properply substituted
	var full_card_text : String = GameLanguage.description_error[PlayerData.game_language]
	var card_on_CardList = CardList.card_list[card_id]
	var line1 : String
	var line2 : String
	
	#Compose the line2 if it will exist. 'This card can count as [count_as_type] for some Fusions.'
	if card_on_CardList.count_as != null:
		var correct_language_count_as_type = GameLanguage.types[card_on_CardList.count_as][PlayerData.game_language]
		line2 = GameLanguage.count_as_part1[PlayerData.game_language] + correct_language_count_as_type + GameLanguage.count_as_part2[PlayerData.game_language]
	
	#WITHOUT EFFECT: [card_type] can fuse with [fusion_friends]
	if card_on_CardList.effect.size() == 0:
		var correct_language_monster_type = GameLanguage.types[card_on_CardList.type][PlayerData.game_language]
		var correct_language_fusion_friends = ""
		for friendly_type in fusion_friends[card_on_CardList.type]:
			correct_language_fusion_friends += GameLanguage.types[friendly_type][PlayerData.game_language] + ", "
		
		line1 = correct_language_monster_type + GameLanguage.type_can_fuse_with[PlayerData.game_language] + correct_language_fusion_friends.trim_suffix(", ") + "."
		
	#WITH EFFECT: The description will be base on what kind of effect the card has
	elif card_on_CardList.effect.size() > 0:
		#EQUIP SPELLS
		if card_on_CardList.type == "equip":
			var type_or_attribute = "types"
			if card_on_CardList.effect[2] in attribute_reference:
				type_or_attribute = "attributes"
			var target_keyword_of_equip = GameLanguage[type_or_attribute][card_on_CardList.effect[2]][PlayerData.game_language]
			
			match card_on_CardList.effect[0]:
				"atk_up":
					line1 = GameLanguage.equip_spell_atk.part1[PlayerData.game_language] + target_keyword_of_equip + GameLanguage.equip_spell_atk.part2[PlayerData.game_language] + String(card_on_CardList.effect[1]) + " " + GameLanguage.system.points[PlayerData.game_language] + "."
				"stats_up":
					#Check for the 'special_case' for 'Mage Power' Equip Spell
					if card_on_CardList.effect[2] == "special_case":
						line1 = GameLanguage.equip_mage_power_special_case.part1[PlayerData.game_language] + String(card_on_CardList.effect[1]) + GameLanguage.equip_mage_power_special_case.part2[PlayerData.game_language]
					else:
						line1 = GameLanguage.equip_spell_stats.part1[PlayerData.game_language] + target_keyword_of_equip + GameLanguage.equip_spell_stats.part2[PlayerData.game_language] + String(card_on_CardList.effect[1]) + " " + GameLanguage.system.points[PlayerData.game_language] + "."
			
		#FIELD SPELLS
		elif card_on_CardList.type == "field":
			line1 = GameLanguage.field_spell.part1[PlayerData.game_language] + GameLanguage.attributes[card_on_CardList.effect[0]][PlayerData.game_language] + GameLanguage.field_spell.part2[PlayerData.game_language] 
			
		#RITUAL SPELLS
		elif card_on_CardList.type == "ritual":
			var ritual_type = CardList.card_list[String(card_on_CardList.effect[1]).pad_zeros(5)].type
			var ritual_name = CardList.card_list[String(card_on_CardList.effect[1]).pad_zeros(5)].card_name
			line1 = GameLanguage.ritual_spell.part1[PlayerData.game_language] + GameLanguage.types[ritual_type][PlayerData.game_language] + GameLanguage.ritual_spell.part2[PlayerData.game_language] + ritual_name + GameLanguage.ritual_spell.part3[PlayerData.game_language]
			
		#ANY OTHER TYPE OF SPELL CARD
		elif card_on_CardList.type == "spell":
			match card_on_CardList.effect[0]:
				"destroy_card":
					#Varies by type of target
					match card_on_CardList.effect[1]:
						"enemy_monsters", "enemy_spelltraps":
							line1 = GameLanguage.spells_destroy_card.all_enemy1[PlayerData.game_language] + GameLanguage.spells_destroy_card[card_on_CardList.effect[1]][PlayerData.game_language] + GameLanguage.spells_destroy_card.all_enemy2[PlayerData.game_language]
						"fusion", "ritual":
							line1 = GameLanguage.spells_destroy_card.targets_fusion_type1[PlayerData.game_language] + GameLanguage.spells_destroy_card[card_on_CardList.effect[1]][PlayerData.game_language] + GameLanguage.spells_destroy_card.targets_fusion_type2[PlayerData.game_language]
						_: #Targets specific Monster Types
							line1 = GameLanguage.spells_destroy_card.type_specific_raigeki1[PlayerData.game_language] + GameLanguage.types[card_on_CardList.effect[1]][PlayerData.game_language] + GameLanguage.spells_destroy_card.type_specific_raigeki2[PlayerData.game_language]
						
				"special_description", "sword_shield", "power_bond", "change_of_heart": #looks for it's own identifier in the language list
					line1 = GameLanguage[card_on_CardList.effect[0]][PlayerData.game_language]
				"block_attack", "stop_defense":
					line1 = GameLanguage.change_monster_position[card_on_CardList.effect[0]][PlayerData.game_language]
				"atk_up", "atk_down":
					line1 = GameLanguage.dice_power_change[card_on_CardList.effect[0]][PlayerData.game_language]
				"tokens":
					var token_quantity = card_on_CardList.effect[1]
					line1 = GameLanguage.tokens.part1[PlayerData.game_language] + String(token_quantity) + GameLanguage.tokens.part2[PlayerData.game_language]
				"tokens_for_life", "tokens_for_damage":
					line1 = GameLanguage.tokens_life_change[card_on_CardList.effect[0]][PlayerData.game_language]
			
		#TRAP CARDS
		elif card_on_CardList.type == "trap":
			match card_on_CardList.effect[0]:
				#Battle interrupters
				"negate_attacker", "mirror_force", "magic_cylinder", "ring_of_destruction", "copy_as_token", "transform_in_token", "fire_darts", "enchanted_javelin": #looks for it's own identifier in the language list
					line1 = GameLanguage[card_on_CardList.effect[0]][PlayerData.game_language]
				#Non-battle interrupters
				"fortify_tokens", "waboku", "gift_of_elf", "reveal_face_down": #looks for it's own identifier in the language list + extra info about not interrupting battle
					line1 = GameLanguage[card_on_CardList.effect[0]][PlayerData.game_language] + GameLanguage.trap_non_interrupt_extra_text[PlayerData.game_language]
				#Effects that have variants
				"destroy_attacker":
					line1 = GameLanguage.destroy_attacker.basic_destroy[PlayerData.game_language] + "."
					if card_on_CardList.effect[1] != 9999:
						line1 = GameLanguage.destroy_attacker.basic_destroy[PlayerData.game_language] + GameLanguage.destroy_attacker.points_limit[PlayerData.game_language] + String(card_on_CardList.effect[1]) + " " + GameLanguage.system.points[PlayerData.game_language] + "."
				"battle_trap":
					var ATK_or_DEF = "ATK"
					if card_on_CardList.card_name == "Castle Walls":
						ATK_or_DEF = "DEF"
					line1 = GameLanguage.battle_trap.part1[PlayerData.game_language] + ATK_or_DEF + GameLanguage.battle_trap.part2[PlayerData.game_language] + GameLanguage.trap_non_interrupt_extra_text[PlayerData.game_language]
			
		#Anything else will be a Monster Effect
		else:
			match card_on_CardList.effect[0]:
				"special_description", "token_monster": #looks for it's own identifier in the language list
					line1 = GameLanguage[card_on_CardList.effect[0]][PlayerData.game_language]
				
				#EFFECTS TRIGGERED WHEN THE MONSTER ATTACKS
				"on_attack":
					match card_on_CardList.effect[1]:
						"anti_flip", "ignore_spelltrap", "piercing", "multiple_attacker", "can_direct", "toon", "change_position", "mutual_banish", "injection_fairy", "rocket_warrior":
							line1 = GameLanguage.on_attack_first[PlayerData.game_language] + GameLanguage[card_on_CardList.effect[1]][PlayerData.game_language]
						"burn":
							if typeof(card_on_CardList.effect[2]) == TYPE_STRING:
								line1 = GameLanguage.on_attack_first[PlayerData.game_language] + GameLanguage.burn.part1[PlayerData.game_language] + GameLanguage.burn.monster_atk_dmg[PlayerData.game_language]
							else:
								var burn_damage = String(card_on_CardList.effect[2])
								line1 = GameLanguage.on_attack_first[PlayerData.game_language] + GameLanguage.burn.part1[PlayerData.game_language] + burn_damage + " " + GameLanguage.system.points[PlayerData.game_language] + "."
						"lifepoint_cost", "lifepoint_up":
							var lifepoint_change_value = String(card_on_CardList.effect[2])
							line1 = GameLanguage.on_attack_first[PlayerData.game_language] + GameLanguage.lifepoint_change[card_on_CardList.effect[1]][PlayerData.game_language] + lifepoint_change_value + GameLanguage.lifepoint_change.final[PlayerData.game_language]
						"get_power":
							var power_gain = String(card_on_CardList.effect[2])
							line1 = GameLanguage.on_attack_first[PlayerData.game_language] + GameLanguage[card_on_CardList.effect[1]][PlayerData.game_language] + power_gain + " " + GameLanguage.system.points[PlayerData.game_language] + "."
						"mill":
							var milled_cards = String(card_on_CardList.effect[2])
							if int(milled_cards) <= 1:
								line1 = GameLanguage.on_attack_first[PlayerData.game_language] + GameLanguage.mill[PlayerData.game_language] + milled_cards + " " + GameLanguage.system.card[PlayerData.game_language] + "."
							else:
								line1 = GameLanguage.on_attack_first[PlayerData.game_language] + GameLanguage.mill[PlayerData.game_language] + milled_cards + " " + GameLanguage.system.cards[PlayerData.game_language] + "."
				
				#EFFECTS TRIGGERED WHEN THE MONSTER IS ATTACKED
				"on_defend":
					match card_on_CardList.effect[1]:
						"cant_die": pass
						"change_position": pass
						"debuff": pass
						"ehero_core": pass
						"no_damage": pass
						"return_damage": pass
				
				#EFFECTS TRIGGERED WHEN THE MONSTER IS FLIPPED
				"on_flip":
					match card_on_CardList.effect[1]:
						"destroy_card": pass
						"jigen_bakudan": pass
						"lifepoint_up": pass
						"mill": pass
						"slate_warrior": pass
				
				#EFFECTS TRIGGERED WHEN THE MONSTER IS SUMMONED
				"on_summon":
					match card_on_CardList.effect[1]:
						"air_neos": pass
						"attribute_booster": pass
						"attribute_reptile": pass
						"castle_power_up": pass
						"copy_atk": pass
						"count_as_power_up": pass
						"cyber_stein": pass
						"damage_monster_count": pass
						"deck_for_stat": pass
						"destroy_card": pass
						"equip_boost": pass
						"flip_enemy_down": pass
						"friends_power_up": pass
						"gandora": pass
						"graveyard_power_up": pass
						"honest": pass
						"jinzo": pass
						"lifepoint_up": pass
						"lifeup_monster_count": pass
						"mill": pass
						"monster_change_field": pass
						"monster_count_boost": pass
						"self_power_up": pass
						"stop_defense": pass
						"summon_pharaoh": pass
						"super_robo": pass
						"white_horned": pass
						"wicked_avatar": pass
						"wicked_dreadroot": pass
						"wicked_eraser": pass
	
	#Compose the final String to be returned
	if line1 != null:
		full_card_text = line1
	if line2 != null:
		full_card_text += "\n" + line2
	
	return full_card_text
