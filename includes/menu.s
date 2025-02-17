.text

DrawMenu:
	addi sp,sp,-4
	sw ra,0(sp)
	
	li a0,38 # cor
	mv a5,zero # quick print desativado
	
	li a1,266 # PosX
	li a2,0 # PosY
	li a3,52 # tamanho X
	li a4,240 # tamanho Y
	jal FillPrint
	
	#---------------------------------------------------------------------------
	
	li a0,183
	
	li a1,267
	li a2,0
	li a3,1
	li a4,240
	jal FillPrint
	
	li a1,316
	li a2,0
	li a3,1
	li a4,240
	jal FillPrint
	
	li a1,319
	li a2,0
	li a3,1
	li a4,240
	jal FillPrint
	
	li a1,288
	li a2,2
	li a3,8
	li a4,1
	jal FillPrint
	
	li a1,283
	li a2,3
	li a3,18
	li a4,1
	jal FillPrint
	
	li a1,279
	li a2,4
	li a3,26
	li a4,1
	jal FillPrint
	
	li a1,276
	li a2,5
	li a3,32
	li a4,1
	jal FillPrint
	
	li a1,273
	li a2,6
	li a3,38
	li a4,1
	jal FillPrint
	
	li a1,271
	li a2,7
	li a3,42
	li a4,1
	jal FillPrint
	
	li a1,270
	li a2,8
	li a3,44
	li a4,115
	jal FillPrint
	
	li a1,271
	li a2,123
	li a3,42
	li a4,2
	jal FillPrint
	
	li a1,272
	li a2,125
	li a3,38
	li a4,1
	jal FillPrint
	
	li a1,273
	li a2,126
	li a3,36
	li a4,1
	jal FillPrint
	
	li a1,274
	li a2,127
	li a3,34
	li a4,1
	jal FillPrint
	
	li a1,276
	li a2,128
	li a3,30
	li a4,1
	jal FillPrint
	
	li a1,268
	li a2,130
	li a3,1
	li a4,3
	jal FillPrint
	
	li a1,315
	li a2,130
	li a3,1
	li a4,3
	jal FillPrint
	
	li a1,269
	li a2,131
	li a3,46
	li a4,1
	jal FillPrint
	
	li a1,274
	li a2,134
	li a3,36
	li a4,44
	jal FillPrint
	
	li a1,268
	li a2,179
	li a3,1
	li a4,3
	jal FillPrint
	
	li a1,315
	li a2,179
	li a3,1
	li a4,3
	jal FillPrint
	
	li a1,269
	li a2,180
	li a3,46
	li a4,1
	jal FillPrint
	
	li a1,270
	li a2,185
	li a3,1
	li a4,45
	jal FillPrint
	
	li a1,271
	li a2,185
	li a3,3
	li a4,1
	jal FillPrint
	
	li a1,274
	li a2,185
	li a3,1
	li a4,48
	jal FillPrint
	
	li a1,309
	li a2,185
	li a3,1
	li a4,48
	jal FillPrint
	
	li a1,310
	li a2,185
	li a3,3
	li a4,1
	jal FillPrint
	
	li a1,313
	li a2,185
	li a3,1
	li a4,45
	jal FillPrint
	
	li a1,282
	li a2,183
	li a3,20
	li a4,1
	jal FillPrint
	
	li a1,280
	li a2,184
	li a3,24
	li a4,1
	jal FillPrint
	
	li a1,279
	li a2,185
	li a3,26
	li a4,2
	jal FillPrint
	
	li a1,278
	li a2,187
	li a3,28
	li a4,48
	jal FillPrint
	
	li a1,279
	li a2,235
	li a3,26
	li a4,1
	jal FillPrint
	
	li a1,283
	li a2,236
	li a3,18
	li a4,1
	jal FillPrint
	
	li a1,288
	li a2,237
	li a3,8
	li a4,1
	jal FillPrint
	
	li a1,271
	li a2,230
	li a3,1
	li a4,2
	jal FillPrint
	
	li a1,272
	li a2,231
	li a3,1
	li a4,1
	jal FillPrint
	
	li a1,273
	li a2,232
	li a3,1
	li a4,1
	jal FillPrint
	
	li a1,312
	li a2,230
	li a3,1
	li a4,2
	jal FillPrint
	
	li a1,311
	li a2,231
	li a3,1
	li a4,1
	jal FillPrint
	
	li a1,310
	li a2,232
	li a3,1
	li a4,1
	jal FillPrint
	
	#---------------------------------------------------------------------------
	
	li a0,10
	
	li a1,264
	li a2,0
	li a3,2
	li a4,240
	jal FillPrint
	
	li a1,318
	li a2,0
	li a3,1
	li a4,240
	jal FillPrint
	
	li a1,288
	li a2,1
	li a3,8
	li a4,1
	jal FillPrint
	
	li a1,283
	li a2,2
	li a3,5
	li a4,1
	jal FillPrint
	
	li a1,296
	li a2,2
	li a3,5
	li a4,1
	jal FillPrint
	
	li a1,279
	li a2,3
	li a3,4
	li a4,1
	jal FillPrint
	
	li a1,301
	li a2,3
	li a3,4
	li a4,1
	jal FillPrint
	
	li a1,276
	li a2,4
	li a3,3
	li a4,1
	jal FillPrint
	
	li a1,305
	li a2,4
	li a3,3
	li a4,1
	jal FillPrint
	
	li a1,273
	li a2,5
	li a3,4
	li a4,1
	jal FillPrint
	
	li a1,308
	li a2,5
	li a3,4
	li a4,1
	jal FillPrint
	
	li a1,271
	li a2,6
	li a3,2
	li a4,1
	jal FillPrint
	
	li a1,311
	li a2,6
	li a3,2
	li a4,1
	jal FillPrint
	
	li a1,270
	li a2,7
	li a3,1
	li a4,1
	jal FillPrint
	
	li a1,313
	li a2,7
	li a3,1
	li a4,1
	jal FillPrint
	
	li a1,269
	li a2,8
	li a3,1
	li a4,122
	jal FillPrint
	
	li a1,314
	li a2,8
	li a3,1
	li a4,122
	jal FillPrint
	
	li a1,270
	li a2,129
	li a3,44
	li a4,1
	jal FillPrint
	
	li a1,273
	li a2,133
	li a3,1
	li a4,46
	jal FillPrint
	
	li a1,274
	li a2,133
	li a3,36
	li a4,1
	jal FillPrint
	
	li a1,310
	li a2,133
	li a3,1
	li a4,46
	jal FillPrint
	
	li a1,274
	li a2,178
	li a3,36
	li a4,1
	jal FillPrint
	
	li a1,277
	li a2,182
	li a3,1
	li a4,54
	jal FillPrint
	
	li a1,278
	li a2,182
	li a3,28
	li a4,1
	jal FillPrint
	
	li a1,306
	li a2,182
	li a3,1
	li a4,54
	jal FillPrint
	
	li a1,278
	li a2,235
	li a3,1
	li a4,1
	jal FillPrint
	
	li a1,305
	li a2,235
	li a3,1
	li a4,1
	jal FillPrint
	
	li a1,279
	li a2,236
	li a3,4
	li a4,1
	jal FillPrint
	
	li a1,301
	li a2,236
	li a3,4
	li a4,1
	jal FillPrint
	
	li a1,283
	li a2,237
	li a3,5
	li a4,1
	jal FillPrint
	
	li a1,296
	li a2,237
	li a3,5
	li a4,1
	jal FillPrint
	
	li a1,288
	li a2,238
	li a3,8
	li a4,1
	jal FillPrint
	
	li a1,289
	li a2,208
	li a3,1
	li a4,1
	jal FillPrint
	
	li a1,294
	li a2,208
	li a3,1
	li a4,1
	jal FillPrint
	
	li a1,290
	li a2,209
	li a3,1
	li a4,1
	jal FillPrint
	
	li a1,293
	li a2,209
	li a3,1
	li a4,1
	jal FillPrint
	
	li a1,291
	li a2,210
	li a3,2
	li a4,2
	jal FillPrint
	
	li a1,290
	li a2,212
	li a3,1
	li a4,1
	jal FillPrint
	
	li a1,293
	li a2,212
	li a3,1
	li a4,1
	jal FillPrint
	
	li a1,289
	li a2,213
	li a3,1
	li a4,1
	jal FillPrint
	
	li a1,294
	li a2,213
	li a3,1
	li a4,1
	jal FillPrint
	
	#---------------------------------------------------------------------------
	
	li t0,6
	lh t1,StageID
	beq t0,t1,MenuBoss # Se estiver no boss
	
	la a0,menuScoreName
	li a1,11
	slli a1,a1,16
	addi a1,a1,296
	jal SimplePrint
	
	lw s0,Score
	
	li s1,296 # PosX inicial
	li s2,108 # PosY
	
	mv s3,zero # contador de casas do numero
	li s4,6
	
