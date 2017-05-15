#!/bin/bash
#
# (c) 1999 - Rui Amaral
# Rui.Amaral@inesc.pt
#
# HISTORY
# 25.05.1999 Creation

echo " Codificando o sinal de fala ..."


#===============================================================
#
# Procedimento de gravação de um sinal de fala
#
#===============================================================

#mkdir temp

#-------------------------------------------- 
# PROG: WAVES
# SYS : LINUX
# Proc: Retira o header colocado pelo Waves.
#
# bhd resources/file2rec.sd  resources/file2rec.raw

#--------------------------------------------
# PROG: WAVESURFER
# SYS : LINUX
# Proc: Codificar WAV para RAW, usando HCopy (HTK Tool).
#
# s16play -f8000 resources/file2rec.wav
../htk/HTKTools/HCopy -F WAVE  -O NOHEAD ./temp/file2rec.wav  ./temp/file2rec.raw

#
# Codificar os sinais de fala
#
../htk/HTKTools/HCopy -T 1 -C toolconfs/hcopy.conf ./temp/file2rec.raw  ./temp/file2rec.mfc

echo " Reconhecendo a palavra ..."
#
# Efectua o reconhecimento usando os modelos obtidos com 5 reestimações 
#
HMM_SRC=./hmms/5

../htk/HTKTools/HVite -T 1 -H $HMM_SRC/macros -H $HMM_SRC/hmmdefs -l '*' -i transcricoes_HIP -w toolconfs/wordnet -p 0.0 -s 5.0 lists/dicpronuncia lists/lista_palavras temp/file2rec.mfc 


