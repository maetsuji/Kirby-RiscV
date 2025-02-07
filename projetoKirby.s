.data

BitmapFrame:	.word 0xff000000

MapaPos:	.half 0, 0

OffsetX:	.half 0		# quantidade de pixels que o jogador se moveu na horizontal que modificam a posicao do mapa 
OffsetY:	.half 0		# quantidade de pixels que o jogador se moveu na vertical que modificam a posicao do mapa  
OldOffset:	.word 1		# precisa comecar com um valor para ser comparado no PrintMapa (so roda se a posicao antiga for diferente da atual) 

PlayerPosX: 	.half 32	# posicao em pixels do jogador no eixo X (de 0 ate a largura do mapa completo)
PlayerPosY: 	.half 16	# posicao em pixels do jogador no eixo Y (de 0 ate a altura do mapa completo)
OldPlayerPos:	.word 1		# precisa comecar com um valor para ser comparado no Print (so roda se a posicao antiga for diferente da atual)  ## nao mais utilizado atualmente
TempPlayerPos:	.word 0
PlayerSpeedX:	.half 0		# velocidade completa do jogador (em centenas) no eixo X, dividida por 100 para ser usada como pixels
PlayerSpeedY:	.half 0		# velocidade completa do jogador (em centenas) no eixo Y, dividida por 100 para ser usada como pixels
PlayerGndState:	.half 0		# 0 = jogador no ar, 1 = jogador no chao
PlayerAnimState:.half 0		
# 0 = vazio,  1 = atacando, 2 = vazio com poder 1, 3 = vazio com poder 2, 4 = inimigo 1 na boca, 5 = inimigo 2 na boca
# 6 = transicao inicio eat, 7 = transicao cancelar eat, 8 = transicao engolir, 9 = transicao inflar, 10 = transicao soltar ar, 11 = transicao soltar item
# 12 = cheio sem poder, 13 = cheio com poder 1, 14 = cheio com poder 2
PlayerPowState:	.word 0		# 0 = vazio sem poder, 1 = fogo, 2 = gelo, 3 = inimigo simples na boca, 4 = inimigo fogo na boca, 5 = inimigo gelo na boca
PlayerAnim:	.half 0
PlayerOldAnim:	.half 0
PlayerAnimCount:.half 0
PlayerAnimTransit:.half 0
PlayerLock:	.word 0		# 0 = movimentacao livre, 1 = controles travados (por enquanto apenas durante o ataque)
PlayerMaxFrame:	.word 0		# duracao do sprite atual em frames, se for 0 sera um sprite sem animacao
PlayerSprite:	.word 0		# endereco para o sprite atual
PlayerColSprite:.word 0		# endereco para o sprite atual de colisao
PlayerLastFrame:.word 0		# contador de frames para comparacao
PlayerObjDelay: .word 0

.eqv playerMaxSpX 200
.eqv playerMaxQuickFallSp 200
.eqv playerMaxSlowFallSp 100
.eqv playerMaxJumpSp -4
.eqv playerAccX 100
.eqv playerDeaccX 10
.eqv playerFlyPow -450
.eqv playerJumpPow -600
.eqv playerFlyIndex 12
.eqv playerMouthIndex 3

.eqv gravityAcc 25

.eqv spriteHeader 12

BGTileCodes:	.word 0		# armazena 4 (bytes) codigos de tiles para que o fundo seja montado no Limpar

LastKey: 	.word 0		# valor da ultima tecla pressionada
PlayerLastDir:	.word 1		# valor 0 ou 1 baseado na ultima tecla "a" ou "d" apertada, inicia como 1 = "d"

LastGlblTime:	.word 0		# valor completo da ecall 30, que sempre sera comparado e atualizado para contar os frames
FrameCount:	.word 0		# contador de frames, sempre aumenta para que possa ser usado como outros contadores (1 seg = rem 50; 0.5 seg = rem 25; etc.)
.eqv FPS 50

ObjAtual:	.word 0
.eqv objQuant 10
.eqv objSize 20

endl:		.string "\n"	# temporariamente sendo usado para debug (contador de ms)

.include "sprites/Ataque1.data"
.include "sprites/chao.data"
.include "sprites/grama.data"
.include "sprites/plataforma1.data"
.include "sprites/plataforma2.data"
.include "sprites/plataforma3.data"
.include "sprites/blocoExemp.data"
.include "sprites/mapa40x30.data"
.include "sprites/mapa30x30.data"
.include "kirby/kirbyMain.data" 
.include "kirby/kirbyMain2.data"
.include "kirby/kirbyPowers.data"

.include "objects/objectDB.data"
.include "objects/objectSprites.data"

.include "collision/collisionObjects.data"
.include "collision/collisionRender.data"
.include "collision/collisionTiles.data"


.text
	
	li t0,0xff200604	# endereco que define qual frame esta sendo apresentado
	li t1,1
	#sw t1,0(t0)		# para visualizar o frame 1

	li s11,0x01E00280 	# s11,  grid 640x480
	#li s11,0x01E001E0 	# s11,  grid 480x480
				
#########################################################################################################################################
# as seguintes funcoes precisam ser chamadas antes do KeyPress, ja que ele atualiza o offset e a posicao do jogador e tornaria elas iguais aos valores antigos

	#jal PrintMapa		# imprime o mapa na inicializacao
	
	la t0,kirbyIdle0
	la t1,PlayerSprite
	sw t0,0(t1)
	
	la t0,playerCol
	la t1,PlayerColSprite
	sw t0,0(t1)
	
	lw a0,PlayerSprite
	lw a1,PlayerPosX
	lw a2,PlayerColSprite
	lw a3,PlayerLastDir
	lw a4,PlayerPowState
	jal Print		# imprime o jogador na inicializacao
	
	#li a7,30
	#ecall
	csrr a0,3073
	sw a0,LastGlblTime,t0	# define o primeiro valor do timer global, que sera comparado no Clock

Main:
	jal Clock
	
	jal ChangeFrame 	# incompleto
	
	jal KeyPress		# confere teclas apertadas, atualizando posicao do jogador e offset
	
	jal PlayerControls	# com base na ultima tecla apertada, salva em s10 pelo KeyPress, realiza as acoes de movimento do jogador
	
	jal PlayerAnimation
	
	#jal EnemyCheck
	
# toda funcao que muda posicao de personagens/objetos deve ser chamada antes de imprimi-los

	jal PrintMapa		# imprime o mapa usando o offset

	#la a0,OldPlayerPos
	#la a1,PlayerPosX
	#jal Limpar		# limpa posicao antiga do jogador  ## removido, pois o PrintMapa serve como um Limpar geral e esta precisando ser chamado todo frame
	
	lw a0,PlayerSprite
	lw a1,PlayerPosX
	lw a2,PlayerColSprite
	lw a3,PlayerLastDir
	lw a4,PlayerPowState
	jal Print		# imprime o jogador em sua nova posicao
	
	jal DrawObjects

	j Main

#########################################################################################################################################
Clock: 
	#li a7,30
	#ecall			# salva o novo valor do tempo global
	csrr a0,3073
	mv s0,a0
	
	lw t0,LastGlblTime
	sub t0,a0,t0		# subtrai o novo tempo global pelo ultimo valor salvo, para definir quantos milissegundos passaram desde o ultimo frame
	
	#mv a0,t0
	#lhu a0,PlayerAnimState
	#li a7,1
	#ecall
	
	#la a0,endl
	#li a7,4
	#ecall			# imprime a diferenca de milissegundos (apenas por debug)
	
	li t1,20		# a cada 20 ms o frame avanca em 1, o que equivale a 50 fps
	blt t0,t1,Clock		# enquanto nao avancar o frame o codigo fica nesse loop
	sw s0,LastGlblTime,t0	# atualiza o novo valor de tempo global
	
	lw s1,FrameCount
	addi s1,s1,1
	sw s1,FrameCount,t0 	# avanca o contador de frames
		
FimClock:

	# debugs

	lhu a0,PlayerAnimCount
	li a7,1
	#ecall
	
	la a0,endl
	li a7,4
	#ecall	

	lhu a0,PlayerAnimTransit
	li a7,1
	#ecall
	
	la a0,endl
	li a7,4
	#ecall		

	lhu a0,PlayerPowState
	li a7,1
	#ecall
	
	la a0,endl
	li a7,4
	#ecall			
	
	lhu a0,PlayerAnim
	li a7,1
	#ecall
	
	la a0,endl
	li a7,4
	#ecall		

	la a0,endl
	li a7,4
	#ecall			

	ret			# depois de avancar o frame segue para o resto do codigo da main, basicamente definindo o framerate do jogo como 50 fps
