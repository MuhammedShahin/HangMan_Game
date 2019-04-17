; Writing Text Colors (WriteColors.asm)
INCLUDE Irvine32.inc
INCLUDE Macros.inc
BUFFER_SIZE = 500
.data
;--------------------------------------------------
startTime DWORD 0
time_message byte " <-- the time you took in this round ",0
;-----------------------------------------------------
;data relate to menu
line Byte "--------------------",0

bar Byte "||",0

menu1 BYTE "--> playGame    "
 BYTE "  HallOfFame    "
 BYTE "  Credit        "
 BYTE "  Exit          ",0

 menu2  BYTE "  playGame      "
 BYTE "--> HallOfFame  "
 BYTE "  Credit        "
 BYTE "  Exit          ",0

 menu3 BYTE "  playGame      "
 BYTE "  HallOfFame    "
 BYTE "--> Credit      "
 BYTE "  Exit          ",0

 menu4 BYTE "  playGame      "
 BYTE "  HallOfFame    "
 BYTE "  Credit        "
 BYTE "--> Exit        ",0

 count_menu dword 0
 index_menu dword 4
 ;-----------------------------------------------------------------

 ;data relate to player
 player_name Byte 50 dup(?),0
 scoure dword 0
 name_lenght dword ?
 ;-----------------------------------------------------------------


 ;data relate to readFile
 buffer BYTE BUFFER_SIZE DUP(?),0
 filename BYTE "file_contains_words.txt",0
 chosen_string byte 50 dup(0),0
 randVal dword ?
 count_delaimeter dword 0 
 fileHandle Handle ?
 ;------------------------------------------------------------------
;read from the Hall of fame file
 hall_of_fame_file_name byte "Hall_of_fame.txt",0
 fileHandle_hall HANDLE ?
 read_Hall BYTE BUFFER_SIZE DUP(?),0
 current_name byte 50 dup(?),0
  count_CONV dword 0
  num_arr byte 20 dup (?),0
  com_num dword 0
  num_arr_count dword 0
  da dword 0
  bool dword 0
  n_read_Hall BYTE BUFFER_SIZE DUP(?),0
  size_n_read_hall dword 0
  stop_n dword 0
  current_name_size dword 0
  current_name_size_old dword 0
  count_hash dword 0
  count_nn dword 0
 ;--------------------------------------------------------
  ;read form the Credits file 
 Credits_file_name byte "Credits.txt",0
 fileHandle_Credits HANDLE ?
 read_Credits BYTE BUFFER_SIZE DUP(?)

 ;-----------------------------------------------------------------------------
            
 outputStr byte lengthof chosen_string dup(?) ,0      ;str output in screen
 char_Used_Arr byte 50 dup(?) ,0                  ;str which char user enter
 char_Used_CH byte ?                              ;char taken from user
 counter_num_of_Trails dword 0                    ;to get # wrong trails 
 num_of_Wrong_Trails dword 0                      ;# wrong trails
 Level_Diff dword ?                               ;# trails user will take ( 5 , 2 )
 string_size dword 0                              ;size of chosen_string
;..................................................................................
 hangman byte "     __________________"
		 byte "    |       _||_       "
		 byte "    |      (____)      "
		 byte "    |      __||__      "
		 byte "    |     /|    |\     "
		 byte "    |    //|    |\\    "
		 byte "    |   // |____| \\   "
		 byte "    |      |    |      "
		 byte "    |      | /\ |      "
		 byte "    |      |/  \|      "









		      ;120											    ;70
