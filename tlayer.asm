IDEAL
P386N
MODEL FLAT
STACK 1000h
jumps
DATASEG

menu            dd switch_pal
                dd rot90
                dd flip_x
                dd flip_y
                dd save_file
                dd quit

decode_proc     dd ONEBP_decode
                dd NES_decode
                dd GB_decode
                dd VB_decode
                dd SNES_decode
                dd SMS_decode

encode_proc     dd ONEBP_encode
                dd NES_encode
                dd GB_encode
                dd VB_encode
                dd SNES_encode
                dd SMS_encode

welcome_msg     db 13,10
                db ' ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿',13,10
                db ' ³ Tile Layer v0.51 BETA ³',13,10
                db ' ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ',13,10
                db ' (c) Kent Hansen 1998',13,10
                db 13,10
                db '$'
syntax_msg      db ' Syntax: tlayer <rom.ext> <rom2.ext (optional) >',13,10
                db '$'
loading_msg     db ' Loading file(s)...',13,10
                db '$'

save_msg        db 'File saved. Press enter.$'
palsave_msg     db 'Palette saved. Press enter.$'

file_error      db 13,10,' ERROR: Could not open file(s).',13,10,'$'
mouse_error     db 13,10,' ERROR: This program requires a mouse.',13,10,'$'
mem_error       db 13,10,' ERROR: Could not allocate memory.',13,10,'$'

pal_file        db 'tlayer.pal',0

offset_msg      db '(000000)',0
mode_msg        db 'MODE:NES ',0

video_mem       dd 0A0000h
keyb_buffer     dd 0400h
HorLineStat     db 0
VertLineStat    db 0
current_offset  dd 0
foregr_color    db 0
backgr_color    db 0
clipboard_tile  db 0
file_count      db 0
current_file    db 0
decoded_tile    db 8*8 dup (0)
clipboard_data  db (64*17*8)+64 dup (0)
file_names      db 128 dup (0)
tile_offsets    dd 2 dup (0)

tile_size       dd 8
tile_format     db 0

mouse_cursor DB 32,32,0,0,0,0,0,0
             DB 32,248,32,0,0,0,0,0
             DB 32,248,248,32,0,0,0,0
             DB 32,248,248,248,32,0,0,0
             DB 32,248,248,248,248,32,0,0
             DB 32,248,248,248,248,248,32,0
             DB 32,248,248,248,248,248,248,32
             DB 32,248,248,248,248,32,32,0
             DB 32,248,248,32,32,0,0,0
             DB 32,32,32,0,0,0,0,0

include "tlayer.inc"
include "2col.inc"
include "16col.inc"

num_pals        db 3
current_pal     db 0
user_palette    db 16 dup (0)

rgb_palette     DB 00,00,00
                DB 21,21,21
                DB 42,42,42
                DB 62,62,62
                DB 00,00,42 ;
                DB 00,22,62
                DB 54,46,62
                DB 21,43,60
                DB 34,05,00 ;
                DB 60,52,44
                DB 63,40,17
                DB 57,23,04
                DB 00,22,00 ;
                DB 00,34,34
                DB 22,54,21
                DB 50,50,10
                DB 59,59,59,55,55,55,52,52,52,48,48,48
 DB 45,45,45,42,42,42,38,38,38,35,35,35,31,31,31,28,28,28,25,25
 DB 25,21,21,21,18,18,18,14,14,14,11,11,11,8,8,8,63,0,0,59
 DB 0,0,56,0,0,53,0,0,50,0,0,47,0,0,44,0,0,41,0,0
 DB 38,0,0,34,0,0,31,0,0,28,0,0,25,0,0,22,0,0,19,0
 DB 0,16,0,0,63,54,54,63,46,46,63,39,39,63,31,31,63,23,23,63
 DB 16,16,63,8,8,63,0,0,63,42,23,63,38,16,63,34,8,63,30,0
 DB 57,27,0,51,24,0,45,21,0,39,19,0,63,63,54,63,63,46,63,63
 DB 39,63,63,31,63,62,23,63,61,16,63,61,8,63,61,0,57,54,0,51
 DB 49,0,45,43,0,39,39,0,33,33,0,28,27,0,22,21,0,16,16,0
 DB 52,63,23,49,63,16,45,63,8,40,63,0,36,57,0,32,51,0,29,45
 DB 0,24,39,0,54,63,54,47,63,46,39,63,39,32,63,31,24,63,23,16
 DB 63,16,8,63,8,0,63,0,0,63,0,0,59,0,0,56,0,0,53,0
 DB 1,50,0,1,47,0,1,44,0,1,41,0,1,38,0,1,34,0,1,31
 DB 0,1,28,0,1,25,0,1,22,0,1,19,0,1,16,0,54,63,63,46
 DB 63,63,39,63,63,31,63,62,23,63,63,16,63,63,8,63,63,0,63,63
 DB 0,57,57,0,51,51,0,45,45,0,39,39,0,33,33,0,28,28,0,22
 DB 22,0,16,16,23,47,63,16,44,63,8,42,63,0,39,63,0,35,57,0
 DB 31,51,0,27,45,0,23,39,54,54,63,46,47,63,39,39,63,31,32,63
 DB 23,24,63,16,16,63,8,9,63,0,1,63,0,0,63,0,0,59,0,0
 DB 56,0,0,53,0,0,50,0,0,47,0,0,44,0,0,41,0,0,38,0
 DB 0,34,0,0,31,0,0,28,0,0,25,0,0,22,0,0,19,0,0,16
 DB 60,54,63,57,46,63,54,39,63,52,31,63,50,23,63,47,16,63,45,8
 DB 63,42,0,63,38,0,57,32,0,51,29,0,45,24,0,39,20,0,33,17
 DB 0,28,13,0,22,10,0,16,63,54,63,63,46,63,63,39,63,63,31,63
 DB 63,23,63,63,16,63,63,8,63,63,0,63,56,0,57,50,0,51,45,0
 DB 45,39,0,39,33,0,33,27,0,28,22,0,22,16,0,16,63,58,55,63
 DB 56,52,63,54,49,63,53,47,63,51,44,63,49,41,63,47,39,63,46,36
 DB 63,44,32,63,41,28,63,39,24,60,37,23,58,35,22,55,34,21,52,32
 DB 20,50,31,19,47,30,18,45,28,17,42,26,16,40,25,15,39,24,14,36
 DB 23,13,34,22,12,32,20,11,29,19,10,27,18,9,23,16,8,21,15,7
 DB 18,14,6,16,12,6,14,11,5,10,8,3,0,0,0,0,0,0,0,0
 DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,49,10,10,49
 DB 19,10,49,29,10,49,39,10,49,49,10,39,49,10,29,49,10,19,49,10
 DB 10,49,12,10,49,23,10,49,34,10,49,45,10,42,49,10,31,49,10,20
 DB 49,11,10,49,63,63,63,33,10,49,21,21,60,63,63,0,25,25,25,21
 DB 21,63,0,0,33,63,63,63

