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
	i.type.weapon = "weapon",
	i.type.helmet = "helmet",
	i.type.chestplate = "chestplate",
	i.type.leggings = "leggings",
	i.type.boots = "boots",
	i.type.equipment = "equipment",
	i.type.food = "food",
	i.type.misc = "misc",
};

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

return i;
