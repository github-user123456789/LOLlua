-- i found it on https://esolangs.org/wiki/LOLScript
--[[
	this is a LOLScript runner thing
	and it works by translating it to luau because im too lazy to interpret it or parse it
	
	NOTE: i dont support [[ or [==[ (strings) yet so anything inside of them might accidentally get converted to lua globals/keywords
]]

local lolscript = {}
lolscript.match = { -- matching lua globals for lolscript globals
	["IF LE"] = "if",
	["DEN"] = "then",
	["MAH"] = "local",
	["INDIS"] = "in",
	["YA"] = "true",
	["NOP"] = "false",
	["NOTHING"] = "nil",
	["IS"] = "==",
	["ISNT"] = "~=",
	["THREAD"] = "coroutine",
	["NAWT"] = "not",
	["LESS"] = "<",
	["MOAR"] = ">",
	["LETIME"] = "os.clock()",
	["AND"] = "and",
	["PCALL"] = "pcall",
	["UNTIL"] = "until",
	["SOMETHING"] = "function",
	["PLZ"] = "do",
	["FER"] = "for",
	["OR ELSE%.%.%."] = "else",
	["OR ELSE IFDIS"] = "elseif",
	["SHUD BE"] = "=",
	["GET OUT"] = "return",
	["INFINITY"] = "math.huge",
	["LE PAIRS"] = "pairs",
	["LOL WHILE"] = "while",
	["BREAK ME KK"] = "break",
	["LOLK"] = "end",
}
lolscript.matchafter = { -- this has to exist because some other keywords use "LOL"
	["LOL"] = "print",
	["OR"] = "or",
}
function lolscript:hasstring(poo)
	return string.find(poo, '"', 1, true) or string.find(poo, "'", 1, true)
end
function lolscript:nowhitespace(v)
	local instr = false
	local new = ""
	local lastl
	for i = 1,#v do
		local l = v:sub(i, i)
		if l == '"' or l == "'" then
			instr = not instr
		end
		if not string.match(l, "%s+") or instr or (l == " ") then new ..= l end
		lastl = l
	end
	
	return new
end
function lolscript:toluau(source) -- translates it to luau
	source = string.gsub(source, "[\n\r]", ";")
	
	local newsource = ""
	local thesplits = string.split(source, ";")
	for i,v in thesplits do
		v = self:nowhitespace(v)
		-- translate globals to normal lua stuff but not in a string!!!!!!
		--[[local lols = string.split(v, " ")
		local instring = false
		for _, lol in lols do
			if not instring then
				
			end
			if self:hasstring(lol) then
				instring = not instring
			end
		end]]
		
		-- special thing for print. yayayaya --
		local newv = ""
		local reachletter
		for i = 1,#v do
			local l = v:sub(i, i)
			if l ~= " " then
				reachletter = true
			end
			if reachletter then
				newv ..= l
			end
		end
		v = newv
		if v:sub(1, 4) == "LOL " then
			-- try to ignore comments aswell
			newsource ..= "print(" ..string.split(v:sub(5), "--")[1] ..")" ..[[

]]
		else
			if #v > 0 then
				local finalstring = ""
				
				local guh = string.split(v, '"')
				for wth,v in guh do
					if wth % 2 == 1 then
						local st = v
						for i,v in self.match do
							st = string.gsub(st, i, v)
						end
						for i,v in self.matchafter do
							st = string.gsub(st, i, v)
						end
						finalstring ..= st
						if #guh > 1 and wth ~= #guh then
							finalstring ..= '"'
						end
					else
						finalstring ..= v .. '"'
					end
				end
				
				newsource ..= finalstring ..[[

]]
			end
		end
	end
	return newsource
end
function lolscript:loadstring(src)
	--print(self:toluau(src))
	loadstring(self:toluau(src))()
end
return lolscript
