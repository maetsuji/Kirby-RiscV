.data

MapaPos:	.half 0, 0

PlayerPosX: 	.half 0		# posicao em pixels do jogador no eixo X (de 0 ate a largura do mapa completo)
PlayerPosY: 	.half 0		# posicao em pixels do jogador no eixo Y (de 0 ate a altura do mapa completo)
OldPlayerPos:	.word 1		# precisa comecar com um valor para ser comparado no Print (so roda se a posicao antiga for diferente da atual) 
PlayerSpeedX:	.half 0		# velocidade completa do jogador (em centenas) no eixo X, dividida por 100 para ser usada como pixels
PlayerSpeedY:	.half 0		# velocidade completa do jogador (em centenas) no eixo Y, dividida por 100 para ser usada como pixels
PlayerState:	.half 0		# 0 = jogador no ar, 1 = jogador no chao

.eqv playerMaxSpX 200
.eqv playerMaxFallSp 100
.eqv playerMaxJumpSp -4
.eqv playerAccX 100
.eqv playerDeaccX 25
.eqv playerJumpPow -600

.eqv GravityAcc 25

OffsetX:	.half 0		# quantidade de pixels que o jogador se moveu na horizontal que modificam a posicao do mapa 
OffsetY:	.half 0		# quantidade de pixels que o jogador se moveu na vertical que modificam a posicao do mapa  
OldOffset:	.word 1		# precisa comecar com um valor para ser comparado no PrintMapa (so roda se a posicao antiga for diferente da atual) 

BGTileCodes:	.word 0		# armazena 4 (bytes) codigos de tiles para que o tempBigBG seja montado no Limpar

LastKey: 	.word 0		# valor da ultima tecla pressionada

LastGlblTime:	.word 0		# valor completo da ecall 30, que sempre sera comparado e atualizado para contar os frames
FrameCount:	.word 0		# contador de frames, sempre aumenta para que possa ser usado como outros contadores (1 seg = rem 50; 0.5 seg = rem 25; etc.)
.eqv FPS 50

endl:		.string "\n"	# temporariamente sendo usado para debug (contador de ms)

.include "sprites/Ataque1.data"
.include "sprites/playerCol.data"
.include "sprites/chao.data"
.include "sprites/grama.data"
.include "sprites/emptyCol.data"
.include "sprites/plataforma1.data"
.include "sprites/plataforma1Col.data"
.include "sprites/plataforma2.data"
.include "sprites/plataforma2Col.data"
.include "sprites/plataforma3.data"
.include "sprites/plataforma3Col.data"
.include "sprites/blocoExemp.data"
.include "sprites/blocoExempCol.data"
.include "sprites/mapa40x30.data"
.include "sprites/mapa30x30.data"
.include "sprites/tempBigBG.data"

.text
	li t0,0xFF200604	# endereco que define qual frame esta sendo apresentado
	li t1,1
	#sw t1,0(t0)		# para visualizar o frame 1

	li s11,0x01E00280 	# s11,  grid 640x480
	#li s11,0x01E001E0 	# s11,  grid 480x480
				
#########################################################################################################################################
# as seguintes funcoes precisam ser chamadas antes do KeyPress, ja que ele atualiza o offset e a posicao do jogador e tornaria elas iguais aos valores antigos

	jal PrintMapa		# imprime o mapa na inicializacao
	
	la a0,Ataque1
	la a1,PlayerPosX
	la a2,OldPlayerPos
	la a3,playerCol
	jal Print		# imprime o jogador na inicializacao
	
	li a7,30
	ecall
	sw a0,LastGlblTime,t0	# define o primeiro valor do timer global, que sera comparado no Clock

Main:
	jal Clock
	
	jal KeyPress		# confere teclas apertadas, atualizando posicao do jogador e offset
	
	jal PlayerControls	# com base na ultima tecla apertada, salva em s10 pelo KeyPress, realiza as acoes de movimento do jogador
	
# toda funcao que muda posicao de personagens/objetos deve ser chamada antes de imprimi-los

	jal PrintMapa		# imprime o mapa usando o offset

	la a0,OldPlayerPos
	la a1,PlayerPosX
	jal Limpar		# limpa posicao antiga do jogador
	
	la a0,Ataque1
	la a1,PlayerPosX
	la a2,OldPlayerPos
	la a3,playerCol
	jal Print		#imprime o jogador em sua nova posicao

	j Main

#########################################################################################################################################
Clock: 
	li a7,30
	ecall			# salva o novo valor do tempo global
	mv s0,a0
	
	lw t0,LastGlblTime
	sub t0,a0,t0		# subtrai o novo tempo global pelo ultimo valor salvo, para definir quantos milissegundos passaram desde o ultimo frame
	
	mv a0,t0
	li a7,1
	ecall
	
	la a0,endl
	li a7,4
	ecall			# imprime a diferenca de milissegundos (apenas por debug)
	
	li t1,20		# a cada 20 ms o frame avanca em 1, o que equivale a 50 fps
	blt t0,t1,Clock		# enquanto nao avancar o frame o codigo fica nesse loop
	sw s0,LastGlblTime,t0	# atualiza o novo valor de tempo global
	
	lw s1,FrameCount
	addi s1,s1,1
	sw s1,FrameCount,t0 	# avanca o contador de frames
		
FimClock:
	ret			# depois de avancar o frame segue para o resto do codigo da main, basicamente definindo o framerate do jogo como 50 fps
	
