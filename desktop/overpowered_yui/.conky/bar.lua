--to call lua:# -- Lua Load -- #
--# SET THE PATH TO THE SCRIPT HERE
--lua_load /home/iacopo/.conky/barras.lua
--lua_draw_hook_post main_bars
--
--[[ BARGRAPH WIDGET
	v1.3 by wlourf (03 march 2010)
	This widget draw a simple bar like (old) equalizers on hi-fi systems.
	http://u-scripts.blogspot.com/
	
	The arguments are :
	- "name" is the type of stat to display; you can choose from 'cpu', 'memperc', 'fs_used_perc', 'battery_used_perc'...
	  or you can set it to "" if you want to display a numeric value with arg=numeric_value
    - "arg" is the argument to the stat type, e.g. if in Conky you would write ${cpu cpu0}, 'cpu0' would be the argument. 
      If you would not use an argument in the Conky variable, use ''.
	- "max" is the maximum value of the bar. If the Conky variable outputs a percentage, use 100.
	- "nb_blocks" is the umber of block to draw
	- "cap" id the cap of a block, possibles values are CAIRO_LINE_CAP_ROUND , CAIRO_LINE_CAP_SQUARE or CAIRO_LINE_CAP_BUTT
	  see http://www.cairographics.org/samples/set_line_cap/
	- "xb" and "yb" are the coordinates of the bottom left point of the bar, or the center of the circle if radius>0
	- "w" and "h" are the width and the height of a block (without caps), w has no effect for "circle" bar
	- "space" is the space betwwen two blocks, can be null or negative
	- "bgc" and "bga" are background colors and alpha when the block is not LIGHT OFF
	- "fgc" and "fga" are foreground colors and alpha when the block is not LIGHT ON
	- "alc" and "ala" are foreground colors and alpha when the block is not LIGHT ON and ALARM ON
	- "alarm" is the value where blocks LIGHT ON are in a different color (values from 0 to 100)
	- "led_effect" true or false : to show a block with a led effect
	- "led_alpha" alpha of the center of the led (values from 0 to 1)
	- "smooth" true or false : colors in the bar has a smooth effect
	- "mid_color",mid_alpha" : colors of the center of the bar (mid_color can to be set to nil)
	- "rotation" : angle of rotation of the bar (values are 0 to 360 degrees). 0 = vertical bar, 90 = horizontal bar
	- "radius" : draw the bar on a circle (it's no more a circle, radius = 0 to keep bars)
	- "angle_bar"  : if radius>0 angle_bar is the angle of the bar
v1.0 (10 Feb. 2010) original release
v1.1 (13 Feb. 2010) numeric values can be passed instead conky stats with parameters name="", arg = numeric_value	
v1.2 (28 Feb. 2010) just renamed the widget to bargraph
v1.3 (03 March 2010) added parameters radius & angle_bar to draw the bar in a circular way
]]

require 'cairo'

----------------START OF PARAMETERS ----------
function conky_main_bars()
bars_settings={
{
name="mpd_percent",
arg="",
max=100,
alarm=50,
cap="b",
x=110,
y=80,
angle=90,
blocks=55,
height=4,
width=10,
space=0,
skew_y=0,
skew_x=0,
bg_colour={0xffffff,0.1},
fg_colour={0x43C3EB,0.9},
smooth=true,
},

---------------------------
}
	if conky_window == nil then return end
	
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
	
	cr = cairo_create(cs)    
	--prevent segmentation error when reading cpu state
    if tonumber(conky_parse('${updates}'))>3 then
        for i in pairs(bars_settings) do
        	
        	draw_multi_bar_graph(bars_settings[i])
        	
        end
    end
	cairo_destroy(cr)
	cairo_surface_destroy(cs)

end



function draw_multi_bar_graph(t)
	cairo_save(cr)
	--check values
	if t.name==nil and t.arg==nil then 
		print ("No input values ... use parameters 'name' with 'arg' or only parameter 'arg' ") 
		return
	end
	if t.max==nil then
		print ("No maximum value defined, use 'max'")
		return
	end
	if t.name==nil then t.name="" end
	if t.arg==nil then t.arg="" end

	--set default values	
	if t.x == nil		then t.x = conky_window.width/2 end
	if t.y == nil		then t.y = conky_window.height/2 end
	if t.blocks == nil	then t.blocks=10 end
	if t.height == nil	then t.height=10 end
	if t.angle == nil 	then t.angle=0 end
	t.angle = t.angle*math.pi/180
	--line cap style
	if t.cap==nil		then t.cap = "b" end
	local cap="b"
	for i,v in ipairs({"s","r","b"}) do 
		if v==t.cap then cap=v end
	end
	delta=0
	if t.cap=="r" or t.cap=="s" then delta = t.height end
	if cap=="s" then 	cap = CAIRO_LINE_CAP_SQUARE
	elseif cap=="r" then
		cap = CAIRO_LINE_CAP_ROUND
	elseif cap=="b" then
		cap = CAIRO_LINE_CAP_BUTT
	end
	--end line cap style
	--if t.led_effect == nil	then t.led_effect="r" end
	if t.width == nil	then t.width=20 end
	if t.space == nil	then t.space=2 end
	if t.radius == nil	then t.radius=0 end
	if t.angle_bar == nil	then t.angle_bar=0 end
	t.angle_bar = t.angle_bar*math.pi/360 --halt angle
	
	--colours
	if t.bg_colour == nil 	then t.bg_colour = {0x00FF00,0.5} end
	if #t.bg_colour~=2 		then t.bg_colour = {0x00FF00,0.5} end
	if t.fg_colour == nil 	then t.fg_colour = {0x00FF00,1} end
	if #t.fg_colour~=2 		then t.fg_colour = {0x00FF00,1} end
	if t.alarm_colour == nil 	then t.alarm_colour = t.fg_colour end
	if #t.alarm_colour~=2 		then t.alarm_colour = t.fg_colour end

	if t.mid_colour ~= nil then	
		for i=1, #t.mid_colour do    
		    if #t.mid_colour[i]~=3 then 
		    	print ("error in mid_color table")
		    	t.mid_colour[i]={1,0xFFFFFF,1} 
		    end
		end
    end
    
	if t.bg_led ~= nil and #t.bg_led~=2	then t.bg_led = t.bg_colour end
	if t.fg_led ~= nil and #t.fg_led~=2	then t.fg_led = t.fg_colour end
	if t.alarm_led~= nil and #t.alarm_led~=2 then t.alarm_led = t.fg_led end
	
	if t.led_effect~=nil then
		if t.bg_led == nil then t.bg_led = t.bg_colour end
		if t.fg_led == nil 	then t.fg_led = t.fg_colour end
		if t.alarm_led == nil  then t.alarm_led = t.fg_led end
	end
	

	if t.alarm==nil then t.alarm = t.max end --0.8*t.max end
	if t.smooth == nil then t.smooth = false end

	if t.skew_x == nil then t.skew_x=0
	t.skew_x = math.pi*t.skew_x/180	
	end
	if t.skew_y == nil then t.skew_y=0
	t.skew_y = math.pi*t.skew_y/360	
	end
	
	if t.reflection_alpha==nil then t.reflection_alpha=0 end
	if t.reflection_length==nil then t.reflection_length=1 end
	if t.reflection_scale==nil then t.reflection_scale=1 end
	
	--end of default values
	

 	local function rgb_to_r_g_b(col_a)
		return ((col_a[1] / 0x10000) % 0x100) / 255., ((col_a[1] / 0x100) % 0x100) / 255., (col_a[1] % 0x100) / 255., col_a[2]
	end
	
	
	--functions used to create patterns

	local function create_smooth_linear_gradient(x0,y0,x1,y1)
		local pat = cairo_pattern_create_linear (x0,y0,x1,y1)
		cairo_pattern_add_color_stop_rgba (pat, 0, rgb_to_r_g_b(t.fg_colour))
		cairo_pattern_add_color_stop_rgba (pat, 1, rgb_to_r_g_b(t.alarm_colour))
		if t.mid_colour ~=nil then
			for i=1, #t.mid_colour do
				cairo_pattern_add_color_stop_rgba (pat, t.mid_colour[i][1], rgb_to_r_g_b({t.mid_colour[i][2],t.mid_colour[i][3]}))
			end
		end
		return pat
	end

	local function create_smooth_radial_gradient(x0,y0,r0,x1,y1,r1)
		local pat =  cairo_pattern_create_radial (x0,y0,r0,x1,y1,r1)
		cairo_pattern_add_color_stop_rgba (pat, 0, rgb_to_r_g_b(t.fg_colour))
		cairo_pattern_add_color_stop_rgba (pat, 1, rgb_to_r_g_b(t.alarm_colour))
		if t.mid_colour ~=nil then
			for i=1, #t.mid_colour do
				cairo_pattern_add_color_stop_rgba (pat, t.mid_colour[i][1], rgb_to_r_g_b({t.mid_colour[i][2],t.mid_colour[i][3]}))
			end
		end
		return pat
	end
	
	local function create_led_linear_gradient(x0,y0,x1,y1,col_alp,col_led)
		local pat = cairo_pattern_create_linear (x0,y0,x1,y1) ---delta, 0,delta+ t.width,0)
		cairo_pattern_add_color_stop_rgba (pat, 0.0, rgb_to_r_g_b(col_alp))
		cairo_pattern_add_color_stop_rgba (pat, 0.5, rgb_to_r_g_b(col_led))
		cairo_pattern_add_color_stop_rgba (pat, 1.0, rgb_to_r_g_b(col_alp))
		return pat
	end

	local function create_led_radial_gradient(x0,y0,r0,x1,y1,r1,col_alp,col_led,mode)
		local pat = cairo_pattern_create_radial (x0,y0,r0,x1,y1,r1)
		if mode==3 then
			cairo_pattern_add_color_stop_rgba (pat, 0, rgb_to_r_g_b(col_alp))				
			cairo_pattern_add_color_stop_rgba (pat, 0.5, rgb_to_r_g_b(col_led))
			cairo_pattern_add_color_stop_rgba (pat, 1, rgb_to_r_g_b(col_alp))				
		else
			cairo_pattern_add_color_stop_rgba (pat, 0, rgb_to_r_g_b(col_led))
			cairo_pattern_add_color_stop_rgba (pat, 1, rgb_to_r_g_b(col_alp))				
		end
		return pat
	end






	local function draw_single_bar()
		--this fucntion is used for bars with a single block (blocks=1) but 
		--the drawing is cut in 3 blocks : value/alarm/background
		--not zvzimzblr for circular bar
		local function create_pattern(col_alp,col_led,bg)
			local pat
			
			if not t.smooth then
				if t.led_effect=="e" then
					pat = create_led_linear_gradient (-delta, 0,delta+ t.width,0,col_alp,col_led)
				elseif t.led_effect=="a" then
					pat = create_led_linear_gradient (t.width/2, 0,t.width/2,-t.height,col_alp,col_led)
				elseif  t.led_effect=="r" then
					pat = create_led_radial_gradient (t.width/2, -t.height/2, 0, t.width/2,-t.height/2,t.height/1.5,col_alp,col_led,2)
				else
					pat = cairo_pattern_create_rgba  (rgb_to_r_g_b(col_alp))
				end
			else
				if bg then
					pat = cairo_pattern_create_rgba  (rgb_to_r_g_b(t.bg_colour))
				else
					pat = create_smooth_linear_gradient(t.width/2, 0, t.width/2,-t.height)
				end
			end
			return pat
		end
		
		local y1=-t.height*pct/100
		local y2=nil
		if pct>(100*t.alarm/t.max) then 
			y1 = -t.height*t.alarm/100
			y2 = -t.height*pct/100
			if t.smooth then y1=y2 end
		end
		
		if t.angle_bar==0 then
		
			--block for fg value
			pat = create_pattern(t.fg_colour,t.fg_led,false)
			cairo_set_source(cr,pat)
			cairo_rectangle(cr,0,0,t.width,y1)
			cairo_fill(cr)
		
			-- block for alarm value			
			if not t.smooth and y2 ~=nil then 
				pat = create_pattern(t.alarm_colour,t.alarm_led,false)
				cairo_set_source(cr,pat)
				cairo_rectangle(cr,0,y1,t.width,y2-y1)
				cairo_fill(cr)
				y3=y2
			else
				y2,y3=y1,y1
			end
			-- block for bg value
			cairo_rectangle(cr,0,y2,t.width,-t.height-y3)
			pat = create_pattern(t.bg_colour,t.bg_led,true)
			cairo_set_source(cr,pat)
			cairo_pattern_destroy(pat)
			cairo_fill(cr)
		end		
	end  --end single bar
	





	local function draw_multi_bar()
		--function used for bars with 2 or more blocks
		for pt = 1,t.blocks do 
			--set block y
			local y1 = -(pt-1)*(t.height+t.space)
			local light_on=false
			
			--set colors
			local col_alp = t.bg_colour
			local col_led = t.bg_led
			if pct>=(100/t.blocks) or pct>0 then --ligth on or not the block
				if pct>=(pcb*(pt-1))  then 
					light_on = true
					col_alp = t.fg_colour
					col_led = t.fg_led
					if pct>=(100*t.alarm/t.max) and (pcb*pt)>(100*t.alarm/t.max) then 
						col_alp = t.alarm_colour 
						col_led = t.alarm_led 
					end
				end
			end

			--set colors
			--have to try to create gradients outside the loop ?
			local pat 
			
			if not t.smooth then
				if t.angle_bar==0 then
					if t.led_effect=="e" then
						pat = create_led_linear_gradient (-delta, 0,delta+ t.width,0,col_alp,col_led)
					elseif t.led_effect=="a" then
						pat = create_led_linear_gradient (t.width/2, -t.height/2+y1,t.width/2,0+t.height/2+y1,col_alp,col_led)					
					elseif  t.led_effect=="r" then
						pat = create_led_radial_gradient (t.width/2, y1, 0, t.width/2,y1,t.width/1.5,col_alp,col_led,2)	
					else
						pat = cairo_pattern_create_rgba  (rgb_to_r_g_b(col_alp))
					end
				else
					 if t.led_effect=="a"  then
						 pat = create_led_radial_gradient (0, 0, t.radius+(t.height+t.space)*(pt-1),
														 0, 0, t.radius+(t.height+t.space)*(pt),						 
											 col_alp,col_led,3)	
					else
						pat = cairo_pattern_create_rgba  (rgb_to_r_g_b(col_alp))					
					end
					
				end
			else
				
				if light_on then
					if t.angle_bar==0 then
						pat = create_smooth_linear_gradient(t.width/2, t.height/2, t.width/2,-(t.blocks-0.5)*(t.height+t.space))
					else
						pat = create_smooth_radial_gradient(0, 0, (t.height+t.space),  0,0,(t.blocks+1)*(t.height+t.space),2)
					end
				else		
					pat = cairo_pattern_create_rgba  (rgb_to_r_g_b(t.bg_colour))
				end
			end
			cairo_set_source (cr, pat)
			cairo_pattern_destroy(pat)

			--draw a block
			if t.angle_bar==0 then
				cairo_move_to(cr,0,y1)
				cairo_line_to(cr,t.width,y1)
			else		
				cairo_arc( cr,0,0,
					t.radius+(t.height+t.space)*(pt)-t.height/2,
					 -t.angle_bar -math.pi/2 ,
					 t.angle_bar -math.pi/2)
			end
			cairo_stroke(cr)
		end	
	end
	
	
	
	
	local function setup_bar_graph()
		--function used to retrieve the value to display and to set the cairo structure
		if t.blocks ~=1 then t.y=t.y-t.height/2 end
		
		local value = 0
		if t.name ~="" then
			value = tonumber(conky_parse(string.format('${%s %s}', t.name, t.arg)))
		else
			value = tonumber(t.arg)
		end

		if value==nil then value =0 end
		
		pct = 100*value/t.max
		pcb = 100/t.blocks
		
		cairo_set_line_width (cr, t.height)
		cairo_set_line_cap  (cr, cap)
		cairo_translate(cr,t.x,t.y)
		cairo_rotate(cr,t.angle)

		local matrix0 = cairo_matrix_t:create()
		cairo_matrix_init (matrix0, 1,t.skew_y,t.skew_x,1,0,0)
		cairo_transform(cr,matrix0)

	
		
		--call the drawing function for blocks
		if t.blocks==1 and t.angle_bar==0 then
			draw_single_bar()
			if t.reflection=="t" or t.reflection=="b" then cairo_translate(cr,0,-t.height) end
		else
			draw_multi_bar()
		end

		--dot for reminder
		--[[
		if t.blocks ~=1 then
			cairo_set_source_rgba(cr,1,0,0,1)
			cairo_arc(cr,0,t.height/2,3,0,2*math.pi)
			cairo_fill(cr)
		else
			cairo_set_source_rgba(cr,1,0,0,1)
			cairo_arc(cr,0,0,3,0,2*math.pi)
			cairo_fill(cr)
		end
]]
		--call the drawing function for reflection and prepare the mask used		
		if t.reflection_alpha>0 and t.angle_bar==0 then
			local pat2
			local matrix1 = cairo_matrix_t:create()
			if t.angle_bar==0 then
				pts={-delta/2,(t.height+t.space)/2,t.width+delta,-(t.height+t.space)*(t.blocks)}
				if t.reflection=="t" then
					cairo_matrix_init (matrix1,1,0,0,-t.reflection_scale,0,-(t.height+t.space)*(t.blocks-0.5)*2*(t.reflection_scale+1)/2)
					pat2 = cairo_pattern_create_linear (t.width/2,-(t.height+t.space)*(t.blocks),t.width/2,(t.height+t.space)/2)
				elseif t.reflection=="r" then
					cairo_matrix_init (matrix1,-t.reflection_scale,0,0,1,delta+2*t.width,0)
					pat2 = cairo_pattern_create_linear (delta/2+t.width,0,-delta/2,0)
				elseif t.reflection=="l" then
					cairo_matrix_init (matrix1,-t.reflection_scale,0,0,1,-delta,0)
					pat2 = cairo_pattern_create_linear (-delta/2,0,delta/2+t.width,-0)
				else --bottom
					cairo_matrix_init (matrix1,1,0,0,-1*t.reflection_scale,0,(t.height+t.space)*(t.reflection_scale+1)/2)
					pat2 = cairo_pattern_create_linear (t.width/2,(t.height+t.space)/2,t.width/2,-(t.height+t.space)*(t.blocks))
				end
			end
			cairo_transform(cr,matrix1)

			if t.blocks==1 and t.angle_bar==0 then
				draw_single_bar()
				cairo_translate(cr,0,-t.height/2) 
			else
				draw_multi_bar()
			end
			
			
			cairo_set_line_width(cr,0.01)
			cairo_pattern_add_color_stop_rgba (pat2, 0,0,0,0,1-t.reflection_alpha)
			cairo_pattern_add_color_stop_rgba (pat2, t.reflection_length,0,0,0,1)
			if t.angle_bar==0 then
				cairo_rectangle(cr,pts[1],pts[2],pts[3],pts[4])
			end
			cairo_clip_preserve(cr)
			cairo_set_operator(cr,CAIRO_OPERATOR_CLEAR)
			cairo_stroke(cr)
			cairo_mask(cr,pat2)
			cairo_pattern_destroy(pat2)
			cairo_set_operator(cr,CAIRO_OPERATOR_OVER)
			
		end --reflection
		
		
	end --setup_bar_graph()

	
	--start here !
	setup_bar_graph()
	cairo_restore(cr)
end

