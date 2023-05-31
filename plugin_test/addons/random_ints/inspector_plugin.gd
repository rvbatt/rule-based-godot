extends EditorInspectorPlugin

var random_int_generator = preload("res://addons/random_ints/random_int_generator.gd")

func _can_handle(object):
	return true

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	if type == TYPE_INT:
		add_property_editor(name, random_int_generator.new())
		return true
	return false
