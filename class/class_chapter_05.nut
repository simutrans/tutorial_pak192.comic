/*
 *  class chapter_05
 *
 *
 *  Can NOT be used in network game !
 */

class tutorial.chapter_05 extends basic_chapter
{
	chapter_name  = "Industrial Efficiency"
	chapter_coord = coord(61,72)
	startcash     = 500000	   				// pl=0 startcash; 0=no reset

	//Step 2 =====================================================================================
	ch5_cov_lim1 = {a = 0 , b = 0}

	//Step 4 =====================================================================================
	ch5_cov_lim2 = {a = 0 , b = 0}
	ch5_cov_lim3 = {a = 0 , b = 0}

	//Step 4 =====================================================================================
	ch5_cov_lim4 = {a = 0 , b = 0}

	cov_cir = 0
	sch_cov_correct = false

	//Step 1 =====================================================================================
	fab_list =	[
					{c = coord(61,72), name = ""/*auto started*/, c_list = null/*auto started*/},
					{c = coord(115,110), name = ""/*auto started*/, c_list = null/*auto started*/},
					{c = coord(110,71), name = ""/*auto started*/, c_list = null/*auto started*/},
					{c = coord(84,97), name = ""/*auto started*/, c_list = null/*auto started*/}
				]

	//Step 2 =====================================================================================
	//Para la carretera
	//------------------------------------------------------------------------------------------
	c_way_lim1 = {a = coord(63,71), b = coord(82,100)}
	c_way1 = {a = coord3d(63,74,6), b = coord3d(82,96,6), dir = 5}	//Inicio, Fin de la via y direccion(fullway)

	//Limites del deposito y carretera
	//--------------------------------------------------------------------------------------------
	c_dep1_lim = {a = coord(64,73), b = coord(64,74)}
	c_dep1 = coord(64,73)
	
	//Para el Camion
	sch_list1 = [coord(63,74), coord(82,96)]
    veh1_obj = "road_truck_bulk_1965_w50"
	veh1_load = 100
	veh1_wait = 0
	d1_cnr = null //auto started
	f1_good = good_alias.coal

	//Step 3 =====================================================================================
    transf_list = [coord(62,71), coord(115,109), coord(111,76), coord(87,96)]
    f_power = 0
    f_pow_list = [0,0,0,0]

    pow_lim =	[	{a = coord(60,70), b = coord(91,103)}, {a = coord(105,67), b = coord(119,113)},
				 	{a = coord(80,89), b = coord(119,103)}
				]

    label_del =	[
					{a = coord(80,89), b = coord(80,102)}, {a = coord(80,89), b = coord(90,89)},
					{a = coord(91,90), b = coord(91,102)}, {a = coord(105,90), b = coord(105,102)},
					{a = coord(106,89), b = coord(118,89)}, {a = coord(106,103), b = coord(118,103)}
				]

	//Step 4 =====================================================================================
	
	st_name = ""
    obj_list1 = []

	//Para el Camion
    veh2_obj = "road_truck_post_1967_t2"
    c_dep2 = coord(92,65) // depot
	line2_name = "Test 6"
    sch_list2 =	[
					coord(108,72), coord(102,74), coord(96,76), coord(84,96),
					coord(91,75), coord(87,72), coord(91,69), coord(91,64),
					coord(92,56), coord(96,54), coord(99,57), coord(101,52)
				]
	veh2_load = 100
	veh2_wait = 10571
	d2_cnr = null //auto started

	//Para el barco
	sch_list3 = [coord(97,77), coord(127,82)]
    veh3_obj = "Kanalschiff-Post"
	veh3_load = 100
	veh3_wait = 42282
    c_dep3 = coord(119,80) // depot
	d3_cnr = null //auto started

	//Step 5 =====================================================================================
	//Para el Autobus
	sch_list4 =	[coord(103,75), coord(108,72),  coord(96,76), coord(84,96), coord(96,76)]

    veh4_obj = "road_bus_1972_ikarus260"
	line4_name = "Test 7"
	veh4_load = 100
	veh4_wait = 10571
	d4_cnr = null //auto started

	//Script
	//----------------------------------------------------------------------------------
	sc_way_name = "asphalt_road"
	sc_st_name1 = "freightstation_end_new"
	sc_dep_name = "depot_road"
	sc_trail_name = "road_trailer_bulk_1965_w50"
	sc_trail_nr = 1

	sc_brid_c = {a = coord3d(71,81,6), b = coord3d(71,83,6)}
	sc_bridge_name = "road_bridge_city"

	sc_tran_list = 	[
						{a = coord3d(62,71,6) , b = coord3d(87,96,7)},
						{a = coord3d(115,109,1) , b = coord3d(87,96,7)},
						{a = coord3d(115,109,1) , b = coord3d(111,76,-1)}
					]
	sc_power_name = "Stromleitung"
	sc_transf_name = "Aufspanntransformator"

	sc_st_name2 = "road_busstop1947small_post"

