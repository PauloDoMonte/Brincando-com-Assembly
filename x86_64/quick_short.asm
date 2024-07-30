section .data
    array db 25, 17, 31, 13, 2, 40, 16, 37
    array_len equ $ - array

section .bss
    ; Espaço reservado para variáveis temporárias
    temp resb 1

section .text
    global _start

_start:
    ; Inicializa os parâmetros
    mov rdi, array          ; Ponteiro para o array
    mov rsi, 0              ; Índice inicial
    mov rdx, array_len - 1  ; Índice final

    ; Chama a função de quick sort
    call quicksort

    ; Saída do programa
    mov eax, 60             ; syscall: exit
    xor edi, edi            ; status: 0
    syscall

quicksort:
    ; Parâmetros:
    ; rdi - ponteiro para o array
    ; rsi - índice inicial
    ; rdx - índice final

    ; Verifica se rsi é maior ou igual a rdx
    cmp rsi, rdx
    jge .done

    ; Particiona o array e obtém o índice do pivô
    mov rcx, rsi            ; Índice inicial
    mov r8, rdx             ; Índice final
    call partition

    ; Ordena a partição esquerda
    mov rdx, rcx
    sub rdx, 1
    call quicksort

    ; Ordena a partição direita
    mov rsi, rcx
    add rsi, 1
    mov rdx, r8
    call quicksort

.done:
    ret

partition:
    ; Parâmetros:
    ; rdi - ponteiro para o array
    ; rsi - índice inicial
    ; rdx - índice final

    ; Escolhe o pivô (aqui, o pivô é o elemento final)
    mov r8, rdx             ; r8 = índice final
    mov al, [rdi + r8]      ; al = array[r8]

    ; Inicializa os índices i e j
    mov rcx, rsi            ; rcx = índice inicial
    mov r9, rsi             ; r9 = índice inicial - 1

.next:
    ; Verifica se rcx é maior ou igual a r8
    cmp rcx, r8
    jge .done_partition

    ; Compara array[rcx] com o pivô
    mov bl, [rdi + rcx]     ; bl = array[rcx]
    cmp bl, al
    jg .skip

    ; Incrementa o índice r9 e troca array[r9] com array[rcx]
    inc r9
    mov dl, [rdi + r9]
    mov [rdi + r9], bl
    mov [rdi + rcx], dl

.skip:
    ; Incrementa o índice rcx
    inc rcx
    jmp .next

.done_partition:
    ; Troca array[r9+1] com o pivô
    inc r9
    mov dl, [rdi + r9]
    mov [rdi + r9], al
    mov [rdi + r8], dl

    ; Retorna o índice do pivô
    mov rcx, r9
    ret
