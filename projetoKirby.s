.macro DE1(%reg,%salto)
	li %reg, 0x10008000	# carrega tp
	bne gp, %reg, %salto	# Na DE1 gp = 0 ! Nao tem segmento .extern
.end_macro

.data

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
.eqv scoreLen 6

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
playerAccX: 	.word 120
playerDeaccX: 	.word 15
playerSlowDeaccX: .word 5
.eqv playerFlyPow -450
.eqv playerJumpPow -600
.eqv playerFlyIndex 13
.eqv playerMouthIndex 3
playerKnockbackX: .word 250
playerKnockbackY: .word -150
.eqv playerBaseHP 7
.eqv playerBaseLives 2

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

GameAnimTimer:	.word 0

tempPos:	.word 0

endl:		.string "\n"	# temporariamente sendo usado para debug (contador de ms)

.include "objects-enemies/objectDB.data"

.include "maps/whispySprites.data"
.include "archive/oldTests/testMap-Tiles.data"
.include "archive/oldTests/testColSprites.data"

.include "title-menu-ending/titleSprites.data"
.include "title-menu-ending/menuSprites.data"
.include "title-menu-ending/numberSprites.data"
.include "title-menu-ending/letterSprites.data"

.include "maps/hubSpecialTiles.data"
.include "maps/stageTileSprites.data"
.include "maps/stageCols.data"
.include "maps/stageGrids.data"

.include "kirby/kirbyMain.data" 
.include "kirby/kirbyPowers.data"

.include "objects-enemies/objectSprites.data"
.include "objects-enemies/enemySprites.data"

.include "collision/collisionCodes.data"
.include "collision/collisionRender.data"
.include "collision/colSprites.data"

.text
	j StartGame

.include "codeIncludes/player.s"
.include "codeIncludes/objectsEnemies.s"
.include "codeIncludes/boss.s"

.include "codeIncludes/keyCheck.s"
.include "codeIncludes/sounds.s"

.include "codeIncludes/titleEnding.s"
.include "codeIncludes/menu.s"
	
#########################################################################################################################################
StartGame:
	csrr a0,3073
	sw a0,LastGlblTime,t0	# define o primeiro valor do timer global, que sera comparado no Clock
	
	li t0,playerBaseHP
	sh t0,PlayerHP,t1
	
	li t0,playerBaseLives
	sh t0,PlayerLives,t1
	
	li t0,28
	sw t0,BossHP,t1
	
	DE1(t0,DE1Start)
	
	j SkipDE1Start
	
DE1Start:
	li t0,60
	sw t0,playerAccX,t1
	li t0,30
	sw t0,playerDeaccX,t1
	li t0,60
	sw t0,playerSlowDeaccX,t1
	li t0,750
	sw t0,playerKnockbackX,t1
	li t0,-275
	sw t0,playerKnockbackY,t1
SkipDE1Start:
	
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
	li t0,32
	sh t0,FadeTimer,t1
	li t0,0xff
	sw t0,FadeColor,t1
	
	li t0,playerBaseLives
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
	
	la t0,hubFinalGrid #hubReducedGrid# hubFullGrid 		# endereco do grid de tiles atual
	sw t0,MapGridAtual,t1
	
	la t0,stageTiles 	# endereco inicial dos sprites de tile
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
	
	jal StartHubObjects
	
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
	
	jal StartEnemiesLvl1
	
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
	
	jal StartEnemiesLvl2
	
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
	
	jal StartEnemiesLvl3
	
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
	
	jal StartEnemiesLvl4
	
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
	li t1,3
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
LoadEnding:
	li t0,7
	sh t0,StageID,t1
	
	la t0,NotasTitle			# define o endereco inicial das notas
	sw t0,MusicStartAdd,t1
	sw t0,MusicAtual,t1
	sw zero,NoteCounter,t1	# zera o NoteCounter
	
	lw t0,DuracaoTitle # DuracaoHub
	sw t0,LenMusAtual,t1
	
	li t0,32
	sh t0,FadeTimer,t1
	li t0,0xff
	sw t0,FadeColor,t1

	# Posicao inicial do jogador
	li t0,132
	li t1,43
	sh t0,PlayerPosX,t2
	sh t1,PlayerPosY,t2
	
	li t0,playerBaseLives
	sh t0,PlayerLives,t1
	
	sw zero,GameAnimTimer,t1
		
	j TitleMain

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
	
	lh t0,StageID
	li t1,6
	bne t0,t1,NotBoss
	jal CheckBoss
