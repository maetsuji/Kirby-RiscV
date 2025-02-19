
CheckBoss:
	addi sp,sp,-4
	sw ra,0(sp)
	
	jal DrawBoss
	
	lh t0,PlayerPosY
	li t1,160
	blt t0,t1,EndCheckBoss
	
	jal BossLogic
	
	lw t0,BossTimer
	addi t0,t0,1
	sw t0,BossTimer,t1
	
	lw t0,BossAnimDuration 
	beqz t0,SkipSubBossDur
	addi t0,t0,-1
	sw t0,BossAnimDuration,t1
SkipSubBossDur:

	lw t0,BossIFrames
	beqz t0,SkipSubBossIFrames
	addi t0,t0,-1
	sw t0,BossIFrames,t1
SkipSubBossIFrames:

	la a0,stageTile100
	li a1,144
	slli a1,a1,16
	addi a1,a1,80
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,stageTile101
	li a1,144
	slli a1,a1,16
	addi a1,a1,96
	mv a3,zero
	mv a4,zero
	jal Print
	
	
EndCheckBoss:
	lw ra,0(sp)
	addi sp,sp,4

	ret

#-----------------------------------------------------------------------------------------------------------
BossLogic:
	addi sp,sp,-4
	sw ra,0(sp)

	# s1 armazenara o novo ID de animacao do boss
	
	lw s0,BossTimer # BossTimer atualizado ao fim do CheckBoss
	
BossAnimation:

	li s1,4 # end
	lw t0,BossHP
	beqz t0,DefinedBossAnim
	
	li s1,3 # hurt
	lw t0,BossIFrames
	bnez t0,DefinedBossAnim
	
	beqz s0,SkipBossAttack # evita ataques no primeiro frame da luta
	# ataque de maca no mod 256
	andi t0,s0,128
	bnez t0,CheckNextBossAtt # skipa o sopro e a piscada quando t0 for 0, pois e o ataque de maca
	li a0,1 # maca
	andi a1,s0,255
	jal BossAttacks
	j SkipBossAnim

CheckNextBossAtt:
	andi t0,s0,64
	li s1,2 # attack, sopro comeca nos valores mod 64, exceto quando for mod 128
	bnez t0,SkipBossAttack
	mv a0,zero # sopro
	andi a1,s0,127
	jal BossAttacks
	j DefinedBossAnim
SkipBossAttack:
	andi t0,s0,31
	li s1,1 # blink
	beqz t0,DefinedBossAnim
SkipBossAnim:
	
	lw t0,BossAnimDuration
	lw s1,BossAnimState 
	bnez t0,DefinedBossAnim # mantem uma animacao que ja estiver acontecendo
	
	mv s1,zero
	j DefinedBossAnim

DefinedBossAnim:
	sw s1,BossAnimState,t0

	lw s5,FrameCount
	
	lw t0,BossSprite
	lw s1,BossAnimCount
	lw s2,BossMaxFrame	# duracao do sprite atual em frames, se for 0 sera um sprite sem animacao

	lw s3,BossAnimState # # # # atualiza s3 com o valor anterior de s1
	lw t0,BossOldAnim
	beq s3,t0,ContinueBossAnim  # continua uma animacao se o valor dela nao trocou
	
	# inicia uma nova animacao:
	sw s5,BossLastFrame,t1
	mv s1,zero	# define que o proximo sprite sera o sprite 0 (da animacao definida abaixo)

	sh s1,BossAnimCount,t1
ContinueBossAnim:
	sw s3,BossOldAnim,t1
	
	mv s6,zero  # inicia definindo a duracao da nova animacao como zero, para o caso das que tem apenas 1 frame
	
	# definicao das animacoes
	li s4,0
	beq s3,zero,GotBossSprite
	li t0,1
	beq s3,t0,WhispyBlink
	li t0,2
	beq s3,t0,WhispyAttack
	li t0,3
	beq s3,t0,WhispyHurt
	li t0,4
	beq s3,t0,WhispyEnd
	
	
WhispyBlink:
	jal CheckNextSprAnimBoss
	li t0,3
	rem s1,s1,t0
	
	lw t0,BossAnimDuration
	bnez t0,SkipSetDurationBlink
	li t0,12
	sw t0,BossAnimDuration,t1
SkipSetDurationBlink:
	
	li s4,1 # blink0
	li s6,4
	beq s1,zero,GotBossSprite
	li t0,1
	li s4,2 # blink1
	li s6,4
	beq s1,t0,GotBossSprite
	li t0,2
	li s4,1 # blink0
	li s6,4
	beq s1,t0,GotBossSprite
	
