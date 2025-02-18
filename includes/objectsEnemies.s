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
	
	# s0 tem o endereco inicial das variaveis do objeto
	sw a0,0(s0) # id
	
	sw a2,4(s0) # posX e posY, pois e possivel armazenar diretamente a word com a posicao de referencia
	
	sh a3,8(s0) # dir
	
	sh a4,10(s0) # status
	
	sh zero,12(s0) # lifeFrames
	
	sh zero,14(s0) # anim
	
	sw zero,16(s0) # posOG
	
	li t0,dustID
	beq a0,t0,BuildDust
	li t0,tinyDustID
	beq a0,t0,BuildTinyDust
	li t0,fireID
	beq a0,t0,BuildFire
	li t0,iceID
	beq a0,t0,BuildIce
	li t0,airID
	beq a0,t0,BuildAir
	li t0,starID
	beq a0,t0,BuildStar
	li t0,waddleID
	beq a0,t0,BuildCommonEnemy
	li t0,hotHeadID
	beq a0,t0,BuildCommonEnemy
	li t0,chillyID
	beq a0,t0,BuildCommonEnemy
	li t0,enemyAirID 
	beq a0,t0,BuildEnemyAir
	li t0,enemyFireID 
	beq a0,t0,BuildFire # o que importa para a colisao e apenas o ID
	li t0,enemyIceID
	beq a0,t0,BuildIce
	li t0,enemyAppleID
	beq a0,t0,BuildCommonEnemy
	li t0,hitID
	beq a0,t0,BuildHit
	
BuildHit:
	sw a2,4(s0) # posX e posY
	
	li t0,8
	sh t0,12(s0) # lifeFrames
	
	j BuildNextObj
	
BuildEnemyAir: # apenas realizado pelo whispy, sendo que o ar realiza o movimento do fogo, apenas com um valor de LifeFrames maior
	slli t2,a2,16
	srli t2,t2,16 # isola posX
	srli t3,a2,16 # isola posY

	addi t2,t2,-12 # offset inicial
	slli t3,t3,16
	add t3,t3,t2
	sw t3,4(s0) # posX e posY
	
	li t0,40
	sh t0,12(s0) # lifeFrames
	
	j BuildNextObj

BuildDust:
	li t0,12
	beq a3,zero,DustBreakRtoL
	li t0,-12
DustBreakRtoL:

	slli t2,a2,16
	srli t2,t2,16 # isola posX
	srli t3,a2,16 # isola posY

	add t2,t2,t0 # define em qual lado do kirby vai aparecer
	addi t3,t3,4 
	
	slli t3,t3,16
	add t3,t3,t2
	sw t3,4(s0) # posX e posY

	# s0 tem o endereco inicial das variaveis do objeto
	li t0,4
	sh t0,12(s0) # lifeFrames
	
	j BuildNextObj
	
BuildTinyDust:
	# status, a4 = 0, 1, 2, 3, 4, 5
	
	beq a4,zero,DrawBuildTinyLU # 0 = esq cima
	li t0,1
	beq a4,t0,DrawBuildTinyMU # 1 = meio cima
	li t0,2
	beq a4,t0,DrawBuildTinyRU # 2 = dir cima
	li t0,3
	beq a4,t0,DrawBuildTinyLD # 3 = esq baixo
	li t0,4
	beq a4,t0,DrawBuildTinyMD # 4 = meio baixo
	li t0,5
	beq a4,t0,DrawBuildTinyRD # 5 = dir baixo 
DrawBuildTinyLU:
	li t1,20
	li t2,-10
	j DoneBuildTinyPos
DrawBuildTinyMU:
	li t1,36
	li t2,-10
	j DoneBuildTinyPos
DrawBuildTinyRU:
	li t1,52
	li t2,-12
	j DoneBuildTinyPos
DrawBuildTinyLD:
	li t1,20
	li t2,6
	j DoneBuildTinyPos
DrawBuildTinyMD:
	li t1,36
	li t2,6
	j DoneBuildTinyPos
DrawBuildTinyRD:
	li t1,52
	li t2,6

DoneBuildTinyPos:
	bne a3,zero,BuildTinyDustRight
	sub t1,zero,t1 # se jogador estiver para a esquerda inverte a posicao horizontal
BuildTinyDustRight:

	slli t4,a2,16
	srli t4,t4,16 # isola posX
	srli t3,a2,16 # isola posY
	
	add t4,t4,t1
	add t3,t3,t2
	
	slli t3,t3,16
	add t3,t3,t4
	sw t3,4(s0) # posX e posY
	
	li t0,5
	sh t0,12(s0) # lifeFrames
	
	j BuildNextObj
	
BuildFire:
	# status, para o fogo: 0 = para cima, 1 = para baixo
	
	slli t2,a2,16
	srli t2,t2,16 # isola posX
	srli t3,a2,16 # isola posY

	li t0,15 # offset inicial do fogo 
	bne a3,zero,BuildFireRight
	sub t0,zero,t0
BuildFireRight:
	add t2,t2,t0
	
	slli t3,t3,16
	add t3,t3,t2
	sw t3,4(s0) # posX e posY
	
	li t0,10
	sh t0,12(s0) # lifeFrames
	
	j BuildNextObj

BuildIce:
	# status, para o gelo: ###
	
	# 0 = upper right:
	li t0,8  
	li t1,-20
	beq a4,zero,DoneIcePos
	# 1 = middle right:
	li t0,20
	li t1,0
	li t2,1
	beq a4,t2,DoneIcePos
	# 2 = down right:
	li t0,8  
	li t1,20
	li t2,2
	beq a4,t2,DoneIcePos
	# 3 = down left:
	li t0,-8  
	li t1,20
	li t2,3
	beq a4,t2,DoneIcePos
	# 4 = middle left:
	li t0,-20
	li t1,0
	li t2,4
	beq a4,t2,DoneIcePos
	# 5 = upper left:
	li t0,-8  
	li t1,-20
DoneIcePos:

	slli t2,a2,16
	srli t2,t2,16 # isola posX
	srli t3,a2,16 # isola posY
	
	add t2,t2,t0
	add t3,t3,t1
	
	slli t3,t3,16
	add t3,t3,t2
	sw t3,4(s0) # posX e posY
	
	li t0,10
	sh t0,12(s0) # lifeFrames
	
	j BuildNextObj
	
