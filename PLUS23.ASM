		.MODEL Small
		.CODE
CSEG		SEGMENT
		assume CS:CSEG,DS:CSEG
		ORG	100h


MAIN_START:	jmp basla

install 	db "	PLUS.COM already$"

just_in		db "	PLUS.COM$"

copyright	label byte
db" installed.",0dh,0ah
koruma1:
db"	PLUS23.COM V2.3 by AYDIN TURAB˜ BAKIR.",0ah,0dh
db"			ANADOLU UNV MMF ELEKTRONIK ",0ah,0dh
koruma2:
db" LEFT_ALT-Key(PAD) ",0ah,0dh
db"	LEFT_ALT-SHIFT-S	ž",0ah,0dh
db" (pad)  LEFT_ALT-4		Ã",0ah,0dh
db" (pad)  LEFT_ALT-SHIFT-9	»",0ah,0dh
db"	LEFT_ALT-]		¸",0ah,0dh
db" TšREK€E, DEUTSCHE and BOX CHARACTERS",0ah,0dh,24h   
;---------------------------------------------------------------------

Old		dd	0
_shift		db	0

; scan kodlari

_SCAN	label	byte

_e	db	12h
_a	db	1eh
_s	db	1fh
_u	db	16h
_i	db	17h
_o	db	18h
_g	db	22h
_n	db	31h
_b	db	30h
_c	db	2eh

; boxing tools

box_t	db	52h,53h
	db	47h,48h,49h
	db	4bh,4ch,4dh
	db	4fh,50h,51h

; sub-boxing
box_t2	db	19h,1ah,1bh
	db	26h,27h,28h
	db	33h,34h,35h

_SIRA	dw	0


; ascii kodlari

_ASCII	label byte

	db	89h,90h,84h,8eh,9fh,9eh,81h,9ah,8dh,98h,94h,99h,0a7h,0a6h
	db	0a4h,0a5h,0e1h,0e1h,87h,80h	
; box
	db	196,205,179,186

	db	218,201,	194,203,	191,187
	db	195,204,	197,206,	180,185
	db	192,200,	193,202,	217,188

; sub-boxing
	db	213,214,	209,210,	184,183
	db	198,199,	216,215,	181,182
	db	212,211,	207,208,	190,189	


basla:
	mov	di,offset koruma1
	mov	cx,offset koruma2-offset koruma1
	xor	ax,ax
koruma:
	add	ax,[di]
	inc	di
	loop	koruma

	cmp	ax,0BE3h
	jz	basarili		
	int	5h
kitle:	jmp	kitle

basarili:
	xor	ax,ax
	mov	ds,ax
	mov	bx,ds:198h
	or	bx,bx
	jz	install_et

	push	cs
	pop	ds
	mov	ah,9
	mov	dx,offset install
	int	21h
	call	copyr
	int	20h

install_et:				

	push	cs
	pop	ax
	mov	word ptr ds:198h,ax
	push	cs
	pop	ds

	mov	ax,3509h
	int	21h
	mov	cs:word ptr Old[0],bx
	mov	cs:word ptr Old[2],es

	mov	dx,offset New
	push	cs
	pop	ds
	mov	ax,2509h
	int	21h
	mov	ah,9
	mov	dx,offset just_in
	int	21h
	call	copyr
	mov	dx,offset END_OF_PRG
	int	27h
copyr:
	mov	ah,9
	mov	dx,offset copyright
	int	21h
	ret


New:
	sti
	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di
	push	ds
	push	es
	pushf
	cld

	mov	cs:word ptr _SIRA, offset _SIRA - offset _SCAN

	mov	cs:byte ptr _IRET,90h		;nop

	mov	ax,40h
	mov	ds,ax
	mov	bx,ds:17h
	test	bx,1000000000b
	jnz	pass_1
	jmp	cikis1

pass_1:
	mov	byte ptr cs:_SHIFT,0

	and	bx,01000011b
	or	bx,bx
	jz	pass_2
	
	mov	byte ptr cs:_SHIFT,1	;shift yapiliyorsa bir yoldan


pass_2:

	in	al,60h

	push	cs
	pop	es
	mov	di,offset _SCAN
	mov	cx,word ptr cs:_SIRA
	repnz	scasb
	jz	degistir
	jmp	cikis1

degistir:

	sub	word ptr cs:_SIRA,cx

	mov	cs:byte ptr _IRET,0CFh		;iret yerlestir.
	push	ax
	in	al,61h
	mov	ah,al
	or 	al,80h
	out	61h,al
	pop	ax
	mov	ah,al

	push	ax

	push	cs
	pop	ds
	mov	bx,offset _ASCII
	mov	ax,ds:word ptr _SIRA
	dec	al
	add	al,al
	xor	ah,ah
	add	ax,cs:word ptr _SHIFT
	xlat

	pop	bx
	mov	ah,bh

	mov	dx,40h
	mov	ds,dx
	mov	bx,ds:1ch
	mov	si,bx		;si'de karakterin addresi saklandi
	add	bx,2
	cmp	bx,3eh
	jnz	ilk_donus
	mov	bx,1eh	
ilk_donus:
	cmp	bx,ds:1ah
	jz	cikis2

	mov	[si],ax
	mov	ds:1ch,bx


cikis2:	mov	al,20h
	out	20h,al


cikis1:
	popf
	pop	es
	pop	ds
	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax

_IRET:	db	90h

	pushf
	call	cs:dword ptr Old

	iret



END_OF_PRG:	nop

CSEG		ENDS
		END	MAIN_START


