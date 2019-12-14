extends Control


func _on_QuitGame_pressed():
	get_tree().quit()

func _on_StartGame_pressed():
	get_tree().change_scene("res://World.tscn")

func _on_Main_Menu_pressed():
	get_tree().change_scene("res://StartMenu.tscn")
