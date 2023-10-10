extends Car

@onready var camera = $Camera2D

func _ready():
	camera.set_as_top_level(true)

func physics_process(delta):
	camera.global_position = global_position
	camera.rotation = lerp_angle(camera.rotation, rotation + deg_to_rad(90), 0.1)
	
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func control():
	if Input.is_action_pressed("left"):
		current_steering_angle = lerp_angle(current_steering_angle, deg_to_rad(-max_steering_angle), steering_speed)
	elif Input.is_action_pressed("right"):
		current_steering_angle = lerp_angle(current_steering_angle, deg_to_rad(max_steering_angle), steering_speed)
	else:
		current_steering_angle = lerp_angle(current_steering_angle, 0, 0.1)
	
	var target_acc = Vector2()
	if Input.is_action_pressed("accelerate"):
		current_acc = lerpf(current_acc, max_acc, 0.05) # 切换档位
		target_acc = transform.x * current_acc
	elif Input.is_action_pressed("back"):
		target_acc = transform.x * reverse_acc
		current_acc = 0 # 如果我在刹车，发动机会关闭
	else:
		current_acc = lerpf(current_acc, 0, 0.001) # 如果我释放了加速键，发动机会减速但不会立即停止
	acc = target_acc
