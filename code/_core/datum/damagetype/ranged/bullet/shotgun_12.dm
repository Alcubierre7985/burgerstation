/damagetype/ranged/bullet/shotgun/buckshot
	name = "group of buckshot pellets"

	//The base attack damage of the weapon. It's a flat value, unaffected by any skills or attributes.
	attack_damage_base = list(
		BLADE = 3,
		BLUNT = 2,
		PIERCE = 5
	)

	//How much armor to penetrate. It basically removes the percentage of the armor using these values.
	attack_damage_penetration = list(
		BLADE = 25,
		BLUNT = 25,
		PIERCE = 25
	)

/damagetype/ranged/bullet/shotgun/slug
	name = "shotgun slug"

	//The base attack damage of the weapon. It's a flat value, unaffected by any skills or attributes.
	attack_damage_base = list(
		BLUNT = 60,
		PIERCE = 20
	)

	//How much armor to penetrate. It basically removes the percentage of the armor using these values.
	attack_damage_penetration = list(
		BLUNT = 25,
		PIERCE = 25
	)