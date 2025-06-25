--[[
Load meshes from a wavefromt .obj file
Usage:
sprite=loadObj(path,file) : load the file located at path/file

Returned sprite has a few specific attributes:
- objs: table referencing all objects within the loaded file

]]
local function Split(str, delim, maxNb)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gmatch(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

local function parsemtl(mtls,path,file)
 if not io.open(file) then return end
 local mtl={ texturew=0, textureh=0 }
 for line in io.lines(path.."/"..file) do
  fld=Split(line," ",6)
  for i=1,#fld,1 do
  fld[i]=string.gsub(fld[i], "\r", "") 
  end
  if (fld[2]~=nil) then
	fld[2]=string.gsub(fld[2], "\r", "")
  end
  if fld[1]=="newmtl" then
    --print("DM",fld[2])
    mtl={texturew=0, textureh=0}
	mtls[fld[2]]=mtl
  elseif fld[1]=="Kd" then
   mtl.kd={fld[2],fld[3],fld[4],1.0}
  elseif fld[1]=="map_Kd" then
   table.remove(fld,1)
   local f=table.concat(fld," ")
   --print("Texture:.. ["..path.."/"..f.."]")
   mtl.texture=Texture.new(path.."/"..f,true,{ wrap=TextureBase.REPEAT })
   mtl.texturew=mtl.texture:getWidth()
   mtl.textureh=mtl.texture:getHeight()
  elseif fld[1]=="map_Bump" then
   table.remove(fld,1)
   local f=table.concat(fld," ")
   --print("Texture:.. ["..path.."/"..f.."]")
   mtl.normalMap=Texture.new(path.."/"..f,true,{ wrap=TextureBase.REPEAT })
   mtl.normalMapW=mtl.normalMap:getWidth()
   mtl.normalMapH=mtl.normalMap:getHeight()
  end
 end
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

function importObj(path,file,imtls)
 local root={}
 v = {}
 imap = nil
 vt = {}
 vn = {}
 mtls=imtls or {}
 mtl=nil
 root.type="group"
 root.parts={}
 oname=nil
 local function buildObject()  
	local m=nil
	if (imap~=nil) then
		local treeDesc=G3DFormat.mapCoords(v,vt,vn,imap)
		treeDesc.type="mesh"
		treeDesc.material=mtl
		local sobj=root.parts[oname]
		if sobj==nil then
			sobj={ type="group", parts={} }
			root.parts[oname]=sobj
		end
		table.insert(sobj.parts,treeDesc)		
		--[[print(oname,m.min[1],m.min[2],m.min[3],m.max[1],m.max[2],m.max[3])
		if string.starts(oname,"light") then
			lightPosX,lightPosY,lightPosZ=m.center[1],m.center[2],m.center[3]
			lightRef=m
		end]]
		imap=nil
	end
 end
 for line in io.lines(path.."/"..file) do
  fld=Split(line," ")
  for i=1,#fld,1 do
  fld[i]=string.gsub(fld[i], "\r", "") 
  end
  if fld[1]=="v" then
	table.insert(v,tonumber(fld[2]))
	table.insert(v,tonumber(fld[3]))
	table.insert(v,tonumber(fld[4]))
  elseif fld[1]=="vn" then
	table.insert(vn,tonumber(fld[2]))
	table.insert(vn,tonumber(fld[3]))
	table.insert(vn,tonumber(fld[4]))
  elseif fld[1]=="vt" then
	table.insert(vt,tonumber(fld[2]))
	table.insert(vt,tonumber(fld[3]))
  elseif fld[1]=="f" then
	local itab={}
	for ii=2,#fld,1 do
		if (fld[ii]~=nil) and (fld[ii]~="") then
			local ifl=Split(fld[ii],"/",3) 			
			table.insert(itab,{ v=tonumber(ifl[1]), t=tonumber(ifl[2]), n=tonumber(ifl[3])})
		end
	end
	if imap==nil then imap={} end
	table.insert(imap,itab)
  elseif fld[1]=="o" or fld[1]=="g" then
  buildObject()
  --print(line)
  oname=fld[2]
  elseif fld[1]=="mtllib" then
   table.remove(fld,1)
   parsemtl(mtls,path,table.concat(fld," "))
  elseif fld[1]=="usemtl" then
   buildObject()
   mtl=fld[2]
  end
 end
 --spr:setColorTransform(1.0,0,0,1.0)
 buildObject() --If any in progress
 G3DFormat.computeG3DSizes(root)
 return root,mtls
end

function loadObj(path,file,imtls)
 local root,mtls=importObj(path,file,imtls)
 return G3DFormat.buildG3D(root,mtls)
end
