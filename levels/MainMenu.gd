extends Control


func _ready():
	$GridContainer/PlayButton.connect("button_up", self, "play_game")
	$GridContainer/ExitButton.connect("button_up", self, "exit_game")

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func play_game():
	LevelManager.play_new_game()

func exit_game():
	get_tree().quit()
