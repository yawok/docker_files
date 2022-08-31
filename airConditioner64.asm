;macro to print to screen
%macro print 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

;macro to collect user input
%macro input 2
	mov rax, 0
	mov rdi, 0
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro


section .bss
	;variable to store user input
	option resb 3


section .data

	;blank space
	blank times 2 db 10
	len_blank equ $ - blank

	;input indicator
	indi db " ==> "
	len_indi equ $ - indi

	;power off prompt
	powerOff db "Power Off", 10, 10
	len_powerOff equ $ - powerOff

	;general header
	header db "-------------Select Number-------------", 10
	len_header equ $ - header
	
	;option menu prompts
	welcome: db "++++Welcome+++++", 10
	len_welcome equ $ - welcome
	on: db "1. ON", 10
	len_on equ $ - on
	off: db "2. OFF", 10
	len_off equ $ - off

	;main menu
	mode db "1. Select operation mode", 10
	len_mode equ $ - mode
	fanSpeed db "2. Set fan speed", 10
	len_fanSpeed equ $ - fanSpeed
	setTemp db "3. Set temperature", 10
	len_setTemp equ $ - setTemp
	sleep db "4. Set sleep timer", 10
	len_sleep equ $ - sleep
	back db "0. Go back", 10
	len_back equ $ - back

	;mode menu
	cool db "1. Cool mode", 10
	len_cool equ $ - cool
	heat db "2. Heat mode", 10
	len_heat equ $ - heat
	fan db "3. Fan mode", 10
	len_fan equ $ - fan
	dry db "4. Dry mode", 10
	len_dry equ $ - dry
	

	;mode submenu prompts
	;cool
	subCool db "The AC is now blowing cool air.", 10
	len_subCool equ $ - subCool
	
	;heat
	subHeat db "The AC is now blowing warm air.", 10
	len_subHeat equ $ - subHeat
	
	;fan
	subFan db "The AC is now blowing room temperature air.", 10
	len_subFan equ $ - subFan
	
	;dry
	subDry db "The AC is now dehumidifying the room.", 10
	len_subDry equ $ - subDry

	
	;fan speed prompt
	promptLow db "1. Low speed", 10
	len_promptLow equ $ - promptLow
	promptMedium db "2. Medium speed", 10
	len_promptMedium equ $ - promptMedium
	promptHigh db "3. High speed", 10
	len_promptHigh equ $ - promptHigh
	

	;fan speed option
	highSpeed db "The AC fan speed is set to high.", 10
	len_highSpeed equ $ - highSpeed
	mediumSpeed db "The AC fan speed is set to medium.", 10
	len_mediumSpeed equ $ - mediumSpeed
	lowSpeed db "The AC fan speed is set to low", 10
	len_lowSpeed equ $ - lowSpeed
	
	;timer
	promptTimer db "Enter time in minutes: "
	len_promptTimer equ $ - promptTimer 
	outTimer db "The AC will automatically go off after "
	len_outTimer equ $ - outTimer
	outMinutes db " minutes", 10
	len_outMinutes equ $ - outMinutes

	;temperature
	promptTemp db "Enter a desired temperature in degree celsius: "
	len_promptTemp equ $ - promptTemp
	outTemp db "The AC is now blowing air at "
	len_outTemp equ $ - outTemp
	outCelsius db " degree celsius", 10
	len_outCelsius equ $ - outCelsius

	;enter to continue
	cont db "Press ENTER to continue to: "
	len_cont equ $ - cont

	;invalid prompt
	promptInvalid db 10, 10, "*****Invalid input*****", 10
	len_promptInvalid equ $ - promptInvalid



section .text

global _start
_start:
	call _intro

	mov rax, 60
	mov rdi, 0
	syscall

_intro:
	print blank, len_blank
	print welcome, len_welcome
	print on, len_on
	print off, len_off

	;input collection
	print indi, len_indi
	input option, 4
	call  _check
	ret

_check: 
	mov al, [option] 
	;if 1(on), keep running
	cmp al, "1"
	je _mainMenu

	;if 2(off), qiut
	cmp al, "2"
	je _exit
	
	;else
	jmp _invalid

