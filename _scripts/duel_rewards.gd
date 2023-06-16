extends Node2D

onready var npc_decks_gd_script = preload("res://_scripts/npc_decks.gd")
onready var npc_decks_gd = npc_decks_gd_script.new()

#These are passed by the Duel Logic
var duel_winner : String

var duel_deck_count :int #= 33
var duel_fusion_count :int #= 22
var duel_effect_count : int #= 22
var duel_spelltrap_count : int #= 5
var defeated_duelist : String #= PlayerData.going_to_duel

var final_turn_count : int
var final_player_LP : int
var final_field_atk : int

func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	
	#Show the YOU WIN/LOSE first
	show_big_letters()
	
	#Show facedown for reward cards
	$cards_reward/HBoxContainer/reward_1/card_design/card_back.show()
	$cards_reward/HBoxContainer/reward_2/card_design/card_back.show()
	$cards_reward/HBoxContainer/reward_3/card_design/card_back.show()
	
	#Initialize stuff on 'card_info_box' hidden
	$user_interface/card_info_box/card_name.hide()
	$user_interface/card_info_box/atk_def.hide()
	$user_interface/card_info_box/extra_icons.hide()
	$user_interface/card_info_box/card_text.hide()
	
	#Initial state of things
	$duel_info/deck_used.text = "00"
	$duel_info/fusion_used.text = "00"
	$duel_info/effects_used.text = "00"
	$duel_info/spelltrap_used.text = "00"
	$rank_info.hide()
	$starchip_reward.hide()

####################################################################################################
# CALCULATE REWARDS FUNCTIONS
####################################################################################################
func get_duel_rank():
	var rank_letter_colors = {
		#"rank" : ["font_color", "font_color_shadow"]
		"S" : ["e6c95d", "c49320"], #dourado
		"A" : ["ff3434", "840b33"], #vermelho
		"B" : ["b427d6", "540b86"], #roxo
		"C" : ["2a7ade", "0b2286"], #azul
		"D" : ["31c437", "08743c"], #verde
		"F" : ["b8b8b8", "4f4f4f"], #cinza
	}
	
	var final_duel_score : int = 0
	
	#For deck count, the more cards still in the deck the better
	if duel_deck_count > 28: final_duel_score += 3
	elif duel_deck_count >= 20: final_duel_score += 2
	else: final_duel_score += 1
	
	#For fusion count, the more the better
	if duel_fusion_count <= 2: final_duel_score += 1
	elif duel_fusion_count <= 4: final_duel_score += 2
	elif duel_fusion_count <= 10: final_duel_score += 3
	else: final_duel_score += 4
	
	#For effect count, the more the better
	if duel_effect_count <= 6: final_duel_score += 1
	elif duel_effect_count <= 14: final_duel_score += 2
	else: final_duel_score += 3
	
	#For spelltrap count, the more the better
	if duel_spelltrap_count <= 3: final_duel_score += 1
	elif duel_spelltrap_count <= 6: final_duel_score += 2
	else: final_duel_score += 3
	
	#Extra points
	if final_turn_count <= 3: final_duel_score += 2
	elif final_duel_score <= 5: final_duel_score += 1
	
	if final_player_LP > 8000: final_duel_score += 2
	elif final_player_LP > 6000: final_duel_score += 1
	
	if final_field_atk > 9000: final_duel_score += 2
	if final_field_atk > 5000: final_duel_score += 1
	
	#Get a letter from the score
	var final_rank_letter : String = ""
	if final_duel_score <= 4: final_rank_letter = "F"
	elif final_duel_score <= 5: final_rank_letter = "D"
	elif final_duel_score <= 7: final_rank_letter = "C"
	elif final_duel_score <= 9: final_rank_letter = "B"
	elif final_duel_score <= 11: final_rank_letter = "A"
	elif final_duel_score >= 12: final_rank_letter = "S"
	
	#Update it visually
	$rank_info/rank_letter.text = final_rank_letter
	$rank_info/rank_letter.add_color_override("font_color", rank_letter_colors[final_rank_letter][0])
	$rank_info/rank_letter.add_color_override("font_color_shadow", rank_letter_colors[final_rank_letter][1])
	
	return final_rank_letter