#----------	
CheckScreenBounds: # a0 = endereço do objeto; a1 = 0 para despawnar, 1 para ativar/desativar
	addi sp,sp,-12
	sw ra,0(sp)
	sw s0,4(sp)
	sw s1,8(sp)

	lh s0,4(a0) # posX
	lh s1,6(a0) # posY
	
	lhu t0,OffsetX
	lhu t1,OffsetY
	
	sub s0,s0,t0
	sub s1,s1,t1
	
	blt s0,zero,OutOfBounds #LeftOOB
	li t0,304
	bgt s0,t0,OutOfBounds #RightOOB
	
	blt s1,zero,OutOfBounds #TopOOB
	li t0,224 ### TODO trocar ao adicionar o menu
	bgt s1,t0,OutOfBounds #BottomOOB
	
	# spawn object:
	li t0,6
	lw t1,0(a0)
	ble t1,t0,EndCheckbounds # objetos nao precisam ter o sstatus atualizado
	
	li t0,1
	sh t0,10(a0) # atualiza status para 1
	j EndCheckbounds
	
OutOfBounds:
	bne a1,zero,DeactivateObj
	
	# despawn:
	sw zero,0(a0)
	j EndCheckbounds
	
DeactivateObj:
	
	sh zero,10(a0) # atualiza status para 0
	lw t0,16(a0) # carrega posicao original do objeto
	sw t0,4(a0) # atualiza posicao atual do objeto para a original
	
EndCheckbounds:
	
	lw ra,0(sp)
	lw s0,4(sp)
	lw s1,8(sp)
	addi sp,sp,12

	ret

#----------
BuildObject: # a0 = id do objeto, a1 = quantidade de objetos a adicionar, a2 = posicao de referencia (0xYYYYXXXX), a3 = direcao do objeto (0 = esq, 1 = dir), a4 = valor de apoio

	addi sp,sp,-16
	sw ra,0(sp)
	sw s0,4(sp)
	sw s1,8(sp)
	sw s2,12(sp)

	la s0,Obj0ID
	mv s1,zero			# s1, contador de objetos geral
	
CheckBuildObjs:
	lw s2,0(s0)
	beq s2,zero,NewInstance
	j BuildNextObj
	
BuildNextObj:
	addi s1,s1,1
	li t0,objQuant
	beq s1,t0,FimBuildObject
	beq a1,zero,FimBuildObject
	
	addi s0,s0,objSize
	j CheckBuildObjs
	
NewInstance:
	addi a1,a1,-1
	
	li a7,1
	#ecall
	
	li t0,1
	beq a0,t0,BuildDust
	li t0,2
	beq a0,t0,BuildTinyDust
	li t0,3
	beq a0,t0,BuildFire
	li t0,4
	beq a0,t0,BuildIce
	li t0,5
	beq a0,t0,BuildPullArea
	li t0,6
	beq a0,t0,BuildAir
	li t0,7
	###beq a0,t0,BuildWaddleDee
	
BuildDust:
	# s0 tem o endereco inicial das variaveis do objeto
	sw a0,0(s0) # id
	
	sw a2,4(s0) # posX e posY, pois e possivel armazenar diretamente a word com a posicao de referencia
	
	sh a3,8(s0) # dir
	
	sh zero,10(s0) # movePat
	
	li t0,4
	sh t0,12(s0) # lifeFrames
	
	sh zero,14(s0) # anim
	
	j BuildNextObj
	
BuildTinyDust:
	# s0 tem o endereco inicial das variaveis do objeto
	sw a0,0(s0) # id
	
	sw a2,4(s0) # posX e posY, pois e possivel armazenar diretamente a word com a posicao de referencia
	
	sh a3,8(s0) # dir
	
	sh a4,10(s0) # movePat # a4 = 0, 1, 2, 3 -> esq cima, dir baixo, dir cima, esq baixo 
	
	li t0,5
	sh t0,12(s0) # lifeFrames
	
	sh zero,14(s0) # anim
	
	j BuildNextObj
	
BuildFire:
	# s0 tem o endereco inicial das variaveis do objeto
	sw a0,0(s0) # id
	
	sw a2,4(s0) # posX e posY, pois e possivel armazenar diretamente a word com a posicao de referencia
	
	sh a3,8(s0) # dir
	
	sh a4,10(s0) # movePat, para o fogo: 0 = para cima, 1 = para baixo
	
	li t0,10
	sh t0,12(s0) # lifeFrames
	
	sh zero,14(s0) # anim
	
	j BuildNextObj

BuildIce:
	# s0 tem o endereco inicial das variaveis do objeto
	sw a0,0(s0) # id
	
	sw a2,4(s0) # posX e posY, pois e possivel armazenar diretamente a word com a posicao de referencia
	
	sh a3,8(s0) # dir
	
	sh zero,10(s0) # movePat
	
	li t0,8
	sh t0,12(s0) # lifeFrames
	
	sh zero,14(s0) # anim
	
	j BuildNextObj
	
BuildPullArea:
	# s0 tem o endereco inicial das variaveis do objeto
	sw a0,0(s0) # id
	
	sw a2,4(s0) # posX e posY, pois e possivel armazenar diretamente a word com a posicao de referencia
	
	sh a3,8(s0) # dir
	
	sh zero,10(s0) # movePat
	
	li t0,5
	sh t0,12(s0) # lifeFrames
	
	sh zero,14(s0) # anim
	
	j BuildNextObj
	
BuildAir:
	# s0 tem o endereco inicial das variaveis do objeto
	sw a0,0(s0) # id
	
	sw a2,4(s0) # posX e posY, pois e possivel armazenar diretamente a word com a posicao de referencia
	
	sh a3,8(s0) # dir
	
	sh zero,10(s0) # movePat
	
	li t0,24
	sh t0,12(s0) # lifeFrames
	
	sh zero,14(s0) # anim
	
	j BuildNextObj
	
FimBuildObject:

	lw ra,0(sp)
	lw s0,4(sp)
	lw s1,8(sp)
	lw s2,12(sp)
	addi sp,sp,16

	ret
	
#----------

DrawObjects: 
	addi sp,sp,-4
	sw ra,0(sp)

	la s0,Obj0ID
	mv s1,zero			# s1, contador de objetos geral
	
IterateDrawObjs:
	lw s2,0(s0)
	
	mv a0,s2
	li a7,1
	#ecall
	
	la a0,endl
	li a7,4
	#ecall
	
	bne s2,zero,DrawObjAtual
	
DrawNextObj:
	addi s1,s1,1
	li t0,objQuant
	beq s1,t0,FimDrawObjects
	
	addi s0,s0,objSize
	j IterateDrawObjs

DrawObjAtual:

	mv a0,s0
	mv a1,zero
	jal CheckScreenBounds

	lw s3,0(s0) # ID
	lhu s4,4(s0) # PosX
	lhu s5,6(s0) # PosY
	lhu s6,8(s0) # Dir
	lhu s7,10(s0) # Status
	lhu s8,12(s0) # LifeFrames
	lhu s9,14(s0) # Anim
	### lw s10,16(s0)
	
	li t0,1
	beq s3,t0,DrawDust
	li t0,2
	beq s3,t0,DrawTinyDust
	li t0,3
	beq s3,t0,DrawFire
	li t0,4
	beq s3,t0,DrawIce
	li t0,5
	beq s3,t0,DrawPullArea
	li t0,6
	beq s3,t0,DrawAir
	li t0,7
	###beq s3,t0,DrawWaddleDee

	j DrawNextObj

DrawDust:
	
	li t0,12
	beq s6,zero,DustBreakRtoL
	li t0,-12
DustBreakRtoL:
	add s4,s4,t0 # define em qual lado do kirby vai aparecer
	
	addi t1,s5,4 
	slli t0,t1,16
	add a1,t0,s4
	
	la a2,emptyCol
	mv a3,s6
	mv a4,zero
	
	la a0,dust0 # frames com vida 4 e 3
	li t0,2
	bgt s8,t0,DrawObjReady
	la a0,dust1 # frames com vida 2 e 1
	j DrawObjReady
	
DrawTinyDust: # ordem: 1 e 3, 0 e 5, 2 e 4
	beq s7,zero,DrawTinyLU # 0 = esq cima
	li t0,1
	beq s7,t0,DrawTinyMU # 1 = meio cima
	li t0,2
	beq s7,t0,DrawTinyRU # 2 = dir cima
	li t0,3
	beq s7,t0,DrawTinyLD # 3 = esq baixo
	li t0,4
	beq s7,t0,DrawTinyMD # 4 = meio baixo
	li t0,5
	beq s7,t0,DrawTinyRD # 5 = dir baixo 
DrawTinyLU:
	li t1,20
	li t2,-10
	li t3,-2
	addi s5,s5,1
	j DoneTinyPos
