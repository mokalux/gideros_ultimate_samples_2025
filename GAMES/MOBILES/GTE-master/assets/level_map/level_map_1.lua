return {
	map = "images/level.png",
	height = 5000,
	speed = 3,
	projectiles = {
		{
			class = "pistol",
			image = "images/bullet.png",
			projectilespeed = 12,
			distance = 180
		},

		{
			class = "grenade",
			image = "images/grenade.png",
			projectilespeed = 5,
			distance = 60,
			exploderadius = 100
		}, 

		{
			class = "flame",
			image = "images/fire.png",
			projectilespeed = 3,
			distance = 120
		}
	},
	
	obstacles = {
		{
			class = "car",
			image = "images/car.png",
			positions = {
				{ 160, 900, 0 } ,
				{ 560, 2300, 0 } ,
				{ 560, 2700, 180 } ,
				{ 240, 3600, 0 } 
			}
		},
		{
			class = "finish",
			image = "images/police_line.png",
			positions = {
				{ 360, 5000, 0 } 
			}
		}
	},
	
	objects = {
		{
			class = "cop_pistol",
			weapon = 1,
			image = { "images/cop_pistol_idle.png", "images/cop_pistol_fire.png" },
			sound = "gunshot",
			firerate = 60,
			positions = {
				{ 100, 2200 } ,
				{ 120, 4700 } 
			}
			
		} ,

		{
			class = "cop_grenade",
			weapon = 2,
			image = { "images/cop_grenade_idle.png", "images/cop_grenade_fire.png" },
			sound = "throw",
			firerate = 120, 
			positions = {
				{ 600, 500 } ,
				{ 560, 1600 } ,
				{ 620, 3500 } 
			}
		} ,

		{
			class = "cop_flame",
			weapon = 3,
			image = { "images/cop_flame_idle.png", "images/cop_flame_fire.png" },
			sound = "flame",
			firerate = 90, 
			positions = {
				{ 120, 2800 } ,
				{ 100, 4300 } 
			}
		}
	}
}