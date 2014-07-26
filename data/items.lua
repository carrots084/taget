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

return {
	[0] = {
		name = "None",
		type = taget.item.type.none,
		description = [[
There's nothing here.
]],
	},
	{
		name = "Soulthief",
		type = taget.item.type.weapon,
		description = [[
Soulthief was enchanted long ago with very healthful properties.
Despite Soulthief only dealing 75% of the base damage, its use
stems from having half of this 75% go into you directly as health.
]],
		onAttack = function(a)
			local newDamage = math.ceil(((a * 0.75) / 2));

			if taget.player.health + ((a * 0.75) / 2)
					> taget.player.maxHealth then
				taget.player.health = taget.player.maxHealth;
			else
				taget.player.health = taget.player.health
					+ newDamage;
			end

			return newDamage;
		end,
	},
	{
		name = "Useless Ring of Uselessness",
		type = taget.item.type.equipment,
		description = [[
A useless ring. Greaaat. :/
]],
		onTurn = function()
			print("Your useless ring continues to be so!\n");
		end,
	},
	{
		name = "Worn Helmet",
		type = taget.item.type.helmet,
		description = [[
A really worn down helmet. Not much, but better than nothing...
]],
		onHit = function(a) return (a + 1) end,
	},
	{
		name = "Worn Chestplate",
		type = taget.item.type.chestplate,
		description = [[
A really worn down chestplate. Not much, but better than nothing...
]],
		onHit = function(a) return (a + 1) end,
	},
	{
		name = "Worn Leggings",
		type = taget.item.type.leggings,
		description = [[
Some really worn down leggings. Not much, but better than nothing...
]],
		onHit = function(a) return (a + 1) end,
	},
	{
		name = "Worn Boots",
		type = taget.item.type.boots,
		description = [[
Some really worn down boots. Not much, but better than nothing...
]],
		onHit = function(a) return (a + 1) end,
	},
	{
		name = "Bread",
		type = taget.item.type.food,
		description = [[
Just your average loaf of bread.
]],
		onUse = function()
			local p = taget.player;

			if p.health + 3 < p.maxHealth then
				p.health = p.health + 3;
			else
				p.health = p.maxHealth;
			end

			print("Yum! The bread restored 3 health points!\n");
		end,
	},
};

