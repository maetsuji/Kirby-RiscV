.macro DE1(%reg,%salto)
	li %reg, 0x10008000	# carrega tp
	bne gp, %reg, %salto	# Na DE1 gp = 0 ! Nao tem segmento .extern
.end_macro

.data

.include "objects/objectDB.data"

BitmapFrame:	.word 0xff000000

StageID:	.half 0 # 0 = title. 1 = hub, 2 = Level1, 3 = Level2, 4 = Level3, 5 = Level4, 6 = Boss, 7 = Ending
Completion:	.half 0
FadeLines:	.half 0
FadeTimer:	.half 0
FadeColor:	.word 0

TitleControls: 	.word 0  # 0 = sair do jogo, 1 = ir para o hub

MapaPos:	.half 0, 0
MapGridAtual:	.word 0 # mapa40x30, hubGrid, stage1Grid, stage2Grid, stage3Grid, stage4Grid, whispyGrid
GridSizeX:	.half 0
GridSizeY:	.half 0
TileSprtStartAdd:.word 0 # testTiles, hubTiles, hubRTiles, stageTiles

ColGridAtual:	.word 0 # mapa40x30col, hubCol, stage1Col, stage2Col, stage3Col, stage4Col, whispyStageCol
ColSprtStartAdd:.word 0 # testColSprites, # colSprites (Col0)
.eqv tileFullSize 268 # 16x16 + 12, header + 256 bytes

OffsetX:	.half 0		# quantidade de pixels que o jogador se moveu na horizontal que modificam a posicao do mapa 
OffsetY:	.half 0		# quantidade de pixels que o jogador se moveu na vertical que modificam a posicao do mapa  
OldOffset:	.word 0		# precisa comecar com um valor para ser comparado no PrintMapa (so roda se a posicao antiga for diferente da atual) 

Score:		.word 0

PlayerHP:	.half 0		# endereco dessa variavel serve como ID do jogador, usada para comparacao no UpdateCollision
PlayerLives:	.half 0
PlayerPosX: 	.half 0		# posicao em pixels do jogador no eixo X (de 0 ate a largura do mapa completo)
PlayerPosY: 	.half 0		# posicao em pixels do jogador no eixo Y (de 0 ate a altura do mapa completo)
OldPlayerPos:	.word 0		# precisa comecar com um valor para ser comparado no Print (so roda se a posicao antiga for diferente da atual)  ## nao mais utilizado atualmente
TempPlayerPos:	.word 0
PlayerSpeedX:	.half 0		# velocidade completa do jogador (em centenas) no eixo X, dividida por 100 para ser usada como pixels
PlayerSpeedY:	.half 0		# velocidade completa do jogador (em centenas) no eixo Y, dividida por 100 para ser usada como pixels
PlayerGndState:	.half 0		# 0 = jogador no ar, 1 = jogador no chao
PlayerAnimState:.half 0		
# 0 = vazio,  1 = atacando, 2 = -, 3 = -, 4 = atingido com ar, 5 = atingido
# 6 = transicao inicio eat, 7 = transicao cancelar eat, 8 = abaixar/transicao engolir, 9 = transicao inflar, 10 = transicao soltar ar, 11 = transicao soltar item, 12 = transicao engolir
# 13 = cheio de ar
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
PlayerIFrames:	.word 0
PlayerDoor:	.word 0

.eqv playerMaxSpX 250
.eqv playerMaxQuickFallSp 200
.eqv playerMaxSlowFallSp 100
.eqv playerMaxJumpSp -4
.eqv playerAccX 120
.eqv playerDeaccX 10
.eqv playerSlowDeaccX 5
.eqv playerFlyPow -450
.eqv playerJumpPow -600
.eqv playerFlyIndex 13
.eqv playerMouthIndex 3
.eqv playerKnockbackX 250
.eqv playerKnockbackY -150

.eqv gravityAcc 25

.eqv spriteHeader 12

BGTileCodes:	.word 0		# armazena 4 (bytes) codigos de tiles para que o fundo seja montado no Limpar

LastKey: 	.word 0		# valor da ultima tecla pressionada
PlayerLastDir:	.word 1		# valor 0 ou 1 baseado na ultima tecla "a" ou "d" apertada, inicia como 1 = "d"

MoveKeys:	.byte 0, 0, 0, 0 # W, A, S, D
OtherKeys:	.byte 0, 0, 0, 0 # E, Space, -, -

LastGlblTime:	.word 0		# valor completo da ecall 30, que sempre sera comparado e atualizado para contar os frames
FrameCount:	.word 0		# contador de frames, sempre aumenta para que possa ser usado como outros contadores
.eqv FPS 50
.eqv frameMS 20 		# ms

MusicStartAdd:	.word 0
MusicAtual:	.word 0
LenMusAtual:	.word 0
NoteEndTime: 	.word 0
NoteCounter: 	.word 0

SoundDuration:	.word 0
SoundEffectAtual:.word 0
SoundInstrument:.word 0
SoundEndTime:	.word 0

ObjAtual:	.word 0
.eqv objQuant 20
.eqv objSize 20

.eqv enemyStartIndex 30
.eqv dangerQuant 5
.eqv enemyDangerQuant 5

BossHP:		.word 0
BossTimer:	.word 0
BossAnimState:	.word 0	# 0 = esperando, 1 = idle, 2 = atacando, 3 = atingido, 4 = derrotado
BossSprite:	.word 0 # valor especifico do frame que sera desenhado
BossOldAnim:	.word 0	
BossAnimCount:	.word 0
BossLastFrame:	.word 0
BossMaxFrame:	.word 0	
BossAnimDuration:.word 0
BossIFrames:	.word 0	
LastApple:	.word 0

tempPos:	.word 0

endl:		.string "\n"	# temporariamente sendo usado para debug (contador de ms)

.include "maps/whispySprites.data"
.include "archive/oldTests/testMap-Tiles.data"
.include "archive/oldTests/testColSprites.data"

.include "maps/title/titleSprites.data"
.include "maps/menu/menuSprites.data"
.include "maps/menu/numberSprites.data"
.include "maps/menu/letterSprites.data"

.include "maps/hubFullTileSprites.data"
.include "maps/hubSpecialTiles.data"
.include "maps/stageTileSprites.data"
.include "maps/stageCols.data"
.include "maps/stageGrids.data"


.include "kirby/kirbyMain.data" 
.include "kirby/kirbyMain2.data"
.include "kirby/kirbyPowers.data"

.include "objects/objectSprites.data"
.include "objects/enemySprites.data"

.include "collision/collisionCodes.data"
.include "collision/collisionRender.data"
.include "collision/colSprites.data"

.text
	j StartGame
.include "includes/objectsEnemies.s"
.include "includes/boss.s"
.include "includes/keyCheck.s"
.include "includes/sounds.s"


.include "includes/title.s"
.include "includes/menu.s"

	
#########################################################################################################################################
StartGame:
	csrr a0,3073
	sw a0,LastGlblTime,t0	# define o primeiro valor do timer global, que sera comparado no Clock
	
	li t0,7
	sh t0,PlayerHP,t1
	
	li t0,4
	sh t0,PlayerLives,t1
	
	li t0,28
	sw t0,BossHP,t1
	
	li a0,0xff
	mv a1,zero
	mv a2,zero
	li a3,320
	li a4,240
	li a5,1
	jal FillPrint
	
	jal ChangeFrame
	
	li a0,0xff
	mv a1,zero
	mv a2,zero
	li a3,320
	li a4,240
	li a5,1
	jal FillPrint

	j LoadTitle
	
SetNextLevel: # chamado do MoveFly, apos apertar 'w' com o PlayerDoor em 1
	sw zero,PlayerDoor,t0 # garante que volta a zero, pois unico lugar que tambem seta isso e no comeco da colisao do jogador com o chao
	
	lh t0,StageID
	li t1,1
	beq t0,t1,CheckHubDoor
	li t1,2
	beq t0,t1,LoadLevel2
	li t1,3
	beq t0,t1,LoadLevel3
	li t1,4
	beq t0,t1,LoadLevel4
	
	li t2,1
	sh t2,Completion,t1
	
	li t1,5
	beq t0,t1,LoadHub
	
CheckHubDoor:
	li t0,192
	lhu t1,PlayerPosY
	
	blt t1,t0,LoadBoss # se estiver no hub e se jogador estiver na metade de cima do hub quer dizer que ele entrou na porta do boss
	
	j LoadLevel1
	
LoadTitle:
	sh zero,StageID,t1
	
	la t0,NotasTitle			# define o endereco inicial das notas
	sw t0,MusicStartAdd,t1
	sw t0,MusicAtual,t1
	sw zero,NoteCounter,t1	# zera o NoteCounter
	
	lw t0,DuracaoTitle # DuracaoHub
	sw t0,LenMusAtual,t1
	
	lh t0,PlayerLives
	#bnez t0,DontFadeTitle # apenas da fade no title se o jogador morrer
	li t0,32
	sh t0,FadeTimer,t1
	li t0,0xff
	sw t0,FadeColor,t1
DontFadeTitle:
	
	li t0,4
	sh t0,PlayerLives,t1
		
	j TitleMain
	
LoadHub:
	li t0,1
	sh t0,StageID,t1
	
	# Definicao do mapa
	li t0,512 # 32
	li t1,368 # 23
	sh t0,GridSizeX,t2
	sh t1,GridSizeY,t2
	
	# Posicao inicial do jogador
	li t0,4
	li t1,17
	lh t2,Completion
	beqz t2,GotPlayerHubPos
	li t0,25
	li t1,16
