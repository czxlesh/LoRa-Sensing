import pymysql
import sys



try:
	sys.argv[1]
except :
	print('no enough input!')
	exit(-1)
conn=pymysql.connect(host='127.0.0.1',user='root',passwd='',db='realtime',port=3306,charset='utf8')
cur=conn.cursor()

inData = sys.argv[1].replace('"', '\\"')

SQL = 'INSERT INTO `breath` VALUES( NULL,\"'+inData+'\" )'

# print(SQL)
cur.execute(SQL)
conn.commit()
cur.close()
conn.close()