func get_starchips_reward():
	var final_stars : int
	match $rank_info/rank_letter.text:
		"S": final_stars = 10
		"A": final_stars = 5
		"B": final_stars = 4
		"C": final_stars = 3
		"D": final_stars = 2
		"E": final_stars = 1
		"F": final_stars = 1
	
	$starchip_reward/number.text = String(final_stars)
	return final_stars

func get_card_rewards():
	#S: GCR, RS, SU
	#A: GC, CR, RS
	#B: GC, CR, CR
	#C,D: GC, GCR, CR
	#E,F: GC, GC, C
	var npc_card_pool = npc_decks_gd.list_of_decks[defeated_duelist] #GAME_LOGIC.get_node("enemy_logic/npc_decks_gd").list_of_decks[PlayerData.going_to_duel]
	
	#Get the first card Reward
	var reward_1 : String #card_id
	var pool_for_reward_1 : Array = []
	pool_for_reward_1 = CardList.general_card_pool + npc_card_pool.C
	if $rank_info/rank_letter.text == "S": pool_for_reward_1 = pool_for_reward_1 + npc_card_pool.R
	
	var random_card_index_1 = randi()%pool_for_reward_1.size()
	reward_1 = pool_for_reward_1[random_card_index_1].pad_zeros(5)
	$cards_reward/HBoxContainer/reward_1.update_card_information(reward_1)
	$cards_reward/HBoxContainer/reward_1/card_design/card_back.show()
	
	#Get the second card reward
	var reward_2 : String #card_id
	var pool_for_reward_2 : Array = []
	match $rank_info/rank_letter.text:
		"E", "F":
			pool_for_reward_2 = CardList.general_card_pool + npc_card_pool.C
		"C", "D":
			pool_for_reward_2 = CardList.general_card_pool + npc_card_pool.C + npc_card_pool.R
		"B", "A":
			pool_for_reward_2 = npc_card_pool.C + npc_card_pool.R
		"S":
			pool_for_reward_2 = npc_card_pool.R + npc_card_pool.SR
	var random_card_index_2 = randi()%pool_for_reward_2.size()
	reward_2 = pool_for_reward_2[random_card_index_2].pad_zeros(5)
	$cards_reward/HBoxContainer/reward_2.update_card_information(reward_2)
	$cards_reward/HBoxContainer/reward_2/card_design/card_back.show()
	
	#Get the third card reward
	var reward_3 : String #card_id
	var pool_for_reward_3 : Array = []
	match $rank_info/rank_letter.text:
		"E", "F":
			pool_for_reward_2 = npc_card_pool.C
		"C", "D", "B":
			pool_for_reward_3 = npc_card_pool.C + npc_card_pool.R
		"A":
			pool_for_reward_3 = npc_card_pool.R + npc_card_pool.SR
		"S":
			pool_for_reward_3 = npc_card_pool.SR + npc_card_pool.UR
	var random_card_index_3 = randi()%pool_for_reward_3.size()
	reward_3 = pool_for_reward_3[random_card_index_3].pad_zeros(5)
	$cards_reward/HBoxContainer/reward_3.update_card_information(reward_3)
	$cards_reward/HBoxContainer/reward_3/card_design/card_back.show()
	
	return [reward_1, reward_2, reward_3]

####################################################################################################
# PLAYER INTERACTION HANDLING
####################################################################################################
func _on_screen_button_button_up():
	
	if !$BIG_LETTERS/tween.is_active():
		if duel_winner == "player":
			show_duel_info()
		else:
			#Only one click
			if not $BIG_LETTERS.is_visible():
				return
			
			#Hide everything, otherwise scene transition doesn't work ????
			$user_interface.hide()
			$cards_reward.hide()
			$duel_info.hide()
			$rank_info.hide()
			$starchip_reward.hide()
			
			var tweener = $BIG_LETTERS/tween
			var text_timer : float = 1
			tweener.interpolate_property($BIG_LETTERS, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), text_timer/2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tweener.start()
			yield(tweener, "tween_completed")
			$BIG_LETTERS.hide()
			
			match PlayerData.scene_to_return_after_duel:
				"tournament_scene": #When losing in the tournament, we need to show the opponents Win message and there it will send the player to main_menu
					$scene_transitioner.scene_transition("tournament_scene")
					
				_: #default return, should be changed to the Game Over screen I think
					$scene_transitioner.scene_transition("main_menu")

