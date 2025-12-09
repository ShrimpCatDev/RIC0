local cpu={}

function cpu:init(code)
    sandbox:loadCart(code)
    self.tickRate=60
    self.acc=0
end

function cpu:tick(dt)
    self.acc=self.acc+dt

    if self.acc>=1/self.tickRate then
        sandbox:tick()
    end
end

return cpu