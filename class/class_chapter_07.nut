/*
 *  class chapter_07
 *
 *
 *  Can NOT be used in network game !
 */


class tutorial.chapter_07 extends basic_chapter
{
	chapter_name  = "Bus networks"
	chapter_coord = coord(91,144)
	startcash     = 500000	   				// pl=0 startcash; 0=no reset
	load = 0

	compass_nr = 0

	cty1 = {c = coord(88,143), name = ""}
	c_cty_lim1 = {a = coord(0,0), b = coord(0,0)}

	cty2 = {c = coord(92,169), name = ""}
	c_cty_lim2 = {a = coord(0,0), b = coord(0,0)}

	cty3 = {c = coord(102,208), name = ""}
	c_cty_lim3 = {a = coord(0,0), b = coord(0,0)}

	// Step 1
    goal_lod1 = 20
	st1_c = tile_x(92,145,7)
	stop1 = tile_x(91,144,7)

	// Step 2
	goal_lod2 = 40
	st2_c = tile_x(92,169,7)
	stop2 = tile_x(93,171,9)

	// Step 3
	goal_lod3 = 80
	st3_c = tile_x(92,209,7)
	stop3 = tile_x(93,207,9)

	function load_limits(city)  //Load all limits for citys
	{
		local list = []
		local c_nw = city.get_pos_nw()
		local c_se = city.get_pos_se()

		list.push({a = c_nw, b = c_se})											// N
		list.push({a =  coord(c_nw.x, c_se.y), b = coord(c_se.x, c_nw.y)})		// W
		list.push({a = c_se, b = c_nw})											// S
		list.push({a =  coord(c_se.x, c_nw.y), b = coord(c_nw.x, c_se.y)})		// E

		return list
	}

	function start_chapter()  //Inicia solo una vez por capitulo
	{
		rules.clear()
		set_all_rules(0)

		cty1.name = get_city_name(cty1.c)
		local cty_buil1 = my_tile(cty1.c).find_object(mo_building).get_city()
		c_cty_lim1 = load_limits(cty_buil1)

		cty2.name = get_city_name(cty2.c)
		local cty_buil2 = my_tile(cty2.c).find_object(mo_building).get_city()
		c_cty_lim2 = load_limits(cty_buil2)

		cty3.name = get_city_name(cty3.c)
		local cty_buil3 = my_tile(cty3.c).find_object(mo_building).get_city()
		c_cty_lim3 = load_limits(cty_buil3)

		compass_nr = my_compass()

		/*
		//Debug ---------------------------------------------------------------
		local opt = 0
		local del = false
		local text = "X"
		local nr = my_compass()

		my_tile(c_cty_lim1[nr].a).mark()
		my_tile(c_cty_lim1[nr].b).mark()

		label_bord(c_cty_lim1[nr].a, c_cty_lim1[nr].b, opt, del, text)
		//---------------------------------------------------------------
		*/

		return 0
	}

	function set_goal_text(text){

		switch (this.step) {
			case 1:
				local t = st1_c
				local halt = t.get_halt()
				text.name = t.href(""+halt.get_name()+" ("+coord3d_to_string(t)+")")+""
				text.city = cty1.c.href(""+cty1.name +" ("+cty1.c.tostring()+")")+""
				text.stop = stop1.href("("+coord3d_to_string(stop1)+")")+""
                text.load = goal_lod1

				break

			case 2:
				local t = st2_c
				local halt = t.get_halt()
				text.name = t.href(""+halt.get_name()+" ("+coord3d_to_string(t)+")")+""
				text.city = cty2.c.href(""+cty2.name +" ("+cty2.c.tostring()+")")+""
				text.stop = stop2.href("("+coord3d_to_string(stop2)+")")+""
                text.load =  goal_lod2
    			break

			case 3:
				local t = st3_c
				local halt = t.get_halt()
				text.name = t.href(""+halt.get_name()+" ("+coord3d_to_string(t)+")")+""
				text.city = cty3.c.href(""+cty3.name +" ("+cty3.c.tostring()+")")+""
				text.stop = stop3.href("("+coord3d_to_string(stop3)+")")+""
                text.load =  goal_lod3
    			break

			case 4:
				break
			}
			text.get_load = load
			return text
	}
	
