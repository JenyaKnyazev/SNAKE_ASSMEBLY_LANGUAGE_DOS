STA SEGMENT STACK
	DB 100H DUP(0)
STA ENDS
CODE SEGMENT 
	ASSUME CS:CODE,DS:CODE,SS:STA
MAIN:
	MOV AX,CODE
	MOV DS,AX
	FOOD_ROW DB 10
	FOOD_COL DB 10
	HROW DB 0
	HCOL DB 0
	MOV AL,40H	;DIRACTION
	MOV BX,4 	;LEN SNAKE
	MOV SI,0 ;ROWS
	MOV DI,20H ;COLS
	;KEYBORDS 1 AND 2 FOR MOVING SNAKE LEFT AND RIGHT
	;CLEAR SCREEN
	MOV DH,0;UP TO 24 ROWS 
	MOV DL,0 ;UP TO 79 COLS
	MOV AH,2
	CLEAR:
		MOV DL,0
		CLEAR_SCREEN:
			INT 10H
			MOV CL,DL
			MOV DL,' '
			INT 21H
			MOV DL,CL
			INC DL
			CMP DL,79
			JNG CLEAR_SCREEN
		INC DH
		CMP DH,24
		JNG CLEAR
	;PUT SNAKE ON THE MIDDLE AND INIT THE POINTERS
	MOV DH,12
	MOV DL,37
	MOV CX,3
	RUN:
		INT 10H
		MOV BH,DL
		MOV DL,'o'
		INT 21H
		MOV DL,BH
		MOV BH,0
		MOV [SI],DH
		MOV [DI],DL
		INC SI
		INC DI
		INC DL
		LOOP RUN
	INT 10H
	MOV BH,DL
	MOV DL,'O'
	INT 21H
	MOV DL,BH
	MOV BH,0
	MOV [SI],DH
	MOV [DI],DL
	INC SI
	INC DI
	SUB SI,BX
	SUB DI,BX
	MOV DH,FOOD_ROW
	MOV DL,FOOD_COL
	INT 10H
	MOV DL,'F'
	INT 21H
	MOV AL,40H
	;GAME
	GAME:
		MOV DX,5H
		DELAY2:
			MOV CX,0FFFFH
			DELAY:LOOP DELAY
			DEC DX
			JNZ DELAY2
		MOV BH,AL
		MOV AH,0BH
		INT 21H
		CMP AL,0FFH
		JNE NEXT2
		MOV AH,7
		INT 21H
		CMP AL,'2'
		JNE NEXT
		ROR BH,1
		ROR BH,1
		JMP NEXT2
		NEXT:
		CMP AL,'1'
		JNE NEXT2
		ROL BH,1
		ROL BH,1
		NEXT2:
		MOV AL,BH
		MOV BH,0
		MOV CL,[SI+BX-1]
		MOV CH,[DI+BX-1]
		MOV [SI+BX],CL
		MOV [DI+BX],CH
		CMP AL,40H
		JNE NEXT3
		INC BYTE PTR[DI+BX]
		JMP NEXT6
		NEXT3:
		CMP AL,10H
		JNE NEXT4
		INC BYTE PTR[SI+BX]
		JMP NEXT6
		NEXT4:
		CMP AL,04H
		JNE NEXT5
		DEC BYTE PTR[DI+BX]
		JMP NEXT6
		NEXT5:
		CMP AL,01H
		JNE NEXT6
		DEC BYTE PTR[SI+BX]
		NEXT6:
		CMP BYTE PTR[SI+BX],25
		JL NEXT7
		MOV BYTE PTR[SI+BX],0
		NEXT7:
		CMP BYTE PTR[SI+BX],0
		JGE NEXT8
		MOV BYTE PTR[SI+BX],24
		NEXT8:
		CMP BYTE PTR[DI+BX],80
		JL NEXT9
		MOV BYTE PTR[DI+BX],0
		NEXT9:
		CMP BYTE PTR[DI+BX],0
		JGE NEXT10
		MOV BYTE PTR[DI+BX],79
		NEXT10:
		MOV AH,2
		MOV CH,AL
		MOV DH,[SI+BX]
		MOV DL,[DI+BX]
		INT 10H
		MOV DL,'O'
		INT 21H
		MOV DH,[SI+BX-1]
		MOV DL,[DI+BX-1]
		INT 10H
		MOV DL,'o'
		INT 21H
		MOV AL,FOOD_ROW
		CMP [SI+BX],AL
		JNE NEXT11
		MOV AL,FOOD_COL
		CMP [DI+BX],AL
		JNE NEXT11
		INC BX
		GENERATE_FOOD:
		MOV BH,CH
		MOV AH,2H
		MOV DX,0
		INT 1AH
		AND DH,18H
		MOV FOOD_ROW,DH
		MOV AH,2H
		MOV DX,0
		INT 1AH
		AND DH,4FH
		MOV FOOD_COL,DH
		MOV AL,BH
		MOV DX,0
		MOV CH,BH
		MOV BH,0
		CHECK:
			MOV AL,FOOD_ROW
			CMP [SI],AL
			JNE NEXT_CHECK
			MOV AL,FOOD_COL
			CMP [DI],AL
			JNE NEXT_CHECK
			SUB SI,DX
			SUB DI,DX
			JMP GENERATE_FOOD
			NEXT_CHECK:
			INC SI
			INC DI
			INC DX
			CMP DX,BX
			JNG CHECK
		SUB SI,DX
		SUB DI,DX
		MOV AH,2
		MOV DH,FOOD_ROW
		MOV DL,FOOD_COL
		INT 10H
		MOV DL,'F'
		INT 21H
		MOV AL,CH
		CMP BX,10
		JL GAME2
		MOV AH,2
		MOV DL,37
		MOV DH,12
		INT 10H
		MOV DL,'W'
		INT 21H
		MOV DL,'I'
		INT 21H
		MOV DL,'N'
		INT 21H
		JMP FINISH
		NEXT11:
		MOV DH,[SI]
		MOV DL,[DI]
		INT 10H
		MOV DL,' '
		INT 21H
		MOV AL,CH
		MOV CX,BX
		REFRESH:
			MOV AH,[SI+1]
			MOV [SI],AH
			MOV AH,[DI+1]
			MOV [DI],AH
			INC SI
			INC DI
			LOOP REFRESH
		SUB SI,BX
		SUB DI,BX
		GAME2:
		JMP GAME
	FINISH:
	MOV AH,4CH
	INT 21H
CODE ENDS
END MAIN