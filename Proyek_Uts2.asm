;@2020
;AUTHOR     : - ARIEF SAFERMAN          < TEKNIK KOMPUTER - 1806148656 - 2B>
;             - ALI BAGIR               < TEKNIK KOMPUTER - 1806200425 - 2B>
;             - BRYAN OLIVER            < TEKNIK KOMPUTER - 1806200305 - 2B>
;             - DIO FAJRIE FADLULLAH    < TEKNIK KOMPUTER - 1806200324 - 2B>
;KELOMPOK   : 2B 
;TEMA       : GAME SPACE IMPACT
;_____________________________________________________________________________________________________________________________________________________________________
;SKENARIO   : 1. USER AKAN DIBERIKAN POST PLAYER DAN MUSUH YANG BERGERAK SECARA VERTIKAL DALAM 10 LEVEL 
;             2. USER MENEMBAK MUSUH DENGAN SPACEBAR UNTUK MENEMBAKAN ARROW DAN USER JUGA DAPAT MENGGERAKAN PESAWATNYA DENGAN CARA PANAH KE ATAS DAN KEBAWAH
;             3. DALAM SETIAP LEVEL MUSUH AKAN BERGERAK SEMAKIN CEPAT 
;             4. GAME AKAN BERAKHIR APABILA TELAH MELALUI SELESAI 10 LEVEL ATAU 10X MISS 
;_____________________________________________________________________________________________________________________________________________________________________  
;
;
;          SPACE IMPACT GAMES is a game that need speed, accuracy, and patient to win the game.
;          
;           Copyright <C> 2020 ARIEF SAFERMAN, ALI BAGIR, BRYAN OLIVER, DIO FAJRIE FADLULLAH 
;
;            This program is free software; you can redistribute it and/or modify 
;            it under the terms of the GNU General Public License as pubslihed by 
;            the Free Software Foundation; either version 3 of the License, or
;            <at your option> any later version.
;
;            This program is distributed in the hope that it will be useful,
;            but WITHOUT ANY WARRANTY; without even the implied warranty of 
;            MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
;            GNU General Public License for more details.
;
;______________________________________________________________________________________________________________________________________________________________________ 
;PREFERENCE :   1. https://github.com/timotei/Space-Invaders-Clone
;               2. https://github.com/timotei/Space-Invaders-Clone/blob/master/spacein.asm
;______________________________________________________________________________________________________________________________________________________________________

.model small
.data

exit db 0
user_pos dw 1760d                          ;first position of user plane  

bullet_pos dw 0d                             ;position of bullet plane  
bullet_status db 0d                          ;status of our bullet plane whether it ready or not  
bullet_limit dw  22d     ;150d               ;area when bullet is miss from screen 

enemy_pos dw 3860d       ;3990d
enemy_status db 0d
         
                                            ;to direct the position of the plane  
                                            ;up=8, down=2
direction db 0d

final_score db '00:0:0:0:0:0:00:00:00:0:0:0:0:0:0:00$'          ;score 
hit_num db 0d
hits  dw 0d
miss  dw 0d
level dw 1d  

game_over_str dw '  ',0ah,0dh
dw '                             |               |',0ah,0dh
dw '                             |---------------|',0ah,0dh
dw '                             |^ Hasil Akhir ^|',0ah,0dh
dw '                             |_______________|',0ah,0dh
dw ' ',0ah,0dh 
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw '                                Game Over',0ah,0dh
dw '                        Press Enter to start again$',0ah,0dh 


game_start_str dw '  ',0ah,0dh

dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw '                ====================================================',0ah,0dh
dw '               ||                                                  ||',0ah,0dh                                        
dw '               ||            *****Space Impact Games*****          ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||--------------------------------------------------||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||          Use up and down key to move player      ||',0ah,0dh
dw '               ||               and space button to shoot          ||',0ah,0dh          
dw '               ||                  Press Enter to start            ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh 
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '                ====================================================',0ah,0dh
dw '$',0ah,0dh




