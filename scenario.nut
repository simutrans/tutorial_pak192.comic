/*
 *  Tutorial Scenario
 *
 
 *  Can NOT be used in network game !
 */
const version = 1650
map.file = "tutorial192.sve"
scenario_name             <- "Tutorial Scenario"
scenario.short_description = scenario_name
scenario.author            = "Yona-TYT"
scenario.version           = (version / 1000) + "." + ((version % 1000) / 100) + "." + ((version % 100) / 10) + (version % 10) +" beta"
scenario.translation      <- ttext("Translator")

resul_version <- {pak= false , st = false}

const nut_path      = "class/"		// path to folder with *.nut files
persistent.version <- version		// stores version of script
persistent.select  <- null			// stores user selection
persistent.chapter <-	1			// stores chapter number
persistent.step    <-	1			// stores step number of chapter

persistent.status <- {chapter=1, step=1} // save step y chapter

script_test <- true

persistent.st_nr <- array(30)			//Numero de estaciones/paradas

scr_jump <- false 

gl_percentage <- 0
persistent.gl_percentage <- 0

persistent.r_way_list <- {}				//Save way list in fullway 

//----------------------------------------------------------------

cov_save <- array(100)						//Guarda los convoys en lista
id_save <- array(100)						//Guarda id de los convoys en lista
ignore_save <- array(600)					//Marca convoys ingnorados

persistent.ignore_save <- array(600)
persistent.id_save <- array(100)

//-------------Guarda el estado del script------------------------
persistent.pot <- [0,0,0,0,0,0,0,0,0,0,0]

persistent.glsw <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
pglsw <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

pot0 <- 0
pot1 <- 0
pot2 <- 0
pot3 <- 0
pot4 <- 0
pot5 <- 0
pot6 <- 0
pot7 <- 0
pot8 <- 0
pot9 <- 0
pot10 <- 0
glsw <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

//---------------------Contador global de vehiculos----------------------------
persistent.gcov_nr <- 0	
gcov_nr <- 0
persistent.gcov_id <- 1
gcov_id <- 0
persistent.gall_cov <- 0	
gall_cov <-0
persistent.current_cov <- 0
current_cov <- 0
cov_sw <- true
correct_cov <- true

//----------------------------------------------------------------
tile_delay <- 2						//delay for mark tiles
tile_delay_list <- 2
gui_delay <- true					//delay for open win

fail_num <- 20						//numr for the count of try
fail_count <- 1            			//if tool fail more of 10 try

//Schedule activate
active_sch_check <- false

// placeholder for tools names in simutrans
tool_alias  <-	{	inspe = translate("Abfrage"), road= translate("ROADTOOLS"), rail = translate("RAILTOOLS"),
					ship = translate("SHIPTOOLS"), land = translate("SLOPETOOLS"), spec = translate("SPECIALTOOLS")
				}

good_alias  <-	{	mail = "Post", passa= "Passagiere", goods = "goods_", grain = "grain", coal = "Kohle",
					flour = "flour", deliv = "Crates Deliverables", oel = "oil", gas = "fuel", wood = "logs", plan = "boards"
				}
// table containing all system_types
all_systemtypes <- [st_flat, st_elevated, st_runway, st_tram]

// Complemento para obtener tiempo de espera
tick_wait <- 16

chapter            <- null			// used later for class
chapter_max        <- 7				// amount of chapter
select_option      <- { x = 0, y = 0, z = 1 }	// place of station to control name
select_option_halt <- null			// placeholder for halt_x
tutorial		  <- {}				// placeholder for all chapter CLASS

//returns pakset name (lower case)
function get_set_name(name)
{
	local s = name.find(" ")
	name = name.slice(0, s)
	name = name.tolower()
	return name
}

simu_version <- "122.0.1"
pak_name <- "pak192.comic"
current_st <- "0"
current_pak <- "pak"