mouse_x         dd 0
mouse_y         dd 0
button_status   db 0

PreCalcBuffer   db 100h*8*8     dup (?)
virtual_screen  db 10000h       dup (?)
file_pointers   dd 2 dup (?)
file_sizes      dd 2 dup (?)
current_ptr     dd ?
mem_alloced     dd ?
current_fsize   dd ?

oldint9         df ?

CODESEG

include "font.inc"
include "palette.inc"

start:

mov     ax,0
int     33h
cmp     ax,0
jnz     mouse_ok

mov     ah,09
mov     edx,offset mouse_error
int     21h
jmp     terminate

mouse_ok:

mov     ah,09
mov     edx,offset welcome_msg
int     21h

mov     ax,0EE02h
int     31h

sub     [video_mem],ebx
sub     [keyb_buffer],ebx

movzx   ecx,[byte ptr esi+80h]
cmp     cl,0
jnz     parameter_present

mov     ah,09
mov     edx,offset syntax_msg
int     21h
jmp     terminate

parameter_present:
mov     ah,09
mov     edx,offset loading_msg
int     21h

mov     edi,offset file_names
add     esi,81h
find_first_char:
cmp     [byte ptr esi],13
je      load_files
cmp     [byte ptr esi],20h
jnz     copy_filename
inc     esi
jmp     short find_first_char

copy_filename:
movsb
cmp     [byte ptr esi],20h
je      done_filecopy
cmp     [byte ptr esi],13
je      done_filecopy
jmp     copy_filename
done_filecopy:
inc     edi
inc     [file_count]
jmp     find_first_char

load_files:

mov     edx,-1
mov     ax,0EE42h
int     31h
mov     [dword ptr file_pointers],edx
mov     [current_ptr],edx
mov     [mem_alloced],eax

mov     ax,3D00h
mov     edx,offset file_names
int     21h
jnc     load_1st_file

open_error:
mov     ah,09
mov     edx,offset file_error
int     21h
jmp     terminate

load_1st_file:

mov     bx,ax
mov     ah,3Fh
mov     ecx,[mem_alloced]
mov     edx,[dword ptr file_pointers]
int     21h
cmp     eax,[mem_alloced]
jnz     file_loaded

mov     ah,09
mov     edx,offset mem_error
int     21h
jmp     terminate

file_loaded:
mov     [dword ptr file_sizes],eax
mov     [current_fsize],eax
mov     [dword ptr file_pointers + 4],edx
add     [dword ptr file_pointers + 4],eax

mov     ah,3Eh
int     21h

mov     esi,offset file_names
call    StrToLower
call    FindExtension
cmp     [dword ptr esi-1],'sen.'
je      nes_file
cmp     [word ptr esi],'bg'
je      gb_file
cmp     [word ptr esi],'bv'
je      vb_file
cmp     [dword ptr esi-1],'cms.'
je      snes_file
cmp     [dword ptr esi-1],'sms.'
je      sms_file

mov     [tile_format],0
mov     [tile_size],8
mov     [dword ptr mode_msg + 5],'PPB1'
jmp     next_file

nes_file:
mov     [tile_format],1
mov     [tile_size],16
mov     [dword ptr mode_msg + 5],' SEN'
jmp     next_file

gb_file:
mov     [tile_format],2
mov     [tile_size],16
mov     [dword ptr mode_msg + 5],'  BG'
jmp     next_file

vb_file:
mov     [tile_format],3
mov     [tile_size],16
mov     [dword ptr mode_msg + 5],'  BV'
jmp     next_file

snes_file:
mov     [tile_format],4
mov     [tile_size],32
mov     [dword ptr mode_msg + 5],'SENS'
jmp     next_file

sms_file:
mov     [tile_format],5
mov     [tile_size],32
mov     [dword ptr mode_msg + 5],' SMS'
jmp     next_file

next_file:

cmp     [file_count],1
je      start_precalc

mov     edx,offset file_names
find_2nd_file:
inc     edx
cmp     [byte ptr edx-1],0
jnz     find_2nd_file

mov     ax,3D00h
int     21h
jc      open_error

mov     bx,ax
mov     ah,3Fh
mov     ecx,[mem_alloced]
mov     edx,[dword ptr file_pointers + 4]
int     21h
add     eax,[dword ptr file_sizes]
cmp     eax,[mem_alloced]
jb      file_loaded_2

mov     ah,09
mov     edx,offset mem_error
int     21h
jmp     terminate

file_loaded_2:
sub     eax,[dword ptr file_sizes]

mov     [dword ptr file_sizes + 4],eax

mov     ah,3Eh
int     21h

start_precalc:

; precalculate all possible bit patterns