var phase_of_reveal = 0
func show_duel_info():
	match phase_of_reveal:
		0:
			#Hide the YOU WIN text
			var tweener = $BIG_LETTERS/tween
			var text_timer : float = 1
			tweener.interpolate_property($BIG_LETTERS, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), text_timer/2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tweener.start()
			yield(tweener, "tween_completed")
			$BIG_LETTERS.hide()
			
			SoundControl.play_sound("poc_decide")
			
			#Do the counting animation for each category kept track
			tween_card_count($duel_info/deck_used, duel_deck_count, $tweens/tween_1)
			tween_card_count($duel_info/fusion_used, duel_fusion_count, $tweens/tween_2)
			tween_card_count($duel_info/effects_used, duel_effect_count, $tweens/tween_3)
			tween_card_count($duel_info/spelltrap_used, duel_spelltrap_count, $tweens/tween_4)
			#increment phase
			phase_of_reveal += 1
		
		1:
			#Force the countings to it's final values
			$duel_info/deck_used.text = String(duel_deck_count).pad_zeros(2)
			$duel_info/fusion_used.text = String(duel_fusion_count).pad_zeros(2)
			$duel_info/effects_used.text = String(duel_effect_count).pad_zeros(2)
			$duel_info/spelltrap_used.text = String(duel_spelltrap_count).pad_zeros(2)
			
			SoundControl.play_sound("poc_decide")
			
			#Calculate and show the final Rank
			get_duel_rank()
			$rank_info.show()
			#increment phase
			phase_of_reveal += 1
		
		2:
			SoundControl.play_sound("poc_decide")
			
			#Calculate and show the Starchips earned
			get_starchips_reward()
			$starchip_reward.show()
			#increment phase
			phase_of_reveal += 1
		
		3:
			#Flip the first reward
			var rewarded_cards = get_card_rewards()
			register_player_rewards(int($starchip_reward/number.get_text()), rewarded_cards)
			
			flip_a_reward($cards_reward/HBoxContainer/reward_1, $tweens/tween_1)
			$user_interface/card_info_box.update_user_interface($cards_reward/HBoxContainer/reward_1)
			#increment phase
			phase_of_reveal += 1
		
		4:
			#Flip the second reward
			flip_a_reward($cards_reward/HBoxContainer/reward_2, $tweens/tween_2)
			$user_interface/card_info_box.update_user_interface($cards_reward/HBoxContainer/reward_2)
			#increment phase
			phase_of_reveal += 1
		
		5:
			#Flip the third reward
			flip_a_reward($cards_reward/HBoxContainer/reward_3, $tweens/tween_3)
			$user_interface/card_info_box.update_user_interface($cards_reward/HBoxContainer/reward_3)
			#increment phase
			phase_of_reveal += 1
		
		_:
			if get_viewport().get_mouse_position().y >= 75 and get_viewport().get_mouse_position().y <= 562:
				if get_viewport().get_mouse_position().x >= 179 and get_viewport().get_mouse_position().x <= 511:
					$user_interface/card_info_box.update_user_interface($cards_reward/HBoxContainer/reward_1)
				elif get_viewport().get_mouse_position().x >= 541 and get_viewport().get_mouse_position().x <= 873:
					$user_interface/card_info_box.update_user_interface($cards_reward/HBoxContainer/reward_2)
				elif get_viewport().get_mouse_position().x >= 904 and get_viewport().get_mouse_position().x <= 1234:
					$user_interface/card_info_box.update_user_interface($cards_reward/HBoxContainer/reward_3)
				else:
					if PlayerData.scene_to_return_after_duel != "":
						$scene_transitioner.scene_transition(PlayerData.scene_to_return_after_duel)
						remove_reward_scene_from_tree()
					else:
						$scene_transitioner.scene_transition("main_menu")
						remove_reward_scene_from_tree()
			
			else:
				if PlayerData.scene_to_return_after_duel != "":
					$scene_transitioner.scene_transition(PlayerData.scene_to_return_after_duel)
					remove_reward_scene_from_tree()
				else:
					$scene_transitioner.scene_transition("main_menu")
					remove_reward_scene_from_tree()

