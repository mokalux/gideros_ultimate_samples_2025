default_language = "en"
current_language = application:getLanguage()
--current_language = "el"

-- Traduction
local en = {
				touch_speed = "Tap to play",
				best = "Best ",
				new_distance = "New Best Distance",
				quit = "Quit application",
				sure = "Are you sure?",
				cancel = "Cancel",
				yes = "Yes",
				meters = "m"
				}
				
local es = {
				touch_speed = "Toca para jugar",
				best = "Mejor ",
				new_distance = "Nueva Mejor Distancia",
				quit = "Salir",
				sure = "¿Estás seguro?",
				cancel = "Cancelar",
				yes = "Si",
				meters = "m"
				}

local de = {
				touch_speed = "Tippen",
				best = "Besten ",
				new_distance = "Neue besten Abstand",
				quit = "Verlassen",
				sure = "Sicher?",
				cancel = "Stornieren",
				yes = "Ja",
				meters = "m"
				}

local fr = {
				touch_speed = "Touchez",
				best = "Meilleure ",
				new_distance = "Nouveau Meilleure Distance",
				quit = "QUITTER",
				sure = "Sûr",
				cancel = "ANNULER",
				yes = "OUI",
				meters = "m"
				}

local it = {
				touch_speed = "Toccare",
				best = "Migliore ",
				new_distance = "Nuovo Migliore Distanza",
				quit = "SMETTERE",
				sure = "SICURO",
				cancel = "CANCELLARE",
				yes = "SI",
				meters = "m"
				}
				
local pt = {	
				touch_speed = "Toque para acelerar",
				best = "Melhor ",
				new_distance = "Novo Melhor Distância",
				quit = "DESISTIR",
				sure = "CERTO",
				cancel = "CANCELAR",
				yes = "SIM",
				meters = "m"
				}
local ko = {
				SPEEDY = "빠른",
				ROAD = "도로",
				touch_speed = "시작을 누릅니다",
				best = "베스트 ",
				new_distance = "새로운 최고의 거리",
				quit = "게임을 종료",
				yes = "예",
				sure = "확실 해요",
				cancel = "취소",
				meters = "미터"
				}
				
local ru = {
				SPEEDY = "быстрый",
				ROAD = "Дорога",
				touch_speed = "Нажмите, чтобы начать",
				best = "Лучший ",
				new_distance = "Новый Лучший",
				quit = "Выйти из игры",
				yes = "да",
				sure = "Вы уверены",
				cancel = "отменить",
				meters = "м"
				}
local ja = {
				SPEEDY = "速度",
				ROAD = "ロード",
				touch_speed = "開始をタップ",
				best = "最高 ",
				new_distance = "新しいベスト",
				quit = "ゲームを終了",
				yes = "はい",
				sure = "本気",
				cancel = "キャンセル",
				meters = "メートル"
				}

local zh = {
				SPEEDY = "快速",
				ROAD  = "路",
				touch_speed = "点击开始",
				best = "最佳 ",
				new_distance = "新的最佳距离",
				quit = "离开游戏",
				yes = "是的",
				sure = "你确定",
				cancel = "取消",
				meters = "米"
				}

local el = {
				SPEEDY = "ταχύς",
				ROAD  = "οδική",
				touch_speed = "Πιέστε για επιτάχυνση",
				best = "Καλύτερη απόσταση ",
				new_distance = "Νεα καλύτερη απόσταση",
				quit = "Έξοδος απο εφαρμογή",
				sure = "Είστε σίγουρος;",
				cancel = "Ακύρωση",
				yes = "Ναι",
				meters = "μέτρα"
				}
				
local strings = {
	en=en,
	es=es,
	de=de,
	fr=fr,
	it=it,
	pt=pt,
	ko=ko,
	ru=ru,
	ja=ja,
	zh=zh,
	el=el
	}

function getString(key)
	
	local language = strings[current_language]
	if not language then
		language = strings[default_language]
	end
		
	local value = language[key]
	if value then
		return value
	else
		return key
	end
end

-- Return TTFont depending on language
function getTTFont(font, size, size2)

	local option_ttf 
	if (current_language == "ko" 
		or current_language == "ru"
		or current_language == "ja"
		or current_language == "zh"
		or current_language == "el") then
		
		local special_size = size2 or size
		option_ttf = TTFont.new("fonts/DroidSansFallback.ttf", special_size)
	else
		option_ttf = TTFont.new(font, size)
	end
	
	return option_ttf
end