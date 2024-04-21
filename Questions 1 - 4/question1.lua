--Q1: If the player has an item(s) with ID 1000, remove it from them
function onLogout(player)
	
	--Originally an event, but passing the player variable was unsafe and it can be done safely on logout
	if player:getStorageValue(1000) == 1 then
		player:setStorageValue(1000, -1)
	end

	return true
end