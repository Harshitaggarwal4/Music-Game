extends Control
#signal start_game_pressed

@onready var start_game_button: Button = $%StartGameButton
@onready var options_menu: Control = $%OptionsMenu
@onready var content: CanvasLayer = $%CanvasLayer

func _ready():
	start_game_button.grab_focus()
	
func quit():
	get_tree().quit()
	
func open_options():
	content.hide()
	options_menu.show()
	options_menu.on_open()
	
func close_options():
	content.show();
	start_game_button.grab_focus()
	options_menu.hide()


#var text_list: Array = []
#var swaras_list : Array = []


func _on_start_game_button_pressed():
	content.hide()
#	var current_text = $VBoxContainer/NameTextBox.text
#
#	var num_words_reqd = 3
#
#	# Split the text into words
#	var words = current_text.split(" ")
#	if current_text=="":
#		words=[]
#	swaras_list.clear()  # Clear the previous swaras
#
#	# ensure number of words is exact
#	if words.size() < num_words_reqd:
#		var names = load_names(num_words_reqd - words.size())
#		for name in names:
#			words.append(name)
#	elif words.size() > num_words_reqd:
#		words = words.slice(0, num_words_reqd)
#
#	# Loop through each word
#	for word in words:
#		var swara = name_to_swaras(word)
#		for swar in swara:
#		# print(swara)  # Print swara for each word
#			swaras_list.append(swar)  # Append swara for each word to the list
#		swaras_list.append(",")
#		swaras_list.append(",")
#	# Store the split words into the text_list variable
#	text_list = words
#	MainMenu.text_list = words
#	MainMenu.swaras_list =swaras_list
#	print(text_list)
#	print(swaras_list)
	get_tree().change_scene_to_file("res://addons/EasyMenus/Scenes/NamePage.tscn")
#	get_tree().change_scene_to_file("res://Scene/main.tscn")
#	emit_signal("start_game_pressed")





#func _on_name_text_box_text_changed():
#	var current_text = $".."/NameTextBox.text
#	# Split the text into words
#	var words = current_text.split(" ")
#	swaras_list.clear()  # Clear the previous swaras
#	# Loop through each word
#	for word in words:
#		var swara = name_to_swaras(word)
#		for swar in swara:
#		# print(swara)  # Print swara for each word
#			swaras_list.append(swar)  # Append swara for each word to the list
#		swaras_list.append(",")
#		swaras_list.append(",")
#	# Store the split words into the text_list variable
#	text_list = words
#	pass

#
#func get_syllables(str):
#	# Convert the input string to lowercase
#	str = str.to_lower()
#
#	# Simplify the string
#	str = str.replace(" ", "")
#	str = str.replace("sh", "s")
#	str = str.replace("ch", "c")
#	str = str.replace("th", "t")
#	str = str.replace("dh", "d")
#	str = str.replace("ph", "p")
#	str = str.replace("bh", "b")
#	str = str.replace("kh", "k")
#	str = str.replace("gh", "g")
#	str = str.replace("jh", "j")
#
#	var result = ""
#	var syllables = []
#	var temp = ""
#
#	var i = 0
#	while i < str.length():
#		temp += str[i]
#
#		# Eat all vowels
#		while i + 1 < str.length() and "aeiou".find(str[i + 1]) != -1:
#			temp += str[i + 1]
#			i += 1
#
#		syllables.append(temp)
#		temp = ""
#		i += 1
#
#	return syllables
#
#
#func get_cons_part(syllable: String) -> String:
#	var result = ""
#	for char in syllable:
#		if char not in "aeiou":
#			result += char
#	return result
#
#func get_vowel_part(syllable: String) -> String:
#	var result = ""
#	for char in syllable:
#		if char in "aeiou":
#			result += char
#	return result
#
#var mapping = {
#	# vowels
#	"a": "s",
#	"i": "r",
#	"u": "g",
#	"e": "m",
#	"ai": "p",
#	"o": "d",
#	"au": "n",
#
#	# consonants
#	"ka": "g",
#	"kha": "g",
#	"ga": "g",
#	"gha": "g",
#	"nga": "n",
#
#	"ca": "s",
#	"cha": "s",
#	"chha": "s",
#	"ja": "s",
#	"jha": "s",
#	"nja": "n",
#
#	"ṭa": "d",
#	"ṭha": "d",
#	"ḍa": "d",
#	"ḍha": "d",
#	"ṇa": "n",
#
#	"ta": "d",
#	"tha": "d",
#	"da": "d",
#	"dha": "d",
#	"na": "n",
#
#	"pa": "p",
#	"pha": "p",
#	"ba": "p",
#	"bha": "p",
#	"ma": "m",
#
#	"ya": "s",
#	"ra": "r",
#	"la": "d",
#	"va": "p",
#	"wa": "p",
#	"śa": "s",
#	"ṣa": "s",
#	"sa": "s",
#	"ha": "g",
#	"ḷa": "d",
#
#	"ṁ": "M",
#}
#
#
#func get_swaras(syllables):
#	var long_vowels = ["e", "o", "aa", "ii", "uu", "ee", "ai", "oo", "au"]
#	var swaras = []
#
#	for i in range(len(syllables)):
#		var syllable = syllables[i]
#		var cons_part = get_cons_part(syllable)
#		var vowel_part = get_vowel_part(syllable)
#		var swara = mapping.get(cons_part + "a", "*")
#
#		if cons_part != "":
#			if vowel_part == "":
#				# Samyukta akshara
#				if cons_part == "m":
#					swaras.append("M-")
#				elif i < len(syllables) - 1 and get_cons_part(syllables[i + 1]) == cons_part and not swara in "sp":
#					swaras.append(swara.to_upper() + "-")
#				else:
#					swaras.append(swara + "-")
#			else:
#				if long_vowels.has(vowel_part):
#					swaras.append(swara + ",")
#				else:
#					swaras.append(swara)
#		else:
#			swaras.append(mapping.get(syllable, "*"))
#
#		syllable = ""
#
#	return swaras
#
#func name_to_swaras(name):
#	return get_swaras(get_syllables(name))
#
#func load_names(num_names):
#	# load names list from the file
#	var file = FileAccess.open("res://Assets/names.txt", FileAccess.READ)
#	var names = file.get_as_text()
#	file.close()
#
#	# split into lines
#	names = names.split("\n")
#
#	var names_list = []
#
#	# get random names
#	for i in range(num_names):
#		var name = names[randi_range(0, names.size() - 1)]
#		names_list.append(name)
##	# display names in the text box
##	var textbox = $VBoxContainer/NameTextBox
##	textbox.set_text(" ".join(names_list))
#	return names_list
