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

local c=[==[
function _load()
    for x=0,15 do
        for y=0,15 do
            sset(x,y,x+y)
        end
    end
end

function _tick()
    cls(6)

    for i=0,8 do
        spr(0,math.cos(t()*0.1+i*6.28319/8)*16+144/2-4,math.sin(t()*0.1+i*6.28319/8)*32+128/2-4,1,1)
    end
    for i=0,8 do
        spr(1,math.sin(t()*0.1+i*6.28319/8)*32+144/2-4,math.cos(t()*0.1+i*6.28319/8)*16+128/2-4,1,1)
    end
    print("the text \4OF \12COLOR\2!",1,2,2)
    print("the text \8OF \13COLOR\3!",1,1,3)
end
]==]

function love.load()
    love.window.setTitle("BitSoda")
    gs=require("lib/hump/gamestate")
    gs.registerEvents()
    timer=require("lib/timer")

    data=require("data")
    state={
        run=require("run"),
        console=require("console")
    }

    tmr=0
    count=1
    shove.createLayer("screen")
    lg.setDefaultFilter("nearest")

    font.init()
    font.new("emu/data/font.png","default",6,8,[===[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|]===])

    vram=love.image.newImageData(sys.sw,sys.sh)
    sound:init()

    gs.switch(state.console,c)
end

function love.update(dt)
    
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

