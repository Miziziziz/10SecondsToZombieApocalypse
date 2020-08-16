extends Sprite


onready var timer = $FlashTimer

func _ready():
	hide()

func flash():
	show()
	timer.start()