welcome	 byte "***      ***    **********    ****         ***    **********    ****              ****    **********    ****         ***"     
		 byte "***      ***   ************   *****        ***   ************   *****            *****   ************   *****        ***"    	 
		 byte "***      ***   ***      ***   ******       ***   ***      ***   ******          ******   ***      ***   ******       ***"    		
		 byte "***      ***   ***      ***   *** ***      ***   ***      ***   *** ***        *** ***   ***      ***   *** ***      ***"    			  
		 byte "***      ***   ***      ***   ***  ***     ***   ***      ***   ***  ***      ***  ***   ***      ***   ***  ***     ***"    						  
		 byte "***      ***   ***      ***   ***   ***    ***   ***            ***   ***    ***   ***   ***      ***   ***   ***    ***"    												  
		 byte "************   ************   ***    ***   ***   ***   ******   ***    ***  ***    ***   ************   ***    ***   ***"    					
		 byte "************   ************   ***     ***  ***   ***   ******   ***     ******     ***   ************   ***     ***  ***"  
		 byte "***      ***   ***      ***   ***      *** ***   ***      ***   ***                ***   ***      ***   ***      *** ***"    					
		 byte "***      ***   ***      ***   ***       ******   ***      ***   ***                ***   ***      ***   ***       ******"    
		 byte "***      ***   ***      ***   ***        *****   ************   ***                ***   ***      ***   ***        *****"
		 byte "***      ***   ***      ***   ***         ****   ************   ***                ***   ***      ***   ***         ****"   	  

 check_hard dword ?
 check_easy dword ?
 level dword ?

.code

main PROC
	call welcome_msg
	call read_data
	call menu
	call cheak_Key
	;call conv_to_int
	ret
main ENDP

 welcome_msg proc
	
	mov ecx, 3
	wL:
		push ecx
		add ecx,10
		mov eax, ecx
		call settextcolor
		mov ecx,12
		mov edi, offset welcome
		welcome_msg_L1:
			push ecx
			mov ecx, 120
			welcome_msg_L2:
				mov al,[edi]
				call writechar
				inc edi
			LOOP welcome_msg_L2
			call crlf
			pop ecx
		LOOP welcome_msg_L1
		mov eax, 1000
		call delay
		call clrscr
		pop ecx
	LOOP wL
	ret
 welcome_msg endp

;----------------------------------------------------------------------
read_data proc	uses edx ecx eax
	
	mov edx,OFFSET filename
	call OpenInputFile
    mov fileHandle,eax

	mov edx,OFFSET buffer
    mov ecx,BUFFER_SIZE

    call ReadFromFile
	

	mov eax,fileHandle
	call CloseFile
	ret
read_data endp
 ;----------------------------------------------------------------------
;return 1 if he pressed arrow and retun 0 otherwise in eax
cheak_Key proc
	L1: ;mov eax,1 ; delay for msg processing
	;;call Delay
	call ReadKey ; wait for a keypress
	jz L1
	cmp al,0
	je men
	cmp al ,13
	je L3
	mWrite <"Press arrow key plz ",0dh,0ah>
	jmp L1
	men:
	call clrscr
	call menu
	jmp L1
	L3: 
	call cheak_select_menu
	ret
cheak_Key endp

draw_line proc ; draw yellow lines.
	; set the color
	mov eax, 14
	call settextcolor
	mov ecx, 2
	menue_L2:
		push ecx
		mov ecx, 20
		mov esi, offset line
		menue_L2_1:
			mov al, [esi]
			call writechar
		
		LOOP menue_L2_1
		add dh,1 
		call Gotoxy
		pop ecx
	LOOP menue_L2
	; reset the color
	mov eax, 7
	call settextcolor 
	ret 
draw_line ENDP


draw_bar proc uses ecx ;draws two yellow bars 
	mov ecx,2
	mov eax, 14
	call settextcolor ; set color
	mov esi, offset bar
	menue_bar:
		mov al, [esi]
		call writechar
	LOOP menue_bar
	mov eax, 7
	call settextcolor  ;reset color
	ret
draw_bar ENDP


