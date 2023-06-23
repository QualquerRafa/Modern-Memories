extends Button

var duelist_name : String

#Export the texture so I can change it in the editor and be more visual
export(Texture) var asset setget my_func
func my_func(pass_duelist_name : String):
	asset = load("res://_resources/character_faces/" + pass_duelist_name + "0.png")
	get_node("visuals/face").texture = asset

#---------------------------------------------------------------------------------------------------
func _ready():
	duelist_name = self.get_name().split("_")[1]
	my_func(duelist_name)

func _on_duelist_face_button_up():
	#Animate the button click
	if $visuals.is_visible():
		SoundControl.play_sound("poc_decide")
		
		#Animate the button being clicked
		var small_scale = Vector2(0.9 , 0.9)
		var normal_scale = Vector2(1 , 1)
		
		$tween.interpolate_property(self, "rect_scale", self.rect_scale, small_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$tween.start()
		yield($tween, "tween_completed")
		$tween.interpolate_property(self, "rect_scale", self.rect_scale, normal_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$tween.start()
		
		#Call the function on the scene root
		get_tree().get_root().get_node("free_duel").duelist_face_clicked(duelist_name)

