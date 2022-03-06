extends BaseState
class_name IdleState

func enter() -> void:
    .enter()

func physics_process(_delta: float) -> void:
    body.velocity = Vector2.ZERO
    body.velocity = body.move_and_slide(body.velocity, Vector2.UP)
