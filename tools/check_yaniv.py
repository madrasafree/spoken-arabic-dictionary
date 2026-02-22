import pyodbc

conn = pyodbc.connect(
    r"Driver={Microsoft Access Driver (*.mdb)};DBQ=c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data\arabicUsers.mdb;"
)
cursor = conn.cursor()
cursor.execute("SELECT username, userPass FROM users WHERE username='yanivg'")
print(cursor.fetchall())
