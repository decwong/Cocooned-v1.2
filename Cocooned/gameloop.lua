-----------------------------------------------------------------------------------------
--
-- gameloop.lua
--
-----------------------------------------------------------------------------------------

require("ballVariables")
require("level1")

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget");

print("Storyboard", storyboard)

local font = "Helvetica" or system.nativeFont;
display.setStatusBar(display.HiddenStatusBar)

--------------------------------------------
-- Include Corona's "physics" library
--------------------------------------------
local physics = require "physics"
physics.start(); physics.pause()

--------------------------------------------
-- Set view mode to show bounding boxes
--------------------------------------------
physics.setDrawMode("hybrid")

--------------------------------------------
-- Forward declarations and other locals
--------------------------------------------
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

--------------------------------------------
-- Initialize game objects:
--      * Balls.
--------------------------------------------
local ballTable = { 
		[1] = display.newImage("ball.png"), 
		[2] = display.newImage("ball.png") }
		
--------------------------------------------------------------------------------
-- Walls:
-- 		* Initialize & draw walls.
-- 		* Temp wall image from: http://protextura.com/wood-plank-cartoon-11130
--------------------------------------------------------------------------------
local walls = {
	[1] = display.newImage("ground1.png"),
	[2] = display.newImage("ground1.png"),
	[3] = display.newImage("ground2.png"),
	[4] = display.newImage("ground2.png") 
} 

	-- Left wall
	walls[1].x = -40
	walls[1].y = 180
	walls[1].rotation = 90

	-- Right wall
	walls[2].x = 520
	walls[2].y = 180
	walls[2].rotation = 90
		
	-- Top wall
	walls[3].x = 250
	walls[3].y = 5
		
	-- Bottom wall
	walls[4].x = 250
	walls[4].y = 315	

--------------------------------------------	
-- Apply physics to walls.
--------------------------------------------	
for count = 1, 4, 1 do
	
	-- if count <= 2 then
	--	  walls[count].rotation = 90
	--  end
	
	physics.addBody(walls[count], "static", { bounce = 0.01 } )
end
		
--------------------------------------------	
-- Save ball locations.
--------------------------------------------
local function saveBallLocation()
	ballVariables.setBall1(ballTable[1].x, ballTable[1].y)
	ballVariables.setBall2(ballTable[2].x, ballTable[2].y)
end

--------------------------------------------	
-- Calculate Distance
--------------------------------------------
local dist
local function distance(x1, x2, y1, y2, detectString)
	dist = math.sqrt( ((x2-x1)^2) + ((y2-y1)^2) )
	if detectString then
		--print(detectString, dist)
	end
end

--------------------------------------------
-- Accelerometer movement
--------------------------------------------
local function onAccelerate( event )
	local xGrav=1
	local yGrav=1
	if event.yInstant > 0.1 then
		xGrav = -1
	elseif event.yInstant < -0.1 then
		xGrav = 1
	elseif event.yGravity > 0.1 then
		xGrav = -1
	elseif event.yGravity < -0.1 then
		xGrav = 1
		else
			xGrav = 0
	end
	if event.xInstant > 0.1 then
		yGrav = -1
	elseif event.xInstant < -0.1 then
		yGrav = 1
	elseif event.xGravity > 0.1 then
		yGrav = -1
	elseif event.xGravity < -0.1 then
		yGrav = 1
		else
			yGrav = 0
	end
	physics.setGravity(12*xGrav, 16*yGrav)
end

   accelerometerON = true
if accelerometerON == true then
	Runtime:addEventListener( "accelerometer", onAccelerate )
end

--------------------------------------------------------
-- Collision Detection for every frame during game time
--------------------------------------------------------
local function frame(event)
	
	-- send both ball position values to distance function
	distance(ballTable[1].x, ballTable[2].x, ballTable[1].y, ballTable[2].y)
	
	-- When less than distance of 35 pixels, do something
	-- 			Used print as testing. Works successfully!
	if dist <= 35 then
		print("Distance =", dist)
	end
end

