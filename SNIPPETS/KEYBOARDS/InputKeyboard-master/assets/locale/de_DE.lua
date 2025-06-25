--This is only an example and dont necessarily fully represent a german keyboard
function keyLang(self)
	return
		{	
			{--Lower Case
				{ {"q", {"1","Q"}}, {"w", {"2","W"}}, {"e", {"3","E","è","é","ê","ë"}}, {"r", {"4","R"}}, {"t", {"5","T"}}, {"z", {"6","Z"}}, {"u", {"7","U","ù","ú","û"}}, {"i",{"8","I","í","î","ï"}}, {"o",{"9","O","ö","ò","ó","ô","õ","œ","ø"}}, {"p", {"0","P"}}, {"ü", {"Ü"}} },
				{ {"a",{"A","à","á","â","ã","æ"}}, {"s", {"S","ß","§"}}, {"d", {"D"}}, {"f", {"F"}}, {"g", {"G"}}, {"h", {"H"}}, {"j", {"J"}}, {"k", {"K"}}, {"l", {"L"}}, {"ö", {"Ö"}}, {"ä", {"Ä"}} },
				{ self.EXTRASPACE, self.UPPER, {"y", {"Y","ý","ÿ"}}, {"x", {"X"}}, {"c", {"C","ç"}}, {"v", {"V"}}, {"b", {"B"}}, {"n", {"N","ñ"}}, {"m", {"M"}}, self.DEL },
				{ self.NUMBERS, self.EXTRASPACE,self.EXTRASPACE,self.SPACE, ".", self.HIDE }
			} ,	
			{--Upper Case
				{ {"Q",{"1"}}, {"W",{"2"}}, {"E",{"3","È","É","Ê","Ë"}}, {"R",{"4"}}, {"T",{"5"}}, {"Z",{"6"}}, {"U",{"7","Ù","Ú","Û"}}, {"I",{"8","Í","Î","Ï"}}, {"O",{"9","Ò","Ó","Ô","Õ","Œ","Ø"}}, {"P",{"0"}}, "Ü"},
				{ {"A",{"À","Á","Â","Ã","Æ"}}, {"S",{"ß","§"}}, "D", "F", "G", "H", "J", "K", "L", "Ö", "Ä" },
				{ self.EXTRASPACE, self.LOWER, {"Y",{"6","Ý","Ÿ"}}, "X", {"C",{"Ç"}}, "V", "B", {"N",{"Ñ"}}, "M", self.DEL },
				{ self.NUMBERS,  self.EXTRASPACE,self.EXTRASPACE,self.SPACE,  ".", self.HIDE }	
			} ,	
			{--Numerical and other
				{ self.EXTRASPACE,"1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
				{ self.EXTRASPACE,"@", "#", "%", "&", "*", "/", "-", "+", "(", ")" },
				{ self.EXTRASPACE, self.EXTRASPACE, self.EXTRASPACE,self.EXTRASPACE, "?", "!", "\"", "'", ":", ";", ",", self.DEL },
				{ self.TEXT, self.EXTRASPACE,self.EXTRASPACE, self.SPACE, ".", self.HIDE   }	
			}
		}
end