dx = application:getLogicalTranslateX() / application:getLogicalScaleX()
dy = application:getLogicalTranslateY() / application:getLogicalScaleY()

myTexturepackFunc = TexturePack.new

TexturePack.new = function(file1,file2,bool)
	return myTexturepackFunc(file1,file2,true)
end
myTextureFunc = Texture.new

Texture.new = function(param,bool)
	return myTextureFunc(param,true)
end

Sprite._set = Sprite.set
Sprite._get = Sprite.get

function Sprite:set(param, value)
		
	if param=="anchor" then
		self.anchor=value
		self:setAnchorPoint(value,value)
	else
		Sprite._set(self, param, value)
	end
end


function Sprite:get(param)

	if param=="anchor" then
		return self.anchor
	
	end
	return Sprite._get(self,param)
end

function drawRect(left,top,width,height)
	local shape = Shape.new()
	shape:setFillStyle(Shape.SOLID, 0x00ff00, 1)
	shape:beginPath()
	shape:moveTo(0,0)
	shape:lineTo(width, 0)
	shape:lineTo(width, height)
	shape:lineTo(0, height)
	
	shape:closePath()
	shape:endPath()
	shape:setPosition(left,top)
	return shape
end 

function string:split(pat)
   local t = {}
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = self:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
		table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = self:find(fpat, last_end)
   end
   if last_end <= #self then
      cap = self:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

function getPackTextures(txtFile)
    local textures = {}
    local file = io.open(txtFile)
	
    if file then
        local parsed
        for line in file:lines() do
            parsed = line:split(", ")
            textures[#textures+1] = parsed[1]
        end
        
    else
       -- print("no pack found")
    end
	
    return textures
end

function unPackTextures(packname,txtFile)
	local myArr = getPackTextures(txtFile)
	local myTextures = {}
	for i=1,#myArr do	
		myTextures[i] = packname:getTextureRegion(myArr[i])
	end
	return myTextures
end

function reverseFile(txtFile)
	
    local file = io.open(txtFile)
	
	local myLineReverseArr = {}
    if file then
        local parsed
        for line in file:lines() do
            parsed = line:split(", ")
			
			table.insert(myLineReverseArr,line)
        end
        
    else
        print("no pack found")
    end
    for i=#myLineReverseArr,1,-1 do
		print(myLineReverseArr[i])
	end
end

function countTotalChildren(parent)
	local count = 0
	for i = 1,parent:getNumChildren() do
		count = count + 1
		local child = parent:getChildAt(i)
		count = count + countTotalChildren(child)
	end
	return count
end