BuildAir:
	slli t2,a2,16
	srli t2,t2,16 # isola posX
	srli t3,a2,16 # isola posY

	li t0,12 # offset inicial do ar 
	bne a3,zero,BuildAirRight
	sub t0,zero,t0
BuildAirRight:
	add t2,t2,t0
	addi t3,t3,-4
	
	slli t3,t3,16
	add t3,t3,t2
	sw t3,4(s0) # posX e posY

	li t0,24
	sh t0,12(s0) # lifeFrames
	
	j BuildNextObj
	
BuildStar:
	slli t2,a2,16
	srli t2,t2,16 # isola posX
	srli t3,a2,16 # isola posY

	li t0,12 # offset inicial da estrela
	bne a3,zero,BuildStarRight
	sub t0,zero,t0
BuildStarRight:
	add t2,t2,t0
	addi t3,t3,-4
	
	slli t3,t3,16
	add t3,t3,t2
	sw t3,4(s0) # posX e posY

	li t0,200
	sh t0,12(s0) # lifeFrames
	
	j BuildNextObj
	
BuildCommonEnemy:
	li t0,1
	sh t0,10(s0) # status
	
	sh t0,12(s0) # lifeFrames
	
	sw a2,4(s0)
	
	sw a2,16(s0) # posOG e definida
	
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

	lw s3,0(s0) # ID

	mv a0,s0
	slti a1,s3,enemyStartIndex # se o id for de um objeto envia 1 para despawnar, se for um inimigo envia 0 para ativar/desativar
	jal CheckScreenBounds
SkipCheckBounds:

	lh s4,4(s0) # PosX
	lh s5,6(s0) # PosY
	lhu s6,8(s0) # Dir
	lh s7,10(s0) # Status
	lhu s8,12(s0) # LifeFrames
	lhu s9,14(s0) # Anim/Assist
	### lw s10,16(s0)
	
	li t0,dustID
	beq s3,t0,DrawDust
	li t0,tinyDustID
	beq s3,t0,DrawTinyDust
	li t0,fireID
	beq s3,t0,DrawFire
	li t0,iceID
	beq s3,t0,DrawIce
	li t0,airID
	beq s3,t0,DrawAir
	li t0,starID
	beq s3,t0,DrawStar
	li t0,waddleID
	beq s3,t0,DrawWaddleDee
	li t0,hotHeadID
	beq s3,t0,DrawHotHead
	li t0,chillyID
	beq s3,t0,DrawChilly
	li t0,enemyAirID 
	beq s3,t0,DrawEnemyAir # criado pelo whispy, bem similar ao fogo
	li t0,enemyFireID
	beq s3,t0,DrawFire
	li t0,enemyIceID
	beq s3,t0,DrawIce
	li t0,enemyAppleID
	beq s3,t0,DrawWaddleDee ### DrawApple
	li t0,hitID
	beq s3,t0,DrawHit ### DrawApple

	j DrawNextObj


DrawDust:
	slli t0,s5,16
	add a1,t0,s4
	
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
	li t1,-2
	addi s5,s5,1
	j DoneTinyPos
DrawTinyMU:
	li t1,-4
	addi s5,s5,1
	j DoneTinyPos
DrawTinyRU:
	li t1,-3
	addi s5,s5,1
	j DoneTinyPos
DrawTinyLD:
	li t1,-2
	addi s5,s5,-1
	j DoneTinyPos
DrawTinyMD:
	li t1,-4
	addi s5,s5,-1
	j DoneTinyPos
DrawTinyRD:
	li t1,-3
	addi s5,s5,-1

DoneTinyPos:
	bne s6,zero,DrawTinyDustRight
	sub t1,zero,t1 # se jogador estiver para a esquerda inverte a posicao horizontal
DrawTinyDustRight:
	
	add s4,s4,t1

	sh s4,4(s0) # PosX
	sh s5,6(s0) # PosY

	slli t0,s5,16
	add a1,t0,s4
	
	mv a3,s6
	mv a4,zero
	
	la a0,tinyDust0
	andi t0,s8,2
	beq t0,zero,DrawObjReady
	la a0,tinyDust1
	
	j DrawObjReady
	
	
DrawAir:	
	mv a0,s0
	jal UpdateCollision
	
	mv a0,s0
	jal ObjectCollisionCheck
	lw t0,0(s0)
	beqz t0,DrawNextObj
	li t1,hitID
	beq t1,t0,DrawNextObj

	li t0,16
	li t1,4 # velocidade de 28 a 19
	bgt s8,t0,DoneAirSpeed
	li t0,12
	li t1,2 # velocidade de 16 a 13
	bgt s8,t0,DoneAirSpeed
	li t0,8
	li t1,1 # velocidade de 13 a 7
	bgt s8,t0,DoneAirSpeed
	li t1,0 # velocidade de 6 a 1
DoneAirSpeed:
	
	bne s6,zero,DrawAirRight
	sub t1,zero,t1
DrawAirRight:

	add s4,s4,t1
	
	sh s4,4(s0) # atualiza PosX
	sh s5,6(s0) # atualiza PosY

	slli t0,s5,16
	add a1,t0,s4
	
	la a0,air
	mv a2,zero
	mv a3,s6
	mv a4,zero
	
	j DrawObjReady
	
	
DrawFire:	
	mv a0,s0
	jal UpdateCollision
	
	mv a0,s0
	jal ObjectCollisionCheck
	lw t0,0(s0)
	beqz t0,DrawNextObj
	li t1,hitID
	beq t1,t0,DrawNextObj
	
	beq s6,zero,MoveFireLeft
	addi s4,s4,4
	j MoveFireHor
MoveFireLeft:
	addi s4,s4,-4
MoveFireHor:
	
	andi t0,s8,1
	bne t0,zero,DoneMoveFireVert # divide a movimentacao vertical por 1
	beq s7,zero,MoveFireDown
	addi s5,s5,-1
	j DoneMoveFireVert
MoveFireDown:
	addi s5,s5,1
