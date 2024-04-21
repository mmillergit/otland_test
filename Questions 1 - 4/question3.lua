--Q3: Remove the player with the name memberName if they're in the party of the player with playerId
function removeMemberFromPlayerParty(playerId, memberName)
	local player = Player(playerId)
	if not player then return end

	local party = player:getParty()
	if party then
		--Loop through the party's members and remove the member with the same name as memberName, if they exist
		for k,v in pairs(party:getMembers()) do
			if v == Player(memberName) then
				party:removeMember(Player(memberName))
				return --Players have unique names, so no need to keep searching if a player was found with the matching name
			end
		end	
	end
end