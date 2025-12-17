local cpu={}

function cpu:init(code)
    sandbox:loadCart(code)
    self.tickRate=60
    self.acc=5
    self.time=0
end

function cpu:tick(dt)
    self.acc=self.acc+dt

    if self.acc>=1/self.tickRate then
        self.time=self.time+1
        sandbox:tick()
        self.acc=0
    end
end

return cpu