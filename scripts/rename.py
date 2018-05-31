
import sys

gff_in=open(sys.argv[1], 'r')
#gff_out=open('LTR_flanks_500bp_renamed.gff', 'w')

lista=[]
for line in gff_in.readlines():
	line=line.strip()
	name=str(line.split('\t')[2])
	if name not in lista:
		lista.append(name)
		name1=name+'_1'
		line=str(line.replace(name, name1))
		print line
	else:
		name2=name+'_2'
		line=str(line.replace(name, name2))
		print line
		del lista[:]
	
