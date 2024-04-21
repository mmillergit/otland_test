--Get the tile ahead of the player and return its location and whether the player can dash to it or not
local function getForwardTile(position, direction)
    forwardPosition = position
    if direction == NORTH then
        forwardPosition.y = forwardPosition.y - 1
    elseif direction == EAST then
        forwardPosition.x = forwardPosition.x + 1
    elseif direction == SOUTH then
        forwardPosition.y = forwardPosition.y + 1
    elseif direction == WEST then
        forwardPosition.x = forwardPosition.x - 1
    end
    
    --If the tile doesn't exist or it's not considered ground, return false to stop the player from dashing anymore
    tile = Tile(forwardPosition)
    if not tile then
        return nil, false
    end

    if not tile:isWalkable() then
        return nil, false
    end

    return forwardPosition, true
end

--The player instantly moves the title ahead of them, repeating until they either hit a wall or move across 6 tiles
local function playerDash(playerId, currentTilePos, dashCount)
    player = Player(playerId)
    if not player or dashCount > 6 then
        return
    end

    nextTilePos, isGround = getForwardTile(currentTilePos, player:getDirection())

    --If the tile ahead of the player is ground, move them there instantly
    if isGround then
        player:teleportTo(nextTilePos, false)
        addEvent(playerDash, 1, playerId, nextTilePos, dashCount + 1) --Schedule the next call to this function, passing the new tile we dashed to and increasing the dash count
    end
end

--Initiate the first dash action upon using the item
function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    playerDash(player:getId(), player:getPosition(), 0)
	return true
end