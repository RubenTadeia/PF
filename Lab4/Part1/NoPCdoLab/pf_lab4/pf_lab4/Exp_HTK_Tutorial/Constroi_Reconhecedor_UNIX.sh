#!/bin/bash
#
# (c) 1999 - Rui Amaral
# Rui.Amaral@inesc.pt
#
# HISTORY
# 24.05.1999 Creation
# 25.05.1999 Revision 1

# PASSOS NECESSARIOS `A CONSTRUCÇA~O DE UM RECONHECEDOR DE PALAVRAS ISOLADAS DEPENDENTES DO ORADOR

echo "Codificar o sinal de fala (HCopy)? s/n"
read ans
if [ "$ans" = "s" ]; then
   #
   # Codificar o sinal de fala num conjunto de observacoes, compostas por vectores de parametros.
   #
   ../htk/HTKTools/HCopy -T 1 -C toolconfs/hcopy.conf -S lists/raws2code.scp

   #
   # Mostra os resultados da codificacao
   #
   ../htk/HTKTools/HList -o -h -t -e 0 -i 8 ./data/treino/cod/abr3.mfc
fi

echo "Converter todos os ficheiros de label num ficheiro MLF, transcricoes.mlf, (HLEd)? s/n"
read ans
if [ "$ans" = "s" ]; then
   #
   # Apos criar-se um ficheiro de label para cada ficheiro de fala, nomes iguais mas extens~oes diferentes,
   # vamos agora juntar tudo num so ficheiro de formato MLF.
   #
    ../htk/HTKTools/HLEd -l '*' -T 1 -i ./data/treino/transcricoes.mlf ./toolconfs/nada_faz.led ./data/treino/lab/*.lab 
	../htk/HTKTools/HLEd -l '*' -T 1 -i ./data/teste/transcricoes_REF.mlf ./toolconfs/nada_faz.led ./data/teste/lab/*.lab 
fi

echo "Construir modelos HMM para cada uma das palavras a reconhecer (HCompV)? s/n"
read ans
if [ "$ans" = "s" ]; then

   #==========================================================================================================
   # Construir modelos HMM para cada uma das palavras a reconhecer. Neste exemplo, todas as palavras terao um
   # modelo HMM de arquitectura semelhante. O modelo sera de 8 estados, esquerda-direita e sem misturas.
   # Desta forma, vai-se construir um modelo HMM com a referida arquitectura para depois reproduzir-se este 
   # modelo tantas vezes quantas as palavras a reconhecer.
   #==========================================================================================================

   #
   # Construir um Modelo HMM de 8 estados apartir de um ficheiro com a sua definicao
   # NOTA:  Este modelo (proto_hmm) tem media nula e variacia unitaria.
   #
   mkdir ./protos
   scripts/MakeProtoHMMSet toolconfs/HMM_param_def

   #
   # Actualizar os parametros media e variancia do anterior modelo HMM, com os valores obtidos apartir dos
   # ficheiros que pertencem ao conjunto de TREINO.transcricoes.mlf
   # (Nota: -m = actualizar tb a media, -f 0.01 = definir valor minimo de variancia que sera 0.001 x Variancia Global)
   #
   ../htk/HTKTools/HCompV -T 1  -f 0.01 -m -o proto_hmm_step2 -M ./protos/ -S lists/trainlist.scp ./protos/proto_hmm_step1

   # Adicionar `a macro a informacao de codificacao (header do proto).
   head -3 protos/proto_hmm_step2 > protos/macros
   cat protos/vFloors >> protos/macros

   #
   # Criar modelos HMM's para todas as palavras e junta as definicoes num so ficheiro. 
   #
   scripts/MakeHMMdef lists/lista_palavras protos/proto_hmm_step2 ./protos
fi


echo "Estimar os parametros estatisticos dos modelos (HERest)? s/n"
read ans
if [ "$ans" = "s" ]; then

   #
   # Estimar os modelos usando o metodo de Baum-Welch (efectuar 5 iteracoes).
   #
   iter=1
   niter=5

   while [ $iter -le $niter ]; do

      echo Iteracao: $iter
      mkdir -p hmms/$iter
      mkdir -p results/$iter

      # Na primeira iteracao vai buscar os modelos `a directoria /protos 
      if [ $iter -eq 1 ]; then
         HMM_SRC=protos
      else
         HMM_SRC=hmms/$[$iter-1]
      fi

      ../htk/HTKTools/HERest -T 1 -I data/treino/transcricoes.mlf -t 250.0 150.0 1000.0 -S lists/trainlist.scp -H $HMM_SRC/macros -H $HMM_SRC/hmmdefs -M hmms/$iter -s results/$iter/herest.stats lists/lista_palavras

      if [ $iter -eq 7 ]; then
         #
         # Incluir "skips" no modelo de silencio.
         #
         iter=$[$iter+1]
         mkdir hmms/$iter
         ../htk/HTKTools/HHEd -H ./$HMM_SRC/macros -H ./$HMM_SRC/hmmdefs -M ./hmms/$iter toolconfs/junta_trans_2_sil.hed lists/lista_palavras
      fi

      iter=$[$iter+1]
   done
fi

echo " Efectuar um teste de reconhecimento sobre o conjunto de TESTE e avaliar os resultados (HVite e HResults)? s/n"
read ans
if [ "$ans" = "s" ]; then

   #
   # Efectuar um teste de reconhecimento sobre o conjunto de TESTE 
   #
   mkdir rec
   HMM_SRC=hmms/$[niter-1]

   # Criar gramatica (sintaxe usada na descodificacao) 
   ../htk/HTKTools/HParse -A -D lists/gramatica toolconfs/wordnet

   ../htk/HTKTools/HVite -T 1 -H $HMM_SRC/macros -H $HMM_SRC/hmmdefs -S lists/testlist.scp -l '*' -i rec/transcricoes_HIP -w toolconfs/wordnet -p 0.0 -s 5.0  lists/dicpronuncia lists/lista_palavras

   #
   # Avaliar os resultados do reconhecimento
   #
   ../htk/HTKTools/HResults -p -e "???" sil -I data/teste/transcricoes_REF.mlf lists/dicpronuncia  rec/transcricoes_HIP
fi