LoopScoreNum:
	beq s3,s4,EndMenuScoreBoss
	
	li t0,10
	rem s5,s0,t0 # s5, digito atual
	
	la a0,number0
	
	li t1,76 # tamanho dos sprites de numero
	mul t1,t1,s5
	add a0,a0,t1 # chega ao endereco do numero equivalente
	
	slli a1,s2,16
	add a1,a1,s1
	jal SimplePrint
	
	li t0,10
	div s0,s0,t0
	
	addi s2,s2,-9
	addi s3,s3,1
	
	j LoopScoreNum
	
	
MenuBoss:
	la a0,menuEnemyName
	li a1,11
	slli a1,a1,16
	addi a1,a1,296
	jal SimplePrint
	
	lw s0,BossHP
	
	li s1,296 # PosX inicial
	li s2,63 # PosY inicial
	
	mv s3,zero # contador de HP
	li s4,28 
	
DrawBossHP:
	beq s3,s4,EndMenuScoreBoss
	
	slli a1,s2,16
	add a1,a1,s1
	
	blt s3,s0,BossHPOn
	
	la a0,menuBossHp1
	j GotBossHP
BossHPOn:
	la a0,menuBossHp0
	li t0,0x10000
	add a1,a1,t0 # adiciona 1 ao Y