--------------------------------------------------------
-- Ball movement control
--------------------------------------------------------
local function moveBall(event, current)
	
	--local levels = require("level1")
	
	local x 
	local y
	local tap = 0
		
	--find distance from start touch to end touch
	local dx = event.x - event.xStart
	local dy = event.y - event.yStart
		

	--checking if touch was a tap touch and not a swipe
	if dx < 5 then
		if dx > -5 then
			if dy < 5 then
				if dy > -5 then
					tap = 1
				end
			end
		end
	end
		
	if tap == 1 then
		if event.phase == "ended" then
			for count = 1, 2, 1 do
		
			-- send mouse/ball position values to distance function
			distance(event.x, ballTable[count].x, event.y, ballTable[count].y, "Mouse to Ball Distance: ")
			
			-- if it is taking too many tries to move the ball, increase the distance <= *value*
			if dist <= 100 then
					x = event.x - ballTable[count].x;
					y = event.y - ballTable[count].y;
					--print (x, y)
					if x < 0 then
						if x > -30 then
							if y > 0 then
								ballTable[count]:applyLinearImpulse(0,-0.05, ballTable[count].x, ballTable[count].y)
							elseif y < 0 then
								ballTable[count]:applyLinearImpulse(0,0.05, ballTable[count].x, ballTable[count].y)
							end
						elseif y >0 then
							if y < 30 then
								ballTable[count]:applyLinearImpulse(0.05, 0, ballTable[count].x, ballTable[count].y)
							else
								ballTable[count]:applyLinearImpulse(0.05, -0.05 ,ballTable[count].x, ballTable[count].y)
							end
						elseif y < 0 then
							if y > -30 then
								ballTable[count]:applyLinearImpulse(0.05, 0, ballTable[count].x, ballTable[count].y)
							else
								ballTable[count]:applyLinearImpulse( 0.05, 0.05, ballTable[count].x, ballTable[count].y)
							end
						end
					elseif x > 0 then
						if x < 30 then
							if y > 0 then
								ballTable[count]:applyLinearImpulse(0,-0.05, ballTable[count].x, ballTable[count].y)
							elseif y < 0 then
								ballTable[count]:applyLinearImpulse(0,0.05, ballTable[count].x, ballTable[count].y)
							end
						elseif y < 0 then
							if y > -30 then
								ballTable[count]:applyLinearImpulse(-0.05, 0, ballTable[count].x, ballTable[count].y)
							else
								ballTable[count]:applyLinearImpulse( -0.05, 0.05, ballTable[count].x, ballTable[count].y)
							end
						elseif y > 0 then
							if y < 30 then
								ballTable[count]:applyLinearImpulse(-0.05, 0, ballTable[count].x, ballTable[count].y)
							else
								ballTable[count]:applyLinearImpulse( -0.05, -0.05, ballTable[count].x, ballTable[count].y)
							end
						end
					end
				end
			end
		end
	elseif tap == 0 then
		local swipeLength = math.abs(event.x - event.xStart)
		local swipeLengthy = math.abs(event.y - event.yStart)
		--print(event.phase, swipeLength)
		local t = event.target
		local phase = event.phase
		if "began" == phase then
			return true
		elseif "moved" == phase then
		elseif "ended" == phase or "cancelled" == phase then
			local current = storyboard.getCurrentSceneName()
			-- Current = level1
			--if current == "gameloop" then
				if event.xStart > event.x and swipeLength > 50 then 
					print("Swiped Left")
					saveBallLocation()
					-- Go to level [D]
					level1.room = "d"
					level1.pane(level1.room)
					--Runtime:removeEventListener("enterFrame", frame)
					--storyboard.gotoScene( "level1d", "fade", 500 )
					
				elseif event.xStart < event.x and swipeLength > 50 then 
					print( "Swiped Right" )
					saveBallLocation()
					-- Go to level [B]
					level1.room = "b"
					level1.pane(level1.room)
					--Runtime:removeEventListener("enterFrame", frame)
					--storyboard.gotoScene( "level1b", "fade", 500 )
				elseif event.yStart > event.y and swipeLengthy > 50 then
					print( "Swiped Down" )
					saveBallLocation()
					-- Go to level [C]
					
					--Runtime:removeEventListener("enterFrame", frame)
					--storyboard.gotoScene( "level1c", "fade", 500 )
				elseif event.yStart < event.y and swipeLengthy > 50 then
					print( "Swiped Up" )
					saveBallLocation()
					-- Go to level [A]
					
					--Runtime:removeEventListener("enterFrame", frame)
					--storyboard.gotoScene( "level1a", "fade", 100 )
				end	
			-- Current = level1 [A]
			--elseif current == "level1a" then
				if event.yStart > event.y and swipeLengthy > 50 then
					print( "Swiped Up" )
					saveBallLocation()
					-- Go to level [MAIN]
					
					--Runtime:removeEventListener("enterFrame", frame)
					--storyboard.gotoScene( "level1", "fade", 100 )
				end	
			-- Current = level1 [B]
			--elseif current == "level1b" then
				if event.xStart > event.x and swipeLength > 50 then 
					print("Swiped Left")
					saveBallLocation()
					-- Go to level [MAIN]
					
					--Runtime:removeEventListener("enterFrame", frame)
					--storyboard.gotoScene( "level1", "fade", 500 )
				end
			--elseif current == "level1c" then
					if event.yStart < event.y and swipeLengthy > 50 then
						print( "Swiped Up" )
						saveBallLocation()
						-- Go to level [MAIN]
						
						--Runtime:removeEventListener("enterFrame", frame)
						--storyboard.gotoScene( "level1", "fade", 500 )
					end	
			--elseif current == "level1d" then
				if event.xStart < event.x and swipeLength > 50 then 
					print( "Swiped Right" )
					saveBallLocation()
					-- Go to level [MAIN]
					
					--Runtime:removeEventListener("enterFrame", frame)
					--storyboard.gotoScene( "level1", "fade", 500 )
				end
			end
		end	
	end