function string_analyzer()
{
	local result = {pak= false , st = false}
	//Check version and pakset name
	current_pak = get_set_name(get_pakset_name())
	current_st = get_version_number()

	local p_siz = {a = current_pak.len(), b = pak_name.len()}

	//Pak name analyzer
	local siz_a = max(p_siz.a, p_siz.a)
	local count_a = 0
	local tx_a = ""
	for(local j=0;j<siz_a;j++){
		try {
			pak_name[count_a]
		}
		catch(ev) {
			break
		}
		if(count_a>0 && current_pak[j]!=pak_name[count_a]){
			break
		}
		if(current_pak[j]==pak_name[count_a]){
			tx_a += format("%c",current_pak[j])
			count_a++
			continue
		}
	}
	if(pak_name == tx_a) result.pak = true
	//gui.add_message("Current: "+current_pak+"  Tx: "+tx_a+"  Pak: "+pak_name+" result: "+result.pak)

	local s_siz = {a = current_st.len(), b = simu_version.len()}
	local siz_b = max(s_siz.a, s_siz.a)

	local nr_a = 0
	local nr_b = 0

	while(nr_a<s_siz.a || nr_b<s_siz.b){
		local value_a = ""
		for(local j=nr_a;j<s_siz.a;j++){
			local tx = format("%c",current_st[j])
			try {
				tx.tointeger()
			}
			catch(ev) {
				if(tx=="."){
					nr_a = j+1
					break
				}
				nr_a++
				continue
			}
			value_a+=tx
		}

		local value_b = ""
		for(local j=nr_b;j<s_siz.b;j++){
			local tx = format("%c",simu_version[j])
			if(tx=="."){
				nr_b = j+1
				break
			}
			value_b+=tx
			if(j == s_siz.b-1)nr_b = s_siz.b
		}
		try {
			value_a.tointeger()
			value_b.tointeger()
		}
		catch(ev) {
			continue
		}
		//gui.add_message("value_a "+value_a.tointeger()+"  value_b "+value_b.tointeger()+"")
		if(value_a.tointeger()<value_b.tointeger()){
			result.st = false
			break
		}
		result.st = true
	}
	//gui.add_message("result st: "+result.st+"  result pak:" +result.pak)
	return result
}

{
	//Check version and pakset name
	resul_version = string_analyzer()
	include(nut_path+"class_basic_convoys") 		// include class for detect eliminated convoys
	include(nut_path+"class_basic_chapter") 		// include class for basic chapter structure

}

include(nut_path+"class_basic_chapter") 		// include class for basic chapter structure
for (local i = 0; i <= chapter_max; i++)		// include amount of chapter classes
	include(nut_path+"class_chapter_"+(i < 10 ? "0"+i:i) )
chapter            <- tutorial.chapter_02      	// must be placed here !!!

function script_text()
{	

	if(!correct_cov){
		gui.add_message(""+translate("Advance not allowed"))
		return null
	}

	if(persistent.chapter<7){

		scr_jump = true

		local result = null

		result = chapter.script_text()
		if(result == 0) gui.add_message(""+translate("Advance not allowed")+"")

		scr_jump = false
		return result
	}

	return null
}

function sum(a,b)
{
	return a+b
}

function my_chapter()
{
	return "chapter_"+(chapter.chap_nr < 10 ? "0":"")+chapter.chap_nr+"/"
}

function scenario_percentage(percentage)
{
	return min( ((persistent.chapter == 0? 1-1 : persistent.chapter -1) * 100 + percentage) / tutorial.len(), 100 )
}

function load_chapter(number,pl)
{
    rules.clear()
	if (!resul_version.pak || !resul_version.st){
		number = 0
		chapter = tutorial["chapter_"+(number < 10 ? "0":"")+number](pl)

		chapter.chap_nr = number
	}
	else{
		if (number <= tutorial.len() )		// replace the class
			chapter = tutorial["chapter_"+(number < 10 ? "0":"")+number](pl)
		else    persistent.chapter--
		if ( (number == persistent.chapter) && (chapter.startcash > 0) )  // set cash money here
			player_x(0).book_cash( (chapter.startcash - player_x(0).get_cash()[0]) * 100)

		chapter.chap_nr = persistent.chapter
		persistent.step = persistent.status.step
	}
}

function load_conv_ch(number, step, pl)
{
    rules.clear()
	if (!resul_version.pak || !resul_version.st){
		number = 0
		chapter = tutorial["chapter_"+(number < 10 ? "0":"")+number](pl)
		chapter.chap_nr = number
	}
	else{
		chapter = tutorial["chapter_"+(number < 10 ? "0":"")+number](pl)

		if ( (number == persistent.chapter) && (chapter.startcash > 0) )  // set cash money here
			player_x(0).book_cash( (chapter.startcash - player_x(0).get_cash()[0]) * 100)

		chapter.step_nr(step)
		persistent.chapter = number
		chapter.chap_nr = number
		chapter.start_chapter()
	}
}