mov     edi,offset PreCalcBuffer
precalc:
xor     bl,bl
xor     cl,cl
precalcbits:
mov     al,bl
mov     ch,8
decode:
rol     al,1
mov     dl,al
and     dl,1
shl     dl,cl
mov     [byte ptr edi],dl
inc     edi
dec     ch
jnz     short decode
inc     bl
jnz     short precalcbits
inc     cl
cmp     cl,8
jne     short precalcbits

mov     ax,13h
int     10h

mov     ax,7
mov     cx,0
mov     dx,312*2
int     33h

mov     ax,8
mov     cx,0
mov     dx,190
int     33h

xor     al,al
mov     ecx,256*3
mov     esi,offset rgb_palette
call    SetPalette

mov     ax,3D00h
mov     edx,offset pal_file
int     21h
jc      use_standard_pal

mov     bx,ax
mov     ah,3Fh
mov     edx,offset rgb_palette
mov     ecx,16*3
int     21h

use_standard_pal:
xor     al,al
mov     ecx,256*3
mov     esi,offset rgb_palette
call    SetPalette

mov     dx,3DAh
in      al,dx
mov     dx,3C0h
mov     al,31h
out     dx,al
mov     al,0FFh
out     dx,al

mov     dx,3c8h
mov     al,0FFh
out     dx,al
inc     dx
xor     al,al
out     dx,al
out     dx,al
out     dx,al

main_loop:
call    Clear_VrScreen
call    Draw_Tiles
call    Draw_clipboard
call    Draw_Current_Tile
call    Print_Info
call    Draw_RGB_Boxes
call    Hilight_Color
call    Hilight_Tile
call    Draw_HorLines
call    Draw_VertLines
call    Read_Mouse
call    Draw_Mouse

mov     esi,offset virtual_screen
mov     edi,[video_mem]
mov     ecx,64000/4
rep     movsd

call    waitvrt

mov     ah,01h
int     16h
jz      main_loop

pushad
mov     edi,[Keyb_buffer]
mov     ax,[word ptr edi + 1Ch]
mov     [word ptr edi + 01Ah],ax        ; tail = head (clear kbbuffer)
popad

cmp     al,27
je      exit
cmp     al,'1'
je      toggle_horlines
cmp     al,'2'
je      toggle_vertlines
cmp     ah,3Bh
je      switch_bpmode
cmp     ah,3Ch
je      save_pal
cmp     ah,0Fh
je      switch_file
cmp     ah,4Bh
je      finetune_up
cmp     ah,4Dh
je      finetune_down
cmp     ah,48h
je      move_up
cmp     ah,50h
je      move_down
cmp     ah,49h
je      page_up
cmp     ah,51h
je      page_down
jmp     main_loop

PROC    Draw_HorLines
cmp     [HorLineStat],1
jnz     @@99
pushad
mov     edi,offset virtual_screen + (24*320)+16
mov     eax,0FDFDFDFDh
rept    18
mov     ecx,128/4
rep     stosd
add     edi,(320-128)+(7*320)
endm
popad
@@99:
ret
ENDP    Draw_HorLines

PROC    Draw_VertLines
cmp     [VertLineStat],1
jnz     @@99
pushad
mov     edi,offset virtual_screen + (17*320)+24
mov     al,0FDh
rept    15
push    edi
rept    152
mov     [byte ptr edi],al
add     edi,320
endm
pop     edi
add     edi,8
endm
popad
@@99:
ret
ENDP    Draw_VertLines

toggle_horlines:
xor     [HorLineStat],1
jmp     main_loop

toggle_vertlines:
xor     [VertLineStat],1
jmp     main_loop

save_pal:
mov     ah,3Ch
xor     cx,cx
mov     edx,offset pal_file
int     21h
mov     bx,ax
mov     ah,40h
mov     ecx,16*3
mov     edx,offset rgb_palette
int     21h
mov     ah,3Eh
int     21h

mov     ah,02
xor     bh,bh
mov     dh,23
mov     dl,7
int     10h

mov     ah,09
mov     edx,offset palsave_msg
int     21h

mov     ah,00h
int     16h
jmp     main_loop

switch_bpmode:
cmp     [tile_format],0
je      nes_mode
cmp     [tile_format],1
je      gb_mode
cmp     [tile_format],2
je      vb_mode
cmp     [tile_format],3
je      snes_mode
cmp     [tile_format],4
je      sms_mode

mov     [tile_size],8
mov     [tile_format],0
mov     [dword ptr mode_msg + 5],'PPB1'
jmp     main_loop
nes_mode:
mov     [tile_size],16
mov     [tile_format],1
mov     [dword ptr mode_msg + 5],' SEN'
jmp     main_loop
gb_mode:
mov     [tile_size],16
mov     [tile_format],2
mov     [dword ptr mode_msg + 5],'  BG'
jmp     main_loop
vb_mode:
mov     [tile_size],16
mov     [tile_format],3
mov     [dword ptr mode_msg + 5],'  BV'
jmp     main_loop
snes_mode:
mov     [tile_size],32
mov     [tile_format],4
mov     [dword ptr mode_msg + 5],'SENS'
jmp     main_loop
sms_mode:
mov     [tile_size],32
mov     [tile_format],5
mov     [dword ptr mode_msg + 5],' SMS'
jmp     main_loop

switch_file:
cmp     [file_count],1
je      main_loop

mov     eax,[current_offset]
movzx   ebx,[current_file]
mov     [tile_offsets + ebx*4],eax

xor     [current_file],1
movzx   ebx,[current_file]
mov     eax,[file_pointers + ebx*4]
mov     [current_ptr],eax
mov     eax,[file_sizes + ebx*4]
mov     [current_fsize],eax
mov     eax,[tile_offsets + ebx*4]
mov     [current_offset],eax

mov     esi,offset file_names
cmp     [current_file],0
je      okidoki

find_2nd_file_again:
inc     esi
cmp     [byte ptr esi-1],0
jnz     find_2nd_file_again

