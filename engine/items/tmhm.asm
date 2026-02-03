TMHMPocket:
	ld a, $1
	ldh [hInMenu], a
	call TMHM_PocketLoop
	ld a, $0
	ldh [hInMenu], a
	ret nc
	call PlaceHollowCursor
	call WaitBGMap
	ld a, [wCurItem] ; wCurItem now contains TM/HM number (1-104) from TMHM_CheckHoveringOverCancel
	ld [wCurTMHM], a ; Store in wCurTMHM for other routines
	scf
	ret

ConvertCurItemIntoCurTMHM: ; if you make TM's infinite-use, this is unreferenced and can be deleted
	ld a, [wCurItem]
	ld c, a
	callfar GetTMHMNumber
	ld a, c
	ld [wTempTMHM], a
	ret

GetTMHMItemMove:
; get the move taught by current TM/HM
; input: wCurTMHM = TM/HM number (1-104)
; output: wTempTMHM = move index
	ld a, [wCurTMHM]
	ld [wTempTMHM], a
	predef GetTMHMMove
	ret

AskTeachTMHM:
; ask player if they want to teach TM/HM move
; input: wCurTMHM = TM/HM number (1-104)
	ld hl, wOptions
	ld a, [hl]
	push af
	res NO_TEXT_SCROLL, [hl]
	ld a, [wCurTMHM]
	and a
	jr z, .NotTMHM ; 0 = no TM/HM
	call GetTMHMItemMove
	ld a, [wTempTMHM]
	ld [wNamedObjectIndex], a
	ld [wPutativeTMHMMove], a
	call GetMoveName
	call CopyName1
	; Check if TM or HM
	ld hl, BootedTMText
	ld a, [wCurTMHM]
	cp NUM_TMS + 1
	jr c, .TM ; 1-50 = TM
	ld hl, BootedHMText
.TM
	call PrintText
	ld hl, ContainedMoveText
	call PrintText
	call YesNoBox
.NotTMHM
	pop bc
	ld a, b
	ld [wOptions], a
	ret

ChooseMonToLearnTMHM:
	ld hl, wStringBuffer2
	ld de, wTMHMMoveNameBackup
	ld bc, MOVE_NAME_LENGTH - 1
	call CopyBytes
	call ClearBGPalettes
ChooseMonToLearnTMHM_NoRefresh:
	farcall LoadPartyMenuGFX
	farcall InitPartyMenuWithCancel
	farcall InitPartyMenuGFX
	ld a, PARTYMENUACTION_TEACH_TMHM
	ld [wPartyMenuActionText], a
.loopback
	farcall WritePartyMenuTilemap
	farcall PlacePartyMenuText
	call WaitBGMap
	call SetDefaultBGPAndOBP
	call DelayFrame
	farcall PartyMenuSelect
	push af
	ld a, [wCurPartySpecies]
	cp EGG
	pop bc ; now contains the former contents of af
	jr z, .egg
	push bc
	ld hl, wTMHMMoveNameBackup
	ld de, wStringBuffer2
	ld bc, MOVE_NAME_LENGTH - 1
	call CopyBytes
	pop af ; now contains the original contents of af
	ret

.egg
	push hl
	push de
	push bc
	push af
	ld de, SFX_WRONG
	call PlaySFX
	call WaitSFX
	pop af
	pop bc
	pop de
	pop hl
	jr .loopback

TeachTMHM:
	predef CanLearnTMHMMove

	push bc
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call GetNickname
	pop bc

	ld a, c
	and a
	jr nz, .compatible
	push de
	ld de, SFX_WRONG
	call PlaySFX
	pop de
	ld hl, TMHMNotCompatibleText
	call PrintText
	jr .nope

.compatible
	callfar KnowsMove
	jr c, .nope

	predef LearnMove
	ld a, b
	and a
	jr z, .nope

	farcall StubbedTrainerRankings_TMsHMsTaught
	ld a, [wCurItem]
	call IsHM
	ret c

	ld c, HAPPINESS_LEARNMOVE
	callfar ChangeHappiness
	call ConsumeTM ; remove this to make TM's infinite-use
	jr .learned_move

.nope
	and a
	ret

.didnt_use ; unreferenced
	ld a, 2
	ld [wItemEffectSucceeded], a
.learned_move
	scf
	ret

BootedTMText:
	text_far _BootedTMText
	text_end

BootedHMText:
	text_far _BootedHMText
	text_end

ContainedMoveText:
	text_far _ContainedMoveText
	text_end

TMHMNotCompatibleText:
	text_far _TMHMNotCompatibleText
	text_end

TMHM_PocketLoop:
	xor a
	ldh [hBGMapMode], a
	call TMHM_DisplayPocketItems
	ld a, 2
	ld [w2DMenuCursorInitY], a
	ld a, 7
	ld [w2DMenuCursorInitX], a
	ld a, 1
	ld [w2DMenuNumCols], a
	ld a, 5
	sub d
	inc a
	cp 6
	jr nz, .okay
	dec a
