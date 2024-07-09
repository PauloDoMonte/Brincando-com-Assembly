section .bss
    num1 resb 10       ; buffer para o primeiro número
    num2 resb 10       ; buffer para o segundo número
    result resb 20     ; buffer para o resultado
    result_end resb 1  ; fim da string do resultado

section .text
    global _start

_start:
    ; Ler o primeiro número
    mov eax, 0        ; syscall número para sys_read
    mov edi, 0        ; file descriptor 0 (stdin)
    mov rsi, num1     ; buffer para armazenar o número
    mov edx, 10       ; número máximo de bytes a ler
    syscall

    ; Converter o primeiro número de string para inteiro
    mov rsi, num1
    call string_to_int
    mov rbx, rax      ; armazenar o primeiro número em rbx

    ; Ler o segundo número
    mov eax, 0        ; syscall número para sys_read
    mov edi, 0        ; file descriptor 0 (stdin)
    mov rsi, num2     ; buffer para armazenar o número
    mov edx, 10       ; número máximo de bytes a ler
    syscall

    ; Converter o segundo número de string para inteiro
    mov rsi, num2
    call string_to_int

    ; Somar os dois números
    add rax, rbx

    ; Converter o resultado de inteiro para string
    mov rsi, result_end ; mover para o final do buffer
    call int_to_string
    mov rsi, result

    ; Escrever o resultado
    mov eax, 1        ; syscall número para sys_write
    mov edi, 1        ; file descriptor 1 (stdout)
    mov edx, result_end-result ; calcular o tamanho da string
    syscall

    ; Sair do programa
    mov eax, 60       ; syscall número para sys_exit
    xor edi, edi      ; código de saída 0
    syscall

; Função para converter string para inteiro
string_to_int:
    xor rax, rax      ; zerar rax para armazenar o resultado
    xor rcx, rcx      ; zerar rcx para o multiplicador
convert_loop:
    movzx rdx, byte [rsi + rcx]
    cmp rdx, 10       ; checar se é uma nova linha (entrada)
    je done_convert
    sub rdx, '0'      ; converter caractere para valor numérico
    imul rax, rax, 10 ; multiplicar o resultado atual por 10
    add rax, rdx      ; adicionar o dígito ao resultado
    inc rcx           ; incrementar o índice
    jmp convert_loop
done_convert:
    ret

; Função para converter inteiro para string
int_to_string:
    xor rdx, rdx      ; zerar rdx para armazenar os dígitos
    mov rcx, 10       ; divisor base 10
convert_to_string:
    xor rbx, rbx
    div rcx           ; dividir rax por 10
    add dl, '0'       ; converter o dígito para caractere
    dec rsi           ; mover o ponteiro do buffer para trás
    mov [rsi], dl     ; armazenar o dígito no buffer
    test rax, rax
    jnz convert_to_string
    ret