DoneMoveFireVert:
	
	sh s4,4(s0) # atualiza PosX
	sh s5,6(s0) # atualiza PosY
	
	slli t0,s5,16
	add a1,t0,s4
	
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
	mv a0,s0
	jal UpdateCollision

	mv a0,s0
	jal ObjectCollisionCheck
	lw t0,0(s0)
	beqz t0,DrawNextObj
	li t1,hitID
	beq t1,t0,DrawNextObj
	
	lw a1,4(s0)
	
	mv a3,s6
	mv a4,zero
	
	la a0,ice1 # frames com vida 10 a 7
	li t0,6 
	bgt s8,t0,DrawObjReady
	la a0,dust1 # frames com vida 6 a 3
	li t0,2
	bgt s8,t0,DrawObjReady
	la a0,ice0 # frames com vida 2 e 1
	j DrawObjReady
	
	
DrawStar:
	mv a0,s0
	jal UpdateCollision
	
	mv a0,s0
	jal ObjectCollisionCheck
	lw t0,0(s0)
	beqz t0,DrawNextObj
	li t1,hitID
	beq t1,t0,DrawNextObj

	li t0,4 
	
	bne s6,zero,DrawStarRight
	sub t0,zero,t0
DrawStarRight:

	add s4,s4,t0
	
	sh s4,4(s0) # atualiza PosX
	sh s5,6(s0) # atualiza PosY

	slli t0,s5,16
	add a1,t0,s4
	
	mv a2,zero
	mv a3,s6
	mv a4,zero
	
	andi t1,s8,15
	
	la a0,star0 # frames com vida 0 a 3
	li t0,4
	blt t1,t0,DrawObjReady
	la a0,star3 # frames com vida 4 a 7
	li t0,8
	blt t1,t0,DrawObjReady
	la a0,star2 # frames com vida 8 a 11
	li t0,12
	blt t1,t0,DrawObjReady
	la a0,star1 # frames de 12 a 15
	j DrawObjReady
	
#---------
DrawEnemyAir:	
	
	addi s4,s4,-4 
	
	andi t0,s8,3
	li t1,2
	beqz t0,EndMoveEnemyAir
	li t2,1
	mv t1,zero
	beq t0,t2,EndMoveEnemyAir
	li t2,2
	li t1,-1
	beq t0,t2,EndMoveEnemyAir
	li t2,3
	mv t1,zero
	beq t0,t2,EndMoveEnemyAir
EndMoveEnemyAir:
	
	add s5,s5,t1
	
	sh s4,4(s0) # atualiza PosX
	sh s5,6(s0) # atualiza PosY

	slli t0,s5,16
	add a1,t0,s4
	
	mv a3,s6
	mv a4,zero
	
	la a0,air 
	j DrawObjReady
	
#---------
DrawHit:
	lw a1,4(s0)
	
	mv a3,s6
	mv a4,zero
	
	mv a0,s8
	li a7,1
	#ecall
	
	la a0,endl
	li a7,4
	#ecall	
	
	la a0,hit0 # frames com vida 8 e 7
	li t0,6 
	bgt s8,t0,DrawObjReady
	la a0,powerUp1 # frames com vida 6 e 5
	li t0,4
	bgt s8,t0,DrawObjReady
	la a0,hit1 # frames com vida 4 e 3
	li t0,2
	bgt s8,t0,DrawObjReady
	la a0,hit2 # frames com vida 2 e 1
	
	j DrawObjReady

#---------
DrawWaddleDee:
	ble s7,zero,DrawNextObj # se estiver com status -1 = morto, 0 = desativado (fora da tela),  1 = ativado, 2 = atingido, 3 = sendo puxado
	
	li t0,3
	beq s7,t0,PullingWaddleDee
	
	beq s9,zero,SkipSubExtraWaddle # tempo
	addi s9,s9,-1
	sh s9,14(s0)
SkipSubExtraWaddle:
	
	li t0,2
	beq s7,t0,WaddleDeath
	
	mv t2,zero

	lh t0,PlayerPosX
	li t1,-1
	andi t3,s8,1
	add t1,t1,t3 # basicamente divide por 2 a velocidade horizontal
	mv a3,zero
	blt t0,s4,GotWaddleDeeDir # se X do jogador for menor que X do inimigo, o jogador esta para a esquerda dele
	li a3,1 # virado para a direita
	mv t1,zero
	beq t0,s4,GotWaddleDeeDir
	li t1,1
	andi t3,s8,1
	sub t1,t1,t3 # basicamente divide por 2 a velocidade horizontal
GotWaddleDeeDir:

	li t2,2 	# # # # # "queda" do inimigo, se houver chao ela e cancelada
	andi t0,s8,1 # lifeFrames
	sub t2,t2,t0 	# reduz a velocidade de queda 
	
	add s4,s4,t1
	add s5,s5,t2
	
	sh s4,4(s0) # atualiza PosX
	sh s5,6(s0) # atualiza PosY
	sh a3,8(s0) # atualiza Dir
	
	mv a0,s0 # endereco base do objeto
	jal UpdateCollision # # # # #
	
	mv a0,s0
	jal EnemyCollisionCheck # # # # #
	
	lh s4,4(s0) # PosX # atualiza posicao apos colisoes
	lh s5,6(s0) # PosY
	
	li t0,2
	bne s7,t0,NotWaddleDeath 
	# se o valor da animacao for 2 o waddle dee esta morrendo 
WaddleDeath:
	la a0,waddleDeeHit
	
	li t0,13
	li t1,1
	li t2,-2
	beq s9,t0,GotWaddleDeathPos
	li t0,10
	li t1,-2
	li t2,2
	beq s9,t0,GotWaddleDeathPos
	li t0,8
	li t1,1
	li t2,-2
	beq s9,t0,GotWaddleDeathPos
	li t0,5
	li t1,1
	li t2,1
	beq s9,t0,GotWaddleDeathPos
	li t0,2
	li t1,-1
	li t2,-1
	beq s9,t0,GotWaddleDeathPos
	mv t1,zero
	mv t2,zero
	
GotWaddleDeathPos:
	add s5,s5,t2
	add s4,s4,t1
	
	sh s4,4(s0) # atualiza PosX
	sh s5,6(s0) # atualiza PosY
	
	bne s9,zero,GotWaddleDeeSprt # timer de 15 frames da animacao de morte e iniciado no EnemyHit
	# ao terminar o timer:
	
	li t0,-1
	sh t0,10(s0) # atualiza status para -1 (morreu e precisa sair da tela para virar 0 e ser reativado)
	sh zero,12(s0) # reinicia LifeFrames para 0
	lw t0,16(s0) # carrega posicao original do objeto
	sw t0,4(s0) # atualiza posicao atual do objeto para a original
	
	### TODO jal build EnemyDeath

	j DrawNextObj
	
