local generated_graphics_file=dfhack.getSavePath()..'/raw/graphics/graphics_procedural.txt'

if dfhack.filesystem.exists(generated_graphics_file) and not ...=='force' then qerror('Procedural graphics already exist!') end

local titans={} --also FBs

local demons={}

local angels={}

for k,v in ipairs(df.global.world.raws.creatures.all) do
    if v.flags.GENERATED then 
        if v.flags.CASTE_TITAN or v.flags.CASTE_FEATURE_BEAST then
            table.insert(titans,v)
        elseif v.flags.CASTE_DEMON or v.flags.CASTE_UNIQUE_DEMON then
            table.insert(demons,v)
        elseif v.source_hfid~=-1 then
            table.insert(angels,v)
        else
            table.insert(titans,v) --in the weird case
        end
    end
end

local tile_pages={
    angel={
        name="angels",
        file="placeholder/placeholder.png",
        TILE_DIM={16,16},
        PAGE_DIM={15,15}
    },
    demon={
        name="demons",
        file="placeholder/placeholder.png",
        TILE_DIM={16,16},
        PAGE_DIM={15,15}
    },
    titan={
        name="titans",
        file="placeholder/placeholder.png",
        TILE_DIM={16,16},
        PAGE_DIM={15,15}
    }
}

local graphics_file=[[graphics_generated

[OBJECT:GRAPHICS] ]]

for k,v in pairs(tile_pages) do
    graphics_file=graphics_file..'\n\n[TILE_PAGE:'..v.name..[[]
    [FILE:]]..v.file..[[]
    [TILE_DIM:]]..v.TILE_DIM[1]..':'..v.TILE_DIM[2]..[[]
    [PAGE_DIM:]]..v.PAGE_DIM[1]..':'..v.PAGE_DIM[2]..']'
end

local rng=dfhack.random.new()

for k,v in ipairs(titans) do
    graphics_file=graphics_file..'\n\n[CREATURE_GRAPHICS:'..v.creature_id..']\n'
    graphics_file=graphics_file..'    [DEFAULT:'..tile_pages.titan.name..':'..rng:random(tile_pages.titan.PAGE_DIM[1])..':'..rng:random(tile_pages.titan.PAGE_DIM[2])..':AS_IS]'
end

for k,v in ipairs(angels) do
    graphics_file=graphics_file..'\n\n[CREATURE_GRAPHICS:'..v.creature_id..']\n'
    graphics_file=graphics_file..'    [DEFAULT:'..tile_pages.angel.name..':'..rng:random(tile_pages.angel.PAGE_DIM[1])..':'..rng:random(tile_pages.angel.PAGE_DIM[2])..':AS_IS]'
end

for k,v in ipairs(demons) do
    graphics_file=graphics_file..'\n\n[CREATURE_GRAPHICS:'..v.creature_id..']\n'
    graphics_file=graphics_file..'    [DEFAULT:'..tile_pages.demon.name..':'..rng:random(tile_pages.demon.PAGE_DIM[1])..':'..rng:random(tile_pages.demon.PAGE_DIM[2])..':AS_IS]'
end

actual_graphics_file=io.open(generated_graphics_file,'w')

actual_graphics_file:write(graphics_file)

actual_graphics_file:close()