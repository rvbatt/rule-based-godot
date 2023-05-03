extends CharacterBody3D

@export var stats: Resource

func _ready():
	# Uses an implicit, duck-typed interface for any 'health'-compatible resources.
	if stats:
		stats.health = 10
		print(stats.health)
		# Prints "10"
