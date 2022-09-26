local Hex_Table={
	[10]="A",
	[11]="B",
	[12]="C",
	[13]="D",
	[14]="E",
	[15]="F"
}
setmetatable(Hex_Table,{
	__index = function(self,i)
		if i > 10 then return rawget(self,i)else return i end
	end,
})
local to_Hex = function(dec)
	assert(type(tonumber(dec))=="number","[toHex]: Number expected. Got "..type(dec)..".")
	local dec = math.floor(tonumber(dec))
	assert(dec>0,"[toHex]: Invalid Decimal Input.")
	if dec > 15 then
		local results = {}
		local next_num = dec
		local breaknext
		while true do
			table.insert(results,Hex_Table[math.floor(next_num%16)])
			next_num = math.floor(next_num/16)
			if breaknext then break end
			if next_num <= 16 then breaknext=true end
		end
		return table.concat(results):reverse()
	else
		return Hex_Table[dec]
	end
end
local hash = function(str : string , length : number ) : string
	assert(type(str)=="string","<HASH> Expected String in argument #1. Got "..type(str)..".")
	assert(type(length)=="number" or length==nil,"<HASH> Expected Number in argument #2. Got "..type(length)..".")
	local length = math.clamp(length or 25,5,1000)
	local old_length = str:len()
	local abytes = {str:byte(1,-1)}
	local bbytes = {}
	local cbytes = 1
	local newnum = ""
	for i,value in next,abytes do
		table.insert(bbytes,bit32.rshift(value^(5),2))
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
	local log10_value = tostring(math.log10(cbytes/2)):sub(6,-1)*2
	log10_value = bit32.rrotate(log10_value,old_length)
	log10_value = bit32.lshift(log10_value,math.sqrt(old_length))
	local final_nums = log10_value * (2^math.pi) ^ math.pi
	final_nums = math.ceil(final_nums * math.pi)
	final_nums = final_nums
	local hash_str = to_Hex(final_nums)..to_Hex(final_nums/2)..to_Hex(final_nums/3)
	local function get_hash_str(string1,length1)
		local string1 = string1
		if string1:len()<length1 then
			repeat
				string1 = string1..string1:rep(1):reverse()
			until string1:len()>=length1
		end
		return string1:sub(1,length1)
	end
	return get_hash_str(hash_str,length):reverse():lower()
end