GotPlayerHubPos:
	slli t0,t0,4
	slli t1,t1,4
	sh t0,PlayerPosX,t2
	sh t1,PlayerPosY,t2
	
	la t0,NotasHub			# define o endereco inicial das notas
	sw t0,MusicStartAdd,t1
	sw t0,MusicAtual,t1
	sw zero,NoteCounter,t1	# zera o NoteCounter
	
	lw t0,DuracaoHub
	sw t0,LenMusAtual,t1
	
	la t0,hubFullGrid 		# endereco do grid de tiles atual
	sw t0,MapGridAtual,t1
	
	la t0,hubRTiles 	# endereco inicial dos sprites de tile
	sw t0,TileSprtStartAdd,t1
	
	la t0,hubCol 		# endereco do grid de colisao atual
	sw t0,ColGridAtual,t1
	
	la t0,Col0 		# endereco inicial dos sprites de tile de colisao
	sw t0,ColSprtStartAdd,t1
	
	li t0,7
	sh t0,PlayerHP,t1
	
	sw zero,PlayerSpeedX,t0
	sh zero,PlayerAnimState,t0
	sw zero,PlayerIFrames,t0 
	sw zero,PlayerLock,t0
	
	jal ClearObjects
	
	li t0,32
	sh t0,FadeTimer,t1
	li t0,255
	sw t0,FadeColor,t1
	
	j Main

# # # # #
LoadLevel1:
	li t0,2
	sh t0,StageID,t1
	
	# Definicao do mapa
	li t0,272 # 17
	li t1,368 # 23
	sh t0,GridSizeX,t2
	sh t1,GridSizeY,t2
	
	# Posicao inicial do jogador
	li t0,2
	li t1,12
	slli t0,t0,4
	slli t1,t1,4
	sh t0,PlayerPosX,t2
	sh t1,PlayerPosY,t2
	
	la t0,NotasLvl			# define o endereco inicial das notas
	sw t0,MusicStartAdd,t1
	sw t0,MusicAtual,t1
	sw zero,NoteCounter,t1	# zera o NoteCounter
	
	lw t0,DuracaoLvl
	sw t0,LenMusAtual,t1
	
	la t0,stage1 		# endereco do grid de tiles atual
	sw t0,MapGridAtual,t1
	
	la t0,stageTiles 	# endereco inicial dos sprites de tile
	sw t0,TileSprtStartAdd,t1
	
	la t0,stage1C 		# endereco do grid de colisao atual
	sw t0,ColGridAtual,t1
	
	la t0,Col0 		# endereco inicial dos sprites de tile de colisao
	sw t0,ColSprtStartAdd,t1
	
	sw zero,PlayerSpeedX,t0
	sh zero,PlayerAnimState,t0
	sw zero,PlayerIFrames,t0 
	sw zero,PlayerLock,t0
	
	jal ClearObjects
	
	#jal StartEnemiesTest
	
	li t0,32
	sh t0,FadeTimer,t1
	sw zero,FadeColor,t1
	
	j Main
	
# # # # #
LoadLevel2:
	li t0,3
	sh t0,StageID,t1
	
	# Definicao do mapa
	li t0,1024 # 64 
	li t1,240 # 15
	sh t0,GridSizeX,t2
	sh t1,GridSizeY,t2
	
	# Posicao inicial do jogador
	li t0,4
	li t1,7
	slli t0,t0,4
	slli t1,t1,4
	sh t0,PlayerPosX,t2
	sh t1,PlayerPosY,t2
	
	# Nao atualiza a musica
	
	la t0,stage2 		# endereco do grid de tiles atual
	sw t0,MapGridAtual,t1
	
	la t0,stageTiles	# endereco inicial dos sprites de tile
	sw t0,TileSprtStartAdd,t1
	
	la t0,stage2C 		# endereco do grid de colisao atual
	sw t0,ColGridAtual,t1
	
	la t0,Col0 		# endereco inicial dos sprites de tile de colisao
	sw t0,ColSprtStartAdd,t1
	
	sw zero,PlayerSpeedX,t0
	sh zero,PlayerAnimState,t0
	sw zero,PlayerIFrames,t0 
	sw zero,PlayerLock,t0
	
	jal ClearObjects
	
	#jal StartEnemiesTest
	
	li t0,32
	sh t0,FadeTimer,t1
	sw zero,FadeColor,t1
	
	j Main
	
# # # # #
LoadLevel3:
	li t0,4
	sh t0,StageID,t1
	
	# Definicao do mapa
	li t0,272 # 17 
	li t1,560 # 35
	sh t0,GridSizeX,t2
	sh t1,GridSizeY,t2
	
	# Posicao inicial do jogador
	li t0,7
	li t1,31
	slli t0,t0,4
	slli t1,t1,4
	sh t0,PlayerPosX,t2
	sh t1,PlayerPosY,t2
	
	# Nao atualiza a musica
	
	la t0,stage3 		# endereco do grid de tiles atual
	sw t0,MapGridAtual,t1
	
	la t0,stageTiles	# endereco inicial dos sprites de tile
	sw t0,TileSprtStartAdd,t1
	
	la t0,stage3C 		# endereco do grid de colisao atual
	sw t0,ColGridAtual,t1
	
	la t0,Col0 		# endereco inicial dos sprites de tile de colisao
	sw t0,ColSprtStartAdd,t1
	
	jal ClearObjects
	
	sw zero,PlayerSpeedX,t0
	sh zero,PlayerAnimState,t0
	sw zero,PlayerIFrames,t0 
	sw zero,PlayerLock,t0
	
	#jal StartEnemiesTest
	
	li t0,32
	sh t0,FadeTimer,t1
	sw zero,FadeColor,t1
	
	j Main
	
# # # # #
LoadLevel4:
	li t0,5
	sh t0,StageID,t1
	
	# Definicao do mapa
	li t0,1280 # 80
	li t1,240 # 15
	sh t0,GridSizeX,t2
	sh t1,GridSizeY,t2
	
	# Posicao inicial do jogador
	li t0,3
	li t1,8
	slli t0,t0,4
	slli t1,t1,4
	sh t0,PlayerPosX,t2
	sh t1,PlayerPosY,t2
	
	# Nao atualiza a musica
	
	la t0,stage4 		# endereco do grid de tiles atual
	sw t0,MapGridAtual,t1
	
	la t0,stageTiles	# endereco inicial dos sprites de tile
	sw t0,TileSprtStartAdd,t1
	
	la t0,stage4C 		# endereco do grid de colisao atual
	sw t0,ColGridAtual,t1
	
	la t0,Col0 		# endereco inicial dos sprites de tile de colisao
	sw t0,ColSprtStartAdd,t1
	
	sw zero,PlayerSpeedX,t0
	sh zero,PlayerAnimState,t0
	sw zero,PlayerIFrames,t0 
	sw zero,PlayerLock,t0
	
	jal ClearObjects
	
	#jal StartEnemiesTest
	
	li t0,32
	sh t0,FadeTimer,t1
	sw zero,FadeColor,t1
	
	j Main
	
# # # # #
LoadBoss:
	li t0,6
	sh t0,StageID,t1
	
	# Definicao do mapa
	li t0,272 # 17 
	li t1,384 # 24
	sh t0,GridSizeX,t2
	sh t1,GridSizeY,t2
	
	# Posicao inicial do jogador
	li t0,2
	li t1,18 #3
	slli t0,t0,4
	slli t1,t1,4
	sh t0,PlayerPosX,t2
	sh t1,PlayerPosY,t2
	
	la t0,NotasBoss			# define o endereco inicial das notas
	sw t0,MusicStartAdd,t1
	sw t0,MusicAtual,t1
	
	lw t0,DuracaoBoss
	sw t0,LenMusAtual,t1
	
	la t0,stageWhispy 		# endereco do grid de tiles atual
	sw t0,MapGridAtual,t1
	
	la t0,stageTiles	# endereco inicial dos sprites de tile
	sw t0,TileSprtStartAdd,t1
	
	la t0,whispyStageCol 		# endereco do grid de colisao atual
	sw t0,ColGridAtual,t1
	
	la t0,Col0 		# endereco inicial dos sprites de tile de colisao
	sw t0,ColSprtStartAdd,t1
	
	sw zero,PlayerSpeedX,t0
	sh zero,PlayerAnimState,t0
	sw zero,PlayerIFrames,t0 
	sw zero,PlayerLock,t0
	
	jal ClearObjects
	
	li t0,28
	sw t0,BossHP,t1
	sw zero,BossTimer,t1
	sw zero,BossAnimState,t1
	sw zero,BossAnimCount,t1
	sw zero,BossIFrames,t1
	
	li t0,32
	sh t0,FadeTimer,t1
	sw zero,FadeColor,t1
	
	j Main
	
# # # # #
LoadEnd:
	li t0,7
	sh t0,StageID,t1
	
	j Main

# # # # #
LoadTest:
	li t0,8
	sh t0,StageID,t1	

	# Definicao do mapa
	li t0,640 
	li t1,480
	sh t0,GridSizeX,t2
	sh t1,GridSizeY,t2
	
	# Posicao inicial do jogador
	li t0,2
	li t1,4
	slli t0,t0,4
	slli t1,t1,4
	sh t0,PlayerPosX,t2
	sh t1,PlayerPosY,t2
	
	la t0,NotasHub			# define o endereco inicial das notas
	sw t0,MusicStartAdd,t1
	sw t0,MusicAtual,t1
	
	lw t0,DuracaoHub
	sw t0,LenMusAtual,t1
	
	la t0,mapa40x30 		# endereco do grid de tiles atual
	sw t0,MapGridAtual,t1
	
	la t0,vazioTeste			# endereco inicial dos sprites de tile
	sw t0,TileSprtStartAdd,t1
	
	la t0,mapa40x30col 		# endereco do grid de colisao atual
	sw t0,ColGridAtual,t1
	
	la t0,blocoExempCol 		# endereco inicial dos sprites de tile de colisao
	sw t0,ColSprtStartAdd,t1
	
	jal StartEnemiesTest
	
	li t0,32
	sh t0,FadeTimer,t1
	li t0,255
	sw t0,FadeColor,t1
	
	j Main	

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Main:
	jal FadeScreen

	jal Clock # MusicLoop acontece aqui
	
	jal ChangeFrame # mostra o BitmapFrame atual e o atualiza, para o proximo ser desenhado
	
	li t0,16
	lhu t1,FadeTimer
	bgt t1,t0,Main # enquanto a primeira parte da transicao acontece mantem a tela do estagio passado
	
	jal KeyPress		# confere teclas apertadas, atualizando posicao do jogador e offset
	
	jal PlayerControls	# com base na ultima tecla apertada, salva em s10 pelo KeyPress, realiza as acoes de movimento do jogador
	
	jal PlayerAnimation
	
