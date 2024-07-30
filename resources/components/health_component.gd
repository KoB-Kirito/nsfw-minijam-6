extends Area3D
class_name HealthComponent


signal health_changed
signal took_damage
signal healed
signal died

@export var max_health: int = 10
@export var health: int = 10

var is_dead: bool


func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(area: Area3D) -> void:
	if area is not DamageComponent:
		return
	
	if is_dead:
		return
	
	var current_health := health
	health -= area.damage
	
	if health < 0:
		health = 0
		
	elif health > max_health:
		health = max_health
	
	if health < current_health:
		health_changed.emit()
		took_damage.emit()
		
	elif health > current_health:
		health_changed.emit()
		healed.emit()
	
	if health == 0:
		is_dead = true
		died.emit()
