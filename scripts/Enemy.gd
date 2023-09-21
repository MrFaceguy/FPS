extends CharacterBody3D

@export var health = 10


@onready var nav_agent = $NavigationAgent3D
var SPEED = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = new_velocity
	move_and_slide()
	
	if health <= 0:
		dies()

func updateTargetLocation(target_location):
	nav_agent.target_position = target_location
	

func dies():
	print(self, " has died")
	self.queue_free()

func takeDamage(damage):
	health -= damage
