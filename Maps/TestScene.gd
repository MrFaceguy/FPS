extends Node3D

@onready var player = $RigidBody3D
@onready var enemyArray = []
@onready var enemyCount

func _physics_process(delta):
	get_tree().call_group("Enemy", "updateTargetLocation", player.global_transform.origin)
	
	
	enemyCount = 0
	for x in self.get_children():
		if x.is_in_group("Enemy"):
			enemyCount += 1