function set_city_names()
{
	foreach ( city in city_list_x() )
	{
		local name = ttext( city.get_name() )
		if (name.tostring() != "") city.set_name( name.tostring() )
	}
}

function get_info_text(pl)
{
    local info = ttextfile("info.txt")
	local help = ""
	local i = 0
	//foreach (chap in tutorial)
	for (i=1;i<=chapter_max;i++)
		help+= "<em>"+translate("Chapter")+" "+(i)+"</em> - "+translate(tutorial["chapter_"+(i<10?"0":"")+i].chapter_name)+"<br>"
	info.list_of_chapters = help

	info.first_link = "<a href=\"goal\">"+(chapter.chap_nr <= 1 ? translate("Let's start!"):translate("Let's go on!") )+"  >></a>"
    return info
}

function get_rule_text(pl)
{
	/*
	local cov_nr_debug = "All convoys-> "+gall_cov+":: Convoys count-> "+gcov_nr+":: current covoy-> "+current_cov+":: Correct cov-> "+correct_cov+":: Convoy id-> "+gcov_id+"<br><br>"
	local tx = ""
	local j=0
	for(j;j<gcov_nr;j++){
		local result = true
		// cnv - convoy_x instance saved somewhat earlier
		try {
			 cov_save[j].get_pos() // will fail if cnv is no longer existent
			 // do your checks
		}
		catch(ev) {
			result = false
		}
		if (result){
			if (cov_save[j].is_in_depot()){
				result = false
			}
		}

		if (result) {
			tx += "<em>["+j+"]</em> id cov save: "+id_save[j]+" :: id conv: "+cov_save[j].id+" <a href=\"("+cov_save[j].get_pos().tostring()+")\"> ("+cov_save[j].get_pos().tostring()+")</a> "+cov_save[j].get_name()+"<br>"
		}
		else
			tx += "<st>["+j+"]</st> "+id_save[j]+"::"+cov_save[j]+"<br>"
	}
	return cov_nr_debug + tx
	*/
	return chapter.give_title() + chapter.get_rule_text( pl, my_chapter() )
}

function get_goal_text(pl)
{
	return chapter.give_title() + chapter.get_goal_text( pl, my_chapter() )
}

function get_result_text(pl)
{
	local text = ttextfile("result.txt")
	//local percentage = chapter.is_chapter_completed(pl)
	text.ratio_chapter = gl_percentage
	text.ratio_scenario = scenario_percentage(gl_percentage)
	return chapter.give_title() + text.tostring()
}

function get_about_text(pl)
{
	local about = ttextfile("about.txt")
	about.short_description = scenario_name
	about.version = scenario.version
	about.author = scenario.author
	about.translation = scenario.translation
	
	return about
}

function get_debug_text(pl)
{
	return null
}

function start()
{
	gui_delay = false
	set_city_names()
    resume_game()
}

function labels_text_debug()
{
	local t1 = tile_x(0, 0, -2)
	local t2 = tile_x(1, 0, -2)

	if(!t1.find_object(mo_label) || !t2.find_object(mo_label)){
		label_x.create(t1, player_x(1), translate(""+persistent.chapter))
		label_x.create(t2, player_x(1), translate(""+chapter.step))
	}
	else {
		local l1 = label_x(t1.x, t1.y, t1.z)
		local l2 = label_x(t2.x, t2.y, t2.z)

		if(correct_cov){
			local ch_nr = l1.get_text().tointeger()
			local st_nr = l2.get_text().tointeger()
			if(persistent.chapter == ch_nr){
				l1.set_text(""+persistent.chapter)

				if(chapter.step <= (st_nr+1)){
					l2.set_text(""+chapter.step)
				}
				else {
					gui.add_message("Error1 here: CH "+persistent.chapter +" : ST "+chapter.step)

					//Se se regresa al valor anterior en caso de error
					persistent.status.step = st_nr
					persistent.step = st_nr
					chapter.step = st_nr
				}
			}
			else {
				if(chapter.step != 1){
					gui.add_message("Error2 here: CH "+persistent.chapter +" : ST "+chapter.step)

					//Se restauran todos en caso de error
					persistent.status.step = 1
					persistent.step = 1
					chapter.step = 1
				}
				l1.set_text(""+persistent.chapter)
				l2.set_text("1")
			}
		}
	}
}

