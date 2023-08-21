extends Button

onready var deck_building_root = get_tree().get_current_scene()
onready var decks_list_node = deck_building_root.get_node("decks_list/")

func _ready():
	#Load the 'New' in the proper language
	decks_list_node.get_node("panel/ScrollContainer/MarginContainer/GridContainer/new_deck/deck_name").text = GameLanguage.system.new[PlayerData.game_language]
	
	#Transform the registered color for decks because when it's loaded from a save file it come as a String with RGBA concatenated lol
	for deck in PlayerData.list_of_player_decks:
		if typeof(PlayerData.list_of_player_decks[deck].color) != TYPE_COLOR:
			var color_as_string = PlayerData.list_of_player_decks[deck].color
			var separated_colors = color_as_string.split(",")
			var corrected_as_color_type = Color(separated_colors[0], separated_colors[1], separated_colors[2], separated_colors[3])
			PlayerData.list_of_player_decks[deck].color = corrected_as_color_type
	
	#For the main button, show the Active Deck information
	if self.get_parent().get_name() == "panel_right":
		$deck_name.text = PlayerData.active_deck_name
		$deck_box.self_modulate = PlayerData.list_of_player_decks[PlayerData.active_deck_name].color
		$delete.hide()
		
		$edit_deckbox/O.add_color_override("font_outline_modulate", PlayerData.list_of_player_decks[PlayerData.active_deck_name].color)
		$edit_deckbox/O.add_color_override("font_color_shadow", PlayerData.list_of_player_decks[PlayerData.active_deck_name].color)
		$edit_deckbox.show()

func _on_deck_slot_button_up():
	#Show the deck list window
	if not decks_list_node.is_visible():
		#Animate the button click
		deck_building_root.button_click_animation(self.get_path())
		
		decks_list_node.show()
		
		#Populate the window with each deck player has registered
		for deck in PlayerData.list_of_player_decks:
			create_deck_box(deck, PlayerData.list_of_player_decks[deck].color)
	
	#If the deck_slot being clicked is one of the shown in the list, update player current deck
	if self.get_parent().get_name() == "GridContainer":
		var main_deck_icon_ref = deck_building_root.get_node("panel_right/deck_slot")
		
		#First, save current deck as is
		PlayerData.list_of_player_decks[main_deck_icon_ref.get_node("deck_name").get_text()].deck = PlayerData.player_deck
		
		#Second, load the clicked deck
		var clicked_deck_name = $deck_name.text
		PlayerData.player_deck = PlayerData.list_of_player_decks[clicked_deck_name].deck
		PlayerData.active_deck_name = clicked_deck_name
		#Update panels
		deck_building_root.update_right_panel()
		var sorter =  deck_building_root.get_child(0).get_child(2)
		var newly_sorted_trunk = sorter.sort_cards(PlayerData.player_trunk.keys(), sorter.last_sorted_type)
		deck_building_root.update_left_panel(newly_sorted_trunk)
		
		#Third, update the main deck indicator
		main_deck_icon_ref.get_node("deck_name").text = PlayerData.active_deck_name
		main_deck_icon_ref.get_node("deck_box").self_modulate = PlayerData.list_of_player_decks[PlayerData.active_deck_name].color
		main_deck_icon_ref.get_node("edit_deckbox/O").add_color_override("font_outline_modulate", PlayerData.list_of_player_decks[PlayerData.active_deck_name].color)
		main_deck_icon_ref.get_node("edit_deckbox/O").add_color_override("font_color_shadow", PlayerData.list_of_player_decks[PlayerData.active_deck_name].color)
		
		#Finally, hide the window
		hide_decklist_window()

#Register a New Deck
func _on_new_deck_button_up():
	#Animate the button
	deck_building_root.button_click_animation(decks_list_node.get_node("panel/ScrollContainer/MarginContainer/GridContainer/new_deck").get_path())
	
	var new_deck_name = String(PlayerData.list_of_player_decks.keys().size() + 1).pad_zeros(3)
	for i in range(1000):
		if PlayerData.list_of_player_decks.keys().has(new_deck_name):
			new_deck_name = String(int(new_deck_name) + i).pad_zeros(3)
		else:
			break
	
	randomize()
	var rand_r = randf()
	var rand_g = randf()
	var rand_b = randf()
	var new_deck_color = Color(rand_r, rand_g, rand_b, 1)
	create_deck_box(new_deck_name, new_deck_color)
	
	#Register the New deck as a Valid one in PlayerData
	PlayerData.list_of_player_decks[new_deck_name] = {"deck":[], "color":new_deck_color}

