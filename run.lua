local run={}

function run:enter(prev,cart)
    mem.init()
    sandbox:init()
    cpu:init(cart)
end

function run:update(dt)
    cpu:tick(dt,function()
        font.time=font.time+1
        sandbox:tick()
    end)
end

function run:draw()

end

function run:keypressed(k)
    if k=="escape" then
        gs.switch(state.console)
    end
end

return run