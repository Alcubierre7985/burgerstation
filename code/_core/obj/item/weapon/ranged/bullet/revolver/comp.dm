/obj/item/weapon/ranged/bullet/revolver/comp
	name = "\improper .38 Competitive Revolver"
	desc = "8 shots!"
	desc_extended = "An 8 round short barrel revolver designed for competitive shooting. Shoots really fast and has very low recoil and spread after the first shot."
	icon = 'icons/obj/item/weapons/ranged/revolver/38_2.dmi'
	icon_state = "inventory"

	shoot_delay = 1.25

	automatic = FALSE

	bullet_count_max = 8

	shoot_sounds = list('sound/weapons/revolver_light/revolver.ogg')

	view_punch = 3

	slowdown_mul_held = HELD_SLOWDOWN_REVOLVER

	size = SIZE_2


	bullet_length_min = 10
	bullet_length_best = 29
	bullet_length_max = 30

	bullet_diameter_min = 8.5
	bullet_diameter_best = 9
	bullet_diameter_max = 9.5

	heat_per_shot = 0.003
	heat_max = 0.01

	value = 150

	attachment_whitelist = list(
		/obj/item/attachment/barrel/charger = TRUE,
		/obj/item/attachment/barrel/compensator = TRUE,
		/obj/item/attachment/barrel/extended = TRUE,
		/obj/item/attachment/barrel/suppressor = TRUE,
		/obj/item/attachment/sight/laser_sight = TRUE,
		/obj/item/attachment/sight/quickfire_adapter = TRUE,
		/obj/item/attachment/sight/red_dot = TRUE,
		/obj/item/attachment/sight/scope = TRUE
	)

	attachment_barrel_offset_x = 29 - 16
	attachment_barrel_offset_y = 23 - 16

	attachment_sight_offset_x = 15 - 16
	attachment_sight_offset_y = 23 - 16

	attachment_undermount_offset_x = 27 - 16
	attachment_undermount_offset_y = 21 - 16

/obj/item/weapon/ranged/bullet/revolver/comp/get_static_spread() //Base spread
	return 0.001

/obj/item/weapon/ranged/bullet/revolver/comp/get_skill_spread(var/mob/living/L) //Base spread
	return max(0,0.04 - (0.06 * L.get_skill_power(SKILL_RANGED)))