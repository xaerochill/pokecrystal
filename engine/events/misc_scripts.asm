Script_AbortBugContest:
	checkflag ENGINE_BUG_CONTEST_TIMER
	iffalse .finish
	setflag ENGINE_DAILY_BUG_CONTEST
	special ContestReturnMons
.finish
	end

FindItemInBallScript::
	callasm .TryReceiveItem
	iffalse .no_room
	if_equal $2, .tm_found
	disappear LAST_TALKED
	opentext
	writetext .FoundItemText
	playsound SFX_ITEM
	pause 60
	itemnotify
	closetext
	end

.no_room
	opentext
	writetext .FoundItemText
	waitbutton
	writetext .CantCarryItemText
	waitbutton
	closetext
	end

.tm_found
	; TM/HM found - skip itemnotify (TMs don't go into pockets)
	disappear LAST_TALKED
	opentext
	writetext .FoundItemText
	playsound SFX_ITEM
	pause 60
	writetext .TMStoredText
	waitbutton
	closetext
	end

.FoundItemText:
	text_far _FoundItemText
	text_end

.CantCarryItemText:
	text_far _CantCarryItemText
	text_end

.TMStoredText:
	text_far _TMStoredText
	text_end

.TryReceiveItem:
	xor a
	ld [wScriptVar], a

	ld a, [wItemBallItemID]
	bit 7, a ; check high bit - is it a TM/HM?
	jr nz, .tmhm_ball

	; regular item - original code
	ld [wNamedObjectIndex], a
	call GetItemName
	ld hl, wStringBuffer3
	call CopyName2
	ld a, [wItemBallItemID]
	ld [wCurItem], a
	ld a, [wItemBallQuantity]
	ld [wItemQuantityChange], a
	ld hl, wNumItems
	call ReceiveItem
	ret nc
	ld a, $1
	ld [wScriptVar], a
	ret

.tmhm_ball:
	and $7F ; clear high bit to get TM/HM number
	ld c, a
	ld [wNamedObjectIndex], a
	push bc
	call GetTMHMName
	ld de, wStringBuffer1
.find_end
	ld a, [de]
	cp '@'
	jr z, .found_end
	inc de
	jr .find_end
.found_end
	inc de
	pop bc
	push bc
	call AppendTMHMMoveName
	ld hl, wStringBuffer3
	ld de, wStringBuffer1
	call CopyName2 ; copy to wStringBuffer3 for text display
	pop bc

	ld a, [wItemBallItemID]
	and $7F
	ld c, a
	farcall ReceiveTMHM

	ld a, $2 ; return 2 for TM/HM (different from 1 for regular items)
	ld [wScriptVar], a
	ret