.okay
	ld [w2DMenuNumRows], a
	ld a, $c
	ld [w2DMenuFlags1], a
	xor a
	ld [w2DMenuFlags2], a
	ld a, $20
	ld [w2DMenuCursorOffsets], a
	ld a, PAD_A | PAD_B | PAD_CTRL_PAD
	ld [wMenuJoypadFilter], a
	ld a, [wTMHMPocketCursor]
	inc a
	ld [wMenuCursorY], a
	ld a, $1
	ld [wMenuCursorX], a
	jr TMHM_ShowTMMoveDescription

TMHM_JoypadLoop:
	call TMHM_DisplayPocketItems
	call StaticMenuJoypad
	ld b, a
	ld a, [wMenuCursorY]
	dec a
	ld [wTMHMPocketCursor], a
	xor a
	ldh [hBGMapMode], a
	ld a, [w2DMenuFlags2]
	bit _2DMENU_EXITING_F, a
	jp nz, TMHM_ScrollPocket
	ld a, b
	ld [wMenuJoypad], a
	bit B_PAD_A, a
	jp nz, TMHM_ChooseTMorHM
	bit B_PAD_B, a
	jp nz, TMHM_ExitPack
	bit B_PAD_RIGHT, a
	jp nz, TMHM_ExitPocket
	bit B_PAD_LEFT, a
	jp nz, TMHM_ExitPocket
TMHM_ShowTMMoveDescription:
	call TMHM_CheckHoveringOverCancel
	jp nc, TMHM_ExitPocket
	hlcoord 0, 12
	ld b, 4
	ld c, SCREEN_WIDTH - 2
	call Textbox
	ld a, [wCurItem]
	cp NUM_TMS + NUM_HMS + 1
	jr nc, TMHM_JoypadLoop
	ld [wTempTMHM], a
	predef GetTMHMMove
	ld a, [wTempTMHM]
	ld [wCurSpecies], a
	hlcoord 1, 14
	call PrintMoveDescription
	jp TMHM_JoypadLoop

TMHM_ChooseTMorHM:
	call TMHM_PlaySFX_ReadText2
	call CountTMsHMs ; This stores the count to wTempTMHM.
	ld a, [wMenuCursorY]
	dec a
	ld b, a
	ld a, [wTMHMPocketScrollPosition]
	add b
	ld b, a
	ld a, [wTempTMHM]
	cp b
	jr z, _TMHM_ExitPack ; our cursor was hovering over CANCEL
TMHM_CheckHoveringOverCancel:
; find which TM/HM the cursor is on
; output: wCurItem = TM/HM number (or -1 for CANCEL)
; carry set if on a TM/HM, clear if on CANCEL
	call TMHM_GetCurrentPocketPosition
	ld a, [wMenuCursorY]
	ld b, a
.loop
	inc c
	ld a, c
	cp NUM_TM_HM_FLAGS + 1
	jr nc, .okay ; past end = CANCEL
	
	push bc
	ld a, c
	call CheckTMHMOwned
	pop bc
	jr nc, .loop ; not owned, keep looking

	dec b
	jr nz, .loop ; not at cursor yet
	ld a, c
.okay
	ld [wCurItem], a
	cp -1
	ret

TMHM_ExitPack:
	call TMHM_PlaySFX_ReadText2
_TMHM_ExitPack:
	ld a, PAD_B
	ld [wMenuJoypad], a
	and a
	ret

TMHM_ExitPocket:
	and a
	ret

TMHM_ScrollPocket:
	ld a, b
	bit B_PAD_DOWN, a
	jr nz, .down

	; Scroll up
	ld hl, wTMHMPocketScrollPosition
	ld a, [hl]
	and a
	jp z, TMHM_JoypadLoop
	dec [hl]
	call TMHM_DisplayPocketItems
	jp TMHM_ShowTMMoveDescription

.down
	call TMHM_GetCurrentPocketPosition
	ld b, 5 ; need to find 5 more owned TMs
.loop
	inc c
	ld a, c
	cp NUM_TM_HM_FLAGS + 1
	jp nc, TMHM_JoypadLoop ; no more items, can't scroll
	
	push bc
	ld a, c
	call CheckTMHMOwned
	pop bc
	jr nc, .loop ; not owned, keep looking
	
	dec b
	jr nz, .loop ; haven't found 5 yet
	
	; found 5 more, can scroll down
	ld hl, wTMHMPocketScrollPosition
	inc [hl]
	call TMHM_DisplayPocketItems
	jp TMHM_ShowTMMoveDescription

TMHM_DisplayPocketItems:
	ld a, [wBattleType]
	cp BATTLETYPE_TUTORIAL
	jp z, Tutorial_TMHMPocket

	hlcoord 5, 2
	lb bc, 10, 15
	ld a, ' '
	call ClearBox
	call TMHM_GetCurrentPocketPosition
	ld d, 5 ; display up to 5 items