#----------
KeyPress:
	li t0,0xFF200000		# carrega o endereco de controle do KDMMIO
	lw t2,0(t0)			# Le bit de Controle Teclado
	andi t2,t2,0x0001		# mascara o bit menos significativo
	lw t1,4(t0)  			# le o valor da tecla
	
	bne t2,zero,ContinueKP	
	mv t1,zero			# se nenhuma tecla esta sendo apertada salva 0 como a tecla atual
ContinueKP:

	sw t1,LastKey,t0		# atualiza a ultima tecla pressionada
	
specialKeys:

	li t0,'p'
  	beq t1,t0,EndGame
  	
  	ret
  	
#----------
EndGame:
	li a7,10
	ecall				# metodo temporario de finalizacao do jogo

#----------
PlayerControls: 
	addi sp,sp,-4
	sw ra,0(sp)			# pilha armazena apenas valor de retorno
			
	lw s0,LastKey			# s0, valor da ultima tecla apertada
	lhu s1,PlayerPosX		# s1, posicao X do jogador no mapa
	lhu s2,PlayerPosY		# s2, posicao Y do jogador no mapa
	
	mv t0,s2
	slli t0,t0,16
	add t0,t0,s1
	sw t0,OldPlayerPos,t1		# atualiza OldPlayerPos

HorizontalMove:
	lh s4,PlayerSpeedX		# s4, velocidade X do jogador em seu valor completo
	li t1,playerDeaccX		# t1, velocidade de desaceleracao do jogador no eixo X 
	li t2,playerAccX		# t2, velocidade de aceleracao do jogador no eixo X
	li t3,playerMaxSpX		# t3, velocidade maxima do jogador no eixo X
	
SlowLeftToRight:
	bgt s4,zero,SlowRightToLeft	# se velocidade for positiva ou 0 vai para o proximo slow
	li t0,'a'
	beq s0,t0,MoveLeft		# se velocidade for negativa e 'a' esta apertado nao ha porque desacelerar
	beq s4,zero,SlowRightToLeft	# se velocidade for zero ainda precisa conferir se 'd' esta sendo apertado
	
	add s4,s4,t1
	ble s4,zero,DoneHorizontalMv
	mv s4,zero			# se a velocidade ficou positiva ao desacelerar precisa voltar para zero
	j DoneHorizontalMv
	
SlowRightToLeft:
	li t0,'d'
	beq s0,t0,MoveRight		# se velocidade for positiva e 'd' esta apertado nao ha porque desacelerar
	beq s4,zero,DoneHorizontalMv	# se a velocidade for zero nesse ponto nao ha porque desacelerar o jogador
	
	sub s4,s4,t1
	bgt s4,zero,DoneHorizontalMv
	mv s4,zero			# se a velocidade ficou negativa ao desacelerar precisa voltar para zero
	j DoneHorizontalMv		
	
MoveLeft:
	sub s4,s4,t2			# aumenta velocidade para a esquerda
	
	sub t0,zero,s4
	ble t0,t3,DoneHorizontalMv
	sub s4,zero,t3			# velocidade se torna a velocidade maxima caso tenha a ultrapassado
	j DoneHorizontalMv
	
MoveRight:
	add s4,s4,t2			# aumenta velocidade para a direita
	
	ble s4,t3,DoneHorizontalMv
	mv s4,t3			# velocidade se torna a velocidade maxima caso tenha a ultrapassado
	j DoneHorizontalMv
	
DoneHorizontalMv:
	sh s4,PlayerSpeedX,t0		# armazena a velocidade X completa do jogador (em centenas)
	li t0,100
	div t1,s4,t0			# divide a velocidade por 100 para obter o numero de pixels a se mover
	
	add s1,s1,t1			# adiciona a velocidade horizontal em pixels para a posicao do jogador
	
VerticalMove:
	lh s5,PlayerSpeedY		# s5, velocidade X do jogador em seu valor completo
	lhu t1,PlayerState		# t1, variavel de estado do jogador
	li t2,GravityAcc		# t2, velocidade de aceleracao da gravidade
	li t3,playerMaxFallSp		# t3, velocidade maxima de queda do jogador
	
	li t0,'w'
	beq s0,t0,MoveJump		
	
	beq t1,zero,MoveFall		# se estado do jogador for 0 ele esta caindo (a posicao dessa linha no codigo determina es pulo no ar e possivel)
	
	blt s5,zero,DoneVerticalMv	# se ojogador estiver indo para cima o chao nao para ele (impede um snap que estava acontecendo)
	mv s5,zero 		 	# se o jogador nao estiver no ar ou tiver pulado, esta no chao e sua velocidade Y se torna zero
	j DoneVerticalMv

MoveJump:
	li s5,playerJumpPow
	j DoneVerticalMv

MoveFall:	# se estado for 0 entao o jogador esta caindo
	add s5,s5,t2			# adiciona a gravidade a velocidade do jogador
	ble s5,t3,DoneVerticalMv
	mv s5,t3			# velocidade se torna a velocidade maxima caso tenha a ultrapassado
	j DoneVerticalMv

DoneVerticalMv:	
	sh s5,PlayerSpeedY,t0		# armazena a velocidade Y completa do jogador (em centenas)
	li t0,100
	div t1,s5,t0			# divide a velocidade por 100 para obter o numero de pixels a se mover
	
	li t0,playerMaxJumpSp
	bge t1,t0,DontLimitJump		# como o jogador nao pode se mover mais de 4 pixels por frame para as colisoes funcionarem, a vel do pulo fica limitada a -4
	mv t1,t0
