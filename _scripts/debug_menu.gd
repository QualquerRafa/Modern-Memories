extends Control

func _on_reset_scene_button_button_up():
	print("DEBUG: resetting scene")
	var _reloaded = get_tree().reload_current_scene()

func _on_change_card_id_button_up():
	get_node("../player_hand/card_0").update_card_information("00990")
	get_node("../player_hand/card_1").update_card_information("00787")
	get_node("../player_hand/card_2").update_card_information("01091")
	get_node("../player_hand/card_3").update_card_information("00120")
	get_node("../player_hand/card_4").update_card_information("00119")

func _on_print_phase_button_up():
	print("DEBUG: ", get_node("../game_logic").GAME_PHASE)

func _on_change_field_view_button_up():
	get_node("../").change_field_view()

func _on_phase_rewind_button_up():
	get_node("../game_logic/player_logic").start_player_turn()

func _on_end_duel_button_up():
	get_node("../game_logic").check_for_game_end("DEBUG_END_DUEL")

func _on_mill_Com_button_up():
	for _i in range(39):
		get_node("../game_logic/enemy_logic").enemy_deck.remove(0) #remove that same card from deck
