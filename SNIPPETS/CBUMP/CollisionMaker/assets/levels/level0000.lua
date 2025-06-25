return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.15.771",
  orientation = "orthogonal",
  renderorder = "left-down",
  width = 10,
  height = 15,
  tilewidth = 32,
  tileheight = 32,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "basictiles",
      firstgid = 1,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "../images/basictiles.png",
      imagewidth = 512,
      imageheight = 96,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 48,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "walls",
      x = 0,
      y = 0,
      width = 10,
      height = 15,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        12, 38, 38, 38, 38, 38, 13, 38, 38, 14,
        23, 0, 0, 0, 0, 0, 27, 0, 0, 21,
        23, 0, 0, 0, 0, 0, 43, 0, 0, 21,
        23, 0, 0, 0, 0, 0, 0, 0, 0, 21,
        23, 0, 0, 0, 0, 0, 11, 0, 0, 21,
        28, 4, 0, 2, 3, 3, 41, 3, 3, 30,
        23, 0, 0, 0, 0, 0, 0, 0, 0, 21,
        23, 0, 0, 0, 11, 0, 0, 0, 0, 21,
        28, 3, 3, 3, 42, 0, 0, 0, 0, 21,
        23, 0, 0, 0, 0, 0, 0, 0, 0, 21,
        23, 0, 0, 0, 8, 4, 0, 2, 3, 30,
        23, 0, 0, 0, 27, 0, 0, 0, 0, 21,
        23, 0, 2, 3, 26, 0, 0, 0, 0, 21,
        23, 0, 0, 0, 27, 0, 0, 0, 0, 21,
        44, 6, 6, 6, 45, 6, 6, 6, 6, 46
      }
    }
  }
}