# toda funcao que muda posicao de personagens/objetos deve ser chamada antes de imprimi-los

	jal PrintMapa		# imprime o mapa usando o offset

	jal DrawPlayer
	
	lh t0,StageID
	li t1,6
	bne t0,t1,NotBoss
	jal CheckBoss
NotBoss:
	
	jal DrawObjects
	
	jal DrawMenu
	
	jal ShowCollision

	j Main

#======================================================
TitleMain:
	jal FadeScreen
	
	jal Clock
	
	jal ChangeFrame # mostra o BitmapFrame atual e o atualiza, para o proximo frame ser desenhado
		
	li t0,16
	lhu t1,FadeTimer
	bgt t1,t0,TitleMain # enquanto a primeira parte da transicao acontece mantem a tela do estagio passado

	jal TitleKeyPress
	
	jal DrawTitle
	
	
	lw t0,TitleControls
	li t1,40
	mul t0,t0,t1
	
	li t1,132
	li t2,180
	add t1,t1,t0
	
	slli a1,t2,16
	add a1,a1,t1
	
	la a0,star0
	jal SimplePrint
	
	
	j TitleMain

#########################################################################################################################################
FadeScreen:

	addi sp,sp,-4
	sw ra,0(sp)

	lhu s0,FadeTimer
	beqz s0,FimFadeScreen
	
	li t0,32
	bne t0,s0,DontStartFade
	li s1,256
	sh s1,FadeLines,t0
DontStartFade:
	lh s1,FadeLines
	
	andi t0,s0,1
	bne t0,zero,DoneGetLines
	
	li t0,16
	bgt s0,t0,DivLines # caso especifico para comecar a trocar a transicao
	
	li t0,14
	ble s0,t0,MultLines
	
	j DoneGetLines
	
DivLines:
	srli s1,s1,1 # divide as linhas por 2
	j DoneGetLines
MultLines:
	slli s1,s1,1
	
DoneGetLines:

	mv s2,zero # contador
	li s3,320 # Y maximo das linhas (nao incluso)
	lw s4,FadeColor
	
LoopFillLines:
	mv a0,s4 # cor
	li a1,0	# PosX
	mv a2,s2 # PosY
	li a3,320 # tamanho X
	li a4,1 # tamanho Y
	li a5,1 # quick print ativado
	jal FillPrint
	
	add s2,s2,s1 # adiciona certa altura para a Y
	bge s2,s3,FimLoopFillLines
	
	j LoopFillLines
	
FimLoopFillLines:
	
	addi s0,s0,-1
	sh s0,FadeTimer,t0
	sh s1,FadeLines,t0
	
FimFadeScreen:
	lw ra,0(sp)
	addi sp,sp,4
	
	ret

#----------
DrawPlayer:
	addi sp,sp,-4
	sw ra,0(sp)
	
	lw a0,PlayerSprite
	lw a1,PlayerPosX
	lw a3,PlayerLastDir
	lw a4,PlayerPowState
	
	lw t0,PlayerIFrames	# frames especiais (invencibilidade, ganhar poder(?))
	beq t0,zero,NoIFrames
	li t1,100
	bge t0,t1,NoIFrames
	sw zero,PlayerLock,t2
	andi t0,t0,15
	li t1,8
	bge t0,t1,NoIFrames
	li a4,-1
NoIFrames:
	jal Print		# imprime o jogador em sua nova posicao
	
	lw ra,0(sp)
	addi sp,sp,4
	
	ret
	
#----------
ShowCollision:
	addi sp,sp,-4
	sw ra,0(sp)

	la a0,PlayerHP
	jal UpdateCollision

	la a0,collisionRender
	mv a1,zero
	jal SimplePrint # ShowCollisionMap
	
	lw ra,0(sp)
	addi sp,sp,4

	ret

#----------
Clock: 
	addi sp,sp,-20
	sw ra,0(sp)
	sw s0,4(sp)
	sw s1,8(sp)
	sw s2,12(sp)
	sw s3,16(sp)

ClockLoop:
	#li a7,30
	#ecall			# salva o novo valor do tempo global
	csrr a0,3073
	mv s0,a0
	
	lw s1,LastGlblTime
	sub s2,s0,s1		# subtrai o novo tempo global pelo ultimo valor salvo, para definir quantos milissegundos passaram desde o ultimo frame
	
	mv a0,s2
	li a7,1
	#ecall
	
	la a0,endl
	li a7,4
	#ecall			# imprime a diferenca de milissegundos (apenas por debug)
	
	li t0,16
	lhu t1,FadeTimer
	bgt t1,t0,SkipMusic
	
	mv a0,s0 # novo valor de tempo global e enviado para a funcao de musica
	jal MusicLoop
SkipMusic:

	#lw t0,SoundDuration 
	#beqz t0,SkipSubSoundDur
	#addi t0,t0,-1
	#sw t0,SoundDuration,t1
#SkipSubSoundDur:

	lw a0,SoundEffectAtual
	beqz a0,SkipSound
	
	lw a1,SoundDuration
	beqz a1,SkipSound

	lw a2,SoundInstrument
	
	jal PlaySoundEffect
SkipSound:
	
	li t0,frameMS		# a cada 20 ms o frame avanca em 1, o que equivale a 50 fps
	blt s2,t0,ClockLoop	# enquanto nao avancar o frame o codigo fica nesse loop
	sw s0,LastGlblTime,t0	# atualiza o novo valor de tempo global
	
	lw s3,FrameCount
	addi s3,s3,1
	sw s3,FrameCount,t0 	# avanca o contador de frames
		
FimClock:

	# debugs

	lhu a0,BossAnimDuration
	li a7,1
	#ecall
	
	la a0,endl
	li a7,4
	#ecall	

	lhu a0,BossTimer
	li a7,1
	#ecall
	
	la a0,endl
	li a7,4
	#ecall		

	lhu a0,BossAnimState
	li a7,1
	#ecall
	
	la a0,endl
	li a7,4
	#ecall			
	
	lhu a0,BossSprite
	li a7,1
	#ecall
	
	la a0,endl
	li a7,4
	#ecall		

	lhu a0,BossOldAnim
	li a7,1
	#ecall
	
	la a0,endl
	li a7,4
	#ecall	

	lhu a0,BossAnimCount
	li a7,1
	#ecall
	
	la a0,endl
	li a7,4
	#ecall
	
	lhu a0,BossMaxFrame
	li a7,1
	#ecall
	
	la a0,endl
	li a7,4
	#ecall
	
	la a0,endl
	li a7,4
	#ecall		
	
	lw ra,0(sp)
	lw s0,4(sp)
	lw s1,8(sp)
	lw s2,12(sp)
	lw s3,16(sp)
	addi sp,sp,20	

	ret			# depois de avancar o frame segue para o resto do codigo da main, basicamente definindo o framerae do jogo como 50 fps

#----------
StartEnemiesTest: 
	addi sp,sp,-4
	sw ra,0(sp)

	li a2,1 # PosY
	slli a2,a2,16
	addi a2,a2,2 # PosX
	slli a2,a2,4
	li a0,waddleID # waddle dee
	li a1,1
	li a2,0x00100020
	mv a3,zero
	mv a4,zero
	jal BuildObject # a0 = id do objeto, a1 = quantidade de objetos a adicionar, a2 = posicao de referencia (0xYYYYXXXX), a3 = direcao do objeto (0 = esq, 1 = dir), a4 = valor de apoio
	
	li a2,7 # PosY
	slli a2,a2,16
	addi a2,a2,8 # PosX
	slli a2,a2,4
	li a0,hotHeadID # hot head
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject
	
	li a2,10 # PosY
	slli a2,a2,16
	addi a2,a2,3 # PosX
	slli a2,a2,4
	li a2,0x00a00030
	li a0,chillyID # chilly
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject
	
	lw ra,0(sp)
	addi sp,sp,4
	
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
PlayerControls:  # s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10
	addi sp,sp,-4
	sw ra,0(sp)			# pilha armazena apenas valor de retorno
			
	lw s0,LastKey			# s0, valor da ultima tecla apertada
	lhu s1,PlayerPosX		# s1, posicao X do jogador no mapa
	lhu s2,PlayerPosY		# s2, posicao Y do jogador no mapa
	lhu s6,PlayerAnimState		# s6, valor de estado do jogador
	mv s7,s6			# s7, novo valor de estado do jogador
	lhu s8,PlayerAnimTransit
	lw s9,PlayerLock
	lw s10,PlayerPowState
	
	mv t0,s2
	slli t0,t0,16
	add t0,t0,s1
	sw t0,OldPlayerPos,t1		# atualiza OldPlayerPos
	
	li t0,'r'
	beq s0,t0,CheckDropPower
	
	li t0,6
	beq s6,t0,ContinueStartAttEat
	
	li t0,7
	beq s6,t0,EndAttackEat
	
	li t0,8
	beq s6,t0,DoneAttack # se estiver para baixo ou engolindo um inimigo skipa para as verificacoes de movimentacao, verificado novamente antes de apertar 's'
	
	li t0,10
	beq s6,t0,EndAttackAir
	
	li t0,11
	beq s6,t0,EndAttackStar
	
	DE1(t0,DE1CheckAtt)	

	li t0,'e'
	beq s0,t0,AttackCheck		# se velocidade for positiva e 'd' esta apertado nao ha porque desacelerar
	j EndDE1CheckAtt
	
