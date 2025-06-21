# Gideros Cross Promo
Cross promotion tool for Gideros 

# Methods
## CrossPromo.new(key)
Create instance of CrossPromo class with your API key

## CrossPromo:setGenre(genre)
Set genre to fetch

## CrossPromo:setIgnore(ignore)
Set app name to ignore when fetching list of apps

## CrossPromo:setName(name)
Set app name to fetch, if you want to fetch specific app and its details

## CrossPromo:request()
Make request to fetch apps, dispatches Event.COMPLETE or Event.ERROR

## CrossPromo:getImage(url)
Downloads and caches image, dispatches Event.IMAGE_COMPLETE or Event.IMAGE_ERROR

## CrossPromo:reset()
Reset all your cross promo parameters

# Events
## Event.COMPLETE
Successfully fetched information about apps, event object should have
### e.data - containing data fetched from server

## Event.ERROR
Could not fetch information about apps, event object should have
### e.error - error message

## Event.IMAGE_COMPLETE
Successfully downloaded image, event object should have
### e.url - url of the image downloaded
### e.path - path where image is saved to use in Gideros

## Event.ERROR
Could not download image, event object should have
### e.url - url of the imaged tried to download
### e.error - error message
