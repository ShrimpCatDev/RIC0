local font={}

function font.init()
    font.fonts={}
    font.time=32
end

function font.new(path,name,w,h,char)
    font.fonts[name]={}
    font.fonts[name].img=love.image.newImageData(path)
    font.fonts[name].w=w
    font.fonts[name].h=h
    font.fonts[name].chars={}

    local f=font.fonts[name]

    for i=1,string.len(char) do
        local t=string.sub(char,i,i)
        f.chars[t]={}
        local idx = i-1
        local sheetW = f.img:getWidth()
        local charX = (idx * w) % sheetW
        local charY = math.floor((idx * w) / sheetW) * h

        for y = charY, charY + h - 1 do
            for x = charX, charX + w - 1 do
                local r,g,b,a = f.img:getPixel(x,y)
                table.insert(f.chars[t], r)
            end
        end
    end
end

function font.drawChar(t,x,y,c,name)
    local f=font.fonts[name]
    local char = f.chars[t]
    if not char then return end
    for k,v in ipairs(char) do
        if v~=0 then
            api.pset(((k-1)%f.w)+x, math.floor((k-1)/f.w)+y, c)
        end
    end
end

function font.print(text,x,y,color,name)
    local f = font.fonts[name]
    if not f then return end
    local c = color
    local dx = 0
    for i = 1, #text do
        local b = text:byte(i)
        if b and b < 16 then
            c = b
        elseif text:sub(i,i)=="\16" then
            c=(font.time/2)
        else
            local ch = text:sub(i,i)
            if c==(font.time/2) then
                font.drawChar(ch, math.floor(x + dx * f.w), math.floor(y)+math.floor(math.cos(font.time/4+i)*2), c+i, name)
            else
                font.drawChar(ch, math.floor(x + dx * f.w), math.floor(y), c, name)
            end
            dx = dx + 1
        end
    end
end

return font