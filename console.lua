local console={}

function console:init()
    local file="carts"
    local info=love.filesystem.getInfo(file)
    if info and info.type=="directory" then
        print("cart directory exists")
    else
        print("cart directory doesn't exist, making one now...")
        ok = love.filesystem.createDirectory("carts")
        if ok then
            print("cart directory made!")
        else
            print("an error occured while making the cart directory")
        end
    end
    mem.init()
    sandbox:init()
    cpu:init()

    self.logo="33333000000000000333300000000000330000000033333303300330003333300333300000330033330033ee33033003300033eee1333333000033133333303311331ee133333033331133ee33003333133ee33033333e1331333330e333303311331333331331133133ee331330e33ee10ee330331033133e331333333133113303310333313333313333331333331333333133333e13310e33303333e1e3333e1e3333133ee331eeeee11ee100eee1eeee110eeee110eeee1ee11ee1011111001100011101111000111100011110110011"
    self.log={
        "-\6Bit\7Soda\3-",
        "",
        "A fantasy console by",
        --"\8S\9h\10r\11i\12m\13p\14C\15a\6t",
        "\16ShrimpCat",
        ""
    }
    self.bg=0
    self.loaded=""
end

function console:enter(prev,cart)
    timer.clear()
    if mem then
        self.backup=mem.ram
    end
    
    self.input=""
    
    self.scroll={y=0,gy=0,mouse=false}
    self.time=0
end

local blink={" ","\8_"}

local function lerp(a, b, t)
    return a + (b - a) * t
end

