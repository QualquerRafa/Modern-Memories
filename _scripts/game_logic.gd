extends Node

#Record with GAME_PHASE it is, so it does the commands in the proper moment
var GAME_PHASE : String

#These values are used to properly scale the 'card_design.tscn' when it's placed on the field
const atk_orientation_x_scale : float = 0.518
const atk_orientation_y_scale : float = 0.517
const def_orientation_y_scale : float = 0.517 #when in def position, shorten it just a little

signal battle_finished

#------------------------------------------------------------------------------
#EFFECTS LOGIC
func effect_activation(card_node : Node, type_of_activation : String):
	#pass this exactly as is to the effects script
	var effect_return = $effects.call_effect(card_node, type_of_activation)
	
	#Check for game End after effect activation (for stuff that burn damage and so)
	check_for_game_end()
	
	return effect_return 

func check_for_trap_cards(attacking_card : Node):
	#If the attacking has the ignore_spelltrap effect, return null
	if CardList.card_list[attacking_card.this_card_id].effect.size() > 1 and CardList.card_list[attacking_card.this_card_id].effect[1] == "ignore_spelltrap":
		return null
	
	#Figure out which side is attacking to check the other side for set trap cards
	var trap_side : String = "enemy"
	if attacking_card.get_parent().get_name().find("player") != 0:
		trap_side = "player"
	
	var side_to_check = get_node("../duel_field/" + trap_side + "_side_zones")
	for i in range(5):
		var card_to_check = side_to_check.get_node("spelltrap_" + String(i))
		if card_to_check.is_visible() and CardList.card_list[card_to_check.this_card_id].attribute == "trap":
			return card_to_check #Node
	
	return null

#------------------------------------------------------------------------------
#FUSION LOGIC
#const fusion_list_gd = preload("res://_scripts/fusions.gd")
onready var fusion_list = $fusions

func fusing_cards_logic(card_1 : Node, card_2 : Node):
	var card_1_id : String = card_1.this_card_id
	var card_2_id : String = card_2.this_card_id
	
	#All the kinds of fusion checks are handled there, this is just passing the ID:String ahead
	var fusion_result : Array #[ID:String, Extra Info]
	fusion_result = fusion_list.check_for_fusion(card_1_id, card_2_id)
	
	#Add to the history if it's a successfull monster fusion
	if typeof(fusion_result[1]) == TYPE_BOOL and fusion_result[1] == true:
		get_node("../side_menu").list_of_fusions_in_this_duel.append([card_1_id, card_2_id, fusion_result[0]])
	elif typeof(fusion_result[1]) == TYPE_ARRAY and fusion_result[1][1] != 0:
		var monster_involved = card_1_id
		if CardList.card_list[card_1_id].attribute in ["spell", "trap"]:
			monster_involved = card_2_id
		get_node("../side_menu").list_of_fusions_in_this_duel.append([card_1_id, card_2_id, monster_involved])
	
	return fusion_result

#------------------------------------------------------------------------------
func reset_a_card_node_properties(card_node_to_reset):
	#Reset ALL flags
	card_node_to_reset.this_card_flags = {
	"is_defense_position" : false,
	"has_field_boost" : false,
	"is_facedown" : false,
	"has_battled" : false,
	"fusion_type" : null,
	"atk_up" : 0,
	"def_up" : 0,
	"has_activated_effect" : false,
	"multiple_attacks" : 0,
	}
	
	card_node_to_reset.get_node("card_design/darken_card").hide()

func destroy_a_card(card_node_to_destroy):
	#If it's a ritual monster, check for it's on_ritual_death effects
	if card_node_to_destroy.this_card_flags.fusion_type == "ritual" and CardList.card_list[card_node_to_destroy.this_card_id].card_name in ["Five-Headed Dragon", "Arcana Knight Joker", "Valkyrion the Magna Warrior", "Lord of the Red", "Paladin of White Dragon", "Paladin of Dark Dragon", "Knight of Armor Dragon", "Chakra", "Demise, Agent of Armageddon", "Demise, King of Armageddon",
																																			"Cyber Angel Natasha", "Cyber Angel Idaten", "Cyber Angel Benten", "Cyber Angel Izana", "Cyber Angel Dakini", "Cyber Angel Vrash"]:
		$effects.ritual_effects_activation(card_node_to_destroy, "on_ritual_death")
		#yield($effects, "effect_fully_executed")
	
	#first reset the nodes properties so it's wiped clean
	reset_a_card_node_properties(card_node_to_destroy)
	
	#Force reset rotation back to attack position for cards in defense position
	if card_node_to_destroy.get_node("card_design").rect_rotation == -90 or card_node_to_destroy.get_node("card_design").rect_rotation == 90:
		card_node_to_destroy.get_node("card_design").rect_rotation = 0
	
	#Then remove the card from the field (by making it invisible)
	card_node_to_destroy.hide()
	
	#Clear the bottom bar of it's information
	get_node("../user_interface/card_info_box/colored_bar").hide()
	get_node("../user_interface/card_info_box/card_name").hide()
	get_node("../user_interface/card_info_box/atk_def").hide()
	get_node("../user_interface/card_info_box/extra_icons").hide()
	get_node("../user_interface/card_info_box/card_text").hide()
	

#------------------------------------------------------------------------------
var card_ready_to_attack : Node #passed by a card node entering in 'selecting_combat_target'
var card_ready_to_defend : Node #passed by a card node when player is in the phase 'selecting_combat_target'

