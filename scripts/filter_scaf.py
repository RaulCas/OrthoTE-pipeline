
infile=open('summary_hits.txt', 'r')

pos=[]

# iterate over each line 
for line in infile.readlines():
	try:
		ltrname=str(line.split('\t')[0])
		f1_scaf=str(line.split('\t')[1])
		f1_start=int(line.split('\t')[2])
		f1_end=int(line.split('\t')[3])
		f2_scaf=str(line.split('\t')[4])
		f2_start=int(line.split('\t')[5])
		f2_end=int(line.split('\t')[6])
		# check that both flanks match the same scaffold
		if f1_scaf == f2_scaf:
			pos.append(f1_start)
			pos.append(f1_end)
			pos.append(f2_start)
			pos.append(f2_end)	
			pos.sort()
			length=pos[2]-pos[1]
			# Filter hits that are too far
			#if (pos[4]-pos[1]) < 25000:
			print ltrname+'\t'+f1_scaf+'\t'+str(pos[0])+'\t'+str(pos[1])+'\t'+str(pos[2])+'\t'+str(pos[3])+'\t'+'Length='+'\t'+str(length)
			del pos[:]				
	except:
		pass


