/* OLD MOVEMENT
/obj/hud/inventory/proc/do_drag(var/turf/T,var/movement_override = 0)
	var/distance = get_dist(owner,grabbed_object)
	if(grabbed_object && distance > 1)
		if(distance > 2 || !grabbed_object.do_step(T,movement_override))
			release_object()
			return FALSE

	return TRUE
*/


/mob/living/advanced/Move(NewLoc,Dir=0,step_x=0,step_y=0)

	. = ..()

	if(.)
		spawn()
			if(left_hand && left_hand.grabbed_object)
				var/turf/back_turf = get_step(src,turn(move_dir, 180))
				var/distance = get_dist(src,left_hand.grabbed_object)
				if(distance > 2)
					left_hand.release_object(src)
				else if(distance > 1)
					left_hand.grabbed_object.glide_size = glide_size
					if(!left_hand.grabbed_object.Move(back_turf,Dir))
						left_hand.release_object(src)

			if(right_hand && right_hand.grabbed_object)
				var/turf/back_turf = get_step(src,turn(move_dir, 180))
				var/distance = get_dist(src,right_hand.grabbed_object)
				if(distance > 2)
					right_hand.release_object(src)
				else if(distance > 1)
					right_hand.grabbed_object.glide_size = glide_size
					if(!right_hand.grabbed_object.Move(back_turf,Dir))
						right_hand.release_object(src)

	return .


/obj/hud/inventory/proc/grab_object(var/mob/caller as mob,var/atom/movable/object,location,control,params)

	if(!is_movable(object) || !object.can_be_grabbed(caller) || !isturf(object.loc))
		caller.to_chat(span("notice","You cannot grab this!"))
		return FALSE

	if(length(held_objects) || grabbed_object)
		caller.to_chat(span("notice","You need an empty hand to grab this!"))
		return FALSE

	if(object.grabber)
		caller.to_chat(span("notice","\The [object.grabber.name] is already grabbing this!"))
		return FALSE

	caller.to_chat(span("notice","You grab \the [object.name]."))
	grabbed_object = object
	grabbed_object.grabber = src.owner
	update_overlays()

	return TRUE

/obj/hud/inventory/proc/release_object(var/mob/caller as mob)
	if(caller)
		caller.to_chat(span("notice","You release \the [grabbed_object.name]."))
	grabbed_object.grabber = null
	grabbed_object = null
	update_overlays()
	return TRUE