DrawTinyMU:
	li t1,36
	li t2,-10
	li t3,-4
	addi s5,s5,1
	j DoneTinyPos
DrawTinyRU:
	li t1,52
	li t2,-12
	li t3,-3
	addi s5,s5,1
	j DoneTinyPos
DrawTinyLD:
	li t1,20
	li t2,6
	li t3,-2
	addi s5,s5,-1
	j DoneTinyPos
DrawTinyMD:
	li t1,36
	li t2,6
	li t3,-4
	addi s5,s5,-1
	j DoneTinyPos
DrawTinyRD:
	li t1,52
	li t2,6
	li t3,-3
	addi s5,s5,-1

DoneTinyPos:
	bne s6,zero,DrawTinyDustRight
	sub t1,zero,t1 # se jogador estiver para a esquerda inverte as posicoes horizontais
	sub t3,zero,t3
DrawTinyDustRight:
	
	add s4,s4,t3

	sh s4,4(s0) # PosX
	sh s5,6(s0) # PosY
	
	add s4,s4,t1
	add s5,s5,t2

	slli t0,s5,16
	add a1,t0,s4
	
	la a2,emptyCol
	mv a3,s6
	mv a4,zero
	
	la a0,tinyDust0
	andi t0,s8,2
	beq t0,zero,DrawObjReady
	la a0,tinyDust1
	
	j DrawObjReady
	
DrawAir:	
	li t1,12 # offset inicial do ar nao e salvo

	li t0,16
	li t2,4 # de 28 a 19
	bgt s8,t0,DoneAirSpeed
	li t0,12
	li t2,2 # de 16 a 13
	bgt s8,t0,DoneAirSpeed
	li t0,8
	li t2,1 # de 13 a 7
	bgt s8,t0,DoneAirSpeed
	li t2,0 # de 6 a 1
DoneAirSpeed:
	
	bne s6,zero,DrawAirRight
	sub t1,zero,t1
	sub t2,zero,t2
DrawAirRight:

	add s4,s4,t2
	
	sh s4,4(s0) # atualiza PosX
	sh s5,6(s0) # atualiza PosY
	
	add s4,s4,t1
	addi s5,s5,-2

	slli t0,s5,16
	add a1,t0,s4
	
	la a0,air
	mv a2,zero
	mv a3,s6
	mv a4,zero
	
	j DrawObjReady
	
DrawFire:	
	beq s6,zero,DrawFireLeft
	addi s4,s4,4
	addi t1,s4,12 # offset inicial do fogo nao e salvo
	j DoneDrawFireHor
DrawFireLeft:
	addi s4,s4,-4
	addi t1,s4,-12 # offset inicial do fogo nao e salvo
DoneDrawFireHor:
	
	andi t0,s8,1
	bne t0,zero,DoneDrawFireVert # divide a movimentacao vertical por 1
	beq s7,zero,DrawFireDown
	addi s5,s5,-1
	j DoneDrawFireVert
DrawFireDown:
	addi s5,s5,1
DoneDrawFireVert:
	
	sh s4,4(s0) # atualiza PosX
	sh s5,6(s0) # atualiza PosY

	slli t0,s5,16
	add a1,t0,t1
	
	la a2,emptyCol
	mv a3,s6
	mv a4,zero
	
	la a0,fire0 # frames com vida 8 e 7
	li t0,6 
	bgt s8,t0,DrawObjReady
	la a0,fire1 # frames com vida 6 e 5
	li t0,4
	bgt s8,t0,DrawObjReady
	la a0,fire2 # frames com vida 4 e 3
	li t0,2 
	bgt s8,t0,DrawObjReady
	la a0,fire3 # frames com vida 2 e 1
	j DrawObjReady
	
DrawIce:
	slli t0,s5,16
	add a1,t0,s4
	
	la a2,emptyCol
	mv a3,s6
	mv a4,zero
	
	la a0,ice # frames com vida 8 a 5
	li t0,4 
	bgt s8,t0,DrawObjReady
	la a0,dust0 # frames com vida 4 e 3
	li t0,2 
	bgt s8,t0,DrawObjReady
	la a0,dust1 # frames com vida 2 e 1
	j DrawObjReady
	
DrawPullArea:
	addi s4,s4,-48
	beq s6,zero,DrawPullAreaLeft
	addi s4,s4,64 # corrige o offset inicial da area de puxar quando esta para a direitapara a direita
DrawPullAreaLeft:

	addi s5,s5,-6 # sprite da area de puxar deve ficar 46pixels para cima
	slli t0,s5,16
	add a1,t0,s4
	
	la a2,emptyCol ###
	mv a3,s6
	mv a4,zero
	
	la a0,playerPullAreaCol # sempre o mesmo sprite
	j DrawObjReady
	
DrawObjReady:
	jal Print
	
	mv a0,s8 ###
	li a7,1
	#ecall

	la a0,endl
	li a7,4
	#ecall
	
	addi s8,s8,-1
	sh s8,12(s0)
	bne s8,zero,DrawNextObj
	sw zero,0(s0)	# define ID do objeto como 0 se tempo de vida dele acabar
	
	j DrawNextObj

FimDrawObjects:
	lw ra,0(sp)
	addi sp,sp,4 # conferir
	
	la a0,endl
	li a7,4
	#ecall

	ret

#----------
ChangeFrame:
	lw s0,BitmapFrame
	srli s1,s0,20
	andi s1,s1,1
	
	li t0,0xff200604	# endereco que define qual frame esta sendo apresentado
	sw s1,0(t0)		# para visualizar o frame que acabou de ser desenhado
	
	li t0,0x00100000
	xor s0,s0,t0
	sw s0,BitmapFrame,t0
	
	ret

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
	
	lw s0,PlayerLock
	bne s0,zero,LockedPlayer

	li t0,'d'
	beq t0,t1,DirectionKey
	li t0,'a'
	beq t0,t1,DirectionKey
	j SpecialKeys
DirectionKey:
	li t0,'a'	
	slt t2,t0,t1			# se estiver virado para a esquerda s0 = 0, para a direita s0 = 1
	sw t2,PlayerLastDir,t0		# serve para as animacoes

LockedPlayer:
SpecialKeys:

	li t0,'p'
  	beq t1,t0,EndGame
  	
  	li t0,'1'
  	beq t1,t0,SetPower0
  	
  	li t0,'2'
  	beq t1,t0,SetPower1
  	
  	li t0,'3'
  	beq t1,t0,SetPower2
  	
  	li t0,'4'
  	beq t1,t0,SetPower3
  	
  	li t0,'5'
  	beq t1,t0,SetPower4
  	
  	li t0,'6'
  	beq t1,t0,SetPower5

FimKeyPress:  	
  	ret
  	
#----------
EndGame:
	li a7,10
	#ecall				# metodo temporario de finalizacao do jogo

#----------
SetPower0:
	sw zero,PlayerPowState,t1
	j FimKeyPress

SetPower1:
	li t0,1
	sw t0,PlayerPowState,t1
	j FimKeyPress

SetPower2:
	li t0,2
	sw t0,PlayerPowState,t1
	j FimKeyPress
	
SetPower3:
	li t0,3
	sw t0,PlayerPowState,t1
	j FimKeyPress
	
SetPower4:
	li t0,4
	sw t0,PlayerPowState,t1
	j FimKeyPress
	
SetPower5:
	li t0,5
	sw t0,PlayerPowState,t1
	j FimKeyPress

#----------
PlayerControls:  # s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10
	addi sp,sp,-4
	sw ra,0(sp)			# pilha armazena apenas valor de retorno
			
	lw s0,LastKey			# s0, valor da ultima tecla apertada
	lhu s1,PlayerPosX		# s1, posicao X do jogador no mapa
	lhu s2,PlayerPosY		# s2, posicao Y do jogador no mapa
	lhu s6,PlayerAnimState		# s6, valor de estado do jogador: 0 = vazio, 1 = atacando, 2 = vazio com poder 1, 3 = vazio com poder 2, 4 = cheio sem poder, 5 = inimigo 1 na boca, 6 = inimigo 2 na boca, 7 = cheio com poder 1, 8 = cheio com poder 2
	mv s7,s6
	lhu s8,PlayerAnimTransit
	lw s9,PlayerLock
	lw s10,PlayerPowState
	
	mv t0,s2
	slli t0,t0,16
	add t0,t0,s1
	sw t0,OldPlayerPos,t1		# atualiza OldPlayerPos
	
	li t0,6
	beq s6,t0,ContinueStartAttEat
	
	li t0,7
	beq s6,t0,EndAttackEat
	
	li t0,10
	beq s6,t0,EndAttackAir
	
	li t0,'e'
	beq s0,t0,AttackCheck
	
	li t0,1
	beq s6,t0,KeepAttackEat
	
	j HorizontalMove
	