.code
main proc
mov ax,@data    ; getting all of the data                          
mov ds,ax

mov ax, 0B800h
mov es,ax        ;as a cursor for plane's user 



jmp game_menu                              ;show game menu

                                                                   
main_loop:                                 ;main logic
                                           
 
    
    mov ah,1h
    int 16h                                ;checking press keybord 
    jnz key_pressed
    jmp inside_loop                        ;jump to move the bullet, the plane, and the enemy 
    
    inside_loop:                           ;checking all position 
        
        cmp miss,9                         ;if we miss enemy 10 times, we lose 
        jge game_over
        
        mov dx,bullet_pos                   ;checking coalition between bullet and enemy 
        cmp dx, enemy_pos
        je hit
        
        cmp direction,8d                   ;going up
        je player_up
        cmp direction,2d                   ;going down
        je player_down
        
        mov dx,bullet_limit                ;check for distance of bullet
        cmp bullet_pos,dx
        jge hide_bullet                   ;erase the last position of bullet 
        
        cmp enemy_pos, 0d                   ;if the eney pos equal to 0 then we add miss +1
        jle miss_enemy
        jne render_enemy
         
    
        hit:                               
            mov ah,2
            mov dx, 7d
            int 21h 
            
            inc hits                       ;update final_score 
            inc level
            
            lea bx,final_score               ;display final_score
            call show_score 
            lea dx,final_score
            mov ah,09h
            int 21h
            
            mov ah,2                       
            mov dl, 0dh
            int 21h    
            
            jmp fire_enemy                  ;show up new enemy if miss/hit added +1
    
        render_enemy:                       ;show the enemy
            mov cl, ' '                    ;erase the past enemy 
            mov ch, 1111b
        
            mov bx,enemy_pos 
            mov es:[bx], cx
      
            cmp level,32h
            je  level2
            cmp level,33h
            je  level3
            cmp level,34h
            je  level4
            cmp level,35h
            je  level5
            cmp level,36h
            je  level6
            cmp level,37h
            je  level7
            cmp level,38h
            je  level8
            cmp level,39h
            je  level9
          
        
          
            sub enemy_pos,160d              ;move the enemy pos to up
            mov cl, 3d
            mov ch, 1101b 
            jmp lanjut
            
        level2:                              ;
            sub enemy_pos,240d               ;
            mov cl, 3d                       ;
            mov ch, 1101b                    ;
            jmp lanjut                       ;
                                             ;
        level3:                              ;
            sub enemy_pos,320d               ;
            mov cl, 3d                       ;
            mov ch, 1101b                    ;
            jmp lanjut                       ;
                                             ;
        level4:
            sub enemy_pos,400d               ;
            mov cl, 3d                      ;
            mov ch, 1101b                   ;
            jmp lanjut                      ;
                                             ;
        level5:                               ;
            sub enemy_pos,480d                 ;
            mov cl, 3d                          ;
            mov ch, 1101b                        ;
            jmp lanjut                            ;
                                                   ;
        level6:                                     ;
            sub enemy_pos,560d                       ;                        CHECKING LEVEL
            mov cl, 3d                               ;                                
            mov ch, 1101b                             ;                          
            jmp lanjut                                 ;
                                                        ;
        level7:                                          ;
            sub enemy_pos,640d                            ;
            mov cl, 3d                                     ;
            mov ch, 1101b                                   ;
            jmp lanjut                                       ;
                                                              ;
        level8:                                                ;
            sub enemy_pos,720d                                  ;
            mov cl, 3d                                           ;
            mov ch, 1101b                                         ;
            jmp lanjut                                             ;
                                                                    ;
        level9:                                                      ;
            sub enemy_pos,900d                                        ;
            mov cl, 3d                                                 ;
            mov ch, 1101b                                               ;
            jmp lanjut                                                   ;
                                                                          ;
       ; level10:                                                           ;
        ;    sub enemy_pos,940d                                              ;
         ;   mov cl, 3d                                                       ;
          ;  mov ch, 1101b                                                     ;
           ; jmp lanjut                                                         ;;
                                                                                 ;
        lanjut:                                                                   ;
            mov bx,enemy_pos                                                       ;
            mov es:[bx], cx                                                         ;
                                                                                     ;
            cmp bullet_status,1d          ;check bullet pos
            je render_bullet
            jne inside_loop2 
        
        render_bullet:               ;render bullet
        
            mov cl, ' '
            mov ch, 1111b
        
            mov bx,bullet_pos    ;erase last bullet pos
            mov es:[bx], cx
                
            add bullet_pos,4d          ;draw the new bullet 
            mov cl, 16d
            mov ch, 1111b
        
            mov bx,bullet_pos
            mov es:[bx], cx
        
        inside_loop2:
            
            mov cl, 219d                  ;User plane 
            mov ch, 1100b
            
            mov bx,user_pos 
            mov es:[bx], cx
            
             
                       
    cmp exit,0
    je main_loop                          ;end game 
    jmp exit_game
 