func remove_reward_scene_from_tree():
	#print(get_node("..").get_children())
	$final_timer.start(2); yield($final_timer, "timeout")
	get_node("../reward_scene").queue_free()
	#print(get_node("..").get_children())

####################################################################################################
# AUXILIARY FUNCTIONS
####################################################################################################
func flip_a_reward(reward_id : Node, tweener : Node):
	var flipping_timer = 0.3
	
	SoundControl.play_sound("poc_move")
	
	tweener.interpolate_property(reward_id, "rect_scale", Vector2(1, 1), Vector2(0.05, 1), flipping_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweener.start()
	tweener.get_node("timer").start(flipping_timer); yield(tweener.get_node("timer"), "timeout")
	reward_id.get_node("card_design/card_back").hide()
	
	tweener.interpolate_property(reward_id, "rect_scale", Vector2(0.05, 1), Vector2(1, 1), flipping_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweener.start()
	tweener.get_node("timer").start(flipping_timer); yield(tweener.get_node("timer"), "timeout")

func tween_card_count(count_label : Node, final_value : int, tweener : Node):
	var step_timer = 0.05
	
	for _i in range(final_value):
		if int(count_label.text) < final_value:
			count_label.text = String(int(count_label.text) + 1).pad_zeros(2)
			tweener.get_node("timer").start(step_timer); yield(tweener.get_node("timer"), "timeout")

func register_player_rewards(starchips : int, array_of_3 : Array):
	#Register the Starchips earned
	PlayerData.player_starchips += starchips
	
	#Register the 3 rewarded cards in the Player's Trunk
	for card_reward in array_of_3:
		if card_reward in PlayerData.player_trunk:
			PlayerData.player_trunk[card_reward] += 1 #register another copy to an already existing 'card_reward' in player's trunk
		else:
			PlayerData.player_trunk[card_reward] = 1 #add the first copy as the registering of 'card_reward'

func show_big_letters():
	if duel_winner == "player":
		PlayerData.last_duel_result = "win"
		$BIG_LETTERS/YOU.add_color_override("font_color","ff0000") #RED
		$BIG_LETTERS/win_lose.text = "WIN"
		$BIG_LETTERS/win_lose.add_color_override("font_color","ff0000") #RED
	else:
		PlayerData.last_duel_result = "lose"
		$BIG_LETTERS/YOU.add_color_override("font_color","0000ff") #BLUE
		$BIG_LETTERS/win_lose.text = "LOSE"
		$BIG_LETTERS/win_lose.add_color_override("font_color","0000ff") #BLUE
	
	$BIG_LETTERS.show()
	
	#Do the animation of the words comming in on the screen
	var tweener = $BIG_LETTERS/tween
	var x_position_offset : int = 1280
	var text_timer : float = 1
	
	tweener.interpolate_property($BIG_LETTERS/YOU, "rect_position:x", $BIG_LETTERS/YOU.rect_position.x - x_position_offset, $BIG_LETTERS/YOU.rect_position.x, text_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweener.interpolate_property($BIG_LETTERS/win_lose, "rect_position:x", $BIG_LETTERS/win_lose.rect_position.x + x_position_offset, $BIG_LETTERS/win_lose.rect_position.x, text_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweener.start()
	yield(tweener, "tween_completed")
	
	$BIG_LETTERS/timer.start(text_timer/2); yield($BIG_LETTERS/timer, "timeout")
	
	#tweener.interpolate_property($BIG_LETTERS, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), text_timer/2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#tweener.start()
	#yield(tweener, "tween_completed")
	
	#show_duel_info()