okidoki:
call    FindExtension

cmp     [dword ptr esi-1],'sen.'
je      nes_mode
cmp     [word ptr esi],'bg'
je      gb_mode
cmp     [word ptr esi],'bv'
je      vb_mode
cmp     [dword ptr esi-1],'cms.'
je      snes_mode
cmp     [dword ptr esi-1],'sms.'
je      sms_mode

mov     [tile_size],8
mov     [tile_format],0
mov     [dword ptr mode_msg + 5],'PPB1'
jmp     main_loop

page_up:
mov     eax,[tile_size]
mov     edx,16*19
mul     edx
cmp     [current_offset],eax
jbe     to_top
sub     [current_offset],eax
jmp     main_loop
to_top:
mov     [current_offset],0
jmp     main_loop

page_down:
mov     eax,[tile_size]
mov     edx,16*19
mul     edx
add     eax,eax
add     eax,[current_offset]
cmp     eax,[current_fsize]
ja      main_loop

mov     eax,[tile_size]
mov     edx,16*19
mul     edx
add     eax,[current_offset]
mov     [current_offset],eax
jmp     main_loop

finetune_up:
cmp     [current_offset],0
je      main_loop
dec     [current_offset]
jmp     main_loop

finetune_down:
mov     eax,[tile_size]
mov     edx,16*19
mul     edx
mov     ebx,[current_fsize]
sub     ebx,eax
cmp     [current_offset],ebx
jb      ofs_ok
mov     [current_offset],ebx
jmp     main_loop
ofs_ok:
inc     [current_offset]
jmp     main_loop

move_up:
mov     eax,[tile_size]
shl     eax,4
cmp     [current_offset],eax
jb      to_top
mov     eax,[tile_size]
shl     eax,4
sub     [current_offset],eax
jmp     main_loop

move_down:
mov     eax,[tile_size]
mov     edx,16*19
mul     edx
mov     ebx,eax
mov     eax,[current_fsize]
sub     eax,ebx
cmp     [current_offset],eax
jb      ofs_ok2
mov     [current_offset],eax
jmp     main_loop
ofs_ok2:
mov     eax,[tile_size]
shl     eax,4
add     [current_offset],eax
jmp     main_loop

exit:

mov     ax,205h
mov     bl,9
mov     edx,[dword ptr oldint9]                    ; set oldint9 back
mov     cx,[word ptr oldint9+4]
int     31h

mov     ax,3
int     10h
terminate:
mov     ax,4c00h
int     21h

PROC    Read_Mouse
pushad
xor     ecx,ecx
xor     edx,edx
mov     ax,3
int     33h
shr     ecx,1
mov     [mouse_x],ecx
mov     [mouse_y],edx
mov     [button_status],bl
cmp     bl,0
je      @@end_read

mov     eax,16
mov     ebx,17
mov     ecx,143
mov     edx,168
call    CmpMouse
je      @@select_tile

mov     eax,160
mov     ebx,17
mov     ecx,295
mov     edx,79
call    CmpMouse
je      @@select_clipboard_tile

mov     eax,160
mov     ebx,105
mov     ecx,223
mov     edx,168
call    CmpMouse
je      @@draw_tile

mov     eax,225
mov     ebx,105
mov     ecx,239
mov     edx,168
call    CmpMouse
je      @@select_color

mov     eax,90
mov     ebx,178
mov     ecx,305
mov     edx,191
call    CmpMouse
je      @@menu_item

mov     eax,255
mov     ebx,98
mov     ecx,295
mov     edx,168
call    CmpMouse
je      @@adjust_rgb

jmp     @@end_read

@@adjust_rgb:
mov     eax,ecx
mov     ecx,14
push    edx
xor     edx,edx
div     ecx
pop     edx
cmp     dl,63
jbe     @@color_ok
mov     dl,63
@@color_ok:

movzx   ebx,al
mov     cl,dl
cmp     [tile_format],4
jae     @@drittsekk

movzx   eax,[current_pal]
mov     edx,4*3
mul     edx
push    eax
add     ebx,eax
movzx   eax,[foregr_color]
mov     edx,3
mul     edx
add     ebx,eax
mov     [rgb_palette + ebx],cl
mov     ecx,4*3
mov     esi,offset rgb_palette
pop     eax
add     esi,eax
xor     al,al
call    SetPalette
jmp     @@end_read

@@drittsekk:
movzx   eax,[foregr_color]
mov     edx,3
mul     edx
add     ebx,eax
mov     [rgb_palette + ebx],cl
xor     al,al
mov     ecx,16*3
mov     esi,offset rgb_palette
call    SetPalette
jmp     @@end_read

@@select_tile:
shr     ecx,3
mov     eax,ecx
push    edx
mov     edx,[tile_size]
mul     edx
mov     ebx,eax
pop     edx
shr     edx,3
mov     eax,edx
mov     edx,[tile_size]
shl     edx,4
mul     edx
add     ebx,eax
mov     esi,ebx
mov     eax,[current_offset]
add     esi,eax
test    [button_status],2
jnz     @@paste_tile

add     esi,[current_ptr]
mov     edi,offset clipboard_data + (64*17*8)
movzx   eax,[tile_format]
mov     ebp,8
call    [decode_proc + eax*4]
mov     [clipboard_tile],17*8
jmp     @@end_read

@@paste_tile:
mov     edi,esi
cmp     edi,[current_fsize]
jae     @@end_read

add     edi,[current_ptr]
mov     esi,offset clipboard_data
movzx   eax,[clipboard_tile]
shl     eax,6
add     esi,eax
movzx   eax,[tile_format]
call    [encode_proc + eax*4]
jmp     @@end_read

@@select_clipboard_tile:
shr     ecx,3
mov     ebx,ecx
shr     edx,3
mov     eax,edx
mov     edx,17
mul     edx
add     ebx,eax

mov     [clipboard_tile],bl