AttackCheck:
	li t0,0
	beq s6,t0,StartAttackEat

	li t0,1
	beq s6,t0,AttackEat
	
	li t0,playerFlyIndex
	bge s6,t0,AttackAir
	j DoneAttack
	
StartAttackEat:
	li t0,1
	sw t0,PlayerLock,t1
	
	li t0,1
	beq s10,t0,AttackEat # se estiver com a habilidade de fogo nao precisa da animacao de StartAttack

	li s8,10
	sh s8,PlayerAnimTransit,t1
	
ContinueStartAttEat:
	beq s8,zero,AttackEat

	li s7,6
	j DoneAttack
	
AttackEat:
	li t0,30
	sh t0,PlayerAnimTransit,t1

	li s7,1
	j DoneAttack
	
KeepAttackEat:
	li s7,1
	bgt s8,zero,DoneAttack
	
	li t0,1
	beq s10,t0,EndAttFire # se estiver com a habilidade de fogo nao precisa da animacao de EndAttack

	li s7,7
	li t0,10
	sh t0,PlayerAnimTransit,t1
	j DoneAttack
	
EndAttackEat:
	li s7,7
	bgt s8,zero,DoneAttack
EndAttFire:	
	sw zero,PlayerLock,t1
	
	li s7,0
	j DoneAttack
	
AttackAir:
	li t0,30
	sh t0,PlayerAnimTransit,t1

	li s7,10
	j DoneAttack

EndAttackAir:
	li s7,10
	bgt s8,zero,DoneAttack
	
	li s7,0
	j DoneAttack

DoneAttack:


HorizontalMove:
	lh s4,PlayerSpeedX		# s4, velocidade X do jogador em seu valor completo
	li t1,playerDeaccX		# t1, velocidade de desaceleracao do jogador no eixo X 
	li t2,playerAccX		# t2, velocidade de aceleracao do jogador no eixo X
	li t3,playerMaxSpX		# t3, velocidade maxima do jogador no eixo X
	
SlowLeftToRight:
	bgt s4,zero,SlowRightToLeft	# se velocidade for positiva ou 0 vai para o proximo slow
	bne s9,zero,LockedR
	li t0,'a'
	beq s0,t0,MoveLeft		# se velocidade for negativa e 'a' esta apertado nao ha porque desacelerar
	beq s4,zero,SlowRightToLeft	# se velocidade for zero ainda precisa conferir se 'd' esta sendo apertado
LockedR:  # mesmo quando travado precisa desacelerar
	
	add s4,s4,t1
	ble s4,zero,DoneHorizontalMv
	mv s4,zero			# se a velocidade ficou positiva ao desacelerar precisa voltar para zero
	j DoneHorizontalMv
	
SlowRightToLeft:
	bne s9,zero,LockedL
	li t0,'d'
	beq s0,t0,MoveRight		# se velocidade for positiva e 'd' esta apertado nao ha porque desacelerar
	beq s4,zero,DoneHorizontalMv	# se a velocidade for zero nesse ponto nao ha porque desacelerar o jogador
LockedL:  # mesmo quando travado precisa desacelerar
	
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
	lhu t1,PlayerGndState		# t1, variavel de estado do jogador
	li t2,gravityAcc		# t2, velocidade de aceleracao da gravidade
	li t3,playerMaxQuickFallSp	# t3, velocidade maxima de queda do jogador
	
	li t0,playerFlyIndex
	blt s6,t0,NotFlying
	li t3,playerMaxSlowFallSp
NotFlying:
	
	bne zero,s9,LockedJump
	
	li t0,9
	beq s6,t0,CheckStartFly
BackCheckStFly:
	
	li t0,'w'
	beq s0,t0,MoveFly
	
	li t0,' '			
	beq s0,t0,MoveJump		# pulo unico
LockedJump:

	beq t1,zero,MoveFall		# se estado do jogador for 0 ele esta caindo
	
	blt s5,zero,DoneVerticalMv	# se o jogador estiver indo para cima o chao nao para ele (impede um snap que estava acontecendo)
	mv s5,zero 		 	# se o jogador nao estiver no ar ou tiver pulado, entao esta no chao e sua velocidade Y se torna zero
	j DoneVerticalMv
	
CheckStartFly:
	li s7,playerFlyIndex 
	beq s8,zero,BackCheckStFly  # se a animacao inflando ja acabou o sprite deve ser o de voo comum
	
	li s7,9
	j BackCheckStFly
	
MoveFly:

	li t0,playerFlyIndex
	bge s6,t0,BoostFly # se ja estiver voando continua com a animacao de voo (salva no CheckStartFly)
	
	li t0,playerMouthIndex
	bge s10,t0,MoveJump # se estiver com item na boca nao ha o pulo infinito

	li t0,9
	bne s6,t0,StartMoveFly
	# se estiver na animacao iniciando voo, ela ja foi definida para ser mantida no CheckStartFly

	j BoostFly

StartMoveFly:
	li s7,9 # transicao inflar

	li t0,20
	sh t0,PlayerAnimTransit,t1
BoostFly:

	li s5,playerFlyPow
	j DoneVerticalMv

MoveJump:
	li t0,playerFlyIndex
	bge s6,t0,MoveFly

	beq t1,zero,MoveFall		# se estado do jogador for 0 ele esta caindo, impede que o jogador pule no ar apos usaro pulo unico

	li s5,playerJumpPow
	j DoneVerticalMv

MoveFall:	# se estado for 0 entao o jogador esta caindo
	add s5,s5,t2			# adiciona a gravidade a velocidade do jogador
	ble s5,t3,DoneVerticalMv
	mv s5,t3			# velocidade se torna a velocidade maxima caso tenha a ultrapassado
	j DoneVerticalMv

DoneVerticalMv:	
	sh s5,PlayerSpeedY,t0		# armazena a velocidade Y completa do jogador (em centenas)
	sh s7,PlayerAnimState,t0
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
	blt s1,zero,FimPlayerControls
	bgt s1,t0,FimPlayerControls		# analisa se passou das bordas dos lados
	
	mv t0,s11
	srli t0,t0,16		
	addi t0,t0,-16			# t0, tamanho da coluna de pixels -16
	
	#li t0,224		
	blt s2,zero,FimPlayerControls
	bgt s2,t0,FimPlayerControls		# analisa se passou das bordas de cima e de baixo
	
	slli t0,s2,16
	add t0,t0,s1
	sw t0,TempPlayerPos,t1
	
	j PlayerColCheck
	
PlayerColCheck:

	la a0,TempPlayerPos
	jal CollisionUpdate

	la s3,collisionRender
	
	mv t0,s1
	andi t0,t0,0xf
	add s3,s3,t0			# adiciona o resto do offset X por 16
	
	mv t0,s2
	andi t0,t0,0xf
	li t1,32
	mul t0,t0,t1			# adiciona as linhas com base no resto do offset Y por 16
	
	add s3,s3,t0			# s3, inicialmente como o endereco para o primeiro pixel do jogador no mapa de colisoes renderizado
	
SetupPlayerFloor:	
	sh zero,PlayerGndState,t5	# determina que jogador esta no ar
	
	mv t0,s3
	li t1,480 # 15 linhas do sprite x 32 pixels da renderizacao da colisao
	add t0,t0,t1 
	li t2,56 # verde
	mv t3,zero
	li t4,4				# contador de pixels a analisar
PlayerFloor:
	lbu t1,0(t0)
	lbu t5,32(t0)
	bne t5,t2,DontSetGroundSt	# analisa pixels 1, 6, 11 e 16 da primeira linha abaixo do jogador
	li t6,1
	sh t6,PlayerGndState,t5		# se algum dos pixels logo abaixo do jogador forem de chao ele passa a estar no estado "no chao"
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
	#sh zero,PlayerSpeedY,t1
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
	addi t0,t0,160			# avanca 5 linhas no mapa de colisao
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
	addi t0,t0,160			# avanca 5 linhas no mapa de colisao
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
	mv t1,zero
	sh t1,OffsetX,t2		# armazena novo offset X
FimChangeOffsetX:

	li t0,112			# precisa parar sprite no pixel 109 do bitmap (contando de 1)
	bge s2,t0,ChangeOffsetY		# se e necessario mover a tela atualiza o offset
	mv t1,zero
	sh t1,OffsetY,t2		# armazena novo offset X
FimChangeOffsetY:
	
FimPlayerControls:
	lw ra,0(sp)
	addi sp,sp,4			# recupera endereco de retorno da pilha

  	ret
  	

