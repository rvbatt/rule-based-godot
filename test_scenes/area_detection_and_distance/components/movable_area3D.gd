extends Area3D

@export var speed := 0.1

func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	self.translate(speed * Vector3(direction.x, 0, direction.y))

func _on_area_entered(area):
	print("Area entered: " + area.name)

func _on_body_entered(body):
	print("Body entered: " + body.name)