mov     esi,offset clipboard_data
add     esi,64*17*8
mov     edi,offset clipboard_data
shl     ebx,6
add     edi,ebx
mov     ecx,64/4

test    [button_status],1
jnz     @@select_worktile

rep     movsd
jmp     @@end_read

@@select_worktile:
xchg    esi,edi
rep     movsd
jmp     @@end_read

@@draw_tile:
shr     ecx,3
mov     ebx,ecx
shr     edx,3
shl     edx,3
add     ebx,edx

test    [button_status],1
jnz     @@draw_foregr_color

mov     esi,offset clipboard_data
movzx   eax,[clipboard_tile]
shl     eax,6
add     esi,eax

mov     al,[backgr_color]
mov     [byte ptr esi + ebx],al

mov     edi,offset clipboard_data + (64*17*8)
mov     ecx,64/4
rep     movsd
jmp     @@end_read

@@draw_foregr_color:
mov     esi,offset clipboard_data
movzx   eax,[clipboard_tile]
shl     eax,6
add     esi,eax

mov     al,[foregr_color]
mov     [byte ptr esi + ebx],al

mov     edi,offset clipboard_data + (64*17*8)
mov     ecx,64/4
rep     movsd
jmp     @@end_read

@@select_color:
cmp     [tile_format],0
je      @@1bp_col
cmp     [tile_format],4
jae     @@snes_col

shr     edx,4
test    [button_status],1
jnz     @@select_foregr_color
mov     [backgr_color],dl
jmp     @@end_read

@@select_foregr_color:
mov     [foregr_color],dl
jmp     @@end_read

@@1bp_col:
shr     edx,5
test    [button_status],1
jnz     @@select_foregr_color
mov     [backgr_color],dl
jmp     @@end_read

@@snes_col:
shr     edx,3
and     cl,8
add     dl,cl
test    [button_status],1
jnz     @@select_foregr_color
mov     [backgr_color],dl
jmp     @@end_read

@@menu_item:
mov     eax,ecx
mov     ecx,36
xor     edx,edx
div     ecx
jmp     [menu + eax*4]

switch_pal:
rept    10
call    waitvrt
endm

mov     al,[current_pal]
cmp     al,[num_pals]
je      set_pal_0
inc     [current_pal]
movzx   eax,[current_pal]
mov     edx,4*3
mul     edx
mov     esi,offset rgb_palette
add     esi,eax
xor     al,al
mov     ecx,4*3
call    SetPalette
jmp     @@end_read
set_pal_0:
xor     al,al
mov     [current_pal],0
movzx   eax,[current_pal]
mov     edx,3
mul     edx
mov     esi,offset rgb_palette
add     esi,eax
xor     al,al
mov     ecx,4*3
call    SetPalette
jmp     @@end_read

rot90:
rept    10
call    waitvrt
endm

mov     esi,offset clipboard_data
movzx   eax,[clipboard_tile]
shl     eax,6
add     esi,eax
push    esi
mov     edi,offset decoded_tile
mov     ecx,(8*8)/4
rep     movsd
pop     esi
mov     edi,esi
mov     esi,offset decoded_tile
add     edi,7

mov     cl,8
rotate_now:
lodsb
mov     [byte ptr edi],al
lodsb
mov     [byte ptr edi+8],al
lodsb
mov     [byte ptr edi+16],al
lodsb
mov     [byte ptr edi+24],al
lodsb
mov     [byte ptr edi+32],al
lodsb
mov     [byte ptr edi+40],al
lodsb
mov     [byte ptr edi+48],al
lodsb
mov     [byte ptr edi+56],al
dec     edi
dec     cl
jnz     rotate_now

mov     esi,offset clipboard_data
movzx   eax,[clipboard_tile]
shl     eax,6
add     esi,eax
mov     edi,offset clipboard_data + (64*17*8)
mov     ecx,64/4
rep     movsd

jmp     @@end_read

flip_x:
rept    10
call    waitvrt
endm
mov     esi,offset clipboard_data
movzx   eax,[clipboard_tile]
shl     eax,6
add     esi,eax
push    esi
mov     edi,offset decoded_tile
mov     ecx,(8*8)/4
rep     movsd
pop     esi
mov     edi,esi
mov     esi,offset decoded_tile
mov     cl,8
@@reverse_x:
mov     al,[byte ptr esi+0]
mov     [byte ptr edi+7],al
mov     al,[byte ptr esi+1]
mov     [byte ptr edi+6],al
mov     al,[byte ptr esi+2]
mov     [byte ptr edi+5],al
mov     al,[byte ptr esi+3]
mov     [byte ptr edi+4],al
mov     al,[byte ptr esi+4]
mov     [byte ptr edi+3],al
mov     al,[byte ptr esi+5]
mov     [byte ptr edi+2],al
mov     al,[byte ptr esi+6]
mov     [byte ptr edi+1],al
mov     al,[byte ptr esi+7]
mov     [byte ptr edi+0],al
add     esi,8
add     edi,8
dec     cl
jnz     @@reverse_x

mov     esi,offset clipboard_data
movzx   eax,[clipboard_tile]
shl     eax,6
add     esi,eax
mov     edi,offset clipboard_data + (64*17*8)
mov     ecx,64/4
rep     movsd

jmp     @@end_read

flip_y:
rept    10
call    waitvrt
endm
mov     esi,offset clipboard_data
movzx   eax,[clipboard_tile]
shl     eax,6
add     esi,eax
push    esi
mov     edi,offset decoded_tile
mov     ecx,(8*8)/4
rep     movsd
pop     esi
mov     edi,esi
mov     esi,offset decoded_tile + (7*8)
mov     bl,8
@@reverse_y:
mov     ecx,8
rep     movsb
sub     esi,16
dec     bl
jnz     @@reverse_y

mov     esi,offset clipboard_data
movzx   eax,[clipboard_tile]
shl     eax,6
add     esi,eax
mov     edi,offset clipboard_data + (64*17*8)
mov     ecx,64/4
rep     movsd

