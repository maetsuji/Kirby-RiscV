.data

# Numero de Notas a tocar
DURACAO: 174

# lista de nota,dura  o,nota,dura  o,nota,dura  o,...
NOTAS: 53,183,60,183,67,183,69,183,65,183,48,183,52,183,59,183,66,183,67,183,64,183,47,183,50,183,57,183,64,183,65,183,62,183,47,183,52,183,59,183,66,183,69,183,67,183,52,183,53,183,60,183,67,183,69,183,65,183,48,183,52,183,59,183,66,183,67,183,64,183,47,183,50,183,57,183,64,183,65,183,62,183,60,183,67,183,62,183,55,183,57,183,58,183,59,183,64,549,65,183,67,366,62,1098,60,549,62,183,63,366,58,1098,60,366,62,366,63,366,72,366,70,366,68,366,67,1098,62,1098,64,549,65,183,67,366,62,1098,60,549,62,183,63,366,58,1098,60,366,62,366,63,366,62,732,55,366,60,2196,76,183,76,183,72,183,72,183,69,183,69,183,72,183,72,183,69,183,69,183,76,183,76,183,74,183,74,183,71,183,71,183,67,183,67,183,71,183,71,183,67,183,67,183,74,183,74,183,72,183,72,183,69,183,69,183,65,183,65,183,69,183,69,183,65,183,65,183,72,183,72,183,71,183,71,183,67,183,67,183,64,183,64,183,67,183,67,183,64,183,64,183,70,183,70,183,76,183,76,183,72,183,72,183,69,183,69,183,72,183,72,183,69,183,69,183,76,183,76,183,74,183,74,183,71,183,71,183,67,183,67,183,71,183,71,183,67,183,67,183,74,183,74,183,72,183,72,183,69,183,69,183,65,183,65,183,69,183,69,183,65,183,65,183,74,183,74,183,72,183,72,183,69,183,69,183,72,183,72,183,79,183,74,183,78,183,81,183,79,183,60,183

NOTEENDTIME: .word 0

NOTECOUNTER: .word 0

.text

la s4,NOTAS			# define o endereçoinicial das notas -- PRECISA SER FORA DO LOOP PRINCIPAL

MAIN:

###
### ~ inicio do programa ~
###

MUSICLOOP:	
			

	ISNOTEOVER: # checa se a nota atual já acabou de tocar
			lw s6,NOTEENDTIME	# salva o tempo do fim da nota em s6
			beqz s6,PLAYNOTE	# vai pro musicloop se s6 valer 0 (primeira nota da musica)
			li a7,30		# ecall 30 - TIME - salva em a0 o tempo do programa
			ecall
			bge a0,s6,PLAYNOTE	# se o tempo atual for maior que o fim da nota, vai pro MUSICLOOP
	        	j ENDMUSICLOOP		# vai pro resto do game loop / repete a comparacao do fim da nota
	        
	PLAYNOTE:	
			li a2,0			# define o instrumentO	- PIANO
			li a3,64		# define o volume		- 64
			lw a0,0(s4)		# le o valor da nota
			lw a1,4(s4)		# le a duracao da nota
			li a7,31		# define a chamada de syscall
			ecall			# toca a nota
		
			li a7,30		
			ecall			# ecall 30 - TIME - salva em a0 o tempo do programa
			lw s6,4(s4)		# carrega a duracao em milissegundos da nota
			add s6,s6,a0		# soma o tempo atual com a duraÃ§Ã£o da nota 
			sw s6,NOTEENDTIME,t6	# salva o valor do fim da nota (valor de s6) em NOTEENDTIME
		
		
			lw s6, NOTECOUNTER	# carregando o numero da nota atual (valor de NOTECOUNTER) em s6
			lw s5, DURACAO		# carregando o numero total de notas
			beq s6,s5,RESTARTMUSIC	# comparar se Ã© a ultima nota (pra loopar a musica)
			addi s6,s6,1		# incrementa o contador de notas
			addi s4,s4,8		# incrementa para o endereco da proxima nota
			sw s6,NOTECOUNTER,t6	# salva o valor de t4 no contador de notas (nessaparte do programa, estamos carregando NOTECOUNTER em s6, fazemos s6++, e carregamos de volta o valor)
			j ENDMUSICLOOP		# volta pro teste se a nota acabou
		
	RESTARTMUSIC:
			li s6,0
			sw s6,NOTECOUNTER,t6	# zera o NOTECOUNTER
			la s4,NOTAS		# define o endereço das notas / zera o ponteiro
	
	
ENDMUSICLOOP:
 
###
### ~ resto do programa ~
###

j MAIN 		# loopa main
