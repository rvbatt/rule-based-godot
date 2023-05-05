class_name MatchInterface
extends Resource
# Interface for condition components

func is_satisfied() -> bool:
	# Abstract method
	print("ABSTRACT METHOD CALL AT " + str(self))
	return false