function is_scenario_completed(pl)
{
	//labels_text_debug()
	//gui.add_message(""+glsw[0]+"")
	//gui.add_message("!!!!!"+persistent.step+" ch a "+st_nr[0]+"  !!!!! "+persistent.status.step+"  -- "+chapter.step+"")				
	if (pl != 0) return 0			// other player get only 0%

	if (currt_pos){
		local t = tile_x(currt_pos.x,currt_pos.y,currt_pos.z)
		local build = t.find_object(mo_building)
		if (!t.is_marked() && build){
			local t_list = gl_buil_list
			foreach(t in t_list){
				t.find_object(mo_building).unmark()
			}
			gl_buil_list = {}
			currt_pos = null
		}
	}
	if(fail_count == null){
		if (fail_num <= 0){
			gui.open_info_win_at("goal")
			fail_count = 1
			fail_num = 20
		}
		else fail_num--
	}
	if(gui_delay){
		gui.open_info_win_at("goal")
		gui_delay = false
	}

	//gui.add_message(""+current_cov+"  "+gall_cov+"")
	//Para los convoys ---------------------
	if (gall_cov != current_cov){
		basic_convoys().checks_convoy_removed(pl)
	}
	
	gall_cov = basic_convoys().checks_all_convoys()
	if(!correct_cov && gall_cov==gcov_nr){
		load_conv_ch(persistent.status.chapter, persistent.status.step, pl)
	}
	correct_cov = basic_convoys().correct_cov_list()
	persistent.gall_cov = gall_cov

//gui.add_message("gall_cov-> "+gall_cov+":: gcov_nr-> "+gcov_nr+":: current_cov-> "+current_cov+":: Step-> "+chapter.step+":: PersisStep-> "+persistent.step+":: Status->"+persistent.status.step+"")

	if(!correct_cov) {
		if (!resul_version.pak || !resul_version.st)
			chapter.step = 1

		else chapter.step = persistent.step
		chapter.start_chapter()
		return 1
	}

	chapter.step = persistent.step
	local percentage = chapter.is_chapter_completed(pl)
	gl_percentage = percentage
	persistent.gl_percentage = gl_percentage

	if (percentage >= 100){	// give message , be sure to have 100% or more
		local text = ttext("Chapter {number} - {cname} complete, next Chapter {nextcname} start here: ({coord}).")
		text.number = persistent.chapter
		text.cname = translate(""+chapter.chapter_name+"")

		persistent.chapter++
		persistent.status.chapter++

		load_chapter(persistent.chapter, pl)
		chapter.chap_nr = persistent.chapter
		percentage = chapter.is_chapter_completed(pl)
		 // ############## need update of scenario window

		text.nextcname = translate(""+chapter.chapter_name+"")
		text.coord = chapter.chapter_coord.tostring()
		chapter.start_chapter()  //Para iniciar variables en los capitulos
		if (persistent.chapter >1) gui.add_message(text.tostring())
	}
	percentage = scenario_percentage(percentage)
	if ( percentage >= 100 ) {		// scenario complete
		local text = translate("Tutorial Scenario complete.")
		gui.add_message( text.tostring() )
	}
	return percentage
}

function is_work_allowed_here(pl, tool_id, pos)
{	
	local pause = debug.is_paused()
	if (pause) return translate("Advance is not allowed with the game paused.")

	//return tile_x(pos.x,pos.y,pos.z).find_object(mo_way).get_dirs()
	if (pl != 0) return null

	if(scr_jump){
		return null
	}
	local result = translate("Action not allowed")
	if (correct_cov){
		result = chapter.is_work_allowed_here(pl, tool_id, pos)
		return fail_count_message(result, tool_id)
	}
	else {
		if (tool_id==4108 || tool_id==4096)
			result = null
	}
	return fail_count_message(result, tool_id)
}

