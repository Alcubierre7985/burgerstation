/event/meteors
	name = "Meteor Shower"

	probability = 10 //relative
	duration = SECONDS_TO_DECISECONDS(60)

	var/list/turf/valid_turfs = list()
	var/list/area/valid_areas = list()

	occurances_max = 5

/event/meteors/Destroy()
	valid_turfs.Cut()
	valid_areas.Cut()
	return ..()

/event/meteors/New()

	for(var/area/A in world)
		if(A.z < Z_LEVEL_MISSION)
			continue
		if(A.interior)
			continue
		if(A.flags_area & FLAGS_AREA_NO_EVENTS)
			continue
		valid_areas += A

	LOG_DEBUG("Found [length(valid_turfs)] valid turfs for meteors event.")

	return ..()

/event/meteors/on_start()

	valid_turfs.Cut()

	LOG_DEBUG("Starting Meteor Event")

	var/list/announce_areas = list()

	for(var/i=1,i<=3,i++)
		if(!length(valid_areas))
			return FALSE
		var/area/A = pick(valid_areas)
		announce_areas |= A.name
		for(var/turf/T in A.contents)
			valid_turfs |= T

	if(!length(valid_turfs))
		return FALSE

	announce(
		"Central Command Meteorology Division",
		"Meteor Storm Inbound",
		"Meteors have been detected near the area of operations. Predicted landing areas: [english_list(announce_areas)]."
	)

	return ..()

/event/meteors/on_life()

	if(lifetime >= SECONDS_TO_DECISECONDS(10))
		for(var/i=1,i<=rand(10,20),i++)
			var/turf/T = pick(valid_turfs)
			new/obj/effect/falling_meteor(T)

	return ..()

/event/meteors/on_end()
	LOG_DEBUG("Ending Meteor Event")
	return ..()