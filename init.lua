local player_pos = {}
local timer = 0

local AREA = 8

local sounds={
	{name = "air",	sound = ""},
	{name = "fire:basic_flame",	sound = "areasound_fire"},
	{name = "default:lava_source",	sound = "areasound_lava"},
	{name = "default:lava_flowing",	sound = "areasound_lava"},
	{name = "default:water_flowing",sound = "areasound_water_flow"},
	{name = "default:grass_1",	sound = "areasound_crickets"},
	{name = "default:grass_2",	sound = "areasound_crickets"},
	{name = "default:grass_3",	sound = "areasound_crickets"},
	{name = "default:grass_4",	sound = "areasound_crickets"},
	{name = "default:grass_5",	sound = "areasound_crickets"},
	{name = "default:dry_scrub",	sound = "areasound_rattlesnake"},
}

for _,item in ipairs(sounds) do
	if minetest.registered_items[item.name] then
		print("[areasound] 1 = "..item.name)
		print("[areasound] 2 = "..item.sound)
		minetest.override_item(item.name, {areasound = item.sound})
	end
end

minetest.register_globalstep(function(dtime)
	-- Don't check all the time.
	timer = timer + dtime
	if timer < 0.5 then return end
	timer = 0

	for _,player in ipairs(minetest.get_connected_players()) do
		local pos = player:getpos()
		local player_name = player:get_player_name()
		player_pos[player_name] = {
			x = math.floor(pos.x+0.5),
			y = math.floor(pos.y+0.5),
			z = math.floor(pos.z+0.5)
		}
		local r_pos = {
			x = player_pos[player_name].x + math.random(1, AREA),
			y = player_pos[player_name].y + math.random(1, AREA),
			z = player_pos[player_name].z + math.random(1, AREA)
		}
		local r_name = minetest.get_node(r_pos).name
--		print("[areasound] r_name = "..r_name)
		local r_sound = minetest.registered_items[r_name].areasound
		if r_sound then
--			print("[areasound] r_sound = "..r_sound)
			minetest.sound_play(r_sound, {pos=player_pos[player_name], max_hear_distance = AREA})
--			print("[areasound] Bling!")
		else
--			print("[areasound] Zonk!")
		end
	end
end)