ChangeOffsetX:
	mv t0,s11
	slli t0,t0,16
	srli t0,t0,16			# tamanho X do mapa
			
	addi t0,t0,-168			# pixel mais a direita do mapa que muda o offset
	bgt s1,t0,MaxOffsetX		# se o jogador estiver no fim da tela, o offset sempre sera o maior possï¿½vel

	li t1,152				
	sub t1,s1,t1			# offsetX = posicao real do jogador - 152

	sh t1,OffsetX,t2		# armazena novo offset X
	
	j FimChangeOffsetX
	
MaxOffsetX:
	li t1,152
	sub t0,t0,t1			# em t0 esta o valor maximo de X que altera o offset, entao e sï¿½ subtrair metade da tela e 8 pixels do sprite
	
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
	sub t0,t0,t1			# em t0 esta o valor maximo de Y que altera o offset, entao e so subtrair metade da tela e 8 pixels do sprite
	
	sh t0,OffsetY,t2		# armazena novo offset Y como o maior valor possivel 
	
	j FimChangeOffsetY

# s1, posicao X original do sprite; s2, posicao Y original do sprite; s3, endereco do pixel 0,0 do sprite no frame 1; t0, endereco do pixel de colisao sendo analisado no frame 1 
SnapUp:		# sobe o jogador em uma linha, loopando ate nao estar mais em colisao
	addi s2,s2,-1
	addi s3,s3,-32
	addi t0,t0,-32
	ret			
SnapDown: 	# desce o jogador em uma linha, loopando ate nao estar mais em colisao
	addi s2,s2,1	
	addi s3,s3,32
	addi t0,t0,32
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
PlayerAnimation:
	addi sp,sp,-4
	# s0, s1, s2, s3, s4, s5, s6, s7
	sw ra,0(sp)			# pilha armazena apenas valor de retorno

	lw s0,PlayerLastDir		# se estiver virado para a esquerda s0 = 0, para a direita s0 = 1

	lhu t3,PlayerAnimTransit
	
	mv t0,t3
	beq t0,zero,SkipSubTransit
	addi t0,t0,-1
	sh t0,PlayerAnimTransit,t1
SkipSubTransit:

	lw t0,PlayerObjDelay ### TODO temporario?
	beq t0,zero,SkipSubDelay
	addi t0,t0,-1
	sw t0,PlayerObjDelay,t1
SkipSubDelay:
	
	lhu s8,PlayerAnimState
	lhu s9,PlayerPowState
	
	bgt t3,zero,DefTransition

	lhu t0,PlayerGndState		# analisa se o jogador esta no chao ou no ar
	beq t0,zero,DefineAnimVert
	li t1,1
	beq t0,t1,DefineAnimHorz
	
DefTransition:
	
	li t0,1
	beq s9,t0,DefFireAnim
	li t0,2
	beq s9,t0,DefIceAnim
	li t0,3
	bge s9,t0,DefSpitAnim

	li t0,1
	li s1,11
	beq s8,t0,DefinedAnim

	li t0,6
	li s1,10
	beq s8,t0,DefinedAnim
	
	li t0,7
	li s1,12
	beq s8,t0,DefinedAnim
	
DefFireAnim:
	li t0,1
	li s1,14
	beq s8,t0,DefinedAnim
	
	j EndDefFireIce
	
DefIceAnim:
	li t0,6
	li s1,15
	beq s8,t0,DefinedAnim
	
	li t0,1
	li s1,16
	beq s8,t0,DefinedAnim
	
	li t0,7
	li s1,17
	beq s8,t0,DefinedAnim
	
	j EndDefFireIce
	
DefSpitAnim:
	li s1,7 ### TODO
	j DefinedAnim
	
EndDefFireIce:
	li t0,9
	li s1,9 # DefStartFly
	beq s8,t0,DefinedAnim
	
	li t0,10
	li s1,13 # DefAttackAir
	beq s8,t0,DefinedAnim

DefineAnimHorz:
	lh t0,PlayerSpeedX
	lh t1,PlayerAnimState
	
	li t2,4
	bge t1,t2,DefFlyKirbyHorz
	
	li t2,playerMouthIndex
	bge s9,t2,DefBigAnimHorz
	
	blt t0,zero,DefNegSpeedX
	bgt t0,zero,DefPosSpeedX
	
	mv s1,zero
	j DefinedAnim
	
DefFlyKirbyHorz:
	li s1,6
	j DefinedAnim
	
DefBigAnimHorz:
	bne t0,zero,DefBigWalk
	# Big Idle
	li s1,7
	j DefinedAnim
DefBigWalk:
	li s1,8
	j DefinedAnim
	
DefNegSpeedX:
	li s1,1
	beq s0,zero,DefinedAnim
	li s1,2		# break left to right se estiver apertando 'd' mas com velocidade para a esquerda
	j DefinedAnim
	
DefPosSpeedX:
	li s1,2		# break right to left se estiver apertando 'a' mas com velocidade para a direita
	beq s0,zero,DefinedAnim
	li s1,1		
	j DefinedAnim
	
	
DefineAnimVert:
	lh t0,PlayerSpeedY
	lh t1,PlayerAnimState
	
	li t2,4
	bge t1,t2,DefAnimFly
	
	li t2,playerMouthIndex
	bge s9,t2,DefBigWalk # animacao de pulo com item na boca e a mesma de andar

	li s1,3
	blt t0,zero,DefinedAnim  # quick jump
	li s1,4
	j DefinedAnim  # quick fall
	
DefAnimFly:
	li s1,5
	ble t0,zero,DefinedAnim  # slow jump
	li s1,6
	j DefinedAnim  # slow fall

DefinedAnim:
	sh s1,PlayerAnim,t0
	

	lw s5,FrameCount
	
	lw t0,PlayerSprite
	lhu s1,PlayerAnimCount
	lhu s2,PlayerMaxFrame	# duracao do sprite atual em frames, se for 0 sera um sprite sem animacao

	lhu s3,PlayerAnim
	lhu t0,PlayerOldAnim
	beq s3,t0,ContinueAnim  # continua uma animacao se o valor dela nao trocou
	
	# inicia uma nova animacao:
	sw s5,PlayerLastFrame,t1
	mv s1,zero	# define que o proximo sprite sera o sprite 0 (da animacao definida abaixo)
	
	li t1,4
	bne t1,s3,MostAnimCases
	# casos especiais para quando a nova animacao e da queda rapida:
	li t1,3
	beq t1,t0,MostAnimCases
	li s1,3  # se a animacao de queda rapida nao estiver vindo de um pulo unico, o kirby nao faz a cambalhota
	
MostAnimCases:
	sh s1,PlayerAnimCount,t1

ContinueAnim:
	sh s3,PlayerOldAnim,t1
	
	mv s6,zero  # inicia definindo a duracao da nova animacao como zero, para o caso das que tem apenas 1 frame
	la s7,playerCol  # inicia armazenando o sprite de colisao basico, ja que e usado na maioria dos sprites
	
	#mv a0,s3
	#li a7,1
	#ecall
	
	#la a0,endl
	#li a7,4
	#ecall	
	
	# definicao das animacoes
	beq s3,zero,PlayerIdle
	li t0,1
	beq s3,t0,PlayerWalk
	li t0,2
	la s4,kirbyBreak		# animacoes que tem apenas 1 frame nao precisam checar mudanca de frame
	beq s3,t0,PlayerBreak		# no caso do break ha a animacao de poeira
	li t0,3
	la s4,kirbyJump
	beq s3,t0,GotPlayerSprite
	li t0,4
	beq s3,t0,PlayerQuickFall
	li t0,5
	beq s3,t0,PlayerFly
	li t0,6
	beq s3,t0,PlayerSlowFall
	li t0,7
	la s4,kirbyBigIdle
	beq s3,t0,GotPlayerSprite
	li t0,8
	beq s3,t0,PlayerBigWalk
	li t0,9
	beq s3,t0,PlayerStartFly
	li t0,10
	beq s3,t0,PlayerStartEat
	li t0,11
	beq s3,t0,PlayerEat
	li t0,12
	beq s3,t0,PlayerEndEat
	li t0,13
	beq s3,t0,PlayerAirAttack
	li t0,14
	beq s3,t0,PlayerFireAttack
	li t0,15
	la s4,kirbyIceAtt0
	beq s3,t0,GotPlayerSprite
	li t0,16
	beq s3,t0,PlayerIceAttack
	li t0,17
	la s4,kirbyIceAtt0
	beq s3,t0,GotPlayerSprite
		
PlayerIdle:
	jal CheckNextSprAnim
	andi s1,s1,3

	la s4,kirbyIdle0
	li s6,150
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyIdle1
	li s6,10
	beq s1,t0,GotPlayerSprite
	li t0,2
	la s4,kirbyIdle0
	li s6,10
	beq s1,t0,GotPlayerSprite
	li t0,3
	la s4,kirbyIdle1
	li s6,10
	beq s1,t0,GotPlayerSprite
	
