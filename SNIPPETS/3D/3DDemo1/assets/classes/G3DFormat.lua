G3DFormat={}

function G3DFormat.computeG3DSizes(g3d)
	if g3d.type=="group" then
		for _,v in pairs(g3d.parts) do
			G3DFormat.computeG3DSizes(v)
			if g3d.min then
				g3d.min={math.min(g3d.min[1],v.min[1]),math.min(g3d.min[2],v.min[2]),math.min(g3d.min[3],v.min[3])}
				g3d.max={math.max(g3d.max[1],v.max[1]),math.max(g3d.max[2],v.max[2]),math.max(g3d.max[3],v.max[3])}
			else
				g3d.min={v.min[1],v.min[2],v.min[3]}
				g3d.max={v.max[1],v.max[2],v.max[3]}
			end
		end
	elseif g3d.type=="mesh" then
		local minx,miny,minz=100000,100000,100000
		local maxx,maxy,maxz=-100000,-100000,-100000
		for i=1,#g3d.vertices-2,3 do
		 local x,y,z=g3d.vertices[i],g3d.vertices[i+1],g3d.vertices[i+2]
		 minx=math.min(minx,x)
		 miny=math.min(miny,y)
		 minz=math.min(minz,z)
		 maxx=math.max(maxx,x)
		 maxy=math.max(maxy,y)
		 maxz=math.max(maxz,z)
		end
		g3d.min={minx,miny,minz}
		g3d.max={maxx,maxy,maxz}
	else
		assert(g3d.type,"No type G3D structure")
		assert(false,"Unrecognized object type: "..g3d.type)
	end
	g3d.center={(g3d.max[1]+g3d.min[1])/2,(g3d.max[2]+g3d.min[2])/2,(g3d.max[3]+g3d.min[3])/2}
end

