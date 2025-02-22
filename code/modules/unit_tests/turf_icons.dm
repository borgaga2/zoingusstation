/// Makes sure turf icons actually exist. :)
/datum/unit_test/turf_icons

/datum/unit_test/turf_icons/Run()
	for(var/turf/turf_path as anything in (subtypesof(/turf) - typesof(/turf/closed/mineral)))

		var/icon_state = initial(turf_path.icon_state)
		var/icon_file = initial(turf_path.icon)
		if(isnull(icon_state) || isnull(icon_file))
			continue
		if(!(icon_state in icon_states(icon_file)))
			TEST_FAIL("[turf_path] using invalid icon_state - \"[icon_state]\" in icon file, '[icon_file]")

	for(var/turf/closed/mineral/turf_path as anything in typesof(/turf/closed/mineral)) //minerals use a special (read: snowflake) MAP_SWITCH definition that changes their icon based on if we're just compiling or if we're actually PLAYING the game.

		var/icon_state = initial(turf_path.icon_state)
		var/icon_file = 'icons/turf/mining.dmi'
		if(isnull(icon_state))
			continue
		if(!(icon_state in icon_states(icon_file)))
			TEST_FAIL("[turf_path] using invalid icon_state - \"[icon_state]\" in icon file, '[icon_file]")

	var/turf/initial_turf_type = run_loc_floor_bottom_left.type

	for(var/turf/open/open_turf_path as anything in subtypesof(/turf/open))

		var/damaged_dmi = initial(open_turf_path.damaged_dmi)
		if(isnull(damaged_dmi))
			continue

		var/turf/open/instanced_turf = run_loc_floor_bottom_left.ChangeTurf(open_turf_path)

		var/list/burnt_states = instanced_turf.burnt_states()
		for(var/state in burnt_states)
			if(!(state in icon_states(damaged_dmi)))
				TEST_FAIL("[open_turf_path] has an invalid icon in burnt_states - \"[state]\", in '[damaged_dmi]'")


		var/list/broken_states = instanced_turf.broken_states()
		for(var/state in broken_states)
			if(!(state in icon_states(damaged_dmi)))
				TEST_FAIL("[open_turf_path] has an invalid icon in broken_states - \"[state]\", in '[damaged_dmi]'")

	run_loc_floor_bottom_left = run_loc_floor_bottom_left.ChangeTurf(initial_turf_type) //cleanup.
