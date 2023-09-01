extends Button

var duelist_name : String

#---------------------------------------------------------------------------------------------------
func _ready():
	duelist_name = self.get_name().split("_")[1]
	get_node("visuals/face").texture = load("res://_resources/character_faces/" + duelist_name + "0.png")
	
#	#Only show the duelist button IF the player has fought it in the campaign mode
#	var is_debug = false
#	$visuals.hide()
#	if is_debug or PlayerData.recorded_campaign_defeats.has("campaign_defeat_" + duelist_name.to_upper()) or duelist_name == "shadi":
#		$visuals.show()
#	if duelist_name in ["Nitemare", "Tenma"] and PlayerData.recorded_campaign_defeats.has("campaign_defeat_KAIBA") and PlayerData.recorded_campaign_defeats.has("campaign_defeat_PEGASUS"):
#		$visuals.show()

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

