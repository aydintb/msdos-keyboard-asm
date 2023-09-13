		TITLE PRG Äalçümadan înce ekranç kaydçrçr... ATB den..
		.model small
		.code
CSEG		SEGMENT
		assume CS:CSEG,DS:CSEG
		org	100h
MAIN_START:	jmp	INSTALL

NEW_INT1c	PROC	FAR
		pushf
		push	ds
		push	si
		push	dx
		push	cx
		push	bx
		push	ax
		mov	ah,02h
		int	1ah
		push	cx
		push	dx
		mov	ax,0040h
		mov	ds,ax
		mov	ax,0b000h
		mov     bh,ds:byte ptr [63h]
		and	bh,40h
		or	bh,bh
		jz	MONO
		add	ax,0800h
MONO:		mov	ds,ax
		mov	ds:byte ptr [0+88h],'A'
		mov	ds:byte ptr [1+88H],73h
		mov	ds:byte ptr [2+88h],'T'
		mov	ds:byte ptr [3+88h],75h
		mov	ds:byte ptr [4+88h],'B'
		mov	ds:byte ptr [5+88h],72h
		mov	ds:byte ptr [6+88h],' '
		mov	ds:byte ptr [0ch+88h],':'
		mov	ds:byte ptr [012h+88h],':'
		pop	dx
		push	dx
		and	dh,00001111b
		add	dh,'0'
		mov	ds:byte ptr [16h+88h],dh
		pop	dx
		and	dh,11110000b
		mov	cl,4
		shr	dx,cl
		add	dh,'0'
		mov	ds:byte ptr [14h+88h],dh
		pop	dx
		push	dx
		and	dx,0000111100001111b
		add	dl,'0'
		mov	ds:byte ptr [10h+88h],dl
		mov	dl,dh
		add	dl,'0'
		mov	ds:byte ptr [0ah+88h],dl
		pop	dx
		push	dx
		and	dx,0000000011110000b
		mov	cl,4
		shr	dx,cl
		add	dx,'0'
		mov	ds:byte ptr [0eh+88h],dl
		pop	dx
		mov	cl,4
		shr	dx,cl
		add	dh,'0'
		mov	ds:byte ptr [8+88h],dh

		pop	ax
		pop	bx
		pop	cx
		pop	dx
		pop	si
		pop	ds
		popf
		jmp	cs:dword ptr OLD_INT1c
NEW_INT1c	ENDP

;----------------------------------------------------------------------------

SUBROUTINES	PROC
OLD_INT1c	DD 0
END_OF_PRG	DB 0
SUBROUTINES	ENDP

INSTALL:	push	cs
		pop	ds
		mov	ax,351ch
		int	21h
		mov	word ptr OLD_INT1c[0],bx
		mov	word ptr OLD_INT1c[2],es
		mov	ax,251ch
		mov	dx,offset NEW_INT1c
		int	21h
		mov	dx,offset END_OF_PRG
		int	27h

CSEG		ENDS
		END	MAIN_START

