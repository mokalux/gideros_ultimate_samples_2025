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
				{ 560, 300, 180 } ,
				{ 150, 1000, 0 } ,
				{ 300, 1000, 180 } ,
				{ 180, 2500, 0 } ,
				{ 400, 3600, 0 } ,
				{ 560, 3700, 0 } 
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
				{ 100, 400 } ,
				{ 240, 1500 } ,
				{ 230, 2300 } ,
				{ 600, 3300 } ,
				{ 580, 3900 } ,
				{ 300, 4700 } ,
				{ 420, 4700 } 
			}
		} ,

		{
			class = "cop_grenade",
			weapon = 2,
			image = { "images/cop_grenade_idle.png", "images/cop_grenade_fire.png" },
			sound = "throw",
			firerate = 120, 
			positions = {
				{ 600, 1000 } ,
				{ 140, 2900 } ,
				{ 100, 4200 } ,
				{ 620, 4400 } 
			}
		} ,

		{
			class = "cop_flame",
			weapon = 3,
			image = { "images/cop_flame_idle.png", "images/cop_flame_fire.png" },
			sound = "flame",
			firerate = 90, 
			positions = {
				{ 80, 1500 } ,
				{ 620, 1900 } ,
				{ 610, 2500 } ,
				{ 100, 3500 } ,
				{ 250, 4100 } ,
				{ 100, 4650 } 
			}
		}
	}
}