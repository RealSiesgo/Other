local bit = bit32
local hash = function(str : string , length : number ) : string
	assert(type(str)=="string","<HASH> Expected String in argument #1. Got "..type(str)..".")
	assert(type(length)=="number" or length==nil,"<HASH> Expected Number in argument #2. Got "..type(length)..".")
	local length = math.clamp(length or 25,1,1000)
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
			cbytes*=math.sqrt(value/math.pi)/(old_length*2)
		else
			cbytes+=math.sqrt(value/math.pi)
		end
	end
	print(cbytes)
	local log10_value = tostring(math.log10(cbytes/2)):sub(6,-1)*2
	log10_value = bit32.rrotate(log10_value,old_length)
	log10_value = bit32.lshift(log10_value,old_length/5)
	local final_nums = log10_value * (2^math.pi) ^ math.pi
	final_nums = math.ceil(final_nums * math.pi)
	final_nums = tostring(final_nums):rep(1)
	local function xzxc(num)
		local num = tonumber(num)
		local text = ""
		local function a(num)
			if old_length<100 then
				return num^2
			else
				return -math.floor(num+cbytes)
			end
		end
		for i=1,length do
			local choose = Random.new(num+(a(i))):NextInteger(1,3)
			if choose ~= 1 then
				local new = Random.new(num+(a(i))):NextInteger(0,9)
				text = text..new
			else
				local new = string.char(Random.new(num+(a(i))):NextInteger(97,102,5))
				text = text..new
			end
		end
		return text
	end
	final_nums = final_nums
	--print(final_nums)
	local result = xzxc(final_nums)
	--newnum=(bit.arshift(newnum,2))
	return result
end
