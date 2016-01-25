vector = require "hump.vector"

local ship
local image
local ships
local deg, rad, sin, cos, floor = math.deg, math.rad, math.sin, math.cos, math.floor

local SPRITE_WIDTH = 36
local SPRITE_HEIGHT = 36

function round(num)
    if num<0 then
        x=-.5
    else
        x=.5
    end
    whole, part = math.modf(num + x)
    return whole
end

SpaceShip = {
    x=0,
    y=0,
    velocity=vector(0,0),
    rotation=0,
    spriteIdx=10,
    image=nil
}

function SpaceShip:new(image, startIdx)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.startIdx = startIdx - 1
    self.sprite = {}
    self.image = image
    return o
end

function SpaceShip:rotate(r)
    self.rotation = (self.rotation + r) % 360
    print(string.format('rotation is %s degrees',  self.rotation))
    -- 9 is how many degrees in 1/40th of a circle
    local spriteIdx = round((self.rotation - 4.5) / 9)
    print(string.format("sprite index: %f", spriteIdx)) -- should always be between 1 and 40
    self.spriteIdx = math.max(spriteIdx, 1)
end

function SpaceShip:accelerate(dV)
    local rads = rad(self.rotation)
    local accelVector = vector(cos(rads) * dV, sin(rads) * dV)
    self.velocity = self.velocity + accelVector
end

function SpaceShip:move()
    self.x = self.x + self.velocity.x
    self.y = self.y + self.velocity.y
end


function love.load()
    ships = {}
    image = love.graphics.newImage('ships.png')
    for x = 0, 39 do
        -- there are 16 types of ship, with 40 orientations each (5 rows of 8)
        if x % 40 == 0 then
            ship = SpaceShip:new(image, x)
            table.insert(ships, ship)
        end
        local i,j = (x % 8), floor(x/8)
        local quad = love.graphics.newQuad(i*SPRITE_WIDTH, j*SPRITE_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT, image:getWidth(), image:getHeight())
        table.insert(ship.sprite, quad)
    end
    ship = ships[1]
end

function love.update(dt)
    -- handle keyboard movement
    if love.keyboard.isDown('up') then
        ship:accelerate(-10 * dt)
    end
    if love.keyboard.isDown('right') then
        ship:rotate(90 * dt)
    end
    if love.keyboard.isDown('left') then
        ship:rotate(-90 * dt)
    end
    -- keep on screen
    if ship.x > love.graphics.getWidth() then
        ship.x = ship.x - (love.graphics.getWidth() + SPRITE_WIDTH)
    end
    if ship.x < -SPRITE_WIDTH then
        ship.x = ship.x + love.graphics.getWidth()
    end
    if ship.y > love.graphics.getHeight() then
        ship.y = ship.y - (love.graphics.getHeight() + SPRITE_HEIGHT)
    end
    if ship.y < -SPRITE_HEIGHT then
        ship.y = ship.y + love.graphics.getHeight()
    end
    ship:move()
end

function love.draw()
    print('============')
    print(ship.spriteIdx)
    print(ship.sprite[ship.spriteIdx])
    print('')
    love.graphics.draw(image, ship.sprite[ship.spriteIdx], ship.x, ship.y)
end

