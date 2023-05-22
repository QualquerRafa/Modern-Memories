extends Control

func _on_reset_scene_button_button_up():
	var _reloaded = get_tree().reload_current_scene()


func _on_change_card_id_button_up():
	get_node("../player_hand/card_0").update_card_information("00703")
	get_node("../player_hand/card_1").update_card_information("00699")
	#get_node("../player_hand/card_2").update_card_information("00429")
	#get_node("../player_hand/card_3").update_card_information("00430")
	#get_node("../player_hand/card_4").update_card_information("00497")

func _on_print_phase_button_up():
	print(get_node("../game_logic").GAME_PHASE)
