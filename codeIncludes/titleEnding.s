.text

DrawTitle:
	addi sp,sp,-4
	sw ra,0(sp)

	li a0,0xff
	li a1,0
	li a2,0
	li a3,320
	li a4,240
	li a5,1
	jal FillPrint

	la a0,smallStarTitle
	
	li a1,0
	slli a1,a1,16
	addi a1,a1,33
	jal SimplePrint
	
	li a1,0
	slli a1,a1,16
	addi a1,a1,145
	jal SimplePrint
	
	li a1,0
	slli a1,a1,16
	addi a1,a1,225
	jal SimplePrint
	
	li a1,16
	slli a1,a1,16
	addi a1,a1,65
	jal SimplePrint
	
	li a1,16
	slli a1,a1,16
	addi a1,a1,257
	jal SimplePrint
	
	li a1,32
	slli a1,a1,16
	addi a1,a1,129
	jal SimplePrint
	
	li a1,32
	slli a1,a1,16
	addi a1,a1,209
	jal SimplePrint
	
	li a1,32
	slli a1,a1,16
	addi a1,a1,305
	jal SimplePrint
	
	li a1,48
	slli a1,a1,16
	addi a1,a1,17
	jal SimplePrint
	
	li a1,64
	slli a1,a1,16
	addi a1,a1,273
	jal SimplePrint
	
	li a1,80
	slli a1,a1,16
	addi a1,a1,33
	jal SimplePrint
	
	li a1,96
	slli a1,a1,16
	addi a1,a1,65
	jal SimplePrint
	
	li a1,96
	slli a1,a1,16
	addi a1,a1,289
	jal SimplePrint
	
	li a1,128
	slli a1,a1,16
	addi a1,a1,1
	jal SimplePrint
	
	li a1,128
	slli a1,a1,16
	addi a1,a1,305
	jal SimplePrint
	
	li a1,144
	slli a1,a1,16
	addi a1,a1,241
	jal SimplePrint
	
	li a1,160
	slli a1,a1,16
	addi a1,a1,65
	jal SimplePrint
	
	li a1,160
	slli a1,a1,16
	addi a1,a1,273
	jal SimplePrint
	
	li a1,176
	slli a1,a1,16
	addi a1,a1,33
	jal SimplePrint
	
	li a1,192
	slli a1,a1,16
	addi a1,a1,225
	jal SimplePrint
	
	li a1,192
	slli a1,a1,16
	addi a1,a1,305
	jal SimplePrint
	
	li a1,208
	slli a1,a1,16
	addi a1,a1,17
	jal SimplePrint
	
	li a1,224
	slli a1,a1,16
	addi a1,a1,81
	jal SimplePrint
	
	li a1,224
	slli a1,a1,16
	addi a1,a1,177
	jal SimplePrint
	
	li a1,224
	slli a1,a1,16
	addi a1,a1,257
	jal SimplePrint
	
	la a0,bigStarTitle
	
	li a1,4
	slli a1,a1,16
	addi a1,a1,92
	jal SimplePrint
	
	li a1,3
	slli a1,a1,16
	addi a1,a1,171
	jal SimplePrint
	
	li a1,35
	slli a1,a1,16
	addi a1,a1,43
	jal SimplePrint
	
	li a1,35
	slli a1,a1,16
	addi a1,a1,235
	jal SimplePrint
	
	li a1,115
	slli a1,a1,16
	addi a1,a1,27
	jal SimplePrint
	
	li a1,99
	slli a1,a1,16
	addi a1,a1,251
	jal SimplePrint
	
	li a1,195
	slli a1,a1,16
	addi a1,a1,43
	jal SimplePrint
	
	li a1,179
	slli a1,a1,16
	addi a1,a1,251
	jal SimplePrint
	
	li a1,211
	slli a1,a1,16
	addi a1,a1,123
	jal SimplePrint
	
	li a1,211
	slli a1,a1,16
	addi a1,a1,203
	jal SimplePrint
	
	la a0,mediumStarTitle
	
	li a1,98
	slli a1,a1,16
	addi a1,a1,89
	jal SimplePrint
	
	li a1,98
	slli a1,a1,16
	addi a1,a1,208
	jal SimplePrint
	
	la a0,kirbysTitle
	li a1,52
	slli a1,a1,16
	addi a1,a1,104
	jal SimplePrint
	
	la a0,adventureTitle
	li a1,127
	slli a1,a1,16
	addi a1,a1,99
	jal SimplePrint
	
	lw t0,FrameCount
	andi t0,t0,255
	la a0,kirbyTitle0
	li t1,208
	bgt t0,t1,GotKirbyTitle
	la a0,kirbyTitle2
	li t1,200
	bgt t0,t1,GotKirbyTitle
	la a0,kirbyTitle0
	li t1,196
	bgt t0,t1,GotKirbyTitle
	la a0,kirbyTitle2
	li t1,192
	bgt t0,t1,GotKirbyTitle
	la a0,kirbyTitle0
	li t1,188
	bgt t0,t1,GotKirbyTitle
	la a0,kirbyTitle2
	li t1,184
	bgt t0,t1,GotKirbyTitle
	la a0,kirbyTitle0
	li t1,76
	bgt t0,t1,GotKirbyTitle
	la a0,kirbyTitle1
	li t1,72
	bgt t0,t1,GotKirbyTitle
	la a0,kirbyTitle0
	li t1,68
	bgt t0,t1,GotKirbyTitle
	la a0,kirbyTitle1
	li t1,64
	bgt t0,t1,GotKirbyTitle
	la a0,kirbyTitle0
