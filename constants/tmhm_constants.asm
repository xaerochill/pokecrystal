DEF __tmhm_value__ = 1
DEF __tm_count__ = 0

MACRO add_tmnum
	DEF \1_TMNUM EQU __tmhm_value__
	DEF __tmhm_value__ += 1
ENDM

MACRO add_tm
; creates TM_\1, \1_TMNUM, and TMxx numeric alias
	DEF __tm_count__ += 1
	DEF TM_\1 EQU __tmhm_value__
	DEF \1_TMNUM EQU __tmhm_value__
	DEF TM{02d:__tm_count__} EQU __tmhm_value__  ; TM01, TM02, etc.
	DEF __tmhm_value__ += 1
ENDM

DEF __hm_count__ = 0

MACRO add_hm
; creates HM_\1, \1_TMNUM, and HMxx numeric alias
	DEF __hm_count__ += 1
	DEF HM_\1 EQU __tmhm_value__
	DEF \1_TMNUM EQU __tmhm_value__
	DEF HM{02d:__hm_count__} EQU __tmhm_value__  ; HM01, HM02, etc.
	DEF __tmhm_value__ += 1
ENDM

MACRO add_mt
; Defines two constants:
; - \1_TMNUM: the learnable TM/HM flag, starting at 58
; - MT##_MOVE: alias for the move id, equal to the value of \1
	DEF MT_VALUE = __tmhm_value__ - NUM_TMS - NUM_HMS
	DEF MT{02d:MT_VALUE}_MOVE = \1
	add_tmnum \1
ENDM

const_def
	const NO_TMHM       ; 00
	add_tm DYNAMICPUNCH ; 01
	add_tm HEADBUTT     ; 02
	add_tm CURSE        ; 03
	add_tm ROLLOUT      ; 04
	add_tm ROAR         ; 05
	add_tm TOXIC        ; 06
	add_tm ZAP_CANNON   ; 07
	add_tm ROCK_SMASH   ; 08
	add_tm PSYCH_UP     ; 09
	add_tm HIDDEN_POWER ; 10
	add_tm SUNNY_DAY    ; 11
	add_tm SWEET_SCENT  ; 12
	add_tm SNORE        ; 13
	add_tm BLIZZARD     ; 14
	add_tm HYPER_BEAM   ; 15
	add_tm ICY_WIND     ; 16
	add_tm PROTECT      ; 17
	add_tm RAIN_DANCE   ; 18
	add_tm GIGA_DRAIN   ; 19
	add_tm ENDURE       ; 20
	add_tm FRUSTRATION  ; 21
	add_tm SOLARBEAM    ; 22
	add_tm IRON_TAIL    ; 23
	add_tm DRAGONBREATH ; 24
	add_tm THUNDER      ; 25
	add_tm EARTHQUAKE   ; 26
	add_tm RETURN       ; 27
	add_tm DIG          ; 28
	add_tm PSYCHIC_M    ; 29
	add_tm SHADOW_BALL  ; 30
	add_tm MUD_SLAP     ; 31
	add_tm DOUBLE_TEAM  ; 32
	add_tm ICE_PUNCH    ; 33
	add_tm SWAGGER      ; 34
	add_tm SLEEP_TALK   ; 35
	add_tm SLUDGE_BOMB  ; 36
	add_tm SANDSTORM    ; 37
	add_tm FIRE_BLAST   ; 38
	add_tm SWIFT        ; 39
	add_tm DEFENSE_CURL ; 40
	add_tm THUNDERPUNCH ; 41
	add_tm DREAM_EATER  ; 42
	add_tm DETECT       ; 43
	add_tm REST         ; 44
	add_tm ATTRACT      ; 45
	add_tm THIEF        ; 46
	add_tm STEEL_WING   ; 47
	add_tm FIRE_PUNCH   ; 48
	add_tm FURY_CUTTER  ; 49
	add_tm NIGHTMARE    ; 50
DEF NUM_TMS EQU __tmhm_value__ - 1

	add_hm CUT          ; 01
	add_hm FLY          ; 02
	add_hm SURF         ; 03
	add_hm STRENGTH     ; 04
	add_hm FLASH        ; 05
	add_hm WHIRLPOOL    ; 06
	add_hm WATERFALL    ; 07
DEF NUM_HMS EQU __tmhm_value__ - NUM_TMS - 1

DEF NUM_TM_HM EQU NUM_TMS + NUM_HMS
DEF NUM_TM_HM_FLAGS EQU NUM_TM_HM

DEF MT01 EQU const_value
	add_mt FLAMETHROWER
	add_mt THUNDERBOLT
	add_mt ICE_BEAM
DEF NUM_TUTORS = __tmhm_value__ - NUM_TMS - NUM_HMS - 1

DEF NUM_TM_HM_TUTOR EQU NUM_TMS + NUM_HMS + NUM_TUTORS