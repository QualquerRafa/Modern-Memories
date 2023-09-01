extends Node
#All about Effects and their functions

#Reference to game_logic node
onready var GAME_LOGIC = get_node("../")

#Signals to be used as timers for other parts of code
signal effect_animation_finished #emitted by the animation
signal effect_fully_executed #emitted at the end to progress the duel phase

signal simulated_fusion_animation_finished #emitted by simulate_fusion_animation()
signal lifepoint_animation_finished

func call_effect(card_node : Node, type_of_activation : String): #The 'card_node' that is passed is already the exact card that's on the field
	#Easily accessible information about the card
	var card_attribute = CardList.card_list[card_node.this_card_id].attribute
	var card_type = CardList.card_list[card_node.this_card_id].type
	
	#Initialize the returned info at the end
	var type_of_effect_activated : String = card_type #can and will be rewritten for monsters to show "on_flip", "on_attack", etc
	var extra_return_information : String #anything else that needs to be returned to be checked by other game functions
	
	#Animate the card being activated
	var force_animation_on_special_cases = false
	if type_of_activation == "on_flip" and CardList.card_list[card_node.this_card_id].effect[0] == "on_flip":
		force_animation_on_special_cases = true
	if type_of_activation == "on_attack" and CardList.card_list[card_node.this_card_id].effect[1] in ["mutual_banish", "injection_fairy", "rocket_warrior", "mill", "toon", "lifepoint_cost", "lifepoint_up", "get_power"]:
			force_animation_on_special_cases = true
	if type_of_activation == "on_defend" and CardList.card_list[card_node.this_card_id].effect[1] in ["debuff", "ehero_core"]:
		force_animation_on_special_cases = true
	
	do_activation_animation(card_node, force_animation_on_special_cases)
	yield(self, "effect_animation_finished")
	
	#Increment the correct counters for Duel Reward
	if CardList.card_list[card_node.this_card_id].effect.size() > 0:
		match card_attribute:
			"spell", "trap":
				GAME_LOGIC.get_node("player_logic").spelltrap_count += 1
			_:
				if type_of_activation == CardList.card_list[card_node.this_card_id].effect[0]:
					GAME_LOGIC.get_node("player_logic").effect_count += 1
	
	#Handle it accordingly
	match card_attribute:
		"spell":
			#Get specific kinds of spells to do specific things
			match card_type:
				"field":
					#Get as the return value the element of the field that was activated
					extra_return_information = activate_spell_field(card_node)
				"equip":
					#Get as the return value true or false that just means if the card missed (false) or tried to work (true)
					var _discard = activate_spell_equip(card_node)
					extra_return_information = "equip"
				"spell": #general spells that activate generic actions
					extra_return_information = activate_spell_generic(card_node)
				"ritual":
					extra_return_information = activate_spell_ritual(card_node)
				_:
					print("Undefined type of Spell card.")
		
		"trap":
			#Trap cards can't be placed face up neither activated from the field, this function will only be called during battles
			extra_return_information = activate_trap(card_node)
		
		_: #Monsters
			match type_of_activation:
				"on_summon":
					if CardList.card_list[card_node.this_card_id].effect[0] == "on_summon":
						extra_return_information = monster_on_summon(card_node)
				"on_flip":
					if CardList.card_list[card_node.this_card_id].effect[0] == "on_flip":
						extra_return_information = monster_on_flip(card_node)
				"on_attack":
					if CardList.card_list[card_node.this_card_id].effect[0] == "on_attack":
						var _discard =  monster_on_attack(card_node)
						extra_return_information = "on_attack"
				"on_defend":
					if CardList.card_list[card_node.this_card_id].effect[0] == "on_defend":
						extra_return_information = monster_on_defend(card_node)
				_:
					print("Monster effect of type ", CardList.card_list[card_node.this_card_id].effect[0], " isn't programmed.")
					extra_return_information = "FAIL"
	
	#For Ritual Summoned monsters, check for their special effects
	if card_node.this_card_flags.fusion_type == "ritual":
		var transform_type_of_activation_in_ritual_condition = {
			#"on_summon" : "on_ritual_summon", #this one isn't actually needed, when a Ritual Monster is summoned it's effects are auto-called with this parameter
			"on_attack" : "on_ritual_attack",
			"on_defend" : "on_ritual_defend",
			#on_ritual_death is specially called only on card_destroy() function
		}
		if transform_type_of_activation_in_ritual_condition.keys().has(type_of_activation):
			ritual_effects_activation(card_node, transform_type_of_activation_in_ritual_condition[type_of_activation])
		else:
			pass
			#print(type_of_activation, " parameter was ignored for ritual monster")
	
	#After a card effect was activated and it's been removed from the field, clear the bottom bar from it's information. Generally happens for Spell and Traps only, since monsters remain.
	if card_attribute in ["spell", "trap"]:
		clear_card_after_activation(card_node)
	
	#Force the card face up after it's effect activates
	if card_node.this_card_flags.has_activated_effect and card_node.this_card_flags.is_facedown:
		#print("Force face up after effect!")
		card_node.this_card_flags.is_facedown = false
		card_node.update_card_information(card_node.this_card_id)
	
	#Return to the Duel with this info after the effects are executed
	if card_type != "equip": #equips will emit this signal at it's own moment, since it needs to wait for player input
		emit_signal("effect_fully_executed")
	
	var final_return = [type_of_effect_activated, extra_return_information]
	return final_return

