global get_words
global compare_func
global sort

extern strtok
extern strlen
extern strcmp
extern qsort

section .data
    delimiters: db " .,", 0xa, 0x0

section .text

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografic
sort:  
    enter 0, 0
    push edi            ; callee preserved
    push esi
    push ebx

    mov edi, [ebp + 8]  ; words
    mov ecx, [ebp + 12] ; num_of_words
    mov esi, [ebp + 16] ; size

    ; qsort (void *base, int nitems, int size, int (*compare_func) (char *a, char *b))
    push dword compare_func
    push esi
    push ecx
    push edi
    call qsort

    ; clean the stack
    add esp, 16

    ; restore the registers
    pop ebx
    pop esi
    pop edi
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0
    push edi            ; callee preserved
    push esi
    push ebx

    mov edi, [ebp + 8]  ; s
    mov esi, [ebp + 12] ; words
    mov ecx, [ebp + 16] ; number_of words

    xor ebx, ebx
    push ecx            ; strtok will change its value

    ; word = strtok(s, delim)
    push delimiters
    push edi
    call strtok

    ; clean the stack
    add esp, 8

    ; restore the registers
    pop ecx
    inc ebx
    cmp ebx, ecx
    jle while

while:
    mov [esi + ebx * 4 - 4], eax  ; words[i] = word
    push ecx                      ; strtok will change its value

    ; word = strtok(NULL, delimiters)    
    push delimiters
    push dword 0
    call strtok

    ; clean the stack
    add esp, 8

    pop ecx
    inc ebx
    cmp ebx, ecx                   ; verify if all the words were found
    jle while

    ; restore the registers
    pop ebx
    pop esi
    pop edi
    leave
    ret

;; int compare_func(char *str1, char *str2)
; compares the 2 strings by their length and if they are 
; equal compares them lexicographicaly 
compare_func:           
    enter 0, 0
    push edi            ; callee preserved
    push esi
    push ebx

    mov edi, [ebp + 8]  ; str1
    mov esi, [ebp + 12] ; str2
    
    push dword[edi]
    call strlen
    add esp, 4

    xor ebx, ebx        ; ebx will keep the difference of lengths
    mov ebx, eax
    push ebx            ; preserve its value

    push dword[esi]
    call strlen         ; it is ok to use strlen, strtok puts the string terminator
    add esp, 4

    pop ebx
    sub ebx, eax
    mov eax, ebx        ; the return value in eax
    cmp eax, 0          ; if the 2 lengths are equal compare them lexicographicaly
    jne exit

compare_lexicographic:
    push dword[esi]
    push dword[edi]
    call strcmp
    add esp, 8

exit:
    pop ebx
    pop esi
    pop edi
    leave
    ret
