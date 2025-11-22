mem=require("emu/ram")
api=require("emu/api")

bit=require("bit")

function comp(val1,val2)
    return bit.bor(val1,bit.lshift(val2,4))
end

function decomp(val)
    local a=bit.band(val,0xF)
    local b=bit.band(bit.rshift(val,4),0xF)
    return a,b
end

function love.load()
    mem:init()
end

function love.update()

end

function love.draw()

end

function love.keypressed(k)

end

