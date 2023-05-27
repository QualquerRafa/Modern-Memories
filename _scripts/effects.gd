extends Node
#All about Effects and their functions

#Reference to game_logic node
onready var GAME_LOGIC = get_node("../")

#Signals to be used as timers for other parts of code
signal effect_animation_finished #emitted by the animation
signal effect_fully_executed #emitted at the end to progress the duel phase

signal simulated_fusion_animation_finished #emitted by simulate_fusion_animation()

func call_effect(card_node : Node, type_of_activation : String): #The 'card_node' that is passed is already the exact card that's on the field
	#Easily accessible information about the card
	var card_attribute = CardList.card_list[card_node.this_card_id].attribute
	var card_type = CardList.card_list[card_node.this_card_id].type
	
	#Initialize the returned info at the end
	var type_of_effect_activated : String = card_type #can and will be rewritten for monsters to show "on_flip", "on_attack", etc
	var extra_return_information : String #anything else that needs to be returned to be checked by other game functions
	
	#Animate the card being activated
	do_activation_animation(card_node)
	yield(self, "effect_animation_finished")
	
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
				
				_:
					print("Undefined type of Spell card.")
		
		"trap":
			extra_return_information = "trap effect"
			print(extra_return_information)
		
		_: #Monsters
			match type_of_activation:
				"on_summon":
					extra_return_information = monster_on_summon(card_node)
				"on_flip":
					extra_return_information = type_of_activation
				"on_attack":
					extra_return_information = type_of_activation
				"on_defend": 
					extra_return_information = type_of_activation
				_:
					print("Monster effect of type ", CardList.card_list[card_node.this_card_id].effect[0], " isn't programmed.")
					extra_return_information = "FAIL"
			
			#For monsters, it's important to return the type of it's activation
			type_of_effect_activated = type_of_activation
			extra_return_information = "monster effect"
	
	#After a card effect was activated and it's been removed from the field, clear the bottom bar from it's information. Generally happens for Spell and Traps only, since monsters remain.
	if card_attribute in ["spell", "trap"]:
		clear_card_after_activation(card_node)
	
	#Return to the Duel with this info after the effects are executed
	if card_type != "equip": #equips will emit this signal at it's own moment, since it needs to wait for player input
		emit_signal("effect_fully_executed")
	
	return [type_of_effect_activated, extra_return_information]

####################################################################################################
# AUXILIARY
####################################################################################################
func do_activation_animation(card_node : Node):
	var animation_timer : float = 0.001
	
	#Update the visuals of the card that has to be animated
	$effect_visuals/visual_cardA.this_card_flags = card_node.this_card_flags
	$effect_visuals/visual_cardA.update_card_information(card_node.this_card_id)
	
	#RESET ANIMATION STUFF BEFORE STARTING
	$effect_visuals.modulate = Color(1,1,1,1)
	$effect_visuals/visual_cardA.modulate = Color(1,1,1,1)
	$effect_visuals/darken_screen.modulate  = Color(1,1,1,0)
	
	#Make the visuals visible right before animating them
	$effect_visuals/visual_cardA/card_design/card_back.show()
	#Gambiarra do caralho pra "não animar" e emitir o sinal direitinho no final
	if not CardList.card_list[card_node.this_card_id].effect[0] in ["on_attack", "on_defend"]:
		animation_timer = 0.2
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
	
	#Emit the signal to indicate the animation has ended
	emit_signal("effect_animation_finished")
	
	#Animation fade out
	$tween_effect.interpolate_property($effect_visuals, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), animation_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween_effect.start()
	$effect_timer_node.start(animation_timer*2); yield($effect_timer_node, "timeout")
	$effect_visuals.hide()
	
	return true

func clear_card_after_activation(card_node : Node):
	#Based on the reference passed, find that card on the field and destroy it
#	for i in range(5):
#		for side_of_the_field in ["player_side_zones", "enemy_side_zones"]:
#			var card_being_checked = GAME_LOGIC.get_parent().get_node("duel_field/"+ side_of_the_field +"/spelltrap_" + String(i))
#			if card_being_checked.is_visible() and card_being_checked.this_card_id == card_node.this_card_id:
#				GAME_LOGIC.destroy_a_card(card_being_checked)
#				break
	GAME_LOGIC.destroy_a_card(card_node)
	
	#Clear the bottom bar
	GAME_LOGIC.get_parent().get_node("user_interface/card_info_box/colored_bar").hide()
	GAME_LOGIC.get_parent().get_node("user_interface/card_info_box/card_name").hide()
	GAME_LOGIC.get_parent().get_node("user_interface/card_info_box/atk_def").hide()
	GAME_LOGIC.get_parent().get_node("user_interface/card_info_box/extra_icons").hide()
	GAME_LOGIC.get_parent().get_node("user_interface/card_info_box/card_text").hide()
	
	return null

