extends CharacterBody2D

@export var blue = Color.BLUE
@export var red = Color.RED
@export var green = Color.GREEN

@export var speed: float = 1.0

@onready var prompt = $RichTextLabel
@onready var prompt_text = $RichTextLabel.text

func _ready():
	prompt_text = Lista.get_prompt()
	prompt.parse_bbcode(set_center_tags(prompt_text))


func _physics_process(_delta):
	global_position.x -= speed 


func get_prompt() -> String:
	return formatar(prompt_text)

func set_next_character(next_character_index: int):
	var texto = formatar(prompt_text)
	var blue_text = get_bbcode_color_tag(blue) + texto.substr(0, next_character_index) + get_bbcode_end_color_tag()
	var green_text = get_bbcode_color_tag(green) + texto.substr(next_character_index, 1) + get_bbcode_end_color_tag()
	var red_text = ""
	
	if  next_character_index != texto.length():
		red_text = get_bbcode_color_tag(red) + texto.substr(next_character_index + 1, texto.length() - next_character_index + 1) + get_bbcode_end_color_tag()
	
	prompt.parse_bbcode("[center]" + blue_text + green_text + red_text + "[/center]")
	

func set_center_tags(string_to_center: String):
	return "[center]" + string_to_center + "[/center]"

func get_bbcode_color_tag(color: Color) -> String:
	var cor = color.to_html(false)
	return "[color=#" + cor + "]"
	
func get_bbcode_end_color_tag() -> String:
	return "[/color]"
	
func teste() -> String:
	return get_bbcode_color_tag(blue)

func formatar(prompt_: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	var text_without_tags = regex.sub(prompt_, "", true)
	return text_without_tags
