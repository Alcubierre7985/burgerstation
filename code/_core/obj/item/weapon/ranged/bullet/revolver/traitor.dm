/obj/item/weapon/ranged/bullet/revolver/traitor_357
	name = "\improper .357 Traditore Revolver"
	desc = "For all your traitor needs!"
	desc_extended = "An Italian made 357 revolver, the Traditore is so cheap it's basically ubiquitous, often ending up among the hands of those of less than savory repute."
	icon = 'icons/obj/item/weapons/ranged/revolver/357.dmi'
	icon_state = "inventory"

	shoot_delay = 4

	automatic = FALSE

	bullet_count_max = 6



	shoot_sounds = list('sound/weapons/traitor/fire.ogg')

	view_punch = 12

	size = SIZE_2


	slowdown_mul_held = HELD_SLOWDOWN_REVOLVER

	bullet_length_min = 20
	bullet_length_best = 33
	bullet_length_max = 35

	bullet_diameter_min = 8.5
	bullet_diameter_best = 9
	bullet_diameter_max = 9.5

	value = 80

	heat_per_shot = 0.04
	heat_max = 0.1

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

	attachment_barrel_offset_x = 30 - 16
	attachment_barrel_offset_y = 21 - 16

	attachment_sight_offset_x = 13 - 16
	attachment_sight_offset_y = 21 - 16

	attachment_undermount_offset_x = 27 - 16
	attachment_undermount_offset_y = 19 - 16

/obj/item/weapon/ranged/bullet/revolver/traitor_357/get_static_spread() //Base spread
	return 0.01

/obj/item/weapon/ranged/bullet/revolver/traitor_357/get_skill_spread(var/mob/living/L) //Base spread
	return max(0,0.03 - (0.04 * L.get_skill_power(SKILL_RANGED)))