extends CanvasLayer

func _ready() -> void:
	GameManager.gained_hearts.connect(update_heart_display)

func update_heart_display(gained_hearts):
	$heartdisplay.text = str(GameManager.hearts)
