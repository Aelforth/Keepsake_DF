local function print_override(letter, object, vector, type_enum)
	if object then
		local type = object:getType()
		local subtype = object:getSubtype()
		local best_id = nil
		local best_size = #vector.all
		for id,objects in pairs(vector.other) do
			if #objects < best_size then
				for _,other_object in ipairs(objects) do
					if other_object == object then
						best_id = id
						best_size = #objects
						break
					end
				end
			end
		end
		if best_id == 'WORKSHOP_CUSTOM' or best_id == 'FURNACE_CUSTOM' then
			subtype = df.global.world.raws.buildings.all[object:getCustomType()].code
		elseif subtype == -1 then
			subtype = ''
		end
		if best_id then
			print('[OVERRIDE:<old_tile>:' ..
			      letter .. ':' ..
			      best_id ..  ':' .. 
			      type_enum[type] ..  ':' ..
			      subtype ..
			      ':<tileset>:<new_tile>]')
		else
			print('Id not found')
		end

	end
end

print_override('I', dfhack.gui.getSelectedItem(),
	       df.global.world.items,
	       df.item_type)
print_override('B', dfhack.gui.getSelectedBuilding(),
               df.global.world.buildings,
	       df.building_type)

local c = df.global.cursor
local block = dfhack.maps.getTileBlock(c.x, c.y, c.z)
if block then
	local tiletype = block.tiletype[c.x%16][c.y%16]
	print('[OVERRIDE:<old_tile>:T:'..df.tiletype[tiletype]..':<tileset>:<new_tile>]')
end
