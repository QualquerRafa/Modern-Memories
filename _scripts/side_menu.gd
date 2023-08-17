extends Node2D

var position_in = Vector2(0,0)
var position_out = Vector2(-310,0)

var list_of_fusions_in_this_duel = [] #populated by player_logic and enemy_logic when they do fusions

func _ready():
	#Only show the Speed Up and forfeit button if it's a Free Duel. TUDO TEM LIMITE NESSA BUDEGA.
	if PlayerData.scene_to_return_after_duel != "free_duel":
		$top_row/buttons.hide()
		Engine.set_time_scale(1.0) #just to be safe
	
	#Start free duels with the registered speed up
	if PlayerData.scene_to_return_after_duel == "free_duel":
		Engine.set_time_scale(PlayerData.registered_freeduel_speed)
		$top_row/buttons/button_speed/label.text = String(PlayerData.registered_freeduel_speed) + "X"
	
	#Properly load the texts in the correct language
	$cards_of_fusion/fusion_history_title.text = GameLanguage.duel_scene.side_menu.fusion_history[PlayerData.game_language]
	$top_row/buttons/button_giveup/label.text = GameLanguage.duel_scene.side_menu.forfeit[PlayerData.game_language]

#-------------------------------------------------------------------------------
#Animations of Showing and Hiding the side menu
func _on_block_clicks_behind_button_up():
	if self.modulate == Color(1,1,1,1):
		#Hide this side menu thingy
		var animation_timer = 0.5
		$Tween.interpolate_property(self, "position", position_in, position_out, animation_timer/2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), animation_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		yield($Tween, "tween_completed")
		
		self.hide()

func _on_history_button_button_up():
	var phases_you_can_click = ["looking_at_hand", "main_phase"]
	if not get_node("../game_logic").GAME_PHASE in phases_you_can_click:
		return
	
	#If the moment is appropriate, clicking on this button will show the Side Menu
	show_side_menu()
	
	#Animate the click
	history_button_out()
	yield(get_tree().create_timer(0.5), "timeout")
	history_button_in()

onready var button = get_node("../history_button")
var history_in = Vector2(-23,39)
var history_out = Vector2(-90,39)
func history_button_out():
	$Tween.interpolate_property(button, "rect_position", history_in, history_out, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
func history_button_in():
	$Tween.interpolate_property(button, "rect_position", history_out, history_in, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func show_side_menu():
	update_fusion_history()
	update_current_rank()
	
	#Prepare it
	self.modulate = Color(1,1,1,1)
	self.position = position_in
	self.show()
	
	var animation_timer = 0.3
	$Tween.interpolate_property(self, "position", position_out, position_in, animation_timer/2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), animation_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

#-------------------------------------------------------------------------------
# Functions of the screen itself
func update_fusion_history():
	var container_for_fusion_history = $cards_of_fusion/ScrollContainer/VBoxContainer
	var fusion_history_node_ref = load("res://_scenes/fusion_history.tscn")
	
	var ref_count = list_of_fusions_in_this_duel.size()
	for i in range(ref_count):
		var new_history_instance = fusion_history_node_ref.instance()
		var fusion_record = list_of_fusions_in_this_duel[i]
		
		new_history_instance.get_node("card_a").update_card_information(String(fusion_record[0])) #card_a
		new_history_instance.get_node("card_b").update_card_information(String(fusion_record[1])) #card_b
		
		if fusion_record[2] != fusion_record[0] and fusion_record[2] != fusion_record[1]:
			new_history_instance.get_node("card_c").this_card_flags.fusion_type = "fusion"
		
		new_history_instance.get_node("card_c").update_card_information(String(fusion_record[2])) #fusion_result
		
		container_for_fusion_history.add_child(new_history_instance)
		container_for_fusion_history.move_child(new_history_instance, 0)
	
	#At the end, clear the list
	list_of_fusions_in_this_duel.clear()

func update_current_rank():
	var reward_scene = get_node("../reward_scene")
	
	#Pass ahead the important information for Rewards calculations
	reward_scene.duel_deck_count = get_node("../game_logic/player_logic").player_deck.size()
	reward_scene.duel_fusion_count = get_node("../game_logic/player_logic").fusion_count
	reward_scene.duel_effect_count = get_node("../game_logic/player_logic").effect_count
	reward_scene.duel_spelltrap_count = get_node("../game_logic/player_logic").spelltrap_count
	
	reward_scene.final_turn_count = int(get_node("../user_interface/top_info_box/field_info/turn").get_text().split(" ")[1])
	reward_scene.final_player_LP = int(get_node("../user_interface/top_info_box/player_info/lifepoints").get_text())
	var total_field_atk = 0
	for i in range(5):
		var checking_node = get_node("../duel_field/player_side_zones/monster_" + String(i))
		if checking_node.is_visible():
			total_field_atk += int(checking_node.get_node("card_design/monster_features/atk_def/atk").get_text())
	reward_scene.final_field_atk = total_field_atk
	
	var get_rank_letter = reward_scene.get_duel_rank()

	#Copy paste from 'reward_scene'
	var rank_letter_colors = {
		#"rank" : ["font_color", "font_color_shadow"]
		"S" : ["e6c95d", "c49320"], #dourado
		"A" : ["ff3434", "840b33"], #vermelho
		"B" : ["b427d6", "540b86"], #roxo
		"C" : ["2a7ade", "0b2286"], #azul
		"D" : ["31c437", "08743c"], #verde
		"F" : ["b8b8b8", "4f4f4f"], #cinza
	}
	
	#Update it visually
	$top_row/rank_indicator/rank_letter.text = get_rank_letter
	$top_row/rank_indicator/rank_letter.add_color_override("font_color", rank_letter_colors[get_rank_letter][0])
	$top_row/rank_indicator/rank_letter.add_color_override("font_color_shadow", rank_letter_colors[get_rank_letter][1])

var current_game_speed = PlayerData.registered_freeduel_speed
func _on_button_speed_button_up():
	if gave_up_game == true:
		Engine.set_time_scale(1.0)
		return
	
	animate_button($top_row/buttons/button_speed)
	
	match current_game_speed:
		1.0, 2.0:
			current_game_speed += 1.0
		3.0:
			current_game_speed = 1.0
	
	$top_row/buttons/button_speed/label.text = String(current_game_speed) + "X"
	PlayerData.registered_freeduel_speed = current_game_speed
	Engine.set_time_scale(current_game_speed)

var gave_up_game = false
func _on_button_giveup_button_up():
	gave_up_game = true
	animate_button($top_row/buttons/button_giveup)
	get_node("../game_logic").check_for_game_end("player_forfeit")

func animate_button(button_node):
	SoundControl.play_sound("poc_decide")
	
	#Animate the button being clicked
	var small_scale = Vector2(0.9 , 0.9)
	var normal_scale = Vector2(1 , 1)
	
	$Tween.interpolate_property(button_node, "rect_scale", button_node.rect_scale, small_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	$Tween.interpolate_property(button_node, "rect_scale", button_node.rect_scale, normal_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