PullingWaddleDee:
	addi s9,s9,1
	sh s9,14(s0)
	
	li t0,1
	sh t0,PlayerAnimState,t1 # manualmente mantem a animacao do jogador como a de puxando
	
	mv t2,zero
	li t1,2
	blt s9,t1,LowPullXWaddle
	lh t0,PlayerLastDir	
	li t2,-1
	bne t0,zero,PullingWaddleToLeft
	li t2,1
PullingWaddleToLeft:
	li t0,2
	li t1,10
	blt s9,t1,LowPullXWaddle
	mul t2,t2,t0
LowPullXWaddle:
	
	lh t0,PlayerPosY
	addi t0,t0,-1
	li t1,6
	blt s9,t1,LowPullYWaddle
	addi t0,t0,-1
LowPullYWaddle:
	sub t3,t0,s5 # player Y - waddle dee Y = velocidade de subida/descida
	
	li t1,-2
	blt t3,t1,SetPullRiseWaddle
	
	li t1,2
	bgt t3,t1,SetPullFallWaddle
	j GotPullWaddleSpY
	
SetPullRiseWaddle:
	li t3,-2
	j GotPullWaddleSpY
SetPullFallWaddle:
	li t3,2
GotPullWaddleSpY:

	add s4,s4,t2
	add s5,s5,t3
	
	sh s4,4(s0) # atualiza PosX
	sh s5,6(s0) # atualiza PosY
	
	mv a0,s0 # endereco base do objeto
	jal UpdateCollision # # # # #
	
	mv a0,s0
	jal EnemyCollisionCheck # # # # #
	
	lh s7,10(s0) # Status # atualiza ID
	ble s7,zero,DrawNextObj # se tiver morrido nao o desenha
	
	lh s4,4(s0) # PosX # atualiza posicao apos colisoes
	lh s5,6(s0) # PosY
	
	la a0,waddleDee1
	
	j GotWaddleDeeSprt
	
NotWaddleDeath:
	mv t0,s8 # LifeFrames
	andi t0,t0,31
	li t1,16
	la a0,waddleDee0
	blt t0,t1,GotWaddleDeeSprt
	la a0,waddleDee1
GotWaddleDeeSprt:

	lw a1,4(s0)
	lh a3,8(s0)
	mv a4,zero
	j DrawObjReady
	
# # # # # # # #	# # # # # # # # # # # # # # # # # 
DrawHotHead: 
	ble s7,zero,DrawNextObj # se estiver com status -1 = morto, 0 = desativado (fora da tela),  1 = ativado, 2 = atingido, 3 = sendo puxado
	
	li t0,3
	beq s7,t0,PullingHotHead
	
	beq s9,zero,SkipSubExtraHotHead # tempo
	addi s9,s9,-1
	sh s9,14(s0)
SkipSubExtraHotHead:
	
	li t0,2
	beq s7,t0,HotHeadDeath
	
	andi t0,s8,127
	andi t2,t0,3 # 
	andi t3,t0,8 #
	li t1,96
	bgt t0,t1,SkipHotHeadAttack # fim do ataque
	
	li t1,2
	bne t2,t1,SkipHotHeadAttack # define se ataca ou nao
	slti a4,t3,8 # define se ataque vai para cima ou para baixo
	
	li t1,64
	bgt t0,t1,HotHeadAttack # inicio do ataque
	j SkipHotHeadAttack
HotHeadAttack:
	li a0,enemyFireID # id do objeto (fogo inimigo)
	li a1,1 # quantidade do objeto
	slli a2,s5,16 #PosY
	add a2,a2,s4 # PosX
	mv a3,s6 # Dir
	jal BuildObject
SkipHotHeadAttack:
	
	li t1,-1
	andi t3,s8,1 # s8, lifeFrames
	add t1,t1,t3 # basicamente divide por 2 a velocidade horizontal
	beqz s6,GotHotHeadDir
	li t1,1
	andi t3,s8,1
	sub t1,t1,t3 # basicamente divide por 2 a velocidade horizontal
GotHotHeadDir:

	li t2,2 	# # # # # "queda" do inimigo, se houver chao ela e cancelada
	andi t0,s8,1 # lifeFrames
	sub t2,t2,t0 	# reduz a velocidade de queda 
	
	add s4,s4,t1
	add s5,s5,t2
	
	sh s4,4(s0) # atualiza PosX
	sh s5,6(s0) # atualiza PosY
	
	mv a0,s0 # endereco base do objeto
	jal UpdateCollision # # # # #
	
	mv a0,s0
	jal EnemyCollisionCheck # # # # #
	
	lh s4,4(s0) # PosX # atualiza posicao apos colisoes
	lh s5,6(s0) # PosY
	
	li t0,2
	bne s7,t0,NotHotHeadDeath 
	# se o valor da animacao for 2 o hot head esta morrendo 
HotHeadDeath:
	la a0,hotHeadHit
	
	li t0,13
	li t1,1
	li t2,-2
	beq s9,t0,GotHotHeadDeathPos
	li t0,10
	li t1,-2
	li t2,2
	beq s9,t0,GotHotHeadDeathPos
	li t0,8
	li t1,1
	li t2,-2
	beq s9,t0,GotHotHeadDeathPos
	li t0,5
	li t1,1
	li t2,1
	beq s9,t0,GotHotHeadDeathPos
	li t0,2
	li t1,-1
	li t2,-1
	beq s9,t0,GotHotHeadDeathPos
	mv t1,zero
	mv t2,zero
	
GotHotHeadDeathPos:
	add s5,s5,t2
	add s4,s4,t1
	
	sh s4,4(s0) # atualiza PosX
	sh s5,6(s0) # atualiza PosY
	
	bne s9,zero,GotHotHeadSprt # timer de 15 frames da animacao de morte e iniciado no EnemyHit
	# ao terminar o timer:
	
	li t0,-1
	sh t0,10(s0) # atualiza status para -1 (morreu e precisa sair da tela para virar 0 e ser reativado)
	sh zero,12(s0) # reinicia LifeFrames para 0
	lw t0,16(s0) # carrega posicao original do objeto
	sw t0,4(s0) # atualiza posicao atual do objeto para a original
	
	### TODO jal build EnemyDeath

	j DrawNextObj
	
