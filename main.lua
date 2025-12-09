lg=love.graphics
shove=require "lib.shove"

sys={
    sw=144,
    sh=128
}

shove.setResolution(sys.sw,sys.sh,{fitMethod="pixel",scalingFilter = "nearest",renderMode="layer"})
shove.setWindowMode(800, 600, {resizable = true})

mem=require("emu/ram")
api=require("emu/api")
sound=require("emu/sound")

pal=require("lib/pal")

pal:new("pal",love.image.newImageData("emu/data/palette.png"))
pal:load("pal")

bit=require("bit")

function love.load()
    tmr=0
    count=1
    shove.createLayer("screen")
    lg.setDefaultFilter("nearest")
    mem:init()
    for x=0,sys.sw-1 do
        for y=0,sys.sh-1 do
            --api:pset(i,y,bit.band(i,y))
            api:rectfill(x*8,y*8,8,8,x+y)
        end
    end
    scn=love.image.newImageData(sys.sw,sys.sh)
    sound:init()
    for i=0,2048 do
        mem:poke(math.random(0,0xffff),math.random(0,255))
    end
    print(sys.sw*sys.sh)

    accm=0
end

function love.update(dt)
    accm=accm+dt

    if accm>=1/60 then
        
    end
end

function love.draw()
    scn:mapPixel(function(x,y,r,g,b,a)
        return pal:color(api:pget(x,y))
    end)

    shove.beginDraw()
        shove.beginLayer("screen")
            local d=lg.newImage(scn)
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
    if k=="i" then
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
    end
end