;menu function 
menu proc uses edi eax
	mov dh,7 ; row 7
	mov dl,50 ; column 50
	call Gotoxy
	cmp count_menu ,0 ;play
	je men1
	cmp count_menu ,1  ;halloffame
	je men2
	cmp count_menu ,2 ;credit
	je men3
	cmp count_menu ,3 ;Exit
	je men4
	men1:
	mov index_menu, 4
	add count_menu ,1
	mov edi, offset menu1
	jmp code
	men2:
	mov index_menu, 3
	add count_menu ,1
	mov edi, offset menu2
	jmp code
	men3:
	mov index_menu, 2
	add count_menu ,1
	mov edi, offset menu3
	jmp code
	men4:
	mov index_menu, 1
	mov count_menu ,0
	mov edi, offset menu4
	code:

	call draw_line

	mov ecx,4
	L1:
		push ecx
		call draw_bar

		;set the selected item color
		cmp ecx ,index_menu
		jne draw_cont
		mov eax, 12
		call settextcolor
		draw_cont:

		mov ecx,16
		L2:
			mov al, [edi]
			call writechar
			inc edi
		LOOP L2
		call draw_bar
	
		;reset the color
		mov eax,7
		call settextcolor

		add dh,1 
		call Gotoxy
		pop ecx
	LOOP L1

	call draw_line

	mov dl,0
	call Gotoxy
	ret
menu endp
;----------------------------------------------------------------------

Get_Choosen_String PROC	 uses edi esi eax edx ebx ecx

	mov eax, 11
    call RandomRange
	inc eax
    mov randVal, eax
	
	mov edi, offset buffer
	MOV	count_delaimeter, 1
	

	l1:
	    mov al, [edi]				  ;;;;;;;;;;;;;;;;;;;
		cmp al, '#'
		je count
		inc edi
		jmp l1_tany
		count:
		
		mov ebx , randVal
		cmp count_delaimeter, ebx
		je fill_chosen_string
		inc count_delaimeter
		inc edi
		l1_tany:
	jmp l1

	fill_chosen_string:

	mov esi, offset chosen_string
	add edi,1
	fill:
        
		mov al, [edi]

		cmp al, '#'
		je exit_fill
		mov [esi], al
		inc edi
		inc esi

	jmp fill

	exit_fill:
	mov byte ptr[esi],0
	mov edx, offset chosen_string
	;call writestring 
	;call crlf 


	ret
Get_Choosen_String ENDP



