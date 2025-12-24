lg=love.graphics
shove=require "lib.shove"

sys={
    sw=144,
    sh=128
}

shove.setResolution(sys.sw,sys.sh,{fitMethod="pixel",scalingFilter = "nearest",renderMode="layer"})
shove.setWindowMode(800, 600, {resizable = true})

cpu=require("emu/cpu")
mem=require("emu/ram")
api=require("emu/api")
sound=require("emu/sound")
sandbox=require("emu/sandbox")
font=require("emu/font")

pal=require("lib/pal")

pal:new("pal",love.image.newImageData("emu/data/palette.png"))
pal:load("pal")

bit=require("bit")

local c=[[
function _load()
    for x=0,7 do
        for y=0,7 do
            sset(x,y,x+y)
        end
    end
end

function _tick()
    sspr(0,0,8,8,0,0,1,1)
end
]]

function love.load()
    tmr=0
    count=1
    shove.createLayer("screen")
    lg.setDefaultFilter("nearest")

    mem.init()
    sandbox:init()
    cpu:init(c)
    font.init()
    font.new("emu/data/font.png","default",6,8,[===[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~]===])

    vram=love.image.newImageData(sys.sw,sys.sh)
    sound:init()
end

function love.update(dt)
    cpu:tick(dt)
end

function love.draw()
    vram:mapPixel(function(x,y,r,g,b,a)
        return pal:color(api.pget(x,y))
    end)

    shove.beginDraw()
        shove.beginLayer("screen")
            local d=lg.newImage(vram)
            lg.draw(d)
        shove.endLayer()
    shove.endDraw()
end

function love.keypressed(k)
    if k=="f11" then
        if love.window.getFullscreen() then
            love.window.setFullscreen(false)
        else
            love.window.setFullscreen(true)
        end
    end
    --[[if k=="i" then
        local s=love.audio.newSource(sound:get(1,16,0.25))
        s:play()
    end
    if k=="o" then
        local s=love.audio.newSource(sound:get(3,16,0.25))
        s:play()
    end
    if k=="p" then
        local s=love.audio.newSource(sound:get(5,16,0.25))
        s:play()
    end]]
end

