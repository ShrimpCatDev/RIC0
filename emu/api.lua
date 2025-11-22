local api={}

function comp(val1,val2)
    return bit.bor(val1,bit.lshift(val2,4))
end

function decomp(val)
    local a=bit.band(val,0xF)
    local b=bit.band(bit.rshift(val,4),0xF)
    return a,b
end

function api:pget(x, y)
    local ind = math.floor((y * sys.sw + x) / 2)
    local hi, lo = decomp(mem:peek(ind))
    if x % 2 == 0 then
        return hi
    else
        return lo
    end
end


function api:pset(x, y, c)
    local ind = math.floor((y * sys.sw + x) / 2)
    local hi, lo = decomp(mem:peek(ind))

    if x % 2 == 0 then
        hi = bit.band(c, 0xF)
    else
        lo = bit.band(c, 0xF)
    end

    mem:poke(ind, comp(hi, lo))
end




return api