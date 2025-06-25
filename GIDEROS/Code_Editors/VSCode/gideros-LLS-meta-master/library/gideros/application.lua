---@meta
---@diagnostic disable: codestyle-check

---
---The Application class contains the common functions that are available to the current application. There is a global variable application of type Application to access these functions. 
---
---@class Application : Object
-- Orientation
---@field LANDSCAPE_LEFT string "landscapeLeft"
---@field LANDSCAPE_RIGHT string "landscapeRight"
---@field PORTRAIT string "portrait"
---@field PORTRAIT_UPSIDE_DOWN string "portraitUpsideDown"
-- Scale mode
---@field CENTER string # "center"
---@field CROP string # "crop"
---@field FIT_HEIGHT string # "fitHeight"
---@field FIT_WIDTH string # "fitWidth"
---@field LETTERBOX string # "letterbox"
---@field NO_SCALE string # "noScale"
---@field PIXEL_PERFECT string # "pixelPerfect"
---@field STRETCH string # "stretch"
-- Text input (Android)
---@field TEXTINPUT_CLASS_NONE string 0
---@field TEXTINPUT_CLASS_TEXT number 1
---@field TEXTINPUT_CLASS_NUMBER number 2
---@field TEXTINPUT_CLASS_PHONE number 3
---@field TEXTINPUT_CLASS_DATE number 4
---@field TEXTINPUT_TVARIANT_URI number 0x10
---@field TEXTINPUT_TVARIANT_EMAIL number 0x20
---@field TEXTINPUT_TVARIANT_PASSWORD number 0x80
---@field TEXTINPUT_DVARIANT_DATE number 0x10
---@field TEXTINPUT_DVARIANT_TIME number 0x20
---@field TEXTINPUT_NVARIANT_PASSWORD number 0x10
---@field TEXTINPUT_TFLAG_CAPCHARACTERS number 0x1000
---@field TEXTINPUT_TFLAG_CAPWORDS number 0x2000
---@field TEXTINPUT_TFLAG_CAPSENTENCES number 0x4000
---@field TEXTINPUT_TFLAG_AUTOCORRECT number 0x8000
---@field TEXTINPUT_TFLAG_MULTILINE number 0x20000
---@field TEXTINPUT_NFLAG_SIGNED number 0x1000
---@field TEXTINPUT_NFLAG_DECIMAL number 0x2000
Application = {}
application = Application

---
---Tests if it is possible to open provided url using Application:openUrl method (it checks only app permissions, so 'true' may be returned even if device is offline). 
---
---@method
---@param url string # url to test if can be opened
---@return boolean res # returns true if app has permission to open the url, even if device is offline
function Application:canOpenUrl(url) end

---
---Checks if an Android permission has been granted. 
---
---Permission possible values are:
--- > `"android.permission.ACCESS_COARSE_LOCATION"`
---   `"android.permission.ACCESS_FINE_LOCATION"`
---   `"android.permission.ACCESS_NETWORK_STATE"`
---   `"android.permission.ACCESS_WIFI_STATE"`
---   `"android.permission.CAMERA"`
---   `"android.permission.CHANGE_WIFI_STATE"`
---   `"android.permission.INTERNET"`
---   `"android.permission.READ_EXTERNAL_STORAGE"`
---   `"android.permission.RECORD_AUDIO"`
---   `"android.permission.VIBRATE"`
---   `"android.permission.WRITE_EXTERNAL_STORAGE"`
---   `"android.permission.WAKE_LOCK"`
---   `"com.android.vending.CHECK_LICENSE"`
---   `"com.yourdomain.yourapp.permission.C2D_MESSAGE"`
---
---@param permission string # the Android permission to check
---@return boolean res # true if the permission has been granted
function Application:checkPermission(permission) end