PullingHotHead:
	addi s9,s9,1
	sh s9,14(s0)
	
	li t0,1
	sh t0,PlayerAnimState,t1 # manualmente mantem a animacao do jogador como a de puxando
	
	mv t2,zero
	li t1,2
	blt s9,t1,LowPullXHotHead
	lh t0,PlayerLastDir	
	li t2,-1
	bne t0,zero,PullingHotHeadToLeft
	li t2,1
PullingHotHeadToLeft:
	li t0,2
	li t1,10
	blt s9,t1,LowPullXHotHead
	mul t2,t2,t0
LowPullXHotHead:
	
	lh t0,PlayerPosY
	addi t0,t0,-1
	li t1,6
	blt s9,t1,LowPullYHotHead
	addi t0,t0,-1
LowPullYHotHead:
	sub t3,t0,s5 # player Y - hot head Y = velocidade de subida/descida
	
	li t1,-2
	blt t3,t1,SetPullRiseHotHead
	
	li t1,2
	bgt t3,t1,SetPullFallHotHead
	j GotPullHotHeadSpY
	
SetPullRiseHotHead:
	li t3,-2
	j GotPullHotHeadSpY
SetPullFallHotHead:
	li t3,2
GotPullHotHeadSpY:

	add s4,s4,t2
	add s5,s5,t3
	
	sh s4,4(s0) # atualiza PosX
	sh s5,6(s0) # atualiza PosY
	
	mv a0,s0 # endereco base do objeto
	jal UpdateCollision # # # # #
	
	mv a0,s0
	jal EnemyCollisionCheck # # # # #
	
	lh s7,10(s0) # Status # atualiza ID
	ble s7,zero,DrawNextObj # se tiver morrido nao o desenha
	
	lh s4,4(s0) # PosX # atualiza posicao apos colisoes
	lh s5,6(s0) # PosY
	
	la a0,hotHead1
	
	j GotHotHeadSprt
	
NotHotHeadDeath:
	mv t0,s8 # LifeFrames
	andi t0,t0,31
	li t1,16
	la a0,hotHead0
	blt t0,t1,GotHotHeadSprt
	la a0,hotHead1
GotHotHeadSprt:

	lw a1,4(s0)
	lh a3,8(s0)
	mv a4,zero
	j DrawObjReady
	
# # # # # # # #	# # # # # # # # # # # # # # # # # 
DrawChilly:
	ble s7,zero,DrawNextObj # se estiver com status -1 = morto, 0 = desativado (fora da tela),  1 = ativado, 2 = atingido, 3 = sendo puxado
	
	li t0,3
	beq s7,t0,PullingChilly
	
	beq s9,zero,SkipSubExtraChilly # tempo
	addi s9,s9,-1
	sh s9,14(s0)
SkipSubExtraChilly:
	
	li t0,2
	beq s7,t0,ChillyDeath
	
	mv t2,zero

	andi t0,s8,511
	andi t2,s8,7
	andi t3,s8,15
	andi t4,s8,3
	
	li t1,448
	bge t0,t1,ChillyMoveLeft
	li t1,384
	bge t0,t1,ChillyMoveRight
	li t1,320
	bge t0,t1,ChillyMoveLeft
	li t1,256
	bge t0,t1,ChillyMoveRight
	li t1,192
	bge t0,t1,ChillyMoveLeft
	li t1,160
	bge t0,t1,ChillyMoveRight
	li t1,48
	bge t0,t1,ChillyJumpAtt
	li t1,32
	bge t0,t1,ChillyCharge
	j ChillyMoveRight
	
ChillyMoveLeft:
	slti t5,t4,1 # t5, velocidade X, fica 1 se t2 = 0
	sub t5,zero,t5
	j ChillyMove
	
ChillyMoveRight:
	slti t5,t4,1 # t5, velocidade X, fica 1 se t2 = 0
	
ChillyMove:
	li t6,1 # t6, velocidade Y
	la a6,chilly0		# a6 armazena temporariamente o sprite
	li t0,8
	bge t3,t0,GotChillyState
	la a6,chilly1
	j GotChillyState

ChillyJumpAtt:
	li t0,8
	beq t3,t0,ChillyIceObjs2
	bnez t3,DoneChillyIce

	li a0,enemyIceID # id do objeto (gelo inimigo)
	li a1,1 # quantidade do objeto
	slli a2,s5,16
	add a2,a2,s4
	mv a3,s6
	li a4,0
	jal BuildObject
	li a0,enemyIceID # id do objeto (gelo inimigo)
	li a1,1 # quantidade do objeto
	slli a2,s5,16
	add a2,a2,s4
	mv a3,s6	
	li a4,2
	jal BuildObject
	li a0,enemyIceID # id do objeto (gelo inimigo)
	li a1,1 # quantidade do objeto
	slli a2,s5,16
	add a2,a2,s4
	mv a3,s6
	li a4,4
	jal BuildObject
	
	j DoneChillyIce
	
ChillyIceObjs2:
	li a0,enemyIceID # id do objeto (gelo inimigo)
	li a1,1 # quantidade do objeto
	slli a2,s5,16
	add a2,a2,s4
	mv a3,s6
	li a4,1
	jal BuildObject
	li a0,enemyIceID # id do objeto (gelo inimigo)
	li a1,1 # quantidade do objeto
	slli a2,s5,16
	add a2,a2,s4
	mv a3,s6
	li a4,3
	jal BuildObject
	li a0,enemyIceID # id do objeto (gelo inimigo)
	li a1,1 # quantidade do objeto
	slli a2,s5,16
	add a2,a2,s4
	mv a3,s6
	li a4,5
	jal BuildObject
	
DoneChillyIce:
	andi t0,s8,511

	li t1,104
	li t6,1
	bge t0,t1,GotChillyJump
	li t6,-1
	j GotChillyJump
ChillyCharge:
	mv t6,zero
	
GotChillyJump:
	andi t2,s8,7
	mv t5,zero
	
	la a6,chillyAtt1
	li t0,4
	ble t2,t0,GotChillyState
	la a6,chillyAtt0
	j GotChillyState
	
