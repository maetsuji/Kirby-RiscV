.eqv KeyMap0		0xFF200520
.eqv KeyMap1		0xFF200524
.eqv KeyMap2		0xFF200528
.eqv KeyMap3		0xFF20052C

.eqv keyW 29 # 0x1D 29-1
.eqv keyA 28 # 0x1C # 28-1
.eqv keyS 27 # 0x1B # 27-1
.eqv keyD 3 # 0x23 # 35-32-1

.eqv keyE 4 # 0x24 # 36-32-1
.eqv keySpace 9 # 0x29 # 41-32-1


.text
TitleKeyPress:
	li t0,0xFF200000		# carrega o endereco de controle do KDMMIO
	lw t2,0(t0)			# Le bit de Controle Teclado
	andi t2,t2,0x0001		# mascara o bit menos significativo
	lw t1,4(t0)  			# le o valor da tecla
	
	beq t2,zero,FimTitleKP	
	
	lw t2,TitleControls
	
	li t0,'e'
	beq t0,t1,PressButton
	li t0,' '
	beq t0,t1,PressButton
	
	li t0,'w'
	beq t0,t1,FlipButton
	li t0,'a'
	beq t0,t1,FlipButton
	li t0,'s'
	beq t0,t1,FlipButton
	li t0,'d'
	beq t0,t1,FlipButton
	j FimTitleKP
	
FlipButton:
	#xori t2,t2,1
	sw t2,TitleControls,t0
	
	j FimTitleKP
	
PressButton:
	bnez t2,FimTitleKP
	
	lh t0,StageID
	bnez t0,RestartGame
	j LoadHub # # # # # # # # # # # # #
RestartGame:
	j LoadTitle

FimTitleKP:
	ret

KeyPress:
	addi sp,sp,-28
	sw ra,0(sp)			# pilha armazena apenas valor de retorno
	sw s0,4(sp)
	sw s1,8(sp)
	sw s2,12(sp)
	sw s3,16(sp)
	sw s4,20(sp)
	sw s5,24(sp)

	#ebreak

	li t0,0xFF200000		# carrega o endereco de controle do KDMMIO
	lw t2,0(t0)			# Le bit de Controle Teclado
	andi t2,t2,0x0001		# mascara o bit menos significativo
	lw t1,4(t0)  			# le o valor da tecla
	
	bne t2,zero,ContinueKP	
	mv t1,zero			# se nenhuma tecla esta sendo apertada salva 0 como a tecla atual
ContinueKP:
	
	sw t1,LastKey,t0		# atualiza a ultima tecla pressionada
	
	DE1(t0,DE1KeyPress)

ReturnDE1KP:

	lw s0,PlayerLock
	bne s0,zero,LockedPlayer

	lw t1,LastKey

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
 	
  	li t0,'q'
  	beq t1,t0,DropPower
	
  	li t0,'F'
  	beq t1,t0,SetPower1
  	
  	li t0,'G'
  	beq t1,t0,SetPower2
  	
  	li t0,'R'
  	beq t1,t0,SetPower3
  	
  	li t0,'C'
  	beq t1,t0,SetCompletion

FimKeyPress:  	
	lw ra,0(sp)			# pilha armazena apenas valor de retorno
	lw s0,4(sp)
	lw s1,8(sp)
	lw s2,12(sp)
	lw s3,16(sp)
	lw s4,20(sp)
	lw s5,24(sp)
	addi sp,sp,28

  	ret
  	
#-----
DE1KeyPress:
	li s1,1
	la s2,MoveKeys
	la s3,OtherKeys
	
	li t0,KeyMap0
	lw s4,0(t0)
	lw s5,4(t0)
	
	sw zero,0(s2)
	lw zero,0(s3)
	
	slli t0,s1,keyW
	and t1,s4,t0 # KeyMap0
	slt t2,zero,t1
	sb t2,0(s2)
	
	slli t0,s1,keyA
	and t1,s4,t0 # KeyMap0
	slt t2,zero,t1
	sb t2,1(s2)
	
	slli t0,s1,keyS
	and t1,s4,t0 # KeyMap0
	slt t2,zero,t1
	sb t2,2(s2)
	
	slli t0,s1,keyD
	and t1,s5,t0 # KeyMap1
	slt t2,zero,t1
	sb t2,3(s2)
	
	slli t0,s1,keyE
	and t1,s5,t0 # KeyMap1
	slt t2,zero,t1
	sb t2,0(s3)
	
	slli t0,s1,keySpace
	and t1,s5,t0 # KeyMap1
	slt t2,zero,t1
	sb t2,1(s3)
	
	j ReturnDE1KP

#-----
EndGame:
	li a7,10
	#ecall				# metodo temporario de finalizacao do jogo

#-----
DropPower:
	lw t0,PlayerPowState
	li t1,2
	beq t0,t1,BuildDropItem
	li t1,3
	beq t0,t1,BuildDropItem
	j FimKeyPress
BuildDropItem:
	sw zero,PlayerPowState,t1

	li a0,7 # id do objeto (estrela) ###
	li a1,1 # quantidade do objeto
	lw a2,PlayerPosX
	li t0,0x20000
	add a2,a2,t0
	lw a3,PlayerLastDir
	mv a4,zero
	jal BuildObject
	
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
	
SetCompletion:
	
	li a0,100 # duracao em ms
	li a1,80 # nota
	mv a2,zero # instrumento
	jal SetSound
	
	li t0,1
	sh t0,Completion,t1
	
	jal ClearObjects
	
	j FimKeyPress
	
SetSound: # a0 = duracao da nota, a1 = valor da nota, a2 = instrumento

	addi sp,sp,-4
	sw ra,0(sp)			# pilha armazena apenas valor de retorno

	# # # SoundTest
	lw t0,SoundDuration	
	bne t0,zero,SkipSetSound # para iniciar um som verifica se a duracao dele ja passou (a todo ms o valor de duracao e subtraido por 1)

	sw a0,SoundDuration,t1
	sw a1,SoundEffectAtual,t1
	sw a2,SoundInstrument,t1
SkipSetSound:

	lw ra,0(sp)			# pilha armazena apenas valor de retorno
	addi sp,sp,4

	ret
