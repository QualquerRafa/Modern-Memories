extends Node

#Record with GAME_PHASE it is, so it does the commands in the proper moment
var GAME_PHASE : String

#These values are used to properly scale the 'card_design.tscn' when it's placed on the field
const atk_orientation_x_scale : float = 0.518
const atk_orientation_y_scale : float = 0.517
const def_orientation_y_scale : float = 0.517 #when in def position, shorten it just a little

#------------------------------------------------------------------------------
#FUSION LOGIC
const fusion_list_gd = preload("res://_scripts/fusions.gd")
var fusion_list = fusion_list_gd.new()

func fusing_cards_logic(card_1 : Node, card_2 : Node):
	var card_1_id : String = card_1.this_card_id
	var card_2_id : String = card_2.this_card_id
	
	#All the kinds of fusion checks are handled there, this is just passing the ID:String ahead
	var fusion_result : Array #[ID:String, Extra Info]
	fusion_result = fusion_list.check_for_fusion(card_1_id, card_2_id)
	
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
	}

func destroy_a_card(card_node_to_destroy):
	#first reset the nodes properties so it's wiped clean
	reset_a_card_node_properties(card_node_to_destroy)
	
	#Force reset rotation back to attack position for cards in defense position
	if card_node_to_destroy.get_node("card_design").rect_rotation == -90 or card_node_to_destroy.get_node("card_design").rect_rotation == 90:
		card_node_to_destroy.get_node("card_design").rect_rotation = 0
	
	#Then remove the card from the field (by making it invisible)
	card_node_to_destroy.hide()

#------------------------------------------------------------------------------
var card_ready_to_attack : Node #passed by a card node entering in 'selecting_combat_target'
var card_ready_to_defend : Node #passed by a card node when player is in the phase 'selecting_combat_target'

func do_battle(attacking_card : Node, defending_card : Node):
	if attacking_card.this_card_flags.has_battled == true:
		return #failsafe to prevent cards from battling more than once
	if defending_card.is_visible() == false:
		print("do_battle() caught a timming mismatch. This should be safe.")
		return #failsafe to prevent multiple attacks on an already destroyed monster in case of timming mismatches
	
	var battle_timer_node = $battle_visuals/battle_timer_node
	var battle_timer : float = 0.2 #in seconds
	
	#Set the attacker and defender flags
	attacking_card.this_card_flags.has_battled = true
	attacking_card.this_card_flags.is_facedown = false
	attacking_card.update_card_information(attacking_card.this_card_id)
	defending_card.this_card_flags.is_facedown = false
	defending_card.update_card_information(defending_card.this_card_id)
	
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
	elif defender_stats > attacker_stats:
		battle_loser_anim_path = $battle_visuals/visual_cardA
		LP_damage = defender_stats - attacker_stats
		LP_position = Vector2(120, 21)
	
	#RESET ANIMATION STUFF BEFORE STARTING
	$battle_visuals.modulate = Color(1,1,1,1)
	$battle_visuals/visual_cardA.modulate = Color(1,1,1,1)
	$battle_visuals/visual_cardB.modulate = Color(1,1,1,1)
	$battle_visuals/darken_screen.modulate  = Color(1,1,1,1)
	$battle_visuals/LP_damage.modulate = Color(1,1,1,1)
	
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
	if attacker_stats > defender_stats:
		#Destroy defender
		destroy_a_card(defending_card)
	elif attacker_stats == defender_stats:
		#If the stats are equal, destroy neither or both, depending on defender battle position
		if defending_card.this_card_flags.is_defense_position == false: #atk pos, destroy both
			destroy_a_card(card_ready_to_attack)
			destroy_a_card(defending_card)
		else: #just flip defense card face up
			defending_card.this_card_flags.is_facedown = false
			defending_card.get_node("card_design/card_back").hide()
	elif attacker_stats < defender_stats:
		#If attacker lost, only destroy it if defender is not in defense position
		if defending_card.this_card_flags.is_defense_position == false:
			destroy_a_card(card_ready_to_attack)
		defending_card.this_card_flags.is_facedown = false
		defending_card.get_node("card_design/card_back").hide()
	
	#Get rid of the Battle Loser
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
	
	#Battle scene fadeout
	$battle_visuals/tween_battle.interpolate_property($battle_visuals, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer*2); yield(battle_timer_node, "timeout")
	$battle_visuals/LP_damage.hide()
	$battle_visuals.hide()
	
	#Finish Battle phase in different ways depending on whose turn it is
	if attacking_card.get_parent().get_name().find("player") != -1: #it's players turn
		print("Back to Player's Main Phase")
		attacking_card.cancel_all_combat_controls() #hide the combat controls for the card that already attacked
		get_node("../").change_field_view() #return back to player's side of the field
		GAME_PHASE = "main_phase"
		
		#Reduce LP as intended
		if defender_stats > attacker_stats: #Reduce from player LP
			change_lifepoints("player", LP_damage)
		else: #Reduce from COM LP
			change_lifepoints("enemy", LP_damage)
	else:
		#Reduce LP as intended
		if defender_stats > attacker_stats: #Reduce from player LP
			change_lifepoints("enemy", LP_damage)
		else: #Reduce from COM LP
			change_lifepoints("player", LP_damage)

