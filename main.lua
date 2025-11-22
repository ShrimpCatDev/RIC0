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

pal=require("lib/pal")

pal:new("pal",love.image.newImageData("emu/data/palette.png"))
pal:load("pal")

bit=require("bit")

function love.load()
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
end

function love.update(dt)
    --api:cls(math.random(0,15))
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
end

