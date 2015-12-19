local player_pos = {}
local timer = 0

-- Area radius around the player within the sounds nodes get scanned.
local AREA = 8

-- Standard definitions
local crickets ={
	sound = "areasound_crickets",
	time_start = 0.8,
	time_end = 0.2,
}

-- Assinging sounds to nodes
local sounds={
	{name = "fire:basic_flame",	def = {
		sound = "areasound_fire"
	}},
	{name = "default:lava_source",	def = {
		sound = "areasound_lava"
	}},
	{name = "default:lava_flowing",	def = {
		sound = "areasound_lava"
	}},
	{name = "default:water_flowing",def = {
		sound = "areasound_water_flow"
	}},
	{name = "default:water_source",def = {
		sound = "areasound_water_flow"
	}},
	{name = "default:grass_1",	def = crickets},
	{name = "default:grass_2",	def = crickets},
	{name = "default:grass_3",	def = crickets},
	{name = "default:grass_4",	def = crickets},
	{name = "default:grass_5",	def = crickets},
	{name = "default:dry_scrub",	def = {
		sound = "areasound_rattlesnake"
	}},
}

for _,item in ipairs(sounds) do
	if minetest.registered_items[item.name] then
		print("[areasound] 1 = "..item.name)
		print("[areasound] 2 = "..item.def.sound)
		minetest.override_item(item.name, {areasound = item.def})
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
		local r_sound = minetest.registered_items[r_name].areasound.sound
		if r_sound then
--			print("[areasound] r_sound = "..r_sound)
			minetest.sound_play(r_sound, {pos=player_pos[player_name], max_hear_distance = AREA})
		else
		end
	end
end)
