-- Don't have any translations
local function S(string)
	return string
end

local function rep(item, count)
	local ret = {}
	for i = 1, count do
		ret[i] = item
	end
	return ret
end

local function compressed_craftitem(def, item)
	item = item:gsub(":", "_")
	local compressed_item = "compressed:" .. item
	def.inventory_image = compressed_item:gsub(":", "_") .. ".png"
	-- register the compressed item
	minetest.register_craftitem(compressed_item, def)
end

local function register_crafting_up_to_count(def)
	minetest.register_craft({
		type = "shapeless",
		output = def.many .. " " .. def.count,
		recipe = {def.one}
	})
end

local function register_crafting_count_many_to_one(def)
	local recipe = {}
	for i = 1, def.count do
		recipe[i] = def.many
	end
	minetest.register_craft({
		type = "shapeless",
		output = def.one,
		recipe = recipe,
	})
end

local function register_crafting_pair_9to1(def)
	minetest.register_craft({
		type = "shapeless",
		output = def[2],
		recipe = rep(def[1], 9),
	})
	minetest.register_craft({
		type = "shapeless",
		output = def[1] .. " 9",
		recipe = {def[2]}
	})
end

local function def_compressed_node(def, info)
	local cur_def = table.copy(def)
	cur_def.description = info.extra .. "Compressed " .. def.description
	local cur_name = "compressed:" .. info.item_name .. ":x" .. info.count
	cur_def.drop = cur_name
	minetest.register_node(":" .. cur_name, cur_def)
	register_crafting_pair_9to1({info.prev_name, cur_name})
	return cur_name
end

local function register_compressed_node(item_name, def)
	local cur_name = item_name
	cur_name = def_compressed_node(def, {
		item_name = item_name,
		prev_name = cur_name,
		count = 1,
		extra = ""
	})
	cur_name = def_compressed_node(def, {
		item_name = item_name,
		prev_name = cur_name,
		count = 2,
		extra = "Double "
	})
	cur_name = def_compressed_node(def, {
		item_name = item_name,
		prev_name = cur_name,
		count = 3,
		extra = "Triple "
	})
	cur_name = def_compressed_node(def, {
		item_name = item_name,
		prev_name = cur_name,
		count = 4,
		extra = "Quadruple "
	})
end

local function consume_from_registered_items()
	local register_list = {
		"default:cobble",
		"default:gravel",
		"default:stone_crumbled",
		-- Apple Tree
		"default:tree",
		"default:leaves",
		"default:sapling",
		-- Jungle Tree
		"default:jungletree",
		"default:jungleleaves",
		"default:junglesapling",
		-- Pine Tree
		"default:pine_tree",
		"default:pine_needles",
		"default:pine_sapling",
		-- Aspen Tree
		"default:aspen_tree",
		"default:aspen_leaves",
		"default:aspen_sapling",
		-- Acacia Tree
		"default:acacia_tree",
		"default:acacia_leaves",
		"default:acacia_sapling",
	}
	for k, v in pairs(register_list) do
		local node = minetest.registered_items[v]
		if node then
			register_compressed_node(node.name, node)
		end
	end
end

if minetest.get_modpath("default") then
	minetest.register_alias("compressed:default_grass_1", "compressed:default:grass_1:x1")
	minetest.register_craftitem(":compressed:default:grass_1:x1", {
		description = "Compressed Grass",
		inventory_image = "compressed_default_grass_1.png"
	})
	register_crafting_pair_9to1({
		"default:grass_1",
		"compressed:default:grass_1:x1",
	})
	register_compressed_node("default:bush_leaves", {
		description = "Bush Leaves",
		drawtype = "allfaces_optional",
		tiles = {"compressed_default_leaves_simple.png"},
		paramtype = "light",
		groups = {snappy = 3},
		sounds = default.node_sound_leaves_defaults(),
		after_place_node = default.after_place_leaves,
	})

	-- minetest.clear_craft({
	-- 	recipe = {
	-- 		{"group:leaves", "group:leaves", "group:leaves"},
	-- 		{"group:leaves", "default:aspen_leaves", "group:leaves"},
	-- 		{"group:leaves", "group:leaves", "group:leaves"}
	-- 	}
	-- })
	-- minetest.clear_craft({
	-- 	output = "default:emergent_jungle_sapling"
	-- })
	minetest.register_craft({
		type = "shapeless",
		output = "default:junglesapling 9",
		recipe = {"default:emergent_jungle_sapling"}
	})

	consume_from_registered_items()

	minetest.register_craft({
		type = "shapeless",
		output = "default:emergent_jungle_sapling 9",
		recipe = {"compressed:default:junglesapling:x2"}
	})
	minetest.register_craft({
		type = "shapeless",
		output = "compressed:default:junglesapling:x2",
		recipe = rep("default:emergent_jungle_sapling", 9)
	})
end

if minetest.get_modpath("too_many_stones") then
	register_compressed_node("too_many_stones:granite_black_cobble", {
		description = "Black Granite Cobble",
		tiles = {"tms_granite_black_cobble.png"},
		is_ground_content = false,
		groups = {cracky = 3, stone = 2, granite = 1},
		sounds = too_many_stones.node_sound_stone_defaults(),
	})
end

if minetest.get_modpath("default") and minetest.get_modpath("farming") then
	register_crafting_up_to_count({
		many = "default:stick",
		one = "farming:beanpole",
		count = 4,
	})

	register_crafting_up_to_count({
		many = "default:stick",
		one = "farming:trellis",
		count = 9,
	})
end

if minetest.get_modpath("everness") then
	minetest.register_craft({
		output = "everness:mese_tree",
		recipe = {
			{"everness:mese_wood", "everness:mese_wood"},
			{"everness:mese_wood", "everness:mese_wood"}
		}
	})
end

if minetest.get_modpath("mts_default") then
	register_crafting_up_to_count({
		many = "mts_default:pebble",
		one = "mts_default:rock",
		count = 5,
	})
end

