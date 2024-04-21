--Q2: Get the names of each guild that has a max member count less than memberCount from the database
local function printSmallGuildNames(memberCount)

	--Query the database and store the result
	local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
	local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))

	--If the query was valid, loop through the results and print each guild's name
	if resultId ~= false then
		repeat
			local guildName = result.getString(resultId, "name")
			print(guildName)
		until not result.next(resultId)

		result.free(resultId) --Clear the results from memory
	end
end