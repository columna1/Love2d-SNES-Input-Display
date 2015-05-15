function love.load()
	require("configloader")
	local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
	if not joystick then error("No gamepad found! plug in and try again") end
	--load the image(s) and set the window size
	--sc.png - controller
	--sc2.png - controller cropped
	--buttons.png - button overlay
	--startselect.png - start select overlay
	--left.png, right.png, up.png, down.png dpad overlay
	controller = love.graphics.newImage("sc.png")
	buttons = love.graphics.newImage("buttons.png")
	startselect = love.graphics.newImage("startselect.png")
	up = love.graphics.newImage("up.png")
	down = love.graphics.newImage("down.png")
	left = love.graphics.newImage("left.png")
	right = love.graphics.newImage("right.png")
	
	--table used for the inputs
	cfg = loadConfigFile("config.txt")
	
	
	inputs = 
	{
	false,--a 1
	false,--b 2
	false,--x 3
	false,--y 4
	false,--left 5
	false,--right 6
	false,--up 7
	false,--down 8
	false,--R 9
	false,--L 10
	false,--start 11
	false,--select 12
	}
	
	min_dt = 1/cfg.maxFPS--for capping fps
	next_time = love.timer.getTime()
	
	--to allow for pressing buttons when the window is not selected
	local ffi = require("ffi")

ffi.cdef[[
typedef enum
{
    SDL_FALSE = 0,
    SDL_TRUE = 1
} SDL_bool;

SDL_bool SDL_SetHint(const char *name, const char *value);
]]

local sdl = ffi.os == "Windows" and ffi.load("SDL2") or ffi.C

sdl.SDL_SetHint("SDL_JOYSTICK_ALLOW_BACKGROUND_EVENTS", "1")
	
end

function love.update(dt)
   next_time = next_time + min_dt
   
   --check for the inputs and set them to the correct state
   
   --[[keyboard testing
   inputs = {
   love.keyboard.isDown("z"),--a
   love.keyboard.isDown("x"),--b
   love.keyboard.isDown("a"),--x
   love.keyboard.isDown("r"),--y
   love.keyboard.isDown("left"),--left
   love.keyboard.isDown("right"),--right
   love.keyboard.isDown("up"),--up
   love.keyboard.isDown("down"),--down
   love.keyboard.isDown("k"),--R
   love.keyboard.isDown("m"),--L
   love.keyboard.isDown("n"),--start
   love.keyboard.isDown("e"),--select
   }]]--
   
   --[[
   inputs = {
   joystick:isDown("2"),--a
   joystick:isDown("3"),--b
   joystick:isDown("1"),--x
   joystick:isDown("4"),--y
   joystick:getHat(1):find("l") and true or false,--left
   joystick:getHat(1):find("r") and true or false,--right
   joystick:getHat(1):find("u") and true or false,--up
   joystick:getHat(1):find("d") and true or false,--down
   joystick:isDown("6") or joystick:isDown("8"),--R
   joystick:isDown("5") or joystick:isDown("7"),--L
   joystick:isDown("10"),--start
   joystick:isDown("9"),--select
   }
   ]]--
   
	if cfg.dpadHat then
		inputs = {
			joystick:isDown(cfg.aButton),--a
			joystick:isDown(cfg.bButton),--b
			joystick:isDown(cfg.xButton),--x
			joystick:isDown(cfg.yButton),--y
			joystick:getHat(1):find("l") and true or false,--left
			joystick:getHat(1):find("r") and true or false,--right
			joystick:getHat(1):find("u") and true or false,--up
			joystick:getHat(1):find("d") and true or false,--down
			joystick:isDown(cfg.RButton),--R
			joystick:isDown(cfg.LButton),--L
			joystick:isDown(cfg.startButton),--start
			joystick:isDown(cfg.selectButton),--select
		}
	elseif cfg.dpadAxisXY then--for the option of x/y axis
		axisDir1, axisDir2, axisDirN = joystick:getAxes( )
		inputs = {
			joystick:isDown(cfg.aButton),--a
			joystick:isDown(cfg.bButton),--b
			joystick:isDown(cfg.xButton),--x
			joystick:isDown(cfg.yButton),--y
			axisDir1 < 0 and true or false,--left
			axisDir1 > 0 and true or false,--right
			axisDir2 < 0 and true or false,--up
			axisDir2 > 0 and true or false,--down
			joystick:isDown(cfg.RButton),--R
			joystick:isDown(cfg.LButton),--L
			joystick:isDown(cfg.startButton),--start
			joystick:isDown(cfg.selectButton),--select
		}
	else
		inputs = {
			joystick:isDown(cfg.aButton),--a
			joystick:isDown(cfg.bButton),--b
			joystick:isDown(cfg.xButton),--x
			joystick:isDown(cfg.yButton),--y
			joystick:isDown(cfg.leftButton),--left
			joystick:isDown(cfg.rightButton),--right
			joystick:isDown(cfg.upButton),--up
			joystick:isDown(cfg.downButton),--down
			joystick:isDown(cfg.RButton),--R
			joystick:isDown(cfg.LButton),--L
			joystick:isDown(cfg.startButton),--start
			joystick:isDown(cfg.selectButton),--select
		}
	end
   
end

function love.draw()

	--draw L and R
	if inputs[10] then love.graphics.rectangle("fill",71,25,99,50) end
	if inputs[9] then love.graphics.rectangle("fill",342,25,99,50) end
	--draw controller
	love.graphics.draw(controller,0,-138)
	--draw Overlays
	if inputs[4] then love.graphics.draw(buttons,324,125) end--Y button
	if inputs[3] then love.graphics.draw(buttons,371,89) end--X button
	if inputs[2] then love.graphics.draw(buttons,370,162) end--B button
	if inputs[1] then love.graphics.draw(buttons,417,124) end--A button
	
	
	if inputs[12] then love.graphics.draw(startselect,194,142) end--select button
	if inputs[11] then love.graphics.draw(startselect,245,142) end--Start button
	
	
	if inputs[7] then love.graphics.draw(up,90,102) end--up button
	if inputs[5] then love.graphics.draw(left,80,127) end--left button
	if inputs[6] then love.graphics.draw(right,97,127) end--right button
	if inputs[8] then love.graphics.draw(down,86,120) end--down button
	
	--love.graphics.print("FPS: "..love.timer.getFPS().." X: "..love.mouse.getX().." Y: "..love.mouse.getY().." "..joystick:getHat(1).." "..tostring(joystick:isDown("2")).." "..axisDir1.." "..axisDir2,0,0)
	
	local cur_time = love.timer.getTime()
	if next_time <= cur_time then
		next_time = cur_time
		return
	end
	love.timer.sleep(next_time - cur_time)
end