playing proc
	P_Again:
	call clrscr
	call Get_Choosen_String
	mov edx , offset chosen_string

	mov eax,Level_Diff
	;;;;;;;;;;;;;;;;;;;
	mov level,eax
	;;;;;;;;;;;;;;;;;;;
	Get_Size:
		mov al , [edx]
		cmp al,0
		je Done
		inc string_size
		inc edx 
	jmp Get_Size

	Done:
	push eax
	mov eax, 10
	call settextcolor ; set the color
	mWrite<"HANGMAN v.0.1",0dh,0ah>
	mov eax, 15
	call settextcolor ; reset the color
	pop eax




	call change_Str
	mov edx , offset outputStr
	call writestring
	call crlf
	call crlf
	call crlf

	push eax
	mov eax, 9
	call settextcolor ; set the color
	mWrite <"Lives Left: ">
	mov eax, 15
	call settextcolor ; reset the color
	pop eax
	mov eax,Level_Diff
	call writedec
	call crlf
	
	mWrite <"You Wrote: ">
	mov edx , offset char_Used_Arr
	call writestring
	call crlf
	call crlf

	mov ebx , offset char_Used_Arr
	;calc the time 
	call GetMseconds
	mov startTime,eax

	L_try_Code:
		call readchar
		mov char_Used_CH , al 

		;Is the char was written before .................

		push ecx
		mov edi, OFFSET char_Used_Arr
		mov al, char_Used_CH
		mov ecx, LENGTHOF char_Used_Arr
		cld
		repne scasb       ; repeat while char not exist
		pop ecx
		jnz CHAR_NOT_FOUND
		call crlf
		mWrite <"You Wrote this character before !! , Write another One ...">
		call crlf
		JMP L_try_Code
		CHAR_NOT_FOUND:

		;.......................................

		mov [ebx] , al 
		inc ebx 
		mov al , ' '
		mov [ebx] , al
		inc ebx

		call clrscr 

		push eax
		mov eax, 10
		call settextcolor ; set the color
		mWrite<"HANGMAN v.0.1",0dh,0ah>
		mov eax, 15
		call settextcolor ; reset the color
		pop eax

		push ecx
		push ebx
		push edi 
		push esi 
		push eax 

		mov al , char_Used_CH
		mov ebx , 0

		call check_Str_Char
		mov edx , offset outputStr
		call writestring
		call crlf
		call crlf


		call check_2_Str_Equal    ;IF THE USER WIN !!
		mov ebx , eax 
		CMP ebx , 1
		je LBreak_WIN

		call crlf
		call crlf

		mov ecx,level
		sub ecx,num_of_Wrong_Trails

		push eax
		mov eax, 9
		call settextcolor ; set the color
		mWrite <"Lives Left: ">
		mov eax, 15
		call settextcolor ; reset the color
		pop eax
	
		mov eax,ecx
		call writedec
		call crlf
		
		mWrite <"You Wrote: ">
	
		mov edx , offset char_Used_Arr
		call writestring
		call crlf
		call crlf

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
		cmp level,2
		je dif
		cmp level,5
		je eas
		dif:
		mov ecx ,num_of_Wrong_Trails
		mov check_hard, ecx     ;check the number of wrong answer if the game mode is difficult
		call hard
		jmp gotoret
		eas:
		mov ecx ,num_of_Wrong_Trails   ;check the number of wrong answer if the game mode is easy
		mov check_easy, ecx
		call easy
		gotoret:
	
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		mov ecx , Level_Diff ;num of wrong trails --> 5 hard   , 2 easy
		cmp ecx , num_of_Wrong_Trails   ;IF THE USER LOSE
		je LBreak_LOSE

		pop eax
		pop esi
		pop edi
		pop ebx
		pop ecx

	JMP L_try_Code

	LBreak_WIN:
	call crlf
	push eax
	mov eax, 10
	call settextcolor
	mWrite <"Congratulation !! You Win :) ">
	mov eax, 15
	call settextcolor
	pop eax
	call crlf
	call GetMseconds
		sub eax,startTime	 
		mov scoure ,eax
		call writedec
		mov edx ,offset time_message
		call writestring
		call crlf
	JMP LBreak
	
	LBreak_LOSE:
	call crlf
	push eax
	mov eax, 4
	call settextcolor
	mWrite <"Badly !! You Lose :(  ">
	mov eax, 15
	call settextcolor
	pop eax
	call GetMseconds
		sub eax,startTime	 
		mov scoure ,eax
		call crlf
		call writedec
		mov edx ,offset time_message
		call writestring
		call crlf

	LBreak:	

	pop eax
	pop esi
	pop edi
	pop ebx
	pop ecx
	
	MOV EDI, offset chosen_string
	MOV EAX, offset char_Used_Arr
	MOV ESI, offset outputStr
	mov ecx, 50
	clear_c_str:
		mov byte ptr [eax],0
		mov byte ptr [edi],0
		mov byte ptr [esi],0
		inc edi
		inc esi
		inc eax
	LOOP clear_c_str

	MOV string_size , 0
	MOV num_of_Wrong_Trails , 0
	MOV counter_num_of_Trails , 0

	push eax
	mov eax, 13
	call settextcolor ; set the color
	mWrite <"Play Anthor Game? (y/n) : ">
	mov eax, 15
	call settextcolor ; reset the color
	pop eax
	call readchar
	cmp al, 'y'
	JE	P_Again
	cmp al, 'Y'
	JE	P_Again

	ret
playing endp

;edi & esi used in offset
;ecx & eax used 
;ret str result in outputStr
change_Str proc
	mov esi , offset chosen_string
	mov edi , offset outputStr

	mov ecx , string_size
	mov eax , 0
	LmoveStr:
		mov al , [esi]
		cmp al , ' '
		je It_Space
		mov al , '_'
		mov [edi] , al
		jmp moveStr_Cont

		It_Space:
		mov al , ' '
		mov [edi] , al
		
		moveStr_Cont:
		inc edi
		inc esi
	LOOP LmoveStr

	ret
change_Str endp


;use ebx reg & edx
;eax -> al : the char which we want search it   Search for (e)
;take the 2 strings in .data (chosen_string , outputStr)
check_Str_Char proc
	mov esi , offset chosen_string
	mov edi , offset outputStr

	mov counter_num_of_Trails , 0

	mov ebx , 0
	mov ecx , string_size  
	Search_Str:
		mov bl , [esi]
		cmp bl , al
		jne Search_Str_Cont
		mov bl , al
		mov [edi] , bl
		jmp NO_Equal
		
		Search_Str_Cont:
		inc counter_num_of_Trails
		NO_Equal:
		inc edi
		inc esi
	LOOP Search_Str

	mov edx , string_size
	cmp edx , counter_num_of_Trails
	jne Choose_Right_Char
	inc num_of_Wrong_Trails

	Choose_Right_Char:

	ret
