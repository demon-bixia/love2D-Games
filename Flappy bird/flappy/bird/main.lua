push = require('push')
Class =  require('class')

require('Bird')
require('Pipe')
require('PipePair')

require('StateMachine')
require('states/BaseState')
require('states/TitleScreenState')
require('states/PlayState')
require('states/ScoreState')
require('states/CountDown')

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514

local scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Fifty Bird')

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    sounds = {
        ['jump'] = love.audio.newSource('audio/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('audio/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('audio/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('audio/score.wav', 'static'),
        ['music'] = love.audio.newSource('audio/marios_way.mp3', 'static'),
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen=false,
        resizable=true,
        vsync=true
    })

    gStateMachine = StateMachine{
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['count_down'] = function() return CountDown() end,
        }

        gStateMachine:change('title')
        love.keyboard.keysPressed = {}
end

function love .resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) %
    BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) %
    GROUND_LOOPING_POINT

    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end
