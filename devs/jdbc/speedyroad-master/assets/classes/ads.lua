Advertise = Core.class()

local android = application:getDeviceInfo() == "Android"
--android = false
local iOS = application:getDeviceInfo() == "iOS"

local android_banner_id = "ca-app-pub-6632080215577631/3284991902" 
local android_interstitial_id = "ca-app-pub-6632080215577631/4761725107"

local ios_banner_id = "ca-app-pub-6632080215577631/4205136303"
local ios_interstitial_id = "ca-app-pub-6632080215577631/5681869502"

--local interval = math.random(1,2)

function Advertise.setup()
	if (android or iOS) then
		require "ads"
		if (android) then
			admob = Ads.new("admob")
			admob:addEventListener(Event.AD_RECEIVED, function(e)
				print("admob AD_RECEIVED")
			end)
			admob:addEventListener(Event.AD_FAILED, function(e)
				print("admob AD_FAILED", e.error)
			end)
		elseif (iOS) then
			iad = Ads.new("iad")
			iad:addEventListener(Event.AD_RECEIVED, function(e)
				print("iad AD_RECEIVED", e.type)
			end)
			iad:addEventListener(Event.AD_FAILED, function(e)
				print("iad AD_FAILED", e.error)
				if (e and e.type == "interstitial") then -- Interstitial
					admob:setKey(ios_interstitial_id)
					admob:showAd("interstitial")
				elseif (e and e.type == "banner") then
					admob:setKey(ios_banner_id)	
					admob:showAd("smart_banner")
					admob:setAlignment("center", "bottom")
				end
			end)
			admob = Ads.new("admob")
		end
	end
end

-- Show banner Ad
function Advertise.showBanner()
	if (android and admob) then
		admob:setKey(android_banner_id)
		admob:showAd("smart_banner")
		admob:setAlignment("center", "bottom")
	elseif (iOS and iad) then
		iad:showAd("banner")
		iad:setAlignment("center", "bottom")
	else
		print("Show banner")
	end
end

function Advertise.hideBanner()
	if (android and admob) then
		admob:hideAd("smart_banner")
	elseif (iOS and iad) then
		iad:hideAd("banner")
		
		if (admob) then
			admob:hideAd("smart_banner")
		end
	else
		print("Hide banner")
	end
end

-- Show interstitial Ad
function Advertise.showInterstitial()
	if (android and admob) then
		admob:setKey(android_interstitial_id)
		admob:showAd("interstitial")
	elseif (iOS and iad) then
		iad:showAd("interstitial")
	else
		print("Show interstitial")
	end
end

-- Open "More games" link
function Advertise.more_games()
	if (android) then
		application:openUrl("market://search?q=pub:JDBC+Games")
		--application:openUrl("amzn://apps/android?p=es.jdbc.speedyroad&showAll=1")
	elseif (iOS) then
		application:openUrl("itms-apps://itunes.com/apps/jesus-d-blazquez-carazo")
	else
		--application:openUrl("http://play.google.com/store/search?q=pub:JDBC+Games")
		application:openUrl("market://search?q=pub:JDBC+Games")
	end
end