#Animate the mouse over "New Deck"
func _on_new_deck_mouse_entered():
	$box_tween.interpolate_property(decks_list_node.get_node("panel/ScrollContainer/MarginContainer/GridContainer/new_deck"), "rect_scale", Vector2(1,1), Vector2(1.1, 1.1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$box_tween.start()
func _on_new_deck_mouse_exited():
	$box_tween.interpolate_property(decks_list_node.get_node("panel/ScrollContainer/MarginContainer/GridContainer/new_deck"), "rect_scale", Vector2(1.1, 1.1), Vector2(1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$box_tween.start()

func create_deck_box(deck_name : String, deck_color : Color):
	var container_node_ref = decks_list_node.get_node("panel/ScrollContainer/MarginContainer/GridContainer/")
	var deck_node_file = load("res://_scenes/deck_slot.tscn")
	
	#Instance only the exact amount of nodes that is necessary to show
	var instance_of_deck_node = deck_node_file.instance()
	container_node_ref.add_child(instance_of_deck_node)
	
	instance_of_deck_node.get_node("deck_name").text = deck_name
	instance_of_deck_node.get_node("deck_box").self_modulate = deck_color
	
	#Hide the Delete button if it's the active deck. Prevent bugging the game.
	if deck_name == PlayerData.active_deck_name:
		instance_of_deck_node.get_node("delete").hide()

#Hide the 'decks_list' interface when clicking anywhere in the darker bg
func _on_darken_screen_button_up():
	hide_decklist_window()
func hide_decklist_window():
	decks_list_node.hide()
	
	#Remove all the 'deck_slots' children of the window
	var window = decks_list_node.get_node("panel/ScrollContainer/MarginContainer/GridContainer/")
	for children in window.get_children():
		#keep the "new_deck" button
		if children.get_name() == "new_deck":
			continue
		
		window.remove_child(children)
		children.queue_free()

#Delete this Deck Slot
func _on_delete_button_up():
	if $delete.is_visible():
		var _erased = PlayerData.list_of_player_decks.erase($deck_name.get_text())
		self.queue_free()

#Edit this deckbox name and color
func _on_edit_deckbox_button_up():
	#Animate the click
	deck_building_root.button_click_animation(deck_building_root.get_node("panel_right/deck_slot/edit_deckbox").get_path())
	
	#Show the customize_deckbox window
	var customize_window_node = deck_building_root.get_node("customize_deckbox")
	
	customize_window_node.get_node("panel/name_label").text = GameLanguage.system.name[PlayerData.game_language] + ":"
	customize_window_node.get_node("panel/color_label").text = GameLanguage.system.color[PlayerData.game_language] + ":"
	customize_window_node.get_node("panel/name_label/player_type").text = PlayerData.active_deck_name
	customize_window_node.get_node("panel/color_label/color_button/color_panel").self_modulate = PlayerData.list_of_player_decks[PlayerData.active_deck_name].color
	
	customize_window_node.show()

func _on_color_button_button_up():
	#Animate the click
	deck_building_root.button_click_animation(deck_building_root.get_node("customize_deckbox/panel/color_label/color_button").get_path())
	
	#Show the color picker window
	deck_building_root.get_node("customize_deckbox/panel/color_label/color_pick_window/ColorPicker").color = PlayerData.list_of_player_decks[PlayerData.active_deck_name].color
	deck_building_root.get_node("customize_deckbox/panel/color_label/color_pick_window").show()
func _on_color_pick_darken_screen_button_up():
	var get_player_color_input = deck_building_root.get_node("customize_deckbox/panel/color_label/color_pick_window/ColorPicker").color
	deck_building_root.get_node("customize_deckbox/panel/color_label/color_button/color_panel").self_modulate = get_player_color_input
	
	deck_building_root.get_node("customize_deckbox/panel/color_label/color_pick_window").hide()

#When closing, save the new info
func _on_customize_darken_screen_button_up():
	var customize_window_node = deck_building_root.get_node("customize_deckbox")
	
	#Player inputed new info
	var player_input_name : String = customize_window_node.get_node("panel/name_label/player_type").get_text()
	var player_input_color : Color = deck_building_root.get_node("customize_deckbox/panel/color_label/color_button/color_panel").self_modulate
	
	#Create a copy of the Active deck with the new information
	PlayerData.list_of_player_decks[player_input_name] = {"deck":PlayerData.player_deck, "color":player_input_color}
	if player_input_name != PlayerData.active_deck_name:
		#Delete the "original" deck and set the new one as the active
		var _erased = PlayerData.list_of_player_decks.erase(PlayerData.active_deck_name)
		PlayerData.active_deck_name = player_input_name
	
	#Visually update the main icon
	var main_deck_icon_ref = deck_building_root.get_node("panel_right/deck_slot")
	main_deck_icon_ref.get_node("deck_name").text = PlayerData.active_deck_name
	main_deck_icon_ref.get_node("deck_box").self_modulate = PlayerData.list_of_player_decks[PlayerData.active_deck_name].color
	main_deck_icon_ref.get_node("edit_deckbox/O").add_color_override("font_outline_modulate", PlayerData.list_of_player_decks[PlayerData.active_deck_name].color)
	main_deck_icon_ref.get_node("edit_deckbox/O").add_color_override("font_color_shadow", PlayerData.list_of_player_decks[PlayerData.active_deck_name].color)
	
	customize_window_node.hide()


#Animate the mouse over
func _on_deck_slot_mouse_entered():
	if self.get_parent().get_name() == "GridContainer":
		$box_tween.interpolate_property(self, "rect_scale", Vector2(1,1), Vector2(1.1, 1.1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$box_tween.start()
func _on_deck_slot_mouse_exited():
	if self.get_parent().get_name() == "GridContainer":
		$box_tween.interpolate_property(self, "rect_scale", Vector2(1.1, 1.1), Vector2(1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$box_tween.start()



