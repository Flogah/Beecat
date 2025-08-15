extends StaticBody2D

@onready var witch_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var victory_text: Label = $VictoryText
@onready var victory_text_2: Label = $VictoryText2



func _on_waving_area_body_entered(body: Node2D) -> void:
	witch_sprite.play("wave")

func _on_waving_area_body_exited(body: Node2D) -> void:
	witch_sprite.play("idle")

func _on_candy_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.victory()
		victory_text.visible = true
		victory_text_2.visible = true
	witch_sprite.play("give_candy")