GotKirbyTitle:
	
	li a1,92
	slli a1,a1,16
	addi a1,a1,128
	jal SimplePrint
	
	#---------------------------
	
	la a0,letterJ
	li a1,188
	slli a1,a1,16
	addi a1,a1,138
	jal SimplePrint
	
	la a0,letterO
	li a1,188
	slli a1,a1,16
	addi a1,a1,147
	jal SimplePrint
	
	la a0,letterG
	li a1,188
	slli a1,a1,16
	addi a1,a1,156
	jal SimplePrint
	
	la a0,letterA
	li a1,188
	slli a1,a1,16
	addi a1,a1,165
	jal SimplePrint
	
	la a0,letterR
	li a1,188
	slli a1,a1,16
	addi a1,a1,174
	jal SimplePrint
	
	#-----------------------------
	
	li t0,184	
	slli a1,t0,16
	addi a1,a1,120
	li a3,1
	
	lw t0,FrameCount
	andi t0,t0,31
	li t1,8
	la a0,star0
	blt t0,t1,GotTitleStar
	li t1,16
	la a0,star1
	blt t0,t1,GotTitleStar
	li t1,24
	la a0,star2
	blt t0,t1,GotTitleStar
	la a0,star3
GotTitleStar:
	jal SimplePrint
	
	lw ra,0(sp)
	addi sp,sp,4
	
	ret
	
