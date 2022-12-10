/*
 *  class chapter_07
 *
 *
 *  Can NOT be used in network game !
 */

//Step 2 =====================================================================================
ch6_cov_lim1 <- {a = 34, b = 36}

//Step 3 =====================================================================================
ch6_cov_lim2 <- {a = 35, b = 38}

//Step 4 =====================================================================================
ch6_cov_lim3 <- {a = 37, b = 43}

class tutorial.chapter_06 extends basic_chapter
{
	chapter_name  = "The forgotten Air transport"
	chapter_coord = coord(112,174)
	startcash     = 500000	   				// pl=0 startcash; 0=no reset

	gl_wt = wt_air

	c_way = coord(0,0)

	cty1 = {c = coord(118,190), name = ""}
	cty2 = {c = coord(163,498), name = ""}

	cty1_lim = {a = null, b = null}
	cty2_lim = {a = null, b = null}

	sch_cov_correct = false

	// Step 1 =====================================================================================
	// Pista de aterrizaje --------------------------
	c1_track = {a = coord(112,174), b = coord(112,178)}
	c1_start = coord(112,174)
	c1_is_way = null
	obj1_way_name = "runway_modern"

	// Pista de maniobras --------------------------
	c2_track = {a = coord(112,176), b = coord(114,176)}
	c2_start = coord(112,176)
	c2_is_way = null
	obj2_way_name = "taxiway"

	// Parada aerea ---------------------------------
	st1_pos = coord(114,176)
	// Terminal -------------------------------------
	st2_pos = coord(113,175)
	//  Hangar --------------------------------------
	c_dep_lim1 = {a = coord(113,176), b = coord(113,177)}
	c_dep1 = coord(113,177)

	// Step 2 =====================================================================================
	d1_cnr = null //auto started
	plane1_obj = "DC-3"
	plane1_load = 100
	plane1_wait = 25369
	sch_list1 = [coord(114,176), coord(168,489)]

	// Step 3 =====================================================================================
	line1_name = "Test 7"
	c_dep2 = coord(115,185)
	d2_cnr = null //auto started
	sch_list2 = [coord(114,177) coord(121,189), coord(126,187)]
	veh1_obj = "BuessingLinie"
	veh1_load = 100
	veh1_wait = 10571

	// Step 4 =====================================================================================
	line2_name = "Test 8"
	c_dep3 = coord(167,497)
	d3_cnr = null //auto started

	sch_list3 =	[	coord(168,490), coord(160,493), coord(155,493), coord(150,494), coord(154,500), coord(159,499),
					coord(164,498), coord(166,503), coord(171,501), coord(176,501), coord(173,493)
				]

	veh2_obj = "BuessingLinie"

	//Script
	//----------------------------------------------------------------------------------
	comm_script = false

	sc_sta1 = "AirStop"
	sc_sta2 = "Tower1930"
	sc_dep1 = "1930AirDepot"
	sc_dep2 = "CarDepot"


	function start_chapter()  //Inicia solo una vez por capitulo
	{
		rules.clear()
		set_all_rules(0)

		d1_cnr = get_dep_cov_nr(ch6_cov_lim1.a,ch6_cov_lim1.b)
		d2_cnr = get_dep_cov_nr(ch6_cov_lim2.a,ch6_cov_lim2.b)
		d3_cnr = get_dep_cov_nr(ch6_cov_lim3.a,ch6_cov_lim3.b)

		cty1.name = get_city_name(cty1.c)
		cty2.name = get_city_name(cty2.c)

		local pl = 0
		//Schedule list form current convoy
		if(this.step == 3){
			local c_dep = this.my_tile(c_dep2)
			local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
			local cov_list = depot.get_convoy_list()		//Lista de vehiculos en el deposito
			local convoy = convoy_x(gcov_id)
			if (cov_list.len()>=1){
				convoy = cov_list[0]
			}
			local all_result = checks_convoy_schedule(convoy, pl)
			sch_cov_correct = all_result.res == null ? true : false
		}

		local pl = 0
		//Schedule list form current convoy
		if(this.step == 3){
            local c_dep = this.my_tile(c_dep2)
			local c_list = sch_list2
			start_sch_tmpsw(pl,c_dep, c_list)
		}
		else if(this.step == 4){
            local c_dep = this.my_tile(c_dep3)
			local c_list = sch_list3
			start_sch_tmpsw(pl,c_dep, c_list)
		}
		return 0
	}

