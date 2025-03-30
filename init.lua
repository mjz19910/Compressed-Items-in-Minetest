local path = minetest.get_modpath("compressed")
dofile(path .. "/compress_nodes.lua")
local function run_tmp()
	dofile(path .. "/tmp.lua")
end
pcall(run_tmp)
