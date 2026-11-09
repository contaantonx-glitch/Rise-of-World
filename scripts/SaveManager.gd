extends Node

const SAVE_PATH := "user://world_dominion_save.json"

func save_game(city: Node2D) -> void:
    var data = city.get_save_data()
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file == null:
        return
    file.store_string(JSON.stringify(data))

func load_game(city: Node2D) -> void:
    if not FileAccess.file_exists(SAVE_PATH):
        return

    var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file == null:
        return

    var text = file.get_as_text()
    var parsed = JSON.parse_string(text)
    if parsed == null:
        return

    city.load_save_data(parsed)
