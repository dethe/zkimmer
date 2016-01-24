local ship
local image
local ships

function love.load()
    ships = {}
    image = love.graphics.newImage('ships.png')
    local spritemap = love.graphics.newSpriteBatch(image, 8*80, "stream")
    local quads = {}
    for x = 0, 640 do
        -- there are 16 types of ship, with 40 orientations each (5 rows of 8)
        local shipIdx = math.floor(x / 40)
        local spriteIdx = x % 40
        if x % 40 == 0 then
            ship = {x=0, y=0, spriteIdx=0, sprite={} }
            ships[shipIdx] = ship
        end
        local i,j = 1 + (x % 8), math.floor(x/8)
        local quad = love.graphics.newQuad(i*35, j*35, 35, 35, image:getWidth(), image:getHeight())
        ship.sprite[spriteIdx] = quad
    end
    ship = ships[0]
end

function love.update(dt)
    if love.keyboard.isDown('up') then
        ship.y = ship.y - 100 * dt
    end
    if love.keyboard.isDown('down') then
        ship.y = ship.y + 100 * dt
    end
    if love.keyboard.isDown('right') then
        ship.x = ship.x + 100 * dt
    end
    if love.keyboard.isDown('left') then
        ship.x = ship.x - 100 * dt
    end
end

function love.draw()
    love.graphics.draw(image, ship.sprite[ship.spriteIdx], ship.x, ship.y)
end