jmp inside_loop2
    
player_up:                                ;merase user plane last position
    mov cl, ' '
    mov ch, 1111b
        
    mov bx,user_pos 
    mov es:[bx], cx
    
    sub user_pos, 160d                  ;draw the new user plane position to up
    mov direction, 0    

    jmp inside_loop2                      ;it will draw in main loop
    
player_down:
    mov cl, ' '                           
    mov ch, 1111b                         ;draw the new user plane position to down 
                                          
    mov bx,user_pos 
    mov es:[bx], cx
    
    add user_pos,160d                   ;and main loop draw that
    mov direction, 0
    
    jmp inside_loop2

key_pressed:                              ;check if keyboard is pressed 
    mov ah,0
    int 16h

    cmp ah,48h                            ;go upKey if up button is pressed
    je upKey
    cmp ah, 50h
    je downKey
    
    cmp ah,39h                            ;go spaceKey if up button is pressed
    je spaceKey
    
    cmp ah,4Bh                            ;go leftKey (this is for debuging)
    je leftKey
     
                                          ;if no key is pressed go to inside of loop
    jmp inside_loop

leftKey:                                  ;we use it for debuging 
    ;jmp game_over
    inc miss
            
    lea bx,final_score
    call show_score 
    lea dx,final_score
    mov ah,09h
    int 21h
    
    mov ah,2
    mov dl, 0dh
    int 21h
jmp inside_loop
    
upKey:                                    ;set player direction to up
    mov direction, 8d
    jmp inside_loop

downKey:
    mov direction, 2d                     ;set player direction to down
    jmp inside_loop
    
spaceKey:                                 ;shoot a bullet
    cmp bullet_status,0
    je  fire_bullet
    jmp inside_loop

fire_bullet:                       ;set bullet position the same as user position
    mov dx, user_pos                    ;fire bullet
    mov bullet_pos,dx
    
    mov dx,user_pos                     ;set limit for bullet
    mov bullet_limit,dx                   ;area when bullet should off the screen
    add bullet_limit,22d
    
    mov bullet_status,1d                  ;set bullet prevent it to multiple 
    jmp inside_loop                       ;shooting 

miss_enemy:
    add miss,1                            ;update score
    inc level

    lea bx,final_score                      ;display score
    call show_score 
    lea dx,final_score
    mov ah,09h
    int 21h
                                          ;new line
    mov ah,2
    mov dl, 0dh
    int 21h
jmp fire_enemy
    
fire_enemy:                                ;fire new balloon
    mov enemy_status, 1d
    mov enemy_pos, 3860d     ;3990d
    jmp render_enemy
    
hide_bullet:
    mov bullet_status,0                   ;hide arrow
    
    mov cl, ' '
    mov ch, 1111b
    
    mov bx,bullet_pos
    mov es:[bx], cx
    
    cmp enemy_pos, 0d 
    jle miss_enemy
    jne render_enemy 
    
    jmp inside_loop2
                                          ;print game over screen
