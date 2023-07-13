extends Node

func _ready():
	if $RuleBasedSystem.has_user_signal("test_signal"):
		$RuleBasedSystem.connect("test_signal", test_signal)

func run_tests(_argument):
	$RuleBasedSystem.test_rules()

func test_signal():
	print("Signal received")

func _unhandled_input(event):
	if event.is_action_pressed("test_rule_based_system"):
		run_tests(0)

func _on_area_2d_area_entered(area):
	print("Entrou")
