extends Camera2D

var y_input = 0

export var max_offset = 5.0
export var max_roll = 5.0
export var shakeReduction = 2.5

var stress = 0.0
var shake = 0.0

onready var target_location = global_position

func _ready():
	GameEvent.connect("camera_shake", self, "init_camera_shake")

func _physics_process(delta):
	if is_instance_valid(Global.player):
		global_position = lerp(global_position, target_location, 0.15)
		global_position.y = clamp(global_position.y, 70, 145)
		
		var y_input_target = Input.get_action_strength("down") - Input.get_action_strength("up")
		y_input = lerp(y_input, y_input_target, 0.025)
		
		target_location.y = Global.player.global_position.y + (y_input * 30)
		
	process_shake(Vector2(0, 0), 0.0, delta)

func init_camera_shake(amount):
	stress += amount
	stress = clamp(stress, 0.0, 1.0)

func process_shake(center, angle, delta) -> void:
	shake = stress * stress

	rotation_degrees = angle + (max_roll * shake *  get_noise(randi(), delta))
	
	var offset = Vector2()
	offset.x = (max_offset * shake * get_noise(randi(), delta + 1.0))
	offset.y = (max_offset * shake * get_noise(randi(), delta + 2.0))
	
	offset_h = center.x + offset.x
	offset_v = center.y + offset.y
		
	stress -= (shakeReduction / 100.0)
	
	stress = clamp(stress, 0.0, 1.0)
	
	zoom.x = 1 + (-stress * 0.3)
	zoom.y = zoom.x
	
func get_noise(noise_seed, time) -> float:
	var n = OpenSimplexNoise.new()
	
	n.seed = noise_seed
	n.octaves = 4
	n.period = 20.0
	n.persistence = 0.8
	
	return n.get_noise_1d(time)
