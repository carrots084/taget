--[[

TAGET - The 'Text Adventure Game Engine Thingy', used for the creation of simple text adventures
Copyright (C) 2013-2014 Robert Cochran

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 3
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License in the LICENSE file for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

]]

local i = {};

i.type = table.setReadOnly{
	none = 0,
	helmet = 1,
	chestplate = 2,
	leggings = 3,
	boots = 4,
	weapon = 5,
	equipment = 6,
	food = 7,
	misc = 8,
};

local itemTypeToName = table.setReadOnly{
	[i.type.none] = "none",
	[i.type.weapon] = "weapon",
	[i.type.helmet] = "helmet",
	[i.type.chestplate] = "chestplate",
	[i.type.leggings] = "leggings",
	[i.type.boots] = "boots",
	[i.type.equipment] = "equipment",
	[i.type.food] = "food",
	[i.type.misc] = "misc",
};

i.list = {};

function i.initialize()
	i.list = dofile("data/items.txt");
end

function i.getItem(id)
	return i.list[id];
end

function i.listInv(input)
	local inv = taget.player.inventory;

	print("Weapon : "..i.getItem(inv.weapon).name);

	print("\nCurrently wearing : ");
	print("Helmet - "..i.getItem(inv.helmet).name);
	print("Chestplate - "..i.getItem(inv.chestplate).name);
	print("Leggings - "..i.getItem(inv.leggings).name);
	print("Boots - "..i.getItem(inv.boots).name);

	print("\nEquipment : ");

	for id = 1, inv.equipment.limit do
		print(id.." - "..i.getItem(inv.equipment[id]).name);
	end

	print("\nStored : ");

	for id = 1, #inv do
		print(i.getItem(inv[id]).name);
	end

	print();
end

function i.getItemTypeName(id)
	return itemTypeToName[id.type];
end

function i.getItemId(itemType, itemSlot)
	if itemType == "weapon" or itemType == "w" then
		return taget.player.inventory.weapon;
	elseif itemType == "helmet" or itemType == "h" then
		return taget.player.inventory.helmet;
	elseif itemType == "chestplate" or itemType == "c" then
		return taget.player.inventory.chestplate;
	elseif itemType == "leggings" or itemType == "l"  then
		return taget.player.inventory.leggings;
	elseif itemType == "boots" or itemType == "b" then
		return taget.player.inventory.boots;
	elseif itemType == "equipment" or itemType == "e" then
		return taget.player.inventory.equipment[itemSlot];
	elseif itemType == "inventory" or itemType == "i" then
		return taget.player.inventory[itemSlot];
	end
end

function i.getInvItem(storageType, slot)
	local id;

	if tonumber(storageType) then
		id = i.getItemId("inventory", tonumber(storageType));
	else
		id = i.getItemId(storageType, tonumber(slot));
	end

	return i.getItem(tonumber(id));
end

function i.displayInfo(invId)
	local item = i.getInvItem(invId[2], invId[3]);

	if not item then
		print("Item not found!\n");
		return;
	end

	print("Item name - "..item.name);
	print("\nItem type - "..i.getItemTypeName(item));
	print("\nItem description - ");
	io.write(item.description);
	print("\nThis item has properties - ");

	if item.onHit then print("* On hit") end
	if item.onAttack then print("* On attack") end
	if item.onUse then print("* On use") end
	if item.onTurn then print("* On turn") end

	io.write("\n");
end

return i;
