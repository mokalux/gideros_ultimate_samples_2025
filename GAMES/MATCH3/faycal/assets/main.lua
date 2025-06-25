marx=40
mary=30
size=40
local sw={0,0,0,0,0,0,0,0,0}
 
local texture = Texture.new("63.png")
local image = Bitmap.new(texture)
image:setPosition(-25, 0)
stage:addChild(image)

for i=0,5 do
	for j=0,8 do
		local gr= grid.new(size+1)
		gr:setPosition(i*(size+1)+marx,j*(size+1)+mary)
		stage:addChild(gr)
	end
end

for i=0,5 do
sw[i]={0,0,0,0,0,0,0,0,0}
	for j=0,8 do
		   sw[i][j] = shapes.new(size,math.random(1,5),i,j)
			sw[i][j]:setPosition(i*(size+1)+marx,j*(size+1)+mary) 
			local tt=sw[i][j]
			sw[tt.xx][tt.yy]:addEventListener("clickdown", function()
			 testt(tt.xx,tt.yy,tt.xx,tt.yy+1,true,41)
			end)
			
			sw[i][j]:addEventListener("clickup", function()
			 testt(tt.xx,tt.yy,tt.xx,tt.yy-1,true,-41)
			end)
			
			sw[i][j]:addEventListener("clickright", function()
			 testt(tt.xx,tt.yy,tt.xx+1,tt.yy,false,41)
			end)
			
			sw[i][j]:addEventListener("clickleft", function()
			 testt(tt.xx,tt.yy,tt.xx-1,tt.yy,false,-41)
			end)
			
			stage:addChild(sw[i][j])
	end
end

function testt(a,b,c,d,tr,si)
	print(""..a.." "..b.."")
	if((0<=c and c<=5) and (0<=d and d<=8)) then
		local dummy=sw[a][b]
		local dummy1=sw[a][b].xx
		local  dummy2=sw[a][b].yy

		sw[a][b].xx=sw[c][d].xx
		sw[a][b].yy=sw[c][d].yy
		sw[c][d].xx=dummy1
		sw[c][d].yy=dummy2

		sw[a][b]=sw[c][d]
		sw[c][d]=dummy

		sw[a][b]:move(tr,-si,true)
		local tweeen=sw[c][d]:move(tr,si,true)
--		Timer.delayedCall(250, function ()
--			if (checkgrid()) then
--				addbeans()
--			else
		tweeen:addEventListener("complete", function()
			print("fff")
			if not checkgrid() then
				dummy1=sw[a][b].xx
				dummy2=sw[a][b].yy
				sw[a][b].xx=sw[c][d].xx
				sw[a][b].yy=sw[c][d].yy
				sw[c][d].xx=dummy1
				sw[c][d].yy=dummy2

				dummy=sw[a][b]
				sw[a][b]=sw[c][d]
				sw[c][d]=dummy

				sw[a][b]:move(tr,-si,true)
				sw[c][d]:move(tr,si,true)

--				sw[a][b]:move(tr,si,true)
--				sw[c][d]:move(tr,-si,true)
--			end
--		end)
			end
		end)
	end
end

function checkgrid()
local dm=0
local save=6
local ismatch=false
for cx=0,5 do
for cy=0,8 do

if(cx<4 and sw[cx][cy].tt==sw[cx+1][cy].tt and sw[cx+1][cy].tt==sw[cx+2][cy].tt and sw[cx][cy].tt~=6 and sw[cx][cy].tt~=7)then
	print ("match found")
	save=sw[cx][cy].tt
	dm=cx
	local twt
	while dm<=5 and save==sw[dm][cy].tt do
		sw[dm][cy]:explode(dm,cy,marx,mary,size)
		sw[dm][cy].tt=6
		dm=dm+1
	end

-----------xxxxxxxxxxxxxxxx

ismatch=true
end

if(cy<7 and sw[cx][cy].tt==sw[cx][cy+1].tt and sw[cx][cy+1].tt==sw[cx][cy+2].tt and sw[cx][cy].tt~=6 and sw[cx][cy].tt~=7)then
print ("match found")
save=sw[cx][cy].tt

dm=cy


  local twty
 while    dm<=8 and save==sw[cx][dm].tt  do
sw[cx][dm]:explode(cx,dm,marx,mary,size)
sw[cx][dm].tt=6
dm=dm+1
end


ismatch=true
end

end

end

Timer.delayedCall(400, function () 
if ismatch then print("ccc")addbeans() end

end)
return ismatch

end

function pufx(dm,cy,save)