DontLimitJump:
	
	add s2,s2,t1			# adiciona a velocidade vertical em pixels para a posicao do jogador

FimMove:
	mv t0,s11
	slli t0,t0,16
	srli t0,t0,16	
	addi t0,t0,-16			# t0, tamanho da linha de pixels -16
	
	#li t0,304		
	blt s1,zero,FimKeyPress
	bgt s1,t0,FimKeyPress		# analisa se passou das bordas dos lados
	
	mv t0,s11
	srli t0,t0,16		
	addi t0,t0,-16			# t0, tamanho da coluna de pixels -16
	
	#li t0,224		
	blt s2,zero,FimKeyPress
	bgt s2,t0,FimKeyPress		# analisa se passou das bordas de cima e de baixo
	
	j PlayerColCheck
	
PlayerColCheck:
	li s3,0xff100000
	
	lhu t0,OffsetX
	sub t1,s1,t0			# subtrai X do jogador pelo offset X
	add s3,s3,t1
	
	lhu t0,OffsetY
	sub t0,s2,t0			# subtrai Y do jogador pelo offset Y
	li t1,320
	mul t1,t1,t0	
	
	add s3,s3,t1			# s3, inicialmente como o endereco para o primeiro pixel do jogador no frame 1 do bitmap
	
SetupPlayerFloor:	
	sh zero,PlayerState,t5		# determina que jogador esta no ar
	
	mv t0,s3
	li t1,4800 # 15 linhas do sprite x 320 pixels do bitmap
	add t0,t0,t1 
	li t2,56 # verde
	mv t3,zero
	li t4,4				# contador de pixels a analisar
PlayerFloor:
	lbu t1,0(t0)
	lbu t5,320(t0)
	bne t5,t2,DontSetGroundSt	# analisa pixels 1, 6, 11 e 16 da primeira linha abaixo do jogador
	li t6,1
	sh t6,PlayerState,t5		# se algum dos pixels logo abaixo do jogador forem de chao ele passa a estar no estado "no chao"
DontSetGroundSt:
	bne t1,t2,DontSnapUp		# analisa pixels 1, 6, 11 e 16 da ultima linha do jogador
	jal SnapUp
	j PlayerFloor			# repete enquanto colisao acontece
DontSnapUp:
	addi t0,t0,5			# avanca 5 pixels na linha
	addi t3,t3,1
	blt t3,t4,PlayerFloor
	
	
SetupPlayerCeiling:
	mv t0,s3
	li t2,7 # vermelho
	mv t3,zero
	li t4,4				# contador de pixels a analisar
PlayerCeiling:
	lbu t1,0(t0)
	bne t1,t2,DontSnapDown		# analisa primeiro pixel da primeira linha do jogador
	jal SnapDown			
	j PlayerCeiling			# repete enquanto colisao acontece
DontSnapDown:
	addi t0,t0,5			# avanca 5 pixels na linha
	addi t3,t3,1
	blt t3,t4,PlayerCeiling

		
SetupPlayerLWall:
	mv t0,s3
	li t2,192 # azul
	mv t3,zero
	li t4,4				# contador de pixels a analisar
PlayerLeftWall:
	lbu t1,0(t0)
	bne t1,t2,DontSnapRight		# analisa primeiro pixel da primeira linha do jogador
	jal SnapRight
	j PlayerLeftWall		# repete enquanto colisao acontece
DontSnapRight:
	addi t0,t0,1600			# avanca 5 linhas no sprite
	addi t3,t3,1
	blt t3,t4,PlayerLeftWall


SetupPlayerRWall:
	mv t0,s3
	li t2,192 # azul
	mv t3,zero
	li t4,4				# contador de pixels a analisar
PlayerRightWall:
	lbu t1,15(t0)
	bne t1,t2,DontSnapLeft		# analisa ultimo pixel da primeira linha do jogador
	jal SnapLeft
	j PlayerRightWall		# repete enquanto colisao acontece
DontSnapLeft:
	addi t0,t0,1600			# avanca 5 linhas no sprite
	addi t3,t3,1
	blt t3,t4,PlayerRightWall
	
	
SuccessfulMove:
	sh s1,PlayerPosX,t0		# armazena novo X do jogador
	sh s2,PlayerPosY,t0		# armazena novo Y do jogador
	
	##### definicao do offset:

	lw t1,OffsetX	
	sw t1,OldOffset,t0		# atualiza OldOffset
	
	li t0,152			# precisa parar sprite no pixel 153 do bitmap (contando de 1)
	bge s1,t0,ChangeOffsetX		# se e necessario mover a tela atualiza o offset
FimChangeOffsetX:

	li t0,112			# precisa parar sprite no pixel 109 do bitmap (contando de 1)
	bge s2,t0,ChangeOffsetY		# se e necessario mover a tela atualiza o offset
FimChangeOffsetY:
	
FimKeyPress:
	lw ra,0(sp)
	addi sp,sp,4			# recupera endereço de retorno da pilha

  	ret
  	

