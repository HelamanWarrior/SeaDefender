extends CPUParticles2D

func _on_DestroyTimer_timeout():
	queue_free()