NotBoss:

	lh t0,StageID
	li t1,1
	bne t0,t1,NotHub
	jal DrawHubObjects
NotHub:
	
	jal DrawObjects
	
	jal DrawPlayer
	
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
	
	lh t0,StageID
	bnez t0,EndingScreen
	jal DrawTitle
	j DoneTitleScreen
EndingScreen:
	jal DrawEnding
DoneTitleScreen:	
	
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
	li t1,75
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

	# debug
	
	lhu a0,PlayerAnimState
	li a7,1
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
DrawHubObjects:
	addi sp,sp,-4
	sw ra,0(sp)
	
	la a0,hubDoor2
	li a1,272
	slli a1,a1,16
	addi a1,a1,96
	li a3,1
	mv a4,zero
	jal Print
	
	la a0,hubDoor2
	li a1,304
	slli a1,a1,16
	addi a1,a1,240
	li a3,1
	mv a4,zero
	jal Print
	
	la a0,hubDoor2
	li a1,208
	slli a1,a1,16
	addi a1,a1,320
	li a3,1
	mv a4,zero
	jal Print
	
	la a0,hubDoor3
	li a1,224
	slli a1,a1,16
	addi a1,a1,160
	li a3,1
	mv a4,zero
	jal Print
	
	la a0,hubDoor3
	li a1,160
	slli a1,a1,16
	addi a1,a1,240
	li a3,1
	mv a4,zero
	jal Print
	
	la a0,hubDoor3
	li a1,48
	slli a1,a1,16
	addi a1,a1,448
	li a3,1
	mv a4,zero
	jal Print
	
	la a0,hubDoor1
	lh t0,Completion
	bnez t0,GotLowerDoor
	
	lw t0,FrameCount
	andi t0,t0,4
	la a0,hubDoor0
	beqz t0,GotLowerDoor
	la a0,hubDoor4
GotLowerDoor:
	li a1,256
	slli a1,a1,16
	addi a1,a1,384
	li a3,1
	mv a4,zero
	jal Print
	
	lw t0,FrameCount
	andi t0,t0,4
	la a0,hubDoor0
	beqz t0,GotUpperDoor
	la a0,hubDoor4
GotUpperDoor:
	li a1,128
	slli a1,a1,16
	addi a1,a1,432
	li a3,1
	mv a4,zero
	jal Print
	
	la a0,hub1
	li a1,255
	slli a1,a1,16
	addi a1,a1,96
	li a3,1
	mv a4,zero
	jal Print
	
	la a0,hub2
	li a1,287
	slli a1,a1,16
	addi a1,a1,240
	li a3,1
	mv a4,zero
	jal Print
	
	la a0,hub3
	li a1,191
	slli a1,a1,16
	addi a1,a1,320
	li a3,1
	mv a4,zero
	jal Print
	
	la a0,hubDoor1
	lh t0,Completion
	bnez t0,GotSignFour
	
	lw t0,FrameCount
	andi t0,t0,4
	mv a4,zero
	beqz t0,GotSignFour
	li a4,-1
GotSignFour:
	la a0,hub4
	li a1,239
	slli a1,a1,16
	addi a1,a1,384
	li a3,1
	jal Print
	
	lw t0,FrameCount
	andi t0,t0,4
	mv a4,zero
	beqz t0,GotSignDedede
	li a4,-1
GotSignDedede:
	la a0,hubDedede
	li a1,111
	slli a1,a1,16
	addi a1,a1,432
	li a3,1
	jal Print
	
	lw t0,FrameCount
	andi t0,t0,31
	li t1,11
	la a0,hubFlag0
	blt t0,t1,GotFlagSprite
	li t1,22
	la a0,hubFlag1 
	blt t0,t1,GotFlagSprite
	la a0,hubFlag2