function console:update(dt)
    cpu:tick(dt,function()
        self.time=self.time+1
        timer.update(1/cpu.tickRate)
        font.time=font.time+1
        api.cls(self.bg)
        --api.drawData(self.logo,5,0,42,10)
        local ox,oy=1,1
        local size=9
        local ind=0
        for k,v in ipairs(self.log) do
            api.print(v,ox,(k-1)*size+oy+self.scroll.y,3)
            ind=k
        end

        api.print("> "..self.input..blink[math.floor((self.time/8)%#blink)+1],ox,ind*size+oy+self.scroll.y,3)

        --145

        local s=(#self.log+1)*size+oy

        if not self.scroll.mouse then
            if s>=145 and self.scroll.gy~=sys.sh-s then
                self.scroll.gy=sys.sh-s
                timer.tween(0.6,self.scroll,{y=self.scroll.gy},"out-elastic")
            elseif s<=145-size and self.scroll.gy~=0 then
                self.scroll.gy=0
                timer.tween(0.6,self.scroll,{y=self.scroll.gy},"out-elastic")
            end
        else
            self.scroll.y=lerp(self.scroll.y,self.scroll.gy,0.4)
        end
    end)
end

function split(str)
    local words = {}
    if not str then return words end
    for w in string.gmatch(str, "%S+") do
        table.insert(words, w)
    end
    return words
end

local function keys_of(t, sort_keys)
  local ks = {}
  for k,_ in pairs(t) do
    if type(k) == "string" then table.insert(ks, k) print(k) end
  end
  if sort_keys then table.sort(ks) end
  return ks
end

console.help={
    ["help"]={"melp :3"},
    ["print"]={""},
}

tempCart=[==[
function _load()
    for x=0,15 do
        for y=0,15 do
            sset(x,y,x+y)
        end
    end
end

function _tick()
    cls(6)

    for i=0,8 do
        spr(0,math.cos(t()*0.1+i*6.28319/8)*16+144/2-4,math.sin(t()*0.1+i*6.28319/8)*32+128/2-4,1,1)
    end
    for i=0,8 do
        spr(1,math.sin(t()*0.1+i*6.28319/8)*32+144/2-4,math.cos(t()*0.1+i*6.28319/8)*16+128/2-4,1,1)
    end
    print("the text \4OF \12COLOR\2!",1,2,2)
    print("the text \8OF \13COLOR\3!",1,1,3)
end
]==]

console.commands={
    ["help"]=function(args)
        out("\11-HELP-")
        if args[1] then
            out("just \16figure out")
            out("what you're supposed")
            out("to do with "..args[1]..".")
        else
            local key=keys_of(console.commands,true)
            out("\14List of commands:")
            for k,v in pairs(key) do
                out("- "..v)
            end
        end
    end,
    ["print"]=function(args)
        if #args>=1 then
            local s=""
            for k,v in ipairs(args) do
                s=s..v.." "
            end
            out(s)
        else
            out(" ")
        end
    end,
    ["cls"]=function(args)
        console.log={}
    end,
    ["bg"]=function(args)
        console.bg=args[1] or 0
    end,
    ["new"]=function(args)
        if args[1] then
            if not love.filesystem.getInfo("carts/"..args[1]..data.extension) then
                love.filesystem.write("carts/"..args[1]..data.extension,data.template)
                out("\11new cart created")
            else
                out("\14File already exists!")
            end
        else
            out("\14Syntax error!")
        end
    end,
    ["folder"]=function(args)
        local suc= love.system.openURL("file://"..love.filesystem.getSaveDirectory())
        if suc then
            out("\14opened data directory!")
        else
            out("\14an error occured :(")
        end
    end,
    ["shutdown"]=function()
        love.event.quit()
    end,
    ["palette"]=function()
        out("\0O\1O\2O\3O")
        out("\4O\5O\6O\7O")
        out("\8O\9O\10O\11O")
        out("\12O\13O\14O\15O")
    end,
    ["ls"]=function(args)
        local dir="carts"

        if args[1] then
            ok = love.filesystem.createDirectory("carts/"..args[1])
            if ok then
                out("\11new folder created")
            else
                out("\11an error occured!")
            end
        else
            local files=love.filesystem.getDirectoryItems(dir)
            table.sort(files)
            for i,v in ipairs(files) do
                local file=dir.."/"..v
                local info=love.filesystem.getInfo(file)
                if info then
                    if info.type=="file" then
                        local name=v:match("^(.+)%"..data.extension.."$")
                        if name then
                            out(name)
                        end
                    elseif info.type=="directory" then
                        out("\15-"..v)
                    end
                end
            end
        end
    end,
    ["load"]=function(args)
        if args[1] then
            local info=love.filesystem.getInfo("carts/"..args[1]..data.extension)
            if info and info.type=="file" then
                local txt,size=love.filesystem.read("carts/"..args[1]..data.extension)
                if console.loaded then
                    console.loaded=txt
                    out("\16loaded!")
                    out("\2("..size.." bytes)")
                else
                    out("\14an error occured :(")
                end
            else
                out("\14Cart doesn't exist")
            end
        else
            out("\14Syntax error!")
            out("\13(include cart name)")
        end
    end,
    ["run"]=function(args)
        if console.loaded~="" then
            local load=require("load")
            load.load(console.loaded)
        end
    end
}

function out(s)
    print(s)
    table.insert(console.log,s)
end

function handleInput(str)
    if string.len(str)>0 then
        local input=split(str)
        if console.commands[input[1]] then
            local r=console.commands[input[1]]
            local arg=input
            table.remove(arg,1)
            r(arg)
        else
            out("\14Syntax error!")
        end
    end
end

function console:textinput(k)
    self.input=self.input..k
    self.scroll.mouse=false
end

function console:keypressed(k)
    if k=="backspace" and string.len(self.input)>0 then
        self.input=string.sub(self.input,1,string.len(self.input)-1)
    end
    if k=="return" then
        out("\1"..self.input)
        handleInput(self.input)
        self.input=""
        self.scroll.mouse=false
    end
end

function console:wheelmoved(x,y)
    if y>0 and self.scroll.gy<0 then
        self.scroll.mouse=true
        self.scroll.gy=self.scroll.gy+9
    elseif y<0 then
        self.scroll.mouse=true
        self.scroll.gy=self.scroll.gy-9
    end
end

return console