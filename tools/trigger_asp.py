import urllib.request

try:
    with urllib.request.urlopen("http://localhost:8081/create_users.asp") as f:
        print(f.read().decode("utf-8"))
except Exception as e:
    print(f"Error accessing ASP: {e}")
