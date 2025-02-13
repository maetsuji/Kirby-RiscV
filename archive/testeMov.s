.data

MapaPos:	.half 0, 0

AtaquePosX: 	.half 0
AtaquePosY: 	.half 0
OldAtaquePos:	.word 1

OffsetX:	.half 0
OffsetY:	.half 0
OldOffset:	.word 0

.include "sprites/Ataque1.s"
.include "sprites/chao.s"
.include "sprites/grama.s"
.include "sprites/mapa640x480.s"	# arquivo em branco, apenas para guardar na memória o tamanho máximo do mapa
.include "sprites/mapa40x30cccc.data"
.include "sprites/mapa30x30dddd.data"

.text
	li s7,0x01E00280 	# s7,  grid 640x480
	#li s7,0x01E001E0 	# s7,  grid 480x480
			
				# s10, última tecla apertada
				
#----------			
BuildMap:	# constrói o mapa completo na memória com base em um mapa de tiles
	la a0,mapa40x30cccc	# a0, mapa de tiles
	#la a0,mapa30x30dddd	# a0, mapa de tiles
	
	lw s0,0(a0)		# s0, tamanho X do mapa de tiles
	lw t0,4(a0)		# t0, *tamanho Y do mapa de tiles
	mul s2,s0,t0		# s2, tamanho total do mapa de tiles
	slli s1,s0,4		# s1, tamanho total da linha de pixels #### não utilizado
	mv s3,zero		# s3, contador de colunas de tiles
	mv s4,zero		# s4, contador de linhas de tiles
	mv s5,zero		# s5, contador total de tiles
	
	la a1,mapa640x480
	addi a1,a1,8
	
LoopBuild:	# passa pelo mapa de tiles e usa ele para montar o mapa de pixels
	mul s5,s4,s0
	add s5,s5,s3		# incrementa contador total dos tiles

	bge s5,s2,FimBuild	# continua o código quando todos os tiles forem salvos
	
	add t0,a0,s5
	addi t0,t0,8
	lbu t0,0(t0)		# armazena o valor do tile a ser salvo
	
	li t1,184
	beq t0,t1,GetTile1
	
	li t1,244
	beq t0,t1,GetTile2
	
GetTile1:
	la a2,grama
	j GotTile
GetTile2:
	la a2,chao
	j GotTile

GotTile:
	
	j SaveTile
FimSaveTile:
	
	addi s3,s3,1
	bge s3,s0,NextLine	
	j LoopBuild
	
NextLine:			# próxima linha de tiles
	mv s3,zero
	addi s4,s4,1
	j LoopBuild

#----------
SaveTile: 	# a1 = endereço que armazena os pixels do mapa completo; a2 = sprite que vai ser salvo no mapa de pixels
	
	slli t1,s3,4
	
	li t0,640
	mul t2,s4,t0
	slli t2,t2,4
	
	mv t0,a1
	#li t0,0xff000000
	add t0,t0,t1
	add t0,t0,t2 			# t2 = endereço base para salvar o sprite do tile
	
	addi t1,a2,8 			# endereco do sprite mais 8
	
	mv t2,zero
	mv t3,zero
	
	lw t4,0(a2) 			# guarda a largura do tile
	lw t5,4(a2)			# guarda a altura do tile
		
TileLine: 	# t0 = endereço do bitmap display; t1 = endereço do sprite
	lw t6,0(t1) 			# guarda a word de pixels do sprite
	sw t6,0(t0) 			# desenha no bitmap display (4 valores a partir de t0) o valor de t6 (4 pixels do sprite)

	addi t0,t0,4 			# avanca o endereço do bitmap display em 4
	addi t1,t1,4 			# avanca o endereco da imagem em 4
	
	addi t3,t3,4 			# avanca o contador de colunas em 4
	blt t3,t4,TileLine 		# enquanto a linha nao estiver completa, continua desenhando ela
	
	addi t0,t0,640 			# avanca para a proxima linha do mapa de pixels
	sub t0,t0,t4 			# subtrai a largura do sprite
		
	mv t3,zero 			# reseta o contador de colunas
	addi t2,t2,1 			# avanca o contador de linhas em 1
	blt t2,t5,TileLine 		# enquanto o contador de linhas for menor que a altura repete a funcao
	
	j FimSaveTile 

FimBuild:

	jal PrintMapa

#########################################################################################################################################

