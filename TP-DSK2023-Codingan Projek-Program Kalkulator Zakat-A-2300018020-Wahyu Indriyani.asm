.model small
.code
org 100h

jmp mulai:

.data

  
    daftar   db 13,10,'+===================================================+'
             db 13,10,'|            KALKULATOR ZAKAT PENGHASILAN           |'
             db 13,10,'+===================================================+'
             db 13,10,'| Nisab : Rp. 6.828.806                              |'
             db 13,10,'+===================================================+' 
             db 13,10,'|Terdapat beberapa aturan inputan                   |'
             db 13,10,'|1. Masukkan penghasilan diatas batas nisab         |'  
             db 13,10,'|2. Nilai inputan 1.000.000 = 100, krn daya tampung |'
             db 13,10,'|   register tidak mencukupi                        |'
             db 13,10,'|3. Berarti nilai nisabnya : Rp.682                  |'
             db 13,10,'+===================================================+'
             db 13,10,'| Proses = penghasilan * 25 / 1000                  |'
             db 13,10,'+===================================================+'

         
    penghasilan             db 13,10,' PENGHASILAN PERBULAN          :Rp. $'
    tampung_penghasilan     dw ?
    nilai_zakat             dw ?
    result                  db 13,10,' ZAKAT YANG HARUS DIBAYAR      :Rp. $'
    garis                   db 13,10,'+===================================================+$'
    pesan                   db 13,10,'| Hasil zakat dikalikan 10.000, atau tambahkan 0    |'
    pesan1                  db 13,10,'| sebanyak 4 dibelakang hasil zakat                 |$'
    pesan2                  db 13,10,'| Terima kasih telah menggunakan kalkulator ini     |$'
    cls                     db 13,10,'Menutup program.... $'
 
 
mulai: 
    mov ax,@data
    mov ds,ax
    
    mov ah,09h
    lea dx,daftar
    int 21h
    
    mov ax,0
    MOV tampung_penghasilan, AX
    
    MOV DL,10
    MOV BL,0

ScanNum:
    MOV AH, 01H
    INT 21H
    CMP AL, 13
    JE EndScanNum
    MOV AH,0
    SUB AL, 48
    MOV CL, AL
    MOV AL, BL
    MUL DL
    ADD AL, CL
    ADC AH, 0
    MOV BX, AX
    JMP ScanNum

EndScanNum:
    MOV tampung_penghasilan, BX
    MOV AX, 0
    MOV BX, tampung_penghasilan
 
proses:
  mov AX, 25
  imul tampung_penghasilan
  mov nilai_zakat,AX
 
  mov AX, nilai_zakat   ;nilai_zakat / 1000
  mov BX, 1000
  idiv BX
  mov nilai_zakat,AX
   
  lea dx, result        ; tampilkan nilai_zakat
  mov ah,09h
  int 21h

  mov ax, nilai_zakat  
  call PRINT_NUM
  
akhir:
  lea dx, garis
  mov ah,09h
  int 21h 
  
  lea dx, pesan
  mov ah,09h
  int 21h   
  
  lea dx, garis
  mov ah,09h
  int 21h       
  
  lea dx, pesan2
  mov ah,09h
  int 21h       
  
  lea dx, garis
  mov ah,09h
  int 21h
  
  lea dx, cls                                                    
  mov ah,09h
  int 21h

  int 20h

PRINT_NUM PROC
  PUSH AX
  PUSH BX
  PUSH CX
  PUSH DX
  
  MOV CX, 0

PRINT_LOOP:
  MOV BX, 10
  XOR DX, DX
  DIV BX
  PUSH DX
  INC CX
  TEST AX, AX
  
  JNZ PRINT_LOOP

PRINT_DIGITS:
  POP DX
  ADD DL, 48
  MOV AH, 02H
  INT 21H

LOOP PRINT_DIGITS
  POP DX
  POP CX
  POP BX
  POP AX
  
  RET
PRINT_NUM ENDP
