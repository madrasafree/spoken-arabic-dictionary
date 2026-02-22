import urllib.request
import urllib.parse
from http.cookiejar import CookieJar

url = "http://localhost:8081/login.asp"
data = urllib.parse.urlencode(
    {"username": "admin", "password": "admin", "Submit1": "יאללה"}
).encode("utf-8")

cookie_jar = CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cookie_jar))

try:
    response = opener.open(url, data=data)
    content = response.read().decode("utf-8", errors="ignore")

    # After POST, it usually redirects to users.landingPage.asp.
    # Let's check where it ended up
    print("Redirected URL:", response.url)

    # Check for login success or failure message in cookies or content
    print("COOKIES:")
    for cookie in cookie_jar:
        print(cookie.name, cookie.value)

    if "טעות בשם המשתמש" in content:
        print("RESULT: Invalid login.")
    elif "מתבצעת כרגע עבודה" in content:
        print("RESULT: Maintenance mode.")
    else:
        print("RESULT: Login successful or handled (check url).")

except Exception as e:
    print(f"Error accessing ASP: {e}")
