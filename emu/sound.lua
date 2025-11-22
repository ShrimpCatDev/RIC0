local sound={}

sound.notes={
    16.35,
    17.32,
    18.35,
    19.45,
    20.6,
    21.83,
    23.12,
    24.5,
    25.96,
    27.5,
    29.14,
    30.87
}

function sound:init()
    self.rate=44100
    self.bits=16
    self.channel=1
    self.base=440
end

function sound:get(note,oct,len)
    local length=len
    local tone=self.notes[note]*oct
    local data=love.sound.newSoundData(length*self.rate,self.rate,self.bits,self.channel)

    local p=math.floor(self.rate/tone)
    for i=0,data:getSampleCount()-1 do
        data:setSample(i, i%p<p/2 and 1 or -1)  
    end

    return data
end

return sound