
# Using a list of unique LTR names, find these elements in the blast output and print a name + positions of left and rigth flank hits

LTRnames=open('LTR_unique_names.txt', 'r')
blast_out=open('blast.out', 'r')
loop=blast_out.readlines()

lista=[]
for item in LTRnames.readlines():
	retro=str(item.strip())
	for elto in loop:
		elto=elto.strip()
		retro_blast=str(elto.split('_')[0])+'_'+str(elto.split('_')[1])
		full_name=str(elto.split('\t')[0])
		scaf=str(elto.split('\t')[1])
		sstart=str(elto.split('\t')[8])
		send=str(elto.split('\t')[9])
		if retro==retro_blast:
			#print full_name+'  '+scaf
			if retro not in lista:
				lista.append(retro)
				lista.append(scaf)
				lista.append(sstart)
				lista.append(send)				
			else:
				lista.append(scaf)
				lista.append(sstart)
				lista.append(send)						
				print lista[0]+'\t'+lista[1]+'\t'+lista[2]+'\t'+lista[3]+'\t'+lista[4]+'\t'+lista[5]+'\t'+lista[6]
				del lista[:]



