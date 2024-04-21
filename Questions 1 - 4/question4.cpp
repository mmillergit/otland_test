//Q4: Add the item with itemId to the player with the name of the recipient string
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
	//First try finding the player by name. If they're offline, try loading them
	Player* player = g_game.getPlayerByName(recipient);
	if (!player)
    {
	    player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient))
        {
            delete player; //Allocated memory for a player that doesn't exist, so deallocate the memory or else it causes a leak
            return;
        }
	}

	Item* item = Item::CreateItem(itemId);
	if (!item)
		return;

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline())
    {
        IOLoginData::savePlayer(player);

        //Player's state has been saved, but they're offline. The reference to the player and item no longer need to be kept around, so they can be deleted
        delete player;
        delete item;
    }
}