func get_caller_and_target(card_node : Node):
	#Check which field it will use ([VAR]_side_zones)
	var who_activated_this_effect = "player"
	var target_of_effect = "enemy"
	if card_node.get_parent().get_name().find("player") != 0:
		who_activated_this_effect = "enemy"
		target_of_effect = "player"
	
	return [who_activated_this_effect, target_of_effect]

func show_field_slots(kind_of_slots : String):
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

####################################################################################################
# SPELL CARDS
####################################################################################################
func activate_spell_field(card_node : Node):
	#Initialize some variables
	var card_id = card_node.this_card_id
	var field_element = CardList.card_list[card_id].effect[0]
	
	#Change the text at the top
	GAME_LOGIC.get_parent().get_node("user_interface/top_info_box/field_info/field_name").text = field_element.capitalize() + " bonus"
	
	#Change the color of the field to visually represent Field Change
	var new_field_color
	match field_element.to_lower():
		"fire":  new_field_color = Color("ff4a4a")
		"earth": new_field_color = Color("0ca528")
		"water": new_field_color = Color("1c68ff")
		"wind":  new_field_color = Color("4dedff")
		"dark":  new_field_color = Color("5100ff")
		"light": new_field_color = Color("ffef00")
		_: new_field_color = Color("ffffff")
	
	var field_texture1 = GAME_LOGIC.get_parent().get_node("duel_field/player_side_zones")
	var field_texture2 = GAME_LOGIC.get_parent(). get_node("duel_field/enemy_side_zones")
	field_texture1.self_modulate = new_field_color
	field_texture2.self_modulate = new_field_color
	
	#Call for the field bonus function to update all monsters that will benefit from the new field
	field_bonus(field_element)
	
	return field_element

#This function can be called at any moment a new card might need to update it's field bonus, such as when it is summoned. Not only for when a field spell is activated.
func field_bonus(field_element : String):
	for i in range(5):
		for side_of_the_field in ["player_side_zones", "enemy_side_zones"]:
			var monster_being_checked = GAME_LOGIC.get_parent().get_node("duel_field/"+ side_of_the_field +"/monster_" + String(i))
			
			#A visible monster that matches the attribute will have it's field boost applied
			if monster_being_checked.is_visible() and CardList.card_list[monster_being_checked.this_card_id].attribute == field_element:
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
		show_field_slots("monster_field_slots")
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
		
		#Final update on the card to visually reflect the status up
		target_card_node.update_card_information(target_card_node.this_card_id)
		GAME_LOGIC.get_parent().update_user_interface(target_card_node)
		
	#This means the equip_result returned as [monster_id, False]
	else:
		print("Failed to equip. Results: ", equip_result)
	
	#Go back to regular main phase and toggle back buttons
	GAME_LOGIC.get_parent().toggle_visibility_of_change_field_view_button()
	GAME_LOGIC.get_parent().toggle_visibility_of_turn_end_button()
	GAME_LOGIC.GAME_PHASE = "main_phase"
	
	return typeof(equip_result[1]) == TYPE_ARRAY #returns TRUE for equip sucess, FALSE for equip failure

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
	var _caller_and_target : Array = get_caller_and_target(card_node) #[caller, target]
	
	#THE EFFECTS LOGIC
	match type_of_effect:
		#Status bonus types of effect
		"att_booster": pass
		"friends_power_up": pass
		"self_power_up": pass
		"monster_count_boost": pass
		"spelltrap_count_boost": pass
		"lp_dif_power_up": pass
		"dice_power_up": pass
		"deck_for_stat": pass
		
		#Card destruction types of effect
		"destroy_monster": pass
		"destroy_spelltrap": pass
		
		#Specific types of effect
		"att_reptile": pass
		"buster_blader": pass
		"honest": pass
		"gandora": pass
		"equip_boost": pass
		"cyber-stein": pass
		"white-horned": pass
		"relinquised": pass
		"jinzo": pass
	
	return card_id #generic return