####################################################################################################
# AUXILIARY
####################################################################################################
func do_activation_animation(card_node : Node, force_animation = false):
	var animation_timer : float = 0.001
	
	#RESET ANIMATION STUFF BEFORE STARTING
	$effect_visuals.modulate = Color(1,1,1,1)
	$effect_visuals/visual_cardA.modulate = Color(1,1,1,1)
	$effect_visuals/darken_screen.modulate  = Color(1,1,1,0)
	
	#Update the visuals of the card that has to be animated
	$effect_visuals/visual_cardA.this_card_flags = card_node.this_card_flags
	$effect_visuals/visual_cardA.update_card_information(card_node.this_card_id)
	
	#Make the visuals visible right before animating them
	$effect_visuals/visual_cardA/card_design/card_back.show()
	#Gambiarra do caralho pra "não animar" e emitir o sinal direitinho no final
	#var catch_on_flip = CardList.card_list[card_node.this_card_id].effect[0] == "on_flip" and was_flipped == true
	if force_animation == true or not CardList.card_list[card_node.this_card_id].effect[0] in ["special_description", "on_attack", "on_defend", "on_flip"]: # or catch_on_flip == true
		animation_timer = 0.2
		SoundControl.play_sound("poc_effect")
		$effect_visuals.show()
	#Show animation for Metalmorph, Level Up, Toon World, Mask Change
	if CardList.card_list[card_node.this_card_id].attribute == "spell" and CardList.card_list[card_node.this_card_id].effect[0] == "special_description":
		animation_timer = 0.2
		SoundControl.play_sound("poc_effect")
		$effect_visuals.show()
	
	#First the black background fade in
	$tween_effect.interpolate_property($effect_visuals/darken_screen, "modulate", Color(1,1,1, 0), Color(1,1,1, 1), animation_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween_effect.start()
	$effect_timer_node.start(animation_timer*1.5); yield($effect_timer_node, "timeout")
	
	#The card flip
	$tween_effect.interpolate_property($effect_visuals/visual_cardA, "rect_scale", Vector2(1.4, 1.4), Vector2(0.1, 1.4), animation_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween_effect.start()
	$effect_timer_node.start(animation_timer); yield($effect_timer_node, "timeout")
	$effect_visuals/visual_cardA/card_design/card_back.hide()
	$tween_effect.interpolate_property($effect_visuals/visual_cardA, "rect_scale", Vector2(0.1, 1.4), Vector2(1.4, 1.4), animation_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween_effect.start()
	
	#Hold the activated card visible for a while
	$effect_timer_node.start(animation_timer*4); yield($effect_timer_node, "timeout")
	
	#Animation fade out
	$tween_effect.interpolate_property($effect_visuals, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), animation_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween_effect.start()
	$effect_timer_node.start(animation_timer*2); yield($effect_timer_node, "timeout")
	$effect_visuals.hide()
	
	#Emit the signal to indicate the animation has ended
	emit_signal("effect_animation_finished")
	
	return true

func clear_card_after_activation(card_node : Node):
	#Based on the reference passed, find that card on the field and destroy it
	GAME_LOGIC.destroy_a_card(card_node)
	
	#Clear the bottom bar
	GAME_LOGIC.get_parent().get_node("user_interface/card_info_box/colored_bar").hide()
	GAME_LOGIC.get_parent().get_node("user_interface/card_info_box/card_name").hide()
	GAME_LOGIC.get_parent().get_node("user_interface/card_info_box/atk_def").hide()
	GAME_LOGIC.get_parent().get_node("user_interface/card_info_box/extra_icons").hide()
	GAME_LOGIC.get_parent().get_node("user_interface/card_info_box/card_text").hide()
	
	return null

func get_caller_and_target(card_node : Node): #returns 'player', 'enemy'
	#Check which field it will use ([VAR]_side_zones)
	var who_activated_this_effect = "player"
	var target_of_effect = "enemy"
	if card_node.get_parent().get_name().find("player") != 0:
		who_activated_this_effect = "enemy"
		target_of_effect = "player"
	
	return [who_activated_this_effect, target_of_effect]

func show_field_slots():
	$just_visual_field_slots.show()
	recursive_slot_animation()

func recursive_slot_animation():
	var animation_time : float = 0.7 #in seconds
	var slots_for_animation : Node = $just_visual_field_slots
	var tween_slots : Node = $just_visual_field_slots/tween_slots
	var small_size : Vector2 = Vector2(1, 1)
	var big_size : Vector2 = Vector2(1.05, 1.05)
	
	#Slots Animation
	for i in range(5):
		if slots_for_animation.get_child(i).rect_scale == small_size:
			tween_slots.interpolate_property(slots_for_animation.get_child(i), "rect_scale", small_size, big_size, animation_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween_slots.start()
		elif slots_for_animation.get_child(i).rect_scale == big_size:
			tween_slots.interpolate_property(slots_for_animation.get_child(i), "rect_scale", big_size, small_size, animation_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween_slots.start()
	$effect_timer_node.start(animation_time + 0.3); yield($effect_timer_node, "timeout")
	
	#Recursive
	if $just_visual_field_slots.is_visible():
		recursive_slot_animation()
	else:
		return

func simulate_fusion_animation_resulting_in_card1(card_1_caller : Node, card_2_material : Node):
	#Do the whole animation of fusing cards
	var fusion_timer : float = 0.8 #in seconds
	var fusion_start_pos_0 : Vector2 = Vector2(83+60, 80)
	var fusion_start_pos_1 : Vector2 = Vector2(856-60, 80)
	var fusion_final_pos : Vector2 = Vector2(475, 80)
	
	#Update info regarding card_1
	GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_0").rect_position = fusion_start_pos_0
	GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_0").this_card_flags.fusion_type = card_1_caller.this_card_flags.fusion_type
	GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_0").this_card_flags.atk_up = card_1_caller.this_card_flags.atk_up 
	GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_0").this_card_flags.def_up = card_1_caller.this_card_flags.def_up
	GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_0").update_card_information(card_1_caller.this_card_id)
	
	#Update info regardin card_2
	GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_1").rect_position = fusion_start_pos_1
	GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_1").this_card_flags.fusion_type = card_2_material.this_card_flags.fusion_type
	GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_1").this_card_flags.atk_up = card_2_material.this_card_flags.atk_up 
	GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_1").this_card_flags.def_up = card_2_material.this_card_flags.def_up
	GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_1").update_card_information(card_2_material.this_card_id)
	
	GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_0").show()
	GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_1").show()
	GAME_LOGIC.get_node("player_logic/fusion_animation").show()
	
	SoundControl.play_sound("poc_fusion1")
	GAME_LOGIC.get_node("player_logic/fusion_animation/tween_fusion").interpolate_property(GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_0"), "rect_position", fusion_start_pos_0, fusion_final_pos, fusion_timer, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	GAME_LOGIC.get_node("player_logic/fusion_animation/tween_fusion").interpolate_property(GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_0"), "modulate", Color(1, 1, 1, 1), Color(10, 10, 10, 0.666), fusion_timer*0.9, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	GAME_LOGIC.get_node("player_logic/fusion_animation/tween_fusion").interpolate_property(GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_1"), "rect_position", fusion_start_pos_1, fusion_final_pos, fusion_timer, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	GAME_LOGIC.get_node("player_logic/fusion_animation/tween_fusion").interpolate_property(GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_1"), "modulate", Color(1, 1, 1, 1), Color(10, 10, 10, 0.666), fusion_timer*0.9, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	GAME_LOGIC.get_node("player_logic/fusion_animation/tween_fusion").start()
	GAME_LOGIC.get_node("player_logic/player_timer").start(fusion_timer); yield(GAME_LOGIC.get_node("player_logic/player_timer"), "timeout")
	
	GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_0").hide()
	GAME_LOGIC.get_node("player_logic/fusion_animation/fusion_order_1").hide()
	GAME_LOGIC.get_node("player_logic/fusion_animation").hide()
	
	emit_signal("simulated_fusion_animation_finished")

func lifepoint_change_animation(signed_lifepoint : String, left_or_right : String):
	var animation_timer : float = 0.5
	
	#Setup the text to be shown on screen
	$lp_change_visuals/LP_damage.text = signed_lifepoint
	$lp_change_visuals/LP_damage.modulate  = Color(1,1,1,0)
	if left_or_right == "left":
		$lp_change_visuals/LP_damage.rect_position.x = 96
	elif left_or_right == "right":
		$lp_change_visuals/LP_damage.rect_position.x = 696
	
	#Delay for the start of animation so it syncs up with the battle animation
	$extra_timer_godot_sucks.start(animation_timer*1.8); yield($extra_timer_godot_sucks, "timeout")
	
	#Animate the text being shown
	$lp_change_visuals.show()
	$lp_change_visuals/lp_anim_tween.interpolate_property($lp_change_visuals/LP_damage, "modulate", Color(1,1,1, 0), Color(1,1,1, 1), animation_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$lp_change_visuals/lp_anim_tween.start()
	$effect_timer_node.start(animation_timer*1.5); yield($effect_timer_node, "timeout")
	
	#Animate the text fading away
	$lp_change_visuals/lp_anim_tween.interpolate_property($lp_change_visuals/LP_damage, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), animation_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$lp_change_visuals/lp_anim_tween.start()
	$effect_timer_node.start(animation_timer*1.5); yield($effect_timer_node, "timeout")
	$lp_change_visuals.hide()
	
	emit_signal("lifepoint_animation_finished")
	return true

####################################################################################################
# SPELL CARDS
####################################################################################################
func activate_spell_field(card_node : Node):
	#Initialize some variables
	var card_id = card_node.this_card_id
	var field_element = CardList.card_list[card_id].effect[0]
	
	#Do the visual changes on the field and text at top
	make_the_field_change(field_element)
	
	#Call for the field bonus function to update all monsters that will benefit from the new field
	field_bonus(field_element)
	
	return field_element

func make_the_field_change(attribute : String):
	#Change the text at the top
	if PlayerData.game_language == "en":
		GAME_LOGIC.get_parent().get_node("user_interface/top_info_box/field_info/field_name").text = GameLanguage.attributes[attribute][PlayerData.game_language].capitalize() + " Field"
	elif PlayerData.game_language == "pt":
		GAME_LOGIC.get_parent().get_node("user_interface/top_info_box/field_info/field_name").text = "Campo de " + GameLanguage.attributes[attribute][PlayerData.game_language].capitalize()
	
	#Change the color of the field to visually represent Field Change
	var new_field_color
	match attribute.to_lower():
		"fire":  new_field_color = Color("ff4a4a")
		"earth": new_field_color = Color("0ca528")
		"water": new_field_color = Color("1c68ff")
		"wind":  new_field_color = Color("4dedff")
		"dark":  new_field_color = Color("5100ff")
		"light": new_field_color = Color("ffef00")
		_: new_field_color = Color("ffffff")
	
	SoundControl.play_sound("poc_field")
	
	var field_texture1 = GAME_LOGIC.get_parent().get_node("duel_field/player_side_zones")
	var field_texture2 = GAME_LOGIC.get_parent(). get_node("duel_field/enemy_side_zones")
	field_texture1.self_modulate = new_field_color
	field_texture2.self_modulate = new_field_color

#This function can be called at any moment a new card might need to update it's field bonus, such as when it is summoned. Not only for when a field spell is activated.
func field_bonus(field_element : String):
	for i in range(5):
		for side_of_the_field in ["player_side_zones", "enemy_side_zones"]:
			var monster_being_checked = GAME_LOGIC.get_parent().get_node("duel_field/"+ side_of_the_field +"/monster_" + String(i))
			
			#A visible monster that matches the attribute will have it's field boost applied if it doesn't have it already
			if monster_being_checked.is_visible() and CardList.card_list[monster_being_checked.this_card_id].attribute == field_element and monster_being_checked.this_card_flags.has_field_boost == false:
				monster_being_checked.this_card_flags.has_field_boost = true
				monster_being_checked.this_card_flags.atk_up += 500
				monster_being_checked.this_card_flags.def_up -= 400
				monster_being_checked.update_card_information(monster_being_checked.this_card_id)
				
			#A monster that doesn't match the attribute might need it's field_boost reverted
			if CardList.card_list[monster_being_checked.this_card_id].attribute != field_element and monster_being_checked.this_card_flags.has_field_boost == true:
				monster_being_checked.this_card_flags.has_field_boost = false
				monster_being_checked.this_card_flags.atk_up -= 500
				monster_being_checked.this_card_flags.def_up += 400
				monster_being_checked.update_card_information(monster_being_checked.this_card_id)
	
	#After it has looped through all monsters on the field, return true
	return true

#Setting up a variable to be used by the two functions bellow
var equip_from_field_node : Node = null
func activate_spell_equip(card_node : Node): #Activating an equip on the field (that was set and was probably flipped now)
	#Check if the player has a monster on the field
	var player_has_at_least_one_monster = false
	var caller_and_target = get_caller_and_target(card_node)
	for i in range(5):
		var monster_being_checked = GAME_LOGIC.get_parent().get_node("duel_field/"+ caller_and_target[0] +"_side_zones/monster_" + String(i))
		if monster_being_checked.is_visible():
			player_has_at_least_one_monster = true
			break
	
	#Player has a monster, so the equip card can try to equip to it or just "miss" and be destroyed
	if player_has_at_least_one_monster:
		#Turn the equip card face up, supposing it was facedown before activation
		card_node.this_card_flags.is_facedown = false
		card_node.update_card_information(card_node.this_card_id)
		
		#Set the variable that is used by the function bellow 'equip_from_field_to_target'
		equip_from_field_node = card_node
		
		#Change the game_phase to a special one so "card_node" can be clicked and react to this effect
		GAME_LOGIC.GAME_PHASE = "activating_equip_from_field"
		
		#Show the indicators that the player has to click on a monster
		show_field_slots()
	else:
		#Player didn't have any monsters, the equip card will just miss
		emit_signal("effect_fully_executed") #Big Exception: Emit the signal here since so the game phases can keep going
		return "FAIL" #false as in the equip didn't work

func equip_from_field_to_target(target_card_node : Node):
	#Call the function the same way as if the equip was to be used from the player's hand
	var equip_result = GAME_LOGIC.fusing_cards_logic(target_card_node, equip_from_field_node) #equip_from_field_node is set by the function above
	
	#Hide the slots indicators
	$just_visual_field_slots.hide()
	
	#Call for the animation
	simulate_fusion_animation_resulting_in_card1(target_card_node, equip_from_field_node)
	yield(self, "simulated_fusion_animation_finished")
	
	#If the equip successeded, it will be returned as [monster_id : string, [status_to_agument : String, value_to_agument : int]]
	if typeof(equip_result[1]) == TYPE_ARRAY:
		#Look inside the array for [0] as the status info and [1] for the value
		match equip_result[1][0]:
			"atk_up", "def_up":
				target_card_node.this_card_flags[equip_result[1][0]] += equip_result[1][1]
			"stats_up":
				target_card_node.this_card_flags.atk_up += equip_result[1][1]
				target_card_node.this_card_flags.def_up += equip_result[1][1]
		
		#Special check for Equiping Ritual Weapon, since it can only be used on a Ritual Monster and those will only be Ritual Summoned (blue border) on the field
		if equip_result.size() > 2 and equip_result[2] == true and target_card_node.this_card_flags.fusion_type == "ritual":
			target_card_node.this_card_flags.atk_up += CardList.card_list["00991"].effect[1]
		
		#Final update on the card to visually reflect the status up
		target_card_node.update_card_information(target_card_node.this_card_id)
		GAME_LOGIC.get_parent().update_user_interface(target_card_node)
		
		SoundControl.play_sound("poc_equip")
		
	#This means the equip_result returned as [monster_id, False]
	else:
		print("Failed to equip. Results: ", equip_result)
	
	#Facedown cards will be forced face up, and trigger on_summon effects (Removed the ability to self trigger flip effects)
	target_card_node.this_card_flags.is_facedown = false
	target_card_node.update_card_information(target_card_node.this_card_id)
	
	if CardList.card_list[target_card_node.this_card_id].effect.size() > 0 and CardList.card_list[target_card_node.this_card_id].effect[0] in ["on_summon"] and target_card_node.this_card_flags.has_activated_effect == false:
		call_effect(target_card_node, CardList.card_list[target_card_node.this_card_id].effect[0])
	
	#Go back to regular main phase and FORCE the buttons to be shown
	GAME_LOGIC.get_parent().get_node("change_field_view/tween").interpolate_property(GAME_LOGIC.get_parent().get_node("change_field_view"), "rect_position", GAME_LOGIC.get_parent().get_node("change_field_view").rect_position, Vector2(1174, 276), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	GAME_LOGIC.get_parent().get_node("change_field_view/tween").start()
	GAME_LOGIC.get_parent().get_node("turn_end_button/tween").interpolate_property(GAME_LOGIC.get_parent().get_node("turn_end_button"), "rect_position", GAME_LOGIC.get_parent().get_node("turn_end_button").rect_position, Vector2(1174, 366), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	GAME_LOGIC.get_parent().get_node("turn_end_button/tween").start()
	GAME_LOGIC.GAME_PHASE = "main_phase"
	
	return typeof(equip_result[1]) == TYPE_ARRAY #returns TRUE for equip sucess, FALSE for equip failure

func activate_spell_generic(card_node : Node):
	var caller_and_target = get_caller_and_target(card_node)
	var type_of_effect = CardList.card_list[card_node.this_card_id].effect[0]
	
	match type_of_effect:
		"destroy_card":
			#The target is always an opposing card of some specific type
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			var target_type_of_destruction = CardList.card_list[card_node.this_card_id].effect[1]
			
			match target_type_of_destruction:
				"enemy_monsters", "enemy_spelltraps": #all of the opposing cards of that type
					var get_keyword = target_type_of_destruction.split("_")[1].trim_suffix("s") #returns 'monster' or 'spelltrap
					for i in range(5):
						var card_being_checked = target_side_of_field.get_node(get_keyword + "_" + String(i))
						if card_being_checked.is_visible():
							GAME_LOGIC.destroy_a_card(card_being_checked)
					return target_type_of_destruction + "destroyed."
					
				"fusion", "ritual": #Based on the color border
					#Get a list of possible targets to be randomly selected for destruction
					var list_of_possible_targets : Array = []
					for i in range(5):
						var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
						if card_being_checked.is_visible() and card_being_checked.this_card_flags.fusion_type == target_type_of_destruction:
							list_of_possible_targets.append(card_being_checked)
					
					if list_of_possible_targets.size() < 1:
						return "FAIL"
					else:
						randomize()
						var index_to_destroy = randi()%list_of_possible_targets.size()
						GAME_LOGIC.destroy_a_card(list_of_possible_targets[index_to_destroy])
						return CardList.card_list[list_of_possible_targets[index_to_destroy].this_card_id].card_name + " was destroyed."
					
				_: #Destroys all Monsters on opposing side based on it's types, i.e. Dragon, Zombie, Warrior, etc
					for i in range(5):
						var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
						if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == false and CardList.card_list[card_being_checked.this_card_id].type == target_type_of_destruction:
							GAME_LOGIC.destroy_a_card(card_being_checked)
					return target_type_of_destruction + "destroyed."
			
		"atk_down", "atk_up":
			#Currently we only have Skull Dice and Gracefull Dice for this kind of effects, so the value is actually random * +/-100
			randomize()
			var value_change : int = 1 + randi()%6 #returns between 1+0 and 1+5
			
			#ATK_DOWN targets the enemy monsters, ATK_UP targets the caller monsters
			var target_side_of_field : Node
			var dice_100s_multiplier : int #positive or negative 100 depending on effect
			if type_of_effect == "atk_down":
				target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
				dice_100s_multiplier = -100
			elif type_of_effect == "atk_up":
				target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
				dice_100s_multiplier = 100
			
			#Do the actual changes of stats for the monsters
			for i in range(5):
				var monster_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if monster_being_checked.is_visible() and monster_being_checked.this_card_flags.is_facedown == false:
					monster_being_checked.this_card_flags.atk_up += value_change * dice_100s_multiplier
					monster_being_checked.update_card_information(monster_being_checked.this_card_id)
			
			#print(value_change * dice_100s_multiplier)
			return String(value_change * dice_100s_multiplier)
			
		"power_bond": #Double the ATK of your strongest Fusion Machine, at the cost of the same amount of life points
			#Get the target
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
			var target_monster_node : Node = null
			var previous_highest_atk = 0
			
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if card_being_checked.is_visible() and card_being_checked.this_card_flags.fusion_type == "fusion" and CardList.card_list[card_being_checked.this_card_id].type == "machine":
					if int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text) >= previous_highest_atk:
						target_monster_node = card_being_checked
						previous_highest_atk = int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text)
			
			#If it finds a monster that matches the requirements, do the effect
			if target_monster_node != null:
				target_monster_node.this_card_flags.atk_up += previous_highest_atk
				target_monster_node.update_card_information(target_monster_node.this_card_id)
				
				#LP Cost
				GAME_LOGIC.change_lifepoints(caller_and_target[0], previous_highest_atk)
				
				return target_monster_node.get_node("card_design/monster_features/atk_def/atk").text
				
			else:
				return "FAIL"
			
		"block_attack", "stop_defense":
			#Always targets the opposing side of the field
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			
			#Do the changes on the targets
			for i in range(5):
				var monster_being_checked = target_side_of_field.get_node("monster_" + String(i))
				
				if monster_being_checked.is_visible():
					if type_of_effect == "block_attack" and monster_being_checked.this_card_flags.is_defense_position == false:
						monster_being_checked.toggle_battle_position() #handles the setting of the flag and the rotation
					elif type_of_effect == "stop_defense" and monster_being_checked.this_card_flags.is_defense_position == true:
						monster_being_checked.toggle_battle_position() #handles the setting of the flag and the rotation
					else:
						print(type_of_effect, " does nothing for def position equals to ", monster_being_checked.this_card_flags.is_defense_position)
			
			return type_of_effect + "finished."
			
		"sword_shield":
			for both_targets in ["player", "enemy"]:
				var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + both_targets + "_side_zones")
				
				for i in range(5):
					var monster_being_checked = target_side_of_field.get_node("monster_" + String(i))
					if monster_being_checked.is_visible() and monster_being_checked.this_card_flags.is_facedown == false:
						var registered_atk = int(monster_being_checked.get_node("card_design/monster_features/atk_def/atk").text)
						var registered_def = int(monster_being_checked.get_node("card_design/monster_features/atk_def/def").text)
						
						#if registered_atk > registered_def:
						monster_being_checked.this_card_flags.atk_up -= registered_atk - registered_def
						monster_being_checked.this_card_flags.def_up += registered_atk - registered_def
						#else:
						#	monster_being_checked.this_card_flags.atk_up += registered_atk - registered_def
						#	monster_being_checked.this_card_flags.def_up -= registered_atk - registered_def
							
						monster_being_checked.update_card_information(monster_being_checked.this_card_id)
			
			return type_of_effect
		
		"tokens":
			var token_quantity = CardList.card_list[card_node.this_card_id].effect[1]
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
			
			for _i in range(token_quantity):
				for j in [2,1,3,0,4]:
					var monster_being_checked = target_side_of_field.get_node("monster_" + String(j))
					if not monster_being_checked.is_visible():
						#Summon the resulting monster on the field
						monster_being_checked.this_card_id = String(int(card_node.this_card_id) + 1).pad_zeros(5)
						monster_being_checked.this_card_flags.fusion_type = "token"
						monster_being_checked.update_card_information(monster_being_checked.this_card_id)
						monster_being_checked.toggle_battle_position()
						monster_being_checked.show()
						break
			
			#Check for field bonus to update the tokens, since their "summoning" happens after this check is done by player_logic
			var field_name : String
			var field_element_colors = {
				"fire":  Color("ff4a4a"),
				"earth": Color("0ca528"),
				"water": Color("1c68ff"),
				"wind":  Color("4dedff"),
				"dark":  Color("5100ff"),
				"light": Color("ffef00"),
			}
			for attribute in field_element_colors.keys():
				var color = field_element_colors[attribute]
				if GAME_LOGIC.get_parent().get_node("duel_field/player_side_zones").self_modulate == color:
					field_name = attribute
					break
			field_bonus(field_name)
			
			return "tokens"
		
		"tokens_for_life", "tokens_for_damage":
			var value = 500
			
			#Count how many monsters on caller side of the field
			var number_of_monsters : int = 0
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if card_being_checked.is_visible() and card_being_checked.this_card_flags.fusion_type == "token":
					number_of_monsters += 1
			
			#To GIVE lifepoints I have to pass a third extra parameter as true
			var is_to_heal = CardList.card_list[card_node.this_card_id].effect[0] == "tokens_for_life" #smart way to reference it bellow
			GAME_LOGIC.change_lifepoints(caller_and_target[int(!is_to_heal)], value * number_of_monsters, is_to_heal)
			
			return "Token Heal: " + String(value * number_of_monsters)
		
		"change_of_heart":
			#Get a random monster from Enemy's Side of the Field
			var list_of_targets : Array = []
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if card_being_checked.is_visible():
					list_of_targets.append(card_being_checked)
			
			var monster_to_copy = null
			if list_of_targets.size() > 0:
				randomize()
				var random_target : Node = list_of_targets[randi()%list_of_targets.size()]
				monster_to_copy = random_target
			
			#If a monster could be found, summon it on player's side of the field and remove from Enemy
			if monster_to_copy != null:
				target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
				for i in [2,1,3,0,4]:
					var monster_being_checked = target_side_of_field.get_node("monster_" + String(i))
					if not monster_being_checked.is_visible():
						monster_being_checked.this_card_id = monster_to_copy.this_card_id
						monster_being_checked.this_card_flags = monster_to_copy.this_card_flags
						monster_being_checked.this_card_flags.is_defense_position = false
						monster_being_checked.this_card_flags.is_facedown = false
						monster_being_checked.this_card_flags.has_battled = false
						monster_being_checked.this_card_flags.multiple_attacks = 0
						monster_being_checked.update_card_information(monster_to_copy.this_card_id)
						monster_being_checked.show()
						GAME_LOGIC.destroy_a_card(monster_to_copy)
						break
			
			return "changed of heart"
		
		"special_description": #Magic Cards that are supposed to be used only for fusions, i.e. Metalmorph, Level Up, Toon World, Mask Change ...
			return "nothing"

func activate_spell_ritual(card_node : Node):
	#Ritual will look for one monster with a specific type, and more monsters to Sum the star level of result
	var ritual_result_monster_id = String(CardList.card_list[card_node.this_card_id].effect[1]).pad_zeros(5)
	var ritual_type_restriction = CardList.card_list[ritual_result_monster_id].type
	var ritual_level_goal = CardList.card_list[ritual_result_monster_id].level
	
	#First restriction: caller has a correct type for the sacrifice
	var caller_and_target = get_caller_and_target(card_node)
	var monster_with_type_restriction : Node = null
	for i in range(5):
		var monster_being_checked = GAME_LOGIC.get_parent().get_node("duel_field/"+ caller_and_target[0] +"_side_zones/monster_" + String(i))
		if monster_being_checked.is_visible() and CardList.card_list[monster_being_checked.this_card_id].type == ritual_type_restriction:
			monster_with_type_restriction = monster_being_checked
			break
	if monster_with_type_restriction == null:
		return "FAIL"
	
	#Second restriction: caller will have enough monsters to sum the level goal (or more)
	var temp_level_array : Array = []
	for i in range(5):
		if GAME_LOGIC.get_parent().get_node("duel_field/"+ caller_and_target[0] +"_side_zones/monster_" + String(i)).is_visible():
			var monster_level = CardList.card_list[GAME_LOGIC.get_parent().get_node("duel_field/"+ caller_and_target[0] +"_side_zones/monster_" + String(i)).this_card_id].level
			temp_level_array.append(monster_level)
	temp_level_array.sort()
	
	#print("temp level array: ", temp_level_array)
	
	var monsters_sorted_by_level : Array = []
	for i in range(temp_level_array.size()):
		for j in range(5):
			if temp_level_array[i] == CardList.card_list[GAME_LOGIC.get_parent().get_node("duel_field/"+ caller_and_target[0] +"_side_zones/monster_" + String(j)).this_card_id].level and GAME_LOGIC.get_parent().get_node("duel_field/"+ caller_and_target[0] +"_side_zones/monster_" + String(j)).is_visible():
				if not monsters_sorted_by_level.has(GAME_LOGIC.get_parent().get_node("duel_field/"+ caller_and_target[0] +"_side_zones/monster_" + String(j))):
					monsters_sorted_by_level.append(GAME_LOGIC.get_parent().get_node("duel_field/"+ caller_and_target[0] +"_side_zones/monster_" + String(j)))
	
	#print("monsters sorted by level: ", monsters_sorted_by_level)
	
	#Remove from the sorted array the first sacrificial monster possible
	var sacrificial_monster : Node
	for i in range(monsters_sorted_by_level.size()):
		if CardList.card_list[monsters_sorted_by_level[i].this_card_id].type == ritual_type_restriction:
			sacrificial_monster = monsters_sorted_by_level[i]
			monsters_sorted_by_level.erase(monsters_sorted_by_level[i])
			break
	
	#print("sacrificial monster: ", sacrificial_monster)
	#print("monsters_sorted_by_level removed it: ", monsters_sorted_by_level)
	
	var level_reached : int = CardList.card_list[sacrificial_monster.this_card_id].level
	var extra_sacrificed = []
	
	#print(level_reached)
	#print(ritual_level_goal)
	
	if level_reached < ritual_level_goal:
		#look for more monsters until goal is reached
		for _i in range(monsters_sorted_by_level.size()):
			var lowest_level_in_array = CardList.card_list[monsters_sorted_by_level[0].this_card_id].level
			level_reached += lowest_level_in_array
			
			var monster_popped = monsters_sorted_by_level.pop_front()
			extra_sacrificed.append(monster_popped)
			
			if level_reached >= ritual_level_goal or monsters_sorted_by_level.size() == 0:
				break
	
	#DO THE RITUAL SUMMON FINALLY
	if level_reached >= ritual_level_goal:
		#Remove from the field the obligatory sacrificial monsters
		GAME_LOGIC.destroy_a_card(sacrificial_monster)
		#Remove from the field any other monsters that were sacrificed with it
		if extra_sacrificed.size() > 0:
			for i in range(extra_sacrificed.size()):
				GAME_LOGIC.destroy_a_card(extra_sacrificed[i])
		
		#Summon the resulting monster on the field
		sacrificial_monster.this_card_id = ritual_result_monster_id
		sacrificial_monster.this_card_flags.fusion_type = "ritual"
		sacrificial_monster.update_card_information(sacrificial_monster.this_card_id)
		sacrificial_monster.show()
		
		#Call for monster field bonus and effects
		var field_name : String
		var field_element_colors = {
			"fire":  Color("ff4a4a"),
			"earth": Color("0ca528"),
			"water": Color("1c68ff"),
			"wind":  Color("4dedff"),
			"dark":  Color("5100ff"),
			"light": Color("ffef00"),
		}
		for attribute in field_element_colors.keys():
			var color = field_element_colors[attribute]
			if GAME_LOGIC.get_parent().get_node("duel_field/player_side_zones").self_modulate == color:
				field_name = attribute
				break
		field_bonus(field_name)
		
		if CardList.card_list[ritual_result_monster_id].effect.size() > 0:
			GAME_LOGIC.effect_activation(sacrificial_monster, "on_summon")
			#yield(get_node("../effects"), "effect_fully_executed")
		
		ritual_effects_activation(sacrificial_monster, "on_ritual_summon")
		
		return ritual_result_monster_id
		
	else:
		#Couldn't match the level needed, ritual will just fail and card disappears
		return "FAIL"

####################################################################################################
# TRAP CARDS
####################################################################################################
func activate_trap(card_node : Node):
	var caller_and_target = get_caller_and_target(card_node)
	var type_of_effect = CardList.card_list[card_node.this_card_id].effect[0]
	var current_attacker = GAME_LOGIC.card_ready_to_attack
	var current_defender = GAME_LOGIC.card_ready_to_defend
	
	if current_attacker == null or not card_node.is_visible():
		print("escaping from problematic trap activation")
		return "Fail"
	
	match type_of_effect:
		"negate_attacker": #just negate the attack
			pass #The very logic of just activating a trap card already stops the attack, this does nothing else
		
		"magic_cylinder": #negate the attack and damage LP of attacker
			var attacker_attack = int(current_attacker.get_node("card_design/monster_features/atk_def/atk").text)
			GAME_LOGIC.change_lifepoints(caller_and_target[1], attacker_attack)
		
		"enchanted_javelin":
			var attacker_attack = int(current_attacker.get_node("card_design/monster_features/atk_def/atk").text)
			GAME_LOGIC.change_lifepoints(caller_and_target[0], attacker_attack, true)
		
		"destroy_attacker": #destroy the attacker if it has less or equal than effect[1] atk points
			var attacker_attack = int(current_attacker.get_node("card_design/monster_features/atk_def/atk").text)
			
			if attacker_attack <= CardList.card_list[card_node.this_card_id].effect[1]:
				GAME_LOGIC.destroy_a_card(current_attacker)
		
		"ring_of_destruction": #destroy the attacker and damage it's ATK on attackers LP
			var attacker_attack = int(current_attacker.get_node("card_design/monster_features/atk_def/atk").text)
			
			var COM_LP = get_node("../../user_interface/top_info_box/com_info/lifepoints").get_text()
			get_node("../../user_interface/top_info_box/com_info/lifepoints").text = String( clamp(int(COM_LP) - attacker_attack, 0, 9999) )
			GAME_LOGIC.change_lifepoints(caller_and_target[0], attacker_attack)
			
			GAME_LOGIC.destroy_a_card(current_attacker)
		
		"mirror_force": #destroy all monsters from attacker
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			for i in range(5):
				var monster_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if monster_being_checked.is_visible() and monster_being_checked.this_card_flags.is_defense_position == false:
					GAME_LOGIC.destroy_a_card(monster_being_checked)
		
		"copy_as_token":
			#Summon a copy of the attacking monster as a Token on player's side of the field
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
			#print("copy_as_token caller: ", caller_and_target)
			
			for i in [2,1,3,0,4]:
				var monster_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if not monster_being_checked.is_visible():
					monster_being_checked.this_card_flags.fusion_type = "token"
					monster_being_checked.update_card_information(current_attacker.this_card_id)
					monster_being_checked.show()
					break
		
		"transform_in_token":
			#Substitutes the attacking monster for a Token with half of it's strenght
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			for i in range(5):
				var monster_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if monster_being_checked == current_attacker:
					monster_being_checked.this_card_flags.fusion_type = "token"
					monster_being_checked.this_card_flags.atk_up -= int(current_attacker.get_node("card_design/monster_features/atk_def/atk").text)/2.0
					monster_being_checked.this_card_flags.def_up -= int(current_attacker.get_node("card_design/monster_features/atk_def/def").text)/2.0
					monster_being_checked.update_card_information(current_attacker.this_card_id)
					break
		
		"fortify_tokens":
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if card_being_checked.is_visible() and card_being_checked.this_card_flags.fusion_type == "token":
					#card_being_checked.this_card_flags.atk_up += 1000
					card_being_checked.this_card_flags.def_up += 1000
					card_being_checked.update_card_information(card_being_checked.this_card_id)
		
		"waboku":
			#Set 'waboku_protection' = true on game_logic for one turn only, this will prevent change_lifepoints() from reducing LP
			get_node("../").waboku_protection = true
		
		"gift_of_elf":
			#Give LP = 300 * number of monsters on both sides of the field
			var monster_count = 0
			for side in ["player", "enemy"]:
				var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + side + "_side_zones")
				for i in range(5):
					var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
					if card_being_checked.is_visible():
						monster_count += 1
			GAME_LOGIC.change_lifepoints(caller_and_target[0], 300 * monster_count, true)
		
		"fire_darts":
			#Roll a Dice, damage opponente with 300 times it's result
			randomize()
			var dice_roll : int = 1 + randi()%6 #returns between 1+0 and 1+5
			var damage_value = 300 * dice_roll
			GAME_LOGIC.change_lifepoints(caller_and_target[1], damage_value)
		
		"battle_trap": #reinforcements (for atk) and castle walls (for def)
			var status_to_increase = ""
			if CardList.card_list[card_node.this_card_id].card_name == "Reinforcements":
				status_to_increase = "atk_up"
			elif CardList.card_list[card_node.this_card_id].card_name == "Castle Walls":
				status_to_increase = "def_up"
			
			if current_defender != null:
				current_defender.this_card_flags[status_to_increase] += 500
				current_defender.update_card_information(current_defender.this_card_id)
		
		"reveal_face_down": #flip monsters that are face down, without calling their effects
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == true:
					card_being_checked.this_card_flags.is_facedown = false
					card_being_checked.update_card_information(card_being_checked.this_card_id)
	
	return "trapped!"

####################################################################################################
# MONSTER CARDS
####################################################################################################
func monster_on_summon(card_node : Node):
	var card_id : String = card_node.this_card_id
	var type_of_effect = CardList.card_list[card_id].effect[1]
	
	#Do an initial check to see if this card isn't triggering it's effect for a second time
	if card_node.this_card_flags.has_activated_effect == true:
		return "FAIL"
	#Set this flag
	card_node.this_card_flags.has_activated_effect = true
	
	#Get proper keywords to use in the logics bellow
	var caller_and_target : Array = get_caller_and_target(card_node) #[caller, target]
	
	#THE EFFECTS LOGIC
	match type_of_effect:
		#STATUS BONUS TYPES OF EFFECT
		"attribute_booster":
			#Boosts all the monsters with the same attribute as it, debuff the ones with opposite
			var positive_attribute = CardList.card_list[card_id].attribute
			var negative_attribute : String
			match positive_attribute:
				"dark": negative_attribute = "light"
				"light": negative_attribute = "dark"
				"water": negative_attribute = "fire"
				"fire": negative_attribute = "water"
				"earth": negative_attribute = "wind"
				"wind": negative_attribute = "earth"
			
			for both_targets in ["player", "enemy"]:
				var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + both_targets + "_side_zones")
				for i in range(5):
					var monster_target = target_side_of_field.get_node("monster_" + String(i))
					#UP for positive attribute
					if monster_target.is_visible() and monster_target.this_card_flags.is_facedown == false and CardList.card_list[monster_target.this_card_id].attribute == positive_attribute:
						monster_target.this_card_flags.atk_up += 500
						monster_target.update_card_information(monster_target.this_card_id)
					#DOWN for negative attribute
					if monster_target.is_visible() and monster_target.this_card_flags.is_facedown == false and CardList.card_list[monster_target.this_card_id].attribute == negative_attribute:
						monster_target.this_card_flags.atk_up -= 400
						monster_target.update_card_information(monster_target.this_card_id)
			
			return "attribute boosted"
		
		"friends_power_up":
			var friendly_type : String = CardList.card_list[card_id].type
			var boost_value : int = CardList.card_list[card_id].effect[2]
			
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
			for i in range(5):
				var monster_target = target_side_of_field.get_node("monster_" + String(i))
				if monster_target.is_visible() and monster_target.this_card_flags.is_facedown == false and CardList.card_list[monster_target.this_card_id].type == friendly_type and monster_target != card_node:
					monster_target.this_card_flags.atk_up += boost_value
					monster_target.this_card_flags.def_up += boost_value
					monster_target.update_card_information(monster_target.this_card_id)
			
			return "friends powered up"
		
		"castle_power_up": #Power up both Zombies and Fiends
			var friendly_type = ["fiend", "zombie"]
			var boost_value : int = CardList.card_list[card_id].effect[2]
			
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
			for i in range(5):
				var monster_target = target_side_of_field.get_node("monster_" + String(i))
				if monster_target.is_visible() and monster_target.this_card_flags.is_facedown == false and CardList.card_list[monster_target.this_card_id].type in friendly_type and monster_target != card_node:
					monster_target.this_card_flags.atk_up += boost_value
					monster_target.this_card_flags.def_up += boost_value
					monster_target.update_card_information(monster_target.this_card_id)
			
			return "Fiends and Zombies powered up"
		
		"self_power_up":
			#Get the value that will be used based on the [2] element of the card effect
			var boost_value : int
			match CardList.card_list[card_id].effect[2]:
				"same_attribute": 
					var count_attribute_on_field : int = 0
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
					for i in range(5):
						var monster_target = target_side_of_field.get_node("monster_" + String(i))
						if monster_target.is_visible() and monster_target.this_card_flags.is_facedown == false and CardList.card_list[monster_target.this_card_id].attribute == CardList.card_list[card_id].attribute and monster_target != card_node:
							count_attribute_on_field += 1
					
					boost_value = 500 * count_attribute_on_field
				
				"buster_blader":
					var count_type_on_field : int = 0
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
					for i in range(5):
						var monster_target = target_side_of_field.get_node("monster_" + String(i))
						if monster_target.is_visible() and monster_target.this_card_flags.is_facedown == false and CardList.card_list[monster_target.this_card_id].type == "dragon":
							count_type_on_field += 1
					
					boost_value = 500 * count_type_on_field
				
				"spelltrap_count":
					var count_spelltrap_on_field : int = 0
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
					for i in range(5):
						var spelltrap_target = target_side_of_field.get_node("spelltrap_" + String(i))
						if spelltrap_target.is_visible():
							count_spelltrap_on_field += 1
					
					boost_value = 500 * count_spelltrap_on_field
				
				"random_dice":
					randomize()
					var dice_roll : int = 1 + randi()%6 #returns between 1+0 and 1+5
					boost_value = 100 * dice_roll
				
				_: #Just an int value to be passed ahead
					var count_type_on_field : int = 0
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
					for i in range(5):
						var monster_target = target_side_of_field.get_node("monster_" + String(i))
						if monster_target.is_visible() and monster_target.this_card_flags.is_facedown == false and CardList.card_list[monster_target.this_card_id].type == CardList.card_list[card_id].type and monster_target != card_node:
							count_type_on_field += 1
					
					boost_value = CardList.card_list[card_id].effect[2] * count_type_on_field
			
			#Update the card itself
			card_node.this_card_flags.atk_up += boost_value
			card_node.this_card_flags.def_up += boost_value
			card_node.update_card_information(card_node.this_card_id)
			
			return "self powered up"
		
		"count_as_power_up":
			var count_as_type : String = CardList.card_list[card_id].count_as
			var boost_value : int
			
			var count_as_on_field : int = 0
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
			for i in range(5):
				var monster_target = target_side_of_field.get_node("monster_" + String(i))
				if monster_target.is_visible() and monster_target.this_card_flags.is_facedown == false and CardList.card_list[monster_target.this_card_id].count_as == count_as_type and monster_target != card_node:
					count_as_on_field += 1
			
			boost_value = CardList.card_list[card_id].effect[2] * count_as_on_field
			
			#Update the card itself
			card_node.this_card_flags.atk_up += boost_value
			card_node.update_card_information(card_node.this_card_id)
			
			return "archetype powered up"
		
		"monster_count_boost":
			var monsters_on_field : int = 0
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
			for i in range(5):
				var monster_target = target_side_of_field.get_node("monster_" + String(i))
				if monster_target.is_visible() and monster_target != card_node:
					monsters_on_field += 1
			
			var boost_value = CardList.card_list[card_id].effect[2] * monsters_on_field
			
			#Update the card itself
			card_node.this_card_flags.atk_up += boost_value
			card_node.update_card_information(card_node.this_card_id)
			
			return "self powered up with any monster on the field"
		
		"graveyard_power_up":
			#Get the remaining cards on the deck when this effect is activated
			var who_is = caller_and_target[0]
			if who_is == "enemy":
				who_is = "com"
			var current_deck_size = get_node("../../user_interface/top_info_box/"+ who_is +"_info/deck").get_text()
			
			#Effect was simplified to just be Deck - Out of Deck * value
			var card_count = 40 - int(current_deck_size)
			var boost_value = card_count * CardList.card_list[card_id].effect[2]
			
			#Update the card itself
			card_node.this_card_flags.atk_up += boost_value
			card_node.this_card_flags.def_up += boost_value
			card_node.update_card_information(card_node.this_card_id)
			
			return "self powered up by counting cards out of the deck"
		
		"deck_for_stat":
			#Get the Deck reference
			var who_is = caller_and_target[0]
			var deck : Array = GAME_LOGIC.get_node("player_logic").player_deck
			if who_is == "enemy":
				who_is = "com"
				deck = GAME_LOGIC.get_node("enemy_logic").enemy_deck
			var current_deck_size = int(get_node("../../user_interface/top_info_box/"+ who_is +"_info/deck").get_text())
			
			#Remove up to 3 cards from the deck, if it has enough
			var cards_removed : int = 0
			for _i in range(3):
				if current_deck_size - 1 >= 0:
					deck.remove(0) #remove that same card from deck
					get_node("../../user_interface/top_info_box/"+ who_is +"_info/deck").text = String(deck.size())
					cards_removed += 1
			
			#Update the card itself
			var boost_value = cards_removed * 500
			match CardList.card_list[card_id].effect[2]:
				"atk": card_node.this_card_flags.atk_up += boost_value
				"def": card_node.this_card_flags.def_up += boost_value
			card_node.update_card_information(card_node.this_card_id)
			
			return String(cards_removed)
		
		"equip_boost":
			#Count for 300 multiples since that is the lowest equipment possible
			var number_of_equips = card_node.this_card_flags.atk_up / 300
			#Remove one 500 boost from field, seems to make sense like that. Power ups by other monsters effect will still count, but that's okay for now
			if card_node.this_card_flags.has_field_boost == true:
				number_of_equips -= 1
			#Kinda nerf the Megamorph being 3*300 so it will count only as two equips instead of 3
			var megamorph_multipliers = ceil(card_node.this_card_flags.atk_up / 750) #Use the rounding to guess if there is a megamorph involved. Works pretty well.
			number_of_equips -= 1 * megamorph_multipliers
			
			card_node.this_card_flags.atk_up += 500 * number_of_equips
			card_node.update_card_information(card_node.this_card_id)
			
			return "equip boosted"
		
		"super_robo": #power up itself and the opposing gender super robo
			var robo_power_up_value = 1000
			var this_robo_name = CardList.card_list[card_node.this_card_id].card_name
			var other_robo_name = "Super Robolady"
			if this_robo_name == "Super Robolady":
				other_robo_name = "Super Roboyarou"
			
			#Self power Up
			card_node.this_card_flags.atk_up += robo_power_up_value
			card_node.update_card_information(card_node.this_card_id)
			
			#Other gender robos on the field power up
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
			for i in range(5):
				var monster_target = target_side_of_field.get_node("monster_" + String(i))
				if monster_target.is_visible() and monster_target.this_card_flags.is_facedown == false and CardList.card_list[monster_target.this_card_id].card_name == other_robo_name:
					monster_target.this_card_flags.atk_up += robo_power_up_value
					monster_target.update_card_information(monster_target.this_card_id)
			
			return "super robo"
		
		#CARD DESTRUCTION TYPES OF EFFECT
		"destroy_card":
			var destruction_target = CardList.card_list[card_id].effect[2]
			match destruction_target:
				"all_enemy_monsters", "all_enemy_spelltraps":
					var get_keyword = destruction_target.split("_")[2].trim_suffix("s") #returns 'monster' or 'spelltrap
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
					
					for i in range(5):
						var card_being_checked = target_side_of_field.get_node(get_keyword + "_" + String(i))
						if card_being_checked.is_visible():
							GAME_LOGIC.destroy_a_card(card_being_checked)
					
					return destruction_target + " destroyed."
				
				"random_monster", "random_spelltrap":
					var list_of_targets : Array = []
					var get_keyword = destruction_target.split("_")[1].trim_suffix("s") #returns 'monster' or 'spelltrap
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
					
					for i in range(5):
						var card_being_checked = target_side_of_field.get_node(get_keyword + "_" + String(i))
						if card_being_checked.is_visible():
							list_of_targets.append(card_being_checked)
					
					if list_of_targets.size() > 0:
						randomize()
						var random_target = list_of_targets[randi()%list_of_targets.size()]
						GAME_LOGIC.destroy_a_card(random_target)
						
						return "randomly destroyed"
					else:
						return "FAIL , no target to destroy"
				
				"atk_highest":
					var list_of_monsters : Array = []
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
					
					#List all of the targetable monsters
					for i in range(5):
						var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
						if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == false:
							list_of_monsters.append(card_being_checked)
					
					#Sort them by ATK
					var temp_atk_array = []
					for i in range(list_of_monsters.size()):
						temp_atk_array.append(int(list_of_monsters[i].get_node("card_design/monster_features/atk_def/atk").text))
					temp_atk_array.sort()
					
					var list_of_monsters_sorted_by_ATK = []
					for i in range(temp_atk_array.size()):
						for j in range(list_of_monsters.size()):
							if temp_atk_array[i] == int(list_of_monsters[j].get_node("card_design/monster_features/atk_def/atk").text) and !(list_of_monsters_sorted_by_ATK.has(list_of_monsters[j])):
								list_of_monsters_sorted_by_ATK.append(list_of_monsters[j])
					list_of_monsters_sorted_by_ATK.invert() #for some reason that is unclear to me right now, I had to invert to get the expected order from Highest to Lowest
					
					#Destroy the Highest ATK monster
					if list_of_monsters_sorted_by_ATK.size() > 0:
						GAME_LOGIC.destroy_a_card(list_of_monsters_sorted_by_ATK[0])
						
						return "highest atk monster destroyed"
					else:
						return "FAIL , no target to destroy"
				
				"dragon":
					var list_of_targets : Array = []
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
					
					for i in range(5):
						var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
						if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == false and CardList.card_list[card_being_checked.this_card_id].type == destruction_target:
							list_of_targets.append(card_being_checked)
					
					if list_of_targets.size() > 0:
						randomize()
						var random_target = list_of_targets[randi()%list_of_targets.size()]
						GAME_LOGIC.destroy_a_card(random_target)
						
						return "randomly destroyed a " + destruction_target + " monster."
					else:
						return "FAIL , no target to destroy"
		
		"attribute_reptile":
			#Destroys all monsters that don't match the attribute of this reptile monster, even player's
			var reptile_attribute = CardList.card_list[card_id].attribute
			
			for both_sides in ["player_side_zones", "enemy_side_zones"]:
				var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + both_sides)
				for i in range(5):
					var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
					if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == false and CardList.card_list[card_being_checked.this_card_id].attribute != reptile_attribute:
						GAME_LOGIC.destroy_a_card(card_being_checked)
		
		#SPECIFIC TYPES OF EFFECT
		"honest": #gives 1000 ATK to a random monster with same attribute as it
			var attribute_to_compare = CardList.card_list[card_node.this_card_id].attribute
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
			
			var list_of_targets : Array = []
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == false and CardList.card_list[card_being_checked.this_card_id].attribute == attribute_to_compare:
					list_of_targets.append(card_being_checked)
			
			if list_of_targets.size() > 0:
				randomize()
				var random_target = list_of_targets[randi()%list_of_targets.size()]
				random_target.this_card_flags.atk_up += 1000
				random_target.update_card_information(random_target.this_card_id)
				return "honest worked"
			else:
				return "honest failed" #never will, it can target itself lol
		
		"copy_atk":
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			
			#List all of the targetable monsters
			var highest_atk = 0
			var associated_def = 0
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == false:
					if int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text) >= highest_atk:
						highest_atk = int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text)
						associated_def = int(card_being_checked.get_node("card_design/monster_features/atk_def/def").text)
			
			#Update the copycat card
			if highest_atk > 0:
				#I have to subtract the original atk before adding the new one
				card_node.this_card_flags.atk_up -= CardList.card_list[card_node.this_card_id].atk #int(card_node.get_node("card_design/monster_features/atk_def/atk").text)
				card_node.this_card_flags.atk_up += highest_atk
				card_node.this_card_flags.def_up -= CardList.card_list[card_node.this_card_id].def #int(card_node.get_node("card_design/monster_features/atk_def/def").text)
				card_node.this_card_flags.def_up += associated_def
				card_node.update_card_information(card_node.this_card_id)
			
			return "atk copied"
		
		"air_neos":
			var caller = "player"
			var target = "com"
			if caller_and_target[0] == "enemy":
				caller = "com"
				target = "player"
			
			var caller_lifepoints = int(GAME_LOGIC.get_parent().get_node("user_interface/top_info_box/"+ caller +"_info/lifepoints").get_text())
			var target_lifepoints = int(GAME_LOGIC.get_parent().get_node("user_interface/top_info_box/"+ target +"_info/lifepoints").get_text())
			var difference = abs(caller_lifepoints - target_lifepoints)
			
			#Update air neos ATK by the difference
			card_node.this_card_flags.atk_up += difference
			card_node.update_card_information(card_node.this_card_id)
			
			return "air neos"
		
		"cyber_stein": #If the caller can pay 5000 LP, the strongest card in the deck is summoned to the field
			var lifepoints : int = int(GAME_LOGIC.get_parent().get_node("user_interface/top_info_box/player_info/lifepoints").get_text())
			var caller_deck : Array = GAME_LOGIC.get_node("player_logic").player_deck
			if caller_and_target[0] == "enemy":
				lifepoints = int(GAME_LOGIC.get_parent().get_node("user_interface/top_info_box/com_info/lifepoints").get_text())
				caller_deck = GAME_LOGIC.get_node("enemy_logic").enemy_deck
			
			var highest_attack_card_id : String = ""
			if lifepoints > 5000:
				var ref_atk : int = 0
				for card in caller_deck:
					if not CardList.card_list[card].attribute in ["spell", "trap"] and CardList.card_list[card].atk > ref_atk:
						highest_attack_card_id = card
						ref_atk = CardList.card_list[card].atk
			
			if highest_attack_card_id != "":
				#Pay the LP cost
				GAME_LOGIC.change_lifepoints(caller_and_target[0], 5000)
				#Transform Cyber-Stein into the strongest card found
				card_node.update_card_information(highest_attack_card_id)
				#Remove that card from the deck
				caller_deck.erase(highest_attack_card_id)
				#Update deck count
				var deck_fix = "player"
				if caller_and_target[0] == "enemy": deck_fix = "com"
				GAME_LOGIC.get_parent().get_node("user_interface/top_info_box/"+ deck_fix +"_info/deck").text = String(caller_deck.size())
			
			return "Cyber-Stein transformed"
		
		"stop_defense":
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			
			#Do the changes on the targets
			for i in range(5):
				var monster_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if monster_being_checked.is_visible() and monster_being_checked.this_card_flags.is_defense_position == true:
					monster_being_checked.toggle_battle_position() #handles the setting of the flag and the rotation
			
			return type_of_effect + "finished."
		
		"flip_enemy_down":
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			
			#Get a random target to be flipped facedown and defense position
			var list_of_targets : Array = []
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == false:
					list_of_targets.append(card_being_checked)
			
			if list_of_targets.size() > 0:
				randomize()
				var random_target = list_of_targets[randi()%list_of_targets.size()]
				
				random_target.this_card_flags.is_facedown = true
				random_target.this_card_flags.atk_up = 0
				random_target.this_card_flags.def_up = 0
				random_target.this_card_flags.has_activated_effect = false
				if random_target.this_card_flags.is_defense_position == false:
					random_target.toggle_battle_position()
				
				#Update the card
				random_target.update_card_information(random_target.this_card_id)
			
			return "enemy flipped down"
		
		"jinzo":
			var damage_value : int = CardList.card_list[card_node.this_card_id].effect[2]
			var number_of_cards_destroyed : int = 0
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("spelltrap_" + String(i))
				if card_being_checked.is_visible():
					GAME_LOGIC.destroy_a_card(card_being_checked)
					number_of_cards_destroyed += 1
			
			#Deal the damage with Jinzo-Lord, Regular Jinzo has damage_value 0 so it's irrelevant
			GAME_LOGIC.change_lifepoints(caller_and_target[1], damage_value * number_of_cards_destroyed)
			
			return "Jinzo cleared the board"
		
		"gandora":
			var lifepoints : int = int(GAME_LOGIC.get_parent().get_node("user_interface/top_info_box/player_info/lifepoints").get_text())
			if caller_and_target[0] == "enemy":
				lifepoints = int(GAME_LOGIC.get_parent().get_node("user_interface/top_info_box/com_info/lifepoints").get_text())
			
			#Pay half of the LP
			GAME_LOGIC.change_lifepoints(caller_and_target[0], float(lifepoints)/2)
			
			#Destroy all Monsters on the field
			var number_of_cards_destroyed : int = 0
			for both_sides in ["player_side_zones", "enemy_side_zones"]:
				var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + both_sides)
				for i in range(5):
					var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
					if card_being_checked.is_visible() and card_being_checked != card_node:
						GAME_LOGIC.destroy_a_card(card_being_checked)
						number_of_cards_destroyed += 1
			
			#Up the stats of Gandora
			card_node.this_card_flags.atk_up += 300 * number_of_cards_destroyed
			card_node.this_card_flags.def_up += 300 * number_of_cards_destroyed
			card_node.update_card_information(card_node.this_card_id)
			
			return "gandora"
		
		"white_horned":
			#Destroy all Spell and Traps on opponents field
			var number_of_cards_destroyed : int = 0
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("spelltrap_" + String(i))
				if card_being_checked.is_visible():
					GAME_LOGIC.destroy_a_card(card_being_checked)
					number_of_cards_destroyed += 1
			
			#Up the stats of the monster
			card_node.this_card_flags.atk_up += 300 * number_of_cards_destroyed
			card_node.this_card_flags.def_up += 300 * number_of_cards_destroyed
			card_node.update_card_information(card_node.this_card_id)
			
			return "white-horned dragon"
		
		"lifepoint_up":
			var value = CardList.card_list[card_node.this_card_id].effect[2]
			
			#To GIVE lifepoints I have to pass a third extra parameter as true
			GAME_LOGIC.change_lifepoints(caller_and_target[0], value, true)
			
			return "life up"
		
		"lifeup_monster_count", "damage_monster_count":
			var value = CardList.card_list[card_node.this_card_id].effect[2]
			
			#Count how many monsters on caller side of the field
			var number_of_monsters : int = 0
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if card_being_checked.is_visible():
					number_of_monsters += 1
			
			#To GIVE lifepoints I have to pass a third extra parameter as true
			var is_to_heal = CardList.card_list[card_node.this_card_id].effect[1] == "lifeup_monster_count" #smart way to reference it bellow
			GAME_LOGIC.change_lifepoints(caller_and_target[int(!is_to_heal)], value * number_of_monsters, is_to_heal)
			
			return "Is to Heal: " + String(is_to_heal)
		
		"mill":
			var card_quantity = CardList.card_list[card_node.this_card_id].effect[2]
			
			#Get the Deck reference
			var target_is = caller_and_target[1]
			var deck : Array = GAME_LOGIC.get_node("player_logic").player_deck
			if target_is == "enemy":
				target_is = "com"
				deck = GAME_LOGIC.get_node("enemy_logic").enemy_deck
			var current_deck_size = int(get_node("../../user_interface/top_info_box/"+ target_is +"_info/deck").get_text())
			
			#Remove cards from the deck, if it has enough
			var cards_removed : int = 0
			for _i in range(card_quantity):
				if current_deck_size > 0:
					deck.remove(0) #remove that same card from deck
					get_node("../../user_interface/top_info_box/"+ target_is +"_info/deck").text = String(deck.size())
					cards_removed += 1
			
			return String(cards_removed)
		
		"summon_pharaoh":
			var friend_card_id_1 = String(CardList.card_list[card_node.this_card_id].effect[2]).pad_zeros(5)
			var friend_card_id_2 = String(CardList.card_list[card_node.this_card_id].effect[3]).pad_zeros(5)
			
			#Summon one friend on field
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
			for summons in [friend_card_id_1, friend_card_id_2]:
				for i in [2,1,3,0,4]:
					var monster_being_checked = target_side_of_field.get_node("monster_" + String(i))
					if not monster_being_checked.is_visible():
						#Summon the resulting monster on the field
						monster_being_checked.this_card_id = summons
						monster_being_checked.update_card_information(monster_being_checked.this_card_id)
						monster_being_checked.show()
						break
			
			return "summoned friend"
		
		"monster_change_field": #THIS IS A COPY OF THE ACTIVATE_SPELL_FIELD
			var monster_attribute = CardList.card_list[card_node.this_card_id].attribute
			
			#Change the text at the top
			GAME_LOGIC.get_parent().get_node("user_interface/top_info_box/field_info/field_name").text = monster_attribute.capitalize() + " bonus"
			
			#Change the color of the field to visually represent Field Change
			var new_field_color
			match monster_attribute.to_lower():
				"fire":  new_field_color = Color("ff4a4a")
				"earth": new_field_color = Color("0ca528")
				"water": new_field_color = Color("1c68ff")
				"wind":  new_field_color = Color("4dedff")
				"dark":  new_field_color = Color("5100ff")
				"light": new_field_color = Color("ffef00")
				_: new_field_color = Color("ffffff")
			
			SoundControl.play_sound("poc_field")
			
			var field_texture1 = GAME_LOGIC.get_parent().get_node("duel_field/player_side_zones")
			var field_texture2 = GAME_LOGIC.get_parent(). get_node("duel_field/enemy_side_zones")
			field_texture1.self_modulate = new_field_color
			field_texture2.self_modulate = new_field_color
			
			#Call for the field bonus function to update all monsters that will benefit from the new field
			field_bonus(monster_attribute)
			
			return "field changed to attribute " + monster_attribute
		
		"wicked_dreadroot": #Halves the attack and def of all other monsters
			for side in ["player", "enemy"]:
				var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + side + "_side_zones")
				for i in range(5):
					var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
					var atk_on_field = int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text)
					var def_on_field = int(card_being_checked.get_node("card_design/monster_features/atk_def/def").text)
					
					if card_being_checked.is_visible() and card_being_checked != card_node:
						card_being_checked.this_card_flags.atk_up -= atk_on_field/2
						card_being_checked.this_card_flags.def_up -= def_on_field/2
						card_being_checked.update_card_information(card_being_checked.this_card_id)
			
			return "Dreadroot debuffed"
		
		"wicked_avatar": #gets the highest attack on the field + 100
			var highest_atk = 0
			
			for both_sides in ["player_side_zones", "enemy_side_zones"]:
				var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + both_sides)
				for i in range(5):
					var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
					if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == false and int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text) > highest_atk:
						highest_atk = int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text)
			
			card_node.this_card_flags.atk_up += highest_atk + 100
			card_node.this_card_flags.def_up += highest_atk + 100
			card_node.update_card_information(card_node.this_card_id)
			
			return "Wicked Avatar"
		
		"wicked_eraser": #gets 1000 times the number of cards on opponent field
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			var card_count = 0
			
			for card_type in ["monster_", "spelltrap_"]:
				for i in range(5):
					var card_being_checked = target_side_of_field.get_node(card_type + String(i))
					if card_being_checked.is_visible():
						card_count += 1
			
			card_node.this_card_flags.atk_up += card_count * 1000
			card_node.this_card_flags.def_up += card_count * 1000
			card_node.update_card_information(card_node.this_card_id)
			
			return "wicked_eraser"
		
		"get_atk_from_field":
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
			var type_of_count = CardList.card_list[card_node.this_card_id].effect[2] #sum, level
			
			var final_atk_gain = 0
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == false:
					match type_of_count:
						"sum"   : final_atk_gain += int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text)
						"level" : final_atk_gain += int(CardList.card_list[card_being_checked.this_card_id].level) * 100
			
			card_node.this_card_flags.atk_up += final_atk_gain
			card_node.update_card_information(card_node.this_card_id)
			
			return "get_atk_from_field"
		
		"halve_opp_LP":
			var lifepoints : int = int(GAME_LOGIC.get_parent().get_node("user_interface/top_info_box/com_info/lifepoints").get_text())
			if caller_and_target[0] == "enemy":
				lifepoints = int(GAME_LOGIC.get_parent().get_node("user_interface/top_info_box/player_info/lifepoints").get_text())
			
			#Halve the opponent's life points
			GAME_LOGIC.change_lifepoints(caller_and_target[1], float(lifepoints)/2)
			
			return "halved opp LP"
		
		"debuff_for_graveyard":
			#Get the remaining cards on the deck when this effect is activated
			var who_is = caller_and_target[0]
			if who_is == "enemy":
				who_is = "com"
			var current_deck_size = get_node("../../user_interface/top_info_box/"+ who_is +"_info/deck").get_text()
			
			#Effect was simplified to just be Deck - Out of Deck * value
			var card_count = 40 - int(current_deck_size)
			var debuff_value = card_count * CardList.card_list[card_node.this_card_id].effect[2]
			
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == false:
					card_being_checked.this_card_flags.atk_up -= debuff_value
					card_being_checked.update_card_information(card_being_checked.this_card_id)
			
			return "debuffed for gy"
		
		"dhero_plasma":
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			
			#List all of the targetable monsters
			var highest_atk = 0
			var keep_monster_node = null
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == false:
					if int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text) >= highest_atk:
						highest_atk = int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text)
						keep_monster_node = card_being_checked
			
			if keep_monster_node != null:
				card_node.this_card_flags.atk_up += float(highest_atk)/2
				card_node.update_card_information(card_node.this_card_id)
				GAME_LOGIC.destroy_a_card(keep_monster_node)
			
			return "plasma killed and copied"
			
	
	return card_id #generic return

