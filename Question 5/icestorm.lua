--Frames for the spell's visual effects. 1 is a larger ice effect while 2 is a smaller ice effect
frames = {
    {  
        {0, 0, 0, 2, 0, 0, 0}, 
        {0, 0, 0, 0, 1, 0, 0}, 
        {0, 0, 0, 0, 0, 2, 0}, 
        {1, 0, 0, 0, 0, 0, 1}, 
        {0, 0, 0, 0, 0, 2, 0}, 
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0} 
    },
    {
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 2, 0, 2, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 2, 0, 0, 0, 0, 0}, 
        {0, 0, 1, 0, 1, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0} 
    },
    {
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 1, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 1, 0, 1, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0} 
    },
    {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 0, 1, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0}, 
        {1, 0, 1, 0, 1, 0, 1}, 
        {0, 0, 0, 2, 0, 0, 0}, 
        {0, 0, 1, 0, 1, 0, 0}, 
        {0, 0, 0, 2, 0, 0, 0} 
    },
    {
        {0, 0, 0, 2, 0, 0, 0}, --repeats
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 2, 0}, 
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 2, 0}, 
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0} 
    },
    {
        {0, 0, 0, 0, 0, 0, 0}, --repeats
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 2, 0, 2, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 2, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0} 
    },

    {
        {0, 0, 0, 0, 0, 0, 0}, --repeats
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 2, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 2, 0, 0, 0} 
    }
}

--Create the combat object that will apply ice damage in a 3x3 circle around the player
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_NONE)
--combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SMALLICE)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))

function onGetFormulaValues(player, level, magicLevel)
    return -99, -99
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

--Iterate through the desired spell effect frame and draw the larger or smaller ice effect based on the value at the x,y coordinate
local function drawFrame(playerPos, index)
    local startPos = Position(playerPos.x - 4, playerPos.y - 4, playerPos.z)
    for y = 1, 7 do
        for x = 1, 7 do
            local position = Position(startPos.x + x, startPos.y + y, startPos.z)
            if frames[index][y][x] == 1 then
                position:sendMagicEffect(CONST_ME_ICEATTACK)
            elseif frames[index][y][x] == 2 then
                position:sendMagicEffect(CONST_ME_ICEAREA)
            end
        end
    end
end

--Called when the player types "friga" in chat and has this spell
function onCastSpell(creature, variant, isHotkey)
    local creatureId = creature:getId()
    local position = creature:getPosition()

    --Draw the initial frame, then schedule the rest of the spell effect frames to play over time
    drawFrame(position, 1)
    addEvent(drawFrame, 200, position, 2)
    addEvent(drawFrame, 400, position, 3)
    addEvent(drawFrame, 600, position, 4)
    addEvent(drawFrame, 800, position, 5)
    addEvent(drawFrame, 1000, position, 6)
    addEvent(drawFrame, 1200, position, 4)
    addEvent(drawFrame, 1400, position, 5)
    addEvent(drawFrame, 1600, position, 6)
    addEvent(drawFrame, 1800, position, 4)

    return combat:execute(creature, variant) --Apply the spell damage after drawing the first effect frame
end