func _on_direct_attack_area_button_up():
	#prevent direct attacks on first turn
	if $player_logic.turn_count <= 1:
		return
	
	#Check if the player can direct attack the enemy (only when 0 monsters on the field)
	var enemy_monsters_on_field : int = 0
	for i in range(5):
		if get_node("../duel_field/enemy_side_zones/monster_" + String(i)).is_visible():
			enemy_monsters_on_field += 1
	
	if enemy_monsters_on_field == 0: #TODO: or card_ready_to_attack effect is "can_direct"
		do_direct_attack(card_ready_to_attack)
	else:
		print("can't direct attack")

func do_direct_attack(attacking_card):
	#Basically a clone of do_battle() with all the references to a defending card being invisible
	if attacking_card.this_card_flags.has_battled == true:
		return #failsafe to prevent cards from battling more than once
	
	var battle_timer_node = $battle_visuals/battle_timer_node
	var battle_timer : float = 0.2 #in seconds
	
	#Set the attacker flags
	attacking_card.this_card_flags.has_battled = true
	attacking_card.this_card_flags.is_facedown = false
	attacking_card.update_card_information(attacking_card.this_card_id)
	
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
	$battle_visuals/darken_screen.modulate  = Color(1,1,1,1)
	$battle_visuals/LP_damage.modulate = Color(1,1,1,1)
	
	#Do all the animations of this battle
	$battle_visuals/visual_cardA/card_design/card_back.show()
	$battle_visuals/visual_cardB/card_design.hide()
	$battle_visuals.show()
	
	#First the black background fade in
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/darken_screen, "modulate", Color(1,1,1, 0), Color(1,1,1, 1), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer*1.5); yield(battle_timer_node, "timeout")
	
	#The card flip
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardA, "rect_scale", Vector2(1.4, 1.4), Vector2(0.1, 1.4), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer); yield(battle_timer_node, "timeout")
	$battle_visuals/visual_cardA/card_design/card_back.hide()
	$battle_visuals/tween_battle.interpolate_property($battle_visuals/visual_cardA, "rect_scale", Vector2(0.1, 1.4), Vector2(1.4, 1.4), battle_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$battle_visuals/tween_battle.start()
	battle_timer_node.start(battle_timer); yield(battle_timer_node, "timeout")
	
	#The attacking movements
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
		print("Back to Player's Main Phase")
		attacking_card.cancel_all_combat_controls() #hide the combat controls for the card that already attacked
		get_node("../").change_field_view() #return back to the other side of the field
		GAME_PHASE = "main_phase"
		change_lifepoints("enemy", LP_damage)
	else:
		print("Back to Enemy's Main Phase")
		GAME_PHASE = "enemy_main_phase"
		change_lifepoints("player", LP_damage)

#---------------------------------------------------------------------------------------------------
var LP_info_node : Node
func change_lifepoints(target : String, LP_damage : int):
	if LP_damage <= 0:
		return
	
	var tween_LP : Node = get_node("../user_interface/top_info_box/tween_LP")
	var constant_timer : float = clamp(LP_damage * 0.05, 0.2, 0.8)
	match target:
		"player": LP_info_node = get_node("../user_interface/top_info_box/player_info/lifepoints")
		"enemy": LP_info_node = get_node("../user_interface/top_info_box/com_info/lifepoints")
		_: print("no target to change lifepoints.")
	tween_LP.interpolate_method(self, "LP_method_for_tween", int(LP_info_node.get_text()), clamp(int(LP_info_node.get_text()) - LP_damage, 0, 9999), constant_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_LP.start()

func LP_method_for_tween(value : int):
	LP_info_node.text = String(value)

