StarWarsEffect=Core.class(Sprite)

function StarWarsEffect:init(width,height,farwidth,texture,distanceeffect)
 local mesh=Mesh.new()
 self:addChild(mesh)
if distanceeffect==nil then
distanceeffect=0.3
end
local steps=height/2
local farlen=farwidth
local fardist=height
local nearlen=width
local tw=texture:getWidth()
local th=texture:getHeight()
for i=0,steps-1,1 do
	local vset=i*4+1
	local vfy=fardist*i/steps
	local vfl=(((nearlen-farlen)*i/steps)+farlen)/2
	local vfx1=(nearlen/2)-vfl
	local vfx2=(nearlen/2)+vfl
	local vny=fardist*(i+1)/steps
	local vnl=(((nearlen-farlen)*(i+1)/steps)+farlen)/2
	local vnx1=(nearlen/2)-vnl
	local vnx2=(nearlen/2)+vnl
	local tfr=i/steps
	local tf=th*math.pow(tfr,distanceeffect)
	local tnr=(i+1)/steps
	local tn=th*math.pow(tnr,distanceeffect)
	local cf=(i/steps)
	local cn=((i+1)/steps)
	local iset=i*6+1
	mesh:setVertices(vset,vfx1,vfy,vset+1,vfx2,vfy,vset+2,vnx1,vny,vset+3,vnx2,vny)
	mesh:setTextureCoordinates(vset,0,tf,vset+1,tw,tf,vset+2,0,tn,vset+3,tw,tn)
	mesh:setColors(vset,0xffff00,cf,vset+1,0xffff00,cf,vset+2,0xffff00,cn,vset+3,0xffff00,cn)
	mesh:setIndices(iset+0,vset+0,iset+1,vset+1,iset+2,vset+3)
	mesh:setIndices(iset+3,vset+0,iset+4,vset+3,iset+5,vset+2)
end
mesh:setTexture(texture)

end
