extends Node2D


func _ready():
	$Timer1.wait_time = 1.1
	$Timer2.wait_time = 1.2
	
	$Timer1.start()


func _on_Timer1_timeout():
	print("1 timeout")
	$Timer1.stop()
	$Timer2.start()


func _on_Timer2_timeout():
	print("2 timeout")
	$Timer2.stop()
	$Timer1.start()
