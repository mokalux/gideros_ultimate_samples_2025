return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 10,
  height = 10,
  tilewidth = 24,
  tileheight = 24,
  properties = {},
  tilesets = 
  {
    {
      name = "sewer_tileset",
      firstgid = 1,
      tilewidth = 24,
      tileheight = 24,
      spacing = 0,
      margin = 0,
      image = "sewer_tileset.png",
      imagewidth = 192,
      imageheight = 217,
      transparentcolor = "#ffffff",
      tileoffset = {x = 0, y = 0},
      properties = {},
      tiles = {}
    }
	{
      name = "monster_tileset",
      firstgid = 73,
      tilewidth = 25,
      tileheight = 25,
      spacing = 1,
      margin = 1,
      image = "monster_tileset.png",
      imagewidth = 250,
      imageheight = 250,
      transparentcolor = "#ffffff",
      tileoffset = {x = 0, y = 0},
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "test1",
      x = 0,
      y = 0,
      width = 10,
      height = 10,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
        10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
        10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
        10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
        10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
        10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
        10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
        10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
        10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
        10, 10, 10, 10, 10, 10, 10, 10, 10, 10
      }
    },
    {
      type = "tilelayer",
      name = "test2",
      x = 0,
      y = 0,
      width = 10,
      height = 10,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 39, 39, 39, 39, 39, 39, 0, 0,
        0, 0, 39, 0, 0, 0, 0, 39, 0, 0,
        0, 0, 39, 0, 0, 0, 0, 39, 0, 0,
        0, 0, 39, 0, 0, 0, 0, 39, 0, 0,
        0, 0, 39, 0, 0, 0, 0, 39, 0, 0,
        0, 0, 39, 0, 0, 0, 0, 39, 0, 0,
        0, 0, 39, 39, 39, 39, 39, 39, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "test3",
      x = 0,
      y = 0,
      width = 10,
      height = 10,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 40, 40, 0, 0, 0, 0,
        0, 0, 0, 0, 40, 40, 0, 0, 0, 0,
        0, 0, 0, 0, 40, 40, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "testobj",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "Mr. John",
          type = "Enemy",
          shape = "ellipse",
          x = 18,
          y = 18,
          width = 36,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {
            ["testObjectProperty"] = "sleeping"
          }
        },
        {
          name = "Gold Pieces",
          type = "Bonus",
          shape = "ellipse",
          x = 120,
          y = 18,
          width = 36,
          height = 30,
          rotation = 0,
          visible = true,
          properties = {
            ["testObjectProperty"] = "10000K"
          }
        }
      }
    }
  }
}
