--[[

This hashing algorithm was made by Real_Siesgo (Siesgo#8832).
    ||
-## \/ ##--

Permission for using this software is hereby granted.
By using this software you agree to the following:

ITS PROHIBITED TO COPY THIS SOFTWARE AND RELEASE IT AS YOUR OWN.
ANY PERSON WHO USES/CHANGES THIS SOFTWARE AND RELEASES IT PUBLICLY MUST GIVE PROPER CREDITS TO THE AUTHOR OF THE SOFTWARE.

-## /\ ##--

]]

--Update 11.11.2022
--The name of the hashing algorithm changed to "CH-Alg"
--The Software may not be really small as of right now due to it still being in BETA
--Changed how CH-Alg works (Same letters no longer repeat themselves twice in a row)

--Update 10.11.2022
--Changed the hex table (Made the outputs unique).
--This algorithm now returns values different than SHA.

local Hex_Table={
	[1] = "A",
	[3] = "B",
	[5] = "C",
	[7] = "D",
	[9] = "E",
	[10]= "F",
	[11]= "T",
	[13]= "S",
	[15]= "N",
}

setmetatable(Hex_Table,{__index = function(self,i)
	if type(i) == "number" then
		return i ~= 0 and i
	else
		local num: number
		
		for a,v in next, self do
			if v == i then
				return self[rawget(self,a-2) and a-2 or a+2]
			end
		end
		
		return nil
	end
end,})

local to_Hex = function(dec)
	assert(type(tonumber(dec)) == "number","[CustomToHex]: Number expected. Got "..type(dec)..".")
	
	local dec = math.floor(tonumber(dec))
	
	assert(dec > 0,"[CustomToHex]: Invalid Decimal Input.")
	
	if dec > 15 then
		local results = {}
		local next_num = dec
		
		while next_num > 15 do
			local result = math.floor(next_num%16)
			
			if result > 0 then
				table.insert(results,Hex_Table[result])
			end
			
			next_num = math.floor(next_num/16)
		end
		
		return table.concat(results):reverse()
	else
		return Hex_Table[dec]
	end
end
hash = function(str : string , length : number ) : string
	assert(type(str)=="string","<HASH> Expected String in argument #1. Got "..type(str)..".")
	assert(type(length)=="number" or length==nil,"<HASH> Expected Number in argument #2. Got "..type(length)..".")
	
	local length = length or 25
	
	if length<5 then
		length = 5
	elseif length>5000 then
		length = 5000
	end
	
	length=math.floor(length)
	
	local old_length = str:len()
	local abytes = {str:byte(1,-1)}
	local bbytes = {}
	local cbytes = 1
	local newnum = ""
	
	for i,value in next,abytes do
		table.insert(bbytes,bit32.rshift(value^5,2))
	end
	
	for i,value in next,bbytes do
		if old_length<100 then
			if i%2 == 0 then
				cbytes*=math.sqrt(value/math.pi)/(old_length^2)
			else
				cbytes/=math.sqrt(value/math.pi)/math.pi
			end
		else
			if i%2 == 0 then
				cbytes+=math.sqrt(value/math.pi)
			else
				cbytes-=math.sqrt(value/math.pi)/math.pi
			end
		end
	end
	
	local log10_value = tostring(math.log10(cbytes/math.pi)):sub(6,-1) * 1.7
	log10_value = bit32.rrotate(log10_value,old_length-length)
	log10_value = bit32.lshift(log10_value,math.sqrt(old_length))
	
	local hash_str = to_Hex(log10_value/7.7)
	
	local function get_hash_str(string1,length1)
		if string1:len()<length1 then
			local nextnum = 2/math.pi
			
			repeat
				string1 = string1:reverse()..to_Hex(log10_value*nextnum):gsub("00.*","")
				
				nextnum *= math.pi
			until string1:len()>=length1
		end
		
		return string1:sub(1,length1)
	end
	
	local output = get_hash_str(hash_str,length):reverse()
	local last_L = ""
	
	output = output:gsub(".",function(s)
		if last_L == s then
			return Hex_Table[last_L]
		else
			last_L = s
			return s
		end
	end)
	
	return output
end

return hash