	function is_chapter_completed(pl) {
		local percentage=0

		switch (this.step) {
			case 1:
                if (!correct_cov)
                   return 0

				if (pot0==0){
					local buld = stop1.find_object(mo_building)
					if(buld){
						local halt = stop1.get_halt()
						if(halt)
							pot0 = 1
						
					}
				}
				else if (pot0==1 && pot1==0){
					local buld = stop1.find_object(mo_building)
					if(buld){
						local halt = stop1.get_halt()
						if(halt){
							if(halt.get_owner().nr==1)
								pot1 = 1
						}
						else
							backward_pot(0)
					}
					else
						backward_pot(0)
				}
				else if (pot1==1 && pot2==0){
					local wt = wt_road
					local good = 0 //Passengers
					local pass = cov_pax(stop1, wt, good)
					load = pass
					if(pass>goal_lod1){
						load = 0
						this.next_step()
					}
				}
				return 5
				break;

			case 2:
                if (!correct_cov)
                   return 0

				if (pot0==0){
					local buld = stop2.find_object(mo_building)
					if(buld){
						local halt = stop2.get_halt()
						if(halt)
							pot0 = 1
						
					}
				}
				else if (pot0==1 && pot1==0){
					local buld = stop2.find_object(mo_building)
					if(buld){
						local halt = stop2.get_halt()
						if(halt){
							if(halt.get_owner().nr==1)
								pot1 = 1
						}
						else
							backward_pot(0)
					}
					else
						backward_pot(0)
				}
				else {
					local wt = wt_road
					local good = 0 //Passengers
					local pass = cov_pax(stop2, wt, good)
					load = pass
					if(pass>goal_lod2){
						load = 0
						this.next_step()
					}
				}
				return 50
				break;

			case 3:
                if (!correct_cov)
                   return 0

				if (pot0==0){
					local buld = stop3.find_object(mo_building)
					if(buld){
						local halt = stop3.get_halt()
						if(halt)
							pot0 = 1
						
					}
				}
				else if (pot0==1 && pot1==0){
					local buld = stop3.find_object(mo_building)
					if(buld){
						local halt = stop3.get_halt()
						if(halt){
							if(halt.get_owner().nr==1)
								pot1 = 1
						}
						else
							backward_pot(0)
					}
					else
						backward_pot(0)
				}
				else {
					local wt = wt_road
					local good = 0 //Passengers
					local pass = cov_pax(stop3, wt, good)
					load = pass
					if(pass>goal_lod3){
						load = 0
						this.next_step()
					}
				}
				return 50
				break;

			case 4:
		        return 90
				break;
			}
			percentage=(this.step-1)+1
			return percentage
	}
	