func monster_on_flip(card_node : Node):
	var type_of_effect = CardList.card_list[card_node.this_card_id].effect[1]
	
	#Do an initial check to see if this card isn't triggering it's effect for a second time
	if card_node.this_card_flags.has_activated_effect == true:
		return "FAIL"
	#Set this flag
	card_node.this_card_flags.has_activated_effect = true
	
	#The flipped card has to be forcefully set to face up
	card_node.this_card_flags.is_facedown = false
	card_node.update_card_information(card_node.this_card_id)
	
	#Get proper keywords to use in the logics bellow
	var caller_and_target : Array = get_caller_and_target(card_node) #[caller, target]
	
	#THE EFFECTS LOGIC
	match type_of_effect:
		"destroy_card":
			var destruction_target = CardList.card_list[card_node.this_card_id].effect[2]
			match destruction_target:
				"random_spelltrap", "random_monster":
					var list_of_targets : Array = []
					var get_keyword = destruction_target.split("_")[1] #returns 'monster' or 'spelltrap
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
					
					for i in range(5):
						var card_being_checked = target_side_of_field.get_node(get_keyword + "_" + String(i))
						if card_being_checked.is_visible():
							list_of_targets.append(card_being_checked)
					
					if list_of_targets.size() > 0:
						randomize()
						var random_target = list_of_targets[randi()%list_of_targets.size()]
						GAME_LOGIC.destroy_a_card(random_target)
						
						return "randomly destroyed"
					else:
						return "FAIL , no target to destroy"
					
				"level4_enemy_monsters":
					var list_of_targets : Array = []
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
					
					for i in range(5):
						var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
						if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == false and CardList.card_list[card_being_checked.this_card_id].level == 4:
							list_of_targets.append(card_being_checked)
					
					for i in range(list_of_targets.size()):
						GAME_LOGIC.destroy_a_card(list_of_targets[i])
					
					return "destroyed all level 4"
					
				"all_enemy_monsters":
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
					for i in range(5):
						var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
						if card_being_checked.is_visible():
							GAME_LOGIC.destroy_a_card(card_being_checked)
					
					return "destroyed everything"
				
				"both_sides_monsters":
					for side in ["player", "enemy"]:
						var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + side + "_side_zones")
						for i in range(5):
							var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
							if card_being_checked.is_visible():
								GAME_LOGIC.destroy_a_card(card_being_checked)
					
					return "destroyed everything"
		
		"lifepoint_up":
			var value : int = CardList.card_list[card_node.this_card_id].effect[2]
			GAME_LOGIC.change_lifepoints(caller_and_target[0], value, true)
			
			return String(value)
		
		"mill":
			var card_quantity = CardList.card_list[card_node.this_card_id].effect[2]
			
			#Get the Deck reference
			var target_is = caller_and_target[1]
			var deck : Array = GAME_LOGIC.get_node("player_logic").player_deck
			if target_is == "enemy":
				target_is = "com"
				deck = GAME_LOGIC.get_node("enemy_logic").enemy_deck
			var current_deck_size = int(get_node("../../user_interface/top_info_box/"+ target_is +"_info/deck").get_text())
			
			#Remove cards from the deck, if it has enough
			var cards_removed : int = 0
			for _i in range(card_quantity):
				if current_deck_size > 0:
					deck.remove(0) #remove that same card from deck
					get_node("../../user_interface/top_info_box/"+ target_is +"_info/deck").text = String(deck.size())
					cards_removed += 1
			
			return String(cards_removed)
		
		"jigen_bakudan":
			var atk_sum : int = 0
			
			#Destroys all of caller's monsters and add their atk to the sum
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if card_being_checked.is_visible():
					atk_sum += int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text)
					GAME_LOGIC.destroy_a_card(card_being_checked)
			
			#Deal half the total sum to opponents LP
			GAME_LOGIC.change_lifepoints(caller_and_target[1], float(atk_sum)/2)
			
			return "jigen bakudan!"
			
		"slate_warrior":
			#Self boosts when flipped
			var boost_value = 500
			card_node.this_card_flags.atk_up += boost_value
			card_node.this_card_flags.def_up += boost_value
			card_node.update_card_information(card_node.this_card_id)
			
			return "slate warrior"
	
	return "fip_effect_completed" #generic return

