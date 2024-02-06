extends Node

var words = [
	"fabricio",
	"gian",
	"carlos",
	"joao",
	"teste",
	"tardivo",
	"luka",
	"miguel",
	"nakahata",
	"foda",
	"tatu",
	"penis"
]

func get_prompt() -> String:
	var word_index = randi() % words.size()
	var word = words[word_index]
	return word