GotChillyState:
	
	add s4,s4,t5
	add s5,s5,t6
	
	sh s4,4(s0) # atualiza PosX
	sh s5,6(s0) # atualiza PosY
	sh a3,8(s0) # atualiza Dir
	
	mv a0,s0 # endereco base do objeto
	jal UpdateCollision # # # # #
	
	mv a0,s0
	jal EnemyCollisionCheck # # # # #
	
	lh s4,4(s0) # PosX # atualiza posicao apos colisoes
	lh s5,6(s0) # PosY
	
	li t0,2
	bne s7,t0,NotChillyDeath 
	# se o valor da animacao for 2 o Chilly esta morrendo 
ChillyDeath:
	la a0,chillyAtt1
	
	li t0,13
	li t1,1
	li t2,-2
	beq s9,t0,GotChillyDeathPos
	li t0,10
	li t1,-2
	li t2,2
	beq s9,t0,GotChillyDeathPos
	li t0,8
	li t1,1
	li t2,-2
	beq s9,t0,GotChillyDeathPos
	li t0,5
	li t1,1
	li t2,1
	beq s9,t0,GotChillyDeathPos
	li t0,2
	li t1,-1
	li t2,-1
	beq s9,t0,GotChillyDeathPos
	mv t1,zero
	mv t2,zero
	
GotChillyDeathPos:
	add s5,s5,t2
	add s4,s4,t1
	
	sh s4,4(s0) # atualiza PosX
	sh s5,6(s0) # atualiza PosY
	
	# ao terminar o timer:
	
	li t0,-1
	sh t0,10(s0) # atualiza status para -1 (morreu e precisa sair da tela para virar 0 e ser reativado)
	sh zero,12(s0) # reinicia LifeFrames para 0
	lw t0,16(s0) # carrega posicao original do objeto
	sw t0,4(s0) # atualiza posicao atual do objeto para a original
	
	### TODO jal build EnemyDeath

	j DrawNextObj
	
PullingChilly:
	addi s9,s9,1
	sh s9,14(s0)
	
	li t0,1
	sh t0,PlayerAnimState,t1 # manualmente mantem a animacao do jogador como a de puxando
	
	mv t2,zero
	li t1,2
	blt s9,t1,LowPullXChilly
	lh t0,PlayerLastDir	
	li t2,-1
	bne t0,zero,PullingChillyToLeft
	li t2,1
PullingChillyToLeft:
	li t0,2
	li t1,10
	blt s9,t1,LowPullXChilly
	mul t2,t2,t0
LowPullXChilly:
	
	lh t0,PlayerPosY
	addi t0,t0,-1
	li t1,6
	blt s9,t1,LowPullYChilly
	addi t0,t0,-1
LowPullYChilly:
	sub t3,t0,s5 # player Y - Chilly Y = velocidade de subida/descida
	
	li t1,-2
	blt t3,t1,SetPullRiseChilly
	
	li t1,2
	bgt t3,t1,SetPullFallChilly
	j GotPullChillySpY
	
SetPullRiseChilly:
	li t3,-2
	j GotPullChillySpY
SetPullFallChilly:
	li t3,2
GotPullChillySpY:

	add s4,s4,t2
	add s5,s5,t3
	
	sh s4,4(s0) # atualiza PosX
	sh s5,6(s0) # atualiza PosY
	
	mv a0,s0 # endereco base do objeto
	jal UpdateCollision # # # # #
	
	mv a0,s0
	jal EnemyCollisionCheck # # # # #
	
	lh s7,10(s0) # Status # atualiza ID
	ble s7,zero,DrawNextObj # se tiver morrido nao o desenha
	
	lh s4,4(s0) # PosX # atualiza posicao apos colisoes
	lh s5,6(s0) # PosY
	
	la a6,chilly1
	
	j NotChillyDeath
	
NotChillyDeath:

	mv a0,a6 # Sprite definido na movimentacao

	lw a1,4(s0)
	lh a3,8(s0)
	li a4,2
	j DrawObjReady

#---------------
DrawApple: ### TODO
	

# # # # # # # #	# # # # # # # # # # # # # # # # # 
	
DrawObjReady:
	jal Print
	
	li t0,enemyStartIndex
	li t1,1
	bge s3,t0,SetEnemyLifeFrames # se o id for de um objeto o lifeFrames diminui, se for de um inimigo ele aumenta 
	sub t1,zero,t1
SetEnemyLifeFrames:
	add s8,s8,t1
	
	mv a0,s8 ###
	li a7,1
	#ecall

	la a0,endl
	li a7,4
	#ecall
	
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
EnemyCollisionCheck: # a0 = endereco do objeto sendo analisado
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
	
	mv s0,a0	# s0, endereco base do inimigo
	lh s1,4(s0)	# s1, PosX
	lh s2,6(s0)	# s2, PosY
	lh s4,0(s0)	# s4, ID
	lh s5,10(s0)	# s5, Status
	lh s6,8(s0)	# s6, Dir
	lh s7,12(s0)	# s7, LifeFrames
		
	la s3,collisionRender
	addi s3,s3,spriteHeader
	
	mv t0,s1
	andi t0,t0,0xf
	add s3,s3,t0			# adiciona o resto do offset X por 16
	
	mv t0,s2
	andi t0,t0,0xf
	li t1,32
	mul t0,t0,t1			# adiciona as linhas com base no resto do offset Y por 16
	
	add s3,s3,t0			# s3, inicialmente com o endereco para o primeiro pixel do jogador no mapa de colisoes renderizado


	mv t6,zero # contador de objetos que podem atingir o jogador
	
	j SetupEnemyPlayer
NextEnemyDanger:
	addi t6,t6,1
	li t1,enemyDangerQuant
	beq t1,t6,DoneEnemyPlayerColCheck
	
SetupEnemyPlayer:

	mv t0,s3
	li t5,66 # pixel 2,2 (iniciando em 0,0)
	
	mv t3,zero
	li t4,4				# contador de pixels a analisar

	li t2,playerPullAreaCol
	beq t6,zero,EnemyPlayer
	li t1,1
	li t2,playerCol
	beq t6,t1,EnemyPlayer
	li t1,2
	li t2,playerFireCol
	beq t6,t1,EnemyPlayer
	li t1,3
	li t2,playerIceCol
	beq t6,t1,EnemyPlayer
	li t1,4
	li t2,playerStarCol
	beq t6,t1,EnemyPlayer

