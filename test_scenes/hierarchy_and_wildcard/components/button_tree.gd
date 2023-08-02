extends VBoxContainer

@onready var a_button: Button = find_child("A", true)
@onready var b_button: Button = find_child("B", true)
@onready var c_button: Button = find_child("C", true)
var _selected_button: Button = null

func _on_a_pressed():
	print("A pressed")
	print(str(_selected_button) + " selected")
	match _selected_button:
		null:
			_selected_button = a_button
		b_button:
			if a_button.find_parent("B") == b_button:
				a_button.reparent(b_button.get_parent())
			b_button.reparent(a_button.get_child(0))
			_deselect_all()
		c_button:
			if a_button.find_parent("C") == c_button:
				a_button.reparent(c_button.get_parent())
			c_button.reparent(a_button.get_child(0))
			_deselect_all()

func _on_b_pressed():
	print("B pressed")
	print(str(_selected_button) + " selected")
	match _selected_button:
		a_button:
			if b_button.find_parent("A") == a_button:
				b_button.reparent(a_button.get_parent())
			a_button.reparent(b_button.get_child(0))
			_deselect_all()
		null:
			_selected_button = b_button
		c_button:
			if b_button.find_parent("C") == c_button:
				b_button.reparent(c_button.get_parent())
			c_button.reparent(b_button.get_child(0))
			_deselect_all()

func _on_c_pressed():
	print("C pressed")
	print(str(_selected_button) + " selected")
	match _selected_button:
		a_button:
			if c_button.find_parent("A") == a_button:
				c_button.reparent(a_button.get_parent())
			a_button.reparent(c_button.get_child(0))
			_deselect_all()
		b_button:
			if c_button.find_parent("B") == b_button:
				c_button.reparent(b_button.get_parent())
			b_button.reparent(c_button.get_child(0))
			_deselect_all()
		null:
			_selected_button = c_button

func _deselect_all():
	print("deselect")
	_selected_button = null
	a_button.set_pressed_no_signal(false)
	b_button.set_pressed_no_signal(false)
	c_button.set_pressed_no_signal(false)
