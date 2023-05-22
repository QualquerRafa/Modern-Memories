extends Node2D

func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	
	#Create Player Deck
	if PlayerData.player_deck.size() == 0:
		var _DEBUG_initialize_Player_Deck : Array = PlayerData.create_player_deck()

#---------------------------------------------------------------------------------------------------
#CLICKING THE BUTTONS
func _on_btn_campaign_button_up():
	pass # Replace with function body.
func _on_btn_free_duel_button_up():
	animate_button($CenterContainer/VBoxContainer/btn_free_duel)
	change_scene("free_duel")
func _on_btn_build_deck_button_up():
	animate_button($CenterContainer/VBoxContainer/btn_build_deck)
	change_scene("deck_building")
func _on_btn_library_button_up():
	pass # Replace with function body.
func _on_btn_password_button_up():
	animate_button($CenterContainer/VBoxContainer/btn_password)
	change_scene("card_shop")

func animate_button(node : Node):
	#Animate the button being clicked
	var small_scale = Vector2(0.9 , 0.9)
	var normal_scale = Vector2(1 , 1)
	$button_tweener.interpolate_property(node, "rect_scale", node.rect_scale, small_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$button_tweener.start()
	yield($button_tweener, "tween_completed")
	$button_tweener.interpolate_property(node, "rect_scale", node.rect_scale, normal_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$button_tweener.start()

func change_scene(scene_to_go_to : String):
	$scene_transitioner.scene_transition(scene_to_go_to)

#---------------------------------------------------------------------------------------------------
#HOVERING OVER BUTTONS
func _on_btn_campaign_mouse_entered():
	pass #hovering_over_button($CenterContainer/VBoxContainer/btn_campaign)
func _on_btn_free_duel_mouse_entered():
	hovering_over_button($CenterContainer/VBoxContainer/btn_free_duel)
func _on_btn_build_deck_mouse_entered():
	hovering_over_button($CenterContainer/VBoxContainer/btn_build_deck)
func _on_btn_library_mouse_entered():
	hovering_over_button($CenterContainer/VBoxContainer/btn_library)
func _on_btn_password_mouse_entered():
	hovering_over_button($CenterContainer/VBoxContainer/btn_password)

func _on_btn_campaign_mouse_exited():
	unhover_button($CenterContainer/VBoxContainer/btn_campaign)
func _on_btn_free_duel_mouse_exited():
	unhover_button($CenterContainer/VBoxContainer/btn_free_duel)
func _on_btn_build_deck_mouse_exited():
	unhover_button($CenterContainer/VBoxContainer/btn_build_deck)
func _on_btn_library_mouse_exited():
	unhover_button($CenterContainer/VBoxContainer/btn_library)
func _on_btn_password_mouse_exited():
	unhover_button($CenterContainer/VBoxContainer/btn_password)

func hovering_over_button(button : Node):
	if button.modulate == Color(1,1,1,1):
		get_node(String(button.get_path()) + "/white_over").show()
func unhover_button(button : Node):
	get_node(String(button.get_path()) + "/white_over").hide()