WhispyAttack:
	jal CheckNextSprAnimBoss
	li t0,3
	rem s1,s1,t0
	
	lw t0,BossAnimDuration
	bnez t0,SkipSetDurationAtt
	li t0,40
	sw t0,BossAnimDuration,t1
SkipSetDurationAtt:
	
	li s4,3 # attack0
	li s6,8
	beq s1,zero,GotBossSprite
	li t0,1
	li s4,4 # attack1
	li s6,24
	beq s1,t0,GotBossSprite
	li t0,2
	li s4,5 # attack2
	li s6,8
	beq s1,t0,GotBossSprite
	
WhispyHurt:
	jal CheckNextSprAnimBoss
	andi s1,s1,3
	
	lw t0,BossAnimDuration
	bnez t0,SkipSetDurationHurt
	li t0,24
	sw t0,BossAnimDuration,t1
SkipSetDurationHurt:
	
	li s4,6 # hurt0
	li s6,8
	beq s1,zero,GotBossSprite
	li t0,1
	li s4,7 # hurt1
	li s6,8
	beq s1,t0,GotBossSprite
	li t0,2
	li s4,6 # hurt0
	li s6,8
	beq s1,t0,GotBossSprite
	li t0,3
	li s4,7 # hurt1
	li s6,8
	beq s1,t0,GotBossSprite
	
WhispyEnd:
	jal CheckNextSprAnimBoss
	andi s1,s1,1
	
	lw t0,BossAnimDuration
	bnez t0,SkipSetDurationEnd
	li t0,32
	sw t0,BossAnimDuration,t1
SkipSetDurationEnd:
	
	li s4,8 # hurt0
	li s6,16
	beq s1,zero,GotBossSprite
	li t0,1
	li s4,9 # hurt1
	li s6,16
	beq s1,t0,GotBossSprite
	
GotBossSprite:
	sw s1,BossAnimCount,t0
	sw s4,BossSprite,t0	# armazena o valor do novo sprite 
	sw s6,BossMaxFrame,t0  # armazena a duracao da animacao atual

FimBossAnimation:
	lw ra,0(sp)
	addi sp,sp,4			# recupera endereco de retorno da pilha

	ret
	
#----
CheckNextSprAnimBoss:
	
	# s5, FrameCount
	# s2, frames de duracao do sprite
	lw t1,BossLastFrame
	
	sub t2,s5,t1	
	blt t2,s2,KeepBossSprAnim
	beq s2,zero,KeepBossSprAnim		# se estiver chegando de um sprite fixo
	
	sw s5,BossLastFrame,t0
	addi s1,s1,1 		# avanca o contador de sprites da animacao se a duracao do sprite passou
KeepBossSprAnim:

	ret

#------------
BossAttacks: # a0 = 0 se for ar, 1 se for macas; a1 = valor do timer de apoio
	addi sp,sp,-4
	sw ra,0(sp)
	
	bnez a0,AppleAttack
	
	li t0,0
	beq t0,a1,AirAttack
	li t0,21
	beq t0,a1,AirAttack
	li t0,42
	beq t0,a1,AirAttack
	li t0,63
	beq t0,a1,AirAttack
	j DoneBossAttacks
	
AirAttack:
	li a0,enemyAirID # id do objeto (vento inimigo)
	li a1,1 # quantidade do objeto
	li a2,311
	slli a2,a2,16
	addi a2,a2,189
	mv a3,zero # Dir
	jal BuildObject
	
	j DoneBossAttacks
	
AppleAttack:
	bnez a1,DoneBossAttacks
	
	lw t0,LastApple
	
	li t2,16
	beqz t0,GotApplePos
	li t1,1
	li t2,112
	beq t0,t1,GotApplePos
	li t1,2
	li t2,64 
	beq t0,t1,GotApplePos
	li t1,3
	li t2,160 
	beq t0,t1,GotApplePos
	
GotApplePos:
	li a0,enemyAppleID # id do objeto (maca)
	li a1,1 # quantidade do objeto
	li a2,208
	slli a2,a2,16
	add a2,a2,t2
	mv a3,zero # Dir
	mv a4,t0
	jal BuildObject
	
	addi t0,t0,1
	andi t0,t0,3
	sw t0,LastApple,t1
	
DoneBossAttacks:	

	lw ra,0(sp)
	addi sp,sp,4
	
	ret
	
#------------
DrawBoss:
	addi sp,sp,-4
	sw ra,0(sp)
	
	lw t0,BossSprite
	beqz t0,WhispyIdle
	li t1,1
	beq t0,t1,WhispyBlink0
	li t1,2
	beq t0,t1,WhispyBlink1
	li t1,3
	beq t0,t1,WhispyAtt0
	li t1,4
	beq t0,t1,WhispyAtt1
	li t1,5
	beq t0,t1,WhispyAtt2
	li t1,6
	beq t0,t1,WhispyHurt0
	li t1,7
	beq t0,t1,WhispyHurt1
	li t1,8
	beq t0,t1,WhispyEnd0
	li t1,9
	beq t0,t1,WhispyEnd1
	
