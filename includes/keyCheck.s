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
	xori t2,t2,1
	sw t2,TitleControls,t0
	
	j FimTitleKP
	
PressButton:
	bnez t2,FimTitleKP
	
	j LoadHub # # # # # # # # # # # # #

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
	
	lw s0,PlayerLock
	bne s0,zero,LockedPlayer
	
ReturnDE1KP:

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
  	
  	li t0,'c'
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
	
SetCompletion:
	# # # SoundTest
	lw t0,SoundDuration	
	bne t0,zero,SkipSoundTest # para iniciar um som verifica se a duracao dele ja passou (a todo ms o valor de duracao e subtriado por 1)
	
	li t0,900 ### # Duracao do som em ms
	sw t0,SoundDuration,t1
	li t0,65### # a0, valor da nota
	sw t0,SoundEffectAtual,t1
	li t0,127
	sw t0,SoundInstrument,t1
SkipSoundTest:
	
	li t0,1
	sh t0,Completion,t1
	j FimKeyPress
