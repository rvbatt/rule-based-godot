extends Node

var _connected: bool = false

func _physics_process(_delta):
	if not _connected and $RuleBasedSystem.has_user_signal("test_signal"):
		$RuleBasedSystem.connect("test_signal", test_signal)
		_connected = true

func run_tests(_argument):
	$RuleBasedSystem.test_rules()

func test_signal():
	print("Signal received")

func _unhandled_input(event):
	if event.is_action_pressed("test_rule_based_system"):
		run_tests(0)
