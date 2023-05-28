extends Control

func _on_reset_scene_button_button_up():
	print("DEBUG: resetting scene")
	var _reloaded = get_tree().reload_current_scene()

func _on_change_card_id_button_up():
	get_node("../player_hand/card_0").update_card_information("00119")
	get_node("../player_hand/card_1").update_card_information("00120")
	get_node("../player_hand/card_2").update_card_information("00429")
	get_node("../player_hand/card_3").update_card_information("00430")
	get_node("../player_hand/card_4").update_card_information("00497")

func _on_print_phase_button_up():
	print("DEBUG: ", get_node("../game_logic").GAME_PHASE)

func _on_change_field_view_button_up():
	get_node("../").change_field_view()

func _on_phase_rewind_button_up():
	get_node("../game_logic/player_logic").start_player_turn()
