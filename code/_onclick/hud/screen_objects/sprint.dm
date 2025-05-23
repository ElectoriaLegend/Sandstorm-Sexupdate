/atom/movable/screen/mov_intent
	icon = 'modular_citadel/icons/ui/screen_midnight.dmi'

/atom/movable/screen/sprintbutton
	name = "toggle sprint"
	icon = 'modular_citadel/icons/ui/screen_midnight.dmi'
	icon_state = "act_sprint"
	mouse_over_pointer = MOUSE_HAND_POINTER
	var/mutable_appearance/flashy

/atom/movable/screen/sprintbutton/Click()
	if(isliving(usr))
		var/mob/living/owner = usr
		owner.default_toggle_sprint()

/atom/movable/screen/sprintbutton/update_icon_state()
	var/mob/living/user = hud?.mymob
	if(!istype(user))
		return
	if(user.combat_flags & COMBAT_FLAG_SPRINT_ACTIVE)
		icon_state = "act_sprint_on"
	else if(HAS_TRAIT(user, TRAIT_SPRINT_LOCKED))
		icon_state = "act_sprint_locked"
	else
		icon_state = "act_sprint"

/atom/movable/screen/sprintbutton/update_overlays()
	. = ..()
	var/mob/living/carbon/user = hud?.mymob
	if(!istype(user) || !user.client)
		return

	if((user.combat_flags & COMBAT_FLAG_SPRINT_ACTIVE) && user.client.prefs.hud_toggle_flash)
		if(!flashy)
			flashy = mutable_appearance('icons/mob/screen_gen.dmi', "togglehalf_flash")
		if(flashy.color != user.client.prefs.hud_toggle_color)
			flashy.color = user.client.prefs.hud_toggle_color
		. += flashy

//Sprint buffer onscreen code.
/datum/hud/var/atom/movable/screen/sprint_buffer/sprint_buffer

/atom/movable/screen/sprint_buffer
	name = "sprint buffer"
	icon = 'icons/effects/progessbar.dmi'
	icon_state = "prog_bar_100"
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/sprint_buffer/Click()
	if(isliving(usr))
		var/mob/living/L = usr
		to_chat(L, "<span class='boldnotice'>Your sprint buffer's maximum capacity is [L.sprint_buffer_max]. It is currently at [L.sprint_buffer], regenerating at [L.sprint_buffer_regen_ds * 10] per second. \
		Sprinting while this is empty will incur a [L.sprint_stamina_cost] stamina cost per tile.</span>")

/atom/movable/screen/sprint_buffer/proc/update_to_mob(mob/living/L)
	var/amount = 0
	if(L.sprint_buffer_max > 0)
		amount = round(clamp((L.sprint_buffer / L.sprint_buffer_max) * 100, 0, 100), 5)
	icon_state = "prog_bar_[amount]"
