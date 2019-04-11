local data = {
	["item_suitcharger"] = {
		["filter"] = {
			[0] = { model = "models/props_combine/suit_charger001.mdl" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				transform = {
					world = {
						pos = Vector(12, 0, 0)
					}
				},
				brightness = 3,
				size = 45,
				color = Vector(255, 75, 0)
			}
		}
	},
	["item_healthcharger"] = {
		["filter"] = {
			[0] = { model = "models/props_combine/health_charger001.mdl" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				transform = {
					world = {
						pos = Vector(12, 0, 0)
					}
				},
				brightness = 3,
				size = 45,
				color = Vector(0, 120, 140)
			}
		}
	},
	["item_healthcharger"] = {
		["filter"] = {
			[0] = { model = "models/props_combine/combinethumper002.mdl" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				transform = {
					world = {
						pos = Vector(35, 0, 55)
					}
				},
				brightness = 4,
				size = 150,
				color = Vector(0, 120, 140)
			}
		}
	},
	["weapon_striderbuster"] = {
		["filter"] = {
			[0] = { model = "models/magnusson_device.mdl" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				brightness = 3,
				size = 35,
				color = Vector(0, 120, 140)
			}
		}
	},
	["item_battery"] = {
		["filter"] = {
			[0] = { model = "models/items/battery.mdl" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				transform = {
					world = {
						pos = Vector(-5, 0, 5)
					}
				},
				brightness = 3,
				size = 25,
				color = Vector(0, 120, 140)
			}
		}
	},
	["item_ammo_ar2_altfire"] = {
		["filter"] = {
			[0] = { model = "models/items/combine_rifle_ammo01.mdl" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				brightness = 2,
				size = 24,
				color = Vector(255, 255, 130)
			}
		}
	},
	["item_healthvial"] = {
		["filter"] = {
			[0] = { model = "models/healthvial.mdl" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				brightness = 2,
				size = 15,
				color = Vector(0, 255, 55)
			}
		}
	},
	["item_healthkit"] = {
		["filter"] = {
			[0] = { model = "models/items/healthkit.mdl" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				transform = {
					world = {
						pos = Vector(4, -3, 8)
					}
				},
				brightness = 2,
				size = 24,
				color = Vector(0, 255, 55)
			},
			[1] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(4, -3, 5)
					}
				},
				size = 64,
				opacity = 5,
				shimmer = false,
				color = Vector(0, 255, 55)
			}
		}
	},
	["item_ammo_ar2"] = {
		["filter"] = {
			[0] = { model = "models/items/combine_rifle_cartridge01.mdl" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				brightness = 3,
				size = 18,
				color = Vector(0, 120, 140)
			}
		}
	},
	["crossbow_bolt"] = {
		["filter"] = {
			[0] = { class = "crossbow_bolt" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				brightness = 3,
				size = 25,
				color = Vector(255, 75, 0)
			},
			[1] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(-7, 0, 0)
					}
				},
				trail = true,
				size = 64,
				shimmer = false,
				color = Vector(255, 75, 0)
			}
		}
	},
	["npc_grenade_frag"] = {
		["filter"] = {
			[0] = { class = "npc_grenade_frag" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				brightness = 2,
				size = 50,
				color = Vector(255, 0, 0),
				lastTime = 0,
				decay = 800,
				Think = function(self)
					if SysTime() > self.lastTime then
						self.lastTime = SysTime() + 0.1
						self:SetEnabled( not self:GetEnabled() )
					end
				end
			},
			[1] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(0, 0, 4)
					}
				},
				size = 0,
				sizeLerp = 0,
				shimmer = true,
				color = Vector(255, 0, 0),
				flick = false,
				lastTime = 0,
				Think = function(self)
					self.size = Lerp(FrameTime() * 8, self.size, self.sizeLerp)
					
					if SysTime() > self.lastTime then
						self.lastTime = SysTime() + 0.1
						
						if self.flick then
							self.sizeLerp = 0
							self.flick = false
						else
							self.sizeLerp = 64
							self.flick = true
						end
					end
				end
			}
		}
	},
	["prop_combine_ball"] = {
		["filter"] = {
			[0] = { class = "prop_combine_ball" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				brightness = 3,
				size = 300,
				color = Vector(128, 220, 200)
			}
		}
	},
	["rpg_missile"] = {
		["filter"] = {
			[0] = { class = "rpg_missile" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				transform = {
					world = {
						pos = Vector(-25, 0, 0)
					}
				},
				brightness = 3,
				size = 400,
				color = Vector(255, 45, 0)
			},
			[1] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(-25, 0, 0)
					}
				},
				size = 92,
				shimmer = true,
				color = Vector(255, 85, 0)
			}
		}
	},
	["npc_manhack"] = {
		["filter"] = {
			[0] = { class = "npc_manhack" }
		},
		["parts"] = {
			[0] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(5, 0, 0)
					}
				},
				size = 64,
				shimmer = false,
				color = Vector(255, 0, 0)
			},
			[1] = {
				name = "Light",
				transform = {
					world = {
						pos = Vector(0, 0, 25)
					}
				},
				size = 300,
				color = Vector(255, 0, 0)
			}
		}
	},
	["npc_rollermine"] = {
		["filter"] = {
			[0] = { class = "npc_rollermine" }
		},
		["parts"] = {
			[0] = {
				name = "Glow",
				size = 264,
				shimmer = false,
				pixVisEnabled = false,
				opacity = 25,
				color = Vector(0, 120, 140)
			},
			[1] = {
				name = "Light",
				brightness = 1,
				size = 300,
				color = Vector(0, 120, 140)
			}
		}
	},
	["weapon_physcannon"] = {
		["filter"] = {
			[0] = { class = "weapon_physcannon" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				command = "r_extended_light_weapons",
				brightness = 3,
				size = 50,
				color = Vector(255, 75, 0),
				bone = "core"
			}
		}
	},
	["weapon_physgun"] = {
		["filter"] = {
			[0] = { class = "weapon_physgun" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				command = "r_extended_light_weapons",
				brightness = 3,
				size = 50,
				color = Vector(255, 75, 0),
				bone = "core",
				Init = function(self)
					local owner = self:GetParent():GetParent()
					local color = Vector(0, 0 ,0)
					
					if IsValid( owner ) then
						color = owner:GetWeaponColor()
					else
						color = LocalPlayer():GetWeaponColor()
					end
					
					self.color = Vector( color*255, color*255, color*255 ) 
				end
			}
		}
	},
	["weapon_ar2"] = {
		["filter"] = {
			[0] = { model = "models/weapons/w_irifle.mdl" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				command = "r_extended_light_weapons",
				transform = {
					world = {
						pos = Vector(-13, -7, 0)
					},
					view = {
						pos = Vector(-29, -5, -9)
					}
				},
				brightness = 3,
				size = 25,
				color = Vector(255, 0, 0),
				bone = "muzzle"
			}
		}
	},
	["weapon_rpg"] = {
		["filter"] = {
			[0] = { class = "weapon_rpg" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				command = "r_extended_light_weapons",
				transform = {
					world = {
						pos = Vector(0, 0, 0)
					},
					view = {
						pos = Vector(0, 0, 0)
					}
				},
				brightness = 3,
				size = 20,
				color = Vector(255, 0, 0),
				bone = "muzzle"
			}
		}
	},
	["gmod_tool"] = {
		["filter"] = {
			[0] = { class = "gmod_tool" }
		},
		["parts"] = {
			[0] = {
				name = "Light",
				command = "r_extended_light_weapons",
				transform = {
					world = {
						pos = Vector(-18, 0, 5)
					},
					view = {
						pos = Vector(-15, 0, -5)
					}
				},
				brightness = 3,
				size = 25,
				color = Vector(255, 255, 255),
				bone = "muzzle"
			}
		}
	}
}

ExtendedRender.Data:Include( "Packages", data )