Main:
	
	lw t0,OffsetX
	lw t1,OldOffset
	beq t0,t1,SkipMoveMapa		# se o offset não mudou skipa o print do mapa
	
	la t0,MapaPos
	la a0,mapa640x480
	jal PrintMapa			# imprime o mapa
	
	j SkipLimpar			# se o mapa foi impresso não há porque limpar o último frame do usuário

SkipMoveMapa:

	lw t1,OffsetX
	sw t1,OldOffset,t0		# atualiza OldOffset
	
	lw t0,AtaquePosX
	lw t1,OldAtaquePos
	beq t0,t1,SkipPrint		# skipa o print se jogador ficou parado

	la t0,OldAtaquePos
	jal Limpar			# limpa frame passado do jogador

SkipLimpar:
	
	la t0,AtaquePosX
	la a0,Ataque1
	jal Print			# movimento do personagem

SkipPrint:

	j KeyPress			# confere teclas apertadas
FimKeyPress:

	j Main

#########################################################################################################################################

EndGame:	# chamado no KeyPress ao apertar "p"
	li a7,10
	ecall

#----------
KeyPress:
	li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
	lw t2,4(t1)  			# lê o valor da tecla
	
	beq t0,zero,Stop		# se nenhuma tecla está sendo apertada o jogador para
	
	beq t2,s10,Move			# se a mesma tecla se manteve apertada segue movendo
	
	mv s10,t2			# s10 armazena a útlima tecla
	j Move
	
Stop:
	li s10,0
	
	j Move			# FimMove = erro (?)

Move: 		
	lhu t1,AtaquePosX
	lhu t2,AtaquePosY
	
	mv t3,t2
	slli t3,t3,16
	add t3,t3,t1
	sw t3,OldAtaquePos,t0		# atualiza OldAtaquePos

	li t0,'w'
	addi t3,t1,0
	addi t4,t2,-1
  	beq s10,t0,FimMove
  	
  	li t0,'a'
  	addi t3,t1,-1
	addi t4,t2,0
  	beq s10,t0,FimMove
  	
  	li t0,'s'
  	addi t3,t1,0
	addi t4,t2,1
  	beq s10,t0,FimMove
  	
  	li t0,'d'
  	addi t3,t1,1
	addi t4,t2,0
  	beq s10,t0,FimMove
  	
  	li t0,'p'
  	beq s10,t0,EndGame

	mv t3,t1
	mv t4,t2
	
FimMove:
	mv t0,s7
	slli t0,t0,16
	srli t0,t0,16	
	addi t0,t0,-16				# t0, tamanho da linha de pixels -16
	
	#li t0,304		
	blt t3,zero,FimKeyPress
	bgt t3,t0,FimKeyPress			# analisa se passou das bordas dos lados
	
	mv t0,s7
	srli t0,t0,16		
	addi t0,t0,-16				# t0, tamanho da coluna de pixels -16
	
	#li t0,224		
	blt t4,zero,FimKeyPress
	bgt t4,t0,FimKeyPress			# analisa se passou das bordas de cima e de baixo
	
	sh t3,AtaquePosX,t0
	sh t4,AtaquePosY,t0
	
	##### definição do offset:
	
	lw t1,OffsetX
	sw t1,OldOffset,t0			# atualiza OldOffset
	
	li t0,152				# precisa parar sprite no pixel 153 do bitmap (contando de 1)
	bge t3,t0,ChangeOffsetX			# se é necessário mover a tela atualiza o offset
FimChangeOffsetX:

	li t0,112				# precisa parar sprite no pixel 109 do bitmap (contando de 1)
	bge t4,t0,ChangeOffsetY			# se é necessário mover a tela atualiza o offset
FimChangeOffsetY:
	
  	j FimKeyPress
  	

ChangeOffsetX:
	mv t0,s7
	slli t0,t0,16
	srli t0,t0,16				# tamanho X do mapa
			
	addi t0,t0,-168				# pixel mais à direita do mapa que muda o offset
	bgt t3,t0,MaxOffsetX			# se o jogador estiver no fim da tela, o offset sempre será o maior possível

	li t1,152				
	sub t1,t3,t1				# offsetX = posição real do jogador - 152

	sh t1,OffsetX,t2
	
	j FimChangeOffsetX
	