func do_battle(attacking_card : Node, defending_card : Node):
	GAME_PHASE = "damage_phase"
	
	if attacking_card.this_card_flags.has_battled == true:
		emit_signal("battle_finished")
		return #failsafe to prevent cards from battling more than once
	if defending_card.is_visible() == false:
		print("do_battle() caught a timming mismatch. This should be safe.")
		emit_signal("battle_finished")
		return #failsafe to prevent multiple attacks on an already destroyed monster in case of timming mismatches
	
	card_ready_to_attack = attacking_card
	card_ready_to_defend = defending_card
	
	#Check for ON_SUMMON Effects before battle when a card is self flipped. 'on_flip' were intentionally removed from this check so player can't trigger it's own on flips
	if attacking_card.this_card_flags.is_facedown == true and CardList.card_list[attacking_card.this_card_id].effect.size() > 0 and CardList.card_list[attacking_card.this_card_id].effect[0] in ["on_summon"] and attacking_card.this_card_flags.has_activated_effect == false:
		match CardList.card_list[attacking_card.this_card_id].effect[0]:
			#"on_flip":
			#	effect_activation(attacking_card, "on_flip")
			"on_summon":
				attacking_card.this_card_flags.is_facedown = false
				effect_activation(attacking_card, "on_summon")
		yield($effects, "effect_fully_executed")
		$battle_visuals/battle_timer_node.start(0.3); yield($battle_visuals/battle_timer_node, "timeout")
	
	#Attacker flags
	attacking_card.this_card_flags.has_battled = true
	attacking_card.get_node("card_design/darken_card").show()
	attacking_card.this_card_flags.is_facedown = false
	attacking_card.update_card_information(attacking_card.this_card_id)
	
	#For multiple attackers that still didn't do it's second attack, hide the darken indicator
	if CardList.card_list[attacking_card.this_card_id].effect.size() > 1 and CardList.card_list[attacking_card.this_card_id].effect[1] == "multiple_attacker" and attacking_card.this_card_flags.multiple_attacks == 0:
		attacking_card.get_node("card_design/darken_card").hide()
	