WhispyIdle:
	la a0,eye0
	li a1,263
	slli a1,a1,16
	addi a1,a1,170
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,eye0
	li a1,263
	slli a1,a1,16
	addi a1,a1,183
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,eye0
	li a1,305
	slli a1,a1,16
	addi a1,a1,175
	mv a3,zero
	mv a4,zero
	jal Print

	j EndPrintWhispy
	
WhispyBlink0:
	la a0,eye1
	li a1,265
	slli a1,a1,16
	addi a1,a1,169
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,eye1
	li a1,265
	slli a1,a1,16
	addi a1,a1,182
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,eye1
	li a1,302
	slli a1,a1,16
	addi a1,a1,175
	mv a3,zero
	mv a4,zero
	jal Print

	j EndPrintWhispy
	
WhispyBlink1:
	la a0,eye2
	li a1,270
	slli a1,a1,16
	addi a1,a1,169
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,eye2
	li a1,270
	slli a1,a1,16
	addi a1,a1,182
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,eye1
	li a1,302
	slli a1,a1,16
	addi a1,a1,175
	mv a3,zero
	mv a4,zero
	jal Print

	j EndPrintWhispy
	
WhispyAtt0:
	la a0,eye0
	li a1,263
	slli a1,a1,16
	addi a1,a1,170
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,eye0
	li a1,263
	slli a1,a1,16
	addi a1,a1,183
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,mouth0
	li a1,303
	slli a1,a1,16
	addi a1,a1,165
	li a3,1
	mv a4,zero
	jal Print

	j EndPrintWhispy
	
WhispyAtt1:
	la a0,eye0
	li a1,263
	slli a1,a1,16
	addi a1,a1,170
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,eye0
	li a1,263
	slli a1,a1,16
	addi a1,a1,183
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,mouth0
	li a1,303
	slli a1,a1,16
	addi a1,a1,168
	li a3,1
	mv a4,zero
	jal Print

	j EndPrintWhispy
	
WhispyAtt2:
	la a0,eye0
	li a1,263
	slli a1,a1,16
	addi a1,a1,170
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,eye0
	li a1,263
	slli a1,a1,16
	addi a1,a1,183
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,mouth0
	li a1,303
	slli a1,a1,16
	addi a1,a1,165
	li a3,1
	mv a4,zero
	jal Print

	j EndPrintWhispy
	
WhispyHurt0:
	la a0,eye0
	li a1,252
	slli a1,a1,16
	addi a1,a1,172
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,eye1
	li a1,260
	slli a1,a1,16
	addi a1,a1,187
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,mouth1
	li a1,316
	slli a1,a1,16
	addi a1,a1,173
	mv a3,zero
	mv a4,zero
	jal Print
	
	j EndPrintWhispy
	
WhispyHurt1:
	la a0,eye0
	li a1,265
	slli a1,a1,16
	addi a1,a1,172
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,eye1
	li a1,268
	slli a1,a1,16
	addi a1,a1,185
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,mouth1
	li a1,308
	slli a1,a1,16
	addi a1,a1,174
	mv a3,zero
	mv a4,zero
	jal Print

	j EndPrintWhispy
	
WhispyEnd0:
	la a0,eye3
	li a1,272
	slli a1,a1,16
	addi a1,a1,169
	li a3,1
	mv a4,zero
	jal Print
	
	la a0,eye3
	li a1,272
	slli a1,a1,16
	addi a1,a1,183
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,mouth1
	li a1,304
	slli a1,a1,16
	addi a1,a1,170
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,tear
	li a1,283
	slli a1,a1,16
	addi a1,a1,184
	mv a3,zero
	mv a4,zero
	jal Print
	
	j EndPrintWhispy
	
WhispyEnd1:
	la a0,eye0
	li a1,263
	slli a1,a1,16
	addi a1,a1,170
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,eye3
	li a1,271
	slli a1,a1,16
	addi a1,a1,183
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,mouth1
	li a1,306
	slli a1,a1,16
	addi a1,a1,171
	mv a3,zero
	mv a4,zero
	jal Print
	
	la a0,tear
	li a1,282
	slli a1,a1,16
	addi a1,a1,184
	mv a3,zero
	mv a4,zero
	jal Print
	
	j EndPrintWhispy

EndPrintWhispy:	
	lw ra,0(sp)
	addi sp,sp,4
	
	ret
