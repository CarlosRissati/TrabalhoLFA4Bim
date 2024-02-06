extends Node

var Inimigo = preload("res://inimigo.tscn")

@onready var enemy_container = $EnemyContainer
@onready var spawn_container = $SpawnContainer
@onready var spawn_timer = $SpawnTimer

@onready var lingua = $CanvasLayer/VBoxContainer/Baixo/Lingua
@onready var acertos = $CanvasLayer/VBoxContainer/Cima/ValorAcertos
@onready var fim_jogo = $CanvasLayer/GameOverTela
@onready var escore = $CanvasLayer/VBoxContainer
@onready var total_acertos_label = $CanvasLayer/GameOverTela/CenterContainer/VBoxContainer/TotalAcertos

var active_enemy = null
var current_letter_index: int = -1
var acertos_realizados: int = 0

func _ready():
	start_game()


func find_new_active_enemy(typed_character: String):
	for enemy in enemy_container.get_children():
		var prompt = enemy.get_prompt()
		if prompt.substr(0, 1) == typed_character:
			active_enemy = enemy
			print("Novo inimigo!")
			current_letter_index = 1
			active_enemy.set_next_character(current_letter_index)
			return;

func _unhandled_input(event):
	if event is InputEventKey and not event.is_pressed():
		var typed_event = event as InputEventKey
		var key_typed = typed_event.as_text_keycode()
		
		if active_enemy == null:
			find_new_active_enemy(key_typed.to_lower())
		else:
			var letra = key_typed.to_lower()
			var prompt = active_enemy.get_prompt()
			var next_character = prompt.substr(current_letter_index, 1)
			if letra == next_character:
				print("success: ", letra)
				current_letter_index += 1;
				active_enemy.set_next_character(current_letter_index)
				if current_letter_index == prompt.length():
					current_letter_index = -1
					active_enemy.queue_free()
					active_enemy = null
					acertos_realizados += 1
					acertos.text = str(acertos_realizados)
			else:
				print("letra errada")


func _on_spawn_timer_timeout():
	spawn_enemy()


func spawn_enemy():
	var enemy_instance = Inimigo.instantiate()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	enemy_container.add_child(enemy_instance)
	enemy_instance.global_position = spawns[index].global_position


func _on_fim_de_jogo_body_entered(body):
	game_over()

func game_over():
	fim_jogo.show()
	spawn_timer.stop()
	active_enemy = null
	total_acertos_label.text = str(acertos_realizados) + " Acertos!"
	current_letter_index = -1
	escore.hide()
	for Inimigo in enemy_container.get_children():
		Inimigo.queue_free()


func start_game():
	fim_jogo.hide()
	acertos_realizados = 0
	acertos.text = '0'
	escore.show()
	spawn_timer.start()
	randomize()
	spawn_timer.start()
	spawn_enemy()


func _on_restart_button_pressed():
	start_game()