DrawEnding:
	addi sp,sp,-4
	sw ra,0(sp)

	li a0,0xff
	li a1,0
	li a2,0
	li a3,320
	li a4,240
	li a5,1
	jal FillPrint
	
	#-------------------------------------------------------
	
	la a0,littleStar
	
	li a1,8
	slli a1,a1,16
	addi a1,a1,102
	jal SimplePrint
	
	li a1,13
	slli a1,a1,16
	addi a1,a1,284
	jal SimplePrint
	
	li a1,51
	slli a1,a1,16
	addi a1,a1,19
	jal SimplePrint
	
	li a1,67
	slli a1,a1,16
	addi a1,a1,243
	jal SimplePrint
	
	li a1,105
	slli a1,a1,16
	addi a1,a1,293
	jal SimplePrint
	
	li a1,122
	slli a1,a1,16
	addi a1,a1,72
	jal SimplePrint
	
	li a1,180
	slli a1,a1,16
	addi a1,a1,42
	jal SimplePrint
	
	li a1,182
	slli a1,a1,16
	addi a1,a1,217
	jal SimplePrint
	
	li a1,203
	slli a1,a1,16
	addi a1,a1,103
	jal SimplePrint
	
	li a1,207
	slli a1,a1,16
	addi a1,a1,286
	jal SimplePrint
	
	#-------------------------------------------------------
	
	la a0,star0
	
	li a1,121
	slli a1,a1,16
	addi a1,a1,21
	jal SimplePrint
	
	li a1,137
	slli a1,a1,16
	addi a1,a1,256
	jal SimplePrint
	
	la a0,star4
	
	li a1,20
	slli a1,a1,16
	addi a1,a1,217
	jal SimplePrint
	
	li a1,55
	slli a1,a1,16
	addi a1,a1,67
	jal SimplePrint
	
	li a1,213
	slli a1,a1,16
	addi a1,a1,157
	jal SimplePrint
	
	#-------------------------------------------------------
	
	la a0,letterO
	li a1,80
	slli a1,a1,16
	addi a1,a1,125
	jal SimplePrint
	
	la a0,letterB
	li a1,80
	slli a1,a1,16
	addi a1,a1,134
	jal SimplePrint
	
	la a0,letterR
	li a1,80
	slli a1,a1,16
	addi a1,a1,143
	jal SimplePrint
	
	la a0,letterI
	li a1,80
	slli a1,a1,16
	addi a1,a1,152
	jal SimplePrint
	
	la a0,letterG
	li a1,80
	slli a1,a1,16
	addi a1,a1,161
	jal SimplePrint
	
	la a0,letterA
	li a1,80
	slli a1,a1,16
	addi a1,a1,170
	jal SimplePrint
	
	la a0,letterD
	li a1,80
	slli a1,a1,16
	addi a1,a1,179
	jal SimplePrint
	
	la a0,letterO
	li a1,80
	slli a1,a1,16
	addi a1,a1,188
	jal SimplePrint
	
	
	la a0,letterP
	li a1,96
	slli a1,a1,16
	addi a1,a1,119
	jal SimplePrint
	
	la a0,letterO
	li a1,96
	slli a1,a1,16
	addi a1,a1,128
	jal SimplePrint
	
	la a0,letterR
	li a1,96
	slli a1,a1,16
	addi a1,a1,137
	jal SimplePrint
	
	la a0,letterJ
	li a1,96
	slli a1,a1,16
	addi a1,a1,154
	jal SimplePrint
	
	la a0,letterO
	li a1,96
	slli a1,a1,16
	addi a1,a1,163
	jal SimplePrint
	
	la a0,letterG
	li a1,96
	slli a1,a1,16
	addi a1,a1,172
	jal SimplePrint
	
	la a0,letterA
	li a1,96
	slli a1,a1,16
	addi a1,a1,181
	jal SimplePrint
	
	la a0,letterR
	li a1,96
	slli a1,a1,16
	addi a1,a1,190
	jal SimplePrint
	
	mv a0,zero
	li a1,200
	li a2,96
	li a3,2
	li a4,5
	mv a5,zero
	jal FillPrint
	
	mv a0,zero
	li a1,200
	li a2,102
	li a3,2
	li a4,2
	mv a5,zero
	jal FillPrint
	
	la a0,letterS
	li a1,124
	slli a1,a1,16
	addi a1,a1,103
	jal SimplePrint
	
	la a0,letterC
	li a1,124
	slli a1,a1,16
	addi a1,a1,112
	jal SimplePrint
	
	la a0,letterO
	li a1,124
	slli a1,a1,16
	addi a1,a1,121
	jal SimplePrint
	
	la a0,letterR
	li a1,124
	slli a1,a1,16
	addi a1,a1,130
	jal SimplePrint
	
	la a0,letterE
	li a1,124
	slli a1,a1,16
	addi a1,a1,139
	jal SimplePrint
	
	mv a0,zero
	li a1,150
	li a2,125
	li a3,2
	li a4,2
	mv a5,zero
	jal FillPrint
	
	mv a0,zero
	li a1,150
	li a2,129
	li a3,2
	li a4,2
	mv a5,zero
	jal FillPrint
	
	la a0,letterV
	li a1,152
	slli a1,a1,16
	addi a1,a1,133
	jal SimplePrint
	
	la a0,letterO
	li a1,152
	slli a1,a1,16
	addi a1,a1,142
	jal SimplePrint
	
	la a0,letterL
	li a1,152
	slli a1,a1,16
	addi a1,a1,151
	jal SimplePrint
	
	la a0,letterT
	li a1,152
	slli a1,a1,16
	addi a1,a1,160
	jal SimplePrint
	
	la a0,letterA
	li a1,152
	slli a1,a1,16
	addi a1,a1,169
	jal SimplePrint
	
	la a0,letterR
	li a1,152
	slli a1,a1,16
	addi a1,a1,178
	jal SimplePrint
	
	#----------------------------
	lw s0,Score
	
	li s1,200 # PosX inicial
	li s2,124 # PosY
	
	mv s3,zero # contador de casas do numero
	li s4,scoreLen
	
LoopScoreNumEnd:	
	beq s3,s4,EndShowScore
	
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
	
	addi s1,s1,-9
	addi s3,s3,1
	
	j LoopScoreNumEnd
EndShowScore:
	#----------------------------
		
	lh s0,PlayerPosX
	lh s1,PlayerPosY
	
	lw s2,GameAnimTimer
	
	andi t1,s2,127
	beqz t1,ByeGoesUp
	andi t1,s2,63
	bnez t1,GotByePosY
	addi s1,s1,1
	j GotByePosY
ByeGoesUp:
	addi s1,s1,-1
GotByePosY:
	sh s1,PlayerPosY,t0
	
	andi t0,s2,1023
	andi t2,s2,15
	bnez t2,GotByePosX
	
	li t1,512
	bge t0,t1,ByeGoingLeft
	# indo para a direita:
	addi s0,s0,1
	j GotByePosX
ByeGoingLeft:
	addi s0,s0,-1
GotByePosX:
	sh s0,PlayerPosX,t0
	
	lw a1,PlayerPosX
	
	andi t0,s2,31
	la a0,kirbyBye0
	li t1,16
	blt t0,t1,GotByeSprt
	la a0,kirbyBye1
GotByeSprt:
	jal SimplePrint
	
	li t0,148	
	slli a1,t0,16
	addi a1,a1,112
	li a3,1
	
	lw t0,FrameCount
	andi t0,t0,31
	li t1,8
	la a0,star0
	blt t0,t1,GotEndingStar
	li t1,16
	la a0,star1
	blt t0,t1,GotEndingStar
	li t1,24
	la a0,star2
	blt t0,t1,GotEndingStar
	la a0,star3
GotEndingStar:
	jal SimplePrint
	
	lw t0,GameAnimTimer
	addi t0,t0,1
	sw t0,GameAnimTimer,t1
	
	lw ra,0(sp)
	addi sp,sp,4
	
	ret
	
