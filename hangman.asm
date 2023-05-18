[org 0x0100]
jmp start

feet:
pusha
mov cx,5
mov ah,0x70
mov al,'^'
push di
diag1:
std
rep stosw
pop di
cld
add di,2
mov cx,4
rep stosw





popa
ret


hand:
pusha
mov cx,5
mov ah,0x70
mov al,'^'
push di
diag:
std
rep stosw
pop di
cld
add di,2
mov cx,4
rep stosw





popa
ret


body:
pusha
mov di,1566
mov cx,6
mov ah,0x70
mov al,'^'
bodyl:
stosw
add di,158
loop bodyl
popa
ret


head:
pusha

mov di,930
mov ah,0x70
mov al,'*'
mov [es:di], ax


mov di,758
mov cx,9
mov ah,0x70
mov al,'^'
rep stosw
mov cx,3
add di,158

mov al,'^'
head1:
stosw
add di,158
loop head1
std
mov al,'^'
mov cx,9
rep stosw
cld
mov cx,3
sub di,158
mov al,'^'
head2:
stosw
sub di,162
loop head2

mov di,1244
mov ah,0x70
mov al,'-'
mov [es:di], ax
mov di,1246
mov ah,0x70
mov al,'-'
mov [es:di], ax
mov di,1248
mov ah,0x70
mov al,'-'
mov [es:di], ax




mov di,922
mov ah,0x70
mov al,'*'
mov [es:di], ax


popa





ret



clearscreen:
pusha
mov di,540
mov ax,0x7020
mov cx,4000
rep stosw
popa
ret


delayforend:
pusha
mov bp,2000
mov dx,1000
first:
mov dx,1000
second:
dec dx
jnz second
dec bp
jnz first
popa
ret

heading:
mov si,spacedesc
mov di,1990
mov ah,0x70
mov cx,20
loo:
lodsb
stosw
loop loo



mov cx,[headlen]
dec cx
mov ah,0x07
mov di,0
mov si,headline
headloop:
lodsb
stosw
cmp cx,67
jne next
mov di,484
next:
loop headloop



pressspace:
mov ah,0
int 0x16
cmp al,0x20
jne pressspace






ret













ret



clear:
pusha
mov ax,0x7020
mov cx,2000
mov di,0
rep stosw
popa
ret




blankspace:
pusha

mov ah,0x72
mov al,'_'
mov di,1950
mov dx,4
spacel:
mov cx,4
rep stosw
add di,10
dec dx
jnz spacel

popa
ret

fillchar1:
pusha
mov di,1952
mov word[es:di],ax


popa
ret

fillchar2:
pusha
mov di,1970
mov word[es:di],ax


popa
ret


fillchar3:

pusha
mov di,1988
mov word[es:di],ax


popa
ret

fillchar4:
pusha
mov di,2006
mov word[es:di],ax


popa
ret



start:



mov cx,4
mov ax,0xb800
mov es,ax

call clear
call heading
call clear
call blankspace
mov ah,0x70
mov si,pointsdesc
mov di,228
mov cx,[pointssize]


pointsloop:
lodsb
stosw
loop pointsloop

mov bl,[points]
mov bh,0x70

add bl,48 
mov word[es:244],bx
mov cx,4
mov si,word1
mov di,arr1
mov bp,0

mov si,word1
mov ah,0x07
lodsb
mov byte[di],1
call fillchar1
 

inc bp
mov byte[di+bp],1
lodsb
call fillchar2


add bp,2
mov byte[di+bp],1
add si,1
lodsb
call fillchar4
mov si,word1


l16:
mov bp,0
mov cx,4
mov ah,0
int 0x16
mov ah,0x07


l1:
cmp al,[si+bp]
jne goagain
mov di,arr1
cmp byte[di+bp],0
jne goagain
mov byte[di+bp],1
cmp bp,0
jne nopr1
call fillchar1


inc word[correct]
mov word[temp],1
jmp nomatch


nopr1:

cmp bp,1
jne nopr2
call fillchar2

inc word[correct]
mov word[temp],1
jmp nomatch


nopr2:

cmp bp,2
jne nopr3
call fillchar3

inc word[correct]
mov word[temp],1
jmp nomatch


nopr3:

cmp bp,3
jne goagain
call fillchar4

inc word[correct]
mov word[temp],1
jmp nomatch


goagain:



inc bp
loop l1



cmp word[temp],0
jne nomatch
dec word[attempts]
cmp word[attempts],3
jne move1
call head
jmp nomatch

move1:
cmp word[attempts],2
jne move2

mov di,1726
call hand






jmp nomatch

move2:
cmp word[attempts],1
jne move3
mov di,1568
call body
jmp nomatch

move3:
cmp word[attempts],0
jne nomatch
mov di,2366
call feet
call delayforend
call clearscreen

mov si,end
mov di,540
mov ah,0x70
mov cx,[endsize]
gameloop:
lodsb
stosw
loop gameloop
mov si,end2
mov cx,[end2size]
mov di,700
printdescc:
lodsb
stosw
loop printdescc
inf3:
mov ah,0
int 0x16
cmp al,27
jne inf3

mov ax,0x4c00
int 21h








nomatch:
cmp word[correct],4
je forward
mov word[temp],0
jmp l16
forward:
pusha
mov cx,4
mov bp,0
mov di,arr1
clearloop:
mov byte[di+bp],0
inc bp
loop clearloop
popa
mov bp,0
push bp
push ax
inc word[total]
inc byte[points]
mov al,[points]
mov ah,0x70
add al,0x30
mov word[es:244],ax
mov al,'0'
mov word[es:246],ax
mov word[correct],0
pop ax
pop bp
call blankspace
cmp word[total],1
jne move12
mov si,word2
mov di,arr1
mov byte[di],1
lodsb
call fillchar1
add bp,3
mov byte[di+bp],1
add si,2
lodsb
call fillchar4
mov word[correct],2
mov si,word2
jmp lol
move12:
cmp word[total],2
jne move21
mov si,word3
mov di,arr1
inc bp
mov word[correct],1
mov byte[di+bp],1
add si,bp
lodsb
call fillchar2
mov si,word3
move21:
cmp word[total],3
jne lol
mov word[correct],0
mov si,word4
lol:
cmp word[total],4
je exit
mov word[temp],0
jmp l16

exit:
cmp word[total],4
jne z
call delayforend
call clearscreen
mov si,won
mov cx,[wonsize]
mov di,540
mov ah,0x70
wonloop:
lodsb
stosw
loop wonloop

inf4:
mov ah,0
int 0x16
cmp al,27
jne inf4

z:
mov ax,0x4c00
int 21h


points: db 0
pointsdesc: db 'Points:'
pointssize: dw 7
end: db 'You Lost, The End'
end2: db 'No More attempts'
end2size: dw 16
won: db 'Victory!!!'
wonsize: dw 10
endsize: dw 17
spacedesc: db 'Enter Space to Start'
presslen: dw 20
headline: db 'HANGMAN Guidelines: Complete the game by guessing words before 4 attempts'
headlen: dw 74
word1: db 'cola',0
arr1: db 0,0,0,0
len1: dw 4
word2: db 'soda',0
len2: dw 4
word3: db 'book',0
len3: dw 4
word4: db 'hook',0
len4: dw 4
total: dw 0
correct: dw 3
attempts: dw 4
temp: dw 0

