
-- CONFIGURACAO
local HABILITADO = true
local INTERVALO = 120
local ALTURA = 4
local TOCHAS = 3

-- ESTADO
local ativo = false
local jogador_ativo = nil
local lampada_pos = nil
local ciclo_id = 0

local LAMPADA = "iluminint:lampada_mese"

-- REGISTRAR LAMPADA DE MESE
minetest.register_node(LAMPADA, {
    description = "Lampada de Mese",
    drawtype = "normal",
    tiles = {"default_mese_block.png"},
    paramtype = "light",
    sunlight_propagates = true,
    light_source = 14,
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = false,
    groups = {
        not_in_creative_inventory = 1
    },
    drop = "",
})

-- REMOVER LAMPADA
local function remover_lampada()
    if not lampada_pos then
        return
    end

    local node = minetest.get_node_or_nil(lampada_pos)

    if node and node.name == LAMPADA then
        minetest.remove_node(lampada_pos)
    end

    lampada_pos = nil
end

-- ENTREGAR TOCHAS
local function entregar_tochas(player)
    local inv = player:get_inventory()

    local sobra = inv:add_item(
        "main",
        "default:torch " .. TOCHAS
    )

    if not sobra:is_empty() then
        minetest.add_item(player:get_pos(), sobra)
    end
end

-- EXECUTAR CICLO
local function executar_ciclo(id)

    if not ativo or id ~= ciclo_id then
        return
    end

    local player = minetest.get_player_by_name(
        jogador_ativo
    )

    if player then

        local pos = player:get_pos()

        local destino = vector.round({
            x = pos.x,
            y = pos.y + ALTURA,
            z = pos.z
        })

        local node = minetest.get_node_or_nil(destino)

        local protegido = minetest.is_protected(
            destino,
            jogador_ativo
        )

        if node and node.name == "air" and not protegido then

            -- GUARDAR COORDENADAS EXATAS
            lampada_pos = {
                x = destino.x,
                y = destino.y,
                z = destino.z
            }

            -- CRIAR LAMPADA
            minetest.set_node(destino, {
                name = LAMPADA
            })

        else

            -- POSICAO OCUPADA OU INDISPONIVEL
            entregar_tochas(player)

        end
    end

    -- AGUARDAR 2 MINUTOS
    minetest.after(INTERVALO, function()

        if id ~= ciclo_id then
            return
        end

        -- REMOVER LAMPADA ANTERIOR
        remover_lampada()

        -- REPETIR
        if ativo then
            executar_ciclo(id)
        end

    end)
end

-- ATIVAR
minetest.register_chatcommand("l_on", {
    description = "Turn on lantern system",
params = "Turn on",

    func = function(name, param)

        if not HABILITADO then
            return false, "System disabled"
        end

        if ativo then
            return false, "System is already active"
        end

        ativo = true
        jogador_ativo = name

        ciclo_id = ciclo_id + 1

        executar_ciclo(ciclo_id)

        return true, "Lantern enabled"
    end
})

-- DESATIVAR
minetest.register_chatcommand("l_off", {
    description = "Turn off lantern system",
    params = "Turn off",

    func = function(name, param)

        ativo = false
        ciclo_id = ciclo_id + 1

        remover_lampada()

        return true, "Lantern disabled"
    end
})

dofile(minetest.get_modpath("iluminint") .. "/fixme.lua")
