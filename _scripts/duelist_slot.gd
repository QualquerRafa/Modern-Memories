extends Button

export var this_duelist_name = ""
onready var free_duel_node_path = get_node("../../../../")

func _ready():
	$duelist_name.text = this_duelist_name
	$duelist_face.texture = load("res://_resources/character_faces/" + this_duelist_name + "0.png")
	
	if not PlayerData.recorded_duels.keys().has(this_duelist_name):
		PlayerData.recorded_duels[this_duelist_name] = {"W":0, "L":0}
	
	$win_count.text = "W: " + String(PlayerData.recorded_duels[this_duelist_name].W)
	$loss_count.text = "L: " + String(PlayerData.recorded_duels[this_duelist_name].L)

func active_this_duelist():
	#Darken the previously highlighted button
	for duelist_button in self.get_parent().get_children():
		if duelist_button.this_duelist_name == free_duel_node_path.active_duelist_name:
			duelist_button.modulate = Color(0.5, 0.5, 0.5, 1)
			break
	
	#Highlight the correct button
	free_duel_node_path.active_duelist_name = this_duelist_name
	self.modulate = Color(1, 1, 1, 1)
	

func _on_duelist_slot_button_up():
	#prevents this node from acting outside of 'free_duel' scene
	if free_duel_node_path.get_name() != "free_duel":
		return
	
	SoundControl.play_sound("poc_cursor")
	
	#Pass up the duelist name so the list can be correctly updated
	free_duel_node_path.update_duelist_cards(this_duelist_name)
	active_this_duelist()
	
	#Unhighlight any highlighted card
	if get_node("/root/free_duel/user_interface/card_info_box").current_highlighted_card != null:
		get_node("/root/free_duel/user_interface/card_info_box").current_highlighted_card.reset_highlighted_card()
	
	#Reset scrollbar of the cards to the top
	get_node("/root/free_duel/panel_right/duelist_cards").set_v_scroll(0)
