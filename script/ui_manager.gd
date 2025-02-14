extends CanvasLayer

var player: Player

func _ready() -> void:
	GameManager.gained_hearts.connect(update_heart_display)
	GameManager.losed_lives.connect(update_live_display)
	
func update_heart_display(gained_hearts):
	$heartdisplay.text = str(GameManager.hearts)

func update_live_display():
	$livesdisplay.text = str(GameManager.lives)
