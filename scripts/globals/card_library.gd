extends Node

#XXYYZZ - XX-тип карты, YY-id карты внутри типа, ZZ-резерв на будущее
#01-герой
#02-босс
#03-моб
#04-помощник
#05-эквип
#06-расходник
#07-скилл
#08-мод
#09-лут(монеты и ресурсы)
#10-событие
#11-лут пак

const CARD_IDS = {
	010100: preload("uid://cbxw8j6jsyw88"), #test hero data
	030100: preload("uid://biyyfemyyv4t8"), #test mob data
	050100: preload("uid://rkbxilwgmfsr"), #test equipment data
	060100: preload("uid://bvyxfktw7wc5l"), #heal potion data
	070100: preload("uid://bqpt5nxvbpbyw"), #test skill data
	070200: preload("uid://bio4qriayousr"), #curse skill data
	080100: preload("uid://crl5wirrdi1ib"), #test mod data
	090100: preload("uid://b3witcfp3y650"), #coin loot data
	090200: preload("uid://dqqyhy6j41eca"), #key loot data 
	110100: preload("uid://v5r7nalbhrit"), #loot pack data
	
}