GotFlagSprite:
	li a1,274
	slli a1,a1,16
	addi a1,a1,112
	li a3,1
	mv a4,zero
	jal Print
	
	# a0 mantido
	li a1,306
	slli a1,a1,16
	addi a1,a1,256
	li a3,1
	mv a4,zero
	jal Print
	
	# a0 mantido
	li a1,210
	slli a1,a1,16
	addi a1,a1,336
	li a3,1
	mv a4,zero
	jal Print
	
	lh t0,Completion
	beqz t0,SkipFlag4
	# a0 mantido
	li a1,258
	slli a1,a1,16
	addi a1,a1,400
	li a3,1
	mv a4,zero
	jal Print
SkipFlag4:
	
	#-------------------------------
	lh t0,Completion
	bnez t0,SkipHubBlocks
	
	mv s0,zero # contador
	li s1,40
	
	li s2,416 # PosX inicial
	li s3,16 # PosY inicial
		
LoopBlocks:
	andi t0,s0,1
	la a0,hubT1
	beqz t0,GotLoopBlock 
	la a0,hubRTiles
GotLoopBlock:

	li t0,5
	div t0,s0,t0
	slli t0,t0,4 
	add a1,s3,t0 
	slli a1,a1,16 # encontra Y

	li t0,5
	rem t0,s0,t0
	slli t0,t0,4
	add a1,a1,s2
	add a1,a1,t0 # encontra X
	
	li a3,1
	mv a4,zero
	
	jal Print
	
	addi s0,s0,1
	bne s0,s1,LoopBlocks # loopa enquanto nao foram construidos todos os blocos
SkipHubBlocks:
	
	lw ra,0(sp)
	addi sp,sp,4
	
	ret 

#----------
StartHubObjects:
	addi sp,sp,-4
	sw ra,0(sp)
	
	lh t0,Completion
	bnez t0,HubCompletedLevel

	li a2,16 # PosY
	slli a2,a2,16
	addi a2,a2,400 # PosX
	li a0,hubBlockWall
	li a1,1
	li a3,1
	mv a4,zero
	jal BuildObject # a0 = id do objeto, a1 = quantidade de objetos a adicionar, a2 = posicao de referencia (0xYYYYXXXX), a3 = direcao do objeto (0 = esq, 1 = dir), a4 = valor de apoio
	
	li a2,32 # PosY
	slli a2,a2,16
	addi a2,a2,400 # PosX
	li a0,hubBlockWall
	li a1,1
	li a3,1
	li a4,1
	jal BuildObject
	
	li a2,48 # PosY
	slli a2,a2,16
	addi a2,a2,400 # PosX
	li a0,hubBlockWall
	li a1,1
	li a3,1
	mv a4,zero
	jal BuildObject
	
	li a2,64 # PosY
	slli a2,a2,16
	addi a2,a2,400 # PosX
	li a0,hubBlockWall
	li a1,1
	li a3,1
	li a4,1
	jal BuildObject
	
	li a2,80 # PosY
	slli a2,a2,16
	addi a2,a2,400 # PosX
	li a0,hubBlockWall
	li a1,1
	li a3,1
	mv a4,zero
	jal BuildObject
	
	li a2,96 # PosY
	slli a2,a2,16
	addi a2,a2,400 # PosX
	li a0,hubBlockWall
	li a1,1
	li a3,1
	li a4,1
	jal BuildObject
	
	li a2,112 # PosY
	slli a2,a2,16
	addi a2,a2,400 # PosX
	li a0,hubBlockWall
	li a1,1
	li a3,1
	mv a4,zero
	jal BuildObject
	
	li a2,128 # PosY
	slli a2,a2,16
	addi a2,a2,400 # PosX
	li a0,hubBlockWall
	li a1,1
	li a3,1
	li a4,1
	jal BuildObject
	
	li a2,144 # PosY
	slli a2,a2,16
	addi a2,a2,400 # PosX
	li a0,hubBlockCeil
	li a1,1
	li a3,1
	mv a4,zero
	jal BuildObject
	
	li a2,144 # PosY
	slli a2,a2,16
	addi a2,a2,416 # PosX
	li a0,hubBlockCeil
	li a1,1
	li a3,1
	li a4,1
	jal BuildObject
	
	li a2,144 # PosY
	slli a2,a2,16
	addi a2,a2,432 # PosX
	li a0,hubBlockCeil
	li a1,1
	li a3,1
	mv a4,zero
	jal BuildObject
	
	li a2,144 # PosY
	slli a2,a2,16
	addi a2,a2,448 # PosX
	li a0,hubBlockCeil
	li a1,1
	li a3,1
	li a4,1
	jal BuildObject
	
	li a2,144 # PosY
	slli a2,a2,16
	addi a2,a2,464 # PosX
	li a0,hubBlockCeil
	li a1,1
	li a3,1
	mv a4,zero
	jal BuildObject
	
	li a2,144 # PosY
	slli a2,a2,16
	addi a2,a2,480 # PosX
	li a0,hubBlockCeil
	li a1,1
	li a3,1
	li a4,1
	jal BuildObject
	
