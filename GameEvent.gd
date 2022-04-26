extends Node

signal update_oxygen_ui(amount)
signal oxygen_refuel()
signal people_refuel()
signal less_people_refuel()
signal add_to_score(amount)
signal camera_shake(amount)
signal update_person_count()
signal kill_all_enemies()
signal pause_enemies(pause)
signal kill_player()
signal full_crew()
signal destroy_crew_ui()

# user interface visibility
signal toggle_points_visibility(visible)
signal toggle_crew_visiblity(visible)
signal toggle_oxygen_visiblity(visible)

# tutorial stuff
signal all_controls_pressed()
signal instance_tutorial_shark()
signal increase_shark_kill_count()
signal hide_controls()
signal spawn_tutorial_people()
