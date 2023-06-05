extends Node

func _ready():
	if $RuleBasedSystem.has_user_signal("test_signal"):
		$RuleBasedSystem.connect("test_signal", test_signal)

func run_tests(_argument):
	$RuleBasedSystem.test_rules()

func test_signal():
	print("Signal received")
