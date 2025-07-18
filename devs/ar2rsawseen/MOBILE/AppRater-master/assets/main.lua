local apprater = AppRater.new({
	androidRate = "link to your Android app...", --link to rate Android app
	iosRate = "link to your IOS app...",     --link to rate IOS app
	timesUsed = 3, -- 3 for testing purposes, 15 seems fair?, times to use before asking to rate
	daysUsed = 30,    --days to use before asking to rate
	version = 0,      --current version of the app
	remindTimes = 5,  --times of use to wait before reminding
	remindDays = 5,    --days of use to wait before reminding
	rateTitle = "Rate My App",
	rateText = "Please rate my app",
	rateButton = "Rate it now!",
	remindButton = "Remind me later",
	cancelButton = "No, thanks"
})

--apprater:reset()
