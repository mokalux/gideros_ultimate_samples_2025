-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!! WARNINGS ONLY USE WITH application SCALE = LetterBox !!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- otherwise Gideros Player crashes!

-- !!!!!! WARNINGS ONLY USE WITH application SCALE = LetterBox !!!!!!


examples = Layout.newResources{
	path = "|R|examples",
	namemod = function(name, path, base, ext, i) return base end
}
examples["splashscreen"]()
