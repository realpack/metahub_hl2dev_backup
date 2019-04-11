local _R = debug.getregistry()

do
	local PRISM = {}

	_R.QuadPrism = PRISM
	_R.QuadPrism.__index = _R.QuadPrism
	
	function QuadPrism( mins, maxs )
		return setmetatable( {	minVec = mins, minX = mins.x, minY = mins.y, minZ = mins.z,
								maxVec = maxs, maxX = maxs.x, maxY = maxs.y, maxZ = maxs.z }, PRISM )
	end

	function PRISM:PointInside( point )
		return point:WithinAABox( self.minVec, self.maxVec )
	end
	
	function PRISM:GetMins()
		return self.minVec
	end
	
	function PRISM:GetMaxs()
		return self.maxVec
	end
end

do
	local SPHERE = {}

	_R.Sphere = SPHERE
	_R.Sphere.__index = _R.Sphere
	
	-- No ovoid support for now b/c too expensive
	function Sphere( center, radius )
		return setmetatable( {  centVec = center, 
					x = center.x, y = center.y, z = center.z, 
					r = radius }, SPHERE )
	end
	
	function SPHERE:PointInside( point )
		return ( point.x - self.x )^2 + ( point.y - self.y )^2 + ( point.z - self.z )^2 <= self.r^2 -- Check if ^2 or *itself is less expensive than square root
	end
	
	function SPHERE:GetCenter()
		return center
	end
	
	function SPHERE:GetRadius()
		return self.r
	end
end
