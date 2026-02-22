import urllib.request
import urllib.parse
import http.cookiejar

pages = [
    ("Homepage", "http://localhost:8081/"),
    ("Stats", "http://localhost:8081/stats.asp"),
    ("About", "http://localhost:8081/about.asp"),
    ("Guide", "http://localhost:8081/guide.asp"),
]

# Test public pages
for name, url in pages:
    try:
        req = urllib.request.urlopen(url)
        code = req.getcode()
        html = req.read().decode("utf-8", errors="replace")
        has_error = "500" in html and "Internal" in html
        print(
            f"{name}: {code} {'ERROR DETECTED!' if has_error else 'OK'} (len={len(html)})"
        )
    except Exception as e:
        print(f"{name}: FAILED - {e}")

# Test login and authenticated pages
cj = http.cookiejar.CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))

# Login
login_data = urllib.parse.urlencode({"username": "admin", "password": "admin"}).encode()
try:
    resp = opener.open("http://localhost:8081/login.asp", login_data)
    print(f"Login: {resp.getcode()} OK (url={resp.url})")
except Exception as e:
    print(f"Login: FAILED - {e}")

auth_pages = [
    ("Landing Page", "http://localhost:8081/users.landingPage.asp"),
    ("Lists All", "http://localhost:8081/lists.all.asp"),
    ("Admin", "http://localhost:8081/admin.asp"),
]

for name, url in auth_pages:
    try:
        resp = opener.open(url)
        code = resp.getcode()
        html = resp.read().decode("utf-8", errors="replace")
        has_error = "500" in html and "Internal" in html
        print(
            f"{name}: {code} {'ERROR DETECTED!' if has_error else 'OK'} (len={len(html)})"
        )
    except Exception as e:
        print(f"{name}: FAILED - {e}")

print("\nDone!")
