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
@onready var tela_inicial = $CanvasLayer/TelaInicial
@onready var mensagem_acerto = $CanvasLayer/GameOverTela/CenterContainer2/VBoxContainer/MsgAcerto
@onready var tutorial_1 = $CanvasLayer/Tutorial
@onready var tutorial_2 = $CanvasLayer/Tutorial2

@onready var botao_1 = $CanvasLayer/GameOverTela/CenterContainer2/VBoxContainer/Escolha1
@onready var botao_2 = $CanvasLayer/GameOverTela/CenterContainer2/VBoxContainer/Escolha2
@onready var botao_3 = $CanvasLayer/GameOverTela/CenterContainer2/VBoxContainer/Escolha3

var active_enemy = null
var current_letter_index: int = -1
var acertos_realizados: int = 0

var speed_atual: float = 1.0

func _ready():
	fim_jogo.hide()
	tela_inicial.show()
	escore.hide()
	#start_game()


func find_new_active_enemy(typed_character: String):
	for enemy in enemy_container.get_children():
		var prompt = enemy.get_prompt()
		if prompt.length() == 1:
			active_enemy = enemy
			current_letter_index = -1
			active_enemy.queue_free()
			active_enemy = null
			acertos_realizados += 1
			acertos.text = str(acertos_realizados)
			return
		if prompt.substr(0, 1) == typed_character:
			active_enemy = enemy
			#print("Novo inimigo!")
			current_letter_index = 1
			active_enemy.set_next_character(current_letter_index)
			return

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
				##print("success: ", letra)
				current_letter_index += 1;
				active_enemy.set_next_character(current_letter_index)
				if current_letter_index == prompt.length():
					current_letter_index = -1
					active_enemy.queue_free()
					active_enemy = null
					acertos_realizados += 1
					acertos.text = str(acertos_realizados)
			##else:
				##print("letra errada")


func _on_spawn_timer_timeout():
	spawn_enemy()


func spawn_enemy():
	var enemy_instance = Inimigo.instantiate()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	if (acertos_realizados % 5 == 0 && acertos_realizados != 0):
		speed_atual += 0.3
	enemy_instance.speed += speed_atual
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
	nomear_buttons()
	for Inimigo in enemy_container.get_children():
		Inimigo.queue_free()
	reativar_botoes()


func start_game():
	fim_jogo.hide()
	reativar_botoes()
	acertos_realizados = 0
	acertos.text = '0'
	speed_atual = 0
	escore.show()
	spawn_timer.start()
	lingua.text = Lista.get_linguagem()
	randomize()
	spawn_timer.start()
	spawn_enemy()


func _on_restart_button_pressed():
	start_game()


func _on_button_pressed():
	tela_inicial.hide()
	iniciar_tutorial()


func iniciar_tutorial():
	tutorial_1.show()
	#start_game()

## O codigo abaixo é para a parte da pergunta final
var index: int = 0

func nomear_buttons():
	var array_linguagens = Lista.get_linguagem_array()
	#Arrumar esse código depois, Fiz um hard code para testar
	index = randi() % 3
	print("A resposta é: " + str(index + 1))
	match index: #Switch / Case
		0:
			botao_1.text = array_linguagens[0]
			botao_2.text = array_linguagens[1]
			botao_3.text = array_linguagens[2]
		1:
			botao_1.text = array_linguagens[2]
			botao_2.text = array_linguagens[0]
			botao_3.text = array_linguagens[1]
		2:
			botao_1.text = array_linguagens[1]
			botao_2.text = array_linguagens[2]
			botao_3.text = array_linguagens[0]

func _on_escolha_1_pressed():
	acertou(1, botao_1)


func _on_escolha_2_pressed():
	acertou(2, botao_2)


func _on_escolha_3_pressed():
	acertou(3, botao_3)

func acertou(index_butao: int, botao: Button):
	if index_butao == index + 1:
		botao.add_theme_color_override("font_color", Color.LIME_GREEN)
		botao.add_theme_color_override("font_hover_color", Color.LIME_GREEN)
		botao.add_theme_color_override("font_focus_color", Color.LIME_GREEN)
		botao.add_theme_color_override("icon_focus_color", Color.LIME_GREEN)
		mensagem_acerto.text = "Você acertou, parabéns!!!"
	else:
		botao.add_theme_color_override("font_color", Color.RED)
		botao.add_theme_color_override("font_hover_color", Color.RED)
		botao.add_theme_color_override("font_focus_color", Color.RED)
		botao.add_theme_color_override("icon_focus_color", Color.RED)
		mensagem_acerto.text = "Você errou, mas tente novamente!"
	desativar_botoes()

func reativar_botoes():
	botao_1.button_mask = 1
	botao_1.remove_theme_color_override("font_color")
	botao_1.remove_theme_color_override("font_hover_color")
	botao_1.remove_theme_color_override("font_focus_color")
	botao_1.remove_theme_color_override("icon_focus_color")
	
	botao_2.button_mask = 1
	botao_2.remove_theme_color_override("font_color")
	botao_2.remove_theme_color_override("font_hover_color")
	botao_2.remove_theme_color_override("font_focus_color")
	botao_1.remove_theme_color_override("icon_focus_color")
	
	botao_3.button_mask = 1
	botao_3.remove_theme_color_override("font_color")
	botao_3.remove_theme_color_override("font_hover_color")
	botao_3.remove_theme_color_override("font_focus_color")
	botao_1.remove_theme_color_override("icon_focus_color")
	
	mensagem_acerto.text = "\t"

func desativar_botoes():
	botao_1.button_mask = 0
	botao_2.button_mask = 0
	botao_3.button_mask = 0
	pass


func _on_tutorial_continuar_pressed():
	tutorial_1.hide()
	tutorial_2.show()


func _on_tutorial_continuar_2_pressed():
	tutorial_2.hide()
	start_game()