#	#Catch end of Flip Effect
#	if not attacking_card.is_visible() or not defending_card.is_visible():
#		emit_signal("battle_finished")
#		check_for_camera_movement_on_effect_return(attacking_card)
#		return #battle logic has to stop since one of the involveds in battle is no longer on the field
	
	if defending_card.this_card_flags.is_facedown == true and CardList.card_list[defending_card.this_card_id].effect.size() > 0 and CardList.card_list[defending_card.this_card_id].effect[0] in ["on_flip", "on_summon"] and defending_card.this_card_flags.has_activated_effect == false:
		#Check for attacker having the "anti_flip" effect
		if CardList.card_list[attacking_card.this_card_id].effect.size() == 0 or CardList.card_list[attacking_card.this_card_id].effect.size() > 1 and CardList.card_list[attacking_card.this_card_id].effect[1] != "anti_flip":
			match CardList.card_list[defending_card.this_card_id].effect[0]:
				"on_flip":
					effect_activation(defending_card, "on_flip")
				"on_summon":
					attacking_card.this_card_flags.is_facedown = false
					effect_activation(defending_card, "on_summon")
			yield($effects, "effect_fully_executed")
			$battle_visuals/battle_timer_node.start(0.3); yield($battle_visuals/battle_timer_node, "timeout")
	
	#Catch end of Flip Effect
	if not attacking_card.is_visible() or not defending_card.is_visible():
		emit_signal("battle_finished")
		check_for_camera_movement_on_effect_return(attacking_card)
		return #battle logic has to stop since one of the involveds in battle is no longer on the field
	
	#Defender Flags
	defending_card.this_card_flags.is_facedown = false
	defending_card.update_card_information(defending_card.this_card_id)
	
	#Check for on_attack effects right before battle starts
	var on_attack_NOT_before_battle = ["change_position", "toon", "piercing"]
	if CardList.card_list[attacking_card.this_card_id].effect.size() > 0 and CardList.card_list[attacking_card.this_card_id].effect[0] == "on_attack" and not CardList.card_list[attacking_card.this_card_id].effect[1] in on_attack_NOT_before_battle:
		effect_activation(attacking_card, "on_attack")
		yield($effects, "effect_fully_executed")
		$battle_visuals/battle_timer_node.start(0.3); yield($battle_visuals/battle_timer_node, "timeout")
	#Check for Ritual Monsters Attack effects
	if attacking_card.this_card_flags.fusion_type == "ritual" and CardList.card_list[attacking_card.this_card_id].card_name in ["Blue-Eyes Chaos MAX Dragon", "Gearfried the Swordmaster"]:
		effect_activation(attacking_card, "on_attack")
		yield($effects, "effect_fully_executed")
		$battle_visuals/battle_timer_node.start(0.3); yield($battle_visuals/battle_timer_node, "timeout")
	
	#Catch end of Attack Effect
	if not attacking_card.is_visible() or not defending_card.is_visible():
		emit_signal("battle_finished")
		check_for_camera_movement_on_effect_return(attacking_card)
		return #battle logic has to stop since at least one of the involveds in battle is no longer on the field
	
	#Check for Trap Card activations before battle
	var fell_into_trap : Node = check_for_trap_cards(attacking_card)
	if fell_into_trap != null:
		effect_activation(fell_into_trap, "on_flip")
		yield($effects, "effect_fully_executed")
		
		#Set the attacker flags
		attacking_card.this_card_flags.has_battled = true
		attacking_card.get_node("card_design/darken_card").show()
		attacking_card.this_card_flags.is_facedown = false
		attacking_card.update_card_information(attacking_card.this_card_id)
		
		check_for_camera_movement_on_effect_return(attacking_card)
		
		#Check if the trap won't stop battle. By default it does.
		if CardList.card_list[fell_into_trap.this_card_id].effect.size() > 1 and typeof(CardList.card_list[fell_into_trap.this_card_id].effect[1]) == TYPE_STRING and CardList.card_list[fell_into_trap.this_card_id].effect[1] == "non_interrupt_battle":
			pass
		else:
			emit_signal("battle_finished")
			return #battle logic is stopped, since most traps will AT LEAST negate the attack (can do more, but that's on effects.gd to solve)
	
	#Check for SOME on_defend effects that should happen at the start of battle
	var on_defend_before_battle = ["debuff", "ehero_core"]
	if CardList.card_list[defending_card.this_card_id].effect.size() > 0 and CardList.card_list[defending_card.this_card_id].effect[0] == "on_defend" and CardList.card_list[defending_card.this_card_id].effect[1] in on_defend_before_battle:
		card_ready_to_attack = attacking_card
		effect_activation(defending_card, "on_defend")
		yield($effects, "effect_fully_executed")
		$battle_visuals/battle_timer_node.start(0.3); yield($battle_visuals/battle_timer_node, "timeout")
	
	var battle_timer_node = $battle_visuals/battle_timer_node
	var battle_timer : float = 0.2 #in seconds
	
	#First thing is to update the cards involved in battle so I can use them as references for calculations and stuff
	$battle_visuals/visual_cardA.this_card_flags = attacking_card.this_card_flags
	$battle_visuals/visual_cardA.update_card_information(attacking_card.this_card_id)
	$battle_visuals/visual_cardB.this_card_flags = defending_card.this_card_flags
	$battle_visuals/visual_cardB.update_card_information(defending_card.this_card_id)
	
	#Calculation and logic
	var attacker_stats : int = int($battle_visuals/visual_cardA.get_node("card_design/monster_features/atk_def/atk").get_text())
	var defender_stats : int = int($battle_visuals/visual_cardB.get_node("card_design/monster_features/atk_def/atk").get_text())
	if defending_card.this_card_flags.is_defense_position:
		defender_stats = int($battle_visuals/visual_cardB.get_node("card_design/monster_features/atk_def/def").get_text())
	
	var battle_loser_anim_path : Node = null
	var LP_damage : int = 0
	var LP_position : Vector2
	
	if attacker_stats > defender_stats:
		battle_loser_anim_path = $battle_visuals/visual_cardB
		#Only calculate and show LP Damage if defending is not in defense position
		if defending_card.this_card_flags.is_defense_position == false:
			LP_damage = attacker_stats - defender_stats
			LP_position = Vector2(696, 21)
		#Calculate LP damage in case attacker has piercing effect on a defense position monster
		else:
			if CardList.card_list[attacking_card.this_card_id].effect.size() > 1 and CardList.card_list[attacking_card.this_card_id].effect[1] == "piercing":
				LP_damage = attacker_stats - defender_stats
				LP_position = Vector2(696, 21)
		
	elif defender_stats > attacker_stats:
		battle_loser_anim_path = $battle_visuals/visual_cardA
		LP_damage = defender_stats - attacker_stats
		LP_position = Vector2(120, 21)
	
	#Catch and change the LP Damage if the defender has on_defend no_damage
	if CardList.card_list[defending_card.this_card_id].effect.size() > 1 and CardList.card_list[defending_card.this_card_id].effect[1] == "no_damage":
		LP_damage = 0
	
	#RESET ANIMATION STUFF BEFORE STARTING
	$battle_visuals.modulate = Color(1,1,1,1)
	$battle_visuals/visual_cardA.modulate = Color(1,1,1,1)
	$battle_visuals/visual_cardB.modulate = Color(1,1,1,1)
	$battle_visuals/darken_screen.modulate  = Color(1,1,1,0)
	$battle_visuals/LP_damage.modulate = Color(1,1,1,0)
	$battle_visuals/visual_cardA.rect_scale = Vector2(1.4, 1.4)
	$battle_visuals/visual_cardB.rect_scale = Vector2(1.4, 1.4)
	
	#Do all the animations of this battle
	$battle_visuals/visual_cardA/card_design/card_back.show()
	$battle_visuals/visual_cardB/card_design/card_back.show()
	$battle_visuals/visual_cardB/card_design.show() #this is to make sure the card B is visible even after it's hidden by a direct attack
	$battle_visuals.show()
	
	#First the black background fade in
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/darken_screen, "modulate", Color(1,1,1, 0), Color(1,1,1, 1), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer*1.5); yield(battle_timer_node, "timeout")
	
	#The card flip
	SoundControl.play_sound("poc_move")
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardA, "rect_scale", Vector2(1.4, 1.4), Vector2(0.1, 1.4), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardB, "rect_scale", Vector2(1.4, 1.4), Vector2(0.1, 1.4), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer); yield(battle_timer_node, "timeout")
	$battle_visuals/visual_cardA/card_design/card_back.hide()
	$battle_visuals/visual_cardB/card_design/card_back.hide()
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardA, "rect_scale", Vector2(0.1, 1.4), Vector2(1.4, 1.4), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardB, "rect_scale", Vector2(0.1, 1.4), Vector2(1.4, 1.4), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer); yield(battle_timer_node, "timeout")
	
	#The attacking movements
	SoundControl.play_sound("poc_attack")
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardA, "rect_position:x", $battle_visuals/visual_cardA.rect_position.x, $battle_visuals/visual_cardA.rect_position.x + 120, battle_timer, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer); yield(battle_timer_node, "timeout")
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardA, "rect_position:x", $battle_visuals/visual_cardA.rect_position.x, $battle_visuals/visual_cardA.rect_position.x - 120, battle_timer, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	#The defender Shaking
	var original_size_register = $battle_visuals/visual_cardB.rect_scale
	for i in range(4):
		if i%2 == 0:
			$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardB, "rect_scale", $battle_visuals/visual_cardB.rect_scale, Vector2(1.5, 1.5), 0.05, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		else:
			$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardB, "rect_scale", $battle_visuals/visual_cardB.rect_scale, Vector2(1.3, 1.3), 0.05, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		if battle_loser_anim_path != null: #animate the attacker as well if both cards had the same stats
			if i%2 == 0:
				$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardA, "rect_scale", $battle_visuals/visual_cardA.rect_scale, Vector2(1.5, 1.5), 0.05, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
			else:
				$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardA, "rect_scale", $battle_visuals/visual_cardA.rect_scale, Vector2(1.3, 1.3), 0.05, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		$battle_visuals/tween_battle.start()
		battle_timer_node.start(0.1); yield(battle_timer_node, "timeout")
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardB, "rect_scale", $battle_visuals/visual_cardB.rect_scale, original_size_register, 0.05, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer); yield(battle_timer_node, "timeout")
	
	#Figure out which card should be destroyed (Placed here to be visually hidden by the animations of battle)
	var fix_for_relinquished_ritual_effect = false
	if defending_card.this_card_flags.fusion_type == "ritual" and CardList.card_list[defending_card.this_card_id].card_name == "Relinquished":
		fix_for_relinquished_ritual_effect = true
	
	#start the variable
	var card_to_be_destroyed = null
	var two_destroys = false
	
	if attacker_stats > defender_stats:
		#Check for "on_defend" cant_die
		if CardList.card_list[defending_card.this_card_id].effect.size() > 1 and CardList.card_list[defending_card.this_card_id].effect[1] == "cant_die":
			#pass
			
			#Check for special cases where the monster can die by a fragile attribute
			if CardList.card_list[defending_card.this_card_id].effect.size() > 2 and CardList.card_list[defending_card.this_card_id].effect[2] == CardList.card_list[attacking_card.this_card_id].attribute:
				#Destroy defender
				card_to_be_destroyed = defending_card
			
		else:
			#Destroy defender
			card_to_be_destroyed = defending_card
		
	elif attacker_stats == defender_stats:
		#If the stats are equal, destroy neither or both, depending on defender battle position
		if defending_card.this_card_flags.is_defense_position == false: #atk pos, destroy both
			card_to_be_destroyed = attacking_card
			
			
			#Check for "on_defend" cant_die
			if CardList.card_list[defending_card.this_card_id].effect.size() > 1 and CardList.card_list[defending_card.this_card_id].effect[1] == "cant_die":
				#pass
				
				#Check for special cases where the monster can die by a fragile attribute
				if CardList.card_list[defending_card.this_card_id].effect.size() > 2 and CardList.card_list[defending_card.this_card_id].effect[2] == CardList.card_list[attacking_card.this_card_id].attribute:
					#Destroy defender
					card_to_be_destroyed = defending_card
					two_destroys = true
				
			else:
				card_to_be_destroyed = defending_card
				two_destroys = true
			
		else: #just flip defense card face up
			defending_card.this_card_flags.is_facedown = false
			defending_card.get_node("card_design/card_back").hide()
		
	elif attacker_stats < defender_stats:
		#If attacker lost, only destroy it if defender is not in defense position
		if defending_card.this_card_flags.is_defense_position == false:
			card_to_be_destroyed = attacking_card
			
		defending_card.this_card_flags.is_facedown = false
		defending_card.get_node("card_design/card_back").hide()
	
	#Get rid of the Battle Loser
	SoundControl.play_sound("poc_destroy")
	if battle_loser_anim_path != null:
		$battle_visuals/tween_battle.interpolate_property(battle_loser_anim_path, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$battle_visuals/tween_battle.start()
		battle_timer_node.start(battle_timer*1.5); yield(battle_timer_node, "timeout")
	else:
		$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardA, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardB, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$battle_visuals/tween_battle.start()
		battle_timer_node.start(battle_timer*1.5); yield(battle_timer_node, "timeout")
	
	#Show Lifepoint Damage
	if LP_damage > 0:
		$battle_visuals/LP_damage.text = "-" + String(LP_damage)
		$battle_visuals/LP_damage.rect_position = LP_position
		$battle_visuals/LP_damage.show()
		$battle_visuals/tween_battle.interpolate_property($battle_visuals/LP_damage, "modulate", Color(1,1,1, 0), Color(1,1,1, 1), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer*2); yield(battle_timer_node, "timeout")
	if LP_damage > 0:
		$battle_visuals/tween_battle.interpolate_property($battle_visuals/LP_damage, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer); yield(battle_timer_node, "timeout")
	
	#Finally destroy the card
	var store_fusion_info = ""
	if card_to_be_destroyed != null:
		store_fusion_info = card_to_be_destroyed.this_card_flags.fusion_type
		
		#Check for mutual destruction
		if two_destroys == true:
			destroy_a_card(attacking_card)
		
		destroy_a_card(card_to_be_destroyed)
	
	#Battle scene fadeout
	$battle_visuals/tween_battle.interpolate_property($battle_visuals, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer*2); yield(battle_timer_node, "timeout")
	$battle_visuals/LP_damage.hide()
	$battle_visuals.hide()
	
	#Add some extra time for ritual cards that have on_death effects
	if store_fusion_info == "ritual" and CardList.card_list[card_to_be_destroyed.this_card_id].card_name in ["Five-Headed Dragon", "Arcana Knight Joker", "Valkyrion the Magna Warrior", "Lord of the Red", "Paladin of White Dragon", "Paladin of Dark Dragon", "Knight of Armor Dragon", "Chakra", "Demise, Agent of Armageddon", "Demise, King of Armageddon",
																																			"Cyber Angel Natasha", "Cyber Angel Idaten", "Cyber Angel Benten", "Cyber Angel Izana", "Cyber Angel Dakini", "Cyber Angel Vrash"]:
		battle_timer_node.start(3);
		yield(battle_timer_node, "timeout")
	
	#Finish Battle phase in different ways depending on whose turn it is
	if attacking_card.get_parent().get_name().find("player") != -1: #it's players turn
		#print("Back to Player's Main Phase")
		attacking_card.cancel_all_combat_controls() #hide the combat controls for the card that already attacked
		get_node("../").change_field_view() #return back to player's side of the field
		GAME_PHASE = "main_phase"
		
		#Reduce LP as intended
		if defender_stats > attacker_stats: #Reduce from player LP
			if LP_damage >= int(get_node("../user_interface/top_info_box/player_info/lifepoints").get_text()):
				check_for_game_end("player_lp_out")
			change_lifepoints("player", LP_damage)
		else: #Reduce from COM LP
			if LP_damage >= int(get_node("../user_interface/top_info_box/com_info/lifepoints").get_text()):
				check_for_game_end("com_lp_out")
			change_lifepoints("enemy", LP_damage)
			
			#check for return_damage that Enemy will inflict on the player
			if CardList.card_list[defending_card.this_card_id].effect.size() > 1 and CardList.card_list[defending_card.this_card_id].effect[1] == "return_damage":
				$battle_visuals/battle_timer_node.start(0.9); yield($battle_visuals/battle_timer_node, "timeout")
				if LP_damage >= int(get_node("../user_interface/top_info_box/player_info/lifepoints").get_text()):
					check_for_game_end("player_lp_out")
				change_lifepoints("player", LP_damage)
			#check for Relinquished ritual effect
			if fix_for_relinquished_ritual_effect:
				$battle_visuals/battle_timer_node.start(0.9); yield($battle_visuals/battle_timer_node, "timeout")
				if LP_damage >= int(get_node("../user_interface/top_info_box/player_info/lifepoints").get_text()):
					check_for_game_end("player_lp_out")
				change_lifepoints("player", LP_damage)
			
	else:
		#Reduce LP as intended
		if defender_stats > attacker_stats: #Reduce from player LP
			if LP_damage >= int(get_node("../user_interface/top_info_box/com_info/lifepoints").get_text()):
				check_for_game_end("com_lp_out")
			change_lifepoints("enemy", LP_damage)
		else: #Reduce from COM LP
			if LP_damage >= int(get_node("../user_interface/top_info_box/player_info/lifepoints").get_text()):
				check_for_game_end("player_lp_out")
			change_lifepoints("player", LP_damage)
			
			#check for return_damage that player will inflict on the enemy
			if CardList.card_list[defending_card.this_card_id].effect.size() > 1 and CardList.card_list[defending_card.this_card_id].effect[1] == "return_damage":
				$battle_visuals/battle_timer_node.start(0.9); yield($battle_visuals/battle_timer_node, "timeout")
				if LP_damage >= int(get_node("../user_interface/top_info_box/com_info/lifepoints").get_text()):
					check_for_game_end("com_lp_out")
				change_lifepoints("enemy", LP_damage)
			#check for Relinquished ritual effect
			if fix_for_relinquished_ritual_effect:
				$battle_visuals/battle_timer_node.start(0.9); yield($battle_visuals/battle_timer_node, "timeout")
				if LP_damage >= int(get_node("../user_interface/top_info_box/com_info/lifepoints").get_text()):
					check_for_game_end("com_lp_out")
				change_lifepoints("enemy", LP_damage)
	
	#Revert some temporary effects
	if attacking_card.is_visible() and CardList.card_list[attacking_card.this_card_id].effect.size() > 1 and CardList.card_list[attacking_card.this_card_id].effect[1] in ["injection_fairy", "clear_vice"]:
		match CardList.card_list[attacking_card.this_card_id].effect[1]:
			#Remove the 3000 ATK boost from Injection Fairy Lily
			"injection_fairy":
				if attacking_card.this_card_flags.atk_up >= 3000:
					 attacking_card.this_card_flags.atk_up -= 3000
					 attacking_card.update_card_information(attacking_card.this_card_id)
			#Goes to Zero
			"clear_vice":
				if attacking_card.this_card_flags.atk_up >= 0:
					attacking_card.this_card_flags.atk_up = 0
					attacking_card.update_card_information(attacking_card.this_card_id)
	if defending_card.is_visible() and CardList.card_list[defending_card.this_card_id].effect.size() > 1 and CardList.card_list[defending_card.this_card_id].effect[1] in ["ehero_core"]:
		match CardList.card_list[defending_card.this_card_id].effect[1]:
			"ehero_core":
				#Remove the attack bonus it gets
				if defending_card.this_card_flags.atk_up >= CardList.card_list[defending_card.this_card_id].atk:
					defending_card.this_card_flags.atk_up -= CardList.card_list[defending_card.this_card_id].atk
					defending_card.update_card_information(defending_card.this_card_id)
	#Revert the Ritual battle effects (atk and def)
	if attacking_card.this_card_flags.fusion_type == "ritual" and CardList.card_list[attacking_card.this_card_id].card_name in ["Blue-Eyes Chaos MAX Dragon", "Gearfried the Swordmaster"]:
		match CardList.card_list[attacking_card.this_card_id].card_name:
			"Blue-Eyes Chaos MAX Dragon":
				attacking_card.this_card_flags.atk_up -= 4000
				attacking_card.update_card_information(attacking_card.this_card_id)
			"Gearfried the Swordmaster":
				var full_atk_on_field = int(attacking_card.get_node("card_design/monster_features/atk_def/atk").text)
				attacking_card.this_card_flags.atk_up -= full_atk_on_field/2
				attacking_card.update_card_information(attacking_card.this_card_id)
	
	#The "change position" effect should happen after battle for both Attacking and Defense
	for battler in [attacking_card, defending_card]:
		if CardList.card_list[battler.this_card_id].effect.size() > 1 and CardList.card_list[battler.this_card_id].effect[1] == "change_position":
			effect_activation(battler, CardList.card_list[battler.this_card_id].effect[0])
			yield($effects, "effect_fully_executed")
			$battle_visuals/battle_timer_node.start(0.5); yield($battle_visuals/battle_timer_node, "timeout")
	
	#Reset these to null
	card_ready_to_attack = null
	card_ready_to_defend = null
	
	#Emit signal at the end of battle
	check_for_game_end() #one final check, just to be sure
	emit_signal("battle_finished")

func _on_direct_attack_area_button_up():
	#prevent direct attacks on first turn
	if $player_logic.turn_count <= 1:
		return
	
	#prevent clicking for a direct outside of the battle phase
	if GAME_PHASE != "selecting_combat_target":
		return
	if GAME_PHASE == "damage_phase":
		return
	
	#Check if the player can direct attack the enemy (only when 0 monsters on the field)
	var enemy_monsters_on_field : int = 0
	for i in range(5):
		if get_node("../duel_field/enemy_side_zones/monster_" + String(i)).is_visible():
			enemy_monsters_on_field += 1
			break
	
	if enemy_monsters_on_field == 0 or CardList.card_list[card_ready_to_attack.this_card_id].effect.size() > 1 and CardList.card_list[card_ready_to_attack.this_card_id].effect[1] in ["can_direct", "toon"]:
		if CardList.card_list[card_ready_to_attack.this_card_id].effect.size() > 1 and CardList.card_list[card_ready_to_attack.this_card_id].effect[1] == "toon":
			effect_activation(card_ready_to_attack, "on_attack")
		do_direct_attack(card_ready_to_attack)
	else:
		print("can't direct attack")

func do_direct_attack(attacking_card):
	GAME_PHASE = "damage_phase"
	
	#Basically a clone of do_battle() with all the references to a defending card being invisible
	if attacking_card.this_card_flags.has_battled == true:
		return #failsafe to prevent cards from battling more than once
	
#	#Check for Flip Effects before battle
#	if attacking_card.this_card_flags.is_facedown == true and CardList.card_list[attacking_card.this_card_id].effect.size() > 0 and CardList.card_list[attacking_card.this_card_id].effect[0] in ["on_flip", "on_summon"] and attacking_card.this_card_flags.has_activated_effect == false:
#		match CardList.card_list[attacking_card.this_card_id].effect[0]:
#			"on_flip":
#				effect_activation(attacking_card, "on_flip")
#			"on_summon":
#				attacking_card.this_card_flags.is_facedown = false
#				effect_activation(attacking_card, "on_summon")
#		yield($effects, "effect_fully_executed")
#		$battle_visuals/battle_timer_node.start(0.3); yield($battle_visuals/battle_timer_node, "timeout")
	
	#Catch end of Flip Effect
	if not attacking_card.is_visible():
		emit_signal("battle_finished")
		return #battle logic has to stop since one of the involveds in battle is no longer on the field
	
	var battle_timer_node = $battle_visuals/battle_timer_node
	var battle_timer : float = 0.2 #in seconds
	
	#Set the attacker flags
	attacking_card.this_card_flags.has_battled = true
	attacking_card.get_node("card_design/darken_card").show()
	attacking_card.this_card_flags.is_facedown = false
	attacking_card.update_card_information(attacking_card.this_card_id)
	
	#For multiple attackers that still didn't do it's second attack, hide the darken indicator
	if CardList.card_list[attacking_card.this_card_id].effect.size() > 1 and CardList.card_list[attacking_card.this_card_id].effect[1] == "multiple_attacker" and attacking_card.this_card_flags.multiple_attacks == 0:
		attacking_card.get_node("card_design/darken_card").hide()
	
	#Check for on_attack effects right before battle starts
	if CardList.card_list[attacking_card.this_card_id].effect.size() > 0 and CardList.card_list[attacking_card.this_card_id].effect[0] == "on_attack" and CardList.card_list[attacking_card.this_card_id].effect[1] != "piercing":
		effect_activation(attacking_card, "on_attack")
		yield($effects, "effect_fully_executed")
		$battle_visuals/battle_timer_node.start(0.3); yield($battle_visuals/battle_timer_node, "timeout")
	#Check for Ritual Monsters Attack effects
	if attacking_card.this_card_flags.fusion_type == "ritual" and CardList.card_list[attacking_card.this_card_id].card_name in ["Blue-Eyes Chaos MAX Dragon", "Gearfried the Swordmaster"]:
		effect_activation(attacking_card, "on_attack")
		yield($effects, "effect_fully_executed")
		$battle_visuals/battle_timer_node.start(0.3); yield($battle_visuals/battle_timer_node, "timeout")
		
	#Catch end of Attack Effect
	if not attacking_card.is_visible():
		emit_signal("battle_finished")
		return #battle logic has to stop since at least one of the involveds in battle is no longer on the field
	
	#Check for Trap Card activations before battle
	var fell_into_trap : Node = check_for_trap_cards(attacking_card)
	if fell_into_trap != null:
		card_ready_to_attack = attacking_card
		effect_activation(fell_into_trap, "on_flip")
		yield($effects, "effect_fully_executed")
		
#		#Set the attacker flags
#		attacking_card.this_card_flags.has_battled = true
#		attacking_card.get_node("card_design/darken_card").show()
#		attacking_card.this_card_flags.is_facedown = false
#		attacking_card.update_card_information(attacking_card.this_card_id)
#
#		#For multiple attackers that still didn't do it's second attack, hide the darken indicator
#		if CardList.card_list[attacking_card.this_card_id].effect.size() > 1 and CardList.card_list[attacking_card.this_card_id].effect[1] == "multiple_attacker" and attacking_card.this_card_flags.multiple_attacks == 0:
#			attacking_card.get_node("card_design/darken_card").hide()
		
		check_for_camera_movement_on_effect_return(attacking_card)
		
		#Check if the trap won't stop battle. By default it does.
		if CardList.card_list[fell_into_trap.this_card_id].effect.size() > 1 and typeof(CardList.card_list[fell_into_trap.this_card_id].effect[1]) == TYPE_STRING and CardList.card_list[fell_into_trap.this_card_id].effect[1] == "non_interrupt_battle":
			pass
		else:
			emit_signal("battle_finished")
			return #battle logic is stopped, since most traps will AT LEAST negate the attack (can do more, but that's on effects.gd to solve)
	
	#First thing is to update the cards involved in battle so I can use them as references for calculations and stuff
	$battle_visuals/visual_cardA.this_card_flags = attacking_card.this_card_flags
	$battle_visuals/visual_cardA.update_card_information(attacking_card.this_card_id)
	
	#Calculation and logic
	var attacker_stats : int = int($battle_visuals/visual_cardA.get_node("card_design/monster_features/atk_def/atk").get_text())
	var LP_damage : int = attacker_stats
	var LP_position : Vector2 = Vector2(696, 21)
	
	#RESET ANIMATION STUFF BEFORE STARTING
	$battle_visuals.modulate = Color(1,1,1,1)
	$battle_visuals/visual_cardA.modulate = Color(1,1,1,1)
	$battle_visuals/darken_screen.modulate  = Color(1,1,1,0)
	$battle_visuals/LP_damage.modulate = Color(1,1,1,0)
	
	#Do all the animations of this battle
	$battle_visuals/visual_cardA/card_design/card_back.show()
	$battle_visuals/visual_cardB/card_design.hide()
	$battle_visuals.show()
	
	#First the black background fade in
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/darken_screen, "modulate", Color(1,1,1, 0), Color(1,1,1, 1), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer*1.5); yield(battle_timer_node, "timeout")
	
	#The card flip
	SoundControl.play_sound("poc_move")
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardA, "rect_scale", Vector2(1.4, 1.4), Vector2(0.1, 1.4), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer); yield(battle_timer_node, "timeout")
	$battle_visuals/visual_cardA/card_design/card_back.hide()
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardA, "rect_scale", Vector2(0.1, 1.4), Vector2(1.4, 1.4), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer); yield(battle_timer_node, "timeout")
	
	#The attacking movements
	SoundControl.play_sound("poc_attack")
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardA, "rect_position:x", $battle_visuals/visual_cardA.rect_position.x, $battle_visuals/visual_cardA.rect_position.x + 120, battle_timer, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer); yield(battle_timer_node, "timeout")
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardA, "rect_position:x", $battle_visuals/visual_cardA.rect_position.x, $battle_visuals/visual_cardA.rect_position.x - 120, battle_timer, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer); yield(battle_timer_node, "timeout")
	
	#Show Lifepoint Damage
	if LP_damage > 0:
		$battle_visuals/LP_damage.text = "-" + String(LP_damage)
		$battle_visuals/LP_damage.rect_position = LP_position
		$battle_visuals/LP_damage.show()
		$battle_visuals/tween_battle.interpolate_property($battle_visuals/LP_damage, "modulate", Color(1,1,1, 0), Color(1,1,1, 1), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer*2); yield(battle_timer_node, "timeout")
	if LP_damage > 0:
		$battle_visuals/tween_battle.interpolate_property($battle_visuals/LP_damage, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer); yield(battle_timer_node, "timeout")
	
	#Battle scene fadeout
	$battle_visuals/tween_battle.interpolate_property($battle_visuals, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer*2); yield(battle_timer_node, "timeout")
	$battle_visuals/LP_damage.hide()
	$battle_visuals.hide()
	
	#Finish Battle phase in different ways depending on whose turn it is
	if attacking_card.get_parent().get_name().find("player") != -1: #it's players turn
		if LP_damage >= int(get_node("../user_interface/top_info_box/com_info/lifepoints").get_text()):
			check_for_game_end("com_lp_out")
		change_lifepoints("enemy", LP_damage)
		
		#print("Back to Player's Main Phase")
		attacking_card.cancel_all_combat_controls() #hide the combat controls for the card that already attacked
		get_node("../").change_field_view() #return back to the other side of the field
		GAME_PHASE = "main_phase"
	else:
		if LP_damage >= int(get_node("../user_interface/top_info_box/player_info/lifepoints").get_text()):
			check_for_game_end("player_lp_out")
		change_lifepoints("player", LP_damage)
		
		#print("Back to Enemy's Main Phase")
		GAME_PHASE = "enemy_main_phase"
	
	#Revert some temporary effects
	if attacking_card.is_visible() and CardList.card_list[attacking_card.this_card_id].effect.size() > 1 and CardList.card_list[attacking_card.this_card_id].effect[1] in ["injection_fairy", "clear_vice"]:
		match CardList.card_list[attacking_card.this_card_id].effect[1]:
			#Remove the 3000 ATK boost from Injection Fairy Lily
			"injection_fairy":
				if attacking_card.this_card_flags.atk_up >= 3000:
					 attacking_card.this_card_flags.atk_up -= 3000
					 attacking_card.update_card_information(attacking_card.this_card_id)
			#Goes to Zero
			"clear_vice":
				if attacking_card.this_card_flags.atk_up >= 0:
					attacking_card.this_card_flags.atk_up = 0
					attacking_card.update_card_information(attacking_card.this_card_id)
	#Revert the Ritual battle effects
	if attacking_card.this_card_flags.fusion_type == "ritual" and CardList.card_list[attacking_card.this_card_id].card_name in ["Blue-Eyes Chaos MAX Dragon", "Gearfried the Swordmaster"]:
		match CardList.card_list[attacking_card.this_card_id].card_name:
			"Blue-Eyes Chaos MAX Dragon":
				attacking_card.this_card_flags.atk_up -= 4000
				attacking_card.update_card_information(attacking_card.this_card_id)
			"Gearfried the Swordmaster":
				var full_atk_on_field = int(attacking_card.get_node("card_design/monster_features/atk_def/atk").text)
				attacking_card.this_card_flags.atk_up -= full_atk_on_field/2
				attacking_card.update_card_information(attacking_card.this_card_id)
	
	check_for_game_end()
	
	#Emit signal at the end of battle
	emit_signal("battle_finished")