ChangeOffsetX:
	mv t0,s11
	slli t0,t0,16
	srli t0,t0,16			# tamanho X do mapa
			
	addi t0,t0,-168			# pixel mais a direita do mapa que muda o offset
	bgt s1,t0,MaxOffsetX		# se o jogador estiver no fim da tela, o offset sempre sera o maior possível

	li t1,152				
	sub t1,s1,t1			# offsetX = posicao real do jogador - 152

	sh t1,OffsetX,t2		# armazena novo offset X
	
	j FimChangeOffsetX
	
MaxOffsetX:
	li t1,152
	sub t0,t0,t1			# em t0 esta o valor maximo de X que altera o offset, entao e só subtrair metade da tela e 8 pixels do sprite
	
	sh t0,OffsetX,t2		# armazena novo offset X como o maior valor possivel 
	
	j FimChangeOffsetX

ChangeOffsetY:
	mv t0,s11
	srli t0,t0,16			# tamanho Y do mapa
			
	addi t0,t0,-128			# pixel mais baixo do mapa que muda o offset
	bgt s2,t0,MaxOffsetY

	li t1,112
	sub t1,s2,t1			# offsetY = posicao real do jogador - 112
	
	sh t1,OffsetY,t2		# armazena novo offset Y
	
	j FimChangeOffsetY
	
MaxOffsetY:
	li t1,112
	sub t0,t0,t1			# em t0 esta o valor maximo de Y que altera o offset, entao e só subtrair metade da tela e 8 pixels do sprite
	
	sh t0,OffsetY,t2		# armazena novo offset Y como o maior valor possivel 
	
	j FimChangeOffsetY

# s1, posição X original do sprite; s2, posição Y original do sprite; s3, endereço do pixel 0,0 do sprite no frame 1; t0, endereço do pixel de colisão sendo analisado no frame 1 
SnapUp:		# sobe o jogador em uma linha, loopando ate nao estar mais em colisao
	addi s2,s2,-1
	addi s3,s3,-320
	addi t0,t0,-320
	ret			
SnapDown: 	# desce o jogador em uma linha, loopando ate nao estar mais em colisao
	addi s2,s2,1	
	addi s3,s3,320
	addi t0,t0,320
	ret		
SnapLeft:	# move o jogador uma coluna para a esquerda, loopando ate nao estar mais em colisao
	addi s1,s1,-1
	addi s3,s3,-1
	addi t0,t0,-1
	ret		
SnapRight:	# move o jogador uma coluna para a esquerda, loopando ate nao estar mais em colisao
	addi s1,s1,1
	addi s3,s3,1
	addi t0,t0,1
	ret
	
#----------
Print: 		# a0 = sprite que vai ser impresso, a1 = endereco com a posicao do sprite, a2 = endereco com a posicao antiga do sprite, a3 = sprite de colisao
	
	lw t0,0(a1)
	lw t1,0(a2)
	beq t0,t1,FimPrint		# se a posicao nova for igual a antiga nao e necessaria realizar o print
	
	mv t0,a1
	
	lhu s0,0(t0)
	lhu s1,2(t0)			# salva posicao inicial do sprite	
	
	lhu t0,OffsetX
	sub t3,s0,t0			# subtrai o X do sprite pelo offset X
	lhu t0,OffsetY			
	sub t4,s1,t0			# subtrai o Y do sprite pelo offset Y
	
	li t1,320
	li t2,240
	rem t3,t3,t1			# corrige a posicao no bitmap quando ela passa do 320x240 inicial
	rem t4,t4,t2			# tecnicamente desnecessario por causa do offset, mas mantido por garantia e para testes que mudam a posicao manualmente
	
	li t0,0xff000000
	
	add t0,t0,t3 			# adiciona x ao endereco do bitmap
	
	mul t1,t1,t4
	add t0,t0,t1 			# adiciona y ao endereco do bitmap
	
	addi t1,a0,8 			# endereco do sprite mais 8
	
	mv t2,zero
	mv t3,zero
	
	lw t4,0(a0) 			# guarda a largura do sprite
	lw t5,4(a0) 			# guarda a altura do sprite
		
	li a6,0x100000			# para o mapa de colisao	
	
Linha: 		# t0 = endereco do bitmap display; t1 = endereco do sprite
	lbu t6,0(t1) 			# guarda um pixel do sprite (nao pode ser word por nao estar sempre alinhado com o endereco)
	sb t6,0(t0) 			# desenha no bitmap display (4 pixels separadamente)
	lbu t6,1(t1) 			
	sb t6,1(t0) 			
	lbu t6,2(t1) 			
	sb t6,2(t0) 			
	lbu t6,3(t1) 			
	sb t6,3(t0) 			
	
	sub t1,t1,a0			# subtrai endereco do sprite base
	add t1,t1,a3			# adiciona endereco do sprite de colisao para utilizar a mesma coordenada dentro do sprite
	add t0,t0,a6			# adiciona 0x100000 ao endereco do bitmap para desenhar no frame
	
	lbu t6,0(t1) 			# guarda a word de pixels do sprite de colisao
	sb t6,0(t0)
	lbu t6,1(t1) 			
	sb t6,1(t0)
	lbu t6,2(t1) 			
	sb t6,2(t0)
	lbu t6,3(t1) 			
	sb t6,3(t0)
	
	sub t1,t1,a3			# subtrai endereco do sprite de colisao
	add t1,t1,a0			# adiciona endereco do sprite base
	sub t0,t0,a6			# subtrai 0x100000 ao endereco do bitmap para voltar ao frame 0

	addi t0,t0,4 			# avanca o endereco do bitmap display em 4
	addi t1,t1,4 			# avanca o endereco da imagem em 4
	
	addi t3,t3,4 			# avanca o contador de colunas em 4
	blt t3,t4,Linha 		# enquanto a linha nao estiver completa, continua desenhando ela
	
	addi t0,t0,320 			# avanca para a proxima linha
	sub t0,t0,t4 			# subtrai a largura do sprite
		
	mv t3,zero 			# reseta o contador de colunas
	addi t2,t2,1 			# avanca o contador de linhas em 1
	blt t2,t5,Linha 		# enquanto o contador de linhas for menor que a altura repete a funcao