	function start_chapter()  //Inicia solo una vez por capitulo
	{
		rules.clear()
		set_all_rules(0)
		local lim_idx = cv_list[(persistent.chapter - 2)].idx
		ch5_cov_lim1 = {a = cv_lim[lim_idx].a, b = cv_lim[lim_idx].b}
		ch5_cov_lim2 = {a = cv_lim[lim_idx+1].a, b = cv_lim[lim_idx+1].b}
		ch5_cov_lim3 = {a = cv_lim[lim_idx+2].a, b = cv_lim[lim_idx+2].b}
		ch5_cov_lim4 = {a = cv_lim[lim_idx+3].a, b = cv_lim[lim_idx+3].b}

		d1_cnr = get_dep_cov_nr(ch5_cov_lim1.a,ch5_cov_lim1.b)
		d2_cnr = get_dep_cov_nr(ch5_cov_lim2.a,ch5_cov_lim2.b)
		d3_cnr = get_dep_cov_nr(ch5_cov_lim3.a,ch5_cov_lim3.b)
		d4_cnr = get_dep_cov_nr(ch5_cov_lim4.a,ch5_cov_lim4.b)

		//Step 4 =====================================================================================
		// Get extension_postoffice Name -----------------------------------
		local siz = coord(1,1)  //siz = null for all build siz
		local desc = building_desc_x.station_extension
		local freight = good_alias.mail
		local wt = wt_all
		st_name = get_build_name(siz, desc, freight, wt)
		//-------------------------------------------------------------------
		
		obj_list1 = [
						{c = coord(87,71), name = st_name, good = good_alias.mail},
						{c = coord(91,70), name = st_name, good = good_alias.mail}, 
						{c = coord(97,76), name = st_name, good = good_alias.mail},
						{c = coord(91,76), name = st_name, good = good_alias.mail},
						{c = coord(91,65), name = st_name, good = good_alias.mail},
						{c = coord(91,55), name = st_name, good = good_alias.mail}, 
						{c = coord(99,58), name = st_name, good = good_alias.mail},
						{c = coord(95,54), name = st_name, good = good_alias.mail}, 
						{c = coord(102,52), name = st_name, good = good_alias.mail},
						{c = coord(108,72), name = "", good = [good_alias.mail, good_alias.passa]},
						{c = coord(103,75), name = "", good = [good_alias.passa]},
						{c = coord(102,74), name = "", good = [good_alias.mail]},
						{c = coord(84,96), name = "", good = [good_alias.mail, good_alias.passa]}
					]
		//===============================================================================================
		
		local list = fab_list
		for(local j = 0; j<list.len(); j++){
			local t = my_tile(list[j].c)
			local buil = t.find_object(mo_building)
			if(buil){
				fab_list[j].c_list = buil.get_tile_list()
				fab_list[j].name = translate(buil.get_name())
				local fields = buil.get_factory().get_fields_list()
				foreach(t in fields){
					fab_list[j].c_list.push(t)
				}
			}
			else{
				gui.add_message("Error aqui: ")
				break
			}
		}
		local pl = 0
		if(this.step == 4){
			//Camion de correo
            local c_dep = this.my_tile(c_dep2)
			local c_list = sch_list2
			start_sch_tmpsw(pl,c_dep, c_list)

			//Barco de Correo/Pasajeros
            c_dep = this.my_tile(c_dep3)
			c_list = sch_list3
			start_sch_tmpsw(pl,c_dep, c_list)
		}
		return 0
	}

	function set_goal_text(text)
	{
		local ok_tx =  translate("Ok")
		local trf_name = translate("Build drain")    //Aufspanntransformator 
		local toolbar = translate("BUILDINGS")
		
		switch (this.step) {
			case 1:
				break
			case 2:
				local c_w1 = coord(c_way1.a.x, c_way1.a.y)
				local c_w2 = coord(c_way1.b.x, c_way1.b.y)

				text.w1 = c_w1.href("("+c_w1.tostring()+")")
				text.w2 = c_w2.href("("+c_w2.tostring()+")")

				text.dep = c_dep1.href("("+c_dep1.tostring()+")")
				text.veh = translate(veh1_obj)
				text.good = translate(f1_good)
				text.all_cov = d1_cnr
				text.cir = cov_cir
				text.load = veh1_load
				text.wait = get_wait_time_text(veh1_wait)
				break
			case 3:
				if (pot0==0){
					text = ttextfile("chapter_05/03_1-2.txt")
					text.tx="<em>[1/2]</em>"
					text.trf_name = trf_name 
					text.toolbar = toolbar

					local tran_tx = ""
					for(local j=0;j<transf_list.len();j++){
						if (glsw[j]==0){
							tran_tx +=format("<st>%s %d</st> ", trf_name, j+1) + transf_list[j].href("("+transf_list[j].tostring()+")") + "<br/>" 
						}
						else {
							tran_tx +=format("<em>%s %d</em> ",trf_name ,j+1)+"("+transf_list[j].tostring()+") <em>"+ok_tx+"</em><br/>" 
						}
					}
					text.tran = tran_tx
				}
				else if (pot0==1 && pot1==0){
					text = ttextfile("chapter_05/03_2-2.txt")
					text.tx="<em>[2/2]</em>"
					text.powerline_tool = translate("Powerline")
					text.toolbar = toolbar

					local tran_tx = ""
					local f_list = fab_list
					for(local j=0;j<f_list.len();j++){
						if (glsw[j]==0){
							tran_tx +=format("<st>%s</st> ",translate(f_list[j].name)) + f_list[j].c.href("("+f_list[j].c.tostring()+")") + "<br/>" 
						}
						else{
							tran_tx +=format("<em>%s</em> ",translate(f_list[j].name)) + "("+f_list[j].c.tostring()+") <em>"+translate("OK")+"</em><br/>" 
						}
					}
					f_power = f_power + f_pow_list[0] + f_pow_list[1] + f_pow_list[2] 
					text.pow = f_power
					text.tran = tran_tx
				}
				break
			case 4:
				if (pot0==1 && pot1==0){
					text = ttextfile("chapter_05/04_1-3.txt")
					text.tx="<em>[1/3]</em>"
					text.toolbar = toolbar
					local st_tx = ""
					local list = obj_list1  //Lista de build
					local siz = list.len()
					for(local j=0;j<siz;j++){
						local name = list[j].name == ""? get_good_text(list[j].good) : translate(list[j].name)
						if (glsw[j]==0){
							st_tx +=format("<st>%d %s</st> ", j+1, name) + list[j].c.href("("+list[j].c.tostring()+")")+"<br/>" 
						}
						else {
							st_tx +=format("<em>%d %s</em> ", j+1, name)+"("+list[j].c.tostring()+")<em>"+ok_tx+"</em><br/>" 
						}
					}
					text.st = st_tx
				}
				else if (pot1==1 && pot2==0 || (current_cov> ch5_cov_lim2.a && current_cov< ch5_cov_lim2.b)){
					text = ttextfile("chapter_05/04_2-3.txt")
					text.tx = "<em>[2/3]</em>"
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
						if(tmpsw[j]==0){
							list_tx += format("<st>%s %d:</st> %s<br>", translate("Stop"), j+1, c.href(st_halt.get_name()+" ("+c.tostring()+")"))
						}
						else{						
							list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
						}
					}
					local c = coord(c_list[0].x, c_list[0].y)
					local tile = my_tile(c)
					text.stnam = "1) "+tile.get_halt().get_name()+" ("+c.tostring()+")"

					text.list = list_tx
					text.dep = c_dep2.href("("+c_dep2.tostring()+")")
					text.veh = translate(veh2_obj)
					text.all_cov = d2_cnr
					text.cir = cov_cir
					text.load = veh2_load
					text.wait = get_wait_time_text(veh2_wait)
					text.nr = siz
				}
				else if (pot2==1 && pot3==0 || (current_cov> ch5_cov_lim3.a && current_cov< ch5_cov_lim3.b)){
					text = ttextfile("chapter_05/04_3-3.txt")
					text.tx = "<em>[3/3]</em>"
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
						if(tmpsw[j]==0){
							list_tx += format("<st>%s %d:</st> %s<br>", translate("Stop"), j+1, c.href(st_halt.get_name()+" ("+c.tostring()+")"))
						}
						else{						
							list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
						}
					}
					local c = coord(c_list[0].x, c_list[0].y)
					local tile = my_tile(c)
					text.stnam = "1) "+tile.get_halt().get_name()+" ("+c.tostring()+")"

					text.list = list_tx
					text.dep = c_dep3.href("("+c_dep3.tostring()+")")
					text.ship = translate(veh3_obj)
					text.load = veh3_load
					text.wait = get_wait_time_text(veh3_wait)
					text.nr = siz
				}
				break
			case 5:
				local list_tx = ""
				local c_list = sch_list4
				local siz = c_list.len()
				for (local j=0;j<siz;j++){
					local c = coord(c_list[j].x, c_list[j].y)
					local tile = my_tile(c)
					local st_halt = tile.get_halt()
					if(sch_cov_correct){
						list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
						continue
					}
					if(tmpsw[j]==0){
						list_tx += format("<st>%s %d:</st> %s<br>", translate("Stop"), j+1, c.href(st_halt.get_name()+" ("+c.tostring()+")"))
					}
					else{						
						list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
					}
				}
				local c = coord(c_list[0].x, c_list[0].y)
				local tile = my_tile(c)
				text.stnam = "1) "+tile.get_halt().get_name()+" ("+c.tostring()+")"

