_ReceiveItem::
	call DoesHLEqualNumItems
	jp nz, PutItemInPocket
	push hl
	call CheckItemPocket
	pop de
	ld a, [wItemAttributeValue]
	dec a
	ld hl, .Pockets
	rst JumpTable
	ret

.Pockets:
; entries correspond to item types
	dw .Item
	dw .KeyItem
	dw .Ball
	dw .TMHM ; impossible

.Item:
	ld h, d
	ld l, e
	jp PutItemInPocket

.KeyItem:
	ld h, d
	ld l, e
	jp ReceiveKeyItem

.Ball:
	ld hl, wNumBalls
	jp PutItemInPocket

.TMHM:
	ret

_TossItem::
	call DoesHLEqualNumItems
	jr nz, .remove
	push hl
	call CheckItemPocket
	pop de
	ld a, [wItemAttributeValue]
	dec a
	ld hl, .Pockets
	rst JumpTable
	ret

.Pockets:
; entries correspond to item types
	dw .Item
	dw .KeyItem
	dw .Ball
	dw .TMHM

.Ball:
	ld hl, wNumBalls
	jp RemoveItemFromPocket

.TMHM:
	ld h, d
	ld l, e
	ld a, [wCurItem]
	ld c, a
	call GetTMHMNumber
	jp TossTMHM

.KeyItem:
	ld h, d
	ld l, e
	jp TossKeyItem

.Item:
	ld h, d
	ld l, e

.remove
	jp RemoveItemFromPocket

_CheckItem::
	call DoesHLEqualNumItems
	jr nz, .nope
	push hl
	call CheckItemPocket
	pop de
	ld a, [wItemAttributeValue]
	dec a
	ld hl, .Pockets
	rst JumpTable
	ret

.Pockets:
; entries correspond to item types
	dw .Item
	dw .KeyItem
	dw .Ball
	dw .TMHM

.Ball:
	ld hl, wNumBalls
	jp CheckTheItem

.TMHM:
	ld h, d
	ld l, e
	ld a, [wCurItem]
	ld c, a
	call GetTMHMNumber
	jp CheckTMHM

.KeyItem:
	ld h, d
	ld l, e
	jp CheckKeyItems

.Item:
	ld h, d
	ld l, e

.nope
	jp CheckTheItem

DoesHLEqualNumItems:
	ld a, l
	cp LOW(wNumItems)
	ret nz
	ld a, h
	cp HIGH(wNumItems)
	ret

GetPocketCapacity:
	ld c, MAX_ITEMS
	ld a, e
	cp LOW(wNumItems)
	jr nz, .not_bag
	ld a, d
	cp HIGH(wNumItems)
	ret z

.not_bag
	ld c, MAX_PC_ITEMS
	ld a, e
	cp LOW(wNumPCItems)
	jr nz, .not_pc
	ld a, d
	cp HIGH(wNumPCItems)
	ret z

.not_pc
	ld c, MAX_BALLS
	ret

PutItemInPocket:
	ld d, h
	ld e, l
	inc hl
	ld a, [wCurItem]
	ld c, a
	ld b, 0
.loop
	ld a, [hli]
	cp -1
	jr z, .terminator
	cp c
	jr nz, .next
	ld a, MAX_ITEM_STACK
	sub [hl]
	add b
	ld b, a
	ld a, [wItemQuantityChange]
	cp b
	jr z, .ok
	jr c, .ok

.next
	inc hl
	jr .loop

.terminator
	call GetPocketCapacity
	ld a, [de]
	cp c
	jr c, .ok
	and a
	ret

.ok
	ld h, d
	ld l, e
	ld a, [wCurItem]
	ld c, a
	ld a, [wItemQuantityChange]
	ld [wItemQuantity], a
.loop2
	inc hl
	ld a, [hli]
	cp -1
	jr z, .terminator2
	cp c
	jr nz, .loop2
	ld a, [wItemQuantity]
	add [hl]
	cp MAX_ITEM_STACK + 1
	jr nc, .newstack
	ld [hl], a
	jr .done

.newstack
	ld [hl], MAX_ITEM_STACK
	sub MAX_ITEM_STACK
	ld [wItemQuantity], a
	jr .loop2

.terminator2
	dec hl
	ld a, [wCurItem]
	ld [hli], a
	ld a, [wItemQuantity]
	ld [hli], a
	ld [hl], -1
	ld h, d
	ld l, e
	inc [hl]

.done
	scf
	ret

RemoveItemFromPocket:
	ld d, h
	ld e, l
	ld a, [hli]
	ld c, a
	ld a, [wCurItemQuantity]
	cp c
	jr nc, .ok ; memory
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [wCurItem]
	cp [hl]
	inc hl
	jr z, .skip
	ld h, d
	ld l, e
	inc hl