HubCompletedLevel:
	lw ra,0(sp)
	addi sp,sp,4
	
	ret
	

#----------
StartEnemiesTest: 
	addi sp,sp,-4
	sw ra,0(sp)

	li a2,16 # PosY
	slli a2,a2,16
	addi a2,a2,32 # PosX
	li a0,waddleID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject # a0 = id do objeto, a1 = quantidade de objetos a adicionar, a2 = posicao de referencia (0xYYYYXXXX), a3 = direcao do objeto (0 = esq, 1 = dir), a4 = valor de apoio
	
	li a2,112 # PosY
	slli a2,a2,16
	addi a2,a2,128 # PosX
	li a0,hotHeadID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject
	
	li a2,160 # PosY
	slli a2,a2,16
	addi a2,a2,48 # PosX
	li a0,chillyID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject
	
	lw ra,0(sp)
	addi sp,sp,4
	
	ret
	
#----------
StartEnemiesLvl1: 
	addi sp,sp,-4
	sw ra,0(sp)

	li a2,96 # PosY
	slli a2,a2,16
	addi a2,a2,96 # PosX
	li a0,hotHeadID
	li a1,1
	li a3,1
	mv a4,zero
	jal BuildObject # a0 = id do objeto, a1 = quantidade de objetos a adicionar, a2 = posicao de referencia (0xYYYYXXXX), a3 = direcao do objeto (0 = esq, 1 = dir), a4 = valor de apoio
	
	li a2,304 # PosY
	slli a2,a2,16
	addi a2,a2,64 # PosX
	li a0,waddleID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject
	
	li a2,304 # PosY
	slli a2,a2,16
	addi a2,a2,224 # PosX
	li a0,waddleID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject
	
	lw ra,0(sp)
	addi sp,sp,4
	
	ret
	
	
#----------
StartEnemiesLvl2: 
	addi sp,sp,-4
	sw ra,0(sp)

	li a2,160 # PosY
	slli a2,a2,16
	addi a2,a2,256 # PosX
	li a0,waddleID 
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject # a0 = id do objeto, a1 = quantidade de objetos a adicionar, a2 = posicao de referencia (0xYYYYXXXX), a3 = direcao do objeto (0 = esq, 1 = dir), a4 = valor de apoio
	
	li a2,144 # PosY
	slli a2,a2,16
	addi a2,a2,400 # PosX
	li a0,chillyID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject
	
	li a2,128 # PosY
	slli a2,a2,16
	addi a2,a2,576 # PosX
	li a0,hotHeadID 
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject
	
	li a2,144 # PosY
	slli a2,a2,16
	addi a2,a2,720 # PosX
	li a0,chillyID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject
	
	li a2,96 # PosY
	slli a2,a2,16
	addi a2,a2,928 # PosX
	li a0,waddleID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject
	
	lw ra,0(sp)
	addi sp,sp,4
	
	ret
	
	