jmp     @@end_read

save_file:
mov     ax,3D02h
mov     edx,offset file_names
cmp     [current_file],0
je      open_it
find_zero:
inc     edx
cmp     [byte ptr edx-1],0
jnz     find_zero

open_it:
mov     esi,edx
call    FindExtension
cmp     [word ptr esi],'bg'
jnz     no_checksum

;
; -------------------
;

pushad

mov     ecx,[current_fsize]
and     ecx,0FFF8000h
xor     eax,eax
xor     ebx,ebx
mov     esi,[current_ptr]
calc_checksum:
mov     al,[byte ptr esi]
add     ebx,eax
inc     esi
dec     ecx
jnz     calc_checksum

mov     esi,[current_ptr]
mov     al,[byte ptr esi + 14Eh]
sub     ebx,eax
mov     al,[byte ptr esi + 14Fh]
sub     ebx,eax

mov     [byte ptr esi + 14Eh],bh
mov     [byte ptr esi + 14Fh],bl

popad

;
; -------------------
;

no_checksum:
int     21h
mov     bx,ax
mov     ah,40h
mov     ecx,[current_fsize]
mov     edx,[current_ptr]
int     21h
mov     ah,3Eh
int     21h

mov     ah,02
xor     bh,bh
mov     dh,23
mov     dl,7
int     10h

mov     ah,09
mov     edx,offset save_msg
int     21h

mov     ah,00
int     16h

jmp     @@end_read

quit:
jmp     exit

@@end_read:
popad
ret
ENDP    Read_Mouse

PROC    Clear_VrScreen
pushad
mov     esi,offset interface
mov     edi,offset virtual_screen
mov     ecx,64000/4
rep     movsd
cmp     [tile_format],0
je      @@2_col_pal
cmp     [tile_format],4
jae     @@16_col_pal
jmp     @@99

@@2_col_pal:
mov     edi,offset virtual_screen
add     edi,(105*320)+224
mov     esi,offset _2col
mov     dl,65
jmp     @@10

@@16_col_pal:
mov     edi,offset virtual_screen
add     edi,(105*320)+224
mov     esi,offset _16col
mov     dl,65
@@10:
mov     ecx,16/4
rep     movsd
add     edi,320-16
dec     dl
jnz     @@10

@@99:
popad
ret
ENDP    Clear_VrScreen

PROC    Draw_Tiles
pushad
mov     esi,[current_ptr]
add     esi,[current_offset]
mov     edi,offset virtual_screen + (320*17+16)

mov     dh,19
@@draw_tiles_y:
mov     dl,16
push    edi
@@draw_tiles_x:
movzx   eax,[tile_format]
mov     ebp,320
call    [decode_proc + eax*4]
add     esi,[tile_size]
add     edi,8
dec     dl
jnz     @@draw_tiles_x
pop     edi
add     edi,8*320
dec     dh
jnz     @@draw_tiles_y
popad
ret
ENDP    Draw_Tiles

PROC    Draw_clipboard
pushad
mov     esi,offset clipboard_data
mov     edi,offset virtual_screen + (320*17+160)
mov     bh,8
@@draw_tiles_y:
mov     bl,17
push    edi
@@draw_tiles_x:
push    edi

rept    8
mov     ecx,8
rep     movsb
add     edi,320-8
endm

pop     edi
add     edi,8
dec     bl
jnz     @@draw_tiles_x
pop     edi
add     edi,320*8
dec     bh
jnz     @@draw_tiles_y
popad
ret
ENDP    Draw_clipboard

PROC    Draw_Mouse
pushad
mov     esi,offset mouse_cursor
mov     edi,offset virtual_screen
mov     eax,[mouse_y]
shl     eax,8
add     edi,eax
shr     eax,2
add     edi,eax
add     edi,[mouse_x]

mov     ch,10
@@yloop:
mov     cl,8
@@xloop:
mov     al,[byte ptr esi]
cmp     al,0
je      @@no_draw
mov     [byte ptr edi],al
@@no_draw:
inc     esi
inc     edi
dec     cl
jnz     @@xloop
add     edi,320-8
dec     ch
jnz     @@yloop

popad
ret
ENDP    Draw_Mouse

PROC    Draw_Current_Tile
pushad
mov     esi,offset clipboard_data + (64*17*8)
mov     edi,offset virtual_screen + (320*105+160)
mov     dh,8
@@yloop:
mov     dl,8
@@xloop:
push    esi
rept    8
lodsb
mov     ecx,8
rep     stosb
endm
pop     esi
add     edi,320-64
dec     dl
jnz     @@xloop
add     esi,8
dec     dh
jnz     @@yloop
@@no_draw:
popad
ret
ENDP    Draw_Current_Tile

PROC    ONEBP_encode
pushad

rept    8
xor     bl,bl
rept    8
lodsb
rol     bl,1
and     al,1
or      bl,al
endm
mov     [byte ptr edi],bl
inc     edi
endm

popad
ret
ENDP    ONEBP_encode

PROC    NES_encode
pushad

rept    8
xor     bx,bx
rept    8
lodsb
rol     bl,1
rol     bh,1
mov     ah,al
and     al,1
or      bl,al
and     ah,2
shr     ah,1
or      bh,ah
endm
mov     [byte ptr edi],bl
mov     [byte ptr edi+8],bh
inc     edi
endm

popad
ret
ENDP    NES_encode

PROC    GB_encode
pushad

rept    8
xor     bx,bx
rept    8
lodsb
rol     bl,1
rol     bh,1
mov     ah,al
and     al,1
or      bl,al
and     ah,2
shr     ah,1
or      bh,ah
endm
mov     [byte ptr edi],bl
mov     [byte ptr edi+1],bh
add     edi,2
endm

popad
ret
ENDP    GB_encode

