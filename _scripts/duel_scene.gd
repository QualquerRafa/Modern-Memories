extends Node2D

#-------------------------------------------------------------------------------
func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	
	#Properly load the text in the correct language
	$user_interface/top_info_box/player_info/YOU.text = GameLanguage.duel_scene.you[PlayerData.game_language]
	$turn_end_button/end.text = GameLanguage.duel_scene.turn_end[PlayerData.game_language]
	$user_interface/top_info_box/field_info/turn.text = GameLanguage.duel_scene.turn[PlayerData.game_language] + " 0"
	$user_interface/top_info_box/field_info/field_name.text = GameLanguage.duel_scene.no_field_bonus[PlayerData.game_language]
	
	#Initialize stuff on 'card_info_box' hidden
	$user_interface/card_info_box/card_name.hide()
	$user_interface/card_info_box/atk_def.hide()
	$user_interface/card_info_box/extra_icons.hide()
	$user_interface/card_info_box/card_text.hide()
	
	#Start player turn as the first thing to do
	$game_logic/player_logic.start_player_turn()
	
	#Some duelists will start with an active field
	if PlayerData.scene_to_return_after_duel == "game_dialog":
		var duelist_field_list = {
			"nitemare" : "dark",
			"tenma" : "light",
			"nightshroud" : "dark",
		}
		if PlayerData.going_to_duel in duelist_field_list.keys():
			$game_logic/effects.make_the_field_change(duelist_field_list[PlayerData.going_to_duel])
	
	#Wait for the intro part to play before playing the actual looping parte of the free_duel theme song
	if PlayerData.scene_to_return_after_duel == "free_duel":
		$debug_menu/debug_timer.start(1.5); yield($debug_menu/debug_timer, "timeout")
		SoundControl.play_sound("lohweo_duel_free", "music")

#-------------------------------------------------------------------------------
func update_user_interface(card_node):
	$user_interface/card_info_box.update_user_interface(card_node)

#-------------------------------------------------------------------------------
var card_in_the_middle : Button #this is setup by clicking on a 'card_' in 'player_hand'
var middle_screen_position : Vector2 = Vector2(475, -60) #arbitrary middle of the screen
var to_middle_time : float = 0.1 #in seconds

func _on_darken_screen_button_up():
	if $game_logic.GAME_PHASE == "card_options":
		SoundControl.play_sound("poc_unable")
		put_middle_card_in_hand()