	function set_goal_text(text){
		switch (this.step) {
			case 1:
				text.c1_a = "<a href=\"("+c1_track.a.x+","+c1_track.a.y+")\"> ("+c1_track.a.tostring()+")</a>"
				text.c1_b = "<a href=\"("+c1_track.b.x+","+c1_track.b.y+")\"> ("+c1_track.b.tostring()+")</a>"
				text.c2_a = "<a href=\"("+c2_track.a.x+","+c2_track.a.y+")\"> ("+c2_track.a.tostring()+")</a>"
				text.c2_b = "<a href=\"("+c2_track.b.x+","+c2_track.b.y+")\"> ("+c2_track.b.tostring()+")</a>"
				break

			case 2:
				text.plane = translate(plane1_obj)
				text.load = plane1_load
				text.wait = get_wait_time_text(plane1_wait)
				text.cnr = d1_cnr
    			break

			case 3:
				local list_tx = ""
				local c_list = sch_list2
				local siz = c_list.len()
				for (local j=0;j<siz;j++){
					local c = coord(c_list[j].x, c_list[j].y)
					local tile = my_tile(c)
					local st_halt = tile.get_halt()
					if(sch_cov_correct){
						list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
						continue
					}
					if(tmpsw[j]==0 ){
						list_tx += format("<st>%s %d:</st> %s<br>", translate("Stop"), j+1, c.href(st_halt.get_name()+" ("+c.tostring()+")"))
					}
					else{						
						list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
					}
				}
				local c = coord(c_list[0].x, c_list[0].y)
				text.stnam = "1) "+my_tile(c).get_halt().get_name()+" ("+c.tostring()+")"
				text.stx = list_tx
				text.dep2 = "<a href=\"("+c_dep2.x+","+c_dep2.y+")\"> ("+c_dep2.tostring()+")</a>"
				text.load = veh1_load
				text.wait = get_wait_time_text(veh1_wait)
				text.cnr = d2_cnr

				break

			case 4:
				local list_tx = ""
				local c_list = sch_list3
				local siz = c_list.len()
				for (local j=0;j<siz;j++){
					local c = coord(c_list[j].x, c_list[j].y)
					local tile = my_tile(c)
					local st_halt = tile.get_halt()
					if(sch_cov_correct){
						list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
						continue
					}
					if(tmpsw[j]==0 ){
						list_tx += format("<st>%s %d:</st> %s<br>", translate("Stop"), j+1, c.href(st_halt.get_name()+" ("+c.tostring()+")"))
					}
					else{						
						list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
					}
				}
				local c = coord(c_list[0].x, c_list[0].y)
				text.stnam = "1) "+my_tile(c).get_halt().get_name()+" ("+c.tostring()+")"
				text.stx = list_tx
				text.dep3 = "<a href=\"("+c_dep3.x+","+c_dep3.y+")\"> ("+c_dep3.tostring()+")</a>"

				text.load = veh1_load
				text.wait = get_wait_time_text(veh1_wait)
				text.cnr = d3_cnr

				break
			}
			local st1_halt = my_tile(sch_list1[0]).get_halt()
			local st2_halt = my_tile(sch_list1[1]).get_halt()
			if(st1_halt){
				text.sch1 = "<a href=\"("+sch_list1[0].x+","+sch_list1[0].y+")\"> "+st1_halt.get_name()+" ("+sch_list1[0].tostring()+")</a>"
				text.sch2 = "<a href=\"("+sch_list1[1].x+","+sch_list1[1].y+")\"> "+st2_halt.get_name()+" ("+sch_list1[1].tostring()+")</a>"
			}
			text.w1name = translate(obj1_way_name)
			text.w2name = translate(obj2_way_name)
			text.bus1 = translate(veh1_obj)
			text.bus2 = translate(veh2_obj) 
			text.cit1 = cty1.c.href(cty1.name.tostring())
			text.cit2 = cty2.c.href(cty2.name.tostring())
			text.st1 = "<a href=\"("+st1_pos.x+","+st1_pos.y+")\"> ("+st1_pos.tostring()+")</a>"
			text.st2 = "<a href=\"("+st2_pos.x+","+st2_pos.y+")\"> ("+st2_pos.tostring()+")</a>"
			text.dep1 = "<a href=\"("+c_dep1.x+","+c_dep1.y+")\"> ("+c_dep1.tostring()+")</a>"
			return text
	}
	