DE1CheckAtt:
	la t0,OtherKeys
	lbu t1,0(t0)
	bnez t1,AttackCheck
EndDE1CheckAtt:
	
	li t0,1
	beq s6,t0,KeepAttackEat
	
	j HorizontalMove
	
CheckDropPower: ### TODO
	j HorizontalMove
	
AttackCheck:
	bne s9,zero,LockedStar # confere o locked, principalmente para evitar que o jogador solte o item da boca sem querer
	li t0,playerMouthIndex # como o item na boca por si so nao muda o AnimState, comparacao precisa ser feita com o PowState
	bge s10,t0,AttackStar
LockedStar:

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
	sh s8,PlayerAnimTransit,t1 ### caso estranho, acho que nem em todos eles pode mudar o registrador s, mas aqui precisa
	
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

AttackStar:
	li t0,30
	sh t0,PlayerAnimTransit,t1

	li s7,11
	j DoneAttack

EndAttackStar:
	li s7,11
	bgt s8,zero,DoneAttack
	
	li s7,0
	
	li t0,0
	sw zero,PlayerPowState,t1
	j DoneAttack

DoneAttack:


HorizontalMove:
	lh s4,PlayerSpeedX		# s4, velocidade X do jogador em seu valor completo
	
	lhu t0,PlayerGndState
	li t1,playerSlowDeaccX
	beq t0,zero,SetSlowDeaccX
	li t1,playerDeaccX		# t1, velocidade de desaceleracao do jogador no eixo X 
SetSlowDeaccX:
	li t2,playerAccX		# t2, velocidade de aceleracao do jogador no eixo X
	li t3,playerMaxSpX		# t3, velocidade maxima do jogador no eixo X
	
SlowLeftToRight:
	bgt s4,zero,SlowRightToLeft	# se velocidade for positiva ou 0 vai para o proximo slow
	bne s9,zero,LockedL

	DE1(t0,DE1CheckLeft)	

	li t0,'a'
	beq s0,t0,MoveLeft		# se velocidade for negativa e 'a' esta apertado nao ha porque desacelerar
	j EndDE1CheckL
	
DE1CheckLeft:
	la t0,MoveKeys
	lbu t1,1(t0) # a
	bnez t1,MoveLeft
EndDE1CheckL:

	beq s4,zero,SlowRightToLeft	# se velocidade for zero ainda precisa conferir se 'd' esta sendo apertado
LockedL:  # mesmo quando travado precisa desacelerar
	
	add s4,s4,t1
	ble s4,zero,DoneHorizontalMv
	mv s4,zero			# se a velocidade ficou positiva ao desacelerar precisa voltar para zero
	j DoneHorizontalMv
	
SlowRightToLeft:
	bne s9,zero,LockedR
	
	DE1(t0,DE1CheckRight)	

	li t0,'d'
	beq s0,t0,MoveRight		# se velocidade for positiva e 'd' esta apertado nao ha porque desacelerar
	j EndDE1CheckR
	
DE1CheckRight:
	la t0,MoveKeys
	lbu t1,3(t0)
	bnez t1,MoveRight
EndDE1CheckR:
	
	
	beq s4,zero,DoneHorizontalMv	# se a velocidade for zero nesse ponto nao ha porque desacelerar o jogador
LockedR:  # mesmo quando travado precisa desacelerar
	
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
	
	# s7, novo valor de animacao do jogador; s8, PlayerAnimTransit s9, PlayerLock; s10, PlayerPowState # # # # #
	
	li t0,playerFlyIndex
	blt s6,t0,NotFlying
	li t3,playerMaxSlowFallSp
NotFlying:
	
	bne zero,s9,LockedJump 
	
	li t0,9
	beq s6,t0,CheckStartFly
ReturnCheckStFly:
	
	DE1(t0,DE1CheckUp)	

	li t0,'w'
	beq s0,t0,MoveFly
	
	li t0,' '			
	beq s0,t0,MoveJump		# pulo unico
	
	j EndDE1CheckUp
	
DE1CheckUp:
	la t0,MoveKeys
	lbu t1,0(t0) # w
	bnez t1,MoveFly
	
	lbu t1,5(t0) # espaco
	bnez t1,MoveJump
EndDE1CheckUp:
	
	
LockedJump:

	beq t1,zero,MoveFall		# se estado do jogador for 0 ele esta caindo
	
	li t0,8
	beq s6,t0,EndEatingDown
BackEatingDown:

	bne s9,zero,LockedD
	li t0,'s'
	beq s0,t0,MoveDown
LockedD:
	
	blt s5,zero,DoneVerticalMv	# se o jogador estiver indo para cima o chao nao para ele (impede um snap que estava acontecendo)
	mv s5,zero 		 	# se o jogador nao estiver no ar ou tiver pulado, entao esta no chao e sua velocidade Y se torna zero
	j DoneVerticalMv
	
EndEatingDown:
	bgt s8,zero,BackEatingDown
		
	li s7,0 
	
	sw zero,PlayerLock,t0 # destrava o jogador
	
	li t0,3
	blt s10,t0,DoneVerticalMv # se nao tiver com nenhum item na boca nao muda o PowState
	
	addi s10,s10,-3 # basta subtrair 3 do PowState de item na boca para definir o novo PowState 
	sw s10,PlayerPowState,t1
	
	beq s10,zero,DoneVerticalMv 
	
	li s7,1 # para o caso de ganhar o poder de fogo
	li t0,30
	sh t0,PlayerAnimTransit,t1
	li t0,1
	beq s10,t0,DoneVerticalMv # se estiver com a habilidade de fogo nao precisa da animacao de EndAttack
	
	li s7,6 # para o caso de ganhar o poder de gelo
	li t0,10
	sh t0,PlayerAnimTransit,t1
	
	j DoneVerticalMv
	
MoveDown:
	li s7,8 
	
	li t0,1
	sw t0,PlayerLock,t2 # trava a movimentacao do jogador enquanto estiver comendo, liberado ao final da animacao no PlayerAnimation
	
	li t1,28 # tempo para segurar a tecla de abaixar
	li t0,3
	blt s10,t0,CrouchHoldDelay
	li t1,40	# tempo da animacao normal de comer
	bgt s8,zero,DoneVerticalMv # se ja estiver em uma animacao de comer nao atualiza o delay
	
CrouchHoldDelay:	
	sh t1,PlayerAnimTransit,t2
	
	j DoneVerticalMv
	
	
CheckStartFly:
	li s7,playerFlyIndex 
	beq s8,zero,ReturnCheckStFly  # se a animacao inflando ja acabou o sprite deve ser o de voo comum
	
	li s7,9
	j ReturnCheckStFly
	
MoveFly:
	lw t0,PlayerDoor
	beqz t0,DontSetNextLevel
	j SetNextLevel
DontSetNextLevel:

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
	sh s7,PlayerAnimState,t0  	# # # # # # # armazena novo estado de animacao do jogador
	li t0,100
	div t1,s5,t0			# divide a velocidade por 100 para obter o numero de pixels a se mover
	
	li t0,playerMaxJumpSp
	
	bge t1,t0,DontLimitJump		# como o jogador nao pode se mover mais de 4 pixels por frame para as colisoes funcionarem, a vel do pulo fica limitada a -4
	mv t1,t0
DontLimitJump:
	
	add s2,s2,t1			# adiciona a velocidade vertical em pixels para a posicao do jogador

FimMove:

	lh t0,GridSizeX
	addi t0,t0,-16			# t0, tamanho da linha de pixels - 48 - 16 # old: -16
	
	#li t0,304		
	blt s1,zero,FimPlayerControls
	bgt s1,t0,FimPlayerControls		# analisa se passou das bordas dos lados
	
	lh t0,GridSizeY	
	addi t0,t0,-16			# t0, tamanho da coluna de pixels -16
	
	#li t0,224		
	blt s2,zero,FimPlayerControls
	bgt s2,t0,FimPlayerControls		# analisa se passou das bordas de cima e de baixo
	
	slli t0,s2,16
	add t0,t0,s1
	sw t0,TempPlayerPos,t1
	
	j PlayerColCheck
	
PlayerColCheck:

	sh s1,PlayerPosX,t0
	sh s2,PlayerPosY,t0		# armazena temporariamente a nova posicao do jogador, pois o mapa de colisao e feito com base nela, se alguma colisao afeta-la ela sera atualizada ao final

	la a0,PlayerHP # endereco que serve como "ID" do jogador
	jal UpdateCollision

	la s3,collisionRender
	addi s3,s3,spriteHeader
	
	mv t0,s1
	andi t0,t0,0xf
	add s3,s3,t0			# adiciona o resto do offset X por 16
	
	mv t0,s2
	andi t0,t0,0xf
	li t1,32
	mul t0,t0,t1			# adiciona as linhas com base no resto do offset Y por 16
	
	add s3,s3,t0			# s3, inicialmente como o endereco para o primeiro pixel do jogador no mapa de colisoes renderizado
		
	# # # inicio colisoes
	mv t6,zero # contador de objetos que podem atingir o jogador
	
	li t1,5
	bne s6,t1,SetupPlayerEnemies # s6 = PlayerAnimState passado, se estiver em qualquer animacao que nao seja de hit esta ok para verificar a colisao
	
	bgt s8,zero,DonePlayerEnemyColCheck # s8 = PlayerAnimTransit, se estiver com AnimState 5 e Transit > 0 ainda esta na animacao de knockback
	# se tiver acabado a animacao de knockback:
	
	sh zero,PlayerAnimState,t5 
	
	j DonePlayerEnemyColCheck # pode skipar para evitar outros hits, alem de que vai estar invencivel
