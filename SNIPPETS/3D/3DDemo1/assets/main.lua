local obj=loadObj("|R|","well.coveredopen.obj")
--local obj=loadObj("gfx","well.coveredopen.obj")

local scrw,scrh=application:getContentWidth(),application:getContentHeight()
local view=Viewport.new()
local vp=Matrix.new()
vp:perspectiveProjection(45,-scrw/scrh,0.01,1000)
view:setProjection(vp)
view:setPosition(scrw/2,scrh/2)
view:setScale(scrw/2,scrh/2,1)

Lighting.apply(obj)
local mix,miy,miz,max,may,maz=obj.min[1],obj.min[2],obj.min[3],obj.max[1],obj.max[2],obj.max[3]
local cx,cy,cz=(mix+max)/2,(miy+may)/2,(miz+maz)/2
local ex,ey,ez=max-mix,may+miy,maz-miz
local em=math.max(ex,ey,ez)
local cnt=Sprite.new()

view:setContent(cnt)
--print(mix,miy,miz,max,may,maz)
--print(em,cx,cy,cz)
local rad=em*2

view:addEventListener(Event.ENTER_FRAME, function (self)
	local frm=Core.frameStatistics().frameCounter
	local angle=frm/70
	local ex,ey,ez=math.sin(angle)*rad,math.sin(frm/200)*rad/3+rad/2,math.cos(angle)*rad
	view:lookAt(ex,ey,ez,0,0,0,0,1,0)
	local lx,ly,lz=view:getTransform():transformPoint(-3*rad,3*rad,-5*rad)
	Lighting.setLight(lx,ly,lz,0.5)
end)

stage:addChild(view)

--Scene
local ground_sz=em*100
local ground=Pixel.new(0x008000,1,ground_sz,ground_sz)
ground:setPosition(-ground_sz/2,0,-ground_sz/2)
ground:setRotationX(90)
cnt:addChild(ground)

local i1=Viewport.new()
i1:setContent(obj)
i1:setPosition(-em/2,0,-em/2)
cnt:addChild(i1)

local i1=Viewport.new()
i1:setContent(obj)
i1:setPosition(em/2,0,em/2)
cnt:addChild(i1)

local i1=Viewport.new()
i1:setContent(obj)
i1:setPosition(-em/2,0,em/2)
cnt:addChild(i1)

local i1=Viewport.new()
i1:setContent(obj)
i1:setPosition(em/2,0,-em/2)
cnt:addChild(i1)

--cnt:setAnchorPosition(cx,cy,cz)

--Lighting.setSpecular(0.3,0.3,0.3,32)
Lighting.setSpecular(0.3,2.8,0.3,32)