.loop
	inc c
	ld a, c
	cp NUM_TM_HM_FLAGS + 1
	jr nc, .NotTMHM ; past last TM/HM, show CANCEL
	
	; check if this TM/HM is owned
	push bc
	push de
	ld a, c
	call CheckTMHMOwned
	pop de
	pop bc
	jr nc, .loop ; not owned, skip to next
	
	; Found an owned TM/HM - display it
	ld a, c
	ld [wTempTMHM], a
	push de
	push bc
	call TMHMPocket_GetCurrentLineCoord
	push hl
	ld a, [wTempTMHM]
	cp NUM_TMS + 1
	jr nc, .HM

	; display TM number
	ld de, wTempTMHM
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	jr .printMove

.HM
	; display HM number
	push af
	sub NUM_TMS
	ld [wTempTMHM], a
	ld [hl], 'H'
	inc hl
	ld de, wTempTMHM
	lb bc, PRINTNUM_LEFTALIGN | 1, 2
	call PrintNum
	pop af
	ld [wTempTMHM], a

.printMove
	predef GetTMHMMove
	ld a, [wTempTMHM]
	ld [wNamedObjectIndex], a
	ld [wPutativeTMHMMove], a
	call GetMoveName
	pop hl
	ld bc, 3
	add hl, bc
	call PlaceString
	pop bc
	pop de
	dec d
	jr nz, .loop
	jr .done

.NotTMHM
	call TMHMPocket_GetCurrentLineCoord
	inc hl
	inc hl
	inc hl
	push de
	ld de, TMHM_CancelString
	call PlaceString
	pop de
.done
	ret

TMHMPocket_GetCurrentLineCoord:
	hlcoord 5, 0
	ld bc, 2 * SCREEN_WIDTH
	ld a, 6
	sub d
	ld e, a
	; AddNTimes
.loop
	add hl, bc
	dec e
	jr nz, .loop
	ret

TMHM_CancelString:
	db "CANCEL@"

TMHM_GetCurrentPocketPosition:
; find the TM/HM number at current scroll position
; output: c = TM/HM number (1-104) of first visible item
; (c = 0 means start from beginning)
	ld a, [wTMHMPocketScrollPosition]
	ld b, a
	inc b ; b = number of owned TMs to skip + 1
	ld c, 0 ; c = current TM/HM number (will be 1-57)
.loop
	inc c
	ld a, c
	cp NUM_TM_HM_FLAGS + 1
	jr nc, .done ; past last TM/HM
	call CheckTMHMOwned
	jr nc, .loop ; not owned, keep scanning
	dec b
	jr nz, .loop ; owned but not at target yet
.done
	dec c ; adjust to match original behavior
	ret

Tutorial_TMHMPocket:
	hlcoord 9, 3
	push de
	ld de, TMHM_CancelString
	call PlaceString
	pop de
	ret

TMHM_PlaySFX_ReadText2:
	push de
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	pop de
	ret

VerboseReceiveTMHM::
; give TM/HM and display message
; input: wCurTMHM = TM/HM number (1-104)
; output: carry always set (always succeeds)
	ld a, [wCurTMHM]
	ld c, a
	call ReceiveTMHM ; set the flag

	ld hl, .ReceivedTMHMText
	call PrintText
	scf
	ret

.ReceivedTMHMText:
	text_far _ReceivedTMHMText
	text_end

ConsumeTM: ; remove this to make TM's infinite-use
; clear the TM flag (consume it after teaching)
; uses FlagAction with RESET_FLAG
	call ConvertCurItemIntoCurTMHM
	ld a, [wTempTMHM]
	dec a ; convert to 0-indexed
	ld e, a
	ld d, 0
	ld hl, wTMsHMs
	ld b, RESET_FLAG
	call FlagAction
	
	; adjust scroll position since we removed an entry
	ld a, [wTMHMPocketScrollPosition]
	and a
	ret z
	dec a
	ld [wTMHMPocketScrollPosition], a
	ret

CountTMsHMs:
; count how many TMs/HMs the player owns
; output: wTempTMHM = count, a = count
	push bc
	ld b, 0 ; counter
	ld c, 1 ; current TM/HM number (1-57)
.loop
	ld a, c
	call CheckTMHMOwned
	jr nc, .not_owned
	inc b
.not_owned
	inc c
	ld a, c
	cp NUM_TM_HM_FLAGS + 1 ; ensures last HM is counted
	jr c, .loop

	ld a, b
	ld [wTempTMHM], a
	pop bc
	ret

CheckTMHMOwned::
; check if player owns TM/HM
; input: a = TM/HM number (1-104)
; output: carry set if owned, clear if not
	push bc
	push de
	push hl

	dec a ; convert to 0-indexed
	ld e, a
	ld d, 0
	ld hl, wTMsHMs
	ld b, CHECK_FLAG
	call FlagAction

	ld a, c ; FlagAction returns result in c

	pop hl
	pop de
	pop bc

	and a
	ret z ; no carry if flag is 0
	scf   ; set carry if flag is 1
	ret
