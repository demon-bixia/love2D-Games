push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIR_WIDTH = 432
VIR_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)

    push:setupScreen(VIR_WIDTH, VIR_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable=false, 
        fullscreen=false, 
        vsync=true
    })

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIR_WIDTH-10, VIR_HEIGHT-30, 5, 20)

    ball = Ball(VIR_WIDTH/2-2, VIR_HEIGHT/2-2, 4, 4)

    gameState = "start"
end

function love.update(dt)
   
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED 
    elseif love.keyboard.isDown('s')then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end
   
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down')then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end
    
    if gameState == 'play' then
        ball:update(dt)
    end
    
    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start'then 
            gameState = 'play'
        else
            gameState = 'start'
            ball:reset()
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    
    love.graphics.setFont(smallFont)
    
    if gameState == 'start' then
        love.graphics.printf('Hello Play State!', 0, 20, VIR_WIDTH, 'center')
    else
        love.graphics.printf('Hello Play State!', 0, 20, VIR_WIDTH, 'center')
    end

    player1:render()
    player2:render()

    ball:render()

    push:apply('end')
end
