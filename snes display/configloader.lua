function loadConfigFile(path)
	local func = loadfile(path) -- Loads the file into a function
	if func == nil then
		error("could not load config file", 2)
	else
		local tEnv = {}
		setmetatable(tEnv, {__index = _G})
		setfenv(func, tEnv)()

		for i,v in pairs(tEnv) do
			--print(i)
			print(i .. " = " .. tostring(v))
		end 

		return tEnv
	end 
end 