	function is_work_allowed_here(pl, tool_id, pos) {
		local result=null	// null is equivalent to 'allowed'
		local t = tile_x(pos.x, pos.y, pos.z)
		local way = t.find_object(mo_way)
		local nr = compass_nr
		switch (this.step) {
			case 1:
				if (tool_id==4096)
					return null
			
				if ((pos.x>=c_cty_lim1[nr].a.x-(1))&&(pos.y>=c_cty_lim1[nr].a.y-(1))&&(pos.x<=c_cty_lim1[nr].b.x+(1))&&(pos.y<=c_cty_lim1[nr].b.y+(1))){
					if (way){
						if(pot0==0){
							if(tool_id==4115){
								if(pos.x==stop1.x && pos.y==stop1.y)
									return null
								else
									return translate("Build Stop here:")+ " ("+stop1.tostring()+")."
							}
							else
								return translate("Action not allowed") + " ("+pos.tostring()+")."
						}

						else if(pot0==1 && pot1==0){
							if(tool_id==4128){
								if(pos.x==stop1.x && pos.y==stop1.y)
									return null
								else
									return translate("Click on the stop")+ " ("+stop1.tostring()+")."
							}
							else
								return translate("Action not allowed") + " ("+pos.tostring()+")."
						}

						else {
							if ((tool_id==4110)||(tool_id==4115)||(tool_id==4117)||(tool_id==4097)||(tool_id==4108)||(tool_id==4109))
								return null
							else
								return translate("Action not allowed") +" ("+pos.tostring()+")."
						}
					}
					else if(tool_id==4110 && pot1==1)
						return null
					else
						return translate("You can only use this tool on a road.")
				}
				else
					return translate("You can only use this tool in the city")+ " " + cty1.name.tostring()+" ("+cty1.c.tostring()+")."	
			break;

			case 2:
				if (tool_id==4096)
					return null
			
				if ((pos.x>=c_cty_lim2[nr].a.x-(1))&&(pos.y>=c_cty_lim2[nr].a.y-(1))&&(pos.x<=c_cty_lim2[nr].b.x+(1))&&(pos.y<=c_cty_lim2[nr].b.y+(1))){
					if (way){
						if(pot0==0){
							if(tool_id==4115){
								if(pos.x==stop2.x && pos.y==stop2.y)
									return null
								else
									return translate("Build Stop here:")+ " ("+stop2.tostring()+")."
							}
							else
								return translate("Action not allowed")+" ("+pos.tostring()+")."
						}

						else if(pot0==1 && pot1==0){
							if(tool_id==4128){
								if(pos.x==stop2.x && pos.y==stop2.y)
									return null
								else
									return translate("Click on the stop")+ " ("+stop2.tostring()+")."
							}
							else
								return translate("Action not allowed")+" ("+pos.tostring()+")."
						}

						else {
							if ((tool_id==4110)||(tool_id==4115)||(tool_id==4117)||(tool_id==4097)||(tool_id==4108)||(tool_id==4109))
								return null
							else
								return translate("Action not allowed")+" ("+pos.tostring()+")."
						}
					}
					else if(tool_id==4110 && pot1==1)
						return null
					else
						return translate("You can only use this tool on a road.")
				}
				else
					return translate("You can only use this tool in the city")+cty2.name.tostring()+" ("+cty2.c.tostring()+")."	
			break;

			case 3:
				if (tool_id==4096)
					return null
			
				if ((pos.x>=c_cty_lim3[nr].a.x-(1))&&(pos.y>=c_cty_lim3[nr].a.y-(1))&&(pos.x<=c_cty_lim3[nr].b.x+(1))&&(pos.y<=c_cty_lim3[nr].b.y+(1))){
					if (way){
						if(pot0==0){
							if(tool_id==4115){
								if(pos.x==stop3.x && pos.y==stop3.y)
									return null
								else
									return translate("Build Stop here:")+ " ("+stop3.tostring()+")."
							}
							else
								return translate("Action not allowed")+" ("+pos.tostring()+")."
						}

						else if(pot0==1 && pot1==0){
							if(tool_id==4128){
								if(pos.x==stop3.x && pos.y==stop3.y)
									return null
								else
									return translate("Click on the stop")+ " ("+stop3.tostring()+")."
							}
							else
								return translate("Action not allowed")+" ("+pos.tostring()+")."
						}

						else {
							if ((tool_id==4110)||(tool_id==4115)||(tool_id==4117)||(tool_id==4097)||(tool_id==4108)||(tool_id==4109))
								return null
							else
								return translate("Action not allowed")+" ("+pos.tostring()+")."
						}
					}
					else if(tool_id==4110 && pot1==1)
						return null
					else
						return translate("You can only use this tool on a road.")
				}
				else
					return translate("You can only use this tool in the city")+cty3.name.tostring()+" ("+cty3.c.tostring()+")."	
			break;

			case 4:
				if (tool_id==4096)
					return null
			
				if ((pos.x>=c_cty_lim4[nr].a.x-(1))&&(pos.y>=c_cty_lim4[nr].a.y-(1))&&(pos.x<=c_cty_lim4[nr].b.x+(1))&&(pos.y<=c_cty_lim4[nr].b.y+(1))){
					if (way){
						if(pot0==0){
							if(tool_id==4115){
								if(pos.x==stop4.x && pos.y==stop4.y)
									return null
								else
									return translate("Build Stop here:")+ " ("+stop4.tostring()+")."
							}
							else
								return translate("Action not allowed")+" ("+pos.tostring()+")."
						}

						else if(pot0==1 && pot1==0){
							if(tool_id==4128){
								if(pos.x==stop4.x && pos.y==stop4.y)
									return null
								else
									return translate("Click on the stop")+ " ("+stop4.tostring()+")."
							}
							else
								return translate("Action not allowed")+" ("+pos.tostring()+")."
						}

						else {
							if ((tool_id==4110)||(tool_id==4115)||(tool_id==4117)||(tool_id==4097)||(tool_id==4108)||(tool_id==4109))
								return null
							else
								return translate("Action not allowed")+" ("+pos.tostring()+")."
						}
					}
					else if(tool_id==4110 && pot1==1)
						return null
					else
						return translate("You can only use this tool on a road.")
				}
				else
					return translate("You can only use this tool in the city")+cty4.name.tostring()+" ("+cty4.c.tostring()+")."	
			break;

		}
		if (tool_id==4096)
			return null
		return tool_id
	}
	