function G3DFormat.buildG3DObject(obj,mtls)
	mtls=mtls or {}
	m=Mesh.new(true)
	m:setVertexArray(obj.vertices)
	m:setIndexArray(obj.indices)
	mtl={}
	if obj.material then 
		mtl=mtls[obj.material]
		assert(mtl,"No such material: "..obj.material)
	end
	if obj.color then
		m:setColorTransform(obj.color[1],obj.color[2],obj.color[3],obj.color[4])
	end
	--m:setColorArray(c)
	if mtl.textureFile and not mtl.texture then
		mtl.texture=Texture.new(mtl.textureFile,true)
		mtl.texturew=mtl.texture:getWidth()
		mtl.textureh=mtl.texture:getHeight()
	end
	if (mtl.texture~=nil) then
		m:setTexture(mtl.texture)
		local tc={}
		for i=1,#obj.texcoords,2 do
			tc[i]=obj.texcoords[i]*mtl.texturew
			tc[i+1]=obj.texcoords[i+1]*mtl.textureh
		end
		m:setTextureCoordinateArray(tc)
		m.hasTexture=true
	end
	if mtl.normalMapFile and not mtl.normalMap then
		mtl.normalMap=Texture.new(mtl.normalMapFile,true)
		mtl.normalMapW=mtl.normalMap:getWidth()
		mtl.normalMapH=mtl.normalMap:getHeight()
	end
	if (mtl.normalMap~=nil) then
		m:setTexture(mtl.normalMap,1)
		m.hasNormalMap=true
	end
	if mtl.kd then
		m:setColorTransform(mtl.kd[1],mtl.kd[2],mtl.kd[3],mtl.kd[4])
	end
	if obj.normals then
		m.hasNormals=true
		m:setGenericArray(3,Shader.DFLOAT,3,#obj.normals/3,obj.normals)
	end
	return m
end

function G3DFormat.buildG3D(g3d,mtl)
	local spr=nil
	if g3d.type=="group" then
		spr=Sprite.new()
		spr.objs={}
		for k,v in pairs(g3d.parts) do
			local m=G3DFormat.buildG3D(v,mtl)
			spr:addChild(m)
			spr.objs[k]=m
		end
	elseif g3d.type=="mesh" then
		spr=G3DFormat.buildG3DObject(g3d,mtl)
	else
		assert(g3d.type,"No type G3D structure")
		assert(false,"Unrecognized object type: "..g3d.type)
	end
	if spr then
	 spr.min=g3d.min
	 spr.max=g3d.max
	 spr.center=g3d.center
	 if g3d.transform then
		local m=Matrix.new()
		m:setMatrix(unpack(g3d.transform))
		spr:setMatrix(m)
	 end
	end
	return spr
end

function G3DFormat.mapCoords(v,t,n,faces)
	imap={}
	vmap={}
	imap.alloc=function(self,facenm,i)
		 local iv=i.v or 0
		 if (iv<0) then
			iv=(#v/3+1+iv)
		 end
		 iv=iv-1
		 local it=i.t or 0
		 if (it==nil) then																																														
		  it=-1
		 else
		  if (it<0) then
			it=(#t/2)+it+1
		  end
		  it=it-1
		 end
		 local inm=i.n or 0
		 if (inm<0) then
		  inm=(#n/3)+inm+1
		 end
		 inm=inm-1
		 if inm==-1 then inm=facenm.code end
		 local ms=iv..":"..it..":"..inm
		 if vmap[ms]==nil then
			local ni=self.ni+1
			self.ni=ni
			table.insert(facenm.lvi,#self.lv)
			assert(v[iv*3+1],"Missing Vertex:"..iv)
			table.insert(self.lv,v[iv*3+1])
			table.insert(self.lv,v[iv*3+2])
			table.insert(self.lv,v[iv*3+3])
			if it>=0 then
				table.insert(self.lvt,t[it*2+1])
				table.insert(self.lvt,(1-t[it*2+2]))
			else 
				table.insert(self.lvt,0)
				table.insert(self.lvt,0)
			end
			if inm>=0 then
				table.insert(self.lvn,n[inm*3+1])
				table.insert(self.lvn,n[inm*3+2])
				table.insert(self.lvn,n[inm*3+3])
			else 
				local vngmap=self.vngmap[iv] or { }
				self.vngmap[iv]=vngmap
				table.insert(vngmap,#self.lvn)
				table.insert(facenm.lvni,#self.lvn)
				table.insert(self.lvn,0)
				table.insert(self.lvn,0)
				table.insert(self.lvn,0)
			end
			self.vmap[ms]=ni
		 end
		 return self.vmap[ms]
	end		
	imap.i={}
	imap.ni=0
	imap.lv={}
	imap.lvt={}
	imap.lvn={}
	imap.vmap={}
	imap.vngmap={}
	imap.gnorm=-2
	
	for _,face in ipairs(faces) do
	local itab={}
	local normtab={ code=imap.gnorm, lvi={}, lvni={} }
	for _,i in ipairs(face) do
		table.insert(itab,imap:alloc(normtab,i))
	end
	imap.gnorm=imap.gnorm-1
	if (#itab>=3) then
		if #normtab.lvni>0 then -- Gen normals
			local ux=imap.lv[normtab.lvi[2]+1]-imap.lv[normtab.lvi[1]+1]
			local uy=imap.lv[normtab.lvi[2]+2]-imap.lv[normtab.lvi[1]+2]
			local uz=imap.lv[normtab.lvi[2]+3]-imap.lv[normtab.lvi[1]+3]
			local vx=imap.lv[normtab.lvi[3]+1]-imap.lv[normtab.lvi[1]+1]
			local vy=imap.lv[normtab.lvi[3]+2]-imap.lv[normtab.lvi[1]+2]
			local vz=imap.lv[normtab.lvi[3]+3]-imap.lv[normtab.lvi[1]+3]
			local nx=uy*vz-uz*vy
			local ny=uz*vx-ux*vz
			local nz=ux*vy-uy*vx
			local nl=math.sqrt(nx*nx+ny*ny+nz*nz)
			if nl==0 then nl=1 end
			nx=nx/nl
			ny=ny/nl
			nz=nz/nl
			for _,vni in ipairs(normtab.lvni) do
				imap.lvn[vni+1]=nx
				imap.lvn[vni+2]=ny
				imap.lvn[vni+3]=nz
			end
		end
		for ii=3,#itab,1 do
			table.insert(imap.i,itab[1])
			table.insert(imap.i,itab[ii-1])
			table.insert(imap.i,itab[ii])
		end
	end
	end
		for _,vm in pairs(imap.vngmap) do
			local nx,ny,nz=0,0,0
			for _,vn in ipairs(vm) do
				nx=nx+imap.lvn[vn+1]
				ny=ny+imap.lvn[vn+2]
				nz=nz+imap.lvn[vn+3]
			end
			local nl=math.sqrt(nx*nx+ny*ny+nz*nz)
			if nl==0 then nl=1 end
			nx=nx/nl
			ny=ny/nl
			nz=nz/nl
			for _,vn in ipairs(vm) do
				imap.lvn[vn+1]=nx
				imap.lvn[vn+2]=ny
				imap.lvn[vn+3]=nz
			end	
		end
	return { vertices=imap.lv, texcoords=imap.lvt, normals=imap.lvn, indices=imap.i }
end
