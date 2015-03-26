	.386
	.model flat,stdcall
	option casemap:none
	include \masm32\include\windows.inc
	include \masm32\include\user32.inc
	include \masm32\include\kernel32.inc
	include \masm32\include\gdi32.inc
	include \masm32\include\comdlg32.inc
	include \masm32\include\shell32.inc
	include \mbuilder\baumanets\baumanets.inc
	include rand.inc
	includelib \masm32\lib\user32.lib
	includelib \masm32\lib\kernel32.lib
	includelib \masm32\lib\gdi32.lib
	includelib \masm32\lib\comdlg32.lib
	includelib \masm32\lib\shell32.lib
	includelib c:\mbuilder\baumanets\baumanets.lib
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
RGB macro red,green,blue
	xor		eax,eax
	mov		ah,blue
	shl		eax,8
	mov		ah,green
	mov		al,red
endm
szText MACRO Name,Text:VARARG
	LOCAL	lbl
	jmp		lbl
	Name	db Text,0
	lbl:
ENDM
.const
Button1ID		equ 3
Edit2ID			equ 2
Edit1ID			equ 1
.data?
hwndButton1		HWND ?
hwndEdit2		HWND ?
hwndEdit1		HWND ?
hInstance		HINSTANCE ?
CommandLine		LPSTR ?
 
.data
TextButton1		db "Button1",0
TextEdit2		db "10",0
TextEdit1		db "1",0
;_______________
ClassName		db "mbuilder",0
BtnClName		db "button",0
StatClName		db "static",0
EditClName		db "edit",0
LboxClName		db "listbox",0
CboxClName		db "combobox",0
ReditClName		db "richedit",0
RichEditLib		db "riched32.dll",0
FormCaption		db "Form",0
number         dd 0
numberstr      db "%d",0
szbuffer       db 128 dup(0)
rand_seed	   db 0


;_______________
.code
start:
	invoke	GetModuleHandle,NULL
	mov		hInstance,eax
	invoke	GetCommandLine
	invoke	WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
	invoke	ExitProcess,eax
WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
LOCAL wc	:WNDCLASSEX
LOCAL msg 	:MSG
LOCAL hwnd	:HWND
	mov		wc.cbSize,SIZEOF WNDCLASSEX
	mov		wc.style,CS_BYTEALIGNCLIENT
	mov		wc.lpfnWndProc,offset WndProc
	mov		wc.cbClsExtra,NULL
	mov		wc.cbWndExtra,NULL
	push	hInst
	pop		wc.hInstance
	mov		wc.hbrBackground,COLOR_BTNFACE+1
	mov		wc.lpszClassName,OFFSET ClassName
	invoke	LoadIcon,NULL,IDI_APPLICATION
	mov		wc.hIcon,eax
	mov		wc.hIconSm,eax
	invoke	LoadCursor,NULL,IDC_ARROW
	mov		wc.hCursor,eax
	invoke	RegisterClassEx,addr wc
invoke CreateWindowEx,0,ADDR ClassName,ADDR FormCaption,WS_SYSMENU or WS_SIZEBOX,645,45,248,173,0,0,hInst,0
	mov		hwnd,eax
	INVOKE	ShowWindow,hwnd,SW_SHOWNORMAL
	INVOKE	UpdateWindow,hwnd
	;------------------------------------------------
	invoke GetTickCount
	
	;imul	eax,00019660Dh		
	;add		eax,03C6EF35Fh
	;mov ecx, 0FFFF0000h
	;xor eax ,ecx
	;mov MC, eax
		;------------------------------------------------
	.WHILE TRUE
		invoke	GetMessage,ADDR msg,0,0,0
		.BREAK .IF (!eax)
		invoke	TranslateMessage,ADDR msg
		invoke	DispatchMessage,ADDR msg
	.ENDW
 	mov	eax,msg.wParam
	ret
WinMain endp
WndProc proc hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	.IF uMsg == WM_DESTROY
		invoke	PostQuitMessage,NULL
	.ELSEIF uMsg == WM_CREATE
invoke CreateWindowEx,0,ADDR BtnClName,ADDR TextButton1,WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE,88,112,75,25,hWnd,Button1ID,hInstance,0
		mov		hwndButton1,eax
invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR EditClName,ADDR TextEdit2,WS_CHILD or ES_LEFT or ES_AUTOHSCROLL or WS_VISIBLE,64,64,121,24,hWnd,Edit2ID,hInstance,0
		mov		hwndEdit2,eax
invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR EditClName,ADDR TextEdit1,WS_CHILD or ES_LEFT or ES_AUTOHSCROLL or WS_VISIBLE,64,32,121,24,hWnd,Edit1ID,hInstance,0
		mov		hwndEdit1,eax
	.ELSEIF uMsg == WM_COMMAND
		mov	eax,wParam
		.IF lParam != 0
			.IF ax == Button1ID
				shr eax,16
				.IF ax == BN_CLICKED
					;call Randomize
					invoke  GetDlgItemInt,hWnd,Edit1ID,0,1
					mov number, eax
					invoke  GetDlgItemInt,hWnd,Edit2ID,0,1
					sub eax, number
					push eax
					call RandM
					add eax, number
					invoke  wsprintf,addr szbuffer,addr numberstr,eax
					invoke MessageBox,hWnd,addr szbuffer,0,MB_ICONINFORMATION
				.ENDIF
			.ENDIF
		.ENDIF
	.ELSE
		invoke	DefWindowProc,hWnd,uMsg,wParam,lParam
		ret
	.ENDIF
	xor		eax,eax
	ret
WndProc endp
	
end start
