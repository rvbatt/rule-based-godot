extends Area2D

@export var speed := 5

func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	self.translate(speed * direction)

func _on_area_entered(area):
	print("Area entered: " + area.name)


func _on_body_entered(body):
	print("Body entered: " + body.name)