check_Str_Char endp

;use ebx reg  & eax  (if EAX = 0 SO two strings not equal ELSE EAX = 1 SO two strings mathces)
;take the 2 strings in .data (chosen_string , outputStr)
check_2_Str_Equal proc
	mov esi , offset chosen_string
	mov edi , offset outputStr

	mov ebx , 0
	mov eax , 0
	mov ecx , string_size 
	Check_Str:
		mov bl , [esi]
		mov al , [edi]
		cmp bl , al
		jne NOT_Equal

		inc edi
		inc esi
		LOOP Check_Str

		mov eax , 1
		jmp LEXIT
		
		NOT_Equal:
		mov eax , 0 
		
	LEXIT:

	ret
check_2_Str_Equal endp

;......................................................................................

hard proc
	cmp check_hard,0
	je cont_without_printing
	mov dh,7 ; row 7
	mov dl,50 ; column 50
	call Gotoxy
	mov edi,offset hangman
	push edx
	mov eax,5
	mul check_hard
	mov ecx,eax
	pop edx
	L1:
	push ecx
	mov ecx,23
		L2:
			mov al, [edi]
			call writechar
			inc edi
		loop L2
	add dh,1 
	call Gotoxy
	pop ecx
	loop L1
	cont_without_printing:
	ret
	hard endp

	easy proc
	cmp check_easy,0
	je cont_without_printing
	mov dh,7 ; row 7
	mov dl,50 ; column 50
	call Gotoxy
	mov edi,offset hangman
	push edx
	mov eax,2
	mul check_easy
	mov ecx,eax
	pop edx
	L1:
	push ecx
	mov ecx,23
		L2:
			mov al, [edi]
			call writechar
			inc edi
		loop L2
	add dh,1 
	call Gotoxy
	pop ecx
	loop L1
	cont_without_printing:
	ret
easy endp


play_game PROC uses edx ecx	eax
	Play_game_rep:
		call clrscr
		mWrite <"1.Easy Game.",0dh,0ah>
		mWrite <"2.Hard Game.",0dh,0ah>
		mWrite <"Please Enter the difficulty level : ">
		call readint
		cmp eax,1
		je Easy_level
		cmp eax,2
		je Hard_level
	
	jmp Play_game_rep

	
	Easy_level:
		mWrite <"Please Enter Your Name : ">
		mov ecx, 50
		mov edx, offset player_name
	   	call readstring
		mov name_lenght, eax
		mov Level_Diff,5
		; code elahike
		call clrscr
		call playing
		call Insert_Hall_of_fame
		jmp Exsit_play
	
	Hard_level:
		mWrite <"Please Enter Your Name : ">
		mov ecx, 50
		mov edx, offset player_name
		call readstring
		mov name_lenght, eax
		;call Get_Choosen_String
		; timer of the code since start of the game
		mov Level_Diff,2
		call clrscr
		call playing
		call Insert_Hall_of_fame
	Exsit_play:
	ret
play_game ENDP

;---------------------------------------
;cheak what i selected in the menu
cheak_select_menu proc
	cmp count_menu ,1 ;play
	je pl

	cmp count_menu ,2  ;halloffame
	je hall
	cmp count_menu ,3 ;credit
	je cred
	cmp count_menu ,0 ;Exit
	je exit1
	
	hall:
	call clrscr
	call Hall_of_fame
	jmp exit1

	cred:
	call clrscr
	call Credits
	jmp exit1
	
	pl:
	call play_game

	exit1:
	mWrite <"Exit the program .. ",0dh,0ah>
	exit
	ret
