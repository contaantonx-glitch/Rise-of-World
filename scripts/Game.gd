extends Node2D

@onready var city: Node2D = $City
@onready var hud: CanvasLayer = $HUD

func _ready() -> void:
    ResourceManager.reset()
    city.connect("city_updated", Callable(self, "_on_city_updated"))
    hud.connect("build_requested", Callable(self, "_on_build_requested"))
    hud.connect("save_requested", Callable(self, "_on_save_requested"))
    hud.connect("load_requested", Callable(self, "_on_load_requested"))
    _on_city_updated()

func _on_city_updated() -> void:
    if hud:
        hud.update_resources(ResourceManager.resources)
        hud.update_city(city.population, city.buildings)

func _on_build_requested(building_type: String) -> void:
    city.build_building(building_type)
    _on_city_updated()

func _on_save_requested() -> void:
    SaveManager.save_game(city)
    hud.set_status("Game saved.")

func _on_load_requested() -> void:
    SaveManager.load_game(city)
    _on_city_updated()
    hud.set_status("Save loaded.")