Timer.delayedCall(250, function ()
while    dm<=5 and save==sw[dm][cy].tt  do
  
stage:removeChild(sw[dm][cy])
sw[dm][cy]=shapes.new(size,6,dm,cy)
sw[dm][cy]:setPosition((dm)*(size+1)+marx,cy*(size+1)+mary)
 stage:addChild(sw[dm][cy])
sw[dm][cy]:explode()

 
 dm=dm+1
 end
end)
end

function pufy(cx,dm,save)

Timer.delayedCall(250, function ()
while dm<=8 and save==sw[cx][dm].tt  do

stage:removeChild(sw[cx][dm])
sw[cx][dm]=shapes.new(size,6,cx,dm)
sw[cx][dm]:setPosition(cx*(size+1)+marx,(dm)*(size+1)+mary)
stage:addChild(sw[cx][dm])
sw[cx][dm]:explode()

dm=dm+1

end
end)
end



function addbeans()
local ddc
for i=0,5 do
 
 local j=0
 while j<9 do
 

if (sw[i][j].tt==6 ) then 

local k=j
local cp=0
			while k<9 and sw[i][k].tt==6  do 
			cp=cp+1
			k=k+1
			end
  
 
 k=k-1
 
 local r=j-1

 while r>=0 do

 
   
local dummy=sw[i][r+cp]
 local dummy1=sw[i][r+cp].xx
local  dummy2=sw[i][r+cp].yy

sw[i][r+cp].xx=sw[i][r].xx
sw[i][r+cp].yy=sw[i][r].yy
sw[i][r].xx=dummy1
sw[i][r].yy=dummy2



sw[i][r+cp]=sw[i][r]

 
sw[i][r]=shapes.new(size,6,i,r)
sw[i][r]:setPosition(i*(size+1)+marx,r*(size+1)+mary)
 --stage:addChild(sw[i][r])
 	 
-- GTween.new(sw[i][r+cp], 0.5, {y = sw[i][r+cp].yy*41+mary}, { ease = easing.Leaner})
 
 --sw[i][r+cp]:setPosition(sw[i][r+cp]:getX(),sw[i][r+cp].yy*41+mary)
 
r=r-1
		end
		
		for pcp=0,cp-1 do 
		
		sw[i][pcp]=shapes.new(size,math.random(1,5),i,pcp)
		sw[i][pcp]:setPosition(i*(size+1)+marx,pcp*(size+1)+mary-41*cp)
	 
	 local tt=sw[i][pcp]
			sw[i][pcp]:addEventListener("clickdown", function()
			 testt(tt.xx,tt.yy,tt.xx,tt.yy+1,true,41)
			end)
			
			sw[i][pcp]:addEventListener("clickup", function()
			 testt(tt.xx,tt.yy,tt.xx,tt.yy-1,true,-41)
			end)
			
			sw[i][pcp]:addEventListener("clickright", function()
			 testt(tt.xx,tt.yy,tt.xx+1,tt.yy,false,41)
			end)
			
			sw[i][pcp]:addEventListener("clickleft", function()
			 testt(tt.xx,tt.yy,tt.xx-1,tt.yy,false,-41)
			end)
			
	 
	stage:addChild(sw[i][pcp])	
	 
	--GTween.new(sw[i][pcp], 0.5, {y = sw[i][pcp].yy*41+mary}, { ease = easing.Leaner})
 
 --sw[i][pcp]:setPosition(sw[i][pcp]:getX(),sw[i][pcp].yy*41+mary)
 
	end
	     
		 j=-1
end
  j=j+1
  end
  
  
  for j=0,8 do
  --ddc=GTween.new(sw[i][j], 2.8+j/40, {y = sw[i][j].yy*41+mary}, { ease = easing.outBounce,dispatchEvents = true})
  sw[i][j]:setScale(1,1)
  sw[i][j]:setX(sw[i][j].xx*41+marx)
  ddc=GTween.new(sw[i][j],0.5+j/40+i/40, {y = sw[i][j].yy*41+mary}, { ease = easing.outBack,dispatchEvents = true})
  end
  
  end
  
  ddc:addEventListener("complete", function()
     checkgrid()        end)
end
 

----------------------------------------------------
local fg=1
while fg<2 do 
 fg=fg+1
 addbeans()
end

-- measure memory and frames per seconds (fps)
frame = 0
timer = os.timer()
qFloor = math.floor -- optimization
 
function displayFps(event)
	frame = frame + 1
	if frame == 60 then
		local currentTimer = os.timer()
--		print("fps: "..qFloor(60 / (currentTimer - timer)), " ,Texture Memory:", application:getTextureMemoryUsage()/1024, "Mb")
		frame = 0
		timer = currentTimer
--		print ("memory used: "..collectgarbage("count")/1000,"Mb") -- optional
	end
 
end
 
-- Add fps counter to stage
stage:addEventListener(Event.ENTER_FRAME, displayFps)
