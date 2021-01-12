local S = ...

function vanity.get_vanity_formspec(clicker)
	local gender = player_api.get_gender(clicker)
	--5.4--local model = player_api.get_gender_model(gender)
	local face_base = player_api.compose_skin(clicker, "vanity_face_base.png")
	local base_texture = player_api.get_base_texture_table(clicker)
	local eyebrows = base_texture["eyebrowns"]
	local eye = base_texture["eye"]
	local mouth = base_texture["mouth"]
	local hair = base_texture["hair"]
	local face_preview = minetest.formspec_escape("[combine:16x16:0,0=".. face_base ..
		":0,0=" .. eyebrows ..
		":2,8=" .. eye ..
		":10,8=" .. eye ..
		":0,12=" .. mouth ..
		":0,0 =" .. string.sub(hair, 0, -5).."_preview.png"
	)
	local formspec =
		"formspec_version[4]"..
		"size[8.75,6.25]"..
		"image[0.5,0.5;4,4;".. face_preview .."]"..
		"image_button[4.75,2.5;1,1;player_blue_eye.png;btn_blue_eye;]"..
		"label[6,0.5;"..S("Skin Tone").."]"..
		"image_button[4.75,0.75;1,1;player_normal_skin.png;btn_normal_skin;]"..
		"image_button[6,0.75;1,1;player_brown_skin.png;btn_brown_skin;]"..
		"image_button[7.25,0.75;1,1;player_black_skin.png;btn_black_skin;]"..
		"label[6,2.25;"..S("Eyes Color").."]"..
		"image_button[6,2.5;1,1;player_brown_eye.png;btn_brown_eye;]"..
		"image_button[7.25,2.5;1,1;player_green_eye.png;btn_green_eye;]"..
		"image_button[4.75,3.75;1,1;player_gray_eye.png;btn_gray_eye;]"..
		"image_button[6,3.75;1,1;player_hazel_eye.png;btn_hazel_eye;]"..
		"image_button[7.25,3.75;1,1;player_violet_eye.png;btn_violet_eye;]"..
		"style_type[button_exit;bgcolor=#006699;textcolor=white]"..
		"button_exit[4,5;1,1;btn_close;"..S("Close").."]"
	return formspec
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "form:vanity" then
		return
	end
	if not player or fields.quit then
		return
	end
	local player_name = player:get_player_name()
	base_texture = player_api.get_base_texture_table(player)
	local change = false
	if fields.btn_blue_eye then
		base_texture["eye"] = "player_blue_eye.png"
	elseif fields.btn_brown_eye then
		base_texture["eye"] = "player_brown_eye.png"
	elseif fields.btn_green_eye then
		base_texture["eye"] = "player_green_eye.png"
	elseif fields.btn_gray_eye then
		base_texture["eye"] = "player_gray_eye.png"
	elseif fields.btn_hazel_eye then
		base_texture["eye"] = "player_hazel_eye.png"
	elseif fields.btn_violet_eye then
		base_texture["eye"] = "player_violet_eye.png"
	elseif fields.btn_normal_skin then
		base_texture["skin"] = nil
	elseif fields.btn_brown_skin then
		base_texture["skin"] = {color = "#a56d40", ratio = 150}
	elseif fields.btn_black_skin then
		base_texture["skin"] = {color = "#462409", ratio = 127}
	end
	player_api.set_base_texture(player, base_texture)
	player_api.set_texture(player)
	minetest.show_formspec(player_name,
		"form:vanity", vanity.get_vanity_formspec(player))
	return true
end)

-- Vanity Set

minetest.register_node("vanity:vanity", {
    description = S("Vanity Table"),
	drawtype = "mesh",
	mesh = "vanity_set.b3d",
    tiles = {"vanity_vanity.png"},
    paramtype2 = "facedir",
    is_ground_content = false,
    groups = {cracky=3, wood=1},

	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local player_name = player:get_player_name()
		minetest.show_formspec(player_name,
			"form:vanity", vanity.get_vanity_formspec(player))
	end,
})

minetest.register_craft({
	output = "vanity:vanity",
	type = "shaped",
		recipe = {
		{"", "", ""},
		{"", "group:mirror", ""},
		{"", "group:wood", ""},
	}
})
