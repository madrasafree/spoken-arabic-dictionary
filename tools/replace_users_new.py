import win32com.client

try:
    cat = win32com.client.Dispatch("ADOX.Catalog")
    cat.ActiveConnection = r"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=c:\Users\yaniv\dev\milon\spoken-arabic-dictionary\App_Data\arabicUsers_new.mdb"

    try:
        cat.Tables.Delete("users_orig")
    except:
        pass

    cat.Tables("users").Name = "users_orig"
    cat.Tables("users_demo").Name = "users"
    print("SUCCESS")
except Exception as e:
    print(f"ERROR: {e}")