#---------------------------------------------------------------------------------------------------
var LP_info_node : Node
var waboku_protection = false
func change_lifepoints(target : String, LP_damage : int, adding = false):
	if LP_damage <= 0:
		return
	
	#If adding is true, ignore waboku_protection and have lifepoints go up
	if waboku_protection == true and adding == false:
		return
	
	var tween_LP : Node = get_node("../user_interface/top_info_box/tween_LP")
	var constant_timer : float = clamp(LP_damage * 0.05, 0.2, 0.8)
	match target:
		"player": LP_info_node = get_node("../user_interface/top_info_box/player_info/lifepoints")
		"enemy": LP_info_node = get_node("../user_interface/top_info_box/com_info/lifepoints")
		_: print("no target to change lifepoints.")
	
	if adding == true: LP_damage = -LP_damage #just inver the signal, math does the rest
	var LP_result = clamp(int(LP_info_node.get_text()) - LP_damage, 0, 9999)
	
	tween_LP.interpolate_method(self, "LP_method_for_tween", int(LP_info_node.get_text()), LP_result, constant_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_LP.start()
	
	if LP_result <= 0:
		if target == "enemy": target = "com"
		check_for_game_end(target + "_lp_out")

func LP_method_for_tween(value : int):
	LP_info_node.text = String(value)

#---------------------------------------------------------------------------------------------------
func check_for_camera_movement_on_effect_return(attacking_card : Node):
	if attacking_card.get_parent().get_name().find("player") != -1: #it's players turn
		attacking_card.cancel_all_combat_controls() #hide the combat controls for the card that already attacked
		get_node("../").change_field_view() #return back to the other side of the field
		GAME_PHASE = "main_phase"

#---------------------------------------------------------------------------------------------------
var game_end_defined = false
func check_for_game_end(optional_passed_condition : String = "nothing"):
	#Check for game end only if game_ended hasn't been triggered yet 
	if game_end_defined == true:
		return
	
	#COM will always have the losing priority over player
	var game_loser : String = "" #COM or Player
	
	#Basic loss by LifePoints reaching 0
	if int(self.get_parent().get_node("user_interface/top_info_box/com_info/lifepoints").get_text()) == 0 or optional_passed_condition == "com_lp_out":
		game_loser = "COM"
	elif int(self.get_parent().get_node("user_interface/top_info_box/player_info/lifepoints").get_text()) == 0 or optional_passed_condition == "player_lp_out":
		game_loser = "player"
	
	#Loss by deck out
	if $enemy_logic.enemy_deck.size() <= 0 or optional_passed_condition == "COM_deck_out":
		game_loser = "COM"
	elif $player_logic.player_deck.size() <= 0 or optional_passed_condition == "PLAYER_deck_out":
		game_loser = "player"
	
	#DEBUG menu testing stuff
	if optional_passed_condition == "DEBUG_END_DUEL":
		game_loser = "COM"
	
	#Forfeit button on side_menu
	if optional_passed_condition == "player_forfeit":
		game_loser = "player"
	
	#Decide what to do next
	var reward_scene
	if game_loser != "":
		game_end_defined = true
		reward_scene = get_node("../reward_scene")
		
		match game_loser:
			"COM": #COM lost, go to the rewards screen
				#Pass ahead the important information for Rewards calculations
				reward_scene.duel_winner = "player"
				reward_scene.duel_deck_count = $player_logic.player_deck.size()
				reward_scene.duel_fusion_count = $player_logic.fusion_count
				reward_scene.duel_effect_count = $player_logic.effect_count
				reward_scene.duel_spelltrap_count = $player_logic.spelltrap_count
				reward_scene.defeated_duelist = PlayerData.going_to_duel
				
				reward_scene.final_turn_count = int(self.get_parent().get_node("user_interface/top_info_box/field_info/turn").get_text().split(" ")[1])
				reward_scene.final_player_LP = int(self.get_parent().get_node("user_interface/top_info_box/player_info/lifepoints").get_text())
				var total_field_atk = 0
				for i in range(5):
					var checking_node = self.get_parent().get_node("duel_field/player_side_zones/monster_" + String(i))
					if checking_node.is_visible():
						total_field_atk += int(checking_node.get_node("card_design/monster_features/atk_def/atk").get_text())
				reward_scene.final_field_atk = total_field_atk
			
			"player": #Player lost, go to game over screen
				#Stop COM turn
				$enemy_logic.enemy_end_turn()
				
				reward_scene.duel_winner = "COM"
			
			_: #no one lost yet, do nothing
				return
		
		#Go to the reward scene
		reward_scene.start_reward_scene()
		
		return "endscreen"













