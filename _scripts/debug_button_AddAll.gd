extends Button

func _on_DebugAddAll_button_up():
	for i in range(CardList.card_list.size()):
		var id_as_padded_string = String(i).pad_zeros(5)
		if id_as_padded_string in PlayerData.player_trunk:
			PlayerData.player_trunk[id_as_padded_string] += 1 #register another copy of the card to the already existing id key
		else: 
			PlayerData.player_trunk[id_as_padded_string] = 1 #card is not in trunk, so add it's key:value pair as id:count

	#update both sides' panels
	var sorter =  get_node("../").get_child(0).get_child(2)
	var newly_sorted_trunk = sorter.sort_cards(PlayerData.player_trunk.keys(), sorter.last_sorted_type)
	get_node("../").update_left_panel(newly_sorted_trunk)
	get_node("../").update_right_panel()
