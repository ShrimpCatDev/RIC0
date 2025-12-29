local loadCart={}

function loadCart.load(filename)
    local contents,size=love.filesystem.read(filename)
end

return loadCart