NextDangerCheck:
	addi t6,t6,1
	li t1,dangerQuant
	beq t1,t6,DonePlayerEnemyColCheck
	
SetupPlayerEnemies:
	lw t1,PlayerIFrames
	bgt t1,zero,DonePlayerEnemyColCheck # se ainda estiver com frames de invencibilidade skipa a colisao com os inimigos

	mv t0,s3
	li t5,66 # pixel 2,2 (iniciando em 0,0)
	
	mv t3,zero
	li t4,4				# contador de pixels a analisar

	li t2,commonEnemyCol
	beq t6,zero,PlayerEnemies
	li t1,1
	li t2,enemyFireCol
	beq t6,t1,PlayerEnemies
	li t1,2
	li t2,enemyIceCol
	beq t6,t1,PlayerEnemies
	li t1,3
	li t2,pitCol
	beq t6,t1,PlayerEnemies

PlayerEnemies:

	add t0,t0,t5
	lbu t1,0(t0)
	#sb zero,0(t0)
	beq t1,t2,PlayerHit
	
	addi t3,t3,1
	beq t3,t4,NextDangerCheck
	
	li t5,11 # pixel 13,2
	li t1,1
	beq t1,t3,PlayerEnemies
	li t5,341 # pixel 2,13
	li t1,2
	beq t1,t3,PlayerEnemies
	li t5,11 # pixel 13,13
	li t1,3
	beq t1,t3,PlayerEnemies
	
PlayerHit:
	andi t1,t3,1 # se o contador de pixels for impar = hit pela direita = jogador vira a direita
	sw t1,PlayerLastDir,t5

	li t1,playerKnockbackX 
	lw t5,PlayerLastDir
	beq t5,zero,GotKnockback
	sub t1,zero,t1
GotKnockback:
	sh t1,PlayerSpeedX,t0 # define manualmente a velocidade do jogador como alem da maxima na direcao oposta que ele esta olhando para efeito de knockback
	
	li t1,playerKnockbackY
	sh t1,PlayerSpeedY,t0

	li t1,25 # tempo da animacao de hit
	sh t1,PlayerAnimTransit,t5
	
	li t1,125 # tempo do jogador invencivel
	sw t1,PlayerIFrames,t5
	
	li t1,1
	sw t1,PlayerLock,t5
	
	li t1,4 # animacao de hit voando
	li t5,playerFlyIndex
	beq s6,t5,DefPlayerFlyHit 
	li t1,5 # animacao de hit comum
DefPlayerFlyHit:
	sh t1,PlayerAnimState,t5 # caso bem especifico em que a animacao do jogador e setada apos as verificacoes de movimento e de ataque
	
	lh t1,PlayerHP
	addi t1,t1,-1
	sh t1,PlayerHP,t0
	
	#beqz t1,PlayerDeath
	
	li t1,1
	#beq s10,t1,DropFire
	li t1,2
	#beq s10,t1,DropIce
	
	j DonePlayerEnemyColCheck
	
PlayerDeath:
	lh t0,PlayerLives
	addi t0,t0,-1
	sh t0,PlayerLives,t1
	
	bnez t0,SimpleDeath
	j LoadTitle
SimpleDeath:
	j LoadHub # ao morrer simplesmente volta para o hub
	
DonePlayerEnemyColCheck:
	
	
SetupPlayerCeiling:
	mv t0,s3
	li t2,7 # vermelho
	mv t3,zero
	li t4,4				# contador de pixels a analisar
PlayerCeiling:
	lbu t1,0(t0)
	bne t1,t2,PlayerDontSnapDown	
	#sh zero,PlayerSpeedY,t1
	jal SnapDown			
	j PlayerCeiling			# repete enquanto colisao acontece
PlayerDontSnapDown:
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
	bne t1,t2,PlayerDontSnapRight	
	jal SnapRight
	j PlayerLeftWall		# repete enquanto colisao acontece
PlayerDontSnapRight:
	addi t0,t0,160			# avanca 5 linhas no mapa de colisao
	addi t3,t3,1
	blt t3,t4,PlayerLeftWall


SetupPlayerRWall:
	mv t0,s3
	li t2,192 # azul
	li t5,88 # whispy
	mv t3,zero
	li t4,4				# contador de pixels a analisar
PlayerRightWall:
	lbu t1,15(t0)
	bne t1,t2,PlayerDontSnapLeft	
	jal SnapLeft
	j PlayerRightWall		# repete enquanto colisao acontece
PlayerDontSnapLeft:
	bne t1,t5,PlayerDontSnapLeft2	
	jal SnapLeft
	j PlayerRightWall		# repete enquanto colisao acontece
PlayerDontSnapLeft2:
	addi t0,t0,160			# avanca 5 linhas no mapa de colisao
	addi t3,t3,1
	blt t3,t4,PlayerRightWall
	
	
SetupPlayerFloor: ### TODO revisar: colisao do player com o chao precisa ser a ultima pois e a unica de mover o jogador de forma que os pixels verificados dele fiquem fora do mapa de colisao
	sh zero,PlayerGndState,t5	# determina que jogador esta no ar
	sw zero,PlayerDoor,t5		# determina que jogador nao esta na porta
	
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
	j DontSetDoorSt
DontSetGroundSt:
	li t6,doorCol
	bne t5,t6,DontSetDoorSt		# analisa pixels 1, 6, 11 e 16 da primeira linha abaixo do jogador
	li t6,1
	sw t6,PlayerDoor,t5
DontSetDoorSt:
	bne t1,t2,PlayerDontSnapUp		# analisa pixels 1, 6, 11 e 16 da ultima linha do jogador
	jal SnapUp
	j PlayerFloor			# repete enquanto colisao acontece
PlayerDontSnapUp:
	addi t0,t0,5			# avanca 5 pixels na linha
	addi t3,t3,1
	blt t3,t4,PlayerFloor
	
SuccessfulMove:
	sh s1,PlayerPosX,t0		# armazena novo X do jogador
	sh s2,PlayerPosY,t0		# armazena novo Y do jogador
	
	##### definicao do offset:

	lw t1,OffsetX	
	sw t1,OldOffset,t0		# atualiza OldOffset
	
	li t0,124 #old: 152		# precisa parar sprite no pixel 128 (contando de 0) [(272/2)-8] # old: 152 do bitmap (contando de 0) [(320/2)-8]
	bge s1,t0,ChangeOffsetX		# se e necessario mover a tela atualiza o offset
	mv t1,zero
	sh t1,OffsetX,t2		# armazena novo offset X
FimChangeOffsetX:

	li t0,112			# precisa parar sprite no pixel 108 do bitmap (contando de 0)
	bge s2,t0,ChangeOffsetY		# se e necessario mover a tela atualiza o offset
	mv t1,zero
	sh t1,OffsetY,t2		# armazena novo offset X
FimChangeOffsetY:
	
FimPlayerControls:
	lw ra,0(sp)
	addi sp,sp,4			# recupera endereco de retorno da pilha

  	ret
  	

ChangeOffsetX:
	lh t0,GridSizeX			# tamanho X do mapa
			
	addi t0,t0,-140 #old: -168	# pixel mais a direita do mapa que muda o offset
	bgt s1,t0,MaxOffsetX		# se o jogador estiver no fim da tela, o offset sempre sera o maior possivel

	li t1,124 #old: 152				
	sub t1,s1,t1			# offsetX = posicao real do jogador - 128 #old: 152

	sh t1,OffsetX,t2		# armazena novo offset X
	
	j FimChangeOffsetX
	
MaxOffsetX:
	li t1,124 #old: 152
	sub t0,t0,t1			# em t0 esta o valor maximo de X que altera o offset, entao e s� subtrair metade da tela e 8 pixels do sprite
	
	sh t0,OffsetX,t2		# armazena novo offset X como o maior valor possivel 
	
	j FimChangeOffsetX

ChangeOffsetY:
	lh t0,GridSizeY			# tamanho Y do mapa
			
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
	# s0, s1, s2, s3, s4, s5, s6, s7, s8, s9 ### TODO s7 foi removido, atualizar registradores
	sw ra,0(sp)			# pilha armazena apenas valor de retorno

	lw s0,PlayerLastDir		# se estiver virado para a esquerda s0 = 0, para a direita s0 = 1

	lhu t3,PlayerAnimTransit
	
	mv t0,t3
	beq t0,zero,SkipSubTransit
	addi t0,t0,-1
	sh t0,PlayerAnimTransit,t1
SkipSubTransit:

	lw t0,PlayerObjDelay 
	beq t0,zero,SkipSubDelay
	addi t0,t0,-1
	sw t0,PlayerObjDelay,t1
SkipSubDelay:

	lw t0,PlayerIFrames 
	beq t0,zero,SkipSubIFrames
	addi t0,t0,-1
	sw t0,PlayerIFrames,t1
SkipSubIFrames:
	
	lhu s8,PlayerAnimState
	lhu s9,PlayerPowState
	
	bgt t3,zero,DefTransition
	
	li t0,4 # se acabar o tempo de transicao (hit voando), volta o jogador ao estado de voando
	bne s8,t0,NotFlyingHitToFly
	li s8,playerFlyIndex
	sh s8,PlayerAnimState,t0
NotFlyingHitToFly:

	li t0,12
	bne s8,t0,DontEndEaten
	sw zero,PlayerLock,t0 # zera o Lock quando termina a animacao
	mv s8,zero
	sh s8,PlayerAnimState,t0  # define animacao como BigIdle, pois como PowState esta maior que 3, o jogador ficara com item na boca
	
	j EndDefFireIce 
DontEndEaten:

	lhu t0,PlayerGndState		# analisa se o jogador esta no chao ou no ar
	beq t0,zero,DefineAnimVert
	li t1,1
	beq t0,t1,DefineAnimHorz
	