PlayerWalk:
	jal CheckNextSprAnim
	andi s1,s1,3

	la s4,kirbyWalk0
	li s6,10
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyWalk1
	li s6,10
	beq s1,t0,GotPlayerSprite
	li t0,2
	la s4,kirbyWalk2
	li s6,10
	beq s1,t0,GotPlayerSprite
	li t0,3
	la s4,kirbyWalk3
	li s6,10
	beq s1,t0,GotPlayerSprite
	
PlayerBreak:
	lw t0,PlayerObjDelay
	bgt t0,zero,GotPlayerSprite # trocar essa label se copiar essa linha
	
	li t0,4
	sw t0,PlayerObjDelay,t1

	li a0,1 # id do objeto (poeira)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	mv a4,zero
	
	jal BuildObject
	
	j GotPlayerSprite
	
PlayerQuickFall:
	jal CheckNextSprAnim
	li t0,5
	slt t1,s1,t0
	mul s1,s1,t1		# um mod 5 manual
	
	la s4,kirbyFall0
	li s6,5
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyFall1
	li s6,5
	beq s1,t0,GotPlayerSprite
	li t0,2
	la s4,kirbyFall2
	li s6,5
	beq s1,t0,GotPlayerSprite
	li t0,3
	la s4,kirbyFall3
	li s6,30
	beq s1,t0,GotPlayerSprite
	li t0,4
	la s4,kirbyFall4
	li s6,500
	beq s1,t0,GotPlayerSprite

PlayerFly:
	la s7,playerCol
	
	jal CheckNextSprAnim
	andi s1,s1,1
	
	la s4,kirbyFly0
	li s6,10
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyFly1
	li s6,10
	beq s1,t0,GotPlayerSprite
	
PlayerSlowFall:
	la s7,playerCol

	jal CheckNextSprAnim
	andi s1,s1,1
	
	la s4,kirbyFly0
	li s6,25
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyFly1
	li s6,25
	beq s1,t0,GotPlayerSprite
	
PlayerBigWalk:
	la s7,playerCol

	jal CheckNextSprAnim
	andi s1,s1,3

	la s4,kirbyBigWalk0
	li s6,10
	beq s1,zero,GotPlayerSprite
	
	lh t1,PlayerSpeedY # se o jogador estiver caindo trava nessa animacao
	bgt t1,zero,GotPlayerSprite
	
	li t0,1
	la s4,kirbyBigWalk1
	li s6,10
	beq s1,t0,GotPlayerSprite
	li t0,2
	la s4,kirbyBigWalk2
	li s6,10
	beq s1,t0,GotPlayerSprite
	li t0,3
	la s4,kirbyBigWalk1
	li s6,10
	beq s1,t0,GotPlayerSprite
	
PlayerStartEat:
	jal CheckNextSprAnim
	andi s1,s1,1
	
	la s4,kirbyEat1
	li s6,5
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyEat2
	li s6,5
	la s7,playerEatCol
	beq s1,t0,GotPlayerSprite

PlayerEat:
	lw t0,PlayerObjDelay
	li t1,10
	beq t0,t1,TinyDustObj2
	li t1,5
	beq t0,t1,TinyDustObj3
	bgt t0,zero,DoneTinyDustObjs
	
	li t0,15
	sw t0,PlayerObjDelay,t1

	li a0,5 # id do objeto (area de puxar)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	mv a4,zero
	jal BuildObject

	li a0,2 # id do objeto (poeira pequena)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	li a4,1
	jal BuildObject
	
	li a0,2 # id do objeto (poeira pequena)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	li a4,3
	jal BuildObject

	j DoneTinyDustObjs

TinyDustObj2:
	li a0,5 # id do objeto (area de puxar)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	mv a4,zero
	jal BuildObject
	
	li a0,2 # id do objeto (poeira pequena)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	mv a4,zero
	jal BuildObject
	
	li a0,2 # id do objeto (poeira pequena)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	li a4,5
	jal BuildObject

	j DoneTinyDustObjs

TinyDustObj3:	
	li a0,5 # id do objeto (area de puxar)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	mv a4,zero
	jal BuildObject

	li a0,2 # id do objeto (poeira pequena)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	li a4,2
	jal BuildObject
	
	li a0,2 # id do objeto (poeira pequena)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	li a4,4
	jal BuildObject
	
DoneTinyDustObjs:
	
	la s4,kirbyEat2
	
	j GotPlayerSprite

PlayerEndEat:
	jal CheckNextSprAnim
	andi s1,s1,1
	
	la s4,kirbyEat2
	li s6,5
	la s7,playerEatCol
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyEat1
	li s6,5
	beq s1,t0,GotPlayerSprite
	
PlayerStartFly:
	jal CheckNextSprAnim
	andi s1,s1,3
	
	la s4,kirbyEat0
	li s6,5
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyEat1
	li s6,5
	beq s1,t0,GotPlayerSprite
	li t0,2
	la s4,kirbyEat2
	li s6,5
	la s7,playerEatCol
	beq s1,t0,GotPlayerSprite
	li t0,3
	la s4,kirbyEat3
	li s6,5
	la s7,playerCol
	beq s1,t0,GotPlayerSprite
	
PlayerAirAttack:
	lw t0,PlayerObjDelay
	bgt t0,zero,DoneAirObj
	
	li t0,30
	sw t0,PlayerObjDelay,t1

	li a0,6 # id do objeto (ar)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	mv a4,zero
	jal BuildObject
DoneAirObj:

	jal CheckNextSprAnim
	andi s1,s1,3
	
	la s4,kirbyEat3
	li s6,15
	la s7,playerCol
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyEat2
	li s6,5
	la s7,playerEatCol
	beq s1,t0,GotPlayerSprite
	li t0,2
	la s4,kirbyEat1
	li s6,5
	la s7,playerCol
	beq s1,t0,GotPlayerSprite
	li t0,3
	la s4,kirbyEat0
	li s6,5
	beq s1,t0,GotPlayerSprite

PlayerIceAttack:
	lw t0,PlayerObjDelay
	li t1,8
	beq t0,t1,IceObjects2
	bgt t0,zero,DoneIceObjs
	
	li t0,16
	sw t0,PlayerObjDelay,t1

	li a0,4 # id do objeto (gelo)
	
	lw a3,PlayerLastDir
	mv a4,zero ### TODO trocar essa logica para usar o MovPat
	
	lhu s8,PlayerPosX
	lhu s9,PlayerPosY
	
	li a1,1 # quantidade do objeto
	addi t0,s8,8  
	addi t1,s9,20
	slli a2,t1,16
	add a2,a2,t0
	jal BuildObject
	
	li a1,1 # quantidade do objeto
	addi t0,s8,8
	addi t1,s9,-20
	slli a2,t1,16
	add a2,a2,t0
	jal BuildObject
	
	li a1,1 # quantidade do objeto
	addi t0,s8,-20
	addi t1,s9,0
	slli a2,t1,16
	add a2,a2,t0
	jal BuildObject
	
	j DoneIceObjs
	
IceObjects2:
	li a0,4 # id do objeto (gelo)
	
	lw a3,PlayerLastDir
	mv a4,zero
	
	lhu s8,PlayerPosX
	lhu s9,PlayerPosY
	
	li a1,1 # quantidade do objeto
	addi t0,s8,-8
	addi t1,s9,20
	slli a2,t1,16
	add a2,a2,t0
	jal BuildObject
	
	li a1,1 # quantidade do objeto
	addi t0,s8,-8
	addi t1,s9,-20
	slli a2,t1,16
	add a2,a2,t0
	jal BuildObject
	
	li a1,1 # quantidade do objeto
	addi t0,s8,20
	addi t1,s9,0
	slli a2,t1,16
	add a2,a2,t0
	jal BuildObject
	
	j DoneIceObjs

DoneIceObjs:

	jal CheckNextSprAnim
	andi s1,s1,1
	
	la s4,kirbyIceAtt1
	li s6,3
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyIceAtt2
	li s6,3
	beq s1,t0,GotPlayerSprite

PlayerFireAttack:
	lw t0,PlayerObjDelay
	li t1,6
	slt a4,t0,t1 # a4, define se o fogo vai para cima (0) ou para baixo (1)
	beq t0,t1,FireObject2
	bgt t0,zero,DoneFireObjs

	li t0,12
	sw t0,PlayerObjDelay,t1
FireObject2:

	li a0,3 # id do objeto (fogo)
	
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	jal BuildObject
	
	j DoneFireObjs

DoneFireObjs:
	jal CheckNextSprAnim
	andi s1,s1,1
	
	la s4,kirbyFireAtt0
	li s6,3
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyFireAtt1
	li s6,3
	beq s1,t0,GotPlayerSprite