cheak_select_menu endp
;-----------------------------------------------------------------------------
;hall of fame
Hall_of_fame proc uses edx eax 
	mov eax, 9
	call settextcolor
	; Open the hall of fame file for input.
	mov edx,OFFSET hall_of_fame_file_name
	call OpenInputFile
	mov fileHandle_hall,eax
	; Check for errors.
	cmp eax,INVALID_HANDLE_VALUE ; error opening file?
	jne file_ok ; no: skip
	mWrite <"Cannot open file",0dh,0ah>
	jmp quit ; and quit
	file_ok:
	; Read the file into a buffer.
	mov edx,OFFSET read_Hall
	mov ecx,BUFFER_SIZE
	call ReadFromFile
	jnc check_buffer_size ; error reading?
	mWrite "Error reading file. " ; yes: show error message
	call WriteWindowsMsg
	jmp close_file
	check_buffer_size:
	cmp eax,BUFFER_SIZE ; buffer large enough?
	jb buf_size_ok ; yes
	mWrite <"Error: buffer size too small for the file",0dh,0ah>
	jmp quit ; and quit
	buf_size_ok:
	mov read_Hall[eax],0 ; insert null terminator
	;mWrite "File size: "
	;call WriteDec ; display file size
	;call Crlf
	; Display the buffer.
	;mWrite <"Buffer:",0dh,0ah,0dh,0ah>
	mWrite <"Hall of fame",0dh,0ah>
	mov edx,OFFSET read_Hall ; display the buffer
	mov ecx , eax
	view:
	mov al , [edx]
	cmp al ,"#"
	je n
	call writechar
	jmp con
	n:
	call crlf
	inc count_hash
	cmp count_hash , 5
	je close_file
	con:
	inc edx
	loop view
	close_file:
	mov eax,fileHandle_hall
	call CloseFile
	quit:
	mov count_menu ,0
	call menu
	call cheak_Key
	ret
Hall_of_fame endp

;fuction that takes the name and the scote and put them into the score
;-----------------------------------------------------------------------------------
;hall_of_fame_file_name
;fileHandle_hall
;read_Hall
Insert_Hall_of_fame proc
;opens the file
mov edx,OFFSET hall_of_fame_file_name
call OpenInputFile
mov fileHandle_hall,eax
;reads form the file
mov edx,OFFSET read_Hall
mov ecx,BUFFER_SIZE
call ReadFromFile
jnc check_buffer_size ; error reading?
mWrite "Error reading file. " ; yes: show error message
call WriteWindowsMsg
jmp close_file
check_buffer_size:
cmp eax,BUFFER_SIZE ; buffer large enough?
jb cheak_if_empty ; yes
mWrite <"Error: Buffer too small for the file",0dh,0ah>
jmp quit ; and quit
cheak_if_empty:
cmp eax,0
je empty
mov ebx , eax
mov eax,fileHandle_hall
call CloseFile

mov esi,OFFSET read_Hall
mov edi , offset player_name
add edi , name_lenght
add ebx , name_lenght
mov byte ptr[edi] , " "
inc edi
inc ebx

push ebx
mov edx ,0
mov ebx , 1000
mov eax , scoure
div ebx
pop ebx

push_chars:
   mov edx ,0             ; clear edx
    mov ecx, 10           ; ecx is divisor, devide by 10
    div ecx               ; devide edx by ecx, result in eax remainder in edx
    add edx, 30h          ; add 0x30 to edx convert int => ascii
	push edx 
	inc count_CONV
    cmp eax ,0      ; is eax 0?
    jnz push_chars       ; if eax not 0 repeat
	mov ecx ,count_CONV
	RETR:
	pop edx
	mov dword ptr[edi] , edx
	add edi , 1
	inc ebx
	loop RETR
mov byte ptr[edi] , "#"
inc edi
inc ebx
mov ecx , ebx
mov edx , offset n_read_Hall
mov edi , offset player_name
fill_new_buff:
mov al , [edi]
cmp al , "#"
je go_en
mov [edx] , al
inc edi
inc edx
inc count_nn
loop fill_new_buff

go_en:
mov [edx] , al
inc edx

mov ecx , ebx
sub ecx , count_nn
mov edi,OFFSET read_Hall
f:
mov al , [edi]
mov [edx] , al
inc edi
inc edx
loop f

