local mem={}

mem.map={
    screenStart=0x0000, screenEnd=0x4800
}


function mem.init()
    mem.size=0xFFFF
    mem.ram={}
    for i=1,mem.size+1 do
        mem.ram[i]=0
    end
    print("created RAM with "..#mem.ram.." bytes")
end

function mem.poke(addr,val)
    if addr+1>#mem.ram or addr<0 or type(val)~="number" then
        return 0
    end
    mem.ram[addr+1] = bit.band((val or 0),0xFF)
end

function mem.peek(addr)
    if addr+1>#mem.ram or addr<0 then
        return 0
    end
    return mem.ram[addr+1]
end

return mem