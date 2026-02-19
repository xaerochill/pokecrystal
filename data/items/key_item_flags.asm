; lookup table: key item flag index -> item ID
; used by BuildKeyItemList and GetKeyItemName to convert flag indices to item IDs
KeyItemFlagToItemID:
; index 0 = unused padding, indices 1-22 = key items
	db NO_ITEM       ; 0 (padding)
	db BICYCLE       ; KEYITEM_BICYCLE
	db COIN_CASE     ; KEYITEM_COIN_CASE
	db ITEMFINDER    ; KEYITEM_ITEMFINDER
	db OLD_ROD       ; KEYITEM_OLD_ROD
	db GOOD_ROD      ; KEYITEM_GOOD_ROD
	db SUPER_ROD     ; KEYITEM_SUPER_ROD
	db RED_SCALE     ; KEYITEM_RED_SCALE
	db SECRETPOTION  ; KEYITEM_SECRETPOTION
	db S_S_TICKET    ; KEYITEM_S_S_TICKET
	db MYSTERY_EGG   ; KEYITEM_MYSTERY_EGG
	db CLEAR_BELL    ; KEYITEM_CLEAR_BELL
	db SILVER_WING   ; KEYITEM_SILVER_WING
	db GS_BALL       ; KEYITEM_GS_BALL
	db BLUE_CARD     ; KEYITEM_BLUE_CARD
	db CARD_KEY      ; KEYITEM_CARD_KEY
	db MACHINE_PART  ; KEYITEM_MACHINE_PART
	db EGG_TICKET    ; KEYITEM_EGG_TICKET
	db LOST_ITEM     ; KEYITEM_LOST_ITEM
	db BASEMENT_KEY  ; KEYITEM_BASEMENT_KEY
	db PASS          ; KEYITEM_PASS
	db SQUIRTBOTTLE  ; KEYITEM_SQUIRTBOTTLE
	db RAINBOW_WING  ; KEYITEM_RAINBOW_WING

; reverse lookup: item ID -> key item flag index
; returns flag index (1-based) in a, or 0 if not a key item
; input: a = item ID
; output: a = key item flag index, or 0
ItemIDToKeyItemFlag::
	cp BICYCLE
	jr z, .bicycle
	cp COIN_CASE
	jr z, .coin_case
	cp ITEMFINDER
	jr z, .itemfinder
	cp OLD_ROD
	jr z, .old_rod
	cp GOOD_ROD
	jr z, .good_rod
	cp SUPER_ROD
	jr z, .super_rod
	cp RED_SCALE
	jr z, .red_scale
	cp SECRETPOTION
	jr z, .secretpotion
	cp S_S_TICKET
	jr z, .s_s_ticket
	cp MYSTERY_EGG
	jr z, .mystery_egg
	cp CLEAR_BELL
	jr z, .clear_bell
	cp SILVER_WING
	jr z, .silver_wing
	cp GS_BALL
	jr z, .gs_ball
	cp BLUE_CARD
	jr z, .blue_card
	cp CARD_KEY
	jr z, .card_key
	cp MACHINE_PART
	jr z, .machine_part
	cp EGG_TICKET
	jr z, .egg_ticket
	cp LOST_ITEM
	jr z, .lost_item
	cp BASEMENT_KEY
	jr z, .basement_key
	cp PASS
	jr z, .pass
	cp SQUIRTBOTTLE
	jr z, .squirtbottle
	cp RAINBOW_WING
	jr z, .rainbow_wing
	xor a ; not a key item
	ret

.bicycle
	ld a, KEYITEM_BICYCLE
	ret
.coin_case
	ld a, KEYITEM_COIN_CASE
	ret
.itemfinder
	ld a, KEYITEM_ITEMFINDER
	ret
.old_rod
	ld a, KEYITEM_OLD_ROD
	ret
.good_rod
	ld a, KEYITEM_GOOD_ROD
	ret
.super_rod
	ld a, KEYITEM_SUPER_ROD
	ret
.red_scale
	ld a, KEYITEM_RED_SCALE
	ret
.secretpotion
	ld a, KEYITEM_SECRETPOTION
	ret
.s_s_ticket
	ld a, KEYITEM_S_S_TICKET
	ret
.mystery_egg
	ld a, KEYITEM_MYSTERY_EGG
	ret
.clear_bell
	ld a, KEYITEM_CLEAR_BELL
	ret
.silver_wing
	ld a, KEYITEM_SILVER_WING
	ret
.gs_ball
	ld a, KEYITEM_GS_BALL
	ret
.blue_card
	ld a, KEYITEM_BLUE_CARD
	ret
.card_key
	ld a, KEYITEM_CARD_KEY
	ret
.machine_part
	ld a, KEYITEM_MACHINE_PART
	ret
.egg_ticket
	ld a, KEYITEM_EGG_TICKET
	ret
.lost_item
	ld a, KEYITEM_LOST_ITEM
	ret
.basement_key
	ld a, KEYITEM_BASEMENT_KEY
	ret
.pass
	ld a, KEYITEM_PASS
	ret
.squirtbottle
	ld a, KEYITEM_SQUIRTBOTTLE
	ret
.rainbow_wing
	ld a, KEYITEM_RAINBOW_WING
	ret
