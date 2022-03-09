extends TextureProgress

func _ready():
	GameEvent.connect("update_oxygen_ui", self, "update_oxygen_ui")

func update_oxygen_ui(amount):
	value = amount