FimPrint:
	ret 

#----------
Limpar:		# a0 = endereco com a posicao que sera limpa; a1 = endereco com a posicao nova (apenas para comparacao)

	lw t0,0(a0)
	lw t1,0(a1)
	beq t0,t1,FimLimpar		# se a posicao nova do sprite for igual a posicao atual nao e necessario limpar o mapa
	
	lw t0,OffsetX
	lw t1,OldOffset
	bne t0,t1,FimLimpar		# se o mapa se mover nao e necessario limpar
	
	lhu a1,0(a0)			# a1, posicao X original do sprite
	lhu a2,2(a0)			# a2, posicao Y original do sprite
	
	andi s0,a1,0xf			# s0, resto da posicao X por 16
	srli s1,a1,4			# s1, divisao da posicao X por 16
	
	andi s2,a2,0xf			# s2, resto da posicao Y por 16
	srli s3,a2,4			# s3, divisao da posicao Y por 16
	
	la t0,mapa40x30			
	lw t1,0(t0)			# t1, tamanho do mapa de tiles
	mul t2,s3,t1			
	
	addi t0,t0,8
	add t0,t0,s1			# adiciona o numero de colunas de tiles
	add t0,t0,t2			# adiciona o numero de linhas de tiles
	
	lbu t4,0(t0)			# valor do primeiro tile -> t4 = 0x00000011
	
	lbu t3,1(t0)			# valor do segundo tile
	slli t3,t3,8
	add t4,t4,t3			# t4 = 0x00002211
	
	add t0,t0,t1			
	lbu t3,0(t0)			# valor do terceiro tile
	slli t3,t3,16
	add t4,t4,t3			# t4 = 0x00332211
	
	lbu t3,1(t0)			# valor do terceiro tile
	slli t3,t3,24
	add t4,t4,t3			# t4 = 0x44332211
	
	lw t0,BGTileCodes
	beq t0,t4,FimBigBG		# se t4 tiver os mesmos codigos de tile que os armazenados skipa a definicao do BigBG
	
	la s4,BGTileCodes		# s4, endereco com todos os códigos de tile
	sw t4,0(s4)			# atualiza os ultimos codigos de tile
	mv s5,zero			# s5, contador de tiles
LoopBigBG:

	lbu s6,0(s4) 			# s6, código do tile atual

	li t3,1				# analise dos codigos de tile
	beq s6,t3,GetBigBGTile1
	li t3,2
	beq s6,t3,GetBigBGTile2
	li t3,3
	beq s6,t3,GetBigBGTile3
	li t3,4
	beq s6,t3,GetBigBGTile4
	li t3,5
	beq s6,t3,GetBigBGTile5
	li t3,6
	beq s6,t3,GetBigBGTile6
	
GetBigBGTile1:
	la a3,grama
	j GotBigBGTile
GetBigBGTile2:
	la a3,chao
	j GotBigBGTile
GetBigBGTile3:
	la a3,plataforma1
	j GotBigBGTile
GetBigBGTile4:
	la a3,plataforma2
	j GotBigBGTile
GetBigBGTile5:
	la a3,plataforma3
	j GotBigBGTile
GetBigBGTile6:
	la a3,blocoExemp
	j GotBigBGTile

GotBigBGTile:	# a3, sprite do tile que sera salvo no tempBigBG

	mv t2,zero		# t2, contador de colunas
	mv t3,zero		# t3, contador de linhas 
	li t4,16		# t4, largura do tile
	li t5,16		# t5, altura do tile
	
	addi a3,a3,8
	la a4,tempBigBG
	
	addi a4,a4,8			# define a4 para salvar o primeiro tile do tempBigBG
	beq s5,zero,SaveTileBigBG
		 
	addi a4,a4,16			# define a4 para salvar o segundo tile do tempBigBG
	li t0,1
	beq s5,t0,SaveTileBigBG
	
	addi a4,a4,496			# define a4 para salvar o terceiro tile do tempBigBG
	li t0,2
	beq s5,t0,SaveTileBigBG
	
	addi a4,a4,16			# define a4 para salvar o quarto tile do tempBigBG
	li t0,3
	beq s5,t0,SaveTileBigBG