GotBossHP:
	jal SimplePrint
	
	addi s3,s3,1
	addi s2,s2,2
	
	j DrawBossHP
	
EndMenuScoreBoss:

	#---------------------------------------------------------------------------

	la a0,menuKirbyName
	li a1,11
	slli a1,a1,16
	addi a1,a1,280
	jal SimplePrint
	
	lh s0,PlayerHP
	
	li s1,277 # PosX inicial
	li s2,63 # PosY inicial
	
	mv s3,zero # contador de HP
	li s4,7 
	
DrawPlayerHP:
	beq s3,s4,EndDrawPlayerHP
	
	slli a1,s2,16
	add a1,a1,s1
	
	blt s3,s0,PlayerHPOn
	
	la a0,menuHp0
	j GotPlayerHP
PlayerHPOn:
	
	lw t0,FrameCount
	andi t0,t0,31
	
	la a0,menuHp1
	li t1,16
	blt t0,t1,GotPlayerHP
	la a0,menuHp2
	
GotPlayerHP:
	jal SimplePrint
	
	addi s2,s2,8
	addi s3,s3,1
	
	j DrawPlayerHP
EndDrawPlayerHP:

	#---------------------------------------------------------------------------

	lw t0,FrameCount
	andi t0,t0,63

	la a0,menuLittleKirby0
	li t1,16
	blt t0,t1,GotLittleKirby
	la a0,menuLittleKirby1
	li t1,32
	blt t0,t1,GotLittleKirby
	la a0,menuLittleKirby2
	li t1,48
	blt t0,t1,GotLittleKirby
	la a0,menuLittleKirby1
GotLittleKirby:
	
	li a1,192
	slli a1,a1,16
	addi a1,a1,286
	jal SimplePrint
	
	la a0,number0
	li a1,218
	slli a1,a1,16
	addi a1,a1,284
	jal SimplePrint
	
	la a0,number0
	li a1,218
	slli a1,a1,16
	addi a1,a1,284
	jal SimplePrint
	
	la a0,number0
	lhu t0,PlayerLives
	
	li t1,76 # tamanho dos sprites de numero
	mul t1,t1,t0
	add a0,a0,t1 # chega ao endereco do numero equivalente
	
	li a1,218
	slli a1,a1,16
	addi a1,a1,292
	jal SimplePrint
	
	#---------------------------------------------------------------------------
	
	lh s0,StageID
	lw s1,PlayerPowState
	lh s2,PlayerAnimState
	
	la a0,menuBye
	li t0,7
	beq s0,t0,GotMenuState
	
	la a0,menuOuch
	li t0,5
	beq s2,t0,GotMenuState
	
	la a0,menuFire
	li t0,1
	beq s1,t0,GotMenuState
	
	la a0,menuFreeze
	li t0,2
	beq s1,t0,GotMenuState
	
	li t0,8
	bne s2,t0,NotMenuEating
MenuEating:
	la a0,menuNothing
	li t0,3
	beq s1,t0,GotMenuState
	
	la a0,menuFire
	li t0,4
	beq s1,t0,GotMenuState
	
	la a0,menuFreeze
	li t0,5
	beq s1,t0,GotMenuState
	
	j MenuEating
	
NotMenuEating:

	la a0,menuNormal
GotMenuState:
	
	li a1,136
	slli a1,a1,16
	addi a1,a1,276
	jal SimplePrint
	
	lw ra,0(sp)
	addi sp,sp,4
	
	ret
	
	
