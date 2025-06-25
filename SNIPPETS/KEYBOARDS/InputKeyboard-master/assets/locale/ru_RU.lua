--This is only an example and dont necessarily fully represent a russian keyboard
function keyLang(self)
	return
		{	
			{--Lower Case
				{ {"й",{"1","Й"}}, {"ц",{"2","Ц"}}, {"у",{"3","У"}}, {"к",{"4","К"}}, {"е",{"5","Е"}}, {"н",{"6","Н"}}, {"г",{"7","Г"}}, {"ш",{"8","Ш"}}, {"щ",{"9","Щ"}}, {"з",{"З","0"}}, {"х",{"Х"}}, {"ъ",{"Ъ"}} },
				{ self.EXTRASPACE, {"ф",{"Ф"}}, {"ы",{"Ы"}}, {"в",{"В"}}, {"а",{"А"}}, {"п",{"П"}}, {"р",{"Р"}}, {"о",{"О"}}, {"л",{"Л"}}, {"д",{"Д"}}, {"ж",{"Ж"}}, {"э",{"Э"}}  },
				{ {"я",{"Я"}}, {"ч",{"Ч"}}, {"с",{"С"}}, {"м",{"М"}}, {"и",{"И"}}, {"т",{"Т"}}, {"ь",{"Ь"}}, {"б",{"Б"}}, {"ю",{"Ю"}}, {"ё",{"Ё"}} , self.DEL},
				{ self.UPPER, self.NUMBERS, self.EXTRASPACE,self.EXTRASPACE,self.SPACE, ".", self.HIDE }
			} ,	
			{--Upper Case
				{ {"Й",{"1"}}, {"Ц",{"2"}}, {"У",{"3"}}, {"К",{"4"}}, {"Е",{"5"}}, {"Н",{"6"}}, {"Г",{"7"}}, {"Ш",{"8"}}, {"Щ",{"9"}}, {"З",{"0"}}, "Х", "Ъ"},
				{ self.EXTRASPACE, "Ф", "Ы", "В", "А", "П", "Р", "О", "Л", "Д", "Ж", "Э" },
				{ "Я", "Ч", "С", "М", "И", "Т", "Ь", "Б", "Ю", "Ё" , self.DEL},
				{ self.LOWER, self.NUMBERS,  self.EXTRASPACE,self.EXTRASPACE,self.SPACE,  ".", self.HIDE }	
			} ,	
			{--Numerical and other
				{ self.EXTRASPACE,"1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
				{ self.EXTRASPACE,"@", "#", "%", "&", "*", "/", "-", "+", "(", ")" },
				{ self.EXTRASPACE, self.EXTRASPACE, self.EXTRASPACE,self.EXTRASPACE, "?", "!", "\"", "'", ":", ";", "," , self.DEL},
				{  self.TEXT, self.EXTRASPACE,self.EXTRASPACE, self.SPACE, ".", self.HIDE   }	
			}
		}
end