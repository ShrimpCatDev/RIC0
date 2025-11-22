lg=love.graphics

sys={
    sw=160,
    sh=128
}

mem=require("emu/ram")
api=require("emu/api")

pal=require("lib/pal")

pal:new("pal",love.image.newImageData("emu/data/palette.png"))
pal:load("pal")

bit=require("bit")

function love.load()
    lg.setDefaultFilter("nearest")
    mem:init()
    for i=0,159 do
        for y=0,127 do
            api:pset(i,y,bit.bxor(i,y))
        end
    end
    scn=love.image.newImageData(sys.sw,sys.sh)
end

function love.update(dt)
    --mem:poke(love.math.random(0,0xffff),love.math.random(0,255))
    --api:cls(math.random(0,15))
end

function love.draw()
    scn:mapPixel(function(x,y,r,g,b,a)
        return pal:color(api:pget(x,y))
    end)
    local d=lg.newImage(scn)
    --[[lg.scale(4,4)

    local ind=0
    for y=0,127 do
        for x=0,(160/2)-1 do
            local a,b=decomp(mem:peek(ind))

            lg.setColor(pal:color(a))
            lg.rectangle("fill",x*2,y,1,1)
            lg.setColor(pal:color(b))
            lg.rectangle("fill",x*2+1,y,1,1)

            ind=ind+1
        end
    end]]
    lg.draw(d,0,0,0,3,3)
    --lg.print(love.timer.getFPS(),0,200)
end

function love.keypressed(k)

end