DefTransition: # se alguma transicao esta acontecendo

	li t0,12
	li s1,23
	beq s8,t0,DefinedAnim # define animacao de terminar de engolir

	li t0,4
	li s1,22
	beq s8,t0,DefinedAnim # verifica se esta sendo atingido com ar

	li t0,5
	beq s8,t0,DefHitState # verifica se esta sendo atingido vazio

	li t0,8
	beq s8,t0,DefDownAnims # animacoes de agachar
	
	li t0,1
	beq s9,t0,DefFireAnim
	li t0,2
	beq s9,t0,DefIceAnim
	li t0,3
	bge s9,t0,DefStarAnim

	li t0,1
	li s1,11
	beq s8,t0,DefinedAnim

	li t0,6
	li s1,10
	beq s8,t0,DefinedAnim
	
	li t0,7
	li s1,12
	beq s8,t0,DefinedAnim
	
	j EndDefFireIce
	
DefHitState:
	
	li s1,22
	li t0,playerMouthIndex
	bge s9,t0,DefinedAnim
	
	li s1,21
	j DefinedAnim
	
DefDownAnims:
	li t0,3
	li s1,19
	blt s9,t0,DefinedAnim
	
	li s1,20
	j DefinedAnim
	
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
	
DefStarAnim:
	li t0,11
	li s1,18 ### TODO
	j DefinedAnim
	#beq s8,t0,DefinedAnim
	
EndDefFireIce:
	li t0,9
	li s1,9 # DefStartFly
	beq s8,t0,DefinedAnim
	
	li t0,10
	li s1,13 # DefAttackAir
	beq s8,t0,DefinedAnim
	
	#lh t0,FadeTimer # unused, fade e muito especifico para isso funcionar
	#li t1,16
	#li s1,24 # DefAnimEnter # tecnicamente so acontece enquanto o o fade esta iniciando
	#bgt t0,t1,DefinedAnim

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

	lhu s3,PlayerAnim # # # # atualiza s3 com o valor anterior de s1
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
	
	mv a0,s3
	li a7,1
	#ecall
	
	la a0,endl
	li a7,4
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
	li t0,18
	beq s3,t0,PlayerStarAttack
	li t0,19
	la s4,kirbyDown
	beq s3,t0,GotPlayerSprite
	li t0,20
	beq s3,t0,PlayerDownEating
	li t0,21
	beq s3,t0,PlayerHitAnim
	li t0,22
	la s4,kirbyBigHit
	beq s3,t0,GotPlayerSprite
	li t0,23
	beq s3,t0,PlayerEaten
	li t0,24 # Unused
	beq s3,t0,PlayerEnter
	
PlayerEnter: # Unused
	jal CheckNextSprAnim
	andi s1,s1,1
	
	la s4,kirbyEnter0
	li s6,4
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyEnter1
	li s6,12
	beq s1,t0,GotPlayerSprite
		
PlayerEaten:
	jal CheckNextSprAnim
	andi s1,s1,1
	
	la s4,kirbyBigDiag
	li s6,12
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyBigEaten
	li s6,14
	beq s1,t0,GotPlayerSprite
	
PlayerHitAnim:
	jal CheckNextSprAnim
	li t0,6
	slt t1,s1,t0
	mul s1,s1,t1		# um mod 5 manual

	la s4,kirbyHit ### TODO terminar animacao de tomar dano
	li s6,9
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyFall1
	li s6,3
	beq s1,t0,GotPlayerSprite
	li t0,2
	la s4,kirbyFall0
	li s6,3
	beq s1,t0,GotPlayerSprite
	li t0,3
	la s4,kirbyFall2
	li s6,3
	beq s1,t0,GotPlayerSprite
	li t0,4
	la s4,kirbyFall1
	li s6,3
	beq s1,t0,GotPlayerSprite
	li t0,5
	la s4,kirbyFall0
	li s6,3
	beq s1,t0,GotPlayerSprite
		
PlayerDownEating:
	jal CheckNextSprAnim
	andi s1,s1,7

	la s4,kirbyBigDiag # tempo de comer normal = 40
	li s6,12
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyMunch
	li s6,14
	beq s1,t0,GotPlayerSprite
	li t0,2
	la s4,kirbyDown
	li s6,10
	beq s1,t0,GotPlayerSprite
	li t0,3
	la s4,kirbyIdle0
	li s6,4
	beq s1,t0,GotPlayerSprite
	
	# para os casos de ganhar os poderes de fogo ou gelo, o s1 pode chegar a 7 e terao uma animacao extra
	
		
PlayerStarAttack:
	lw t0,PlayerObjDelay
	bgt t0,zero,DoneStarObj
	
	li t0,30
	sw t0,PlayerObjDelay,t1

	li a0,7 # id do objeto (estrela) ###
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	mv a4,zero
	jal BuildObject
DoneStarObj:

	jal CheckNextSprAnim
	andi s1,s1,3
	
	la s4,kirbyEat3Gnd
	li s6,15
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyEat2
	li s6,5
	beq s1,t0,GotPlayerSprite
	li t0,2
	la s4,kirbyEat1
	li s6,5
	beq s1,t0,GotPlayerSprite
	li t0,3
	la s4,kirbyEat0
	li s6,5
	beq s1,t0,GotPlayerSprite
		
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
	beq s1,t0,GotPlayerSprite
	li t0,3
	la s4,kirbyEat3
	li s6,5
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
	beq s1,zero,GotPlayerSprite
	li t0,1
	la s4,kirbyEat2
	li s6,5
	beq s1,t0,GotPlayerSprite
	li t0,2
	la s4,kirbyEat1
	li s6,5
	beq s1,t0,GotPlayerSprite
	li t0,3
	la s4,kirbyEat0
	li s6,5
	beq s1,t0,GotPlayerSprite

PlayerIceAttack:
	lw t0,PlayerObjDelay
	li t1,10
	beq t0,t1,IceObjects2
	bgt t0,zero,DoneIceObjs
	
	li t0,20
	sw t0,PlayerObjDelay,t1

	li a0,4 # id do objeto (gelo)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	li a4,0
	jal BuildObject
	
	li a0,4 # id do objeto (gelo)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir	
	li a4,2
	jal BuildObject
	
	li a0,4 # id do objeto (gelo)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	li a4,4
	jal BuildObject
	
	j DoneIceObjs
	
IceObjects2:
	
	li a0,4 # id do objeto (gelo)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	li a4,1
	jal BuildObject
	
	li a0,4 # id do objeto (gelo)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	li a4,3
	jal BuildObject
	
	li a0,4 # id do objeto (gelo)
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	lw a3,PlayerLastDir
	li a4,5
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

GotPlayerSprite:
	sh s1,PlayerAnimCount,t0
	sw s4,PlayerSprite,t0	# armazena o endereco do novo sprite no PlayerSprite
	sh s6,PlayerMaxFrame,t0  # armazena a duracao da animacao atual

FimPlayerAnimation:
	lw ra,0(sp)
	addi sp,sp,4			# recupera endereco de retorno da pilha

	ret
	
CheckNextSprAnim:
	
	# s5, frameCount
	# s2, frames de duracao do sprite
	lw t1,PlayerLastFrame
	
	sub t2,s5,t1	
	blt t2,s2,KeepSprAnim
	beq s2,zero,KeepSprAnim		# se estiver chegando de um sprite fixo
	
	sw s5,PlayerLastFrame,t0
	addi s1,s1,1 		# avanca o contador de sprites da animacao se a duracao do sprite passou
KeepSprAnim:

	ret
	
#----------
Print: 		# a0 = sprite que vai ser impresso; a1 = posicao do sprite 0xYYYYXXXX;
		# ### TODO a2 nao e mais utilizado, atualizar registradores; a3 = 0 para esquerda ou 1 para direita; a4 = 0, 1 ou 2 para o caso especifico do jogador estar com poderes
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
	
	la t0,tempPos
	sw a1,0(t0)
	lh s0,0(t0)
	lh s1,2(t0)			# salva posicao inicial do sprite
	
	lh s2,8(a0)			# salva a distancia X para iniciar a desenhar o sprite
	lh s3,10(a0)			# salva a distancia Y para iniciar a desenhar o sprite
	
	lhu t0,OffsetX
	sub t3,s0,t0			# subtrai o X do sprite pelo offset X
	sub t3,t3,s2			# subtrai a distancia X para iniciar o sprite
	lhu t0,OffsetY			
	sub t4,s1,t0			# subtrai o Y do sprite pelo offset Y
	sub t4,t4,s3			# subtrai a distancia Y para iniciar o sprite
		
	li t1,320
	li t2,240
	#rem t3,t3,t1			# corrige a posicao no bitmap quando ela passa do 320x240 inicial
	#rem t4,t4,t2			# tecnicamente desnecessario por causa do offset, mas mantido por garantia e para testes que mudam a posicao manualmente
	
	lw a3,BitmapFrame
	
	mul t1,t1,t4
	add s7,a3,t1 			# adiciona y ao endereco do bitmap e armazena esse valor em s7 para evitar o underflow de sprites no bitmap
	addi s8,s7,260 # old: 316	# s8, valor maximo da linha, para evitar o overflow de sprites
	
	add t0,s7,t3 			# adiciona x ao endereco do bitmap
	
	addi t1,a0,spriteHeader		# endereco do sprite mais spriteHeader
	
	mv t2,zero
	mv t3,zero
	
	lw t4,0(a0) 			# guarda a largura do sprite
	lw t5,4(a0) 			# guarda a altura do sprite
	
	beq s4,zero,PreLinhaRev

Linha: 		# t0 = endereco do bitmap display; t1 = endereco do sprite, a3 = endereco inicial do bitmap (0xffX00000), 
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
	li s6,-1
	beq a4,s6,SpecialColors
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

SpecialColors: # 0 -> 20; 159 -> 183; 239 -> 255
	beq t6,zero,BorderSp
	li s6,159
	beq t6,s6,DarkSp
	li s6,239
	beq t6,s6,LightSp
	j EndCheckColors