--end

-----------------------------------------------------
-- scene:createScene(event, lines)
-- 		Called when the scene's view does not exist:
-----------------------------------------------------
function scene:createScene(event)
	local group = self.view
	--local levels = require("level1")
	
	print("Levels: ", levels)

	-- create a grey rectangle as the backdrop
	-- temp wood background from http://wallpaperstock.net/wood-floor-wallpapers_w6855.html
	local background = display.newImageRect( "background2.jpg", screenW+100, screenH)

	background.anchorX = 0.0
	background.anchorY = 0.0
	background.x, background.y = -50, 0
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( ballTable[1] )
	group:insert( ballTable[2] )
	
	level1.init()
	print(level1.lines)
	
end

-----------------------------------------------------------
-- scene:enterScene(event, roomDebugger)
-- 		Called immediately after scene has moved onscreen:
-----------------------------------------------------------
function scene:enterScene(event)
	local group = self.view

	physics.start()
	
	physics.setGravity(0, 0)
	
	physics.addBody(ballTable[1], {radius = 15, bounce = .8 })
	physics.addBody(ballTable[2], {radius = 15, bounce = .8 })
	
	ballTable[1]:setLinearVelocity(0,0)
	ballTable[1].angularVelocity = 0
	ballTable[2]:setLinearVelocity(0,0)
	ballTable[2].angularVelocity = 0
	
	Runtime:addEventListener("touch", moveBall)
	Runtime:addEventListener("enterFrame", frame)
	Runtime:addEventListener("enterFrame", level1.pane)
	
end

----------------------------------------------
-- scene:willEnterScene(event)
----------------------------------------------
function scene:willEnterScene(event)

	ballTable[1].x = ballVariables.getBall1x()
	ballTable[1].y = ballVariables.getBall1y()
	ballTable[2].x = ballVariables.getBall2x()
	ballTable[2].y = ballVariables.getBall2y()
	
end

------------------------------------------------------
-- scene:exitScene(event, eventDebugger)
-- 		Called when scene is about to move offscreen:
------------------------------------------------------
function scene:exitScene(event)
	local group = self.view
	--local levels = require("level1")
	
	print("level =", levels)
	
	Runtime:removeEventListener("touch", moveBall)
	Runtime:removeEventListener("enterFrame", frame)

	physics.removeBody(ballTable[1])
	physics.removeBody(ballTable[2])

	--for count = 1, 8, 1 do 
	--	physics.removeBody(levels[1].lines[count])
	--end
	
	--levels.destroy(event)

	physics.pause()
	
end

-----------------------------------------------------------------------------------
-- scene:destroyScene(event, eventDebugger)
-- 			If scene's view is removed, scene:destroyScene() will be called just prior to:
-----------------------------------------------------------------------------------
function scene:destroyScene(event, eventDebugger)
	local group = self.view
	
end


-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

scene:addEventListener( "willEnterScene", scene)

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene
