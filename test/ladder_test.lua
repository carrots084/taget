--[[

TAGET - The 'Text Adventure Game Engine Thingy', used for the creation of simple text adventures
Copyright (C) 2013 Robert Cochran

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

package.path = "../src/?.lua;" .. package.path

-- world needs table.setReadOnly()
require("extensions");

-- Pathfinder relies on taget.* namespace
taget = {};

taget.world = require("world");

dungeon = taget.world.generateDungeon(tonumber(arg[1]) or 10, 5, 5);

for i = 1, #dungeon - 1 do
	local ladderX = 0;
	local ladderY = 0;

	for j = 1, #dungeon[1] do
		for k = 1, #dungeon[1][1] do
			if taget.world.getTileType(dungeon, i, j, k)
				== taget.world.room.ladder
			and taget.world.getTileType(dungeon, i + 1, j, k)
				== taget.world.room.ladder
			then
				ladderX = j; ladderY = k;
				goto ladder_break;	
			end
		end
	end

	::ladder_break::;

	if taget.world.getTileType(dungeon, ladderX - 1, ladderY, i) ~= "wall"
		or taget.world.getTileType(dungeon, ladderX + 1, ladderY, i) 
			~= "wall"
		or taget.world.getTileType(dungeon, ladderX, ladderY - 1, i)
			~= "wall"
		or taget.world.getTileType(dungeon, ladderX, ladderY + 1, i)
			~= "wall"
	then
		print("Blockade on floor "..i.."!");
		taget.world.displayFloorMap(dungeon, i, {x = -1, y = -1}, true);
	end
end

print("Everything looks okay");