EnemyPlayer:

	add t0,t0,t5
	lbu t1,0(t0)
	
	li t5,playerPullAreaCol
	beq t1,t5,EnemyPull # determinado apos a EnemyCollisionCheck
	
	li t5,3
	bne t5,s5,NotPullingEnemy
	
	li t5,playerCol
	beq t1,t5,EnemyEaten # determinado apos EnemyPull
	
NotPullingEnemy:
	beq t1,t2,EnemyHit
	
	addi t3,t3,1
	beq t3,t4,NextEnemyDanger
	
	li t5,11 # pixel 13,2
	li t1,1
	beq t1,t3,EnemyPlayer
	li t5,341 # pixel 2,13
	li t1,2
	beq t1,t3,EnemyPlayer
	li t5,11 # pixel 13,13
	li t1,3
	beq t1,t3,EnemyPlayer
	
EnemyHit:
	li t0,15 # duracao da animacao de morte
	sh t0,14(s0) # Extra

	li t0,2
	sh t0,10(s0) # atualiza status para 2 (esta morrendo)
DoneEnemyPlayerColCheck:	

	li t0,3
	beq s5,t0,DoneEnemyCollisionCheck # se estiver sendo puxado skipa as colisoes com o mapa

SetupEnemyFloor: # cada inimigo realiza uma tentativa de cair, se houver um chao abaixo dele a queda e cancelada
	mv t0,s3
	li t1,480 # 15 linhas do sprite x 32 pixels da renderizacao da colisao
	add t0,t0,t1 
	li t2,56 # verde
	mv t3,zero
	li t4,4				# contador de pixels a analisar
EnemyFloor:
	lbu t1,0(t0)
	
	lbu t5,32(t0) # linha de pixels abaixo do inimigo
	beq t5,t2,DontFlipHotHead
	li t6,hotHeadID
	bne t6,s4,DontFlipHotHead
	xori s6,s6,1 # troca a direcao do hot head se ele for cair
	sh s6,8(s0)
	
	### j SetupEnemyCeiling
	
	bnez t3,NudgeLeft # se for o primeiro pixel analisado empurra o hot head para a direita
	jal SnapRight
	j DontFlipHotHead
NudgeLeft:
	jal SnapLeft
	
DontFlipHotHead:

	bne t1,t2,EnemyDontSnapUp		# analisa pixels 1, 6, 11 e 16 da ultima linha do inimigo
	jal SnapUp
	j EnemyFloor			# repete enquanto colisao acontece
EnemyDontSnapUp:
	addi t0,t0,5			# avanca 5 pixels na linha
	addi t3,t3,1
	blt t3,t4,EnemyFloor
	

SetupEnemyCeiling:
	mv t0,s3
	li t2,7 # vermelho
	mv t3,zero
	li t4,4				# contador de pixels a analisar
EnemyCeiling:
	lbu t1,0(t0)
	bne t1,t2,EnemyDontSnapDown	
	#sh zero,EnemySpeedY,t1
	jal SnapDown			
	j EnemyCeiling			# repete enquanto colisao acontece
EnemyDontSnapDown:
	addi t0,t0,5			# avanca 5 pixels na linha
	addi t3,t3,1
	blt t3,t4,EnemyCeiling

		
SetupEnemyLWall:
	mv t0,s3
	li t2,192 # azul
	mv t3,zero
	li t4,4				# contador de pixels a analisar
EnemyLeftWall:
	lbu t1,0(t0)
	bne t1,t2,EnemyDontSnapRight	
	jal SnapRight
	j EnemyLeftWall		# repete enquanto colisao acontece
EnemyDontSnapRight:
	addi t0,t0,160			# avanca 5 linhas no mapa de colisao
	addi t3,t3,1
	blt t3,t4,EnemyLeftWall


SetupEnemyRWall:
	mv t0,s3
	li t2,192 # azul
	mv t3,zero
	li t4,4				# contador de pixels a analisar
EnemyRightWall:
	lbu t1,15(t0)
	#sb zero,15(t0)
	bne t1,t2,EnemyDontSnapLeft	
	jal SnapLeft
	j EnemyRightWall		# repete enquanto colisao acontece
EnemyDontSnapLeft:
	addi t0,t0,160			# avanca 5 linhas no mapa de colisao
	addi t3,t3,1
	blt t3,t4,EnemyRightWall
	
	
SuccessfulEnemyMove:
	sh s1,4(s0)	# s1, PosX
	sh s2,6(s0)	# s2, PosY
	
DoneEnemyCollisionCheck:

	lw ra,0(sp)
	lw s0,4(sp)
	lw s1,8(sp)
	lw s2,12(sp)
	lw s3,16(sp)
	lw s4,20(sp)
	lw s5,24(sp)
	lw s5,24(sp)
	lw s6,28(sp)
	lw s7,32(sp)
	addi sp,sp,36
	
	ret

#-----
EnemyPull:
	li t0,3
	sh t0,10(s0)

	j DoneEnemyCollisionCheck

#-----
EnemyEaten:
	li t0,-1
	sh t0,10(s0)

	li t0,waddleID
	li t1,playerMouthIndex # 3
	beq s4,t0,SetEatenPower
	li t0,hotHeadID
	li t1,4
	beq s4,t0,SetEatenPower
	li t0,chillyID
	li t1,5
	beq s4,t0,SetEatenPower

SetEatenPower:
	sw t1,PlayerPowState,t0
	
	li t0,12 # transicao engolir
	sh t0,PlayerAnimState,t1	
	
	li t0,25 # transicao de engolir dura 25 frames e termina no PlayerAnimation
	sh t0,PlayerAnimTransit,t1
	
	li t0,1 # impede que atire a estrela sem querer
	sw t0,PlayerLock,t1
	
	li t0,-1
	sh t0,10(s0) # define inimigo como morto
	
	lw t0,16(s0)
	sw t0,4(s0) # reinicia posicao do inimigo
	
	j DoneEnemyCollisionCheck

