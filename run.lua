local run={}

function run:enter(prev,cart)
    mem.init()
    sandbox:init()
    cpu:init(cart)
end

function run:update(dt)
    cpu:tick(dt,function()
        sandbox:tick()
    end)
end

function run:draw()

end

return run