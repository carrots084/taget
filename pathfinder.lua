local p = {};

local endpoints = {};

function p.createEndpoint(floor, x, y)
	if type(floor) ~= "number" then
		error("floor - expected number, got "..type(x), 2);
	end

	if type(x) ~= "number" then
		error("x - expected number, got "..type(x), 2);
	end

	if type(y) ~= "number" then
		error("y - expected number, got "..type(y), 2);
	end

	if type(endpoints[floor]) ~= "table" then
		endpoints[floor] = {};
	end
	
	endpoints[floor][#endpoints + 1] = { x = x, y = y, };
end

local function displaySpecialMap(floor)
	for j = 1, #floor[1] do
		for i = 1, #floor do
			io.write(floor[i][j]);
		end
		
		io.write("\n");
	end
end

local function addPathStep(path, directionWent)
	if type(path) ~= "table" then
		error("path - expected table, got "..type(path), 2);
	end
	
	if type(directionWent) ~= "number" then
		error("directionWent - expected number, got "..type(path), 2);
	end
	
	path[#path].hasGone[directionWent] = true;
	
	local x, y = path[#path].x, path[#path].y;
	
	if directionWent == taget.world.direction.north then
		y = y - 1;
	elseif directionWent == taget.world.direction.east then
		x = x + 1;
	elseif directionWent == taget.world.direction.south then
		y = y + 1;
	elseif directionWent == taget.world.direction.west then
		x = x - 1;
	end
	
	path[#path + 1] = {
		x = x,
		y = y,
		hasGone = {
			[taget.world.direction.north] = false,
			[taget.world.direction.east] = false,
			[taget.world.direction.south] = false,
			[taget.world.direction.west] = false,
		},
	};
end

function p.wallIsOk(dungeon, specials, floor, isFirstFloor)
	local startX, startY = -1, -1;

	-- Find startpoint
	if isFirstFloor then
		-- Easy
		startX = math.ceil(#dungeon[1] / 2);
		startY = math.ceil(#dungeon[1][1] / 2);
	else
		-- Iterate through until we find a ladder, on this and the floor above
		for a = 1, #dungeon[1] do
			for b = 1, #dungeon[1][1] do
				if dungeon[floor][a][b].type == taget.world.room.ladder and dungeon[floor - 1][a][b].type == taget.world.room.ladder then
					startX = a;
					startY = b;
					goto location_breakout;
				end
			end
		end
	end

	::location_breakout::;

	if startX == -1 or startY == -1 then error("Did not find starting locations for floor "..floor.."!", 2) end

	-- Loop through all of the endpoints
	
	local didPass = true;
	
	for _, endpoint in pairs(endpoints[floor]) do
		--[[
			Set up our path. Fill in the first step by hand so that the
			direction checking logic doesn't choke on values that don't
			exist
		]]
		
		local path = {
			[1] = {
				x = startX,
				y = startY,
				hasGone = {
					[taget.world.direction.north] = false,
					[taget.world.direction.east] = false,
					[taget.world.direction.south] = false,
					[taget.world.direction.west] = false,
				},
			}
		};
		
		local costF = {};
		
		local times = 0;
		
		while true do
			local lowestCost = math.huge;
			local lowestDirection = -1;

			if not path[#path].hasGone[taget.world.direction.north] and (path[#path].y > 1 and specials[floor][path[#path].x][path[#path].y - 1] ~= 0) then
				costF[taget.world.direction.north] = #path + math.abs(path[#path].x - endpoint.x) + math.abs((path[#path].y - 1) - endpoint.y);
			else
				costF[taget.world.direction.north] = math.huge;
			end

			if not path[#path].hasGone[taget.world.direction.east] and (path[#path].x < #specials[1][1] and specials[floor][path[#path].x + 1][path[#path].y] ~= 0) then
				costF[taget.world.direction.east] = #path + math.abs((path[#path].x + 1) - endpoint.x) + math.abs(path[#path].y - endpoint.y);
			else
				costF[taget.world.direction.east] = math.huge;
			end

			if not path[#path].hasGone[taget.world.direction.south] and (path[#path].y < #specials[1] and specials[floor][path[#path].x][path[#path].y + 1] ~= 0) then
				costF[taget.world.direction.south] = #path + math.abs(path[#path].x - endpoint.x) + math.abs((path[#path].y + 1) - endpoint.y);
			else
				costF[taget.world.direction.south] = math.huge;   
			end

			if not path[#path].hasGone[taget.world.direction.west] and (path[#path].x > 1 and specials[floor][path[#path].x - 1][path[#path].y] ~= 0) then
				costF[taget.world.direction.west] = #path + math.abs((path[#path].x - 1) - endpoint.x) + math.abs(path[#path].y - endpoint.y);
			else
				costF[taget.world.direction.west] = math.huge;
			end
			
			for a = 1, 4 do
				for b = 1, 4 do
					if costF[a] < costF[b] then
						if costF[a] < lowestCost then
							lowestCost = costF[a];
							lowestDirection = a;
						end
					end
				end
			end
			
			if not path[#path].hasGone[lowestDirection] then
				addPathStep(path, lowestDirection);
			else
				path[#path] = nil;
			end
			
			if path[#path].x == endpoint.x and path[#path].y == endpoint.y then
				goto for_continue;
			end
			
			if times > (#dungeon[1] * #dungeon[1][1]) * 2 then
				didPass = false;
				goto for_break;
			end
			
			times = times + 1;
		end
		::for_continue::;
	end
	
	::for_break::;
	return didPass;
end

return p;