#----------
CheckScreenBounds: # a0 = endereco do objeto; a1 = 1 para despawnar, 0 para ativar/desativar
	# chamado no DrawObjects
	addi sp,sp,-20
	sw ra,0(sp)
	sw s0,4(sp)
	sw s1,8(sp)
	sw s2,12(sp)
	sw s3,16(sp)

	lh s0,4(a0) # posX
	lh s1,6(a0) # posY
	
	lh s2,16(a0) # ogPosX
	lh s3,18(a0) # ogPosY
	
	lhu t0,OffsetX
	lhu t1,OffsetY
	
	sub s0,s0,t0
	sub s1,s1,t1
	
	sub s2,s2,t0
	sub s3,s3,t1
	
	li t0,-16
	blt s0,t0,OutOfBounds #LeftOOB
	li t0,248 # old: 304
	bgt s0,t0,OutOfBounds #RightOOB
	
	li t0,-16
	blt s1,t0,OutOfBounds #TopOOB
	li t0,240 
	bgt s1,t0,OutOfBounds #BottomOOB

	j EndCheckbounds
	
OutOfBounds:
	bne a1,zero,DespawnObject
	
	# se um inimigo sai da tela basta reinicia-lo para a posicao inicial para reativa-lo
	li t0,1
	sh t0,10(a0) # atualiza status para 1
	sh zero,12(a0) # reinicia LifeFrames para 0
	lw t0,16(a0) # carrega posicao original do objeto
	sw t0,4(a0) # atualiza posicao atual do objeto para a original
	
	j EndCheckbounds
	
ogOutOfBounds:
	li t0,1
	sh t0,10(a0) # atualiza status para 1 se o inimigo foi desativado e saiu da tela (volta a se mover ao entrar na tela, quando status = 1)
	j EndCheckbounds
	
DespawnObject:
	sw zero,0(a0)
	j EndCheckbounds
	
EndCheckbounds:
	
	lw ra,0(sp)
	lw s0,4(sp)
	lw s1,8(sp)
	lw s2,12(sp)
	lw s3,16(sp)
	addi sp,sp,20

	ret

#----------
ClearObjects:
	addi sp,sp,-4
	sw ra,0(sp)
	
	la t0,Obj0ID
	mv t1,zero # contador de objetos
	li t2,objQuant
LoopClearObjs:
	beq t1,t2,EndClearObjs
	
	sw zero,0(t0)
	
	addi t0,t0,objSize
	addi t1,t1,1
	
	j LoopClearObjs
	
EndClearObjs:
	lw ra,0(sp)
	addi sp,sp,4
	
	ret
	
#-----------
ObjectCollisionCheck: # a0 = endereco do objeto sendo analisado
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
	
	mv s0,a0	# s0, endereco base do objeto
	lh s1,4(s0)	# s1, PosX
	lh s2,6(s0)	# s2, PosY
	lh s4,0(s0)	# s4, ID
	lh s5,10(s0)	# s5, Status
	lh s6,8(s0)	# s6, Dir
	lh s7,12(s0)	# s7, LifeFrames
		
	la s3,collisionRender
	addi s3,s3,spriteHeader
	
	mv t0,s1
	andi t0,t0,0xf
	add s3,s3,t0			# adiciona o resto do offset X por 16
	
	mv t0,s2
	andi t0,t0,0xf
	li t1,32
	mul t0,t0,t1			# adiciona as linhas com base no resto do offset Y por 16
	
	add s3,s3,t0			# s3, inicialmente com o endereco para o primeiro pixel do jogador no mapa de colisoes renderizado


	mv t6,zero # contador de colisoes que podem atingir o objeto
	
	j SetupObjectCols
NextObjectDanger:
	addi t6,t6,1
	li t1,3 # commonEnemyCol, wallCol, whispyCol
	beq t1,t6,DoneObjectCollisionCheck
	
SetupObjectCols:

	mv t0,s3
	li t5,66 # pixel 2,2 (iniciando em 0,0)
	
	mv t3,zero
	li t4,4				# contador de pixels a analisar

	li t2,commonEnemyCol
	beq t6,zero,ObjectCols
	li t1,1
	li t2,wallCol
	beq t6,t1,ObjectCols
	li t1,2
	li t2,whispyCol
	beq t6,t1,ObjectCols

ObjectCols:

	add t0,t0,t5
	lbu t1,0(t0)
	
	beq t1,t2,ObjectHit
	
	addi t3,t3,1
	beq t3,t4,NextObjectDanger
	
	li t5,11 # pixel 13,2
	li t1,1
	beq t1,t3,ObjectCols
	li t5,341 # pixel 2,13
	li t1,2
	beq t1,t3,ObjectCols
	li t5,11 # pixel 13,13
	li t1,3
	beq t1,t3,ObjectCols
	
ObjectHit:	
	li t0,whispyCol
	bne t0,t2,SkipBossHit # se for o boss tenta dar dano nele

	lw t0,BossIFrames
	bnez t0,SkipBossHit
	
	li t0,airID
	li t1,-1
	beq t0,s4,GotBossDamage
	li t0,iceID
	li t1,-3
	beq t0,s4,GotBossDamage
	li t0,fireID
	li t1,-3
	beq t0,s4,GotBossDamage
	li t0,starID
	li t1,-4
	
GotBossDamage:
	lw t0,BossHP
	add t0,t0,t1
	bgt t0,zero,DontZeroBossHP
	jal ClearObjects
	mv t0,zero
DontZeroBossHP:
	sw t0,BossHP,t1
	
	li t0,40
	sw t0,BossIFrames,t1
SkipBossHit:

	li t0,iceID
	beq t0,s4,DontHitIce
	
	li t0,enemyIceID
	beq t0,s4,DontHitIce

	sh zero,0(s0) # desespawna objeto
	
	li a0,hitID # id do objeto (sprite de hit) ###
	li a1,1 # quantidade do objeto
	lw a2,4(s0)
	mv a3,zero
	mv a4,zero
	jal BuildObject
DontHitIce:

	j DoneObjectCollisionCheck
	
SuccessfulObjectMove:
	sh s1,4(s0)	# s1, PosX
	sh s2,6(s0)	# s2, PosY
	
DoneObjectCollisionCheck:

	lw ra,0(sp)
	lw s0,4(sp)
	lw s1,8(sp)
	lw s2,12(sp)
	lw s3,16(sp)
	lw s4,20(sp)
	lw s5,24(sp)
	lw s5,24(sp)
	lw s6,28(sp)
	lw s7,32(sp)
	addi sp,sp,36
	
	ret