	function is_chapter_completed(pl) {
		local percentage=0

		save_glsw()
		save_pot()

		switch (this.step) {
			case 1:
				if (pot0==0){
					local tile = my_tile(c1_start)	
					c1_is_way = tile.find_object(mo_way)

					local ta = my_tile(c1_track.a)
					local tb = my_tile(c1_track.b)
					local coora = coord3d(ta.x, ta.y, ta.z)
					local coorb = coord3d(tb.x, tb.y, tb.z)
					local wt = gl_wt
					local name_list = [obj1_way_name]
					local dir = 4
					local fullway = check_way(coora, coorb, wt, name_list, dir)
					if (fullway.result){
						c_way =  coord(0,0)
						pot0=1
					}
					else 
						c_way = fullway.c
				
					return 5					
				}

				else if (pot0==1 && pot1==0){
					local tile = my_tile(c2_start)	
					c2_is_way = tile.find_object(mo_way)

					local ta = my_tile(c2_track.a)
					local tb = my_tile(c2_track.b)
					local coora = coord3d(ta.x, ta.y, ta.z)
					local coorb = coord3d(tb.x, tb.y, tb.z)
					local wt = gl_wt
					local name_list = [obj1_way_name, obj2_way_name]
					local dir = 2
					local fullway = check_way(coora, coorb, wt, name_list, dir)
					if (fullway.result){
						c_way = coord(0,0)
						pot1=1
					}
					else 
						c_way = fullway.c
				
					return 10					
				}

				else if (pot1==1 && pot2==0){
					local tile = my_tile(st1_pos)
					local way = tile.find_object(mo_way)
					local buil = tile.find_object(mo_building)
					if(way && buil){
						pot2 = 1
					}
					return 15
				}

				else if (pot2==1 && pot3==0){
					local tile = my_tile(st2_pos)
					local buil = tile.find_object(mo_building)
					if(buil){
						pot3 = 1
					}
					return 20
				}

				else if (pot3==1 && pot4==0){
					local tile = my_tile(c_dep1)
					local way = tile.find_object(mo_way)
					local depot = tile.find_object(mo_depot_air)
					if(way && depot){
						pot4 = 1
					}
					return 25
				}
				else if (pot5==1 && pot6==0){
					this.next_step()
				}

				break;

			case 2:

				if(current_cov == ch6_cov_lim1.b){
					this.next_step()
				}

				return 50
				break;

			case 3:
			    local c_dep = this.my_tile(c_dep2)
                local line_name = line1_name
                set_convoy_schedule(pl, c_dep, wt_road, line_name)

				local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
				local cov_list = depot.get_convoy_list()		//Lista de vehiculos en el deposito
				local convoy = convoy_x(gcov_id)
				if (cov_list.len()>=1){
					convoy = cov_list[0]
				}
				local all_result = checks_convoy_schedule(convoy, pl)
				sch_cov_correct = all_result.res == null ? true : false

				if(current_cov == ch6_cov_lim2.b){
					sch_cov_correct = false
				    this.next_step()
				}
		        return 65
				break;

			case 4:
				if (pot0==0){
					local tile = my_tile(c_dep3)
					local way = tile.find_object(mo_way)
					local depot = tile.find_object(mo_depot_road)
					if(way && depot){
						pot0 = 1
					}
					return 25
				}
				else if (pot0==1 && pot1==0){
					local c_dep = this.my_tile(c_dep3)
		            local line_name = line2_name
		            set_convoy_schedule(pl, c_dep, wt_road, line_name)

					local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
					local cov_list = depot.get_convoy_list()		//Lista de vehiculos en el deposito
					local convoy = convoy_x(gcov_id)
					if (cov_list.len()>=1){
						convoy = cov_list[0]
					}
					local all_result = checks_convoy_schedule(convoy, pl)
					sch_cov_correct = all_result.res == null ? true : false

					if(current_cov == ch6_cov_lim3.b){
						sch_cov_correct = false
						this.next_step()
					}			
				}
		        return 80
				break;

			case 5:
				this.step=1
				persistent.step=1
				persistent.status.step = 1
		        return 100
				break;
			}
			percentage=(this.step-1)+1
			return percentage
	}
	
