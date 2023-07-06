extends Node2D

var position_in = Vector2(0,0)
var position_out = Vector2(-310,0)

var list_of_fusions_in_this_duel = [] #populated by player_logic and enemy_logic when they do fusions

func _ready():
	#Startup stuff
	#Properly load the texts in the correct language
	pass

#-------------------------------------------------------------------------------
#Animations of Showing and Hiding the side menu
func _on_block_clicks_behind_button_up():
	if self.is_visible():
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

func show_side_menu():
	update_fusion_history()
	update_current_rank()
	
	#Prepare it
	self.modulate = Color(1,1,1,1)
	self.position = position_in
	self.show()
	
	var animation_timer = 0.5
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
		new_history_instance.get_node("card_c").this_card_flags.fusion_type = "fusion"
		new_history_instance.get_node("card_c").update_card_information(String(fusion_record[2][0])) #fusion_result
		
		container_for_fusion_history.add_child(new_history_instance)
		container_for_fusion_history.move_child(new_history_instance, 0)
	
	#At the end, clear the list
	list_of_fusions_in_this_duel.clear()

func update_current_rank():
	var get_rank_letter = get_node("../reward_scene").get_duel_rank()

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
	$duel_rank_indicator/rank_letter.text = get_rank_letter
	$duel_rank_indicator/rank_letter.add_color_override("font_color", rank_letter_colors[get_rank_letter][0])
	$duel_rank_indicator/rank_letter.add_color_override("font_color_shadow", rank_letter_colors[get_rank_letter][1])
	

var current_game_speed = 1.0
func _on_button_speed_button_up():
	match current_game_speed:
		1.0, 2.0:
			current_game_speed += 1.0
		3.0:
			current_game_speed = 1.0
	
	$button_speed.text = String(current_game_speed)
	Engine.set_time_scale(current_game_speed)

func _on_button_giveup_button_up():
	pass # Replace with function body.
