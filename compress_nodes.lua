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
		output = def.one,
		recipe = {
			def.many, def.many, def.many,
			def.many, def.many, def.many,
			def.many, def.many, def.many,
		},
	})
	minetest.register_craft({
		type = "shapeless",
		output = def.many .. " 9",
		recipe = {def.one}
	})
end

if minetest.get_modpath("default") then

	local S = default.get_translator


	minetest.register_craftitem("compressed:default_grass_1", {
		description = "Compressed Grass",
		inventory_image = "compressed_default_grass_1.png"
	})
	register_crafting_pair_9to1({
		many = "default:grass_1",
		one = "compressed:default_grass_1",
	})
	minetest.register_node("compressed:default_bush_leaves", {
		description = "Compressed Bush Leaves",
		drawtype = "allfaces_optional",
		tiles = {"compressed_default_leaves_simple.png"},
		paramtype = "light",
		groups = {snappy = 3},
		drop = "compressed:default_bush_leaves",
		sounds = default.node_sound_leaves_defaults(),
		after_place_node = default.after_place_leaves,
	})
	register_crafting_pair_9to1({
		many = "default:bush_leaves",
		one = "compressed:default_bush_leaves",
	})
	minetest.register_node("compressed:default_leaves", {
		description = "Compressed Apple Tree Leaves",
		drawtype = "allfaces_optional",
		tiles = {"compressed_default_leaves.png"},
		paramtype = "light",
		groups = {snappy = 3},
		drop = "compressed:default_leaves",
		sounds = default.node_sound_leaves_defaults(),
		after_place_node = default.after_place_leaves,
	})
	register_crafting_pair_9to1({
		many = "default:leaves",
		one = "compressed:default_leaves",
	})
	minetest.register_node("compressed:default_tree", {
		description = S("Compressed Apple Tree"),
		tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
		sounds = default.node_sound_wood_defaults(),
		on_place = minetest.rotate_node,
	})
	register_crafting_pair_9to1({
		many = "default:tree",
		one = "compressed:default_tree",
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