PlayerSpitItem: ### TODO
	j DoneIceObjs

GotPlayerSprite:
	sh s1,PlayerAnimCount,t0
	sw s4,PlayerSprite,t0	# armazena o endereco do novo sprite no PlayerSprite
	sh s6,PlayerMaxFrame,t0  # armazena a duracao da animacao atual
	sw s7,PlayerColSprite,t0  # armazena o sprite de colisao

FimPlayerAnimation:
	lw ra,0(sp)
	addi sp,sp,4			# recupera endereco de retorno da pilha

	ret
	
CheckNextSprAnim:
	
	# s5, frameCount
	# s2, frames de duracao do sprite
	lw t1,PlayerLastFrame
	
	sub t2,s5,t1	
	blt t2,s2,keepSprAnim
	beq s2,zero,keepSprAnim		# se estiver chegando de um sprite fixo
	
	sw s5,PlayerLastFrame,t0
	addi s1,s1,1 		# avanca o contador de sprites da animacao se a duracao do sprite passou
keepSprAnim:

	ret
	
#----------
Print: 		# a0 = sprite que vai ser impresso; a1 = posicao do sprite 0xYYYYXXXX;
		# a2 = sprite de colisao; a3 = 0 para esquerda ou 1 para direita; a4 = 0, 1 ou 2 para o caso especifico do jogador estar com poderes
	# s0, s1, s2, s3, s4, s5, s6 
	
	addi sp,sp,-40
	sw ra,0(sp)
	sw s0,4(sp)
	sw s1,8(sp)
	sw s2,12(sp)
	sw s3,16(sp)
	sw s4,20(sp)
	sw s5,24(sp)
	sw s6,28(sp)
	sw s7,32(sp)
	sw s8,36(sp)
	
	mv s4,a3
	
	li t0,0xffff
	and s0,a1,t0
	srli s1,a1,16 			# salva posicao inicial do sprite	
	
	lh s2,8(a0)			# salva a distancia X para iniciar a desenhar o sprite
	lh s3,10(a0)			# salva a distancia Y para iniciar a desenhar o sprite
	
	lhu t0,OffsetX
	sub t3,s0,t0			# subtrai o X do sprite pelo offset X
	sub t3,t3,s2			# subtrai a distancia X para iniciar o sprite
	lhu t0,OffsetY			
	sub t4,s1,t0			# subtrai o Y do sprite pelo offset Y
	sub t4,t4,s3			# subtrai a distancia Y para iniciar o sprite
	
	#blt s0,zero,FimPrint		# se x for menor que 0 impede que algo seja impresso no outro lado do bitmap
	
	li t1,320
	li t2,240
	#rem t3,t3,t1			# corrige a posicao no bitmap quando ela passa do 320x240 inicial
	#rem t4,t4,t2			# tecnicamente desnecessario por causa do offset, mas mantido por garantia e para testes que mudam a posicao manualmente
	
	lw a3,BitmapFrame
	
	mul t1,t1,t4
	add s7,a3,t1 			# adiciona y ao endereco do bitmap e armazena esse valor em s7 para evitar o underflow de sprites no bitmap
	addi s8,s7,319			# s8, valor maximo da linha, para evitar o overflow de sprites
	
	add t0,s7,t3 			# adiciona x ao endereco do bitmap
	
	addi t1,a0,spriteHeader		# endereco do sprite mais spriteHeader
	
	mv t2,zero
	mv t3,zero
	
	lw t4,0(a0) 			# guarda a largura do sprite
	lw t5,4(a0) 			# guarda a altura do sprite
	
	beq s4,zero,PreLinhaRev

Linha: 		# t0 = endereco do bitmap display; t1 = endereco do sprite
	blt t0,a3,SkipOOBLinha
	blt t0,s7,SkipOOBLinha
	bgt t0,s8,SkipOOBLinha

	lbu t6,0(t1) 			# guarda um pixel do sprite (nao pode ser word por nao estar sempre alinhado com o endereco)
	jal CheckColors
	sb t6,0(t0) 			# desenha no bitmap display (4 pixels separadamente)
	lbu t6,1(t1) 			
	jal CheckColors
	sb t6,1(t0) 			
	lbu t6,2(t1) 			
	jal CheckColors
	sb t6,2(t0) 			
	lbu t6,3(t1) 			
	jal CheckColors
	sb t6,3(t0) 			
SkipOOBLinha:
	addi t0,t0,4 			# avanca o endereco do bitmap display em 4
	addi t1,t1,4 			# avanca o endereco da imagem em 4
	
	addi t3,t3,4 			# avanca o contador de colunas em 4
	blt t3,t4,Linha 		# enquanto a linha nao estiver completa, continua desenhando ela

	addi s7,s7,320
	addi s8,s8,320

	addi t0,t0,320 			# avanca para a proxima linha
	sub t0,t0,t4 			# subtrai a largura do sprite
		
	mv t3,zero 			# reseta o contador de colunas
	addi t2,t2,1 			# avanca o contador de linhas em 1
	blt t2,t5,Linha 		# enquanto o contador de linhas for menor que a altura repete a funcao
	j FimPrint

PreLinhaRev:
	add t0,t0,t4
	addi t0,t0,-4

LinhaReverse:
	blt t0,a3,SkipOOBLinhaRev
	blt t0,s7,SkipOOBLinhaRev
	bgt t0,s8,SkipOOBLinhaRev

	lbu t6,3(t1) 			# guarda um pixel do sprite (nao pode ser word por nao estar sempre alinhado com o endereco)
	jal CheckColors
	sb t6,0(t0) 			# desenha no bitmap display (4 pixels separadamente)
	lbu t6,2(t1) 			
	jal CheckColors
	sb t6,1(t0) 			
	lbu t6,1(t1) 			
	jal CheckColors
	sb t6,2(t0) 			
	lbu t6,0(t1) 			
	jal CheckColors
	sb t6,3(t0) 

SkipOOBLinhaRev:
	addi t0,t0,-4 			# recua o endereco do bitmap display em 4
	addi t1,t1,4 			# avanca o endereco da imagem em 4
	
	addi t3,t3,4 			# avanca o contador de colunas em 4
	blt t3,t4,LinhaReverse 		# enquanto a linha nao estiver completa, continua desenhando ela
	
	addi s7,s7,320
	addi s8,s8,320
	
	addi t0,t0,320 			# avanca para a proxima linha
	add t0,t0,t4
		
	mv t3,zero 			# reseta o contador de colunas
	addi t2,t2,1 			# avanca o contador de linhas em 1
	blt t2,t5,LinhaReverse 		# enquanto o contador de linhas for menor que a altura repete a funcao
	j FimPrint

	
CheckColors:
	beq a4,zero,EndCheckColors
	li s6,1
	beq a4,s6,FireColors
	li s6,2
	beq a4,s6,IceColors
	j EndCheckColors
	
FireColors: # 0 -> 0; 159 -> 103; 239 -> 183
	li s6,159
	beq t6,s6,DarkFire
	li s6,239
	beq t6,s6,LightFire
	j EndCheckColors
DarkFire: li t6,103
	j EndCheckColors
LightFire: li t6,183
	j EndCheckColors
	
IceColors: # 0 -> 129; 159 -> 235; 239 -> 255
	beq t6,zero,BorderIce
	li s6,159
	beq t6,s6,DarkIce
	li s6,239
	beq t6,s6,LightIce
	j EndCheckColors
BorderIce: li t6,129
	j EndCheckColors
DarkIce: li t6,235
	j EndCheckColors
LightIce: li t6,255
	j EndCheckColors
EndCheckColors:
	ret

FimPrint:
	lw ra,0(sp)
	lw s0,4(sp)
	lw s1,8(sp)
	lw s2,12(sp)
	lw s3,16(sp)
	lw s4,20(sp)
	lw s5,24(sp)
	lw s6,28(sp)
	lw s7,32(sp)
	lw s8,36(sp)
	addi sp,sp,40

	ret 

#----------
CollisionUpdate: # a0 = endereco com a posicao inicial

	addi sp,sp,-32
	sw ra,0(sp)
	sw s0,4(sp)
	sw s1,8(sp)
	sw s2,12(sp)
	sw s3,16(sp)
	sw s4,20(sp)
	sw s5,24(sp)
	sw s6,28(sp)
	
	lhu a1,0(a0)			# a1, posicao X original do sprite
	lhu a2,2(a0)			# a2, posicao Y original do sprite
	
	#andi s0,a1,0xf			# s0, resto da posicao X por 16
	srli s1,a1,4			# s1, divisao da posicao X por 16
	
	#andi s2,a2,0xf			# s2, resto da posicao Y por 16
	srli s3,a2,4			# s3, divisao da posicao Y por 16
	
	la t0,mapa40x30 #mapaCodesAtual			
	lw t1,0(t0)			# t1, tamanho do mapa de tiles
	mul t2,s3,t1			
	
	addi t0,t0,spriteHeader
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
	
	lbu t3,1(t0)			# valor do quarto tile
	slli t3,t3,24
	add t4,t4,t3			# t4 = 0x44332211
	
	la s4,BGTileCodes		# s4, endereco com todos os codigos de tile
	sw t4,0(s4)			
	mv s5,zero			# s5, contador de tiles
