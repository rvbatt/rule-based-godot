@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	add_custom_type("RuleBasedSystem", "Node",
		preload("system/rule_based_system.gd"),
		preload("ruler_icon.png"))

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type("RuleBasedSystem")
