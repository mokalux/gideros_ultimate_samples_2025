--[[
   Copyright 2014 MySQUAR

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]--

function g_convertToBurmeseNumber(s)
-- ၁၂၃၄၅၆၇၈၉၀
--[[
	local result = string.gsub(s,"1","၁")
	result = string.gsub(result,"2","၂")
	result = string.gsub(result,"3","၃")
	result = string.gsub(result,"4","၄")
	result = string.gsub(result,"5","၅")
	result = string.gsub(result,"6","၆")
	result = string.gsub(result,"7","၇")
	result = string.gsub(result,"8","၈")
	result = string.gsub(result,"9","၉")
	result = string.gsub(result,"0","၀")
	return result
]]--
	return s
end
