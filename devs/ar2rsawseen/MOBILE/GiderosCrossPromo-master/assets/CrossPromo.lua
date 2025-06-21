CrossPromo = Core.class(EventDispatcher)

if not Event.IMAGE_COMPLETE then
	Event.IMAGE_COMPLETE = "imageComplete"
end

if not Event.IMAGE_ERROR then
	Event.IMAGE_ERROR = "imageError"
end

if not Event.COMPLETE then
	Event.COMPLETE = "complete"
end

if not Event.ERROR then
	Event.ERROR = "error"
end

if not string.split then
	function string:split(sep)
		local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        self:gsub(pattern, function(c) fields[#fields+1] = c end)
        return fields
	end
end

local function exists(file)
	local f = io.open(file, "rb")
	if f == nil then
		return false
	end
	f:close()
	return true
end

function CrossPromo:init(key)
	if not json then
		require "json"
	end
	self.url = "http://giderosmobile.com/api/crosspromo.php"
	self.key = key or ""
	self:reset()
end

function CrossPromo:reset()
	self.loaded = false
	self.genre = ""
	self.ignore = ""
	self.name = ""
end

function CrossPromo:setGenre(genre)
	self.genre = genre
end

function CrossPromo:setIgnore(ignore)
	self.ignore = ignore
end

function CrossPromo:setName(name)
	self.name = name
end

function CrossPromo:dispatchComplete(data)
	local e = Event.new(Event.COMPLETE)
	e.data = data
	self:dispatchEvent(e)
end

function CrossPromo:dispatchError(error)
	local e = Event.new(Event.ERROR)
	e.error = error or "Error"
	self:dispatchEvent(e)
end

function CrossPromo:dispatchImageComplete(url, path)
	local e = Event.new(Event.IMAGE_COMPLETE)
	e.url = url
	e.path = path
	self:dispatchEvent(e)
end

function CrossPromo:dispatchImageError(url, error)
	local e = Event.new(Event.IMAGE_ERROR)
	e.url = url
	e.error = error or "Error"
	self:dispatchEvent(e)
end

function CrossPromo:getCache()
	local data = dataSaver.load("|D|crosspromo")
	if data then
		self.data = data
		return true
	end
	return false
end

function CrossPromo:cacheResponse()
	dataSaver.save("|D|crosspromo", self.data)
end

function CrossPromo:request()
	local url = self.url.."?key="..self.key
	if self.genre ~= "" then
		url = url.."&genre="..self.genre
	end
	if self.ignore ~= "" then
		url = url.."&ignore="..self.ignore
	end
	if self.name ~= "" then
		url = url.."&name="..self.name
	end
	local loader = UrlLoader.new(url)
	loader:addEventListener(Event.COMPLETE, function(e)
		local data = json.decode(e.data)
		if e.error then
			if self:getCache() then
				self:dispatchComplete(self.data)
			else
				self:dispatchError(e.error)
			end
		else
			self.data = data
			self:cacheResponse()
			self:dispatchComplete(self.data)
		end
	end)
	loader:addEventListener(Event.ERROR, function()
		if self:getCache() then
			self:dispatchComplete(self.data)
		else
			self:dispatchError("Network Error")
		end
	end)
end

function CrossPromo:getImage(url)
	local img = string.split(url, "/")
	img = img[#img]
	local filename = "|D|"..img
	if not exists(filename) then
		local loader = UrlLoader.new(url)
		loader:addEventListener(Event.COMPLETE, function(event)
			local out = io.open(filename, "wb")
			out:write(event.data)
			out:close()
			self:dispatchImageComplete(url, filename)
		end)
		loader:addEventListener(Event.ERROR, function()
			self:dispatchImageError(url, "Network Error")
		end)
	else
		self:dispatchImageComplete(url, filename)
	end
end