func monster_on_attack(card_node : Node):
	var caller_and_target : Array = get_caller_and_target(card_node) #[caller, target]
	var type_of_effect = CardList.card_list[card_node.this_card_id].effect[1]
	
	match type_of_effect:
		"anti_flip", "ignore_spelltrap", "piercing", "can_direct":
			return type_of_effect #these effects are actually part of the logic on GAME_LOGIC.do_battle() and player_logic and enemy_logic
		
		"multiple_attacker": #a good part of the logic here is set by player_logic, game_logic, enemy_logic
			if card_node.this_card_flags.has_battled == true and card_node.this_card_flags.multiple_attacks == 0:
				card_node.this_card_flags.has_battled = false
				card_node.this_card_flags.multiple_attacks = 1
			return "multiple attacks"
		
		"toon":
			#All the combat checks for this is done in the GAME_LOGIC.do_battle() thingy, this effect will only deduce the 500 LP in case of a direct attack
			#Since this effect will only be called when checking for a direct attack, the smart way to figure out if it is a direct by effect is by counting monsters on Target field
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			var target_number_of_monsters : int = 0
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if card_being_checked.is_visible():
					target_number_of_monsters += 1
			
			if target_number_of_monsters > 0: #there are monsters on the field, so this Direct was by effect and costs 500 LP
				lifepoint_change_animation("-500", "left")
				GAME_LOGIC.change_lifepoints(caller_and_target[0], 500)
			
			return "toon"
		
		"change_position":
			#This attacking monster will be changed to DEF position
			if card_node.this_card_flags.is_defense_position == false:
				card_node.toggle_battle_position()
			
			return "changed to def"
		
		"injection_fairy":
			var lifepoints : int = int(GAME_LOGIC.get_parent().get_node("user_interface/top_info_box/player_info/lifepoints").get_text())
			if caller_and_target[0] == "enemy":
				lifepoints = int(GAME_LOGIC.get_parent().get_node("user_interface/top_info_box/com_info/lifepoints").get_text())
			
			if lifepoints > 2000:
				lifepoint_change_animation("-2000", "left")
				
				card_node.this_card_flags.atk_up += 3000
				card_node.update_card_information(card_node.this_card_id)
				GAME_LOGIC.change_lifepoints(caller_and_target[0], 2000)
			
			#This buff is removed at the end of the battle logic
			return "injection fairy"
		
		"rocket_warrior":
			var get_attacked_monster = GAME_LOGIC.card_ready_to_defend
			if get_attacked_monster != null:
				get_attacked_monster.this_card_flags.atk_up -= 500
				get_attacked_monster.update_card_information(get_attacked_monster.this_card_id)
			
			return "rocket warrior"
		
		"mutual_banish":
			var get_attacked_monster = GAME_LOGIC.card_ready_to_defend
			if get_attacked_monster != null:
				GAME_LOGIC.destroy_a_card(card_node)
				GAME_LOGIC.destroy_a_card(get_attacked_monster)
			
			return "both monsters removed"
		
		"lifepoint_cost", "lifepoint_up":
			var value : int = CardList.card_list[card_node.this_card_id].effect[2]
			
			var get_keyword = type_of_effect.split("_")[1] #returns 'cost' or 'up'
			var is_up = get_keyword == "up"
			
			if get_keyword == "up":
				lifepoint_change_animation("+" + String(value), "left")
			else:
				lifepoint_change_animation("-" + String(value), "left")
			
			GAME_LOGIC.change_lifepoints(caller_and_target[0], value, is_up)
			
			return "life changed"
		
		"burn":
			var value = CardList.card_list[card_node.this_card_id].effect[2]
			var final_value : int = 0
			match value:
				"enemy_atk":
					var get_attacked_monster = GAME_LOGIC.card_ready_to_defend
					var found_attacked_on_field = false
					
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
					for i in range(5):
						var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
						print(card_being_checked, " and ", get_attacked_monster)
						if card_being_checked == get_attacked_monster:
							found_attacked_on_field = true
							break
					
					if get_attacked_monster != null and found_attacked_on_field == true:
						final_value = int(CardList.card_list[get_attacked_monster.this_card_id].atk)
					else:
						final_value = 0
				_:
					final_value = int(value)
			
			if final_value > 0:
				lifepoint_change_animation("-" + String(final_value), "right")
				GAME_LOGIC.change_lifepoints(caller_and_target[1], final_value)
			
			return "burn damage"
		
		"mill":
			var card_quantity = CardList.card_list[card_node.this_card_id].effect[2]
			
			#Get the Deck reference
			var target_is = caller_and_target[1]
			var deck : Array = GAME_LOGIC.get_node("player_logic").player_deck
			if target_is == "enemy":
				target_is = "com"
				deck = GAME_LOGIC.get_node("enemy_logic").enemy_deck
			var current_deck_size = int(get_node("../../user_interface/top_info_box/"+ target_is +"_info/deck").get_text())
			
			#Remove cards from the deck, if it has enough
			var cards_removed : int = 0
			for _i in range(card_quantity):
				if current_deck_size > 0:
					deck.remove(0) #remove that same card from deck
					get_node("../../user_interface/top_info_box/"+ target_is +"_info/deck").text = String(deck.size())
					cards_removed += 1
			
			return String(cards_removed)
		
		"get_power": #each time the monster attack it is powered up
			var atk_boost_value = CardList.card_list[card_node.this_card_id].effect[2]
			card_node.this_card_flags.atk_up += atk_boost_value
			card_node.update_card_information(card_node.this_card_id)
			
			return "powered up"
		
		"clear_vice":
			var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
			
			#List all of the targetable monsters
			var highest_atk = 0
			for i in range(5):
				var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
				if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == false:
					if int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text) >= highest_atk:
						highest_atk = int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text)
			
			#Update the copycat card
			if highest_atk > 0:
				card_node.this_card_flags.atk_up += highest_atk
				card_node.update_card_information(card_node.this_card_id)
			
			return "clear_vice"
	
	return "generic return" #for breaking prevention