.ok
	ld a, [wCurItem]
	ld b, a
.loop
	ld a, [hli]
	cp b
	jr z, .skip
	cp -1
	jr z, .nope
	inc hl
	jr .loop

.skip
	ld a, [wItemQuantityChange]
	ld b, a
	ld a, [hl]
	sub b
	jr c, .nope
	ld [hl], a
	ld [wItemQuantity], a
	and a
	jr nz, .yup
	dec hl
	ld b, h
	ld c, l
	inc hl
	inc hl
.loop2
	ld a, [hli]
	ld [bc], a
	inc bc
	cp -1
	jr nz, .loop2
	ld h, d
	ld l, e
	dec [hl]

.yup
	scf
	ret

.nope
	and a
	ret

CheckTheItem:
	ld a, [wCurItem]
	ld c, a
.loop
	inc hl
	ld a, [hli]
	cp -1
	jr z, .done
	cp c
	jr nz, .loop
	scf
	ret

.done
	and a
	ret

ReceiveKeyItem:
; input: wCurItem = item ID
; output: carry set (always succeeds)
	push bc
	push de
	push hl

	ld a, [wCurItem]
	call ItemIDToKeyItemFlag
	and a
	jr z, .nope

	dec a ; convert to 0-indexed for FlagAction
	ld e, a
	ld d, 0
	ld hl, wKeyItemFlags
	ld b, SET_FLAG
	call FlagAction

	pop hl
	pop de
	pop bc
	scf ; always succeeds
	ret

.nope
	pop hl
	pop de
	pop bc
	and a
	ret

TossKeyItem:
; input: wCurItem = item ID
; output: carry set if successful
	push bc
	push de
	push hl

	ld a, [wCurItem]
	call ItemIDToKeyItemFlag
	and a
	jr z, .nope

	dec a
	ld e, a
	ld d, 0
	ld hl, wKeyItemFlags
	ld b, RESET_FLAG
	call FlagAction

	pop hl
	pop de
	pop bc
	scf
	ret

.nope
	pop hl
	pop de
	pop bc
	and a
	ret

CheckKeyItems:
; input: wCurItem = item ID
; output: carry set if owned
	push bc
	push de
	push hl

	ld a, [wCurItem]
	call ItemIDToKeyItemFlag
	and a
	jr z, .not_owned

	dec a
	ld e, a
	ld d, 0
	ld hl, wKeyItemFlags
	ld b, CHECK_FLAG
	call FlagAction
	ld a, c

	pop hl
	pop de
	pop bc

	and a
	ret z ; no carry if not owned
	scf   ; set carry if owned
	ret

.not_owned
	pop hl
	pop de
	pop bc
	and a
	ret

INCLUDE "data/items/key_item_flags.asm"

_Script_checkkeyitem::
	call GetScriptByte
	dec a
	ld e, a
	ld d, 0
	ld b, CHECK_FLAG
	ld hl, wKeyItemFlags
	call FlagAction
	ld a, c
	ld [wScriptVar], a
	ret

_Script_takekeyitem::
	call GetScriptByte
	dec a
	ld e, a
	ld d, 0
	ld b, RESET_FLAG
	ld hl, wKeyItemFlags
	call FlagAction
	ret

_Script_verbosegivekeyitem::
; sets flag, gets name into wStringBuffer1. Trampoline handles CopyConvertedText + ScriptCall.
	call GetScriptByte
	push af
	dec a
	ld e, a
	ld d, 0
	ld b, SET_FLAG
	ld hl, wKeyItemFlags
	call FlagAction
	pop af
	; get key item name (inline - same bank as KeyItemFlagToItemID)
	ld c, a
	ld b, 0
	ld hl, KeyItemFlagToItemID
	add hl, bc
	ld a, [hl]
	ld [wNamedObjectIndex], a
	call GetItemName
	ret

_Script_getkeyitemname::
; reads flag index, looks up item name into wStringBuffer1. Trampoline handles GetScriptByte + CopyConvertedText.
	call GetScriptByte
	ld c, a
	ld b, 0
	ld hl, KeyItemFlagToItemID
	add hl, bc
	ld a, [hl]
	ld [wNamedObjectIndex], a
	call GetItemName
	ret

; TM/HM script handler implementations (moved from scripting.asm to free bank space)

_Script_checktmhm::
	call GetScriptByte
	dec a
	ld e, a
	ld d, 0
	ld b, CHECK_FLAG
	ld hl, wTMsHMs
	call FlagAction
	ld a, c
	ld [wScriptVar], a
	ret

