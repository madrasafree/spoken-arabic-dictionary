"""
check-http.py — HTTP status checker for milon.madrasafree.com

Usage:
    python tools/check-http.py              # check production
    python tools/check-http.py --local      # check localhost:8081

Verifies:
  - Key pages return 200
  - Non-existent pages return 404 with the custom error page
  - /docs/ is blocked (404 via hiddenSegments)
"""

import sys
import argparse
import requests

PROD_BASE  = "https://milon.madrasafree.com"
LOCAL_BASE = "http://localhost:8081"

# (path, expected_status, description, optional_body_snippet)
CHECKS = [
    ("/",              200, "Home page"),
    ("/about.asp",     200, "About page"),
    ("/labels.asp",    200, "Labels tag cloud"),
    ("/word.asp?id=1", 200, "Word page (id=1)"),
    ("/1.asp",         404, "Non-existent page → custom 404"),
    ("/does-not-exist.asp", 404, "Non-existent page → custom 404"),
    ("/docs/",         404, "docs/ blocked by hiddenSegments"),
    ("/docs/file-inventory.csv", 404, "docs/file-inventory.csv blocked"),
]

CUSTOM_404_SNIPPET = "לא נמצא"   # Hebrew text in the custom not_found.html


def run(base: str) -> bool:
    print(f"\nChecking: {base}\n{'─' * 50}")
    all_passed = True

    for path, expected_status, description, *rest in CHECKS:
        url = base + path
        body_snippet = rest[0] if rest else None
        try:
            r = requests.get(url, timeout=10, allow_redirects=True)
            status_ok = r.status_code == expected_status
            body_ok = True
            if body_snippet:
                body_ok = body_snippet in r.text

            icon = "✓" if (status_ok and body_ok) else "✗"
            status_label = f"{r.status_code}" + (f" (expected {expected_status})" if not status_ok else "")
            print(f"  {icon}  {description}")
            print(f"       {url}  →  {status_label}")

            if not status_ok or not body_ok:
                all_passed = False
                if not body_ok:
                    print(f"       ⚠ body snippet not found: {repr(body_snippet)}")
        except requests.exceptions.ConnectionError:
            print(f"  ✗  {description}")
            print(f"       {url}  →  CONNECTION ERROR")
            all_passed = False
        except Exception as e:
            print(f"  ✗  {description}")
            print(f"       {url}  →  ERROR: {e}")
            all_passed = False

    print(f"\n{'─' * 50}")
    print(f"  {'ALL PASSED' if all_passed else 'SOME CHECKS FAILED'}\n")
    return all_passed


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--local", action="store_true", help="Test localhost:8081 instead of production")
    args = parser.parse_args()

    base = LOCAL_BASE if args.local else PROD_BASE
    success = run(base)
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