SaveTileBigBG:

	lw t6,0(a3) 			# guarda a word de pixels do tile
	sw t6,0(a4) 			# salva no tempBigBG

	addi a4,a4,4			# avanca o endereco do tempBigBG em 4
	addi a3,a3,4 			# avanca o endereco da imagem em 4
	
	addi t2,t2,4 			# avanca o contador de colunas em 4
	blt t2,t4,SaveTileBigBG 	# enquanto a linha nao estiver completa, continua desenhando ela
	
	addi a4,a4,16 			# avanca para a proxima linha do tempBigBG

	mv t2,zero 			# reseta o contador de colunas
	addi t3,t3,1 			# avanca o contador de linhas em 1
	blt t3,t5,SaveTileBigBG 	# enquanto o contador de linhas for menor que a altura repete a funcao

	addi s4,s4,1			# avanca para o proximo codigo de tile
	addi s5,s5,1			# avanca o contador de tiles
	
	li t2,4
	beq s5,t2,FimBigBG		# se ja foram todos os 4 tiles do tempBigBG segue com o Limpar
	j LoopBigBG
FimBigBG:

	la a3,tempBigBG
	addi a3,a3,8
	
	add a3,a3,s0			# adiciona os pixels de offset X no endereco de tempBigBG 
	li t0,32
	mul t0,t0,s2
	add a3,a3,t0			# adiciona os pixels de offset Y no endereco de tempBigBG 
	
	lhu t2,OffsetX
	sub t3,a1,t2			# subtrai a posicao X original do sprite pelo offset X
	lhu t2,OffsetY			
	sub t4,a2,t2			# subtrai a posicao Y original do sprite pelo offset Y
	
	li t1,320
	li t2,240
	rem t3,t3,t1			# corrige a posicao no bitmap quando ela passa do 320x240 inicial
	rem t4,t4,t2			# tecnicamente desnecessario por causa do offset, mas mantido por garantia e para testes que mudam a posicao manualmente
	
	li t0,0xff000000
	
	add t0,t0,t3 			# adiciona X ao endereco do bitmap
	
	mul t1,t1,t4
	add t0,t0,t1 			# adiciona Y ao endereco do bitmap
	
	mv t1,a3			# t1, endereco do tempBigBG com offsets
	
	mv t2,zero			# t2, contador de colunas
	mv t3,zero			# t3, contador de linhas
	
	li t4,16			# largura do sprite sempre e 16
	li t5,16			# altura do sprite sempre e 16
	
	la a5,emptyCol			
	li a6,0x100000 			# para o mapa de colisao
	
LinhaLimpar:
 	lbu t6,0(t1) 			# guarda um pixel do sprite (nao pode ser word por nao estar sempre alinhado com o endereco)
	sb t6,0(t0) 			# desenha no bitmap display (4 pixels separadamente)
	lbu t6,1(t1) 			
	sb t6,1(t0) 			
	lbu t6,2(t1) 			
	sb t6,2(t0) 			
	lbu t6,3(t1) 			
	sb t6,3(t0) 			

	li t6,0xff			# sempre guarda branco no frame 1
	add t0,t0,a6	# nenhuma hitbox de colisao pode se sobrepor, no maximo pode acontecer se for em um ponto em que a tela sempre se mexe, ja que a impressao do mapa evitaria problemas

	sb t6,0(t0)			
	sb t6,1(t0)		
	sb t6,2(t0)		
	sb t6,3(t0)			
	
	sub t0,t0,a6			# subtrai 0x100000 para voltar ao frame 0

	addi t0,t0,4 			# avanca o endereco do bitmap display em 4
	addi t1,t1,4 			# avanca o endereco da imagem em 4
	
	addi t3,t3,4 			# avanca o contador de colunas em 4
	blt t3,t4,LinhaLimpar 		# enquanto a linha nao estiver completa, continua desenhando ela

	addi t0,t0,320 			# avanca para a proxima linha do bitmap
	sub t0,t0,t4 			# subtrai a largura do sprite
	
	addi t1,t1,16			# avanca o endereco do tempBigBG
	
	mv t3,zero 			# reseta o contador de colunas
	addi t2,t2,1 			# avanca o contador de linhas em 1
	blt t2,t5,LinhaLimpar 		# enquanto o contador de linhas for menor que a altura repete a funcao
	
FimLimpar:
	ret 

#----------
PrintMapa:
	
	lw t0,OffsetX
	lw t1,OldOffset
	beq t0,t1,FimPrintMapa		# se o offset nao mudou skipa o print do mapa

	lhu t0,OffsetX
	andi s0,t0,0xf		# s0, resto de offset X por 16
	srli s1,t0,4		# s1, divisao de offset X por 16
	
	lhu t1,OffsetY
	andi s2,t1,0xf		# s2, resto de offset Y por 16
	srli s3,t1,4		# s3, divisao de offset Y por 16
	
	mv s4,zero		# s4, contador de colunas de tiles
	mv s5,zero		# s5, contador de linhas de tiles
	mv s6,zero		# s6, contador total de tiles
	
	li s7,21		# s7, numero maximo de tiles na horizontal
	li s8,16		# s8, numero maximo de tiles na vertical
	li s9,336		# s9, numero total de tiles que precisam ser analisados (21 na horizontal * 16 na vertical) 
	
LoopBuild:	# passa pelo mapa de tiles e usa ele para montar o mapa de pixels

	beq s6,s9,FimPrintMapa	# continua o código quando todos os tiles forem analisados
	
	la a0,mapa40x30
	
	lw t1,0(a0)
	
	add a0,a0,s1		# adiciona offsetX/16
	add a0,a0,s4		# adiciona contador de colunas
	
	mv t0,s3		# adiciona offsetY/16
	add t0,t0,s5		# adiciona contador de linhas
	mul t0,t0,t1		# multiplica por 40 (tamanho das linhas do mapa completo)
	add a0,a0,t0		
	
	addi a0,a0,8
	lbu t0,0(a0)		# armazena o valor do tile a ser salvo
	
	li t1,1			# analisa os codigos de tile
	beq t0,t1,GetTile1
	li t1,2
	beq t0,t1,GetTile2
	li t1,3
	beq t0,t1,GetTile3
	li t1,4
	beq t0,t1,GetTile4
	li t1,5
	beq t0,t1,GetTile5
	li t1,6
	beq t0,t1,GetTile6
	
