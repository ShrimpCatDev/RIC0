local font={}

function font.init()
    font.fonts={}
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
    local f=font.fonts[name]
    for i=1,string.len(text) do
        font.drawChar(string.sub(text,i,i),(i-1)*f.w+x,y,color,name)
    end
end

return font