function fail_count_message(result, tool_id)
{
	//gui.add_message(result+" ")
	//Desabilitado
	//if(tool_id != tool_build_tunnel && result != ""){
		//gui.add_message("fail_count: "+fail_count + "Tool: "+tool_id)
		if (fail_count && result != null){
			fail_count++
			if (fail_count >= fail_num){
				true//fail_count = null
				//return translate("Are you lost ?, see the instructions shown below.")
			}
		}
		else if (result == null)
			true//fail_count = 1
	//}
	return result
}

function is_schedule_allowed(pl, schedule)
{
	local pause = debug.is_paused()
	if (pause) return translate("Advance is not allowed with the game paused.")

    local result = null

	if (pl != 0) return null
	result = chapter.is_schedule_allowed(pl, schedule)
    if (result != null)
         active_sch_check = true
    else
         active_sch_check = false

    return result
}

function is_convoy_allowed(pl, convoy, depot)
{
	local pause = debug.is_paused()
	if (pause) return translate("Advance is not allowed with the game paused.")

	local result = null
	basic_convoys().checks_convoy_removed(pl)
	//gui.add_message("Run ->"+current_cov+","+correct_cov+" - "+gall_cov+"")
	if (pl != 0) return null
	result = chapter.is_convoy_allowed(pl, convoy, depot)
	//gui.add_message(""+result+"")
	return result
}

function is_tool_allowed(pl, tool_id, wt)
{
	//if (tool_id == 0x2000) return false // prevent players toggling pause mode
	if (tool_id == 0x2005) return false 
	else if (tool_id == 0x4006) return false 
	else if (tool_id == 0x4029) return false 
	else if (tool_id == 0x401c) return false 

    return true
}

function jump_to_link_executed(pos)
{
	chapter.jump_to_link_executed(pos)
	return null
}

//--------------------------------------------------------
datasave <- {cov = cov_save}

class data_save {	
	// Convoys
	function convoys_save() {return datasave.cov;}
	function _save() { return "data_save()"; }
}

persistent.datasave <- datasave

convoy_x._save <- function()
{
	return "convoy_x(" + id + ")"
}
//-----------------------------------------------------------

function resume_game()
{
	basic_convoys().set_convoy_limit()
	//Mark all text labels
	foreach(label in world.get_label_list()){
		if(label.get_owner().nr == 1)
			label.mark()
	}
	//Check version and pakset name
	resul_version = string_analyzer()

	// Datos guardados
	//-----------------------------------------------------	
	// copy it piece by piece otherwise the reference 
	foreach(key,value in persistent.datasave)
	{
		datasave.rawset(key,value)
	}
	persistent.datasave = datasave

	// Se obtienen los datos guardados
	cov_save  = data_save().convoys_save()

//-------------------------------------------------------
	gcov_nr = persistent.gcov_nr
	gall_cov = persistent.gall_cov
	current_cov = persistent.current_cov
	gcov_id = persistent.gcov_id
	sigcoord = persistent.sigcoord
	id_save = persistent.id_save
	ignore_save = persistent.ignore_save
	
	pot0=persistent.pot[0]
	pot1=persistent.pot[1]
	pot2=persistent.pot[2]
	pot3=persistent.pot[3]	
	pot4=persistent.pot[4]
	pot5=persistent.pot[5]	
	pot6=persistent.pot[6]	
	pot7=persistent.pot[7]	
	pot8=persistent.pot[8]
	pot9=persistent.pot[9]

	gl_percentage = persistent.gl_percentage

	for(local j=0;j<20;j++){
		if (persistent.glsw[j]!=0)
			glsw[j]=persistent.glsw[j]
		persistent.glsw[j]=glsw[j]
	}

	r_way_list = persistent.r_way_list

	load_chapter(persistent.chapter,0)      // load correct chapter for player=0

	chapter.step = persistent.step		// set chapter step from persistent

	select_option_halt = tile_x( 0, 0, select_option.z ).find_object(mo_label)

    chapter.start_chapter()
}

function get_line_name(halt)
{
	local lin_list = halt.get_line_list()
	
	foreach(line in lin_list) {
		return "<em>"+line.get_name()+"</em>"
	}
	return "<s>not line</s>"
}

function coord3d_to_key(c)
{
	return ("coord3d_" + c.x + "_" + c.y + "_" + c.z).toalnum();
}

// END OF FILE
