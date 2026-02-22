import urllib.request
import urllib.parse
from http.cookiejar import CookieJar

url_login = "http://localhost:8081/login.asp"
url_lists = "http://localhost:8081/lists.all.asp"
data = urllib.parse.urlencode(
    {"username": "admin", "password": "admin", "Submit1": "יאללה"}
).encode("utf-8")

cookie_jar = CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cookie_jar))

try:
    opener.open(url_login, data=data)
    response = opener.open(url_lists)
    content = response.read().decode("utf-8", errors="ignore")

    if "500 - Internal server error" in content:
        print("RESULT: 500 Error")
    else:
        print("RESULT: 200 OK. Length: ", len(content))
        with open("lists_out.html", "w", encoding="utf-8") as f:
            f.write(content)
except Exception as e:
    print(f"Error accessing ASP: {e}")
