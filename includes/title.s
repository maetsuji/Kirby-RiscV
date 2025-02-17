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
	
	la a0,kirbyTitle0
	
	li a1,92
	slli a1,a1,16
	addi a1,a1,128
	jal SimplePrint
	
	lw ra,0(sp)
	addi sp,sp,4
	
	ret
	