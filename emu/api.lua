local api={}

function api.updateInput()
    input:update()
    api.inputDown={
        input:down("up"),
        input:down("down"),
        input:down("left"),
        input:down("right"),
        input:down("a"),
        input:down("b")
    }
    api.inputPressed={
        input:pressed("up"),
        input:pressed("down"),
        input:pressed("left"),
        input:pressed("right"),
        input:pressed("a"),
        input:pressed("b")
    }
end

function api.btn(ind)
    if ind<#api.inputDown and ind>=0 then
        return api.inputDown[ind+1]
    else
        return false
    end
end

function api.btnp(ind)
    if ind<#api.inputPressed and ind>=0 then
        return api.inputPressed[ind+1]
    else
        return false
    end
end

function comp(val1,val2)
    return bit.bor(val1,bit.lshift(val2,4))
end

function decomp(val)
    local a=bit.band(val,0xF)
    local b=bit.band(bit.rshift(val,4),0xF)
    return a,b
end

function api.pget(x, y)
    local ind = mem.map.screenStart+math.floor((y * sys.sw + x) / 2)
    local hi, lo = decomp(mem.peek(ind))
    if x % 2 == 0 then
        return hi
    else
        return lo
    end
end

function api.pset(x, y, c)
    if x>=0 and x<sys.sw and y>=0 and y<sys.sh then
        local ind = mem.map.screenStart+math.floor((y * sys.sw + x) / 2)
        local hi, lo = decomp(mem.peek(ind))

        if x % 2 == 0 then
            hi = bit.band(c, 0xF)
        else
            lo = bit.band(c, 0xF)
        end

        mem.poke(ind, comp(hi, lo))
    end
end

function api.sset(x, y, c)
    if x>=0 and x<128 and y>=0 and y<128 then
        local ind = mem.map.spriteStart+math.floor((y * 128 + x) / 2)
        local hi, lo = decomp(mem.peek(ind))

        if x % 2 == 0 then
            hi = bit.band(c, 0xF)
        else
            lo = bit.band(c, 0xF)
        end

        mem.poke(ind, comp(hi, lo))
    end
end

function api.sget(x, y)
    local ind = mem.map.spriteStart+math.floor((y * 128 + x) / 2)
    local hi, lo = decomp(mem.peek(ind))
    if x % 2 == 0 then
        return hi
    else
        return lo
    end
end

function api.sspr(sx,sy,sw,sh,dx,dy,dw,dh)
    for x=sx,sx+sw-1 do
        for y=sy,sy+sh-1 do
            api.rectfill(x*dw+dx-sx,y*dh+dy-sy,dw,dh,api.sget(x,y))
        end
    end
end

function api.spr(ind,x,y,w,h)
    local sw,sh=w or 1, h or 1
    api.sspr(math.floor((ind%16)*8),math.floor((ind/16)*8),8*sw,8*sh,math.floor(x),math.floor(y),1,1)
end

function api.cls(c)
    local color=c or 0
    for x=0,sys.sw-1 do
        for y=0,sys.sh-1 do
            api.pset(x,y,color)
        end
    end
end

function api.rectfill(x1,y1,w,h,c)
    for x=x1,x1+w-1 do
        for y=y1,y1+h-1 do
            api.pset(x,y,c)
        end
    end
end

function api.rect(x,y,w,h,c)
    for i=x,x+w-1 do
        api.pset(i,y,c)
        api.pset(i,y+h-1,c)
    end
    for j=y,y+h-1 do
        api.pset(x,j,c)
        api.pset(x+w-1,j,c)
    end
end

function api.time()
    return cpu.time
end

function api.print(text,x,y,color)
    if x and y and color then
        font.print(text,x,y,color,"default")
    else
        print(text)
    end
end

--code not made my me, this isnt for anything importandt and ill redo this later
function api.drawData(text, x, y, w, h)
    local hex = tostring(text):gsub("^0x",""):gsub("%s+",""):gsub("[^%x]","")
    local total = w * h

    for i = 1, total do
        local ch = hex:sub(i,i)
        local col = ch ~= "" and (tonumber(ch,16) or 0) or 0
        local px = (i - 1) % w
        local py = math.floor((i - 1) / w)
        api.pset(x + px, y + py, col)
    end
end

return api