_Script_verbosegivetmhm::
; sets flag, gets name into wStringBuffer1. Trampoline handles CopyConvertedText + ScriptCall.
	call GetScriptByte
	ld [wCurTMHM], a
	dec a
	ld e, a
	ld d, 0
	ld b, SET_FLAG
	ld hl, wTMsHMs
	call FlagAction
	ld a, [wCurTMHM]
	ld [wNamedObjectIndex], a
	call GetTMHMName
	ret

_Script_gettmhmname::
; gets TM/HM name into wStringBuffer1. Trampoline handles GetScriptByte + CopyConvertedText.
	call GetScriptByte
	ld [wNamedObjectIndex], a
	call GetTMHMName
	ret

ReceiveTMHM::
; input: c = TM/HM flag index (1-104)
; output: carry set if successful
	push bc
	push de
	push hl

	ld a, c
	dec a ; convert to 0-indexed
	ld e, a
	ld d, 0
	ld hl, wTMsHMs
	ld b, SET_FLAG
	call FlagAction

	pop hl
	pop de
	pop bc
	scf ; always succeeds
	ret

TossTMHM::
; input: c = TM/HM flag index (1-104)
	push bc
	push de
	push hl

	ld a, c
	dec a
	ld e, a
	ld d, 0
	ld hl, wTMsHMs
	ld b, RESET_FLAG
	call FlagAction

	pop hl
	pop de
	pop bc
	ret

CheckTMHM::
; input: c = TM/HM flag index (1-104)
; output: carry set if player owns it
	push bc
	push de
	push hl

	ld a, c
	dec a
	ld e, a
	ld d, 0
	ld hl, wTMsHMs
	ld b, CHECK_FLAG
	call FlagAction
	ld a, c ; save `FlagAction`  result

	pop hl
	pop de
	pop bc

	and a  ; now test result from `FlagAction`
	ret z  ; no carry if not owned
	scf    ; set carry if owned
	ret

ConsumeTMHM::
; input: c = TM/HM flag index (1-104)
	push bc
	push de
	push hl
	push af

; check if this is a TM (indices 1-50) or HM (51-57)
	ld a, c
	cp 51         ; first HM index
	jr nc, .is_hm ; don't consume HMs
	call TossTMHM ; reuse TossTMHM to clear the flag

.is_hm:
	pop af
	pop hl
	pop de
	pop bc
	ret

GetTMHMNumber::
	ld a, [wCurTMHM]
	ld c, a
	ret

_CheckTossableItem::
; Return 1 in wItemAttributeValue and carry if wCurItem can't be removed from the bag.
	ld a, ITEMATTR_PERMISSIONS
	call GetItemAttr
	bit CANT_TOSS_F, a
	jr nz, ItemAttr_ReturnCarry
	and a
	ret

CheckSelectableItem:
; Return 1 in wItemAttributeValue and carry if wCurItem can't be selected.
	ld a, ITEMATTR_PERMISSIONS
	call GetItemAttr
	bit CANT_SELECT_F, a
	jr nz, ItemAttr_ReturnCarry
	and a
	ret

CheckItemPocket::
; Return the pocket for wCurItem in wItemAttributeValue.
	ld a, ITEMATTR_POCKET
	call GetItemAttr
	and $f
	ld [wItemAttributeValue], a
	ret

CheckItemContext:
; Return the context for wCurItem in wItemAttributeValue.
	ld a, ITEMATTR_HELP
	call GetItemAttr
	and $f
	ld [wItemAttributeValue], a
	ret

CheckItemMenu:
; Return the menu for wCurItem in wItemAttributeValue.
	ld a, ITEMATTR_HELP
	call GetItemAttr
	swap a
	and $f
	ld [wItemAttributeValue], a
	ret

GetItemAttr:
; Get attribute a of wCurItem.

	push hl
	push bc

	ld hl, ItemAttributes
	ld c, a
	ld b, 0
	add hl, bc

	xor a
	ld [wItemAttributeValue], a

	ld a, [wCurItem]
	dec a
	ld c, a
	ld a, ITEMATTR_STRUCT_LENGTH
	call AddNTimes
	ld a, BANK(ItemAttributes)
	call GetFarByte

	pop bc
	pop hl
	ret

ItemAttr_ReturnCarry:
	ld a, 1
	ld [wItemAttributeValue], a
	scf
	ret

GetItemPrice:
; Return the price of wCurItem in de.
	push hl
	push bc
	ld a, ITEMATTR_PRICE_LO
	call GetItemAttr
	ld e, a
	ld a, ITEMATTR_PRICE_HI
	call GetItemAttr
	ld d, a
	pop bc
	pop hl
	ret
