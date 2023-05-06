extends Node2D

func _on_spin_box_value_changed(_value):
	$RuleBasedSystem.test_rules()