func monster_on_defend(card_node : Node):
	var type_of_effect = CardList.card_list[card_node.this_card_id].effect[1]
	match type_of_effect:
		#Effects handled by Battle Logic
		"cant_die", "no_damage", "return_damage": pass
		
		#Effects that happen at the start of battle
		"debuff":
			var debuff_value : int = CardList.card_list[card_node.this_card_id].effect[2]
			
			var get_attacker_monster = GAME_LOGIC.card_ready_to_attack
			if get_attacker_monster != null:
				get_attacker_monster.this_card_flags.atk_up -= debuff_value
				get_attacker_monster.update_card_information(get_attacker_monster.this_card_id)
			
			return "defense debuff"
		
		"ehero_core":
			#When this card is attacked it doubles it's own base atk for this battle
			card_node.this_card_flags.atk_up += CardList.card_list[card_node.this_card_id].atk
			card_node.update_card_information(card_node.this_card_id)
			
			return "hero core"
		
		#Effects that happen at the end of battle
		"change_position":
			#This defending monster will be changed to ATK position
			if card_node.this_card_flags.is_defense_position == true:
				card_node.toggle_battle_position()
			
			return "changed to atk"
	
	return "generic return"

func ritual_effects_activation(card_node : Node, ritual_activation_condition : String):
	var caller_and_target = get_caller_and_target(card_node)
	var ritual_monster_name = CardList.card_list[card_node.this_card_id].card_name
	
	#Call for card animation
	var monsters_to_not_animate = [
		"Five-Headed Dragon", "Arcana Knight Joker", "Valkyrion the Magna Warrior",
		"Lord of the Red", "Paladin of White Dragon", "Paladin of Dark Dragon", "Knight of Armor Dragon",
		"Chakra", "Demise, Agent of Armageddon", "Demise, King of Armageddon",
		"Cyber Angel Natasha", "Cyber Angel Idaten", "Cyber Angel Benten", "Cyber Angel Izana", "Cyber Angel Dakini", "Cyber Angel Vrash",
		"Blue-Eyes Chaos MAX Dragon", "Gearfried the Swordmaster", "Relinquished"
	]
	
	if not ritual_monster_name in monsters_to_not_animate:
		do_activation_animation(card_node, true)
		yield(self, "effect_animation_finished")
	
	#The effects will happen individually for each monster
	match ritual_activation_condition:
		"on_ritual_summon":
			match ritual_monster_name:
				#on_summon, summon friend
				"Hungry Burger", "Zera the Mant":
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
					var friend_match = {
						"Hungry Burger" : "01111", #Potato & Chips
						"Zera the Mant" : "01112", #Warrior of Zera
					}
					#Summon one friend on field
					for i in [2,1,3,0,4]:
						var monster_being_checked = target_side_of_field.get_node("monster_" + String(i))
						if not monster_being_checked.is_visible():
							#Summon the resulting monster on the field
							monster_being_checked.this_card_id = friend_match[ritual_monster_name]
							monster_being_checked.update_card_information(monster_being_checked.this_card_id)
							monster_being_checked.show()
							break
				
				#on_summon, summons a token copying the status of an opponent
				"The Masked Beast":
					#Get strongest monster on enemy side of the field
					var target_atk = 0
					var target_def = 0
					
					#look for the strongest
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
					
					#List all of the targetable monsters
					for i in range(5):
						var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
						if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == false and int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text) >= target_atk:
							target_atk = int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text)
							target_def = int(card_being_checked.get_node("card_design/monster_features/atk_def/def").text)
					
					#Summon one friend on field
					for i in [2,1,3,0,4]:
						target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
						var monster_being_checked = target_side_of_field.get_node("monster_" + String(i))
						if not monster_being_checked.is_visible():
							#Summon the resulting monster on the field
							monster_being_checked.this_card_id = "01246" #Mask Token
							monster_being_checked.this_card_flags.fusion_type = "token"
							monster_being_checked.this_card_flags.atk_up += target_atk
							monster_being_checked.this_card_flags.def_up += target_def
							monster_being_checked.update_card_information(monster_being_checked.this_card_id)
							monster_being_checked.show()
							break
				
				#on_summon, destroy enemies
				"Fortress Whale":
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
					
					#List all of the targetable monsters
					var highest_atk_so_far = 0
					var the_monster : Node = null
					for i in range(5):
						var card_being_checked = target_side_of_field.get_node("monster_" + String(i))
						if card_being_checked.is_visible() and card_being_checked.this_card_flags.is_facedown == false and int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text) >= highest_atk_so_far:
							highest_atk_so_far = int(card_being_checked.get_node("card_design/monster_features/atk_def/atk").text)
							the_monster = card_being_checked
					
					#Destroy the Highest ATK monster
					if the_monster != null:
						GAME_LOGIC.destroy_a_card(the_monster)
				
				"Black Luster Soldier", "Magician of Black Chaos", "Super War-Lion":
					var all_monsters_destroyer = ["Black Luster Soldier", "Super War-Lion"]
					var destroy_keyword = ""
					if ritual_monster_name in all_monsters_destroyer:
						destroy_keyword = "enemy_monsters"
					else:
						destroy_keyword = "enemy_spelltraps"
					
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[1] + "_side_zones")
					var get_keyword = destroy_keyword.split("_")[1].trim_suffix("s") #returns 'monster' or 'spelltrap
					for i in range(5):
						var card_being_checked = target_side_of_field.get_node(get_keyword + "_" + String(i))
						if card_being_checked.is_visible():
							GAME_LOGIC.destroy_a_card(card_being_checked)
				
				#on_summon, power up by spells
				"Elemental HERO Divine Neos":
					var count_spelltrap_on_field : int = 0
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
					for i in range(5):
						var spelltrap_target = target_side_of_field.get_node("spelltrap_" + String(i))
						if spelltrap_target.is_visible():
							count_spelltrap_on_field += 1
					
					card_node.this_card_flags.atk_up += 500 * count_spelltrap_on_field
					card_node.update_card_information(card_node.this_card_id)
				
				#on_summon, power up friendly types
				"Dokurorider", "Crab Turtle":
					var friendly_type : String = CardList.card_list[card_node.this_card_id].type
					var boost_value : int = 500
					
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
					for i in range(5):
						var monster_target = target_side_of_field.get_node("monster_" + String(i))
						if monster_target.is_visible() and monster_target.this_card_flags.is_facedown == false and CardList.card_list[monster_target.this_card_id].type == friendly_type and monster_target != card_node:
							monster_target.this_card_flags.atk_up += boost_value
							monster_target.this_card_flags.def_up += boost_value
							monster_target.update_card_information(monster_target.this_card_id)
				
				#on_summon, dice power up monsters on field
				"Dark Master - Zorc":
					randomize()
					var value_change : int = 1 + randi()%6 #returns between 1+0 and 1+5
					
					#Do the actual changes of stats for the monsters
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
					for i in range(5):
						var monster_being_checked = target_side_of_field.get_node("monster_" + String(i))
						if monster_being_checked.is_visible() and monster_being_checked.this_card_flags.is_facedown == false:
							monster_being_checked.this_card_flags.atk_up += value_change * 100
							monster_being_checked.update_card_information(monster_being_checked.this_card_id)
				
				#on_summon, power up itself for friendly type
				"Javelin Beetle":
					var boost_value : int = 250
					var count_type_on_field : int = 0
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
					for i in range(5):
						var monster_target = target_side_of_field.get_node("monster_" + String(i))
						if monster_target.is_visible() and monster_target.this_card_flags.is_facedown == false and CardList.card_list[monster_target.this_card_id].type == CardList.card_list[card_node.this_card_id].type and monster_target != card_node:
							count_type_on_field += 1
					boost_value = boost_value * count_type_on_field
					
					card_node.this_card_flags.atk_up += boost_value
					card_node.update_card_information(card_node.this_card_id)
				
				#on_summon, power up itself by spelltrap count in deck
				"Litmus Doom Swordsman":
					var value_boost = 300
					var spelltrap_count = 0
					for card in PlayerData.player_deck:
						if CardList.card_list[card].attribute in ["spell", "trap"]:
							spelltrap_count += 1
					
					card_node.this_card_flags.atk_up += value_boost * spelltrap_count
					card_node.this_card_flags.def_up += value_boost * spelltrap_count
					card_node.update_card_information(card_node.this_card_id)
				
				#on_summon, Sword and Shield
				"Skull Guardian":
					for both_targets in ["player", "enemy"]:
						var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + both_targets + "_side_zones")
						
						for i in range(5):
							var monster_being_checked = target_side_of_field.get_node("monster_" + String(i))
							if monster_being_checked.is_visible() and monster_being_checked.this_card_flags.is_facedown == false:
								var registered_atk = int(monster_being_checked.get_node("card_design/monster_features/atk_def/atk").text)
								var registered_def = int(monster_being_checked.get_node("card_design/monster_features/atk_def/def").text)
								
								#if registered_atk > registered_def:
								monster_being_checked.this_card_flags.atk_up -= registered_atk - registered_def
								monster_being_checked.this_card_flags.def_up += registered_atk - registered_def
								#else:
									#monster_being_checked.this_card_flags.atk_up += registered_atk - registered_def
									#monster_being_checked.this_card_flags.def_up -= registered_atk - registered_def
									
								monster_being_checked.update_card_information(monster_being_checked.this_card_id)
				
				#mill 6 cards
				"Garma Sword":
					var card_quantity = 6
					#Get the Deck reference
					var target_is = caller_and_target[1]
					var deck : Array = GAME_LOGIC.get_node("player_logic").player_deck
					if target_is == "enemy":
						target_is = "com"
						deck = GAME_LOGIC.get_node("enemy_logic").enemy_deck
					var current_deck_size = int(get_node("../../user_interface/top_info_box/"+ target_is +"_info/deck").get_text())
					
					#Remove cards from the deck, if it has enough
					for _i in range(card_quantity):
						if current_deck_size > 0:
							deck.remove(0) #remove that same card from deck
							get_node("../../user_interface/top_info_box/"+ target_is +"_info/deck").text = String(deck.size())
		
		"on_ritual_death":
			match ritual_monster_name:
				#on_death summon successors
				"Five-Headed Dragon", "Arcana Knight Joker", "Valkyrion the Magna Warrior", "Lord of the Red", "Paladin of White Dragon", "Paladin of Dark Dragon", "Knight of Armor Dragon", "Chakra", "Demise, Agent of Armageddon", "Demise, King of Armageddon":
					var successor_match = {
						"Five-Headed Dragon" : ["01117"], #Berserk Dragon
						"Arcana Knight Joker" : ["01110"], #Royal Straight Slasher
						"Valkyrion the Magna Warrior" : ["00445", "00446", "00447"], #Alpha, Beta, Gamma
						"Lord of the Red" : ["00643"], #Red-Eyes Black Flare Dragon
						"Paladin of White Dragon" : ["00240"], #Blue-Eyes White Dragon
						"Paladin of Dark Dragon" : ["00073"], #Red-Eyes Black Dragon 
						"Knight of Armor Dragon" : ["00164"], #Armed Dragon LV5
						"Chakra" : ["01237"], #Chakra invokes a normal version of itself
						"Demise, Agent of Armageddon" : ["01362"], #Demise, King of Armageddon
						"Demise, King of Armageddon" : ["01363"], #Demise, Supreme King of Armageddon
					}
					
					#At Death, do the animation
					do_activation_animation(card_node, true)
					yield(self, "effect_animation_finished")
					
					#Summon the successor on field
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
					for i in range(successor_match[ritual_monster_name].size()):
						for j in [2,1,3,0,4]:
							var monster_being_checked = target_side_of_field.get_node("monster_" + String(j))
							if not monster_being_checked.is_visible():
								monster_being_checked.this_card_id = successor_match[ritual_monster_name][i]
								
								#Monsters which successors come as ritual monsters themselves to keep the Chain going
								if successor_match[ritual_monster_name][i] in ["01362"]: 
									monster_being_checked.this_card_flags.fusion_type = "ritual"
								
								monster_being_checked.update_card_information(monster_being_checked.this_card_id)
								monster_being_checked.show()
								
								#Call for a possible effect of the summoned monster
								if CardList.card_list[monster_being_checked.this_card_id].effect.size() > 0:
									call_effect(monster_being_checked, "on_summon")
								break
				
				#Same thing, but I've separated because it's TOO LONG wtf
				"Cyber Angel Natasha", "Cyber Angel Idaten", "Cyber Angel Benten", "Cyber Angel Izana", "Cyber Angel Dakini", "Cyber Angel Vrash":
					var succession_line = ["00998", "00987", "00997", "00984", "00977", "00976"] #same as above but IDs
					
					#At Death, do the animation
					do_activation_animation(card_node, true)
					yield(self, "effect_animation_finished")
					
					#Summon next one on the field
					var target_side_of_field = GAME_LOGIC.get_parent().get_node("duel_field/" + caller_and_target[0] + "_side_zones")
					for j in [2,1,3,0,4]:
						var monster_being_checked = target_side_of_field.get_node("monster_" + String(j))
						if not monster_being_checked.is_visible():
							#print("Looking for: ", card_node.this_card_id, " in: ", succession_line, " Found it at index: ", succession_line.find(card_node.this_card_id))
							if succession_line.find(card_node.this_card_id) != succession_line.size() -1:
								monster_being_checked.this_card_id = succession_line[succession_line.find(card_node.this_card_id) + 1]
								monster_being_checked.this_card_flags.fusion_type = "ritual"
								monster_being_checked.update_card_information(monster_being_checked.this_card_id)
								monster_being_checked.show()
								
								#Call for a possible effect of the summoned monster
								if CardList.card_list[monster_being_checked.this_card_id].effect.size() > 0:
									call_effect(monster_being_checked, "on_summon")
								break
		
		"on_ritual_attack":
			match ritual_monster_name:
				"Blue-Eyes Chaos MAX Dragon":
					card_node.this_card_flags.atk_up += 4000
					card_node.update_card_information(card_node.this_card_id)
				"Gearfried the Swordmaster":
					var full_atk_on_field = int(card_node.get_node("card_design/monster_features/atk_def/atk").text)
					card_node.this_card_flags.atk_up += full_atk_on_field
					card_node.update_card_information(card_node.this_card_id)
		
		"on_ritual_defend":
			match ritual_monster_name:
				#Relinquished basically does the same 'return_damage' effect that is purely part of game_logic
				"Relinquished": pass




