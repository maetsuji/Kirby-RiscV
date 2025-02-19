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
	lbu t6,0(t0)
	bnez t6,AttackCheck
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
	lw t1,playerSlowDeaccX
	beq t0,zero,SetSlowDeaccX
	lw t1,playerDeaccX		# t1, velocidade de desaceleracao do jogador no eixo X 
SetSlowDeaccX:
	lw t2,playerAccX		# t2, velocidade de aceleracao do jogador no eixo X
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
	lbu t6,1(t0) # a
	bnez t6,MoveLeft
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
	lbu t6,3(t0)
	bnez t6,MoveRight
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
	beq s0,t0,MoveFly 		# possui chamada de troca de fase
	
	li t0,' '			
	beq s0,t0,MoveJump		# pulo unico
	
	j EndDE1CheckUp
	
DE1CheckUp:
	la t0,MoveKeys
	lbu t6,0(t0) # w
	bnez t6,MoveFly
	
	lbu t6,5(t0) # espaco
	bnez t6,MoveJump
EndDE1CheckUp:
LockedJump:

	beq t1,zero,MoveFall		# se estado do jogador for 0 ele esta caindo
	
	li t0,8
	beq s6,t0,EndEatingDown
BackEatingDown:

	li t0,13
	beq s6,t0,LockedD # se estiver com ar skipa para baixo

	bne s9,zero,LockedD
	
	DE1(t0,DE1CheckDown)
	
	li t0,'s'
	beq s0,t0,MoveDown

	j EndDE1CheckDown

DE1CheckDown:
	la t0,MoveKeys
	lbu t6,2(t0) # s
	bnez t6,MoveDown
EndDE1CheckDown:
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
	
	lw t0,Score
	addi t0,t0,150
	sw t0,Score,t1	
	
	addi s10,s10,-3 # basta subtrair 3 do PowState de item na boca para definir o novo PowState 
	sw s10,PlayerPowState,t1
	
	beq s10,zero,DoneVerticalMv 
	
	lw t0,Score
	addi t0,t0,150
	sw t0,Score,t1	
	
	li t0,1
	sw t0,PlayerLock,t1	
	
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
	
	li t2,starRodCol
	bne t1,t2,NotEnding
	j LoadEnding
NotEnding:
	
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

	lw t1,playerKnockbackX 
	lw t5,PlayerLastDir
	beq t5,zero,GotKnockback
	sub t1,zero,t1
GotKnockback:
	sh t1,PlayerSpeedX,t0 # define manualmente a velocidade do jogador como alem da maxima na direcao oposta que ele esta olhando para efeito de knockback
	
	lw t1,playerKnockbackY
	sh t1,PlayerSpeedY,t0

	li t1,25 # tempo da animacao de hit
	sh t1,PlayerAnimTransit,t5
	
	li t1,100 # tempo do jogador invencivel
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
	
	beqz t1,PlayerDeath
	
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
	#li s1,24 # DefAnimEnter
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
	beq s3,t0,PlayerEating
		
PlayerEating:
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
	li a0,300 # duracao em ms
	li a1,68 # nota
	mv a2,zero # instrumento
	jal SetSound

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
	li a0,100 # duracao em ms
	li a1,80 # nota
	mv a2,zero # instrumento
	jal SetSound

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
	li a0,100 # duracao em ms
	li a1,80 # nota
	mv a2,zero # instrumento
	jal SetSound

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
	li a0,100 # duracao em ms
	li a1,80 # nota
	mv a2,zero # instrumento
	jal SetSound

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
	
IceObjects2:
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
	li a0,100 # duracao em ms
	li a1,40 # nota
	mv a2,zero # instrumento
	jal SetSound

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