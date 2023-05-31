class_name RandomIntGenerator
extends EditorProperty


var property_control = Button.new()
var current_value = 0
var updating = false


func _init():
	add_child(property_control)
	add_focusable(property_control)
	refresh_control_text()
	property_control.pressed.connect(_on_button_pressed)


func _on_button_pressed():
	if updating: return

	current_value = randi() % 100
	refresh_control_text()
	emit_changed(get_edited_property(), current_value)


func _update_property():
	var new_value = get_edited_object()[get_edited_property()]
	if (new_value == current_value): return

	updating = true
	current_value = new_value
	refresh_control_text()
	updating = false

func refresh_control_text():
	property_control.text = "Value: " + str(current_value)