	function is_schedule_allowed(pl, schedule) {
		local result=null	// null is equivalent to 'allowed'
		return result
	}

	function is_convoy_allowed(pl, convoy, depot)
	{
		local result=null	// null is equivalent to 'allowed'
		//Check load type
		local good_nr = 0 //Passengers
		local good = convoy.get_goods_catg_index()		
		for(local j=0;j<good.len();j++){
			if(good[j]!=good_nr)
				return translate("The bus must be [Passengers].")
		}
		if (result == null){
			ignore_save[convoy.id] = true  //Ingnora el vehiculo
			return null
        }
		return result = translate("It is not allowed to start vehicles.")
	}

	function script_text()
	{
		return null
	}
	
	function set_all_rules(pl) 
    {
		local forbid = [tool_remove_wayobj, tool_build_way, tool_build_bridge, tool_build_tunnel,tool_build_station,
                       tool_remove_way, tool_build_depot, tool_build_roadsign, tool_build_wayobj]

		foreach(wt in all_waytypes)
			if (wt != wt_road) {
			    foreach (tool_id in forbid)
				    rules.forbid_way_tool(pl, tool_id, wt, "")
			}

		// tool "climate zones" = 4135
		local forbid = [4116, 4136, 4140, 4126, 4103, 4134, 4135, tool_lower_land, tool_raise_land, tool_setslope, tool_build_roadsign,
        tool_restoreslope, tool_plant_tree, tool_set_marker, tool_stop_mover, tool_buy_house, tool_build_wayobj,
        tool_remove_wayobj, tool_build_tunnel, tool_build_transformer, tool_build_bridge, tool_build_way,tool_remove_way]

		foreach (tool_id in forbid)
		    rules.forbid_tool(pl, tool_id)
	}

	
	function is_tool_active(pl, tool_id, wt) {
		local result = true
		return result
	}

	function is_tool_allowed(pl, tool_id, wt){

		local gt_list =	[
							t_icon.rail, t_icon.other, t_icon.slope, t_icon.tram, t_icon.exte, t_icon.plane
							t_icon.narr, t_icon.magl, t_icon.ship, t_icon.wremo, t_icon.gobj, t_icon.rotobj
						]
		foreach (id in gt_list){
			if(id == tool_id)
				return false
		}

		local result = true
		local t_list = [0] // 0 = all tools allowed
		local wt_list = [wt_road, 0] 
		local res = update_tools(t_list, tool_id, wt_list, wt)
		result = res.result
		if(res.ok)  return result
		return result
	}
}        // END of class

// END OF FILE