BorderSp: li t6,20
	j EndCheckColors
DarkSp: li t6,183
	j EndCheckColors
LightSp: li t6,255
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
UpdateCollision: # a0 = endereco com o ID do jogador, objeto ou inimigo
	
	addi sp,sp,-36
	sw ra,0(sp)
	sw s0,4(sp)
	sw s1,8(sp)
	sw s2,12(sp)
	sw s3,16(sp)
	sw s4,20(sp)
	sw s5,24(sp)
	sw s6,28(sp)
	sw s7,32(sp)
	
	lhu a1,4(a0)			# a1, posicao X original do sprite
	lhu a2,6(a0)			# a2, posicao Y original do sprite
	
	srli s0,a1,4			# s0, divisao da posicao X por 16
	
	srli s1,a2,4			# s1, divisao da posicao Y por 16
	
	lw t0,ColGridAtual	
	lw t1,0(t0)			# t1, tamanho do mapa de tiles
	mul t2,s1,t1			
	
	addi t0,t0,spriteHeader
	add t0,t0,s0			# adiciona o numero de colunas de tiles
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
	
	la s2,BGTileCodes		# s2, endereco com todos os codigos de tile
	sw t4,0(s2)			
	mv s3,zero			# s3, contador de tiles
LoopTileRenderCol:

	lbu s4,0(s2) 			# s4, codigo do tile atual
	lw a5,ColSprtStartAdd 		# a5, endereco inicial dos sprites de colisao
	
	li t0,tileFullSize
	mul t1,s4,t0
	add a5,a5,t1			# tamanho total dos tiles (268) e multiplicado pelo ID e somado ao endereco inicial dos tiles de colisao para encontrar o tile atual
	
	la t0,collisionRender
	addi t0,t0,spriteHeader
	li t1,2
	
	beq s3,zero,LeftColTile
	beq s3,t1,LeftColTile
	# se for um dos tiles da coluna direita:
	addi t0,t0,16
LeftColTile:
	blt s3,t1,UpperColTile
	# se for um dos tiles da linha de baixo
	addi t0,t0,512
UpperColTile:		
	
	mv t2,zero			# t2, contador de colunas
	mv t3,zero			# t3, contador de linhas
	li t4,16
	li t5,16
	
	mv t1,a5			# se a5 for um sprite de colisao ele e salvo normalmente
	addi t1,t1,spriteHeader 
	j SaveTileRenderCol

SaveTileRenderCol:

	lw t6,0(t1) 			# guarda uma word do tile
	sw t6,0(t0) 			# salva no mapa de colisao

	addi t0,t0,4			# avanca o endereco do bitmap em 4
	addi t1,t1,4 			# avanca o endereco da imagem em 4		
	
	addi t2,t2,4 			# avanca o contador de colunas em 4
	blt t2,t4,SaveTileRenderCol 	# enquanto a linha nao estiver completa, continua desenhando ela
	
	addi t0,t0,16 			# avanca para a proxima linha do mapa de colisao

	mv t2,zero 			# reseta o contador de colunas
	addi t3,t3,1 			# avanca o contador de linhas em 1
	blt t3,t5,SaveTileRenderCol 	# enquanto o contador de linhas for menor que a altura repete a funcao

NextTileRenderCol:
	addi s2,s2,1			# avanca para o proximo codigo de tile
	addi s3,s3,1			# avanca o contador de tiles
	
	li t2,4
	beq s3,t2,FimTileRenderCol	# se ja foram todos os 4 tiles segue com o UpdateCollision
	j LoopTileRenderCol
	
FimTileRenderCol:
	# inicio da renderizacao do jogador, objetos e inimigos no mapa de colisao

	la s5,Obj0ID
	li t0,objSize
	sub s5,s5,t0
	li s6,-1 			# s6, contador de objetos a desenhar, inicia em -1 para analisar o jogador

	li s7,-1			# ID do jogador tratado como -1
	la t0,PlayerHP
	beq a0,t0,RenderNextObj 	# skipa o jogador se estiver atualizando a colisao para ele
	j RenderObjAtual
	
IterateRenderObjCols:
	beq a0,s5,RenderNextObj

	lw s7,0(s5) # ID
	
	bne s7,zero,RenderObjAtual

RenderNextObj:
	addi s6,s6,1
	li t0,objQuant
	beq s6,t0,FimUpdateCollision
	
	addi s5,s5,objSize
	j IterateRenderObjCols

RenderObjAtual:	
	li t0,enemyStartIndex
	blt s7,t0,RenderNotEnemy
	lh t0,10(s5) # Status, se for um inimigo e o status dele for 0 significa que esta inativo
	ble t0,zero,RenderNextObj
	
	li t1,3
	beq t0,t1,RenderNextObj # se objeto estiver sendo puxado ele nao precisa aparecer no mapa de colisao, pois na vez dele que e verificado se ele atingiu o jogador 
	
RenderNotEnemy:
	# s5 = endereco inicial do objeto, s7 = ID

	li t0,-1
	li a5,playerCol
	beq s7,t0,GotCollision

	li t0,tinyDustID
	li a5,playerPullAreaCol
	beq s7,t0,GotCollision
	
	li t0,fireID
	li a5,playerFireCol
	beq s7,t0,GotCollision
	
	li t0,iceID
	li a5,playerIceCol
	beq s7,t0,GotCollision
	
	li t0,airID
	li a5,playerStarCol
	beq s7,t0,GotCollision
	
	li t0,starID
	li a5,playerStarCol
	beq s7,t0,GotCollision
	
	li t0,waddleID
	li a5,commonEnemyCol
	beq s7,t0,GotCollision
	
	li t0,hotHeadID
	li a5,commonEnemyCol
	beq s7,t0,GotCollision
	
	li t0,chillyID
	li a5,commonEnemyCol
	beq s7,t0,GotCollision
	
	li t0,enemyFireID
	li a5,enemyFireCol
	beq s7,t0,GotCollision
	
	li t0,enemyIceID
	li a5,enemyIceCol
	beq s7,t0,GotCollision
	
	li t0,enemyAirID
	li a5,commonEnemyCol
	beq s7,t0,GotCollision
	
	li t0,enemyAppleID
	li a5,commonEnemyCol
	beq s7,t0,GotCollision
	
	li t0,hitID
	li a5,playerStarCol # por precaucao, para evitar que inimigos nao sejam atingidos quando deveriam
	beq s7,t0,GotCollision


	j RenderNextObj

GotCollision:
	
	# s5 = endereco inicial do objeto, s7 = ID, s0 e s1 = posicoes iniciais do mapa de colisao divididas por 16, a5 = cor da colisao
	
	blt s7,zero,GetPlayerPosColUpdate
	lh a1,4(s5) # PosX
	lh a2,6(s5) # PosY
	j NotPlayerCol
GetPlayerPosColUpdate:
	la t0,PlayerHP
	lh a1,4(t0)
	lh a2,6(t0)
NotPlayerCol:
	
	slli a3,s0,4
	slli a4,s1,4		# posicoes do mapa de colisao sao multiplicadas por 16 para encontrar a posicao dele nas coordenadas base
	
	# objeto esta dentro da area de colisao se:
	# (objLeftX <= colRightX) e (objRightX >= colLeftX) e (objTopY <= colBottomY) e (objBottomY >= colTopY)
	# equivalente a:
	# (colRightX - objLeftX >= 0) e (objRightX - colLeftX >= 0) e (colBottomY - objTopY >= 0) e (objBottomY - colTopY >= 0)
	# a1 = objLeftX
	# a1+15 = objRightX
	# a2 = objTopY
	# a2+15 = objBottomY
	# a3 = colLeftX
	# a3+31 = colRightX
	# a4 = colTopY
	# a4+31 = colBottomY
	
	# tamanho X do sprite a renderizar = min(16, min((colRightX - objLeftX), (objRightX - colLeftX)))
	# tamanho Y do sprite a renderizar = min(16, min((colBottomY - objTopY), (objBottomY - colTopY)))
	
	# posicao X do sprite = max(0, objLeftX - colLeftX)
	# posicao Y do sprite = max(0, objUpperY - colUpperY)
	
	li t6,16
	
	addi t0,a3,31
	sub t1,t0,a1
	
	addi t0,a1,15
	sub t2,t0,a3
	
	mv t4,t1
	blt t4,t6,GotSizeXObjRender
	mv t4,t2
	blt t4,t6,GotSizeXObjRender # impossivel de mais de um dos valores ser menor que 16
	mv t4,t6
	addi t4,t4,-1
GotSizeXObjRender:

	addi t0,a4,31
	sub t1,t0,a2
	
	addi t0,a2,15
	sub t2,t0,a4
	
	mv t5,t1
	blt t5,t6,GotSizeYObjRender
	mv t5,t2
	blt t5,t6,GotSizeYObjRender # impossivel de mais de um dos valores ser menor que 16
	mv t5,t6
	addi t5,t5,-1
GotSizeYObjRender:

	addi t4,t4,1
	addi t5,t5,1 # para serem tratados como valores de tamanho e necessario adicionar 1 para cada um deles

	ble t4,zero,RenderNextObj # # # # # # #
	ble t5,zero,RenderNextObj # se qualquer um dos tamanhos for negativo ou 0 quer dizer que o sprite esta fora do mapa de colisao
	
	sub t2,a1,a3
	bgt t2,zero,GotPosXObjRender
	mv t2,zero
GotPosXObjRender:
	
	sub t3,a2,a4
	bgt t3,zero,GotPosYObjRender
	mv t3,zero
GotPosYObjRender:

	slli t3,t3,5 # multiplica a posicao Y por 32, ja que e a largura do mapa de colisao
	
	la t0,collisionRender
	addi t0,t0,spriteHeader
	add t0,t0,t2
	add t0,t0,t3 # adiciona posicao do sprite ao endereco do mapa de colisao
	
	mv t2,zero # contador de colunas
	mv t3,zero # contador de linhas
	
