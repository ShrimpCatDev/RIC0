local console={}

function console:enter(prev,cart)
    timer.clear()
    if mem then
        self.backup=mem.ram
    end
    mem.init()
    sandbox:init()
    cpu:init(cart)

    self.logo="33333000000000000333300000000000330000000033333303300330003333300333300000330033330033ee33033003300033eee1333333000033133333303311331ee133333033331133ee33003333133ee33033333e1331333330e333303311331333331331133133ee331330e33ee10ee330331033133e331333333133113303310333313333313333331333331333333133333e13310e33303333e1e3333e1e3333133ee331eeeee11ee100eee1eeee110eeee110eeee1ee11ee1011111001100011101111000111100011110110011"
    self.log={
        "-\6Bit\7Soda\3-",
        "",
        "A fantasy console by",
        --"\8S\9h\10r\11i\12m\13p\14C\15a\6t",
        "\16ShrimpCat",
        ""
    }
    self.input=""
    self.bg=0
    self.egg={
        cat={x=-8,y=sys.sh-8,go=false,img="0000000000050050005655650557777557570705577877855777775056777650"}
    }
    self.scroll={y=0,gy=0}
    self.time=0
end

local blink={" ","\8_"}

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
            
        --api.print("hello world",0,0,7)
        if self.egg.cat.go then
            self.egg.cat.x=self.egg.cat.x+1
            api.drawData(self.egg.cat,self.egg.cat.x,self.egg.cat.y,8,8)
            if self.egg.cat.x>sys.sw then
                self.egg.cat.go=false
            end
        end

        --145

        local s=(#self.log+1)*size+oy

        if s>=145 and self.scroll.gy~=sys.sh-s then
            self.scroll.gy=sys.sh-s
            timer.tween(0.6,self.scroll,{y=self.scroll.gy},"out-elastic")
        elseif s<=145-size and self.scroll.gy~=0 then
            self.scroll.gy=0
            timer.tween(0.6,self.scroll,{y=self.scroll.gy},"out-elastic")
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
            if not love.filesystem.getInfo(args[1]..data.extension) then
                love.filesystem.write(args[1]..data.extension,data.template)
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
end

function console:keypressed(k)
    if k=="backspace" and string.len(self.input)>0 then
        self.input=string.sub(self.input,1,string.len(self.input)-1)
    end
    if k=="return" then
        out("\1"..self.input)
        handleInput(self.input)
        self.input=""
    end
end

return console