---
---Configures the field of view (fov) and far clipping plane for 3D projection.
---```lua
--- application:configureFrustum(fov,farplane)
---```
---Setting a fov of 0 selects the default orthographic projection (no perspective).
---
---The field of view specifies the angle of vision by which the largest side of the scene is seen. It is used to compute the distance of the eye relative to the screen along the Z axis:
---```lua
---  Z=(largest screen dimension/2)/tan(fov/2)
---```
---Z is the eye location. The far clipping plane specifies the maximum distance of an object. Objects more distant than the far clipping plane are not drawn.
---
---**Note:** the perspective is oriented so that the full screen is at Z=0 (so `sprite:setPosition(x, y, 0)` will place the sprite at exactly (x, y) pixels on the screen, irrespective of fov) and distant objects are placed at negative Z values.
---
---If the fov is set at non-zero then perspective projection is activated. If farplane is then not set it takes the default value *100\*(screen height)*. Normally the user should set this value. Note that there is no nearplane in perspective mode (objects are clipped only at the eye position).
---
---If fov is set at 0 then the eye is at +infinity and a near plane is set at *z=+farplane*. Objects closer than this are clipped. The farplane remains at z=-farplane. 
---
---@param fov number specifies the field of view angle in degrees. If fov>0 a perspective projection is used with the eye at position *z=+h/tan(fov/2)* where h is half the larger screen dimension (logical coordinates). In this case there is a farplane but no nearplane: clipping is done only at the eye position. If fov=0, an orthographic projection is used with both a farplane and a nearplane (see farplane)
---@param farplane? number the distance of the far clipping plane along Z axis. If fov>0 and this value is not set, the farplane is set at *distance 100*(screen height)* from the origin (z=0). If fov=0 (orthographic projection), a nearplane is also used at distance farplane from the origin. If fov=0 and no farplane is set then near and farplanes are set at 1 pixel from the origin
function Application:configureFrustum(fov, farplane) end

---
---Shows or hides Gideros info layer in the given color. 
---
---@param color? vector # the color to use when drawing info, or nil to disable
function Application:enableDrawInfo(color) end

---
---Terminates the application. Although this function is available to all platforms, it should be used on Android only. 
---
function Application:exit() end

---
---Returns the state of the desktop setting provided as string parameter. 
---
---@param setting string # the name of the desktop setting
---@return any df # the value(s) of the settieng
function Application:get(setting) end

---
---Returns API version
---
---@return string
function Application:getApiVersion() end

---
---Returns App ID
---
---@return string
function Application:getAppId() end

---
---Returns background color.
---
---@return string
function Application:getBackgroundColor() end

---
---
---
---@return string
function Application:getClipboard() end

---
---If the orientation is portrait, this function returns logical height. If the orientation is landscape, this function returns logical width.
---
---@return number # logical width or logical height depending on orientation
function Application:getContentHeight() end

---
---If the orientation is portrait, this function returns logical width. If the orientation is landscape, this function returns logical height.
---
---@return number # logical width or logical height depending on orientation
function Application:getContentWidth() end

---
---Returns the physical height of the device in pixels. For example, for iPhone 3GS this function returns 480 and for iPhone 4 (with retina display enabled) this function returns 960. 
---
---@return number # The physical height of the device in pixels 
function Application:getDeviceHeight() end

---
---Returns the physical width of the device in pixels. For example, for iPhone 3GS this function returns 320 and for iPhone 4 (with retina display enabled) this function returns 640.
---
---@return number # The physical width of the device in pixels
function Application:getDeviceWidth() end

---
---Returns information about device.
---
--->    **iOS:** returns 5 values: "iOS", iOS version, device type, user interface idiom and device model
--->
--->    **Android:** returns 4 values: "Android", Android version, manufacturer and model information
--->
--->    **Windows:** returns 1 value: "Windows"
--->
--->    **macOS:** returns 1 value: "Mac OS"
--->
--->    **Win32:** returns 1 value: "Win32"
--->
--->    **HTML5:** returns 2 values: "Web", Browser ID string
---@return any ... # Information about device, returned informations varies depending on platform
function Application:getDeviceInfo() end

---
---Returns the device name
---
---@return string name
function Application:getDeviceName() end

---
---Gets the device orientation (and not what is in project properties as done with getOrientation). Please check Accelerometer example project for usage.
---
---@return string # values can be: "portrait", "portraitUpsideDown", "landscapeLeft", "landscapeRight" 
function Application:getDeviceOrientation() end

---
---Some screens have non rectangular shapes, in which case it is useful to know the bounds of the safe area, that is area that is guaranteed to be visible and user accessible. This functions returns the minimum and maximum coordinates to use, either in physical coordinates or in logical coordinates.
---
---@param logical? boolean # Returns the margin in logical scale if set to true.
---@return number min_x, number min_y, number max_x, number max_y
function Application:getDeviceSafeArea(logical) end

---
---Returns the frame rate of the application.
---
---@return number fps
function Application:getFps() end

---@return number
function Application:getKeyboardModifiers() end

---@return string # user language
function Application:getLanguage() end


---@return string # the device locale
function Application:getLocale() end

---
---Returns the minimum and maximum logical space coordinates to cover full screen. 
---
---@return number min_x, number min_y, number max_x, number max_y
function Application:getLogicalBounds() end

---
---Returns the logical height of the application that is specified at the project properties.
---
---@return number # the logical height of the application
function Application:getLogicalHeight() end

