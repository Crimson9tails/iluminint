
local LIMITE = 4913

local ANTIGO = "lanterna:lampada_mese"
local NOVO = "air"

minetest.register_chatcommand("fixme", {
    description = "Remove lanterns of mese around of the player",
    params = "Radius limit (2 to 8)",

    func = function(name, param)

        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found"
        end

        local raio = tonumber(param)

        if not raio or raio < 2 or raio > 8 or
           raio ~= math.floor(raio) then
            return false, "Enter an integer between 2 and 8"
        end

        local origem = vector.round(player:get_pos())

        local volume = (raio * 2 + 1) ^ 3

        if volume > LIMITE then
            return false, "Very large region selected"
        end

        local substituidos = 0

        for x = -raio, raio do
            for y = -raio, raio do
                for z = -raio, raio do

                    local pos = {
                        x = origem.x + x,
                        y = origem.y + y,
                        z = origem.z + z
                    }

                    local node = minetest.get_node_or_nil(pos)

                    if node and node.name == ANTIGO and
                       not minetest.is_protected(pos, name) then

                        minetest.set_node(pos, {name = NOVO})
                        substituidos = substituidos + 1

                    end
                end
            end
        end

        return true, "Removed lanterns: " .. substituidos
    end
})

local LIMITE = 4913

local ANTIGO = "lanterna:lampada_mese"
local NOVO = "air"

minetest.register_chatcommand("fixme", {
    description = "Remove mese lamps around the player",
    params = "Radius limit (2 to 8)",

    func = function(name, param)

        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found"
        end

        local raio = tonumber(param)

        if not raio or raio < 2 or raio > 8 or
           raio ~= math.floor(raio) then
            return false, "Enter an integer between 2 and 8"
        end

        local origem = vector.round(player:get_pos())

        local volume = (raio * 2 + 1) ^ 3

        if volume > LIMITE then
            return false, "Very large region selected"
        end

        local substituidos = 0

        for x = -raio, raio do
            for y = -raio, raio do
                for z = -raio, raio do

                    local pos = {
                        x = origem.x + x,
                        y = origem.y + y,
                        z = origem.z + z
                    }

                    local node = minetest.get_node_or_nil(pos)

                    if node and node.name == ANTIGO and
                       not minetest.is_protected(pos, name) then

                        minetest.set_node(pos, {name = NOVO})
                        substituidos = substituidos + 1

                    end
                end
            end
        end

        return true, "Removed lanterns: " .. substituidos
    end
})

