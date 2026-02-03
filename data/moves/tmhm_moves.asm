TMHMMoves::
; entries correspond to *_TMNUM constants (see constants/tmhm_constants.asm)
	table_width 1

; TMs
	db DYNAMICPUNCH ; 01
	db HEADBUTT     ; 02
	db CURSE        ; 03
	db ROLLOUT      ; 04
	db ROAR         ; 05
	db TOXIC        ; 06
	db ZAP_CANNON   ; 07
	db ROCK_SMASH   ; 08
	db PSYCH_UP     ; 09
	db HIDDEN_POWER ; 10
	db SUNNY_DAY    ; 11
	db SWEET_SCENT  ; 12
	db SNORE        ; 13
	db BLIZZARD     ; 14
	db HYPER_BEAM   ; 15
	db ICY_WIND     ; 16
	db PROTECT      ; 17
	db RAIN_DANCE   ; 18
	db GIGA_DRAIN   ; 19
	db ENDURE       ; 20
	db FRUSTRATION  ; 21
	db SOLARBEAM    ; 22
	db IRON_TAIL    ; 23
	db DRAGONBREATH ; 24
	db THUNDER      ; 25
	db EARTHQUAKE   ; 26
	db RETURN       ; 27
	db DIG          ; 28
	db PSYCHIC_M    ; 29
	db SHADOW_BALL  ; 30
	db MUD_SLAP     ; 31
	db DOUBLE_TEAM  ; 32
	db ICE_PUNCH    ; 33
	db SWAGGER      ; 34
	db SLEEP_TALK   ; 35
	db SLUDGE_BOMB  ; 36
	db SANDSTORM    ; 37
	db FIRE_BLAST   ; 38
	db SWIFT        ; 39
	db DEFENSE_CURL ; 40
	db THUNDERPUNCH ; 41
	db DREAM_EATER  ; 42
	db DETECT       ; 43
	db REST         ; 44
	db ATTRACT      ; 45
	db THIEF        ; 46
	db STEEL_WING   ; 47
	db FIRE_PUNCH   ; 48
	db FURY_CUTTER  ; 49
	db NIGHTMARE    ; 50
	assert_table_length NUM_TMS

; HMs
	db CUT          ; 01
	db FLY          ; 02
	db SURF         ; 03
	db STRENGTH     ; 04
	db FLASH        ; 05
	db WHIRLPOOL    ; 06
	db WATERFALL    ; 07
assert_table_length NUM_TM_HM

; Move tutors
DEF n = 1
for n, 1, NUM_TUTORS + 1
	db MT{02d:n}_MOVE
endr
	assert_table_length NUM_TM_HM_TUTOR

	db 0 ; end
