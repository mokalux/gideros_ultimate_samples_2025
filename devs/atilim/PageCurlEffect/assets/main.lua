local flipview = FlipPageView.new()
flipview:addPages{"gfx/page1.png",
					"gfx/page2.png",
					"gfx/page3.png",
					"gfx/page4.png",
					"gfx/page5.png",
					"gfx/page6.png"}
stage:addChild(flipview)
flipview:show()