func put_middle_card_in_hand():
	#failsafe if case there isn't a middle card selected
	if card_in_the_middle == null:
		return
	
	#Cancel the card in the middle of the screen and it's summoning options
	#if $game_logic.GAME_PHASE == "card_options":
	var card_in_the_middle_id : String = String(card_in_the_middle.get_name()[-1])
	var recorded_position = $game_logic/player_logic.card_references["card_"+ card_in_the_middle_id +"_references"].rect_position
	var recorded_rotation = $game_logic/player_logic.card_references["card_"+ card_in_the_middle_id +"_references"].rect_rotation
	var recorded_scale : Vector2 = Vector2(0.524, 0.524) #Scale for cards in hand is slightly bigger than on field
	
	$game_logic.reset_a_card_node_properties(card_in_the_middle)
	
	$player_hand/darken_screen.hide()
	get_node("player_hand/card_" + String(card_in_the_middle_id) + "/summon_controls").hide()
	$player_hand/hand_tween.interpolate_property(card_in_the_middle, "rect_position", card_in_the_middle.rect_position, recorded_position, to_middle_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$player_hand/hand_tween.interpolate_property(card_in_the_middle, "rect_rotation", card_in_the_middle.rect_rotation, recorded_rotation, to_middle_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$player_hand/hand_tween.interpolate_property(card_in_the_middle, "rect_scale", card_in_the_middle.rect_scale, recorded_scale, to_middle_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$player_hand/hand_tween.start()
	
	#Return the Game Phase to previous state
	show_player_entire_hand()
	yield(get_tree().create_timer(to_middle_time), "timeout")
	$game_logic.GAME_PHASE = "looking_at_hand"

#-------------------------------------------------------------------------------
var player_hand_on_screen_position : Vector2 = Vector2(0, 22)
var player_hand_out_of_screen_position : Vector2 = Vector2(0, 140)
var hand_show_time : float = 0.2 #in seconds

func hide_player_entire_hand():
	$player_hand/hand_tween.interpolate_property($player_hand, "position", $player_hand.position, player_hand_out_of_screen_position, hand_show_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$player_hand/hand_tween.start()

func show_player_entire_hand():
	$player_hand/hand_tween.interpolate_property($player_hand, "position", $player_hand.position, player_hand_on_screen_position, hand_show_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$player_hand/hand_tween.start()

func _on_back_to_hand_button_up():
	if $back_to_hand.rect_position.x != 1174:
		return
	
	SoundControl.play_sound("poc_unable")
	
	#when cancelling the summon of a monster i'm basically resetting everything that was changed by trying to summon a card
	var is_monster_or_spelltrap : String = "monster_field_slots" #monster_field_slots or spelltrap_field_slots
	if !(get_node("duel_field/player_side_zones/monster_field_slots").is_visible()):
		is_monster_or_spelltrap = "spelltrap_field_slots"
	
	$game_logic.GAME_PHASE = "looking_at_hand" #reset phase
	get_node("duel_field/player_side_zones/" + is_monster_or_spelltrap).hide()
	put_middle_card_in_hand()
	
	#Remove from fusion order the last card in the middle IN CASE it didn't have a fusion indicator on it. Only for better visual cues and shish.
	if $game_logic/player_logic.fusion_order.has(card_in_the_middle) and !(card_in_the_middle.get_node("fusion_indicator").is_visible()):
		$game_logic/player_logic.fusion_order.erase(card_in_the_middle)
	
	$player_hand.show() #show player hand after everything is resolved
	toggle_visibility_of_back_to_hand_button()
	toggle_visibility_of_change_field_view_button()

#-------------------------------------------------------------------------------
var player_field_camera_position : Vector2 = Vector2(0,0)
var enemy_field_camera_position : Vector2 = Vector2(0,640)
var time_to_cross_field = 0.3 #in seconds

func _on_change_field_view_button_up():
	if $change_field_view.rect_position.x != 1174:
		return
	
	SoundControl.play_sound("poc_move")
	
	#GAME_PHASES where player can look at the other side of the field
	match $game_logic.GAME_PHASE:
		"looking_at_hand", "main_phase", "card_options":
			pass #can look at the other side of the field
		"selecting_combat_target":
			#While at this phase, if the button is clicked, player will return to it's own field and 'main_phase'
			$game_logic.GAME_PHASE = "main_phase"
			
			#Return turn end button to be visible and cancel all current combat controls
			$game_logic.card_ready_to_attack.cancel_all_combat_controls() 
			#toggle_visibility_of_turn_end_button() #no need to call this function, as 'cancel_all_combat_controls' already does it and this would toggle it back off
		_:
			return #can't look at the other side of the field
	
	#When the button is clicked, change the view to the other side
	change_field_view()

func change_field_view():
	if $duel_field.position == player_field_camera_position:
		$change_field_view/tween.interpolate_property($duel_field, "position", $duel_field.position, enemy_field_camera_position, time_to_cross_field, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$change_field_view/tween.start()
		
		#When looking at the enemy field, if player hand is visible, lower it a little bit for a better view
		if $game_logic.GAME_PHASE == "looking_at_hand":
			hide_player_entire_hand()
		
	else:
		$change_field_view/tween.interpolate_property($duel_field, "position", $duel_field.position, player_field_camera_position, time_to_cross_field, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$change_field_view/tween.start()
		
		#When looking at the player field, make sure player hand is still visible
		if $game_logic.GAME_PHASE == "looking_at_hand":
			show_player_entire_hand()

var is_change_field_visible = false
func toggle_visibility_of_change_field_view_button():
	var position_in : Vector2 = Vector2(1174, 276)
	var position_out : Vector2  = Vector2(1274, 276)
	
	if is_change_field_visible: #is visible, move out
		$change_field_view/tween.interpolate_property($change_field_view, "rect_position", $change_field_view.rect_position, position_out, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$change_field_view/tween.start()
		is_change_field_visible = false
	elif is_change_field_visible == false: #isn't visible, move in
		$change_field_view/tween.interpolate_property($change_field_view, "rect_position", $change_field_view.rect_position, position_in, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$change_field_view/tween.start()
		is_change_field_visible = true
	else:
		print("Visibility of Change Field View Button can't be changed")

var is_turn_end_visible = false
func toggle_visibility_of_turn_end_button():
	var position_in : Vector2 = Vector2(1174, 366)
	var position_out : Vector2  = Vector2(1274, 366)
	
	if is_turn_end_visible: #is visible, move out
		$turn_end_button/tween.interpolate_property($turn_end_button, "rect_position", $turn_end_button.rect_position, position_out, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$turn_end_button/tween.start()
		is_turn_end_visible = false
	elif is_turn_end_visible == false: #isn't visible, move in
		$turn_end_button/tween.interpolate_property($turn_end_button, "rect_position", $turn_end_button.rect_position, position_in, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$turn_end_button/tween.start()
		is_turn_end_visible = true
	else:
		print("Visibility of Change Field View Button can't be changed")

var is_back_to_hand_visible = false
func toggle_visibility_of_back_to_hand_button():
	var position_in : Vector2 = Vector2(1174, 276)
	var position_out : Vector2  = Vector2(1274, 276)
		
	if is_back_to_hand_visible: #is visible, move out
		$back_to_hand/tween.interpolate_property($back_to_hand, "rect_position", $back_to_hand.rect_position, position_out, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$back_to_hand/tween.start()
		is_back_to_hand_visible = false
	elif is_back_to_hand_visible == false: #isn't visible, move in
		$back_to_hand/tween.interpolate_property($back_to_hand, "rect_position", $back_to_hand.rect_position, position_in, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$back_to_hand/tween.start()
		is_back_to_hand_visible = true
	else:
		print("Visibility of Back to Hand Button can't be changed")

func _on_turn_end_button_button_up():
	if $turn_end_button.rect_position.x != 1174:
		return
	
	SoundControl.play_sound("poc_turn_end")
	
	#Animate these buttons out so player doesn't control anything anymore
	toggle_visibility_of_turn_end_button()
	toggle_visibility_of_change_field_view_button()
	
	#Hide the history button
	get_node("side_menu").history_button_out()
	
	#At the end of player's turn, remove the darken layer from the monsters that battled this turn
	for i in range(5):
		var this_i_monster = get_node("duel_field/player_side_zones/monster_" + String(i))
		this_i_monster.get_node("card_design/darken_card").hide()
		
		if CardList.card_list[this_i_monster.this_card_id].effect.size() > 1 and typeof(CardList.card_list[this_i_monster.this_card_id].effect[1]) == TYPE_STRING and CardList.card_list[this_i_monster.this_card_id].effect[1] == "multiple_attacker":
			this_i_monster.this_card_flags.multiple_attacks = 0
	
	#Change field view to Enemy Field
	if $duel_field.position == player_field_camera_position:
		change_field_view()
	
	#Call first Enemy Turn
	$game_logic/enemy_logic.enemy_draw_phase()
