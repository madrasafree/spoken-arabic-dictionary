import urllib.request
import urllib.error

url = "http://localhost:8081/team/mediaControl.asp"

try:
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req) as response:
        html = response.read().decode("utf-8", errors="ignore")
        with open("team_control_out.html", "w", encoding="utf-8") as f:
            f.write(html)
        print("Done")
except Exception as e:
    print(e)
