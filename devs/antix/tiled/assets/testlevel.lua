return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 100,
  height = 100,
  tilewidth = 64,
  tileheight = 64,
  nextlayerid = 5,
  nextobjectid = 9,
  properties = {},
  tilesets = {},
  layers = {
    {
      type = "objectgroup",
      id = 2,
      name = "objects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "platform",
          shape = "polygon",
          x = -144,
          y = 77,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 234, y = 3 },
            { x = 436, y = -98 },
            { x = 575, y = -95 },
            { x = 706, y = 16 },
            { x = 680, y = 126 },
            { x = 326, y = 171 },
            { x = 39, y = 106 }
          },
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "player_start",
          shape = "rectangle",
          x = -78,
          y = 21,
          width = 43,
          height = 54,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "level_exit",
          shape = "rectangle",
          x = 381,
          y = -83,
          width = 46,
          height = 62,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 116,
          y = -2,
          width = 30,
          height = 36,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 167,
          y = -25,
          width = 30,
          height = 36,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 215,
          y = -52,
          width = 30,
          height = 36,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
