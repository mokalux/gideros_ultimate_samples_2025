function append(t1,t2)
	for k,v in pairs(t2) do 
		if (t1[k] == nil) then
			t1[k] = v
		end
	end
end