				text.list = list_tx
				text.dep = c_dep2.href("("+c_dep2.tostring()+")")
				text.veh = translate(veh4_obj)
				text.all_cov = d4_cnr
				text.cir = cov_cir
				text.load = veh4_load
				text.wait = get_wait_time_text(veh4_wait)
				text.nr = siz
				break
			case 6:
				break
	    }
        text.f1 = fab_list[0].c.href(""+translate(fab_list[0].name)+" ("+fab_list[0].c.tostring()+")")+""
	    text.f2 = fab_list[1].c.href(""+translate(fab_list[1].name)+" ("+fab_list[1].c.tostring()+")")+""
	    text.f3 = fab_list[2].c.href(""+translate(fab_list[2].name)+" ("+fab_list[2].c.tostring()+")")+""
	    text.f4 = fab_list[3].c.href(""+translate(fab_list[3].name)+" ("+fab_list[3].c.tostring()+")")+""

		text.tool1 = tool_alias.inspe
		text.tool2 = tool_alias.road
		text.tool3 = tool_alias.spec

	    return text
	}
	
	function is_chapter_completed(pl) {
		local percentage=0
		save_glsw()
		save_pot()
		switch (this.step) {
			case 1:
				if(pot0==1){
					//Creea un cuadro label
					local opt = 0
					local del = false
					local text = "X"
					label_bord(c_way_lim1.a, c_way_lim1.b, opt, del, text)	

					this.next_step()
				}
				return 0
			break;
			case 2:
				if (pot0==0){
					local coora = coord3d(c_way1.a.x,c_way1.a.y,c_way1.a.z)
					local coorb = coord3d(c_way1.b.x,c_way1.b.y,c_way1.b.z)

					local t_start = tile_x(coora.x,coora.y,coora.z)
					local t_end = tile_x(coorb.x,coorb.y,coorb.z)

					if(!t_start.find_object(mo_way)){
						local label = t_start.find_object(mo_label)
						if(label.get_text()== "X")
							t_start.remove_object(player_x(1), mo_label)

						label_x.create(t_start, player_x(pl), translate("Place the Road here!."))
					}
					else t_start.remove_object(player_x(1), mo_label)

					if(!t_end.find_object(mo_way)){
						local label = t_end.find_object(mo_label)
						if(label.get_text()== "X")
							t_end.remove_object(player_x(1), mo_label)

						label_x.create(t_end, player_x(pl), translate("Place the Road here!."))
					}
					else t_end.remove_object(player_x(1), mo_label)

					//Comprueba la conexion de la via
					local obj = false
					local dir = c_way1.dir		
					local r_way = get_fullway(coora, coorb, dir, obj)

					if (r_way.r){
						//elimina el cuadro label
						local opt = 0
						local del = true
						local text = "X"
						label_bord(c_way_lim1.a, c_way_lim1.b, opt, del, text)

						pot0=1
						return 10
					}
				}
				else if (pot0==1 && pot1==0){
					local siz = sch_list1.len()
					local c_list = sch_list1
					local name =  translate("Place Stop here!.")
					local load = good_alias.goods
					local all_stop = is_stop_building(siz, c_list, name, load)
					if (all_stop){
						reset_glsw()
						pot1=1
					}
				}
				else if (pot1==1 && pot2==0){
					local tile = my_tile(c_dep1_lim.a)
					if(!tile.find_object(mo_way)){
						label_x.create(tile, player_x(pl), translate("Place the Road here!."))
					}
					else {
						if (!tile.find_object(mo_depot_road)){
							local lab = tile.find_object(mo_label)
							if(lab) lab.set_text(translate("Build a Depot here!."))
						}
						else{
							tile.remove_object(player_x(1), mo_label)
							pot2=1
						}	
					}
				}
				else if (pot2==1 && pot3==0){
					cov_cir = get_convoy_nr((ch5_cov_lim1.a), d1_cnr)

					if (cov_cir == d1_cnr){
						this.next_step()
						return 15
					}
				}
				return 0
			break;
			case 3:
                if (pot0==0){
					local transf_count = 0
                    for(local j=0;j<transf_list.len();j++){
                        local tile = my_tile(transf_list[j])
                        local f_transfc = tile.find_object(mo_transformer_c)
                        local f_transfs = tile.find_object(mo_transformer_s)
                        if (f_transfc || f_transfs){
							tile.remove_object(player_x(1), mo_label)
                            glsw[j]=1
							transf_count++
                        }
                        else
                            label_x.create(tile, player_x(pl), translate("Transformer Here!."))
                    }
					if(transf_count == transf_list.len()){
                        pot0 = 1
						reset_glsw()

						//Crear cuadro label para las power line
						local opt = 0
                        local del = false
						for(local j = 0;j<pow_lim.len();j++){
							label_bord(pow_lim[j].a, pow_lim[j].b, opt, del, "X")
						}
                        //Elimina cudro label
                        del = true
						for(local j = 0;j<label_del.len();j++){
							label_bord(label_del[j].a, label_del[j].b, opt, del, "X")
						}
                        return 20
                    }  
                }
                else if (pot0==1 && pot1 == 0){
					local f_list = fab_list
					local f_tile_t = my_tile(transf_list[3])
					local f_transf = f_tile_t.find_object(mo_transformer_s)
					for(local j=0;j<f_list.len();j++){
						local tile = my_tile(f_list[j].c)
						local factory = tile.find_object(mo_building).get_factory()
						if (factory){
						    if(script_test && factory.is_transformer_connected()){
						        local transf = factory.get_transformer()
						        if (transf.is_connected(f_transf)){
									glsw[j] = 1
						        }
						    }
						}  
					}
					if (glsw[0] == 1 && glsw[1] == 1 && glsw[2] == 1){
						//Elimina cuadro label para las power line
						local opt = 0
						local del = true

						for(local j = 0;j<pow_lim.len();j++){
							label_bord(pow_lim[j].a, pow_lim[j].b, opt, del, "X")
						}

						this.next_step()
						return 30
					}
				}
				return 0
			break;
			case 4:
				if (pot0==0){
                    local player = player_x(1)
                    local list = obj_list1
                    local obj = mo_building
                    local station = false
                    local lab_name = translate("Mail Extension Here!.")

                    delete_objet(player, list, obj, lab_name, station)
                    pot0=1  
				}
				if (pot0==1 && pot1==0){
				    local list = obj_list1
					local nr = list.len()
                    local lab_name = translate("Mail Extension Here!.")
				    local all_stop = is_stop_building_ex(nr, list, lab_name)
				    if (all_stop && pot1==0){
					    pot1=1
					    reset_glsw()
				    }
                }
				if (pot1==1 && pot2==0){
				    local c_dep = this.my_tile(c_dep2)
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

					cov_cir = get_convoy_nr((ch5_cov_lim2.a), d2_cnr)
					if (current_cov >= ch5_cov_lim2.b){
						sch_cov_correct = false
						pot2=1
					}
                }
				if (pot2==1 && pot3==0){
				    local c_dep = this.my_tile(c_dep3)
					local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
					local cov_list = depot.get_convoy_list()		//Lista de vehiculos en el deposito
					local convoy = convoy_x(gcov_id)
					if (cov_list.len()>=1){
						convoy = cov_list[0]
					}
					local all_result = checks_convoy_schedule(convoy, pl)
					sch_cov_correct = all_result.res == null ? true : false

					if (current_cov >= ch5_cov_lim3.b){
						sch_cov_correct = false
						this.next_step()
					}
				}
				return 10+percentage
				break
			case 5:

			    local c_dep = this.my_tile(c_dep2)
                local line_name = line4_name
                set_convoy_schedule(pl, c_dep, wt_road, line_name)

				local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
				local cov_list = depot.get_convoy_list()		//Lista de vehiculos en el deposito
				local convoy = convoy_x(gcov_id)
				if (cov_list.len()>=1){
					convoy = cov_list[0]
				}
				local all_result = checks_convoy_schedule(convoy, pl)
				sch_cov_correct = all_result.res == null ? true : false

				cov_cir = get_convoy_nr((ch5_cov_lim4.a), d4_cnr)
				if (current_cov >= ch5_cov_lim4.b){
					sch_cov_correct = false
					this.next_step()
				}

				return 90
				break

			case 6:
				this.step=1
				persistent.step =1
				persistent.status.step = 1
				return 100
				break
		}
		percentage=(this.step-1)+1
		return percentage
	}
	
	function is_work_allowed_here(pl, tool_id, pos) {
        //return tool_id
		glpos = coord3d(pos.x, pos.y, pos.z)
		local t = tile_x(pos.x, pos.y, pos.z)
		local ribi = 0
		local wt = 0
		local slope = t.get_slope()
		local way = t.find_object(mo_way)
        local powerline = t.find_object(mo_powerline)
		local bridge = t.find_object(mo_bridge)
		local label = t.find_object(mo_label)
		local building = t.find_object(mo_building)
		if(building){
			/*local fact = building.get_factory().get_desc()
			local input_list = fact.get_inputs()
			foreach(input in input_list){
				local good = input.good
				gui.add_message(""+good.get_name())
			}*/
		}
		local sign = t.find_object(mo_signal)
		local roadsign = t.find_object(mo_roadsign)
		/*if (way){
			wt = way.get_waytype()
			if (tool_id!=4111)
				ribi = way.get_dirs()
			if (!t.has_way(gl_wt))
				ribi = 0
		}*/
		local result = translate("Action not allowed")		// null is equivalent to 'allowed'
		switch (this.step) {
			case 1:
				if (tool_id == 4096){
					local list = fab_list
					for(local j = 0; j<list.len(); j++){
						local t_list = fab_list[j].c_list
						foreach(t in t_list){
							if(pos.x == t.x && pos.y == t.y){
								pot0=1
							}
						}				
					}
				}
				else
					result = translate("You must use the inspection tool")+" ("+pos.tostring()+")."				
				break;
			case 2:
				if(pot0==0){
					if(pos.x>=c_way_lim1.a.x && pos.y>=c_way_lim1.a.y && pos.x<=c_way_lim1.b.x && pos.y<=c_way_lim1.b.y){
						if (!way && label && label.get_text()=="X"){
							return translate("Indicates the limits for using construction tools")+" ( "+pos.tostring()+")."	
						}
						local label = tile_x(r_way.c.x, r_way.c.y, r_way.c.z).find_object(mo_label)
						if(label){
							if(tool_id==tool_build_way || tool_id==4113 || tool_id==tool_remover)
								return null	
						}
						else return all_control(result, wt_road, way, ribi, tool_id, pos, r_way.c)
					}
				}
				else if(pot0==1 && pot1==0){
                    for(local j=0;j<sch_list1.len();j++){
                       if(pos.x==sch_list1[j].x && pos.y==sch_list1[j].y){
							if(tool_id==tool_build_station || tool_id==tool_remover){
								way.unmark()
								local c_list = sch_list1
								local good = good_alias.goods
								return is_station_truck_build(pos, tool_id, c_list, good)
							}
						}
					}
				}
				else if(pot1==1 && pot2==0){
					if(pos.x>=c_dep1_lim.a.x && pos.y>=c_dep1_lim.a.y && pos.x<=c_dep1_lim.b.x && pos.y<=c_dep1_lim.b.y){
						if(tool_id==tool_build_way || tool_id==tool_build_depot){
							return null
						}
					}
				}
				else if(pot2==1 && pot3==0){
					if (tool_id==4108) {
						local c_list = sch_list1	//Lista de todas las paradas
						local c_dep = c_dep1		//Coordeadas del deposito 
						local nr = c_list.len()		//Numero de paradas 
						result = translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep.tostring()+")."
						return is_stop_allowed(result, nr, c_list, pos)
					}
				}
			break;

			//Conectando los transformadores
			case 3:
                if (pot0==0){
                    for(local j=0;j<transf_list.len();j++){
                        if(tool_id == tool_build_transformer){
                            local f_transf = t.find_object(mo_transformer_c)
                            if (pos.x==transf_list[j].x && pos.y==transf_list[j].y){
                                if (glsw[j]==0){
                                   return null
                                }
                                else return  translate("There is already a transformer here!")+" ("+pos.tostring()+")."
                            }
                            else if (glsw[j]==0) result = translate("Build the transformer here!")+" ("+transf_list[j].tostring()+")."
                        }
                    }
                    if(tool_id == tool_build_transformer)
                        return result
                }
                else if (pot0==1 && pot1 == 0){
                    for(local j=0;j<pow_lim.len();j++){
                       if(pos.x>=pow_lim[j].a.x && pos.y>=pow_lim[j].a.y && pos.x<=pow_lim[j].b.x && pos.y<=pow_lim[j].b.y){
                                           
                            if(tool_id == tool_build_way || tool_id == tool_build_bridge || tool_id == tool_build_tunnel){
                               if (label && label.get_text()=="X")
						        return translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."	
                                else
                                    return null

                                 return result
                            }
                            else if (tool_id == tool_remover || tool_id == tool_remove_way){
                                if (building && !t.get_halt())
                                    return null

                                else if (powerline)
                                    return null

                                return result
                            }
                       }
                       else if (j== pow_lim.len()-1){
                            result = translate("You are outside the allowed limits!")+" ("+pos.tostring()+")."
                       }
                    }
                   if(tool_id == tool_build_way)
                       return result
                   
                }
				break
			case 4:
                if (pot0==1 && pot1==0){
                    //Permite construir paradas
					if (tool_id==tool_build_station){
						local list = obj_list1
						local nr = list.len()
						return build_stop_ex(nr, list, t)
					}
					
					//Permite eliminar paradas
					if (tool_id==4097){
						local list = obj_list1
						local nr = list.len()
						return delete_stop_ex(nr, list, pos)
					}
                }
                if (pot1==1 && pot2==0){
					if (tool_id==4108) {			
						local c_list = sch_list2  	//Lista de todas las paradas de autobus
						local c_dep = c_dep2 		//Coordeadas del deposito 
						local nr = c_list.len()		//Numero de paradas 
						result = translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep.tostring()+")."
						return is_stop_allowed(result, nr, c_list, pos)
					}
                }
                if (pot2==1 && pot3==0){
					if (tool_id==4108) {			
						local c_list = sch_list3 	 //Lista de todas las paradas de autobus
						local c_dep = c_dep3		 //Coordeadas del deposito 
						local siz = c_list.len()	 //Numero de paradas 
						local wt = wt_water
						result = translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep.tostring()+")."
						return is_stop_allowed_ex(result, siz, c_list, pos, wt)	
					}
                }
			break
			case 5:

				if (tool_id==4108) {			
					local c_list = sch_list4  	//Lista de todas las paradas de autobus
					local c_dep = c_dep2		//Coordeadas del deposito 
					local nr = c_list.len()		//Numero de paradas 
					result = translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep.tostring()+")."
					return is_stop_allowed(result, nr, c_list, pos)
				}
                
			break

		}
		if (tool_id == 4096){
			if (label && label.get_text()=="X")
				return translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."		
			else if (label)	
				return translate("Text label")+" ("+pos.tostring()+")."
			result = null	// Always allow query tool
		}
		if (label && label.get_text()=="X")
			return translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."	

		return result	
	}
	
	function is_schedule_allowed(pl, schedule) {
		local result=null	// null is equivalent to 'allowed'
		if ( (pl == 0) && (schedule.waytype != wt_road) )
			result = translate("Only road schedules allowed")

		local nr = schedule.entries.len()

		switch (this.step) {
			case 2:
				local selc = 0
				local load = veh1_load
				local time = veh1_wait
				local c_list = sch_list1
				local siz = c_list.len()
				result = set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz)
				if(result != null) reset_tmpsw()
				return result
			break
			case 4:
				if (current_cov> ch5_cov_lim2.a && current_cov< ch5_cov_lim2.b){
					local selc = 0
					local load = veh2_load
					local time = veh2_wait
					local c_list = sch_list2
					local siz = c_list.len()
					local line = true
					result = set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz, line)
					if(result == null){
						local line_name = line2_name
						update_convoy_schedule(pl, wt_road, line_name, schedule)
					}
				}
				else if (current_cov> ch5_cov_lim3.a && current_cov< ch5_cov_lim3.b){
					local selc = 0
					local load = veh3_load
					local time = veh3_wait
					local c_list = sch_list3
					local siz = c_list.len()
					result = set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz)
				}
				return result
			break
			case 5:
				if (current_cov> ch5_cov_lim4.a && current_cov< ch5_cov_lim4.b){
					local selc = 0
					local load = veh4_load
					local time = veh4_wait
					local c_list = sch_list4
					local siz = c_list.len()
					local line = true
					result = set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz, line)
					if(result == null){
						local line_name = line4_name
						update_convoy_schedule(pl, wt_road, line_name, schedule)
					}
				}
			break
		}
		return result
	}
	function is_convoy_allowed(pl, convoy, depot)
	{
		local result=null	// null is equivalent to 'allowed'

		switch (this.step) {
			case 2:
				local cov = d1_cnr
				local veh = 2
				local good_list = [good_desc_x(f1_good).get_catg_index()] 	 //Coal
				local name = veh1_obj
				local st_tile = 1

				//Para arracar varios vehiculos
				local id_start = ch5_cov_lim1.a
				local id_end = ch5_cov_lim1.b
				local c_sch = sch_list1[0]
				local cir_nr = get_convoy_number_exp(c_sch, depot, id_start, id_end)
				cov -= cir_nr

				result = is_convoy_correct(depot, cov, veh, good_list, name, st_tile)

				if (result!=null){
					reset_tmpsw()
					local good = translate(f1_good)
					return truck_result_message(result, translate(name), good, veh, cov)
				}
				if (current_cov> ch5_cov_lim1.a && current_cov< ch5_cov_lim1.b){
					local selc = 0
					local load = veh1_load
					local time = veh1_wait
					local c_list = sch_list1
					local siz = c_list.len()
					return set_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
				}
			break
			case 4:
				if (current_cov> ch5_cov_lim2.a && current_cov< ch5_cov_lim2.b){
					local cov = d2_cnr
					local veh = 1
					local good_list = [good_desc_x(good_alias.mail).get_catg_index()] 	 //Mail
					local name = veh2_obj
					local st_tile = 1

					//Para arracar varios vehiculos
					local id_start = ch5_cov_lim2.a
					local id_end = ch5_cov_lim2.b
					local c_sch = sch_list2[0]
					local cir_nr = get_convoy_number_exp(c_sch, depot, id_start, id_end)
					cov -= cir_nr

					result = is_convoy_correct(depot, cov, veh, good_list, name, st_tile)

					if (result!=null){
						local good = translate(good_alias.mail)
						return truck_result_message(result, translate(name), good, veh, cov)
					}
					local selc = 0
					local load = veh2_load
					local time = veh2_wait
					local c_list = sch_list2
					local siz = c_list.len()
					return set_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
				}

				else if (current_cov> ch5_cov_lim3.a && current_cov< ch5_cov_lim3.b){
					local cov = d3_cnr
					local veh = 1
					local good_list = [good_desc_x(good_alias.mail).get_catg_index()] 	 //Mail
					local name = veh3_obj
					local st_tile = 1
					result = is_convoy_correct(depot, cov, veh, good_list, name, st_tile)

					if (result!=null){
						local good = translate(good_alias.mail)
						return ship_result_message(result, translate(name), good, veh, cov)
					}
					local selc = 0
					local load = veh3_load
					local time = veh3_wait
					local c_list = sch_list3
					local siz = c_list.len()
					return set_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
				}
			break
			case 5:
				if (current_cov> ch5_cov_lim4.a && current_cov< ch5_cov_lim4.b){
					local cov = d4_cnr
					local veh = 1
					local good_list = [good_desc_x(good_alias.passa).get_catg_index()] 	 //Mail
					local name = veh4_obj
					local st_tile = 1

					//Para arracar varios vehiculos
					local id_start = ch5_cov_lim4.a
					local id_end = ch5_cov_lim4.b
					local c_sch = sch_list4[0]
					local cir_nr = get_convoy_number_exp(c_sch, depot, id_start, id_end)
					cov -= cir_nr

					result = is_convoy_correct(depot, cov, veh, good_list, name, st_tile)

					if (result!=null){
						local good = translate(good_alias.passa)
						return truck_result_message(result, translate(name), good, veh, cov)
					}
					local selc = 0
					local load = veh4_load
					local time = veh4_wait
					local c_list = sch_list4
					local siz = c_list.len()
					return set_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
				}
		}
		return result = translate("It is not allowed to start vehicles.")
	}

	function script_text()
	{
		local pl = 0
		switch (this.step) {
			case 1:
				if(pot0==0) pot0=1

				return null
			break;
			case 2:
				if (pot0==0){
					local coora = c_way1.a
					local coorb = c_way1.b

					local t = command_x(tool_build_way)			
					t.work(player_x(pl), coora, sc_brid_c.a, sc_way_name)
					t.work(player_x(pl), sc_brid_c.b, coorb, sc_way_name)

					t = command_x(tool_build_bridge)
					t.set_flags(2)
					t.work(player_x(pl), sc_brid_c.a, sc_brid_c.b, sc_bridge_name)

				}
				if (pot2==0){

					//Para la carretera
					local t_start = my_tile(c_dep1_lim.a)
					local t_end = my_tile(c_dep1_lim.b)
					t_start.remove_object(player_x(1), mo_label)
					local t = command_x(tool_build_way)

					local err = t.work(player_x(pl), t_start, t_end, sc_way_name)

					t = command_x(tool_build_depot)			
					t.work(player_x(pl), t_start, sc_dep_name)
				}

				if (pot1==0){
					for(local j=0;j<sch_list1.len();j++){
						local tile = my_tile(sch_list1[j])
						local way = tile.find_object(mo_way)
						tile.remove_object(player_x(1), mo_label)
						local tool = command_x(tool_build_station)			
						local err = tool.work(player_x(pl), tile, sc_st_name1)
					}
				}

				if (current_cov> ch5_cov_lim1.a && current_cov< ch5_cov_lim1.b){

					local player = player_x(pl)
					local c_depot = my_tile(c_dep1)

					try {
						comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito
					}
					catch(ev) {
						return null
					}

					local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
					local good_nr = good_desc_x(f1_good).get_catg_index()  //Coal
					local sched = schedule_x(wt_road, [])
					sched.entries.append(schedule_entry_x(my_tile(sch_list1[0]), veh1_load, veh1_wait))
					sched.entries.append(schedule_entry_x(my_tile(sch_list1[1]), 0, 0))
					local c_line = comm_get_line(player, wt_road, sched)

					local name = veh1_obj
					local cov_nr = d1_cnr  //Max convoys nr in depot
					local extender_name = sc_trail_name
					local siz = sc_trail_nr
					local extender = true
					for (local j = 0; j<(cov_nr); j++){
						if (!comm_set_convoy(cov_nr, c_depot, name))
							return 0
						for (local count = 0;count<siz;count++){
							if (!comm_set_convoy(j, c_depot, extender_name, extender))
								return 0
						}
						local conv = depot.get_convoy_list()
						conv[j].set_line(player, c_line)
					}
					local convoy = false
					local all = true
					comm_start_convoy(player, convoy, depot, all)	
				}
				return null
				break;
			case 3:

                if (pot0==0){
                    for(local j=0;j<transf_list.len();j++){
                        local tile = my_tile(transf_list[j])
                        local label = tile.find_object(mo_label)	
                        if (label){
							tile.remove_object(player_x(1), mo_label)
                        }

						local tool = command_x(tool_build_transformer)			
						local err = tool.work(player_x(pl), tile, sc_transf_name)
                    }
                }
                if (pot1 == 0){
		            local list = sc_tran_list
					local t_name = sc_power_name
					local tool = command_x(tool_build_way)
					local player = player_x(pl)

					for(local j = 0; j<list.len(); j++){
						tool.work(player, list[j].a, list[j].b, t_name)
					}
           		}
				return null
				break;
			case 4:
				if (pot0==0){
                    local pl = 0
                    local list = obj_list1
                    local obj = mo_building
                    local station = false

					for(local j=0;j<list.len();j++){
						local tile = my_tile(list[j].c)
						local is_obj = tile.find_object(obj)
						local halt = tile.get_halt()
						if (is_obj){
						    if (!halt){
						        tile.remove_object(player_x(1), obj)
						    }
						    else if (station){
						        tile.remove_object(player_x(1), obj)
						    }
						}
					}
				}
				if (pot1==0){
				    local count=0
				    local nr = obj_list1.len()
				    local list = obj_list1

					for(local j=0;j<nr;j++){
						if (glsw[j]==0){
							local tile = my_tile(list[j].c)
							local name = list[j].name == ""? sc_st_name2 : list[j].name
							local label = tile.find_object(mo_label)
							if (label)
								tile.remove_object(player_x(1), mo_label)

							local way = tile.find_object(mo_way)
							if(way)
								way.unmark()

							local halt = tile.get_halt()
							local tool = command_x(tool_build_station)
							tool.work(player_x(pl), tile, name)
						}					
					}
                }
				local ok = false
				if (current_cov> ch5_cov_lim2.a && current_cov< ch5_cov_lim2.b){
					local wt = wt_road
					local player = player_x(pl)
					local c_depot = my_tile(c_dep2)
					comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito

					local sched = schedule_x(wt, [])
					local c_list = sch_list2
					local siz = c_list.len()
					for(local j = 0;j<siz;j++){
						if(j==0)
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), veh2_load, veh2_wait))
						else
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), 0, 0))
					}
					local c_line = comm_get_line(player, wt, sched)

					local name = veh2_obj
					local cov_nr = d2_cnr  //Max convoys nr in depot
					local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
					for (local j = 0; j<(cov_nr); j++){
						if (!comm_set_convoy(j, c_depot, name))
							return 0
						local conv = depot.get_convoy_list()
						conv[j].set_line(player, c_line)
					}
					local convoy = false
					local all = true
					comm_start_convoy(player, convoy, depot, all)	

					ok = true
				}

				if (ok || (current_cov> ch5_cov_lim3.a && current_cov< ch5_cov_lim3.b)){
					local wt = wt_water
					local player = player_x(pl)
					local c_depot = my_tile(c_dep3)
					comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito

					local sched = schedule_x(wt, [])
					local c_list = is_water_entry(sch_list3)
					local siz = c_list.len()
					for(local j = 0;j<siz;j++){
						if(j==0)
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), veh3_load, veh3_wait))
						else
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), 0, 0))
					}
					local c_line = comm_get_line(player, wt, sched)

					local name = veh3_obj
					local cov_nr = d3_cnr  //Max convoys nr in depot
					if (!comm_set_convoy(cov_nr, c_depot, name))
						return 0

					local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
					local conv = depot.get_convoy_list()
					conv[0].set_line(player, c_line)
					comm_start_convoy(player, conv[0], depot)
				}
                
				return null
				break
			case 5:
				if (current_cov> ch5_cov_lim4.a && current_cov< ch5_cov_lim4.b){
					local wt = wt_road
					local player = player_x(pl)
					local c_depot = my_tile(c_dep2)
					comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito

					local sched = schedule_x(wt, [])
					local c_list = sch_list4
					local siz = c_list.len()
					local load = veh4_load
					local wait = veh4_wait
					for(local j = 0;j<siz;j++){
						if(j==0)
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), load, wait))
						else
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), 0, 0))
					}
					local c_line = comm_get_line(player, wt, sched)

					local name = veh4_obj
					local cov_nr = d4_cnr  //Max convoys nr in depot
					if (!comm_set_convoy(cov_nr, c_depot, name))
						return 0

					local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
					local conv = depot.get_convoy_list()
					conv[0].set_line(player, c_line)
					comm_start_convoy(player, conv[0], depot)
				}
		}
		return null
	}
	
	function set_all_rules(pl)
    {
		local forbid = [tool_remove_wayobj, tool_build_way, tool_build_bridge, tool_build_tunnel, tool_build_station,
                       tool_remove_way, tool_build_depot, tool_build_roadsign, tool_build_wayobj]

		foreach(wt in all_waytypes)
			if (wt != wt_power && wt != wt_road) {
			    foreach (tool_id in forbid)
				    rules.forbid_way_tool(pl, tool_id, wt )
			}

		local forbid =	[	4134,4135, tool_lower_land, tool_raise_land, tool_setslope, tool_build_roadsign,
        					tool_restoreslope, tool_plant_tree, tool_set_marker, tool_stop_mover, tool_buy_house, 
							tool_add_city, tool_make_stop_public, 4137, tool_build_wayobj,tool_remove_wayobj
						]

		foreach (tool_id in forbid)
		    rules.forbid_tool(pl, tool_id)

		switch (this.step) {
			case 1:
				local forbid =	[	4136,4140,4126,4103,4097,4134,4135,tool_lower_land,tool_raise_land,tool_restoreslope,tool_build_way,
									tool_make_stop_public,tool_build_transformer,tool_build_station,
									tool_build_bridge,tool_build_depot,tool_remove_way,tool_build_tunnel
								]
				foreach (tool_id in forbid)
					rules.forbid_tool(pl, tool_id )
			break

			case 2:
				local forbid = [tool_remove_wayobj, tool_build_tunnel, tool_build_roadsign, tool_build_wayobj]

				foreach(wt in all_waytypes)
					if (wt != wt_power) {
					    foreach (tool_id in forbid)
						    rules.forbid_way_tool(pl, tool_id, wt )
				}
			break

			case 3:
				local forbid = [tool_remove_wayobj, tool_build_way, tool_build_bridge, tool_build_tunnel, tool_build_station,
		                       tool_remove_way, tool_build_depot, tool_build_roadsign, tool_build_wayobj]

				foreach(wt in all_waytypes)
					if (wt != wt_power) {
					    foreach (tool_id in forbid)
						    rules.forbid_way_tool(pl, tool_id, wt )
				}
		        rules.forbid_tool(pl, tool_build_station)
			break

			case 4:
				local forbid =	[	tool_build_transformer,tool_build_way,
									tool_build_bridge,tool_build_depot,tool_remove_way,tool_build_tunnel
								]
				foreach (tool_id in forbid)
					rules.forbid_tool(pl, tool_id )
			break
		}
	}

    function delete_objet(player, list, obj, lab_name, station = false)
    {
        for(local j=0;j<list.len();j++){
            local t = my_tile(list[j].c)
            local is_obj = t.find_object(obj)
            local halt = t.get_halt()
            if (is_obj){
                if (!halt){
                    t.remove_object(player, obj)
                }
                else if (station){
                    t.remove_object(player, obj)
                }
            }
            if (t.is_empty())
				public_label(t, lab_name)
        }
        return null
    }

	function truck_result_message(nr, name, good, veh, cov)
	{
		switch (nr) {
			case 0:
				return format(translate("You must select a [%s]."),name)
				break

			case 1:
				return format(translate("The number of trucks must be [%d]."),cov)
				break

			case 2:
				return format(translate("The number of convoys must be [%d], press the [Sell] button."),cov)
				break

			case 3:
				return format(translate("The truck must be for [%s]."),good)
				break

			case 4:
				return format(translate("The trailers numbers must be [%d]."),veh-1)
				break

			default :
				return translate("The convoy is not correct.")
				break
		}
	}

	function is_station_truck_build(pos, tool_id, c_list, good)
	{
		local result = null
		local is_correct = false
		local st = {is_correct = true, c = null, nr = 0}
		for(local j=0;j<c_list.len();j++){
			local tile = my_tile(c_list[j])
			local halt = tile.get_halt()
			local buil = tile.find_object(mo_building)
			if(buil){
				local st_desc = buil.get_desc()
				local st_list = building_desc_x.get_available_stations(34/*building_desc_x.station*/, st_desc.get_waytype(), good_desc_x(good))
				local sw = false
				
				//gui.add_message(""+st_desc.get_type()+"  , "+st_desc.get_waytype()+"")
				foreach(st in st_list){
					if (st.get_name() == st_desc.get_name())
						sw=true
				}
				//gui.add_message(""+sw+"  , "+st_desc.get_waytype()+"")
				if(sw) st.is_correct = true//halt.accepts_good(good_desc_x(good))
				else {
					st.is_correct = false
					st.c = c_list[j]
					st.nr = j+1
				}
			}
			if (pos.x == c_list[j].x && pos.y == c_list[j].y){
				if(tool_id==tool_build_station){
					if(st.is_correct && result == null) result = null
					else result = format(translate("Station No.%d must accept goods"),st.nr)+" ("+st.c.tostring()+")."
				}	
			}
			if (tool_id==tool_remover && !st.is_correct){
				if(halt){
					local tile_list = halt.get_tile_list()
					foreach(tile in tile_list){
						if(pos.x == tile.x && pos.y == tile.y)
							return null
					}
				}
			}
			if(!st.is_correct) result = format(translate("Station No.%d must accept goods"),st.nr)+" ("+st.c.tostring()+")."
		}
		return result
	}
	function ship_result_message(nr, name, good, veh, cov)
	{
		switch (nr) {
			case 0:
				return format(translate("You must select a [%s]."),name)
				break

			case 1:
				return format(translate("The number of ships must be [%d]."),cov)
				break

			case 2:
				return format(translate("The number of convoys must be [%d], press the [Sell] button."),cov)
				break

			case 3:
				return format(translate("The ship must be for [%s]."),good)
				break

			case 4:
				return translate("No barges allowed.")
				break

			default :
				return translate("The convoy is not correct.")
				break
		}
	}
}        // END of class

// END OF FILE