GetTile1:
	la a1,grama
	la a5,emptyCol
	j GotTile
GetTile2:
	la a1,chao
	la a5,emptyCol
	j GotTile
GetTile3:
	la a1,plataforma1
	la a5,plataforma1Col
	j GotTile
GetTile4:
	la a1,plataforma2
	la a5,plataforma2Col
	j GotTile
GetTile5:
	la a1,plataforma3
	la a5,plataforma3Col
	j GotTile
GetTile6:
	la a1,blocoExemp
	la a5,blocoExempCol
	j GotTile

GotTile:

	addi a2,zero,-1
	beq s4,zero,DoneColOffset	# define a2 como -1 se for a primeira coluna

	addi a2,zero,1		
	addi t0,s7,-1
	beq s4,t0,DoneColOffset		# define a2 como 1 se for a ultima coluna
	
	mv a2,zero			# define a2 como 0 se for a qualquer uma das outras colunas 
DoneColOffset:			
	
	addi a3,zero,-1
	beq s5,zero,DoneLineOffset	# define a2 como -1 se for a primeira linha

	addi a3,zero,1
	addi t0,s8,-1
	beq s5,t0,DoneLineOffset	# define a2 como 1 se for a ultima linha
	
	mv a3,zero			# define a2 como 0 se for a qualquer uma das outras linhas
DoneLineOffset:			
	
	bne a2,zero,SaveTile		# se for uma coluna inicial ou final vai para SaveTile
	bne a3,zero,SaveTile		# se for uma linha inicial ou final vai para SaveTile
	
	j SaveCenterTile		# tiles do meio são mais simples então podem ser salvos mais rapidamente
FimSaveTile:
	
	addi s4,s4,1			# avanca contador de colunas de tiles
	addi s6,s6,1			# avanca contador total de tile
	bge s4,s7,NextLine		# se estiver no fim de uma linha vai para a proxima
	j LoopBuild
	
NextLine:				# próxima linha de tiles
	mv s4,zero		
	addi s5,s5,1			# avanca contador de linhas
	j LoopBuild

#----------
SaveTile: 	# a1 = sprite que vai ser salvo no mapa de pixels, a2 = offset das colunas, a3 = offset das linhas
	
	mv t1,s4

	slli t1,t1,4			# multiplica numero da coluna por 16 (tamanho dos tiles)
	blt a2,zero,FirstCol
	# todas as colunas exceto a 1a:
	sub t1,t1,s0			# resto do offset X subtraído do bitmap (puxa para a esquerda as colunas, se ocorrer na 1a = erro)
FirstCol:
	
	mv t2,s5
	li t0,320
	mul t2,t2,t0			# multiplica numero da linha por 320 (tamanho das linhas do bitmap)
	slli t2,t2,4			# multiplica numero da linha por 16 (tamanho dos tiles)
	blt a3,zero,FirstLine
	# todas as linhas exceto a 1a:
	mul t0,s2,t0
	sub t2,t2,t0			# resto do offset Y vezes 320 subtraído do bitmap (sobe as linhas, se ocorrer na 1a = erro)
FirstLine:
	
	li t0,0xff000000
	add t0,t0,t1
	add t0,t0,t2 			# t0 = endereco base para salvar o sprite do tile
	
	addi t1,a1,8 			# endereco do sprite mais 8
		
	mv t2,zero			# contador de colunas do tile
	mv t3,zero			# contador de linhas do tile	
	
	sub t4,s8,s0			
	blt a2,zero,SetColSize		# na 1a coluna a largura do tile será 16-OffsetX
	mv t4,s0
	bgt a2,zero,SetColSize		# na ultima coluna a largura do tile será OffsetX
	lw t4,0(a1)			# nas outras colunas a largura do tile é 16
SetColSize:
	beq t4,zero,FimSaveTile 	# se a ultima coluna nao estiver aparecendo, t4 = 0 e o tile pode ser skipado
	
	sub t5,s8,s2		
	blt a3,zero,SetLineSize		# na 1a linha a altura do tile será 16-OffsetY
	mv t5,s2
	bgt a3,zero,SetLineSize		# na 1a linha a altura do tile será OffsetY
	lw t5,4(a1)			# nas outras linhas a altura do tile é 16
SetLineSize:
	beq t5,zero,FimSaveTile 	# se a ultima linha nao estiver aparecendo, t5 = 0 e o tile pode ser skipado
	
	bge a3,zero,NotFirstLine
	# 1a linha:
	mv t6,s2
	slli t6,t6,4
	add t1,t1,t6			# adiciona o tamanho das linhas fora da tela ao endereco do sprite
NotFirstLine:
		
PreTileLine:	# loop de impressao do tile comeca aqui

	bge a2,zero,NotFirstCol
	# 1a coluna:
	add t1,t1,s0			# adiciona resto do offset X ao endereco do sprite
NotFirstCol:
		
	li a6,0x100000			# para o mapa de colisao
	
