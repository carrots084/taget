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

local m = {};

taget.encounter = nil;


function m.initialize()
	m.list = dofile("data/monsters.txt");
end

local function createEncounter()
	math.randomseed(os.time());
	local encounterChance = math.random(1, 100);
	local monsterNum = math.random(1, #m.list);

	if m.list[monsterNum].startFloor <= taget.player.z and encounterChance <= m.list[monsterNum].rarity then
		taget.encounter = table.copy(m.list[monsterNum]);

		taget.encounter.baseHealth = (taget.player.z == 1) and taget.encounter.baseHealth or math.floor(taget.encounter.baseHealth * ((taget.player.z + 1) / 2));
		taget.encounter.baseAttack = (taget.player.z == 1) and taget.encounter.baseAttack or math.floor(taget.encounter.baseAttack * ((taget.player.z + 1) / 2));
		taget.encounter.baseDefense = (taget.player.z == 1) and taget.encounter.baseDefense or math.floor(taget.encounter.baseDefense * ((taget.player.z + 1) / 2));
		taget.encounter.baseExp = (taget.player.z == 1) and taget.encounter.baseExp or math.floor(taget.encounter.baseExp * ((taget.player.z + 1) / 2));

		taget.encounter.x = taget.player.x;
		taget.encounter.y = taget.player.y;
		taget.encounter.z = taget.player.z;
	
		print("A random "..taget.encounter.name.." has appeared!\n");
	end
end

function m.processEncounter()
	if not taget.encounter then
		if taget.world.getTileType(taget.dungeon, taget.player.x, taget.player.y, taget.player.z) == "boss" then
			taget.encounter = table.copy(m.list.boss);

			taget.encounter.x = taget.player.x;
			taget.encounter.y = taget.player.y;
			taget.encounter.z = taget.player.z;

			print("The dungeon boss "..taget.encounter.name.." has appeared!\n");
		else
			createEncounter();
		end
	else
		if taget.encounter.x ~= taget.player.x or taget.encounter.y ~= taget.player.y or taget.encounter.z ~= taget.player.z then
			taget.encounter = nil;
			return;
		end

		if taget.encounter.baseHealth <= 0 then
			print("Defeated the "..taget.encounter.name.."!");
			
			if taget.encounter.name == m.list.boss.name then
				print("You win!");
				os.exit();
			end

			taget.player.experience = taget.player.experience + taget.encounter.baseExp;
			print("Got "..taget.encounter.baseExp.." experience points!\n");

			taget.encounter = nil;

			if taget.player.experience >= taget.player.nextLevel then
				taget.player.level = taget.player.level + 1;
				print("Got to level "..taget.player.level.."!");
				taget.player.nextLevel = taget.player.nextLevel + (25 * taget.player.level);
				taget.input.chooseLevelUp();
			end

			print("Next level : "..(taget.player.nextLevel - taget.player.experience).." more experience points\n");
			return;
		end

		local strength = math.random(taget.encounter.baseAttack);
		local defense = math.random(taget.player.defense);

		if strength - defense > -1 then
			taget.player.health = taget.player.health - (strength - defense);
		else
			-- Set them to dummy values that come out to 0
			strength = 1; defense = 1;
		end

		print("The "..taget.encounter.name.." hit you for "..(strength - defense).." damage!");
		print("You have "..taget.player.health.." hit points left!\n");

		if taget.player.health <= 0 then
			print("Game over! You died!");
			os.exit();
		end
	end
end

return m;