---
---Returns the logical width of the application that is specified at the project properties.
---
---@return number # the logical width of the application
function Application:getLogicalWidth() end

---
---Returns the scaling of automatic screen scaling on the x-axis. 
---
---@return number # The scaling of automatic screen scaling on the x-axis. 
function Application:getLogicalScaleX() end

---
---Returns the scaling of automatic screen scaling on the y-axis. 
---
---@return number # The scaling of automatic screen scaling on the y-axis. 
function Application:getLogicalScaleY() end

---
---Returns the translation of automatic screen scaling on the x-axis. 
---
---@return number The translation of automatic screen scaling on the x-axis. 
function Application:getLogicalTranslateX() end

---
---Returns the translation of automatic screen scaling on the y-axis. 
---
---@return number The translation of automatic screen scaling on the y-axis. 
function Application:getLogicalTranslateY() end


---
---Returns the system path for a given resource. 
---
---@param path string # path to an application local resource
---@return string the native path of the given resource
function Application:getNativePath(path) end


---
---Returns the orientation of the application. 
---
---@return string # Values "portrait", "portraitUpsideDown", "landscapeLeft", "landscapeRight" 
function Application:getOrientation() end

---
---Returns the automatic scale mode of the application. 
---
---@return string # The automatic scale mode of the application
function Application:getScaleMode() end

---
---Returns the screen density in pixels per inch. If screen density information is not available, returns nil
---
---@return number|nil # If available returns the screen density in pixels per inch, otherwise returns nil.
function Application:getScreenDensity() end

---
---Returns the texture memory usage (in Kbytes).
---
---@return number # The texture memory usage (in Kbytes).
function Application:getTextureMemoryUsage() end

---
---Returns true if app is ran on Gideros player and, false if it is ran as stand alone app. 
---
---@return boolean
function Application:isPlayerMode() end

---
---Opens the given URL (Universal Resource Locator) in the appropriate application. URL can be one of the http:, https:, tel:, or mailto: schemes. 
---
---@source https://wiki.gideros.rocks/index.php/Application:openUrl
---@param url string # url to open
function Application:openUrl(url) end

---
---Requests one or multiple android permission(s) and displays the request permission screen. 
---Possible values are:
---<ul><li>"android.permission.ACCESS_COARSE_LOCATION"</li>
---<li>"android.permission.ACCESS_FINE_LOCATION"</li>
---<li>"android.permission.ACCESS_NETWORK_STATE"</li>
---<li>"android.permission.ACCESS_WIFI_STATE"</li>
---<li>"android.permission.CAMERA"</li>
---<li>"android.permission.CHANGE_WIFI_STATE"</li>
---<li>"android.permission.INTERNET"</li>
---<li>"android.permission.READ_EXTERNAL_STORAGE"</li>
---<li>"android.permission.RECORD_AUDIO"</li>
---<li>"android.permission.VIBRATE"</li>
---<li>"android.permission.WRITE_EXTERNAL_STORAGE"</li>
---<li>"android.permission.WAKE_LOCK"</li></ul>
---<ul><li>"com.android.vending.CHECK_LICENSE"</li></ul>
---<ul><li>"com.yourdomain.yourapp.permission.C2D_MESSAGE"</li></ul>
---
---@param permissions table
function Application:requestPermissions(permissions) end

---
---Sets the state of the desktop setting provided as string parameter. 
---
---Run `application:set("help")` for list of available settings.
---
---Run `application:set("cursor", "help")` for options for specific setting.
---
---@param setting string
---@param ... string|number # values to set 
function Application:set(setting, ...) end

---
---Set's the background color for the whole application
---
---@param color integer # e.g. 0xbedead
function Application:setBackgroundColor(color) end

---@param ok boolean
function Application:setFullScreen(ok) end

---@param wx number
---@param wy number
function Application:setLogicalDimensions(wx, wy) end

---@param orientation string
---|`Application.PORTRAIT`
---|`Application.PORTRAIT_UPSIDE_DOWN`
---|`Application.LANDSCAPE_LEFT`
---|`Application.LANDSCAPE_RIGHT`
function Application:setOrientation(orientation) end

---
---Sets the automatic scale mode of the application.
---
---@param scale_mode string
---|`Application.NO_SCALE`
---|`Application.CENTER`
---|`Application.PIXEL_PERFECT`
---|`Application.LETTERBOX`
---|`Application.CROP`
---|`Application.STRETCH`
---|`Application.FIT_WIDTH`
---|`Application.FIT_HEIGHT`
function Application:setScaleMode(scale_mode) end

