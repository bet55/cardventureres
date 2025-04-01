extends Node2D

#при вынесении основной логики в CardData здесь сломалась сигнатура метода, тк
#в мобе мейн эффект брал только 1 аргумент
#сейчас автомейн эффект вызывает мейн эффект передавая туда саму карту, вызывающую его и нул вместо таргета
func use_main_effect(card):
	var apllying_card = card
	var target_card = null
	card.main_effect.call(apllying_card, target_card)
