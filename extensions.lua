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

function table.setReadOnly(t)
	if type(t) ~= "table" then error("Expected table, got "..type(t), 2) end

	local p = {};

	local m = {
		__index = t,
		__newindex = function()
			error("Attempted write to read-only table!", 2);

		end
	}

	setmetatable(p, m);

	return p;
end

function table.copy(t)
	if type(t) ~= "table" then error("Expected table, got "..type(t), 2) end

	local nt = {};

	for k, v in pairs(t) do
		nt[k] = v;
	end

	return nt;
end