PROC    VB_encode
pushad

rept    8
rept    2
xor     bl,bl
mov     al,[byte ptr esi+0]
and     al,00000011b
or      bl,al
mov     al,[byte ptr esi+1]
shl     al,2
and     al,00001100b
or      bl,al
mov     al,[byte ptr esi+2]
shl     al,4
and     al,00110000b
or      bl,al
mov     al,[byte ptr esi+3]
ror     al,2
and     al,11000000b
or      bl,al
mov     [byte ptr edi],bl
inc     edi
add     esi,4
endm
endm

popad
ret
ENDP    VB_encode

PROC    SNES_encode
pushad

push    esi
rept    8
xor     bx,bx
rept    8
lodsb
and     al,3
rol     bl,1
rol     bh,1
mov     ah,al
and     al,1
or      bl,al
and     ah,2
shr     ah,1
or      bh,ah
endm
mov     [byte ptr edi],bl
mov     [byte ptr edi+1],bh
add     edi,2
endm
pop     esi

rept    8
xor     bx,bx
rept    8
lodsb
shr     al,2
rol     bl,1
rol     bh,1
mov     ah,al
and     al,1
or      bl,al
and     ah,2
shr     ah,1
or      bh,ah
endm
mov     [byte ptr edi],bl
mov     [byte ptr edi+1],bh
add     edi,2
endm

popad
ret
ENDP    SNES_encode

PROC    SMS_encode
pushad

rept    8
push    esi
xor     bx,bx
rept    8
lodsb
and     al,3
rol     bl,1
rol     bh,1
mov     ah,al
and     al,1
or      bl,al
and     ah,2
shr     ah,1
or      bh,ah
endm
mov     [byte ptr edi],bl
mov     [byte ptr edi+1],bh
add     edi,2
pop     esi

xor     bx,bx
rept    8
lodsb
shr     al,2
rol     bl,1
rol     bh,1
mov     ah,al
and     al,1
or      bl,al
and     ah,2
shr     ah,1
or      bh,ah
endm
mov     [byte ptr edi],bl
mov     [byte ptr edi+1],bh
add     edi,2
endm

popad
ret
ENDP    SMS_encode

PROC    ONEBP_decode
pushad

xor     ebx,ebx
rept    8
mov     bl,[byte ptr esi]
mov     eax,[dword ptr PreCalcBuffer + ebx*8]
mov     [dword ptr edi],eax
mov     eax,[dword ptr PreCalcBuffer + ebx*8+4]
mov     [dword ptr edi+4],eax
inc     esi
add     edi,ebp
endm

popad
ret
ENDP    ONEBP_decode

PROC    NES_decode
pushad

xor     ebx,ebx
rept    8
; bp 0
mov     bl,[byte ptr esi]
mov     eax,[dword ptr PreCalcBuffer + ebx*8]
mov     [dword ptr edi],eax
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 4]
mov     [dword ptr edi+4],eax
; bp 1
mov     bl,[byte ptr esi+8]
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 100h*8]
or      [dword ptr edi],eax
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 4 + 100h*8]
or      [dword ptr edi+4],eax
inc     esi
add     edi,ebp
endm

popad
ret
ENDP    NES_decode

PROC    GB_decode
pushad

xor     ebx,ebx
rept    8
; bp 0
mov     bl,[byte ptr esi]
mov     eax,[dword ptr PreCalcBuffer + ebx*8]
mov     [dword ptr edi],eax
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 4]
mov     [dword ptr edi+4],eax
; bp 1
mov     bl,[byte ptr esi+1]
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 100h*8]
or      [dword ptr edi],eax
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 4 + 100h*8]
or      [dword ptr edi+4],eax
add     esi,2
add     edi,ebp
endm

popad
ret
ENDP    GB_decode

PROC    VB_decode
pushad

rept    8
rept    2
mov     al,[byte ptr esi+0]
mov     ah,al
and     ah,00000011b
mov     [byte ptr edi+0],ah
shr     al,2
mov     ah,al
and     ah,00000011b
mov     [byte ptr edi+1],ah
shr     al,2
mov     ah,al
and     ah,00000011b
mov     [byte ptr edi+2],ah
shr     al,2
mov     ah,al
and     ah,00000011b
mov     [byte ptr edi+3],ah
inc     esi
add     edi,4
endm
sub     edi,8
add     edi,ebp
endm

popad
ret
ENDP    VB_decode

PROC    SNES_decode
pushad

xor     ebx,ebx
rept    8
; bp 0
mov     bl,[byte ptr esi]
mov     eax,[dword ptr PreCalcBuffer + ebx*8]
mov     [dword ptr edi],eax
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 4]
mov     [dword ptr edi+4],eax
; bp 1
mov     bl,[byte ptr esi+1]
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 100h*8]
or      [dword ptr edi],eax
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 4 + 100h*8]
or      [dword ptr edi+4],eax
; bp 2
mov     bl,[byte ptr esi+16]
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 200h*8]
or      [dword ptr edi],eax
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 4 + 200h*8]
or      [dword ptr edi+4],eax
; bp 3
mov     bl,[byte ptr esi+16+1]
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 300h*8]
or      [dword ptr edi],eax
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 4 + 300h*8]
or      [dword ptr edi+4],eax
add     esi,2
add     edi,ebp
endm

popad
ret
ENDP    SNES_decode

PROC    SMS_decode
pushad

xor     ebx,ebx
rept    8
; bp 0
mov     bl,[byte ptr esi]
mov     eax,[dword ptr PreCalcBuffer + ebx*8]
mov     [dword ptr edi],eax
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 4]
mov     [dword ptr edi+4],eax
; bp 1
mov     bl,[byte ptr esi+1]
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 100h*8]
or      [dword ptr edi],eax
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 4 + 100h*8]
or      [dword ptr edi+4],eax
; bp 2
mov     bl,[byte ptr esi+2]
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 200h*8]
or      [dword ptr edi],eax
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 4 + 200h*8]
or      [dword ptr edi+4],eax
; bp 3
mov     bl,[byte ptr esi+3]
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 300h*8]
or      [dword ptr edi],eax
mov     eax,[dword ptr PreCalcBuffer + ebx*8 + 4 + 300h*8]
or      [dword ptr edi+4],eax
add     esi,4
add     edi,ebp
endm

