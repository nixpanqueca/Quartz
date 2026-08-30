; Programa Aether: ponto de entrada.
; O kernel carrega o binario flat em PROGRAM_BASE e chama o endereco base,
; que aqui executa o Main do programa (cdecl -> simbolo _Main) e retorna.

bits 32

global _start
extern _Main

section .text

_start:
    call _Main
    ret
