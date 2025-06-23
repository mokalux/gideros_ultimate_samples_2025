local shader=Shader.new("blur/vShader","blur/fShader",0,
{
{name="vMatrix",type=Shader.CMATRIX,sys=Shader.SYS_WVP,vertex=true},
{name="fColor",type=Shader.CFLOAT4,sys=Shader.SYS_COLOR,vertex=false},
{name="fColorMod",type=Shader.CFLOAT4,vertex=false},
{name="fTexture",type=Shader.CTEXTURE,vertex=false},
{name="fTexelSize",type=Shader.CFLOAT4,vertex=false},
{name="fRad",type=Shader.CINT,vertex=false},
},
{
{name="vVertex",type=Shader.DFLOAT,mult=3,slot=0,offset=0},
{name="vColor",type=Shader.DUBYTE,mult=4,slot=1,offset=0},
{name="vTexCoord",type=Shader.DFLOAT,mult=2,slot=2,offset=0},
});

assert(shader:isValid(), "Invalid shader.")

GShape = Core.class(Path2D)

function GShape:init(name, ...)
	self.name = name
	self.needToUpdate = false
	self[name](self, ...)
	self.blurShader = shader
	self:initShader(2)
--	self:initShader(3)
	self:updateBlur()
end
--
function GShape:initShader(blurLevel)
	local texw, texh = self:getSize()
	--Initial blur level
	self.blurShader:setConstant("fRad",Shader.CINT,1,blurLevel)
	--Initial texel size
	self.blurShader:setConstant("fTexelSize",Shader.CFLOAT4,1,{1/texw,1/texh,0,0})
	
	self.blurBG = RenderTarget.new(texw,texh,false)
	self.blurBG:draw(stage)
	self.blurIMG = Bitmap.new(self.blurBG)
	self.blurIMG:setShader(self.blurShader)
	
	self.RT = RenderTarget.new(texw,texh,true)
	self:setTexture(self.RT)
	self:setShader(self.blurShader)
end
--
function GShape:updateBlur()
	local x,y = self:getPosition()
	local offsetX, offsetY = 0, 0
	local texw, texh = self:getSize()
	
	-- circle is centerd, so we need to offset drawing position by its radius
	if (self.name == "circle") then 
		offsetX = self.r
		offsetY = self.r
	elseif (self.name == "rect") then -- mokalux
		offsetX = self.w/2 -- mokalux
		offsetY = self.h/2 -- mokalux
	end
	self:setVisible(false)
	self.blurBG:draw(stage, -x+offsetX, -y+offsetY)
	self:setVisible(true)
	
	self.blurShader:setConstant("fTexelSize",Shader.CFLOAT4,1,{0,16/texh,0,0}) --Step 1: Vertical blur
	self.RT:draw(self.blurIMG)
	self.blurShader:setConstant("fTexelSize",Shader.CFLOAT4,1,{1/texw,0,0,0}) --Step 2: Horizontal blur
end
--
function GShape:circle(r)
	self.r = r
	local ms="MAAZ"
	local mp={-r,0, r,r,0,0,0,r,0, r,r,0,0,0,-r,0}
	self:setPath(ms,mp)
	
	self:setFillColor(0xffffff, 1)
	self:setLineColor(0, 1)
	self:setLineThickness(2, 1)
end
--
function GShape:rect(w, h)
	self.w, self.h = w, h -- mokalux
	local ms="MHVHVZ"
	local mp={0,0, w, h, 0, 0}
	self:setPath(ms,mp)
	
	self:setFillColor(0xffffff, 1)
	self:setLineColor(0, 1)
	self:setLineThickness(2, 1)
	self:setAnchorPoint(0.5, 0.5) -- mokalux
end
--
function GShape:rrect(w,h,r)
	local ms="MALALALAZ"
	local mp = {0,r, r,r,0,0,1,r,0, w-r,0, r,r,0,0,1,w,r, w,h-r, r,r,0,0,1,w-r,h, r,h, r,r,0,0,1,0,h-r}
	self:setPath(ms,mp)
	
	self:setFillColor(0xffffff, 1)
	self:setLineColor(0, 1)
	self:setLineThickness(4, 1)
end
--
function GShape:setPosition(x, y)
	Path2D.setPosition(self, x, y)
	self:updateBlur()
end