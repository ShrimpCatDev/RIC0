local console={}

function console:enter(prev,cart)
    if mem then
        self.backup=mem.ram
    end
    mem.init()
    sandbox:init()
    cpu:init(cart)
end

function console:update(dt)
    cpu:tick(dt,function()
        
    end)
end

return console