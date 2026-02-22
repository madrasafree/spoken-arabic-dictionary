import urllib.request

urls = [
    "http://localhost:8081/",
    "http://localhost:8081/word.asp?id=9552",
    "http://localhost:8081/sentences.asp",
    "http://localhost:8081/guide.asp",
    "http://localhost:8081/lists.all.asp",
]
for u in urls:
    try:
        print(f"{u}: {urllib.request.urlopen(u).getcode()}")
    except Exception as e:
        print(f"{u}: Error {e}")
