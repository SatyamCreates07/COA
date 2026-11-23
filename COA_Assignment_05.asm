%macro WRITE 2
    mov rax, 01H
    mov rdi, 01H
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro
%macro READ 2
    mov rax, 00H
    mov rdi, 00H
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro
%macro EXIT 0
    mov rax, 60
    mov rdi, 00
    syscall
%endmacro
section .data
menu db 10, "1. Successive Addition", 10
     db "2. Shift and Add", 10
     db "3. Exit", 10
     db "Enter Your Choice: "
menulen equ $-menu
msg1 db "Enter two numbers:", 10
len1 equ $-msg1
msg2 db "Multiplication is: "
len2 equ $-msg2
msg7 db "Invalid choice", 10
len7 equ $-msg7
section .bss
char_buff resb 17
act1      resq 1
m         resq 1
n         resq 1
ans       resq 1
A         resq 1
Q         resq 1
M         resq 1
choice    resb 2
section .text
global _start
_start:
    WRITE msg1, len1
    call accept
    mov [m], rbx
    call accept
    mov [n], rbx
printmenu:
    WRITE menu, menulen
    READ choice, 02
    cmp byte [choice], 31H
    je succadd
    cmp byte [choice], 32H
    je shiftnadd
    cmp byte [choice], 33H
    je exit
    WRITE msg7, len7
    jmp printmenu
; ==================================
; SUCCESSIVE ADDITION
; ==================================
succadd:
    mov rbx, 00
    mov rcx, [n]
l1:
    add rbx, [m]
    dec rcx
    jnz l1
    mov [ans], rbx
    WRITE msg2, len2
    mov rbx, [ans]
    call display
    jmp printmenu
; ==================================
; SHIFT AND ADD
; ==================================
shiftnadd:
    mov qword [A], 00H
    mov rbx, [m]
    mov [M], rbx
    mov rbx, [n]
    mov [Q], rbx
    mov rcx, 64
l2:
    mov rbx, [Q]
    and rbx, 01H
    jz shiftaq
    mov rbx, [M]
    add [A], rbx
shiftaq:
    shr qword [Q], 01H
    mov rbx, [A]
    and rbx, 01H
    jz shifta
    mov rbx, 01
    ror rbx, 01
    or [Q], rbx
shifta:
    shr qword [A], 01H
    dec rcx
    jnz l2
    WRITE msg2, len2
    mov rbx, [A]
    call display
    mov rbx, [Q]
    call display
    jmp printmenu
; ==================================
; EXIT
; ==================================
exit:
    EXIT
; ==================================
; ACCEPT HEXADECIMAL NUMBER
; ==================================
accept:
    READ char_buff, 17
    dec rax
    mov [act1], rax
    mov rsi, char_buff
    mov rbx, 00H
up:
    shl rbx, 04H
    mov rdx, 00H
    mov dl, [rsi]
    cmp dl, 39H
    jbe sub30
    sub dl, 07H
sub30:
    sub dl, 30H
    add rbx, rdx
    inc rsi
    dec qword [act1]
    jnz up
    ret
; ==================================
; DISPLAY HEXADECIMAL RESULT
; ==================================
display:
    mov rsi, char_buff
    mov rcx, 16
above:
    rol rbx, 04H
    mov dl, bl
    and dl, 0FH
    cmp dl, 09H
    jbe add30
    add dl, 07H
add30:
    add dl, 30H
    mov [rsi], dl
    inc rsi
    dec rcx
    jnz above
    WRITE char_buff, 16
    Ret
