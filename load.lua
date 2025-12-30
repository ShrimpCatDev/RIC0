local loadCart={}

function loadCart.load(cartString)
    local loc={
        code=string.find(cartString,data.loc.code),
        sprite=string.find(cartString,data.loc.sprite)
    }

    local code=""
    local sprite={}

    if loc.code then
        code=string.sub(cartString,loc.code+string.len(data.loc.code)+1,loc.sprite-1)
    end

    gs.switch(state.run,code)
end

return loadCart