local cpu={}

function cpu:init(code)
    if code then
        sandbox:loadCart(code)
    end
    self.tickRate=60
    self.acc=5
    self.time=0
end

function cpu:tick(dt,runFunc)
    self.acc=self.acc+dt

    if self.acc>=1/self.tickRate then
        self.time=self.time+1
        runFunc()
        self.acc=0
    end
end

return cpu