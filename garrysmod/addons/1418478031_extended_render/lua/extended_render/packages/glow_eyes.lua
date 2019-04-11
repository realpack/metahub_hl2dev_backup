local data = {
	["metropolice_blue"] = {
		["filter"] = {

		},
        ["filter_func"] = function( ent )
            if not ent:IsPlayer() then return false end
            local job = rp.teams[ent:Team()]
            return job and job.mask_type and job.mask_type == 'metropolice_blue' and ent:GetNetVar('CPMask')
        end,
		["parts"] = {
			[0] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(1.5, 2, 0)
					}
				},
				trail = false,
				size = 8,
				color = Vector(32, 165, 255),
				bone = "eyes"
			},
			[1] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(1.5, -2, 0)
					}
				},
				trail = false,
				size = 8,
				color = Vector(32, 165, 255),
				bone = "eyes"
			}
		}
	},
	["metropolice_red"] = {
		["filter"] = {

		},
        ["filter_func"] = function( ent )
            if not ent:IsPlayer() then return false end
            local job = rp.teams[ent:Team()]
            return job and job.mask_type and job.mask_type == 'metropolice_red' and ent:GetNetVar('CPMask')
        end,
		["parts"] = {
			[0] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(1.5, 2, 0)
					}
				},
				trail = false,
				size = 8,
				color = Vector(255, 0, 0),
				bone = "eyes"
			},
			[1] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(1.5, -2, 0)
					}
				},
				trail = false,
				size = 8,
				color = Vector(255, 0, 0),
				bone = "eyes"
			}
		}
	},
	["metropolice_yellow"] = {
		["filter"] = {

		},
        ["filter_func"] = function( ent )
            if not ent:IsPlayer() then return false end
            local job = rp.teams[ent:Team()]
            return job and job.mask_type and job.mask_type == 'metropolice_yellow' and ent:GetNetVar('CPMask')
        end,
		["parts"] = {
			[0] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(1.5, 2, -0.3)
					}
				},
				trail = false,
				size = 8,
				color = Vector(255, 240, 0),
				bone = "eyes"
			},
			[1] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(1.5, -2, -0.3)
					}
				},
				trail = false,
				size = 8,
				color = Vector(255, 240, 0),
				bone = "eyes"
			}
		}
	},
	["metropolice_white"] = {
		["filter"] = { },
        ["filter_func"] = function( ent )
            if not ent:IsPlayer() then return false end
            local job = rp.teams[ent:Team()]
            return job and job.mask_type and job.mask_type == 'metropolice_white' and ent:GetNetVar('CPMask')
        end,
		["parts"] = {
			[0] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(1.5, 2, -0.3)
					}
				},
				trail = false,
				size = 8,
				color = Vector(255, 255, 255),
				bone = "eyes"
			},
			[1] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(1.5, -2, -0.3)
					}
				},
				trail = false,
				size = 8,
				color = Vector(255, 255, 255),
				bone = "eyes"
			}
		}
	},
	["combine_soldier_player"] = {
		["filter"] = { },
        ["filter_func"] = function( ent )
            if not ent:IsPlayer() then return false end
            local job = rp.teams[ent:Team()]
            return job and job.mask_type and job.mask_type == 'combine_soldier_player' and ent:GetNetVar('CPMask')
        end,
		["parts"] = {
			[0] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(0, 2, 0)
					}
				},
				trail = false,
				size = 8,
				color = Vector(255, 0, 0),
				bone = "eyes",
				Init = function(self)
					local color = self:GetParent():GetPlayerColor()
					self.color = Vector( color*255, color*255, color*255 )
				end
			},
			[1] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(0, -2, 0)
					}
				},
				trail = false,
				size = 8,
				color = Vector(255, 0, 0),
				bone = "eyes",
				Init = function(self)
					local color = self:GetParent():GetPlayerColor()
					self.color = Vector( color*255, color*255, color*255 )
				end
			},
			[2] = {
				name = "Light",
				brightness = 3,
				size = 20,
				color = Vector(255, 0, 0),
				bone = "eyes",
				Init = function(self)
					local color = self:GetParent():GetPlayerColor()
					self.color = Vector( color*255, color*255, color*255 )
				end
			}
		}
	},
	["combine_soldier_red"] = {
		["filter"] = { },
        ["filter_func"] = function( ent )
            if not ent:IsPlayer() then return false end
            local job = rp.teams[ent:Team()]
            return job and job.mask_type and job.mask_type == 'combine_soldier_red' and ent:GetNetVar('CPMask')
        end,
		["parts"] = {
			[0] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(0, 2, 0)
					}
				},
				trail = false,
				size = 8,
				color = Vector(255, 0, 0),
				bone = "eyes"
			},
			[1] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(0, -2, 0)
					}
				},
				trail = false,
				size = 8,
				color = Vector(255, 0, 0),
				bone = "eyes"
			}
		}
	},
	["combine_soldier_yellow"] = {
		["filter"] = { },
        ["filter_func"] = function( ent )
            if not ent:IsPlayer() then return false end
            local job = rp.teams[ent:Team()]
            return job and job.mask_type and job.mask_type == 'combine_soldier_yellow' and ent:GetNetVar('CPMask')
        end,
		["parts"] = {
			[0] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(0, 2, 0)
					}
				},
				trail = false,
				size = 8,
				color = Vector(255, 240, 0),
				bone = "eyes"
			},
			[1] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(0, -2, 0)
					}
				},
				trail = false,
				size = 8,
				color = Vector(255, 240, 0),
				bone = "eyes"
			}
		}
	},
	["combine_soldier_blue"] = {
		["filter"] = { },
        ["filter_func"] = function( ent )
            if not ent:IsPlayer() then return false end
            local job = rp.teams[ent:Team()]
            return job and job.mask_type and job.mask_type == 'combine_soldier_blue' and ent:GetNetVar('CPMask')
        end,
		["parts"] = {
			[0] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(-0.5, 1.9, -0.2)
					}
				},
				size = 12,
				shimmer = true,
				color = Vector(0, 120, 140),
				bone = "eyes"
			},
			[1] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(-0.5, -1.9, -0.2)
					}
				},
				size = 12,
				shimmer = true,
				color = Vector(0, 120, 140),
				bone = "eyes"
			}
		}
	},
	["combine_elite_red"] = {
		["filter"] = { },
        ["filter_func"] = function( ent )
            if not ent:IsPlayer() then return false end
            local job = rp.teams[ent:Team()]
            return job and job.mask_type and job.mask_type == 'combine_elite_red' and ent:GetNetVar('CPMask')
        end,
		["parts"] = {
			[0] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(-1.5, 0, 0.3)
					}
				},
				trail = false,
				size = 16,
				opacity = 50,
				shimmer = true,
				color = Vector(255, 0, 0),
				bone = "eyes"
			},
			[1] = {
				name = "Light",
				brightness = 3,
				size = 20,
				color = Vector(255, 0, 0),
				bone = "eyes"
			}
		}
	},
	["combine_elite_armored"] = {
		["filter"] = { },
        ["filter_func"] = function( ent )
            if not ent:IsPlayer() then return false end
            local job = rp.teams[ent:Team()]
            return job and job.mask_type and job.mask_type == 'combine_elite_armored' and ent:GetNetVar('CPMask')
        end,
		["parts"] = {
			[0] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(0.5, 0, 0.3)
					}
				},
				trail = false,
				size = 16,
				shimmer = true,
				opacity = 50,
				color = Vector(255, 0, 0),
				bone = "eyes"
			},
			[1] = {
				name = "Light",
				brightness = 3,
				size = 20,
				color = Vector(255, 0, 0),
				bone = "eyes"
			}
		}
	},
	["combine_elite_yellow"] = {
		["filter"] = { },
        ["filter_func"] = function( ent )
            if not ent:IsPlayer() then return false end
            local job = rp.teams[ent:Team()]
            return job and job.mask_type and job.mask_type == 'combine_elite_yellow' and ent:GetNetVar('CPMask')
        end,
		["parts"] = {
			[0] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(-1.5, 0, 0.3)
					}
				},
				trail = false,
				size = 16,
				opacity = 50,
				shimmer = true,
				color = Vector(255, 240, 0),
				bone = "eyes"
			},
			[1] = {
				name = "Light",
				brightness = 3,
				size = 20,
				color = Vector(255, 240, 0),
				bone = "eyes"
			}
		}
	},
	["combine_elite_blue"] = {
		["filter"] = { },
        ["filter_func"] = function( ent )
            if not ent:IsPlayer() then return false end
            local job = rp.teams[ent:Team()]
            return job and job.mask_type and job.mask_type == 'combine_elite_blue' and ent:GetNetVar('CPMask')
        end,
		["parts"] = {
			[0] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(-1.5, 0, 0.3)
					}
				},
				trail = false,
				size = 16,
				opacity = 50,
				shimmer = true,
				color = Vector(0, 120, 140),
				bone = "eyes"
			},
			[1] = {
				name = "Light",
				brightness = 3,
				size = 20,
				color = Vector(0, 120, 140),
				bone = "eyes"
			}
		}
	},
	["combine_elite_player"] = {
		["filter"] = { },
        ["filter_func"] = function( ent )
            if not ent:IsPlayer() then return false end
            local job = rp.teams[ent:Team()]
            return job and job.mask_type and job.mask_type == 'combine_elite_player' and ent:GetNetVar('CPMask')
        end,
		["parts"] = {
			[0] = {
				name = "Glow",
				transform = {
					world = {
						pos = Vector(-1.5, 0, 0.3)
					}
				},
				trail = false,
				size = 16,
				opacity = 50,
				shimmer = true,
				color = Vector(255, 0, 0),
				bone = "eyes",
				Init = function(self)
					local color = self:GetParent():GetPlayerColor()
					self.color = Vector( color*255, color*255, color*255 )
				end
			},
			[1] = {
				name = "Light",
				brightness = 3,
				size = 20,
				color = Vector(255, 0, 0),
				bone = "eyes",
				Init = function(self)
					local color = self:GetParent():GetPlayerColor()
					self.color = Vector( color*255, color*255, color*255 )
				end
			}
		}
	}
}

ExtendedRender.Data:Include( "Packages", data )
