/obj/item/weapon/ranged/bullet/magazine/pistol/gyrojet
	name = "\improper 20mm GyroPistol"
	desc = "Overdesigned and a little overpowered."
	desc_extended = "A prototype syndicate pistol that uses minature rockets as projectiles. As a result, it suffers no inaccuracy due to firing."
	icon = 'icons/obj/item/weapons/ranged/pistol/gyrojet.dmi'
	icon_state = "inventory"
	value = 140

	shoot_delay = 8

	automatic = TRUE

	shoot_sounds = list('sound/weapons/gyrojet/shoot.ogg')

	view_punch = 2

	slowdown_mul_held = HELD_SLOWDOWN_REVOLVER

	size = SIZE_3


	heat_per_shot = 0
	heat_max = 0

	bullet_length_min = 48
	bullet_length_best = 50
	bullet_length_max = 52

	bullet_diameter_min = 19
	bullet_diameter_best = 20
	bullet_diameter_max = 21

	attachment_whitelist = list(
		/obj/item/attachment/barrel/extended = TRUE,
		/obj/item/attachment/sight/laser_sight = TRUE,
		/obj/item/attachment/sight/red_dot = TRUE,
		/obj/item/attachment/sight/scope = TRUE,
		/obj/item/attachment/undermount/vertical_grip = TRUE
	)

	attachment_barrel_offset_x = 29 - 16
	attachment_barrel_offset_y = 22 - 16

	attachment_sight_offset_x = 20 - 16
	attachment_sight_offset_y = 21 - 16

	attachment_undermount_offset_x = 24 - 16
	attachment_undermount_offset_y = 12 - 16

/obj/item/weapon/ranged/bullet/magazine/pistol/gyrojet/get_static_spread() //Base spread
	return 0.005

/obj/item/weapon/ranged/bullet/magazine/pistol/gyrojet/get_skill_spread(var/mob/living/L) //Base spread
	return max(0,0.10 - (0.15 * L.get_skill_power(SKILL_RANGED)) )