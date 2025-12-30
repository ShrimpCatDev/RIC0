local codeword="\x1F code"
local spriteword="\x1F sprite"

return {
    template=codeword.."\n\n"..spriteword.."\n\n",
    extension=".bs",
    loc={code=codeword,sprite=spriteword}
}