	function is_work_allowed_here(pl, tool_id, pos) {
		local result = null	// null is equivalent to 'allowed'

		result = translate("Action not allowed")
		local t = tile_x(pos.x, pos.y, pos.z)
		local ribi = 0
		local wt = 0
		//local tmark = t.is_marked()
		local buil = t.find_object(mo_building)
		//if(buil)
			//gui.add_message(""+buil.get_desc().get_name())
		
		local depot = t.find_object(mo_depot_air)
		//if(depot)
			//gui.add_message(""+depot.get_desc().get_name())
		
		local way = t.find_object(mo_way)
		//local gcursor = t.find_object(mo_pointer)
		//local cursor = null
		//local hold_way = null

		if (way){
			wt = way.get_waytype()
			if (tool_id!=4111)
				ribi = way.get_dirs()
			if (!t.has_way(gl_wt))
				ribi = 0
		}

		if (tool_id==4096)
			return null
		switch (this.step) {
			case 1:		
				local climate = square_x(pos.x, pos.y).get_climate()
				//return climate
				if (pot0==0){
					if ((pos.x>=c1_track.a.x)&&(pos.y>=c1_track.a.y)&&(pos.x<=c1_track.b.x)&&(pos.y<=c1_track.b.y)){
						if (way && way.get_name() != obj1_way_name){
							if(tool_id == tool_remover || tool_id == tool_remove_way) return null

							result = format(translate("The track is not correct it must be: %s, use the 'Remove' tool"),translate(obj1_way_name)) + " ("+c1_start.tostring()+")."

							if(tool_id == tool_build_way) return result
						}
						else if (way) result = translate("The track is correct.")

						if(tool_id == tool_build_way) return null

/*
						if (!c1_is_way){
							local cursor = my_tile(c1_start).find_object(mo_pointer)
							if (cursor) hold_pos=pos 
							local tmark = hold_pos ? my_tile(hold_pos).is_marked() : false
							if((pos.x != c1_start.x || pos.y != c1_start.y)&&(!cursor)&&(!tmark))
								return translate("Build the track from here") + " ("+c1_start.tostring()+")."

							if(tool_id == tool_build_way) return null
						}
						else {
							if(way && way.get_name() != obj1_way_name)
								return format(translate("The track is not correct it must be: %s, use the 'Remove' tool"),translate(obj1_way_name)) + " ("+c1_start.tostring()+")."
							else if(tool_id == tool_build_way)									
								return all_control(result, gl_wt, way, ribi, tool_id, pos, c_way)
						
							if (way && way.get_name() == obj1_way_name){
								return translate("The track is correct.")
							}
						}*/
					}
					else return translate("Build here") + ": ("+c_way.tostring()+")!."
				}
				else if (pot0==1 && pot1==0){	
					if (pos.x == c2_track.a.x && pos.y == c2_track.a.y){
						if(tool_id == tool_remover || tool_id == tool_remove_way) return result
						else if(tool_build_way) return null			
					}

					if ((pos.x>=c2_track.a.x)&&(pos.y>=c2_track.a.y)&&(pos.x<=c2_track.b.x)&&(pos.y<=c2_track.b.y)){
						if (way && way.get_name() != obj2_way_name){
							if(tool_id == tool_remover || tool_id == tool_remove_way) return null

							result = format(translate("The track is not correct it must be: %s, use the 'Remove' tool"),translate(obj2_way_name)) + " ("+c2_start.tostring()+")."

							if(tool_id == tool_build_way){							
								return result
							}
						}
						else if (way) result = translate("The track is correct.")

						if(tool_id == tool_build_way) return null

						
						/*if (!c2_is_way){
							local cursor = my_tile(c2_start).find_object(mo_pointer)
							if (cursor) hold_pos=pos 
							local tmark = hold_pos ? my_tile(hold_pos).is_marked() : false
							if((pos.x != c2_start.x || pos.y != c2_start.y)&&(!cursor)&&(!tmark))
								return translate("Build the track from here") + " ("+c2_start.tostring()+")!."
							if(tool_id == tool_build_way) return null
						}
						else {
							if (tool_id == tool_build_way && pos.x == c2_track.a.x && pos.y == c2_track.a.y)
								return null

							else if (way && way.get_name() != obj2_way_name){
								return format(translate("The track is not correct it must be: %s, use the 'Remove' tool"),translate(obj2_way_name)) + " ("+c2_start.tostring()+")!."
							}
							else if(tool_id == tool_build_way)									
								return all_control(result, gl_wt, way, ribi, tool_id, pos, c_way)
						}
						
						if (way && way.get_name() == obj2_way_name){
							return translate("The track is correct.")
						}*/
					}
					else return translate("Build here") + ": ("+c_way.tostring()+")!."
				}

				else if (pot1==1 && pot2==0){
					if(pos.x == st1_pos.x && pos.y == st1_pos.y){
						if(tool_id == tool_build_way){
							if (way){
								return translate("The track is correct.")
							}
							else return null
						}
						if(tool_id == tool_build_station){
							if(buil){
								return translate("There is already a station.")
							}
							else return null
						}
					}
					else return translate("Build here") + ": ("+st1_pos.tostring()+")!."
				}

				else if (pot2==1 && pot3==0){
					if(pos.x == st2_pos.x && pos.y == st2_pos.y){
						if(tool_id == tool_build_station){
							if (buil){
								return translate("There is already a station.")
							}
							else return null
						}
					}
					else return translate("Build here") + ": ("+st2_pos.tostring()+")!."
				}

				else if (pot3==1 && pot4==0){
					if((pos.x == c_dep_lim1.a.x && pos.y == c_dep_lim1.a.y) || (pos.x == c_dep_lim1.b.x && pos.y == c_dep_lim1.b.y)){
						if(tool_id == tool_build_way){
							return null
						}
						if(tool_id == tool_build_depot){
							if(depot){
								return translate("The Hangar is correct.")
							}
							else return null
						}
					}
					else return translate("Build here") + ": ("+c_dep1.tostring()+")!."
				}
				else if (pot4==1 && pot5==0){
					if(pos.x == st1_pos.x && pos.y == st1_pos.y){
						if(tool_id == tool_make_stop_public){
							if(buil){
								pot5 = 1
								return null
							}
							else return null
						}
					}
					else return translate("Click on the stop") + " ("+st1_pos.tostring()+")!."
					
				}
				break;

			case 2:

				if (tool_id==4108) {
					if (glsw[0]==0){
						if(pos.x == sch_list1[0].x && pos.y == sch_list1[0].y) {
							glsw[0]=1
							return null
						}
						else return translate("Click on the stop") + " ("+sch_list1[0].tostring()+")!."		
					}

					if (glsw[1]==0 && glsw[0]==1){
						if(pos.x == sch_list1[1].x && pos.y == sch_list1[1].y) {
							glsw[1]=1
							return null
						}
						else return translate("Click on the stop") + " ("+sch_list1[1].tostring()+")!."		
					}
				}
				break;

			case 3:
				if (tool_id==4108) {			
					local c_list = sch_list2		//Lista de todas las paradas de autobus
					local c_dep = c_dep2			//Coordeadas del deposito 
					local siz = c_list.len()		//Numero de paradas 
					result = translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep.tostring()+")."
					return is_stop_allowed(result, siz, c_list, pos)
				}
				break;

			case 4:
				if (pot0==0){
					if(pos.x == c_dep3.x && pos.y == c_dep3.y){
						if(tool_id == tool_build_depot){
							if(depot){
								return translate("The Depot is correct.")
							}
							else return null
						}
					}
					else return translate("Build here") + ": ("+c_dep3.tostring()+")!."
				}
				if (pot0==1 && pot1==0){
					if (tool_id==4108) {
						local c_list = sch_list3			//Lista de todas las paradas de autobus
						local c_dep = c_dep3				//Coordeadas del deposito 
						local siz = c_list.len()			//Numero de paradas 
						result = translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep.tostring()+")."
						return is_stop_allowed(result, siz, c_list, pos)
					}
				}
				break;
		}
		if (tool_id==4096)
			return null
		return result

	}
	