LoopRenderCol:

	lbu s6,0(s4) 			# s6, codigo do tile atual

	li t3,1				# analise dos codigos de tile
	beq s6,t3,GetColTile1
	li t3,2
	beq s6,t3,GetColTile2
	li t3,3
	beq s6,t3,GetColTile3
	li t3,4
	beq s6,t3,GetColTile4
	li t3,5
	beq s6,t3,GetColTile5
	li t3,6
	beq s6,t3,GetColTile6
	
GetColTile1:
	#la a3,grama
	la a5,emptyCol
	j GotLimparTile
GetColTile2:
	#la a3,chao
	la a5,emptyCol
	j GotLimparTile
GetColTile3:
	#la a3,plataforma1
	la a5,plataforma1Col
	j GotLimparTile
GetColTile4:
	#la a3,plataforma2
	la a5,plataforma2Col
	j GotLimparTile
GetColTile5:
	#la a3,plataforma3
	la a5,plataforma3Col
	j GotLimparTile
GetColTile6:
	#la a3,blocoExemp
	la a5,blocoExempCol
	j GotLimparTile

GotLimparTile:	# a5, sprite de colisao que sera desenhado
	
	la t0,collisionRender
	
	beq s5,zero,LeftColTile
	li t1,2
	beq s5,t1,LeftColTile
	# se for um dos tiles da coluna direita:
	addi t0,t0,16
LeftColTile:
	blt s5,t1,UpperColTile
	# se for um dos tiles da linha de baixo
	addi t0,t0,512
UpperColTile:		
	
	mv t1,a5
	addi t1,t1,spriteHeader
	mv t2,zero			# t2, contador de colunas
	mv t3,zero			# t3, contador de linhas
	li t4,16
	li t5,16

SaveTileRenderCol:

	lw t6,0(t1) 			# guarda uma word do tile
	sw t6,0(t0) 			# salva no render de colisao

	addi t0,t0,4			# avanca o endereco do bitmap em 1
	addi t1,t1,4 			# avanca o endereco da imagem em 1		
	
	addi t2,t2,4 			# avanca o contador de colunas em 1
	blt t2,t4,SaveTileRenderCol 	# enquanto a linha nao estiver completa, continua desenhando ela
	
	addi t0,t0,16 			# avanca para a proxima linha do render

	mv t2,zero 			# reseta o contador de colunas
	addi t3,t3,1 			# avanca o contador de linhas em 1
	blt t3,t5,SaveTileRenderCol 	# enquanto o contador de linhas for menor que a altura repete a funcao

NextTileRenderCol:
	addi s4,s4,1			# avanca para o proximo codigo de tile
	addi s5,s5,1			# avanca o contador de tiles
	
	li t2,4
	beq s5,t2,FimRenderCol		# se ja foram todos os 4 tiles segue com o CollisionUpdate
	j LoopRenderCol
	
FimRenderCol:
RenderObjectsCol:
	

FimCollisionUpdate:
	
	lw ra,0(sp)
	lw s0,4(sp)
	lw s1,8(sp)
	lw s2,12(sp)
	lw s3,16(sp)
	lw s4,20(sp)
	lw s5,24(sp)
	lw s6,28(sp)
	addi sp,sp,32

	ret 

#----------
PrintMapa:
	
	#w t0,OffsetX
	#lw t1,OldOffset
	#beq t0,t1,FimPrintMapa		# se o offset nao mudou skipa o print do mapa  ## retirado devido a troca de frame, que obriga o mapa ser desenhado todo frame

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

	beq s6,s9,FimPrintMapa	# continua o cï¿½digo quando todos os tiles forem analisados
	
	la a0,mapa40x30
	
	lw t1,0(a0)
	
	add a0,a0,s1		# adiciona offsetX/16
	add a0,a0,s4		# adiciona contador de colunas
	
	mv t0,s3		# adiciona offsetY/16
	add t0,t0,s5		# adiciona contador de linhas
	mul t0,t0,t1		# multiplica por 40 (tamanho das linhas do mapa completo)
	add a0,a0,t0		
	
	addi a0,a0,spriteHeader
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
	
	j SaveCenterTile		# tiles do meio sï¿½o mais simples entï¿½o podem ser salvos mais rapidamente
FimSaveTile:
	
	addi s4,s4,1			# avanca contador de colunas de tiles
	addi s6,s6,1			# avanca contador total de tile
	bge s4,s7,NextLine		# se estiver no fim de uma linha vai para a proxima
	j LoopBuild
	
NextLine:				# prï¿½xima linha de tiles
	mv s4,zero		
	addi s5,s5,1			# avanca contador de linhas
	j LoopBuild

#----------
SaveTile: 	# a1 = sprite que vai ser salvo no mapa de pixels, a2 = offset das colunas, a3 = offset das linhas
	
	mv t1,s4

	slli t1,t1,4			# multiplica numero da coluna por 16 (tamanho dos tiles)
	blt a2,zero,FirstCol
	# todas as colunas exceto a 1a:
	sub t1,t1,s0			# resto do offset X subtraï¿½do do bitmap (puxa para a esquerda as colunas, se ocorrer na 1a = erro)
FirstCol:
	
	mv t2,s5
	li t0,320
	mul t2,t2,t0			# multiplica numero da linha por 320 (tamanho das linhas do bitmap)
	slli t2,t2,4			# multiplica numero da linha por 16 (tamanho dos tiles)
	blt a3,zero,FirstLine
	# todas as linhas exceto a 1a:
	mul t0,s2,t0
	sub t2,t2,t0			# resto do offset Y vezes 320 subtraï¿½do do bitmap (sobe as linhas, se ocorrer na 1a = erro)
FirstLine:
	
	lw a4,BitmapFrame
	add t0,a4,t1
	add t0,t0,t2 			# t0 = endereco base para salvar o sprite do tile
	
	addi t1,a1,spriteHeader		# endereco do sprite mais spriteHeader
		
	mv t2,zero			# contador de colunas do tile
	mv t3,zero			# contador de linhas do tile	
	
	sub t4,s8,s0			
	blt a2,zero,SetColSize		# na 1a coluna a largura do tile serï¿½ 16-OffsetX
	mv t4,s0
	bgt a2,zero,SetColSize		# na ultima coluna a largura do tile serï¿½ OffsetX
	lw t4,0(a1)			# nas outras colunas a largura do tile ï¿½ 16
SetColSize:
	beq t4,zero,FimSaveTile 	# se a ultima coluna nao estiver aparecendo, t4 = 0 e o tile pode ser skipado
	
	sub t5,s8,s2		
	blt a3,zero,SetLineSize		# na 1a linha a altura do tile serï¿½ 16-OffsetY
	mv t5,s2
	bgt a3,zero,SetLineSize		# na 1a linha a altura do tile serï¿½ OffsetY
	lw t5,4(a1)			# nas outras linhas a altura do tile ï¿½ 16
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
	
TileLine: 	# t0 = endereco do bitmap display; t1 = endereco do sprite

	lbu t6,0(t1) 			# guarda um pixel do sprite
	sb t6,0(t0) 			# desenha no bitmap display um pixel do sprite (jï¿½ que tamanho das linhas pode variar de 1 a 16)

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
	
	lw t0,BitmapFrame
	add t0,t0,t1
	add t0,t0,t2 			# t0, endereco base para salvar o sprite do tile
	
	addi t1,a1,spriteHeader		# endereco do sprite mais spriteHeader
	
	mv t2,zero			# contador de colunas do tile
	mv t3,zero			# contador de linhas do tile	
	
	lw t4,0(a1) 			# guarda a largura do tile
	lw t5,4(a1)			# guarda a altura do tile
				
CenterTileLine: 	# t0 = endereco do bitmap display; t1 = endereco do sprite

	lbu t6,0(t1) 			# guarda um pixel do sprite (nao pode ser word por nao estar sempre alinhado com o endereco)
	sb t6,0(t0) 			# desenha no bitmap display (4 pixels separadamente)
	lbu t6,1(t1) 			
	sb t6,1(t0)
	lbu t6,2(t1) 			
	sb t6,2(t0)
	lbu t6,3(t1) 			
	sb t6,3(t0)

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
