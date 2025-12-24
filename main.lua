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
        print("hello")
        snow={}
        for i=0,50 do
            table.insert(snow,{x=math.random(0,143),y=math.random(0,127),spd=math.random(1,2)})
        end
    end

    function _tick()
        cls(15)

        rectfill(0,80,144,144,13)
        rectfill(0,70,144,8,13)
        rectfill(0,60,144,4,13)
        rectfill(0,50,144,1,13)

        for k,v in ipairs(snow) do
            v.y=v.y+v.spd
            v.y=v.y%144
            pset(v.x,v.y,3)
        end

        print("Merry \12Christmas",1,1,3)
        print("from BitSoda!",1,9,3)

        local x,y=2,128-34
        rectfill(x-1,y-1,34,34,0)
        for i=0,15 do
            rectfill((i%4)*8+x,math.floor(i/4)*8+y,8,8,i)
        end
        print("64 KiB RAM",x+34,y,3)
        print("16 colors",x+34,y+9,3)
        print("144x128 screen",x+34,y+9+9,3)
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

