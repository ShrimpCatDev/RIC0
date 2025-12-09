local sandbox={}

function sandbox:init()
    self.env={
        poke=mem.poke,
        peek=mem.peek,

        pset=api.pset,
        pget=api.pget,
        cls=api.cls,
        rectfill=api.rectfill,
        print=print
    }
end

function sandbox:loadCart(code)
    self.env._load=nil
    self.env._tick=nil

    func,err=loadstring(code)

    if not func then
        print(err)
        return
    end

    print("loaded!")

    setfenv(func,self.env)
    func()
    
    if self.env._load then self.env._load() end
end

function sandbox:tick()
    if self.env._tick then self.env._tick() end
end

return sandbox