game_over:
    mov ah,09h
    ;mov dh,0
    mov dx, offset game_over_str
    int 21h
    
    
    
    mov cl, ' '                           ;hide last of enemy
    mov ch, 1111b 
    mov bx,bullet_pos           
    
    mov cl, ' '                           ;hide player
    mov ch, 1111b 
    mov bx,user_pos  
 
    
    ;reset value                          ;update variable for start again
    mov miss, 0d
    mov hits,0d
    mov level,1d
    
    mov user_pos, 1760d

    mov bullet_pos,0d
    mov bullet_status, 0d
    mov bullet_limit,22d      

    mov enemy_pos, 3860d       ;3990d
    mov enemy_status, 0d
         
    mov direction, 0d
                                           ;wait for input
    input:
        mov ah,1
        int 21h
        cmp al,13d
        jne input
        call clear_screen
        jmp main_loop
    

game_menu:
                                           ;game menu screen
    mov ah,09h
    mov dh,0
    mov dx, offset game_start_str
    int 21h
                                           ;wait for input
    input2:
        mov ah,1
        int 21h
        cmp al,13d
        jne input2
        call clear_screen   
        
         
      
         
        
        lea bx,final_score                   ;display score
        call show_score 
        lea dx,final_score
        mov ah,09h
        int 21h
    
        mov ah,2
        mov dl, 0dh
        int 21h
        
        jmp main_loop

exit_game:                                  ;  AKHIR
mov exit,10d                                ;       DARI 
                                             ;         GAME 
main endp                                     ;           SPACE 
                                               ;              GAME 
                                                ;                IMPACT

;;--------------------------------------------------------------------;;
;;                                                                    ;;
;;  show score in same postion on screen                              ;;
;;  using base pointer to get segment of variable                     ;;
;;                                                                    ;;
;;____________________________________________________________________;;

proc show_score
    lea bx,final_score
    
    mov dx, hits
    add dx,48d 
    
    mov [bx], 9d
    mov [bx+1], 9d
    mov [bx+2], 9d
    mov [bx+3], 9d
    mov [bx+4], 'H'
    mov [bx+5], 'i'                                        
    mov [bx+6], 't'
    mov [bx+7], 's'
    mov [bx+8], ':'
    mov [bx+9], dx
    
    mov dx, miss
    add dx,48d
    mov [bx+10], ' '
    mov [bx+11], 'M'
    mov [bx+12], 'i'
    mov [bx+13], 's'
    mov [bx+14], 's'
    mov [bx+15], ':'
    mov [bx+16], dx 
    
    mov dx, level
    add dx, 48d 
    mov [bx+17], 10
    mov [bx+18], 8d
    mov [bx+19], 8d
    mov [bx+20], 8d
    mov [bx+21], 8d
    mov [bx+22], 8d 
    mov [bx+23], 8d
    mov [bx+24], 8d
    mov [bx+25], 8d
    mov [bx+26], 8d
    mov [bx+27], 8d  
    mov [bx+28], 'L'
    mov [bx+29], 'e' 
    mov [bx+30], 'v'
    mov [bx+31], 'e'
    mov [bx+32], 'L'
    mov [bx+33], ':'
    mov [bx+34], dx
     
    
   
    

    
ret    
show_score endp 


;;--------------------------------------------------------------------;;
;;                                                                    ;;
;;  Clear the sceen                                                   ;;
;;  Set background and foreground color                               ;;
;;                                                                    ;;
;;____________________________________________________________________;;

clear_screen proc near 
        
        mov ah,00
        mov al,02  
        int 10h         ;for video display  
        mov ah,06h
        xor al,al 
        xor cx,cx
        mov dx,184fh
        mov bh,2ch  
        int 10h
        ret
        
clear_screen endp

end main