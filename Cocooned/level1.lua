-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

module("level1", package.seeall)

local lines = {}
local oldLines = {}
local room

function pane(room)
	--print("Room = ", room)
	if room == "main" then
		print("main")
		init(main)
		destroy(lines)
		last = main
	elseif room == "a" then
		init(a)
		destroy(last)
		last = a
	elseif room == "b" then
		init(b)
		destroy(lines)
		last = b
	elseif room == "c" then
		init(c)
		destroy(lines)
		last = c
	elseif room == "d" then
		init(d)
		destroy(lines)
		last = d
	end
end

function init(room) 
	
	if room == main then
		-- Draw lines
		lines = {
			-- Rectangles for initial pane on 
			-- left and right side
			[1] = display.newRect(70, 180, 20, 575) ,
			[2] = display.newRect(410, 180, 20, 575), 

			-- Rectangles for the walls blocking
			-- the area on the left and right side
			[3] = display.newRect(15, 200, 85, 15) ,
			[4] = display.newRect(465, 100, 85, 15) , 

			-- Rectangles for the center column
			[5] = display.newRect(130, 180, 20, 400) , 
			[6] = display.newRect(350, 180, 20, 400) ,

			-- Horizontal rectangles for center column
			[7] = display.newRect(240, 225, 200, 15) ,
			[8] = display.newRect(240, 100, 200, 15) }
		
		oldLines = lines
		destroy(lines)
	elseif room == a then
		lines = {
			-- Rectangles for initial pane on 
			-- left and right side
			[1] = display.newRect(70, 180, 20, 575) ,
			[2] = display.newRect(410, 180, 20, 575) }
		oldLines = lines
	elseif room == b then
		lines = {
			-- Rectangles for initial pane on 
			-- left and right side
			[1] = display.newRect(70, 180, 20, 575) ,
			[2] = display.newRect(410, 180, 20, 575), 

			-- Rectangles for the walls blocking
			-- the area on the left and right side
			[3] = display.newRect(-10, 200, 35, 15) ,
			[4] = display.newRect(465, 100, 85, 15) }
		oldLines = lines
	elseif room == c then
		lines = {
			-- Rectangles for the walls blocking
			-- the area on the left and right side
			[1] = display.newRect(15, 200, 85, 15) ,
			[2] = display.newRect(440, 100, 35, 15) }
		oldLines = lines
	elseif room == d then
		lines = {
			-- Rectangles for inital pane on 
			-- left and right side
			[1] = display.newRect(70, 180, 20, 575) ,
			[2] = display.newRect(410, 180, 20, 575), 

			-- Rectangles for the walls blocking
			-- the area on the left and right side
			[3] = display.newRect(15, 200, 85, 15) ,
			[4] = display.newRect(440, 100, 35, 15) }
		oldLines = lines
		destroy(lines)
	end
		
	--for count = 1, 8, 1 do
	--	gameLoop.group:insert(lines[count])
	--end
	
	print("lines = ", #lines)
	
	-- apply physics to lines
	for count = 1, #lines do 
		physics.addBody(lines[count], "static", { bounce = 0.01 } )
	end
	
	--return lines
end

function destroy(oldLines)
	--lines = oldLines
	print("oldLines =", oldLines)
	for count = 1, #lines do
		print("destroy lines =", lines[count])
		physics.removeBody(lines[count])
	end	
end