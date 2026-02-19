; Key Item flag indices for wKeyItemFlags
; 1-based: dec before FlagAction (same convention as TM/HM)
	const_def 1
	const KEYITEM_BICYCLE       ; 1
	const KEYITEM_COIN_CASE     ; 2
	const KEYITEM_ITEMFINDER    ; 3
	const KEYITEM_OLD_ROD       ; 4
	const KEYITEM_GOOD_ROD      ; 5
	const KEYITEM_SUPER_ROD     ; 6
	const KEYITEM_RED_SCALE     ; 7
	const KEYITEM_SECRETPOTION  ; 8
	const KEYITEM_S_S_TICKET    ; 9
	const KEYITEM_MYSTERY_EGG   ; 10
	const KEYITEM_CLEAR_BELL    ; 11
	const KEYITEM_SILVER_WING   ; 12
	const KEYITEM_GS_BALL       ; 13
	const KEYITEM_BLUE_CARD     ; 14
	const KEYITEM_CARD_KEY      ; 15
	const KEYITEM_MACHINE_PART  ; 16
	const KEYITEM_EGG_TICKET    ; 17
	const KEYITEM_LOST_ITEM     ; 18
	const KEYITEM_BASEMENT_KEY  ; 19
	const KEYITEM_PASS          ; 20
	const KEYITEM_SQUIRTBOTTLE  ; 21
	const KEYITEM_RAINBOW_WING  ; 22
DEF NUM_KEY_ITEM_FLAGS EQU const_value - 1