MaxOffsetX:
	li t1,152
	sub t0,t0,t1				# em t0 está o valor máximo de X que altera o offset, então é só subtrair metade da tela e 8 pixels do sprite
	
	sh t0,OffsetX,t2			
	
	j FimChangeOffsetX

ChangeOffsetY:
	mv t0,s7
	srli t0,t0,16				# tamanho Y do mapa
			
	addi t0,t0,-128				# pixel mais para baixo do mapa que muda o offset
	bgt t4,t0,MaxOffsetY

	li t1,112
	sub t1,t4,t1				# offsetY = posição real do jogador - 112
	
	sh t1,OffsetY,t2
	
	j FimChangeOffsetY
	
MaxOffsetY:
	li t1,112
	sub t0,t0,t1				# em t0 está o valor máximo de Y que altera o offset, então é só subtrair metade da tela e 8 pixels do sprite
	
	sh t0,OffsetY,t2
	
	j FimChangeOffsetY

#----------
Print: 		# t0 = endereco com a posicao do sprite, a0 = sprite que vai ser impresso
	
	lhu a1,0(t0)
	lhu a2,2(t0)			# salva posição inicial do sprite
	#li a3,0
	#li t3,2
	#mul a1,a1,t3
	#mul a2,a2,t3 			
	
	lhu t2,OffsetX
	sub t3,a1,t2			# subtrai o X do sprite pelo offset X
	lhu t2,OffsetY			
	sub t4,a2,t2			# subtrai o Y do sprite pelo offset Y
	
	li t1,320
	li t2,240
	rem t3,t3,t1			# corrige a posição no bitmap quando ela passa do 320x240 inicial
	rem t4,t4,t2			# tecnicamente desnecessário por causa do offset, mas mantido por garantia e para testes que mudam a posição manualmente
	
	li t0,0xff000000
	
	add t0,t0,t3 			# adiciona x ao endereco do bitmap
	
	mul t1,t1,t4
	add t0,t0,t1 			# adiciona y ao endereco do bitmap
	
	addi t1,a0,8 			# endereco do sprite mais 8
	
	mv t2,zero
	mv t3,zero
	
	lw t4,0(a0) 			# guarda a largura do sprite
	lw t5,4(a0) 			# guarda a altura do sprite
		
Linha: 		# t0 = endereço do bitmap display; t1 = endereço do sprite
	lbu t6,0(t1) 			# guarda um pixel do sprite (não pode ser word por não estar sempre alinhado com o endereço)
	sb t6,0(t0) 			# desenha no bitmap display (4 pixels separadamente)
	
	lbu t6,1(t1) 			
	sb t6,1(t0) 			
	lbu t6,2(t1) 			
	sb t6,2(t0) 			
	lbu t6,3(t1) 			
	sb t6,3(t0) 			

	addi t0,t0,4 			# avanca o endereco do bitmap display em 4
	addi t1,t1,4 			# avanca o endereco da imagem em 4
	
	addi t3,t3,4 			# avanca o contador de colunas em 4
	blt t3,t4,Linha 		# enquanto a linha nao estiver completa, continua desenhando ela
	
	addi t0,t0,320 			# avanca para a proxima linha
	sub t0,t0,t4 			# subtrai a largura do sprite
		
	mv t3,zero 			# reseta o contador de colunas
	addi t2,t2,1 			# avanca o contador de linhas em 1
	blt t2,t5,Linha 		# enquanto o contador de linhas for menor que a altura repete a funcao
	
	ret 

#----------
Limpar:		# t0 = endereco com a posicao que será limpa
	
	lhu a1,0(t0)
	lhu a2,2(t0)			# salva posição inicial do sprite
	
	lhu t2,OffsetX
	sub t3,a1,t2			# subtrai a posição X pelo offset X
	lhu t2,OffsetY			
	sub t4,a2,t2			# subtrai a posição Y pelo offset Y
	
	li t1,320
	li t2,240
	rem t3,t3,t1			# corrige a posição no bitmap quando ela passa do 320x240 inicial
	rem t4,t4,t2			# tecnicamente desnecessário por causa do offset, mas mantido por garantia e para testes que mudam a posição manualmente
	
	li t0,0xff000000
	
	add t0,t0,t3 			# adiciona X ao endereco do bitmap
	
	mul t1,t1,t4
	add t0,t0,t1 			# adiciona Y ao endereco do bitmap
	
	la a0,mapa640x480		# sprite do mapa sempre terá esse endereço (é montado no inicio de cada fase)
	
	li t2,640			
	mul t2,t2,a2			# linha multiplicada pelo tamanho do mapa na memória (640)
	
	mv t1,a0
	addi t1,t1,8 			# endereco do sprite do mapa mais 8
	add t1,t1,a1 			# avanca o endereco procurado no mapa de pixels pelo X da posição a ser limpa
	add t1,t1,t2 			# avanca o endereco procurado no mapa pelo Y da posição a ser limpa
	
	mv t2,zero
	mv t3,zero
	
	li t4,16			# largura do sprite sempre é 16 (por enquanto)
	li t5,16			# altura do sprite sempre é 16 (por enquanto)
	
