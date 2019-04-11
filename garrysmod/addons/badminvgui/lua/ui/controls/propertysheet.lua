local PANEL = {}

function PANEL:Paint(w, h)
	derma.SkinHook('Paint', 'PropertySheet', self, w, h)
end

vgui.Register('ui_propertysheet', PANEL, 'DPropertySheet')
