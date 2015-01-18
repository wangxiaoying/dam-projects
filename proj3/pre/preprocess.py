import os
import re
import gl

def handleSingleUser(one_user, user_id):
	one_user = sorted(one_user, key=lambda item: int(item[3]))
	count = len(one_user)
	# print(count)
	gl.train_data.append(one_user[0:round(count*0.9)])
			
	if user_id == gl.aim_userid:
		gl.test_data = one_user[round(count*0.9):]

def readIn():
	print('start read in')

	inputFile = open('ratings.dat', 'r')
	# inputFile = open('test.dat', 'r')
	
	one_user = []
	user_id = 1
	line = inputFile.readline()

	while line != "":
		line = re.sub('\n', '', line)
		temp = re.split('::', line)
		
		if str(user_id) == temp[0]:
			one_user.append(temp)
			line = inputFile.readline()
		else:
			handleSingleUser(one_user, user_id)
			one_user = []
			user_id += 1
	
	handleSingleUser(one_user, user_id)

	inputFile.close()

##############################################################

def outputTrain():
	print('start output train data')
	outputFileTrain = open('train.csv', 'w')

	for i in range(0, gl.count_user):
		one_user = sorted(gl.train_data[i], key=lambda item: int(item[1]))
		# print(one_user)
		k = 0
		s = ''
		for j in range(1, gl.count_movie+1):
			
			if k < len(one_user) and str(j) == one_user[k][1]:
				s += one_user[k][2]+','
				k += 1
			else:
				s += 'NA,'
		s = s[0:len(s)-1] + '\n'
		outputFileTrain.write(s)
	
	outputFileTrain.close()

def outputTest():
	print('start output test data')
	outputFileTest = open('test.csv', 'w')
	for t in gl.test_data:
		outputFileTest.write('%d,%d,%d,%d\n' % (int(t[0]), int(t[1]), int(t[2]), int(t[3])))

	outputFileTest.close()

##############################################################

def main():
	
	readIn()
	outputTrain()
	outputTest()

if __name__ == '__main__':
    main()