	function is_schedule_allowed(pl, schedule) {
		local result=null	// null is equivalent to 'allowed'
		local nr = schedule.entries.len()
		switch (this.step) {
			case 2:
				reset_glsw()

				local selc = 0
				local load = plane1_load
				local time = plane1_wait
				local c_list = sch_list1
				local siz = c_list.len()
				return set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz)
			break
			case 3:
				if ( schedule.waytype != wt_road )
					result = translate("Only road schedules allowed")
				local selc = 0
				local load = veh1_load
				local time = veh1_wait
				local c_list = sch_list2
				local siz = c_list.len()
				local line = true
				result = set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz, line)
				if(result == null){
					local line_name = line1_name
					update_convoy_schedule(pl, wt_road, line_name, schedule)
				}
				return result
			break
			case 4:
				if ( schedule.waytype != wt_road )
					result = translate("Only road schedules allowed")
				local selc = 0
				local load = veh1_load
				local time = veh1_wait
				local c_list = sch_list3
				local siz = c_list.len()
				local line = true
				result = set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz, line)
				if(result == null){
					local line_name = line2_name
					update_convoy_schedule(pl, wt_road, line_name, schedule)
				}
				return result
			break
		}
		return translate("Action not allowed")
	}

	function is_convoy_allowed(pl, convoy, depot)
	{						
		local result=null	// null is equivalent to 'allowed'
		switch (this.step) {
			case 2:
				local wt = gl_wt
				if ((depot.x != c_dep1.x)||(depot.y != c_dep1.y))
					return translate("You must select the deposit located in")+" ("+c_dep1.tostring()+")."
				if (current_cov>ch6_cov_lim1.a && current_cov<ch6_cov_lim1.b){
					local cov = d1_cnr
					local veh = 1
					local good_list = [good_desc_x(good_alias.passa).get_catg_index()] //Passengers
					local name = plane1_obj
					local st_tile = 1

					result = is_convoy_correct(depot, cov, veh,good_list, name, st_tile)
					if (result!=null){
						local name = translate(plane1_obj)
						local load = translate(good_alias.passa)
						if (result==0)
							return format(translate("You must select a [%s]."),translate(name))

						if (result==1)
							return format(translate("The number of aircraft in the hangar must be [%d]."),cov)

						if (result==2)
							return format(translate("The number of convoys must be [%d], press the [Sell] button."),cov)

						if (result==3)
							return format(translate("The Plane must be for [%s]."),load)

						if (result==4)
							return translate("Extensions are not allowed.")

						if (result==5)
							return format(translate("The number of planes in the hangar must be [%d], use the [sell] button."),cov)
					}

					local selc = 0
					local load = plane1_load
					local time = plane1_wait
					local c_list = sch_list1
					local siz = c_list.len()
					return set_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
				}
			break
			case 3:
				if ((depot.x != c_dep2.x)||(depot.y != c_dep2.y))
					return translate("You must select the deposit located in")+" ("+c_dep2.tostring()+")."
				if (current_cov>ch6_cov_lim2.a && current_cov<ch6_cov_lim2.b){
					/*if (comm_script){
						cov_save[current_cov]=convoy
						id_save[current_cov]=convoy.id
						gcov_nr++
						persistent.gcov_nr = gcov_nr
						return null
					}*/

					local cov_list = depot.get_convoy_list()
					local cov = cov_list.len()
					local veh = 1
					local good_list = [good_desc_x (good_alias.passa).get_catg_index()] 	 //Passengers
					local name = veh1_obj
					local st_tile = 1
					result = is_convoy_correct(depot,cov,veh,good_list,name, st_tile)
					if (result!=null){
						reset_tmpsw()
						return bus_result_message(result, translate(name), veh, cov)
					}

					local selc = 0
					local load = veh1_load
					local wait = veh1_wait
					local c_list = sch_list2
					local siz = c_list.len()
					local line = false
					result = set_schedule_convoy(result, pl, cov, convoy, selc, load, wait, c_list, siz, line)
					if(result == null)
						reset_tmpsw()
					return result		
				}
			break
			case 4:
				if ((depot.x != c_dep3.x)||(depot.y != c_dep3.y))
					return translate("You must select the deposit located in")+" ("+c_dep3.tostring()+")."
				if (current_cov>ch6_cov_lim3.a && current_cov<ch6_cov_lim3.b){
					/*if (comm_script){
						cov_save[current_cov]=convoy
						id_save[current_cov]=convoy.id
						gcov_nr++
						persistent.gcov_nr = gcov_nr
						return null
					}*/

					local cov_list = depot.get_convoy_list()
					local cov = cov_list.len()
					local veh = 1
					local good_list = [good_desc_x (good_alias.passa).get_catg_index()] 	 //Passengers
					local name = veh1_obj
					local st_tile = 1
					result = is_convoy_correct(depot,cov,veh,good_list,name, st_tile)
					if (result!=null){
						reset_tmpsw()
						return bus_result_message(result, translate(name), veh, cov)
					}

					local selc = 0
					local load = veh1_load
					local wait = veh1_wait
					local c_list = sch_list3
					local siz = c_list.len()
					local line = false
					result = set_schedule_convoy(result, pl, cov, convoy, selc, load, wait, c_list, siz, line)
					if(result == null)
						reset_tmpsw()
					return result		
				}
			break
		}
		return result = translate("It is not allowed to start vehicles.")
	}

	function script_text()
	{
		local player = player_x(0)
		switch (this.step) {
			case 1:
				// Pista de aterrizaje --------------------------
				if(pot0 == 0) {
					local coora = my_tile(c1_track.a)
					local coorb = my_tile(c1_track.b)

					local wt = gl_wt
					local name_list = [obj1_way_name]
					local dir = 4
					local fullway = check_way(coora, coorb, wt, name_list, dir)
					if (fullway.result){
						c_way =  coord(0,0)
					}
					else{
						local tile = tile_x(fullway.c.x, fullway.c.y, fullway.c.z)
						local way = tile.find_object(mo_way)
						if(way)
							way.unmark()

						local siz = (coorb.y)-(coora.y)+(1)
						local opt = 2 //Incrementa y
						local t = coora
						clean_track_segment(t, siz, opt)
					}
					//gui.add_message(""+fullway.result)

					coora = my_tile(c1_track.a)
					coorb = my_tile(c1_track.b)
					local t = command_x(tool_build_way)
					t.work(player, coora, coorb, obj1_way_name)
					pot0=1
				}

				// Pista de maniobras --------------------------
				if(pot1 == 0) {
					local coora = my_tile(c2_track.a)
					local coorb = my_tile(c2_track.b)

					local wt = gl_wt
					local name_list = [obj2_way_name]
					local dir = 2
					local fullway = check_way(coora, coorb, wt, name_list, dir)
					if (fullway.result){
						c_way =  coord(0,0)
					}
					else{
						local tile = tile_x(fullway.c.x, fullway.c.y, fullway.c.z)
						local way = tile.find_object(mo_way)
						if(way)
							way.unmark()

						local siz = (coorb.x)-(coora.x)
						//gui.add_message(""+siz+" -- "+coorb.x)
						local opt = 1 //Incrementa x
						coora.x++
						local t = coora
						clean_track_segment(t, siz, opt)
					}
					//gui.add_message(""+fullway.result)

					coora = my_tile(c2_track.a)
					coorb = my_tile(c2_track.b)

					local t = command_x(tool_build_way)
					t.work(player, coora, coorb, obj2_way_name)
					pot1 = 1
				}
				// Parada aerea ---------------------------------
				if(pot2 == 0) {
					local tile = my_tile(st1_pos)
					local t = command_x(tool_build_station)			
					t.work(player, tile, sc_sta1)
					pot2 = 1
				}
				// Terminal -------------------------------------
				if(pot3 == 0) {
					local tile = my_tile(st2_pos)
					local t = command_x(tool_build_station)			
					t.work(player, tile, sc_sta2)
					pot3 = 1
				}

				//  Hangar --------------------------------------
				if(pot4 == 0) {
					local coora = my_tile(c_dep_lim1.a)
					local coorb = my_tile(c_dep_lim1.b)
					local t = command_x(tool_build_way)
					t.work(player, coora, coorb, obj2_way_name)
					local tile = my_tile(c_dep1)
					t = command_x(tool_build_depot)			
					t.work(player, tile, sc_dep1)
					pot4 = 1
				}
				if(pot5 == 0) {
					local t = command_x(tool_make_stop_public)			
					t.work(player, my_tile(st1_pos), "")
					pot5 = 1
				}
				return null
			break;
			case 2:
				//gui.add_message(""+current_cov+" -- "+ch6_cov_lim1.a +" -- "+ ch6_cov_lim1.b)
				if (current_cov> ch6_cov_lim1.a && current_cov< ch6_cov_lim1.b){

					local pl = player
					local c_depot = my_tile(c_dep1)

					try {
						comm_destroy_convoy(pl, c_depot) // Limpia los vehiculos del deposito
					}
					catch(ev) {
						return null
					}
					local sched = schedule_x(gl_wt, [])
					local c_list = sch_list1
					for(local j = 0;j<c_list.len();j++){
						if(j==0)
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), plane1_load, plane1_wait))
						else
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), 0, 0))
					}
					local c_line = comm_get_line(player, gl_wt, sched)

					local depot = c_depot.find_object(mo_depot_air)
					local name = plane1_obj
					local cov_nr = d1_cnr  //Max convoys nr in depot
					if (!comm_set_convoy(cov_nr, c_depot, name))
						return 0

					local conv = depot.get_convoy_list()
					conv[0].set_line(player, c_line)
					comm_start_convoy(player, conv[0], depot)
				}

			break
			case 3:
				local c_depot = my_tile(c_dep2)
				comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito

				if (current_cov>ch6_cov_lim2.a && current_cov<ch6_cov_lim2.b){
					local c_list = sch_list2
					local sch_siz = c_list.len()
					local load = veh1_load
					local wait = veh1_wait
					local sched = schedule_x(wt_road, [])
					for(local i=0;i<sch_siz;i++){
						if (i==0)
							sched.entries.append(schedule_entry_x(my_tile(c_list[i]), load, wait))
						else
							sched.entries.append(schedule_entry_x(my_tile(c_list[i]), 0, 0))
					}
					local c_line = comm_get_line(player, wt_road, sched)

					local good_nr = 0 //Passengers
					local name = veh1_obj
					local cov_nr = d2_cnr  //Max convoys nr in depot
					local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
					for (local j = 0; j<cov_nr; j++){
						if (!comm_set_convoy(cov_nr, c_depot, name))
							return 0

						local conv = depot.get_convoy_list()
						if (conv.len()==0) continue
						conv[j].set_line(player, c_line)
					}
					local convoy = false
					local all = true
					comm_start_convoy(player, convoy, depot, all)
				}
				return null
				break;
			case 4:
				local c_depot = my_tile(c_dep3)
				if(pot0==0){

					local tool = command_x(tool_build_depot)
					tool.work(player, c_depot, sc_dep2)
					pot0=1
				}
				comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito
				//gui.add_message(""+current_cov+" -- "+ch6_cov_lim3.a +" -- "+ ch6_cov_lim3.b)
				if (current_cov>ch6_cov_lim3.a && current_cov<ch6_cov_lim3.b){
					local c_list = sch_list3
					local sch_siz = c_list.len()
					local load = veh1_load
					local wait = veh1_wait
					local sched = schedule_x(wt_road, [])
					for(local i=0;i<sch_siz;i++){
						if (i==0)
							sched.entries.append(schedule_entry_x(my_tile(c_list[i]), load, wait))
						else
							sched.entries.append(schedule_entry_x(my_tile(c_list[i]), 0, 0))
					}
					local c_line = comm_get_line(player, wt_road, sched)

					local good_nr = 0 //Passengers
					local name = veh1_obj
					local cov_nr = d3_cnr  //Max convoys nr in depot
					local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
					for (local j = 0; j<cov_nr; j++){
						if (!comm_set_convoy(cov_nr, c_depot, name))
							return 0

						local conv = depot.get_convoy_list()
						if (conv.len()==0) continue
						conv[j].set_line(player, c_line)
					}
					local convoy = false
					local all = true
					comm_start_convoy(player, convoy, depot, all)
				}
				return null
			break
		}
		return null
	}

	function script_experimento()
	{
		exp = true
		return null
	}
	
	function set_all_rules(pl) 
    {
		local forbid = [	tool_remove_wayobj, tool_build_bridge, tool_build_way, tool_build_tunnel,tool_build_station,
	                       	tool_remove_way, tool_build_depot, tool_build_roadsign, tool_build_wayobj
						]

		foreach(wt in all_waytypes)
			if (wt != wt_air && wt != wt_road) {
			    foreach (tool_id in forbid)
				    rules.forbid_way_tool(pl, tool_id, wt )
			}

		local forbid =	[	4134,4135, tool_lower_land, tool_raise_land, tool_setslope, tool_build_roadsign, tool_restoreslope,
							tool_plant_tree, tool_set_marker, tool_add_city, 4137, tool_stop_mover, tool_buy_house, tool_build_wayobj,
      						tool_remove_wayobj, tool_build_tunnel, tool_build_transformer, tool_build_bridge, tool_remove_way
						]

		foreach (tool_id in forbid)
		    rules.forbid_tool(pl, tool_id)
	}


	function check_way(coora, coorb, wt, name_list, dir = false)
	{
		local sve_coord = coora
		local tile_start =  tile_x(coora.x, coora.y, coora.z)
		local way_start = tile_start.find_object(mo_way)
		if(way_start){
			way_start.mark()
			tile_start.mark()
			local start_wt = way_start.get_waytype()
			if(start_wt != wt) {
				tile_start.mark()
				return {c = coora, result = false}
			}
			local start_name = way_start.get_name()
			for(local j = 0;j<name_list.len();j++){
				if(start_name == name_list[j]) {
					break
				}
				if(j == name_list.len()-1) {
					tile_start.mark()
					return {c = coora, result = false}
				}
			}

			local dir_start = dir? dir : way_start.get_dirs()
			switch (dir_start) {
				case 1:  //y--
					coora.y--
				break
				case 2:  //x++
					coora.x++
				break
				case 4:  //y++
					coora.y++
				break
				case 8:  //x--
					coora.x--
				break
				default:
					if(coora.x >= coorb.x && coora.y == coorb.y){
						coora.x--
						dir_start = 8
					}
					else if(coora.x <= coorb.x && coora.y == coorb.y){
						coora.x++
						dir_start = 2
					}

					else if(coora.x == coorb.x && coora.y >= coorb.y){
						coora.y--
						dir_start = 4
					}
					else if(coora.x == coorb.x && coora.y <= coorb.y){
						coora.y++
						dir_start = 1
					}

				break
			}

			local tile_test =  tile_x(coora.x, coora.y, coora.z)
			local way_test = tile_test.find_object(mo_way)
			if (!way_test){
				return {c = sve_coord, result = false}
			}

			way_start.unmark()
			tile_start.unmark()

			while(true){
				local current_dir = 0
				local tile = tile_x(coora.x, coora.y, coora.z)
				local way = tile.find_object(mo_way)
				if(way){
					way.unmark()
					tile.unmark()

					local current_wt = way.get_waytype()
					if(current_wt != wt){
						way.mark()
						tile.mark()
						return {c = coora, result = false}
					}

					local current_name = way.get_name()
					for(local j = 0;j<name_list.len();j++){
						if(current_name == name_list[j]) {
							break
						}
						if(j == name_list.len()-1) {
							tile_start.mark()
							return {c = coora, result = false}
						}
					}

					current_dir = way.get_dirs()
					local c_z = coora.z -1
					for(local j = c_z;j<=(c_z+2);j++){
						local c_test = square_x(coora.x,coora.y).get_tile_at_height(j)
						local is_tile = true
						try {
							 c_test.is_valid()
						}
						catch(ev) {
							is_tile = false
							//gui.add_message("This faill")
						}
						if(is_tile && c_test.is_valid()){
							local t = tile_x(coora.x, coora.y, coora.z)
							local way = c_test.find_object(mo_way)
							if(t.is_bridge())c_test.z = coora.z

							//gui.add_message(""+coora.y+","+c_test.z+"  - "+way+"")
							if(way){
								coora.z = c_test.z
								break
							}
						}
					}
					
					if(coora.x==coorb.x && coora.y==coorb.y && coora.z==coorb.z){
						return {c = coora, result = true}
					}
					if ((current_dir==1)||(current_dir==2)||(current_dir==4)||(current_dir==8)){
						way.mark()
						tile.mark()
						return {c = coora, result = false}					
					}
					else if(dir_start == 1){ //y--
						switch (current_dir) {
							case 5:
								coora.y--
								dir_start = 1
							break
							case 6:
								coora.x++
								dir_start = 2
							break
							case 12:
								coora.x--
								dir_start = 8
							break
							default:
								coora.y--
							break
						}
					}
					else if(dir_start == 2){ //x++
						switch (current_dir) {
							case 9:
								coora.y--
								dir_start = 1
							break
							case 12: 
								coora.y++
								dir_start = 4
							break
							default:
								coora.x++
							break
						}
					}
					else if(dir_start == 4){ //y++
						switch (current_dir) {
							case 3:
								coora.x++	
								dir_start = 2
							break
							case 12:
								coora.x--
								dir_start = 8
							break
							case 9:
								coora.x--
								dir_start = 8
							break
							default:
								coora.y++
							break
						}
					}
					else if(dir_start == 8){ //x--
						switch (current_dir) {
							case 3:
								coora.y--	
								dir_start = 1					
							break
							case 6:
								coora.y++
								dir_start = 4
							break
							case 12:
								coora.y--
								dir_start = 12
							break
							default:
								coora.x--
							break
						}
					}
				}
				else {
					tile.mark()
					return {c = coora, result = false}
				}
			}
		}
		else {
			tile_start.mark()
			return {c = coora, result = false}
		}
	}

}        // END of class

// END OF FILE