LinhaLimpar:
 	lbu t6,0(t1) 			# guarda um pixel do sprite (não pode ser word por não estar sempre alinhado com o endereço)
	sb t6,0(t0) 			# desenha no bitmap display (4 pixels separadamente)
	
	lbu t6,1(t1) 			
	sb t6,1(t0) 			
	lbu t6,2(t1) 			
	sb t6,2(t0) 			
	lbu t6,3(t1) 			
	sb t6,3(t0) 			

	addi t0,t0,4 			# avanca o endereco do bitmap display em 4
	addi t1,t1,4 			# avanca o endereco da imagem em 4
	
	addi t3,t3,4 			# avanca o contador de colunas em 4
	blt t3,t4,LinhaLimpar 		# enquanto a linha nao estiver completa, continua desenhando ela

	addi t0,t0,320 			# avanca para a proxima linha do bitmap
	sub t0,t0,t4 			# subtrai a largura do sprite

	addi t1,t1,640			# avanca para a proxima linha do sprite do mapa completo
	sub t1,t1,t4 			# subtrai a largura do sprite
	
	mv t3,zero 			# reseta o contador de colunas
	addi t2,t2,1 			# avanca o contador de linhas em 1
	blt t2,t5,LinhaLimpar 		# enquanto o contador de linhas for menor que a altura repete a funcao
	
	ret 

#----------
PrintMapa: 	
	
	#la t0,MapaPos			# posicao do mapa, sempre 0,0
	la a0,mapa640x480		# sprite do mapa sempre terá esse endereço (é montado no inicio de cada fase)
	
	#lhu a1,0(t0)
	#lhu a2,2(t0)
	
	addi t1,a0,8 			# endereco da imagem mais 8
	
	lhu t2,OffsetX
	add t1,t1,t2
	lhu t2,OffsetY			
	li t3,640
	mul t2,t2,t3
	add t1,t1,t2
	
	li t0,0xff000000
	
	#add t0,t0,a1 			# adiciona x ao endereco do bitmap
	
	#li t1,320
	#mul t1,t1,a2
	#add t0,t0,t1 			# adiciona y ao endereco do bitmap
	
	mv t2,zero
	mv t3,zero
	
	li t4,320 			# guarda em t4 a largura de a0
	li t5,240 			# guarda em t5 a altura de a0
		
LinhaMapa: 	
	lbu t6,0(t1) 			# guarda um pixel do sprite (não pode ser word por não estar sempre alinhado com o endereço)
	sb t6,0(t0) 			# desenha no bitmap display (4 pixels separadamente)
	
	lbu t6,1(t1) 			
	sb t6,1(t0) 			
	lbu t6,2(t1) 			
	sb t6,2(t0) 			
	lbu t6,3(t1) 			
	sb t6,3(t0) 
	
	addi t0,t0,4 			# avanca o endereco do bitmap display em 4
	addi t1,t1,4 			# avanca o endereco da imagem em 4
	
	addi t3,t3,4 			# avanca o contador de colunas em 4
	blt t3,t4,LinhaMapa 		# enquanto a linha nao estiver completa, continua desenhando ela
	
	addi t0,t0,320 			# avanca para a proxima linha do bitmap
	sub t0,t0,t4 			# subtrai a largura do sprite
	
	addi t1,t1,640 			# avanca para a proxima linha do sprite do mapa completo
	sub t1,t1,t4 			# subtrai a largura do sprite
		
	mv t3,zero 			# reseta o contador de colunas
	addi t2,t2,1 			# avanca o contador de linhas em 1
	blt t2,t5,LinhaMapa 		# enquanto o contador de linhas for menor que a altura repete a funcao
	
	ret 
