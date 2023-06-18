extends Node

func save_game():
	#Get from 'PlayerData' the info that will be stored in a savefile
	var info_to_save = {
		#Player information
		"player_name"  : PlayerData.player_name, #String
		"player_deck"  : PlayerData.player_deck, #Array
		"player_trunk" : PlayerData.player_trunk, #Dictionary
		"player_starchips" : PlayerData.player_starchips, #Int
		"password_bought_cards" : PlayerData.password_bought_cards, #Array
		"recorded_duels" : PlayerData.recorded_duels #Dictionary
		
		#Story Progression information
		#TODO
	}
	
	#Start the file to be written
	var save_file = File.new()
	save_file.open_encrypted_with_pass("user://savegame.save", File.WRITE, OS.get_unique_id()) #ENCRYPTED
	
	#Write info to save_file
	save_file.store_line(to_json(info_to_save)) #get 'info_to_save' dictionary and turn into JSON
	save_file.close()
	
	return "sucess"

func load_game():
	#Check if a savegame exists, if not, scape function
	var save_file = File.new()
	if not save_file.file_exists("user://savegame.save"):
		return
	
	#Load the file if one was found
	save_file.open_encrypted_with_pass("user://savegame.save", File.READ, OS.get_unique_id()) #ENCRYPTED
	
	var info_to_load = { } #start as empty dictionary and will be loaded key by key
	info_to_load = parse_json(save_file.get_as_text())
	
	#Load it safely. IF the save file has that information, load it. Good for future-proof with backwards compatibility
	var saved_info = [
		["player_name", "string"],
		["player_deck", "array"],
		["player_trunk", "dictionary"],
		["player_starchips", "int"],
		["password_bought_cards", "array"],
		["recorded_duels", "dictionary"],
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