SaveObjRenderCol:

	sb a5,0(t0) 			# salva a cor da colisao no render de colisao

	addi t0,t0,1			# avanca o endereco do mapa de colisao em 1		
	
	addi t2,t2,1 			# avanca o contador de colunas em 1
	blt t2,t4,SaveObjRenderCol 	# enquanto a linha nao estiver completa, continua desenhando ela
	
	addi t0,t0,32 			# avanca para a proxima linha do mapa de colisao
	sub t0,t0,t4 			# subtrai largura do sprite

	mv t2,zero 			# reseta o contador de colunas
	addi t3,t3,1 			# avanca o contador de linhas em 1
	blt t3,t5,SaveObjRenderCol 	# enquanto o contador de linhas for menor que a altura repete a funcao
	
	j RenderNextObj

FimUpdateCollision:
	
	lw ra,0(sp)
	lw s0,4(sp)
	lw s1,8(sp)
	lw s2,12(sp)
	lw s3,16(sp)
	lw s4,20(sp)
	lw s5,24(sp)
	lw s6,28(sp)
	lw s7,32(sp)
	addi sp,sp,36

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
	
	li s7,18		# s7, numero maximo de tiles na horizontal
	li s8,16		# s8, numero maximo de tiles na vertical
	li s9,288		# s9, numero total de tiles que precisam ser analisados (21 na horizontal * 16 na vertical) old: 336 (21x16)
	
LoopBuild:	# passa pelo mapa de tiles e usa ele para montar o mapa de pixels

	beq s6,s9,FimPrintMapa	# continua o codigo quando todos os tiles forem analisados
	
	lw a0,MapGridAtual
	
	lw t1,0(a0)
	
	add a0,a0,s1		# adiciona offsetX/16
	add a0,a0,s4		# adiciona contador de colunas
	
	mv t0,s3		# adiciona offsetY/16
	add t0,t0,s5		# adiciona contador de linhas
	mul t0,t0,t1		# multiplica por 40 (tamanho das linhas do mapa completo)
	add a0,a0,t0		
	
	# # # # #
	addi a0,a0,spriteHeader
	lbu t0,0(a0)		# armazena o valor do tile a ser salvo
	
	lw a1,TileSprtStartAdd 		# a1, endereco inicial dos sprites
	
	li t1,tileFullSize
	mul t1,t0,t1
	add a1,a1,t1			# tamanho total dos tiles (268) e multiplicado pelo ID e somado ao endereco inicial dos tiles de colisao para encontrar o tile atual
	# # # # #

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
	
	mv a3,zero			# define a3 como 0 se for a qualquer uma das outras linhas
DoneLineOffset:			
	
	bne a2,zero,SaveTile		# se for uma coluna inicial ou final vai para SaveTile
	bne a3,zero,SaveTile		# se for uma linha inicial ou final vai para SaveTile
	
	j SaveCenterTile		# tiles do meio s�o mais simples ent�o podem ser salvos mais rapidamente
FimSaveTile:
	
	addi s4,s4,1			# avanca contador de colunas de tiles
	addi s6,s6,1			# avanca contador total de tile
	bge s4,s7,NextLine		# se estiver no fim de uma linha vai para a proxima
	j LoopBuild
	
NextLine:				# pr�xima linha de tiles
	mv s4,zero		
	addi s5,s5,1			# avanca contador de linhas
	j LoopBuild

#----------
SaveTile: 	# a1 = sprite que vai ser salvo no mapa de pixels, a2 = offset das colunas, a3 = offset das linhas
	
	mv t1,s4

	slli t1,t1,4			# multiplica numero da coluna por 16 (tamanho dos tiles)
	blt a2,zero,FirstCol
	# todas as colunas exceto a 1a:
	sub t1,t1,s0			# resto do offset X subtra�do do bitmap (puxa para a esquerda as colunas, se ocorrer na 1a = erro)
FirstCol:
	
	mv t2,s5
	li t0,320
	mul t2,t2,t0			# multiplica numero da linha por 320 (tamanho das linhas do bitmap)
	slli t2,t2,4			# multiplica numero da linha por 16 (tamanho dos tiles)
	blt a3,zero,FirstLine
	# todas as linhas exceto a 1a:
	mul t0,s2,t0
	sub t2,t2,t0			# resto do offset Y vezes 320 subtra�do do bitmap (sobe as linhas, se ocorrer na 1a = erro)
FirstLine:
	
	lw a4,BitmapFrame
	add t0,a4,t1
	add t0,t0,t2 			# t0 = endereco base para salvar o sprite do tile
	
	addi t1,a1,spriteHeader		# endereco do sprite mais spriteHeader
		
	mv t2,zero			# contador de colunas do tile
	mv t3,zero			# contador de linhas do tile	
	
	sub t4,s8,s0			
	blt a2,zero,SetColSize		# na 1a coluna a largura do tile sera 16-OffsetX
	mv t4,s0
	bgt a2,zero,SetColSize		# na ultima coluna a largura do tile sera OffsetX
	lw t4,0(a1)			# nas outras colunas a largura do tile e 16
SetColSize:
	beq t4,zero,FimSaveTile 	# se a ultima coluna nao estiver aparecendo, t4 = 0 e o tile pode ser skipado
	
	sub t5,s8,s2		
	blt a3,zero,SetLineSize		# na 1a linha a altura do tile ser� 16-OffsetY
	mv t5,s2
	bgt a3,zero,SetLineSize		# na 1a linha a altura do tile ser� OffsetY
	lw t5,4(a1)			# nas outras linhas a altura do tile � 16
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
	sb t6,0(t0) 			# desenha no bitmap display um pixel do sprite (j� que tamanho das linhas pode variar de 1 a 16)

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

#----------
SimplePrint: # a0 = endereco do sprite, a1 = posicao 0xYYYYXXXX
	
	li t0,0xffff
	and t1,a1,t0
	
	li t0,320
	srli t2,a1,16
	mul t2,t2,t0
	
	lw t0,BitmapFrame
	add t0,t0,t1
	add t0,t0,t2 			# t0, endereco base para salvar o sprite
	
	addi t1,a0,spriteHeader		# endereco do sprite mais spriteHeader
	
	mv t2,zero			# contador de colunas do tile
	mv t3,zero			# contador de linhas do tile	
	
	lw t4,0(a0) 			# guarda a largura do tile
	lw t5,4(a0)			# guarda a altura do tile
				
SimpleLine: 	# t0 = endereco do bitmap display; t1 = endereco do sprite

	lb t6,0(t1) 			# guarda um pixel do sprite (nao pode ser word por nao estar sempre alinhado com o endereco)
	sb t6,0(t0) 			# desenha no bitmap display (4 pixels separadamente)

	addi t0,t0,1			# avanca o endereco do bitmap display
	addi t1,t1,1 			# avanca o endereco da imagem
	
	addi t2,t2,1 			# avanca o contador de colunas
	blt t2,t4,SimpleLine 	# enquanto a linha nao estiver completa, continua desenhando ela
	
	addi t0,t0,320 			# avanca para a proxima linha do bitmap
	sub t0,t0,t4 			# subtrai a largura do sprite

	mv t2,zero 			# reseta o contador de colunas
	addi t3,t3,1 			# avanca o contador de linhas
	blt t3,t5,SimpleLine 	# enquanto o contador de linhas for menor que a altura repete a funcao

FimSimplePrint: 
	ret
	
#---------- 
FillPrint: # a0 = valor da cor, a1 = posicao X de inicio, a2 = posicao Y de inicio, a3 = largura, a4 = altura, a5 = quickPrint ativo ou nao (1 ou 0)

	li t0,320
	mul t1,t0,a2
	
	lw t0,BitmapFrame
	add t0,t0,a1
	add t0,t0,t1 			# t0, endereco base para salvar o sprite
	
	mv t2,zero			# contador de colunas do tile
	mv t3,zero			# contador de linhas do tile	
	
	mv t4,a3 			# guarda a largura do tile
	mv t5,a4			# guarda a altura do tile
	
	bnez a5,QuickPrint
				
FillLine: 	# t0 = endereco do bitmap display; t1 = endereco do sprite

	sb a0,0(t0) 			# desenha um byte no bitmap display

	addi t0,t0,1			# avanca o endereco do bitmap display
	
	addi t2,t2,1 			# avanca o contador de colunas
	blt t2,t4,FillLine 		# enquanto a linha nao estiver completa, continua desenhando ela
	
	addi t0,t0,320 			# avanca para a proxima linha do bitmap
	sub t0,t0,t4 			# subtrai a largura do sprite

	mv t2,zero 			# reseta o contador de colunas
	addi t3,t3,1 			# avanca o contador de linhas
	blt t3,t5,FillLine 		# enquanto o contador de linhas for menor que a altura repete a funcao
	
	j FimFillPrint
	
QuickPrint:
	mv t6,a0
	slli t1,a0,8
	add t1,t1,t6
	slli t1,t1,8
	add t1,t1,t6
	slli t1,t1,8
	add t1,t1,t6 # 0xa0a0a0a0
	
QuickFillLine:
	sw t1,0(t0) 			# desenha um byte no bitmap display

	addi t0,t0,4			# avanca o endereco do bitmap display
	
	addi t2,t2,4 			# avanca o contador de colunas
	blt t2,t4,QuickFillLine 		# enquanto a linha nao estiver completa, continua desenhando ela
	
	addi t0,t0,320 			# avanca para a proxima linha do bitmap
	sub t0,t0,t4 			# subtrai a largura do sprite

	mv t2,zero 			# reseta o contador de colunas
	addi t3,t3,1 			# avanca o contador de linhas
	blt t3,t5,QuickFillLine 		# enquanto o contador de linhas for menor que a altura repete a funcao

FimFillPrint: 
	ret