_invalid:
	print promptInvalid, len_promptInvalid
	jmp _intro

_exit:
	print powerOff, len_powerOff	
	mov rax, 60
	mov rdi, 0
	syscall

_mainMenu:
	print blank, len_blank
	print header, len_header
	print mode, len_mode
	print fanSpeed, len_fanSpeed
	print setTemp, len_setTemp
	print sleep, len_sleep
	print back, len_back

	;input collection
	print indi, len_indi
	input option, 2
	;print option, 1
	
	;if statement
	mov al, [option]
	;if 1(mode):
	cmp al, "1"
	je _modeMenu
	
	;else if 2(set fan speed):
	cmp al, "2"
	je _fanSpeed

	;else if 3(set temperature):
	cmp al, "3"
	je _setTemp

	;else if 4(sleep):
	cmp al, "4"
	je _sleep

	;else if 4(back):
	cmp al, "0"
	je _intro

	jmp _invalid

;mode menu and prompts
_modeMenu:
	print header, len_header
	print cool, len_cool
	print heat, len_heat
	print fan, len_fan
	print dry, len_dry
	print back, len_back
	print option, 1

	;input collection
	print indi, len_indi
	input option, 2
	
	mov al, [option]
	;if 1(cool):
	cmp al, "1"
	je _cool
	
	;else if 2(heat):
	cmp al, "2"
	je _heat

	;else if 3(dry):
	cmp al, "3"
	je _fan

	cmp al, "4"
	je _dry

	;else if 0(back):
	cmp al, "0"
	je _mainMenu

	jmp _invalid



_cool:
	print subCool, len_subCool

	;enter to continue prompt
	print cont, len_cont
	
	;input collection
	print indi, len_indi
	input option, 1
	jmp _mainMenu

_heat:
	print subHeat, len_subHeat
	print cont, len_cont

	;input collection
	print indi, len_indi
	input option, 1
	jmp _mainMenu

_fan:
	print subFan, len_subFan
	print cont, len_cont

	;input collection
	print indi, len_indi
	input option, 1
	jmp _mainMenu

_dry:
	print subDry, len_subDry

		;enter to continue prompt
	print cont, len_cont

	;input collection
	print indi, len_indi
	input option, 1
	jmp _mainMenu


;fan speed submenu and prompts
_fanSpeed:
	print header, len_header
	print promptLow, len_promptLow
	print promptMedium, len_promptMedium
	print promptHigh, len_promptHigh
	
	;input collection
	print indi, len_indi
	input option, 2

	mov al, [option]
	;if 1(cool):
	cmp al, "1"
	je _low
	
	;else if 2(heat):
	cmp al, "2"
	je _medium

	;else if 3(dry):
	cmp al, "3"
	je _high

_low:
	print lowSpeed, len_lowSpeed

	;enter to continue prompt
	print cont, len_cont

	;input collection
	print indi, len_indi
	input option, 1
	jmp _mainMenu

_medium:
	print mediumSpeed, len_mediumSpeed
	
	;enter to continue prompt
	print cont, len_cont
	
	;input collection
	print indi, len_indi
	input option, 1
	jmp _mainMenu

_high:
	print highSpeed, len_highSpeed
	
	;enter to continue prompt
	print cont, len_cont

	;input collection
	print indi, len_indi
	input option, 1
	jmp _mainMenu


;set temperature 
_setTemp:
	print promptTemp, len_promptTemp

	;input collection
	print indi, len_indi
	input option, 3

	print outTemp, len_outTemp
	print option, 2
	print outCelsius, len_outCelsius

	;enter to continue prompt
	print cont, len_cont
	
	;input collection
	print indi, len_indi
	input option, 1
	
	;back to main menu
	jmp _mainMenu


;set sleep timer
_sleep:
	print promptTimer, len_promptTimer

	;input collection
	print indi, len_indi
	input option, 3

	print outTimer, len_outTimer
	print option, 2
	print outMinutes, len_outMinutes

	;enter to continue prompt
	print cont, len_cont
	
	;input collection
	print indi, len_indi
	input option, 1
	
	;back to main menu
	jmp _mainMenu


