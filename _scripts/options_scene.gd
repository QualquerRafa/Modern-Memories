extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	
	load_options_file()
	
	$option_volume/volume_percent_indicator.text = String(PlayerData.game_volume * 100) + "%"
	$option_volume/scroller.value = PlayerData.game_volume * 10

#---------------------------------------------------------------------------------------------------
func _on_scroller_value_changed(value):
	$option_volume/volume_percent_indicator.text = String(value*10) + "%"
	PlayerData.game_volume = value/10


func _on_back_button_button_up():
	save_options_file()
	$scene_transitioner.scene_transition("main_menu")

#---------------------------------------------------------------------------------------------------
func save_options_file():
	var info_to_save = {
		"game_language" : PlayerData.game_language, #String
		"game_volume"   : PlayerData.game_volume, #float
	}
	
	#Start the file to be written
	var save_file = File.new()
	save_file.open_encrypted_with_pass("user://gameoptions.save", File.WRITE, OS.get_unique_id()) #ENCRYPTED
	
	#Write info to save_file
	save_file.store_line(to_json(info_to_save)) #get 'info_to_save' dictionary and turn into JSON
	save_file.close()

func load_options_file():
	#Check if a saved file exists, if not, scape function
	var save_file = File.new()
	if not save_file.file_exists("user://gameoptions.save"):
		return
	
	#Load the file if one was found
	save_file.open_encrypted_with_pass("user://gameoptions.save", File.READ, OS.get_unique_id()) #ENCRYPTED
	
	var info_to_load = { } #start as empty dictionary and will be loaded key by key
	info_to_load = parse_json(save_file.get_as_text())
	
	#Load it safely. IF the save file has that information, load it. Good for future-proof with backwards compatibility
	var saved_info = [
		["game_language", "string"],
		["game_volume", "float"]
	]
	
	for i in range(saved_info.size()):
		if info_to_load.has(saved_info[i][0]):
			match saved_info[i][1]:
				"string":
					PlayerData[saved_info[i][0]] = String(info_to_load[saved_info[i][0]])
				"int":
					PlayerData[saved_info[i][0]] = int(info_to_load[saved_info[i][0]])
				"float":
					PlayerData[saved_info[i][0]] = float(info_to_load[saved_info[i][0]])
				"array":
					PlayerData[saved_info[i][0]] = Array(info_to_load[saved_info[i][0]])
				"dictionary":
					PlayerData[saved_info[i][0]] = Dictionary(info_to_load[saved_info[i][0]])
	
	return "sucess"