popad
ret
ENDP    SMS_decode

PROC    waitvrt
push    eax edx
    mov     dx,3dah
Vrt:
    in      al,dx
    test    al,1000b        
    jnz     Vrt            
NoVrt:
    in      al,dx
    test    al,1000b         
    jz      NoVrt         
pop     edx eax
    ret
ENDP    waitvrt

PROC    Print_Info
pushad
mov     eax,[current_offset]
mov     ebx,16
mov     cl,6
mov     edi,offset offset_msg + 1
call    FNT_NumToASCII
mov     esi,offset offset_msg
mov     edi,offset virtual_screen + (10*320)+84
call    disp_string

mov     esi,offset mode_msg
mov     edi,offset virtual_screen + (180*320)+8
call    disp_string

popad
ret
ENDP    Print_Info

PROC    SetPalette

pushad

mov     dx,3c8h
out     dx,al
inc     dx
rep     outsb

popad
ret
ENDP    SetPalette

PROC    CmpMouse

cmp     [mouse_x],eax
jb      @@false
cmp     [mouse_y],ebx
jb      @@false
cmp     [mouse_x],ecx
ja      @@false
cmp     [mouse_y],edx
ja      @@false

mov     ecx,[mouse_x]
sub     ecx,eax
mov     edx,[mouse_y]
sub     edx,ebx

xor     al,al
ret

@@false:
xor     al,al
inc     al

ret
ENDP    CmpMouse

PROC    Draw_RGB_Boxes
pushad

movzx   eax,[foregr_color]
mov     edx,3
mul     edx
mov     ebx,eax
cmp     [tile_format],4
jae     @@40

movzx   eax,[current_pal]
mov     edx,4*3
mul     edx
add     ebx,eax

@@40:
mov     esi,offset rgb_palette
add     esi,ebx
mov     edi,offset virtual_screen + (98*320)+256
mov     bh,3
@@draw_them:
push    edi
movzx   eax,[byte ptr esi]
cmp     al,63
jbe     @@color_ok
mov     al,63
@@color_ok:
shl     eax,8
add     edi,eax
shr     eax,2
add     edi,eax

mov     al,252
mov     bl,8
@@10:
mov     ecx,11
rep     stosb
add     edi,320-11
dec     bl
jnz     @@10

pop     edi
add     edi,14
inc     esi
dec     bh
jnz     @@draw_them

popad
ret
ENDP    Draw_RGB_Boxes

PROC    Hilight_Color

pushad

mov     edi,offset virtual_screen + (105*320)+224
movzx   eax,[foregr_color]
cmp     [tile_format],0
je      @@1bp_col
cmp     [tile_format],4
jae     @@snes_col

and     [foregr_color],3
mov     al,[foregr_color]
shl     eax,4
shl     eax,8
add     edi,eax
shr     eax,2
add     edi,eax

push    edi
mov     al,248
mov     ecx,16
rep     stosb
rept    16
mov     [byte ptr edi],al
add     edi,320
endm
pop     edi
rept    16
mov     [byte ptr edi],al
add     edi,320
endm
mov     ecx,17
rep     stosb
jmp     @@99

@@1bp_col:
and     [foregr_color],1
mov     al,[foregr_color]
shl     eax,5
shl     eax,8
add     edi,eax
shr     eax,2
add     edi,eax

push    edi
mov     al,248
mov     ecx,16
rep     stosb
rept    32
mov     [byte ptr edi],al
add     edi,320
endm
pop     edi
rept    32
mov     [byte ptr edi],al
add     edi,320
endm
mov     ecx,17
rep     stosb
jmp     @@99

@@snes_col:
mov     ebx,eax
and     al,7
and     bl,8
shl     eax,3
shl     eax,8
add     edi,eax
shr     eax,2
add     edi,eax
add     edi,ebx

push    edi
mov     al,248
mov     ecx,8
rep     stosb
rept    8
mov     [byte ptr edi],al
add     edi,320
endm
pop     edi
rept    8
mov     [byte ptr edi],al
add     edi,320
endm
mov     ecx,9
rep     stosb

@@99:
popad
ret
ENDP    Hilight_Color

PROC    Hilight_Tile

cmp     [clipboard_tile],8*17
je      @@99

pushad

mov     edi,offset virtual_screen + (320*17+160)
movzx   eax,[clipboard_tile]
mov     ecx,17
xor     edx,edx
div     ecx
shl     eax,3
shl     eax,8
add     edi,eax
shr     eax,2
add     edi,eax
shl     edx,3
add     edi,edx

push    edi
mov     al,248
mov     ecx,7
rep     stosb
rept    7
mov     [byte ptr edi],al
add     edi,320
endm
pop     edi
rept    7
mov     [byte ptr edi],al
add     edi,320
endm
mov     ecx,8
rep     stosb

popad
@@99:
ret
ENDP    Hilight_Tile

PROC    StrToLower
pushad

@@10:
cmp     [byte ptr esi],41h
jb      @@not_upper
cmp     [byte ptr esi],5Ah
ja      @@not_upper
add     [byte ptr esi],20h
@@not_upper:
inc     esi
cmp     [byte ptr esi],0
jnz     @@10

popad
ret
ENDP    StrToLower

PROC    FindExtension

@@10:
cmp     [byte ptr esi],0
je      @@eos
inc     esi
jmp     @@10
@@eos:
dec     esi
cmp     [byte ptr esi],'.'
jnz     @@eos
inc     esi

ret
ENDP    FindExtension

end     start
