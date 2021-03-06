/damagetype/melee/sword/curvedsword
	name = "steel curved sword"

	//The base attack damage of the weapon. It's a flat value, unaffected by any skills or attributes.
	attack_damage_base = list(
		BLADE = 20
	)

	//How much armor to penetrate. It basically removes the percentage of the armor using these values.
	attack_damage_penetration = list(
		BLADE = 10
	)

	attribute_stats = list(
		ATTRIBUTE_STRENGTH = 10,
		ATTRIBUTE_DEXTERITY = 40
	)

	attribute_damage = list(
		ATTRIBUTE_STRENGTH = BLADE,
		ATTRIBUTE_DEXTERITY = BLADE
	)

	skill_stats = list(
		SKILL_MELEE = 20
	)

	skill_damage = list(
		SKILL_MELEE = BLADE
	)