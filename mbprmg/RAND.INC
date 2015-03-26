;Makoto Matsumoto and Takuji Nishimura
;psuedorandom number generating algorithm
;copyright 1997, matumoto@math.keio.ac.jp
;http://www.math.keio.ac.jp/matumoto/eMT.html

;This version is for MASM v6.

;These functions do not preserve the values in the registers.
;They can easily be modified to do that.

;Randomize proto Seed:DWORD  ;Changes the seed for Rand
;RandM     proto Max :DWORD  ;Generates a number on [0,Max-1]
;Rand      proto             ;Generates a number on [0,2^32-1]

.const
N                equ 6343;equ 634
M                equ 397
TEMPERING_MASK_B equ 9d2c5680h
TEMPERING_MASK_C equ 0efc60000h
UM               equ 80000000h
LM               equ 7fffffffh

.data
MTI       dd (N+1)
MC        dd 69069
MATRIX    dd 0
          dd 9908b0dfh

.data?
MT dd 2496 dup(?)

.code
Randomize::
lea edi,MT
mov eax,[esp+4]
mov [edi],eax
mov ecx,N
add edi,4
@R: mul MC
    stosd
    dec ecx
    jnz @R
mov MTI,N
ret 4

RandM::
push 0
lea edi,MT
cmp MTI,N
jb @XA
    cmp MTI,N+1
    jnz @RA
        push 4357
        call Randomize
@RA:mov esi,edi
@SA:    mov eax,[esi]
        and eax,UM
        mov ebx,[esi+4]
        and ebx,LM
        or eax,ebx
        mov ecx,eax
        shr eax,1
        mov edx,esi
        add edx,(M*4)
        mov ebx,[edx]
        xor eax,ebx
        and ecx,1
        xor eax,MATRIX[ecx*4]
        mov [esi],eax
        add esi,4
        inc DWORD PTR[esp]
        cmp DWORD PTR[esp],(N-M)
        jnz @SA

@UA:    mov eax,[esi]
        and eax,UM
        mov ebx,[esi+4]
        and ebx,LM
        or eax,ebx
        mov ecx,eax
        shr eax,1
        mov edx,esi
        add edx,((M-N)*4)
        mov ebx,[edx]
        xor eax,ebx
        and ecx,1
        xor eax,MATRIX[ecx*4]
        mov [esi],eax
        add esi,4
        inc DWORD PTR[esp]
        cmp DWORD PTR[esp],(N-1)
        jnz @UA

    mov edx,edi
    add edx,(M-1)*4
    mov ebx,[edx]
    xor eax,ebx
    and ecx,1
    xor eax,MATRIX[ecx*4]
    mov [esi],eax
    mov MTI,0
@XA::
mov esi,edi
mov eax,MTI
inc MTI
shl eax,2
add esi,eax
mov eax,[esi]
mov ebx,eax
shr eax,11
xor ebx,eax
mov eax,ebx
shl eax,7
and eax,TEMPERING_MASK_B
xor ebx,eax
mov eax,ebx
shl eax,15
and eax,TEMPERING_MASK_C
xor ebx,eax
mov eax,ebx
shr eax,18
xor eax,ebx
xor edx,edx
div DWORD PTR[esp+8]
mov eax,edx
pop ebx
ret 4

Rand::
push 0
lea edi,MT
cmp MTI,N
jb @XB
    cmp MTI,N+1
    jnz @RB
        push 4357
        call Randomize
@RB:mov esi,edi
@SB:    mov eax,[esi]
        and eax,UM
        mov ebx,[esi+4]
        and ebx,LM
        or eax,ebx
        mov ecx,eax
        shr eax,1
        mov edx,esi
        add edx,(M*4)
        mov ebx,[edx]
        xor eax,ebx
        and ecx,1
        xor eax,MATRIX[ecx*4]
        mov [esi],eax
        add esi,4
        inc DWORD PTR[esp]
        cmp DWORD PTR[esp],(N-M)
        jnz @SB

@UB:    mov eax,[esi]
        and eax,UM
        mov ebx,[esi+4]
        and ebx,LM
        or eax,ebx
        mov ecx,eax
        shr eax,1
        mov edx,esi
        add edx,((M-N)*4)
        mov ebx,[edx]
        xor eax,ebx
        and ecx,1
        xor eax,MATRIX[ecx*4]
        mov [esi],eax
        add esi,4
        inc DWORD PTR[esp]
        cmp DWORD PTR[esp],(N-1)
        jnz @UB

    mov edx,edi
    add edx,(M-1)*4
    mov ebx,[edx]
    xor eax,ebx
    and ecx,1
    xor eax,MATRIX[ecx*4]
    mov [esi],eax
    mov MTI,0
@XB::
mov esi,edi
mov eax,MTI
inc MTI
shl eax,2
add esi,eax
mov eax,[esi]
mov ebx,eax
shr eax,11
xor ebx,eax
mov eax,ebx
shl eax,7
and eax,TEMPERING_MASK_B
xor ebx,eax
mov eax,ebx
shl eax,15
and eax,TEMPERING_MASK_C
xor ebx,eax
mov eax,ebx
shr eax,18
xor eax,ebx
pop ebx
ret
