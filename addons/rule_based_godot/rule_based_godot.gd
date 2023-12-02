@tool
extends EditorPlugin

const RULES_EDITOR_PATH := "res://addons/rule_based_godot/interface/rules_editor.tscn"
const INSPECTOR_PATH := "res://addons/rule_based_godot/interface/rules_inpector_plugin.gd"
const SYSTEM_NODE_PATH := "res://addons/rule_based_godot/system/rule_based_system.gd"

var rules_editor: Control
var inspector_plugin: EditorInspectorPlugin

func _enter_tree():
	# Initialization of the plugin goes here.
	add_custom_type("RuleBasedSystem", "Timer",
		preload(SYSTEM_NODE_PATH),
		preload("ruler_icon.png"))

	rules_editor = preload(RULES_EDITOR_PATH).instantiate()
	var button = add_control_to_bottom_panel(rules_editor, "Rules Editor")

	inspector_plugin = preload(INSPECTOR_PATH).new()
	inspector_plugin.set_rules_editor(rules_editor, button)
	add_inspector_plugin(inspector_plugin)

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type("RuleBasedSystem")

	remove_inspector_plugin(inspector_plugin)

	remove_control_from_bottom_panel(rules_editor)
	rules_editor.queue_free()
