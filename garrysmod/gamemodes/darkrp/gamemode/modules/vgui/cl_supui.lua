rp.ui = rp.ui or {}

local color_bg      = Color(0,0,0)
local color_outline = Color(245,245,245)

local math_clamp  = math.Clamp
local Color       = Color

local texOutlinedCorner = surface.GetTextureID( "gui/corner16" )
function draw.RoundedBoxOutlined( bordersize, x, y, w, h, color, bordercol )

  x = math.Round( x )
  y = math.Round( y )
  w = math.Round( w )
  h = math.Round( h )

  draw.RoundedBox( bordersize, x, y, w, h, color )
  
  surface.SetDrawColor( bordercol )
  
  surface.SetTexture( texOutlinedCorner )
  surface.DrawTexturedRectRotated( x + bordersize/2 , y + bordersize/2, bordersize, bordersize, 0 ) 
  surface.DrawTexturedRectRotated( x + w - bordersize/2 , y + bordersize/2, bordersize, bordersize, 270 ) 
  surface.DrawTexturedRectRotated( x + w - bordersize/2 , y + h - bordersize/2, bordersize, bordersize, 180 ) 
  surface.DrawTexturedRectRotated( x + bordersize/2 , y + h -bordersize/2, bordersize, bordersize, 90 ) 
  
  surface.DrawLine( x+bordersize, y, x+w-bordersize, y )
  surface.DrawLine( x+bordersize, y+h-1, x+w-bordersize, y+h-1 )
  
  surface.DrawLine( x, y+bordersize, x, y+h-bordersize )
  surface.DrawLine( x+w-1, y+bordersize, x+w-1, y+h-bordersize )

end

function rp.ui.DrawBar(x, y, w, h, perc)
  local color = Color(255 - (perc * 255), perc * 255, 0, 255)

  draw.OutlinedBox(x, y, math_clamp((w * perc), 3, w), h, color, color_outline)
end

function rp.ui.DrawProgress(x, y, w, h, perc)
  local color = Color(255 - (perc * 255), perc * 255, 0, 255)

  draw.RoundedBoxOutlined( 2, x, y, w, h, Color(0, 0, 0, 90), Color(70,70,70,150) )
  draw.RoundedBoxOutlined( 2, x + 5, y + 5, math_clamp((w * perc) - 10, 3, w), h - 10, color, Color(50,50,50,150) )
end