TileLine: 	# t0 = endereco do bitmap display; t1 = endereco do sprite

	lbu t6,0(t1) 			# guarda um pixel do sprite
	sb t6,0(t0) 			# desenha no bitmap display um pixel do sprite (já que tamanho das linhas pode variar de 1 a 16)
	
	sub t1,t1,a1			# subtrai endereco do sprite base
	add t1,t1,a5			# adiciona endereco do sprite de colisao para utilizar a mesma coordenada dentro do sprite
	add t0,t0,a6			# adiciona 0x100000 ao endereco do bitmap para desenhar no frame 1
			
	lbu t6,0(t1) 			# guarda a word de pixels do sprite de colisao
	sb t6,0(t0)
	
	sub t1,t1,a5			# subtrai endereco do sprite de colisao
	add t1,t1,a1			# adiciona de volta o endereco do sprite base
	sub t0,t0,a6			# subtrai 0x100000 ao endereco do bitmap para voltar ao frame 0

	addi t0,t0,1 			# avanca o endereco do bitmap display
	addi t1,t1,1 			# avanca o endereco da imagem
	
	addi t2,t2,1 			# avanca o contador de colunas
	blt t2,t4,TileLine 		# enquanto a linha nao estiver completa, continua desenhando ela
	
	ble a2,zero,NotLastCol
	# ultima coluna
	add t1,t1,s8			
	sub t1,t1,s0			# se estiver na ultima coluna, adiciona 16-OffsetX ao endereco do sprite
NotLastCol:
	
	addi t0,t0,320 			# avanca para a proxima linha do bitmap
	sub t0,t0,t4 			# subtrai a largura do sprite

	mv t2,zero 			# reseta o contador de colunas
	addi t3,t3,1 			# avanca o contador de linhas
	blt t3,t5,PreTileLine 		# enquanto o contador de linhas for menor que a altura repete a funcao

	j FimSaveTile 

#---------------------
SaveCenterTile: 	# a1 = sprite que vai ser salvo no mapa de pixels, a2 = offset das colunas, a3 = offset das linhas
	
	mv t1,s4
	slli t1,t1,4			# multiplica numero da coluna por 16 (tamanho dos tiles)
	sub t1,t1,s0			# subtrai endereco do bitmap por OffsetX (ja que nesse caso ele sempre sera no minimo 16) 

	mv t2,s5
	li t0,320
	mul t2,t2,t0			# multiplica numero da linha por 320 (tamanho das linhas do bitmap)
	slli t2,t2,4			# multiplica numero da linha por 16 (tamanho dos tiles)
	mul t0,s2,t0
	sub t2,t2,t0			# subtrai endereco do bitmap por 320xOffsetY (ja que nesse caso ele sempre sera no minimo 320x16) 
	
	li t0,0xff000000
	add t0,t0,t1
	add t0,t0,t2 			# t0, endereco base para salvar o sprite do tile
	
	addi t1,a1,8 			# endereco do sprite mais 8
	
	mv t2,zero			# contador de colunas do tile
	mv t3,zero			# contador de linhas do tile	
	
	lw t4,0(a1) 			# guarda a largura do tile
	lw t5,4(a1)			# guarda a altura do tile
	
	li a6,0x100000			# para o mapa de colisao
				
CenterTileLine: 	# t0 = endereco do bitmap display; t1 = endereco do sprite

	lbu t6,0(t1) 			# guarda um pixel do sprite (nao pode ser word por nao estar sempre alinhado com o endereco)
	sb t6,0(t0) 			# desenha no bitmap display (4 pixels separadamente)
	lbu t6,1(t1) 			
	sb t6,1(t0)
	lbu t6,2(t1) 			
	sb t6,2(t0)
	lbu t6,3(t1) 			
	sb t6,3(t0)
	
	sub t1,t1,a1			# subtrai endereco do sprite base
	add t1,t1,a5			# adiciona endereco do sprite de colisao para utilizar a mesma coordenada dentro do sprite
	add t0,t0,a6			# adiciona 0x100000 ao endereco do bitmap para desenhar no frame
	
	lbu t6,0(t1) 			# guarda uma word de pixels do sprite de colisao
	sb t6,0(t0)
	lbu t6,1(t1) 			
	sb t6,1(t0)
	lbu t6,2(t1) 			
	sb t6,2(t0)
	lbu t6,3(t1) 			
	sb t6,3(t0)
	
	sub t1,t1,a5			# subtrai endereco do sprite de colisao
	add t1,t1,a1			# adiciona endereco do sprite base
	sub t0,t0,a6			# subtrai 0x100000 ao endereco do bitmap para voltar ao frame 0

	addi t0,t0,4			# avanca o endereco do bitmap display
	addi t1,t1,4 			# avanca o endereco da imagem
	
	addi t2,t2,4 			# avanca o contador de colunas
	blt t2,t4,CenterTileLine 	# enquanto a linha nao estiver completa, continua desenhando ela
	
	addi t0,t0,320 			# avanca para a proxima linha do bitmap
	sub t0,t0,t4 			# subtrai a largura do sprite

	mv t2,zero 			# reseta o contador de colunas
	addi t3,t3,1 			# avanca o contador de linhas
	blt t3,t5,CenterTileLine 	# enquanto o contador de linhas for menor que a altura repete a funcao

	j FimSaveTile 

FimPrintMapa: 
	ret
