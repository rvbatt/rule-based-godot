extends HBoxContainer

signal changed(_arguments)

@export var number: int:
	set(new_number):
		$SpinBox.set_value_no_signal(new_number)
		number = new_number
	get:
		number = $SpinBox.value
		return number

@export var string: String:
	set(new_string):
		$LineEdit.text = new_string
		string = new_string
	get:
		string = $LineEdit.text
		return string


func _on_line_edit_text_submitted(new_text):
	string = new_text
	emit_signal("changed", false)


func _on_spin_box_value_changed(value):
	number = value
	emit_signal("changed", false)
