extends CharacterBody3D


@export var SPEED = 5.0
const JUMP_VELOCITY = 4.5


var mouse_sensitivity = 0.002

@onready var camera = $Camera3D
@onready var guncam = $Camera3D/SubViewportContainer/SubViewport/Camera3D
@onready var aimCast = $Camera3D/RayCast3D
@onready var enemyCounter = $Camera3D/SubViewportContainer/SubViewport/EnemiesLeftIndicator

@export_node_path("Node3D") var enemyAmountLOCATION

enum MODE {hitscan, projectile}
var currentMode = MODE.hitscan


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(90), deg_to_rad(90))

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(_delta):
	guncam.global_transform = camera.global_transform
	
	var enemyAmount = get_parent().enemyCount
	enemyCounter.text = "Enemies Left: " + str(enemyAmount)

func _physics_process(delta):
	
	if Input.is_action_pressed("shoot_gun"):
		if currentMode == MODE.hitscan:
			if Input.is_action_just_pressed("shoot_gun"):
				$Camera3D/Node3D/AnimationPlayer.play("shoot")
				var target = aimCast.get_collider()
				if target != null:
					if target.is_in_group("Enemy"):
						target.takeDamage(10)
				
			
		
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()




