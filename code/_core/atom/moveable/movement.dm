/atom/movable/proc/get_movement_delay()
	return movement_delay * MOVEMENT_DELAY_MOD

/atom/movable/proc/handle_movement(var/adjust_delay = 1) //Measured in ticks.

	if(anchored)
		return FALSE

	var/final_move_dir = move_dir

	if(!final_move_dir)
		if(deceleration)
			acceleration_value = round(max(acceleration_value - deceleration*adjust_delay,0),0.01)
		else
			acceleration_value = 0
		if(use_momentum && move_dir_last && acceleration_value)
			final_move_dir = move_dir_last

	if(final_move_dir && is_valid_dir(final_move_dir) && move_delay <= 0)

		var/final_movement_delay = get_movement_delay()

		if(final_move_dir in DIRECTIONS_INTERCARDINAL)
			final_movement_delay *= HYPOTENUSE(1,1)

		if(acceleration_mod > 0)
			final_movement_delay *= 1 / (acceleration_mod + ((acceleration_value/100)*(1-acceleration_mod)))

		var/atom/desired_loc = get_step(src,final_move_dir)
		var/list/step_offsets = list(0,0)
		if(step_size != TILE_SIZE)
			step_offsets = direction_to_pixel_offset(final_move_dir)
			desired_loc = src.loc
			final_movement_delay = 0
		if(isturf(desired_loc))
			var/turf/T = desired_loc
			final_movement_delay *= T.delay_modifier

		move_delay = CEILING(max(final_movement_delay,move_delay + final_movement_delay), adjust_delay ? adjust_delay : 1) //Round to the nearest tick. Counting decimal ticks is dumb.

		glide_size = move_delay ? step_size/move_delay : 1

		var/similiar_move_dir = FALSE

		var/move_result = Move(desired_loc,final_move_dir,step_offsets[1],step_offsets[2])
		if(move_result)
			if(move_dir_last & final_move_dir)
				similiar_move_dir = TRUE
			move_dir_last = final_move_dir
		else if(final_move_dir in DIRECTIONS_INTERCARDINAL)
			for(var/new_dir in DIRECTIONS_CARDINAL)
				var/list/new_step_offsets = list(0,0)
				var/atom/new_desired_loc = get_step(src,new_dir)
				if(step_size != 32)
					new_step_offsets = direction_to_pixel_offset(final_move_dir)
					new_desired_loc = src.loc
				if((new_dir & final_move_dir) && Move(new_desired_loc,new_dir,new_step_offsets[1],new_step_offsets[2]))
					if(move_dir_last & final_move_dir)
						similiar_move_dir = TRUE
					move_dir_last = new_dir
					return TRUE
				else
					move_dir_last = 0x0
		else
			move_dir_last = 0x0

		if(acceleration_mod)
			if(similiar_move_dir)
				acceleration_value = round(min(acceleration_value + acceleration*adjust_delay,100),0.01)
			else
				acceleration_value *= 0.5


		return TRUE
	else
		if(adjust_delay)
			move_delay = move_delay - adjust_delay
		return FALSE

/atom/movable/proc/force_move(var/atom/new_loc)

	var/atom/old_loc = loc

	if(old_loc)
		old_loc.Exited(src, new_loc)
		if(loc) //This needs to be here.
			for(var/k in loc.contents)
				var/atom/movable/AM = k
				if(AM == src)
					continue
				AM.Uncrossed(src,new_loc,old_loc)

	loc = new_loc

	if(loc)
		loc.Entered(src, old_loc)
		if(loc) //This needs to be here.
			for(var/k in loc.contents)
				var/atom/movable/AM = k
				if(AM == src)
					continue
				AM.Crossed(src,new_loc,old_loc)

	if(old_loc != loc)
		post_move(old_loc)

	return FALSE



/atom/movable/proc/post_move(var/atom/old_loc)

	if(grabbing_hand)
		grabbing_hand.check_grab()

	var/light_source/L
	var/thing
	for(thing in light_sources)
		L = thing
		L.source_atom.update_light()

	HOOK_CALL("post_move")
	return TRUE

/atom/movable/Bump(var/atom/obstacle,var/Dir=0)

	if(Dir && ismovable(obstacle) && src.loc != obstacle)
		var/atom/movable/M = obstacle
		if(!M.anchored && (!grabbing_hand || obstacle != grabbing_hand.owner))
			M.glide_size = src.glide_size
			return M.Move(get_step(M,Dir))

	return FALSE


/atom/movable/Move(var/atom/NewLoc,Dir=0x0,desired_step_x=0,desired_step_y=0,var/silent=FALSE)

	var/stepped_x = 0
	var/stepped_y = 0

	//Try Pixel Movement x
	if(desired_step_x)
		if(step_x + desired_step_x >= TILE_SIZE)
			NewLoc = get_step(NewLoc,EAST)
			stepped_x = TILE_SIZE
		else if(step_x + desired_step_x < 0)
			NewLoc = get_step(NewLoc,WEST)
			stepped_x = -TILE_SIZE

	//Try Pixel Movement y
	if(desired_step_y)
		if(step_y + desired_step_y >= TILE_SIZE)
			NewLoc = get_step(NewLoc,NORTH)
			stepped_y = TILE_SIZE

		else if(step_y + desired_step_y < 0)
			NewLoc = get_step(NewLoc,SOUTH)
			stepped_y = -TILE_SIZE

	if(istype(src.loc,/obj/projectile))
		return FALSE

	if(change_dir_on_move && Dir)
		set_dir(Dir)

	if(!NewLoc)
		return FALSE

	if(!loc)
		return FALSE

	var/atom/OldLoc = loc

	var/real_dir = get_dir(loc,NewLoc)

	//TRY: Exit the turf.
	if(!OldLoc.Exit(src,NewLoc) && !Bump(OldLoc,real_dir))
		return FALSE

	//TRY: Exit the contents.
	for(var/k in OldLoc.contents)
		var/atom/movable/M = k
		if(M == src)
			continue
		if(!M.Uncross(src,NewLoc,OldLoc)) //Placing bump here is a bad idea. Easy way to cause infinite loops.
			return FALSE

	//TRY: Enter the contents.
	if(!NewLoc.Enter(src,OldLoc) && !Bump(NewLoc,real_dir))
		return FALSE

	//TRY: Enter the contents.
	for(var/k in NewLoc.contents)
		var/atom/movable/M = k
		if(M == src)
			continue
		if(!M.Cross(src,NewLoc,OldLoc) && !Bump(M,real_dir))
			return FALSE

	if(OldLoc != NewLoc)
		//DO: Exited the turf.
		OldLoc.Exited(src,NewLoc)

		//DO: Exited the contents.
		for(var/k in OldLoc.contents)
			var/atom/movable/A = k
			if(A == src)
				continue
			A.Uncrossed(src,NewLoc,OldLoc)

	if(desired_step_x)
		step_x += desired_step_x - stepped_x

	if(desired_step_y)
		step_y += desired_step_y - stepped_y

	if(loc == OldLoc && loc != NewLoc)
		loc = NewLoc

		//DO: Entered the turf.
		NewLoc.Entered(src,OldLoc)

		//DO: Enter the contents.
		for(var/k in NewLoc.contents)
			var/atom/movable/A = k
			if(A == src)
				continue
			A.Crossed(src,NewLoc,OldLoc)

		post_move(OldLoc)

	return TRUE
