bits 64
section .data
  map db "#################@.............##..............##..............##..............##..............##..............##..............##..............##..............##..............##..............##.............S#################"
  LENGHT equ $ - map
  LEN equ 16 ; longueur d'une ligne
  LINES equ (LENGHT / LEN) - 1 ; nombre de lignes
  cr db 10 ; caractère de retour à la ligne

section .bss
  action resb 1 ; buffer pour les actions ; 2 car le caractère retour à la ligne

section .text
  global _start

_start:
  xor r8, r8
  lea r10, [map + 17] ; dans r10 : emplacement du joueur
  mov r9, map ; ajout de map dans r9  

.print_map:
  mov rax, 1 
  mov rdi, 1
  mov rsi, r9
  mov rdx, LEN
  syscall ; affichage de la première ligne
  mov rax, 1
  mov rdi, 1
  mov rsi, cr
  mov rdx, 1
  syscall ; affichage du retour à la ligne
  inc r8 ; incrémentation de r8 
  add r9, LEN ; ajout de la longueur d'une ligne à r9, ce qui va décaler le pointeur de 12 par rapport à map à chaque tour pour afficher la ligne suivant en dessous de la précédente
  cmp r8, LINES ; comparaison pour l'affichage complet de la map en fonctione du nombre de lignes
  jle .print_map ; si le nombre de lignes est atteint, on continue le programme, sinon c'est qu'il y a encore des lignes à afficher

.game:
  xor r8, r8 ; remise à zéro du compteur
  mov r9, map ; remise du pointeur de la map au début
  mov rax, 0
  mov rdi, 0
  lea rsi, [action]
  mov rdx, 1
  syscall ; on lit la lettre action
  cmp [action], 122
  je .top ; si la lettre est z on monte
  cmp [action], 113
  je .left ; si la lettre est q on part à gauche
  cmp [action], 115
  je .down ; si la lettre est s on descend
  cmp [action], 100
  je .right ; si la lettre est d on part à droite
  cmp [action], 97
  je .quit ; si la lettre est a on quitte
  jmp .game ; si la lettre n'est pas reconnu on retourne à .game

.top:; comparer au caractère à l'adresse actuelle - 16 ; # : 35 ; . : 46 ; S : 83 ; @ : 64
  cmp byte [r10 - 16], 35 ; compare le caractère au dessus (soit 16 emplacements mémoire avant) avec 35, caractère du #
  je .print_map
  mov byte [r10 - 16], 64 ; si ce n'est pas un #, on met un arobase à la nouvelle position du joueur
  mov byte [r10], 46 ; et on met un point à la position du joueur
  lea r10, [r10 - 16] ; on met à jour la position du joueur dans le registre
  jmp .print_map

.left:
  cmp byte [r10 - 1], 35 ; compare le caractère au dessus (soit 16 emplacements mémoire avant) avec 35, caractère du #
  je .print_map
  mov byte [r10 - 1], 64 ; si ce n'est pas un #, on met un arobase à la nouvelle position du joueur
  mov byte [r10], 46 ; et on met un point à la position du joueur
  lea r10, [r10 - 1] ; on met à jour la position du joueur dans le registre
  jmp .print_map

.down:
  cmp byte [r10 + 16], 35 ; compare le caractère au dessus (soit 16 emplacements mémoire avant) avec 35, caractère du #
  je .print_map
  mov byte [r10 + 16], 64 ; si ce n'est pas un #, on met un arobase à la nouvelle position du joueur
  mov byte [r10], 46 ; et on met un point à la position du joueur
  lea r10, [r10 + 16] ; on met à jour la position du joueur dans le registre
  jmp .print_map

.right:
  cmp byte [r10 + 1], 35 ; compare le caractère au dessus (soit 16 emplacements mémoire avant) avec 35, caractère du #
  je .print_map
  mov byte [r10 + 1], 64 ; si ce n'est pas un #, on met un arobase à la nouvelle position du joueur
  mov byte [r10], 46 ; et on met un point à la position du joueur
  lea r10, [r10 + 1] ; on met à jour la position du joueur dans le registre
  jmp .print_map

.quit:
  jmp .end

; passer en paramètre dans un registre (r14) la valeur ascii du caractère à vérifier via un jmp pour que l'on revienne après dans le cours du programme

.end:
  mov rax, 60
  xor rdi, rdi
  syscall
