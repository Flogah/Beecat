extends StaticBody2D

@onready var witch_sprite: AnimatedSprite2D = $AnimatedSprite2D



func _on_waving_area_body_entered(body: Node2D) -> void:
	witch_sprite.play("wave")

func _on_waving_area_body_exited(body: Node2D) -> void:
	witch_sprite.play("idle")

func _on_candy_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.victory()
	witch_sprite.play("give_candy")
