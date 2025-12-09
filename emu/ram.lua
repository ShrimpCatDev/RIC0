local mem={}

mem.map={
    screenStart=0x0000, screenEnd=0x4800
}


function mem:init()
    self.size=0xFFFF
    self.ram={}
    for i=1,self.size+1 do
        self.ram[i]=0
    end
    print("created RAM with "..#self.ram.." bytes")
end

function mem:poke(addr,val)
    if addr+1>#self.ram or addr<0 or type(val)~="number" then
        return 0
    end
    self.ram[addr+1] = bit.band((val or 0),0xFF)
end

function mem:peek(addr)
    if addr+1>#self.ram or addr<0 then
        return 0
    end
    return self.ram[addr+1]
end

return mem