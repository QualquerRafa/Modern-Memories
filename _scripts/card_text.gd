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
						"change_position", "ehero_core", "no_damage", "return_damage": #looks for it's own identifier in the language list
							line1 = GameLanguage.on_defend_first[PlayerData.game_language] + GameLanguage[card_on_CardList.effect[1]][PlayerData.game_language]
						"cant_die":
							line1 = GameLanguage.on_defend_first[PlayerData.game_language] + GameLanguage.cant_die.basic[PlayerData.game_language] + "."
							if card_on_CardList.effect.size() > 2:
								line1 = GameLanguage.on_defend_first[PlayerData.game_language] + GameLanguage.cant_die.basic[PlayerData.game_language] + GameLanguage.cant_die.extra[PlayerData.game_language] + GameLanguage.attributes[card_on_CardList.effect[2]][PlayerData.game_language] + GameLanguage.cant_die.final[PlayerData.game_language]
						"debuff":
							var debuff_value = String(card_on_CardList.effect[2])
							line1 = GameLanguage.on_defend_first[PlayerData.game_language] + GameLanguage.debuff[PlayerData.game_language] + debuff_value + " " + GameLanguage.system.points[PlayerData.game_language] + "."
				
				#EFFECTS TRIGGERED WHEN THE MONSTER IS FLIPPED
				"on_flip":
					match card_on_CardList.effect[1]:
						"jigen_bakudan", "slate_warrior":#looks for it's own identifier in the language list
							line1 = GameLanguage.on_flip_first[PlayerData.game_language] + GameLanguage[card_on_CardList.effect[1]][PlayerData.game_language]
						"destroy_card":
							#Varies by type of target
							match card_on_CardList.effect[2]:
								"all_enemy_monsters", "both_sides_monsters", "level4_enemy_monsters", "random_monster", "random_spelltrap":
									line1 = GameLanguage.on_flip_first[PlayerData.game_language] + GameLanguage.monster_destroy_effects[card_on_CardList.effect[2]][PlayerData.game_language]
						"lifepoint_up":
							var lifepoint_value = String(card_on_CardList.effect[2])
							line1 = GameLanguage.on_flip_first[PlayerData.game_language] + GameLanguage.lifepoint_change.lifepoint_up[PlayerData.game_language] + lifepoint_value + GameLanguage.lifepoint_change.final[PlayerData.game_language]
						"mill":
							var milled_cards = String(card_on_CardList.effect[2])
							if int(milled_cards) <= 1:
								line1 = GameLanguage.on_flip_first[PlayerData.game_language] + GameLanguage.mill[PlayerData.game_language] + milled_cards + " " + GameLanguage.system.card[PlayerData.game_language] + "."
							else:
								line1 = GameLanguage.on_flip_first[PlayerData.game_language] + GameLanguage.mill[PlayerData.game_language] + milled_cards + " " + GameLanguage.system.cards[PlayerData.game_language] + "."
				
				#EFFECTS TRIGGERED WHEN THE MONSTER IS SUMMONED
				"on_summon":
					match card_on_CardList.effect[1]:
						"air_neos", "castle_power_up", "copy_atk", "cyber_stein", "equip_boost", "flip_enemy_down", "gandora", "stop_defense", "summon_pharaoh", "super_robo", "white_horned", "wicked_avatar", "wicked_dreadroot", "wicked_eraser": #looks for it's own identifier in the language list
							line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage[card_on_CardList.effect[1]][PlayerData.game_language]
						"attribute_booster":
							var monster_attribute = card_on_CardList.attribute
							var negative_attribute = "?"
							match monster_attribute:
								"dark": negative_attribute = "light"
								"light": negative_attribute = "dark"
								"water": negative_attribute = "fire"
								"fire": negative_attribute = "water"
								"earth": negative_attribute = "wind"
								"wind": negative_attribute = "earth"
							line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.attribute_booster.part1[PlayerData.game_language] + GameLanguage.attributes[monster_attribute][PlayerData.game_language] + GameLanguage.attribute_booster.part2[PlayerData.game_language] + GameLanguage.attributes[negative_attribute][PlayerData.game_language] + GameLanguage.attribute_booster.part3[PlayerData.game_language]
						"attribute_reptile":
							var monster_attribute = card_on_CardList.attribute
							line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.attribute_reptile[PlayerData.game_language] + GameLanguage.attributes[monster_attribute][PlayerData.game_language] + "."
						"count_as_power_up":
							var count_as_type = card_on_CardList.count_as
							var value = String(card_on_CardList.effect[2])
							line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.count_as_power_up.part1[PlayerData.game_language] + value + GameLanguage.count_as_power_up.part2[PlayerData.game_language] + GameLanguage.types[count_as_type][PlayerData.game_language] + GameLanguage.count_as_power_up.part3[PlayerData.game_language]
						"damage_monster_count", "lifeup_monster_count":
							var value = String(card_on_CardList.effect[2])
							line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage[card_on_CardList.effect[1]].part1[PlayerData.game_language] + value + GameLanguage[card_on_CardList.effect[1]].part2[PlayerData.game_language]
						"deck_for_stat":
							var ATK_or_DEF = card_on_CardList.effect[2].to_upper()
							line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.deck_for_stat.part1[PlayerData.game_language] + ATK_or_DEF + GameLanguage.deck_for_stat.part2[PlayerData.game_language]
						"destroy_card":
							#Varies by type of target
							match card_on_CardList.effect[2]:
								"all_enemy_monsters", "atk_highest", "random_monster", "random_spelltrap":
									line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.monster_destroy_effects[card_on_CardList.effect[2]][PlayerData.game_language]
								_: #Monster Types
									var monster_type = card_on_CardList.effect[2]
									line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.specific_type_destroy.part1[PlayerData.game_language] + GameLanguage.types[monster_type][PlayerData.game_language] + GameLanguage.specific_type_destroy.part2[PlayerData.game_language]
						"friends_power_up":
							var value = String(card_on_CardList.effect[2])
							var monster_type = card_on_CardList.type
							line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.friends_power_up.part1[PlayerData.game_language] + GameLanguage.types[monster_type][PlayerData.game_language] + GameLanguage.friends_power_up.part2[PlayerData.game_language] + value + " " + GameLanguage.system.points[PlayerData.game_language] + "."
						"graveyard_power_up":
							var value = String(card_on_CardList.effect[2])
							line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.graveyard_power_up.part1[PlayerData.game_language] + value + GameLanguage.graveyard_power_up.part2[PlayerData.game_language]
						"honest":
							var honest_attribute = card_on_CardList.attribute
							line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.honest.part1[PlayerData.game_language] + GameLanguage.attributes[honest_attribute][PlayerData.game_language] + GameLanguage.honest.part2[PlayerData.game_language]
						"jinzo":
							var jinzo_damage_value = card_on_CardList.effect[2]
							if jinzo_damage_value == 0:
								line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.jinzo.part1[PlayerData.game_language] + "."
							else:
								line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.jinzo.part1[PlayerData.game_language] + GameLanguage.jinzo.part2[PlayerData.game_language] + String(jinzo_damage_value) + GameLanguage.jinzo.part3[PlayerData.game_language]
						"lifepoint_up":
							var lifepoint_value = String(card_on_CardList.effect[2])
							line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.lifepoint_change.lifepoint_up[PlayerData.game_language] + lifepoint_value + GameLanguage.lifepoint_change.final[PlayerData.game_language]
						"mill":
							var milled_cards = String(card_on_CardList.effect[2])
							if int(milled_cards) <= 1:
								line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.mill[PlayerData.game_language] + milled_cards + " " + GameLanguage.system.card[PlayerData.game_language] + "."
							else:
								line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.mill[PlayerData.game_language] + milled_cards + " " + GameLanguage.system.cards[PlayerData.game_language] + "."
						"monster_change_field":
							var monster_attribute = card_on_CardList.attribute
							line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.monster_change_field[PlayerData.game_language] + GameLanguage.attributes[monster_attribute][PlayerData.game_language]
						"monster_count_boost":
							var boost_value = String(card_on_CardList.effect[2])
							line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.monster_count_boost.part1[PlayerData.game_language] + boost_value + GameLanguage.monster_count_boost.part2[PlayerData.game_language]
						"self_power_up":
							var boost_value = card_on_CardList.effect[2]
							match boost_value:
								"buster_blader", "random_dice", "same_attribute", "spelltrap_count":
									line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.self_power_up.part1[PlayerData.game_language] + GameLanguage.self_power_up[boost_value][PlayerData.game_language]
								_: #just a numerical value
									line1 = GameLanguage.on_summon_first[PlayerData.game_language] + GameLanguage.self_power_up.part1[PlayerData.game_language] + String(boost_value) + GameLanguage.self_power_up.part2[PlayerData.game_language]
	
	#Compose the final String to be returned
	if line1 != null:
		full_card_text = line1
	if line2 != null:
		full_card_text += "\n" + line2
	
	return full_card_text
