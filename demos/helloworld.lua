return [==[ code
function _load()
    pl={x=0,y=40}
end

function _tick()
    if btn(3) then
        pl.x=pl.x+1
    end
    if btn(2) then
        pl.x=pl.x-1
    end
    if btn(0) then
        pl.y=pl.y-1
    end
    if btn(1) then
        pl.y=pl.y+1
    end

    cls(0)
    for x=0,143 do
        for y=0,127 do
            pset(x,y,math.floor((x+y+t())/8)%2)
        end
    end
    print("\16hello world",1,4,8)
    for i=0,15 do
        rectfill(i*8,21+math.floor(math.cos(t()/10+i*0.4)*4),8,8,i+1)
    end
    for i=0,15 do
        rectfill(i*8,20+math.floor(math.cos(t()/10+i*0.4)*4),8,8,i)
    end
    rectfill(pl.x,pl.y,8,8,14)
    --rect(pl.x,pl.y,8,8,13)
end
 sprite

]==]

