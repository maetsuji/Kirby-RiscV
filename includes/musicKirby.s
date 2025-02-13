.data

# Numero de Notas a tocar
Duracao1: 	.word 174

# lista de nota,duracao,nota,duracao,nota,duracao,...
Notas1: 	.half 53,183,60,183,67,183,69,183,65,183,48,183,52,183,59,183,66,183,67,183,64,183,47,183,50,183,57,183,64,183,65,183,62,183,47,183,52,183,59,183,66,183,69,183,67,183,52,183,53,183,60,183,67,183,69,183,65,183,48,183,52,183,59,183,66,183,67,183,64,183,47,183,50,183,57,183,64,183,65,183,62,183,60,183,67,183,62,183,55,183,57,183,58,183,59,183,64,549,65,183,67,366,62,1098,60,549,62,183,63,366,58,1098,60,366,62,366,63,366,72,366,70,366,68,366,67,1098,62,1098,64,549,65,183,67,366,62,1098,60,549,62,183,63,366,58,1098,60,366,62,366,63,366,62,732,55,366,60,2196,76,183,76,183,72,183,72,183,69,183,69,183,72,183,72,183,69,183,69,183,76,183,76,183,74,183,74,183,71,183,71,183,67,183,67,183,71,183,71,183,67,183,67,183,74,183,74,183,72,183,72,183,69,183,69,183,65,183,65,183,69,183,69,183,65,183,65,183,72,183,72,183,71,183,71,183,67,183,67,183,64,183,64,183,67,183,67,183,64,183,64,183,70,183,70,183,76,183,76,183,72,183,72,183,69,183,69,183,72,183,72,183,69,183,69,183,76,183,76,183,74,183,74,183,71,183,71,183,67,183,67,183,71,183,71,183,67,183,67,183,74,183,74,183,72,183,72,183,69,183,69,183,65,183,65,183,69,183,69,183,65,183,65,183,74,183,74,183,72,183,72,183,69,183,69,183,72,183,72,183,79,183,74,183,78,183,81,183,79,183,60,183

.text

MusicLoop: # a0, tempo atual em ms
	addi sp,sp,-20
	sw ra,0(sp)
	sw s0,4(sp)
	sw s1,8(sp)
	sw s2,12(sp)
	sw s3,16(sp)

	mv s0,a0
	lw s1,MusicAtual

	IsNoteOver: # checa se a nota atual j� acabou de tocar
		lw s2,NoteEndTime	# salva o tempo do fim da nota em s2
		beqz s2,PlayNote	# vai pro musicloop se s2 valer 0 (primeira nota da musica)
		#li a7,30		# ecall 30 - TIME - salva em a0 o tempo do programa
		#ecall
		bge s0,s2,PlayNote	# se o tempo atual for maior que o fim da nota, vai pro PlayNote
        	j EndMusicLoop		# vai pro resto do game loop / repete a comparacao do fim da nota
	        
	PlayNote:	
		li a2,0			# define o instrumento	- PIANO
		li a3,64		# define o volume		- 64
		lhu a0,0(s1)		# le o valor da nota
		lhu a1,2(s1)		# le a duracao da nota
		#li a7,31		# define a chamada de syscall
		#ecall			# toca a nota
	
		jal midiOut
	
		#li a7,30		
		#ecall			# ecall 30 - TIME - salva em a0 o tempo do programa
		lw t0,LastGlblTime
		
		lhu t1,2(s1)		# carrega a duracao em milissegundos da nota
		add t1,t1,t0		# soma o tempo atual com a duracao da nota 
		sw t1,NoteEndTime,t6	# salva o valor do fim da nota (valor de s2) em NoteEndTime
	
	
		lw s3,NoteCounter	# carregando o numero da nota atual (valor de NoteCounter) em s2
		lw t0,LenMusAtual	# carregando o numero total de notas
		beq s3,t0,RestartMusic	# comparar se foi a ultima nota (pra loopar a musica)
		
		addi s3,s3,1		# incrementa o contador de notas
		addi s1,s1,4		# incrementa para o endereco da proxima nota
		sw s3,NoteCounter,t6	# salva o valor de t4 no contador de notas (nessa parte do programa, estamos carregando NoteCounter em t0, fazemos t0++, e carregamos de volta o valor)
		j EndMusicLoop		# volta pro teste se a nota acabou
	
	RestartMusic:
		li s3,0
		sw s3,NoteCounter,t6	# zera o NoteCounter
		lw s1,MusicStartAdd	# define o endere�o das notas / zera o ponteiro
	
	
EndMusicLoop:
	sw s1,MusicAtual,t0
	
	lw ra,0(sp)
	lw s0,4(sp)
	lw s1,8(sp)
	lw s2,12(sp)
	lw s3,16(sp)
	addi sp,sp,20
	
	ret
	
#############
	
.eqv NoteData           0xFF200178
.eqv NoteClock          0xFF20017C
.eqv NoteMelody         0xFF200180
.eqv MusicTempo         0xFF200184
.eqv MusicAddress       0xFF200188

midiOut:
	DE1(t0,midiOutDE2)
	
	li a7,31		# Chama o ecall normal
	ecall
	j fimmidiOut
	
midiOutDE2:	li      t0, NoteData
    		add     t1, zero, zero

    		# Melody = 0

    		# Definicao do Instrumento
   	 	andi    t2, a2, 0x0000000F
    		slli    t2, t2, 27
    		or      t1, t1, t2

    		# Definicao do Volume
    		andi    t2, a3, 0x0000007F
    		slli    t2, t2, 20
    		or      t1, t1, t2

    		# Definicao do Pitch
    		andi    t2, a0, 0x0000007F
    		slli    t2, t2, 13
    		or      t1, t1, t2

    		# Definicao da Duracao
		li 	t4, 0x1FF
		slli 	t4, t4, 4
		addi 	t4, t4, 0x00F			# t4 = 0x00001FFF
    		and    	t2, a1, t4
    		or      t1, t1, t2

    		# Guarda a definicao da duracao da nota na Word 1
    		j       SintMidOut

SintMidOut:	sw	t1, 0(t0)

	    		# Verifica a subida do clock AUD_DACLRCK para o sintetizador receber as definicoes
	    		li      t2, NoteClock
Check_AUD_DACLRCK:     	lw      t3, 0(t2)
    			beq     t3, zero, Check_AUD_DACLRCK

fimmidiOut:    		ret

