local api={}

function comp(val1,val2)
    return bit.bor(val1,bit.lshift(val2,4))
end

function decomp(val)
    local a=bit.band(val,0xF)
    local b=bit.band(bit.rshift(val,4),0xF)
    return a,b
end

function api.pget(x, y)
    local ind = mem.map.screenStart+math.floor((y * sys.sw + x) / 2)
    local hi, lo = decomp(mem.peek(ind))
    if x % 2 == 0 then
        return hi
    else
        return lo
    end
end

function api.pset(x, y, c)
    if x>=0 and x<sys.sw and y>=0 and y<sys.sh then
        local ind = mem.map.screenStart+math.floor((y * sys.sw + x) / 2)
        local hi, lo = decomp(mem.peek(ind))

        if x % 2 == 0 then
            hi = bit.band(c, 0xF)
        else
            lo = bit.band(c, 0xF)
        end

        mem.poke(ind, comp(hi, lo))
    end
end

function api.cls(c)
    for x=0,sys.sw-1 do
        for y=0,sys.sh-1 do
            api.pset(x,y,c)
        end
    end
end

function api.rectfill(x1,y1,w,h,c)
    for x=x1,x1+w do
        for y=y1,y1+h do
            api.pset(x,y,c)
        end
    end
end

function api.time()
    return cpu.time
end

function api.print(text,x,y,color)
    if x and y and color then
        font.print(text,x,y,color,"default")
    else
        print(text)
    end
end


return api