mov edx,OFFSET hall_of_fame_file_name
call CreateOutputFile
mov fileHandle_hall,eax
mov edx , offset n_read_Hall
mov eax,fileHandle_hall
mov ecx,ebx
call WriteToFile
call CloseFile
jmp quit

empty:
call add_in_hall_empty
ret
;mov bytesWritten,eax
close_file:
quit:
ret
Insert_Hall_of_fame endp
;-------------------------------------------------------------------------------------
;add in an empty file
add_in_hall_empty proc
;here should write the code that write one string on the file
mov eax,fileHandle_hall
call CloseFile
push edx
mov edx ,0
mov ebx , 1000
mov eax , scoure
div ebx
pop edx
mov esi , offset player_name
add esi , name_lenght
mov byte ptr[esi] , " "
add esi , 1
add name_lenght , 1
;--------- 
push_chars:
   mov edx ,0             ; clear edx
    mov ecx, 10           ; ecx is divisor, devide by 10
    div ecx               ; devide edx by ecx, result in eax remainder in edx
    add edx, 30h          ; add 0x30 to edx convert int => ascii
	push edx 
	inc count_CONV
    cmp eax ,0      ; is eax 0?
    jnz push_chars       ; if eax not 0 repeat
	mov ecx ,count_CONV
	RETR:
	pop edx
	mov dword ptr[esi] , edx
	add esi , 1
    add name_lenght , 1  
	loop RETR
;---------
mov byte ptr[esi] , "#"
add name_lenght , 1
;---------
mov edx,OFFSET hall_of_fame_file_name
call CreateOutputFile
mov fileHandle_hall,eax
mov edx , offset player_name
mov eax,fileHandle_hall
mov ecx,name_lenght
call WriteToFile
call CloseFile
mov count_CONV ,0
ret
add_in_hall_empty endp

 ;--------------------------------------------------------------------------------------


Credits proc
	; Open the hall of fame file for input.
	mov eax, 14
	call settextcolor
	mov edx,OFFSET Credits_file_name
	call OpenInputFile
	mov fileHandle_Credits,eax
	; Check for errors.
	cmp eax,INVALID_HANDLE_VALUE ; error opening file?
	jne file_ok ; no: skip
	mWrite <"Cannot open file",0dh,0ah>
	jmp quit ; and quit
	file_ok:
	; Read the file into a buffer.
	mov edx,OFFSET read_Credits
	mov ecx,BUFFER_SIZE
	call ReadFromFile
	jnc check_buffer_size ; error reading?
	mWrite "Error reading file. " ; yes: show error message
	call WriteWindowsMsg
	jmp close_file
	check_buffer_size:
	cmp eax,BUFFER_SIZE ; buffer large enough?
	jb buf_size_ok ; yes
	mWrite <"Error: buffer size too small for the file",0dh,0ah>
	jmp quit ; and quit
	buf_size_ok:
	mov read_Credits[eax],0 ; insert null terminator
	;mWrite "File size: "
	;call WriteDec ; display file size
	;call Crlf
	; Display the buffer.
	;mWrite <"Buffer:",0dh,0ah,0dh,0ah>
	mWrite <"Credits",0dh,0ah>
	mov edx,OFFSET read_Credits ; display the buffer
	call WriteString
	call Crlf
	close_file:
	mov eax,fileHandle_Credits
	call CloseFile
	quit:
	mov count_menu ,0
	call menu
	call cheak_Key
	ret
Credits endp

;-----------------------------------------------------------------------------------
;take a string and convert it to int and comp it
conv_to_int proc
mov esi , offset num_arr
mov ecx  ,num_arr_count
dec ecx
mov eax , 1
L:
mov ebx , 10
mul ebx
loop l

mov da , eax

mov ecx  ,num_arr_count
sta:
mov al , [esi]
sub al , 30h
movzx ebx , al
mov eax , ebx

mov ebx , da
mul ebx
add com_num , eax

mov edx , 0
mov eax , da
mov ebx , 10
div ebx

mov da , eax
inc esi
loop sta
ret
conv_to_int endp
;----------------------------------------------------------------------------------
END main
