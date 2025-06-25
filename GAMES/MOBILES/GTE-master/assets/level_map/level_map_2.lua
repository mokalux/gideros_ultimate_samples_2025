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
				{ 560, 500, 180 } ,
				{ 150, 1700, 0 } ,
				{ 180, 2700, 180 } ,
				{ 160, 3900, 0 } ,
				{ 200, 1700, 0 } 
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
				{ 100, 600 } ,
				{ 550, 1000 } ,
				{ 120, 2200 } ,
				{ 90, 2400 } ,
				{ 600, 3200 } ,
				{ 560, 4600 } ,
				{ 360, 4800 } ,
				{ 80, 4800 } 
			}
		} ,

		{
			class = "cop_grenade",
			weapon = 2,
			image = { "images/cop_grenade_idle.png", "images/cop_grenade_fire.png" },
			sound = "throw",
			firerate = 120, 
			positions = {
				{ 360, 1200 } ,
				{ 100, 4200 } 
			}
		} ,

		{
			class = "cop_flame",
			weapon = 3,
			image = { "images/cop_flame_idle.png", "images/cop_flame_fire.png" },
			sound = "flame",
			firerate = 90, 
			positions = {
				{ 620, 1800 } ,
				{ 120, 3000 } 
			}
		}
	}
}