#----------
StartEnemiesLvl3: 
	addi sp,sp,-4
	sw ra,0(sp)

	li a2,432 # PosY
	slli a2,a2,16
	addi a2,a2,128 # PosX
	li a0,chillyID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject
	
	li a2,496 # PosY
	slli a2,a2,16
	addi a2,a2,160 # PosX
	li a0,waddleID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject
	
	li a2,304 # PosY
	slli a2,a2,16
	addi a2,a2,96 # PosX
	li a0,hotHeadID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject
	
	li a2,160 # PosY
	slli a2,a2,16
	addi a2,a2,144 # PosX
	li a0,hotHeadID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject
	
	lw ra,0(sp)
	addi sp,sp,4
	
	ret
	
	
#----------
StartEnemiesLvl4: 
	addi sp,sp,-4
	sw ra,0(sp)

	li a2,112 # PosY
	slli a2,a2,16
	addi a2,a2,312 # PosX
	li a0,chillyID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject # a0 = id do objeto, a1 = quantidade de objetos a adicionar, a2 = posicao de referencia (0xYYYYXXXX), a3 = direcao do objeto (0 = esq, 1 = dir), a4 = valor de apoio
		
	li a2,128 # PosY
	slli a2,a2,16
	addi a2,a2,560 # PosX
	li a0,waddleID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject # a0 = id do objeto, a1 = quantidade de objetos a adicionar, a2 = posicao de referencia (0xYYYYXXXX), a3 = direcao do objeto (0 = esq, 1 = dir), a4 = valor de apoio
	
	li a2,144 # PosY
	slli a2,a2,16
	addi a2,a2,904 # PosX
	li a0,chillyID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject # a0 = id do objeto, a1 = quantidade de objetos a adicionar, a2 = posicao de referencia (0xYYYYXXXX), a3 = direcao do objeto (0 = esq, 1 = dir), a4 = valor de apoio
	
	li a2,64 # PosY
	slli a2,a2,16
	addi a2,a2,904 # PosX
	li a0,chillyID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject # a0 = id do objeto, a1 = quantidade de objetos a adicionar, a2 = posicao de referencia (0xYYYYXXXX), a3 = direcao do objeto (0 = esq, 1 = dir), a4 = valor de apoio
	
	li a2,112 # PosY
	slli a2,a2,16
	addi a2,a2,784 # PosX
	li a0,hotHeadID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject # a0 = id do objeto, a1 = quantidade de objetos a adicionar, a2 = posicao de referencia (0xYYYYXXXX), a3 = direcao do objeto (0 = esq, 1 = dir), a4 = valor de apoio
	
	li a2,144 # PosY
	slli a2,a2,16
	addi a2,a2,1232 # PosX
	li a0,waddleID
	li a1,1
	mv a3,zero
	mv a4,zero
	jal BuildObject # a0 = id do objeto, a1 = quantidade de objetos a adicionar, a2 = posicao de referencia (0xYYYYXXXX), a3 = direcao do objeto (0 = esq, 1 = dir), a4 = valor de apoio
	
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
	
	li t0,16
	lhu t1,FadeTimer
	bgt t1,t0,SkipChangeFrame
	
	li t0,0x00100000
	xor s0,s0,t0
	sw s0,BitmapFrame,t0
SkipChangeFrame:
	
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
	bne s7,t0,SkipDefHitCol
	li a5,playerStarCol # por precaucao, para evitar que inimigos nao sejam atingidos quando deveriam
	lh t1,10(s5)
	beqz t1,GotCollision # status for 0, desenha a colisao do hit, se nao, sera um hit inimigo e nao tera colisao
SkipDefHitCol:

	li t0,hubBlockWall
	li a5,wallCol
	beq s7,t0,GotCollision
	
	li t0,hubBlockCeil
	li a5,ceilingCol
	beq s7,t0,GotCollision
	
	li t0,starRodID
	li a5,starRodCol
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

