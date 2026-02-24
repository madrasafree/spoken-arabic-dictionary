"""
check-http.py - HTTP status checker for milon.madrasafree.com

Usage:
    python tools/check-http.py              # check production
    python tools/check-http.py --local      # check localhost:8081

Verifies:
  - Key public pages return expected statuses
  - Non-existent pages return 404
  - /docs/ is blocked (404 via hiddenSegments)
  - Admin migration routes behave as expected:
      - Legacy root admin.* routes redirect to /admin/*
      - /admin/* routes require login for anonymous users
"""

from __future__ import annotations

import argparse
import sys
from typing import Iterable

import requests

PROD_BASE = "https://milon.madrasafree.com"
LOCAL_BASE = "http://localhost:8081"

REQUEST_HEADERS = {
    # Using a browser-like UA avoids false negatives from some Cloudflare setups.
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/123.0.0.0 Safari/537.36"
    ),
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
}

CORE_CHECKS = [
    # path, expected_status, description
    ("/", 200, "Home page"),
    ("/about.asp", 200, "About page"),
    ("/labels.asp", 200, "Labels page"),
    ("/word.asp?id=1", 200, "Word page (id=1)"),
    ("/1.asp", 404, "Non-existent page"),
    ("/does-not-exist.asp", 404, "Non-existent page"),
    ("/docs/", 404, "docs/ blocked by hiddenSegments"),
    ("/docs/file-inventory.csv", 404, "docs/file-inventory.csv blocked"),
]

ADMIN_CHECKS = [
    # path, expected_status, location_contains, description
    ("/admin.asp", 301, "admin/default.asp", "Legacy admin.asp redirects"),
    (
        "/admin.userControl.asp",
        301,
        "admin/userControl.asp",
        "Legacy admin.userControl.asp redirects",
    ),
    ("/admin/", 302, "/login.asp", "Admin folder requires login"),
    ("/admin/default.asp", 302, "/login.asp", "Admin default requires login"),
    (
        "/admin/userControl.asp",
        302,
        "/login.asp",
        "Admin userControl requires login",
    ),
]


def _ok_icon(ok: bool) -> str:
    return "[OK]" if ok else "[FAIL]"


def _status_matches(actual: int, expected: int | Iterable[int]) -> bool:
    if isinstance(expected, int):
        return actual == expected
    return actual in expected


def run(base: str) -> bool:
    print(f"\nChecking: {base}\n" + ("-" * 60))
    all_passed = True

    session = requests.Session()
    session.headers.update(REQUEST_HEADERS)

    print("\nPublic routes:")
    for path, expected_status, description in CORE_CHECKS:
        url = base + path
        try:
            response = session.get(url, timeout=15, allow_redirects=True)
            status_ok = _status_matches(response.status_code, expected_status)
            ok = status_ok
            print(
                f"  {_ok_icon(ok)} {description}\n"
                f"       {url} -> {response.status_code}"
                + (f" (expected {expected_status})" if not ok else "")
            )
            if not ok:
                all_passed = False
        except requests.exceptions.ConnectionError:
            print(f"  [FAIL] {description}\n       {url} -> CONNECTION ERROR")
            all_passed = False
        except Exception as err:  # noqa: BLE001
            print(f"  [FAIL] {description}\n       {url} -> ERROR: {err}")
            all_passed = False

    print("\nAdmin migration routes:")
    for path, expected_status, expected_location, description in ADMIN_CHECKS:
        url = base + path
        try:
            response = session.get(url, timeout=15, allow_redirects=False)
            actual_location = response.headers.get("Location", "")
            status_ok = _status_matches(response.status_code, expected_status)
            location_ok = expected_location in actual_location
            ok = status_ok and location_ok

            print(
                f"  {_ok_icon(ok)} {description}\n"
                f"       {url} -> {response.status_code}"
                f", Location: {actual_location or '(none)'}"
            )
            if not status_ok:
                print(
                    f"       Expected status {expected_status}, got {response.status_code}"
                )
            if not location_ok:
                print(f"       Expected Location to contain: {expected_location}")

            if not ok:
                all_passed = False
        except requests.exceptions.ConnectionError:
            print(f"  [FAIL] {description}\n       {url} -> CONNECTION ERROR")
            all_passed = False
        except Exception as err:  # noqa: BLE001
            print(f"  [FAIL] {description}\n       {url} -> ERROR: {err}")
            all_passed = False

    print("\n" + ("-" * 60))
    print("ALL PASSED\n" if all_passed else "SOME CHECKS FAILED\n")
    return all_passed


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--local", action="store_true", help="Test localhost:8081 instead of production"
    )
    args = parser.parse_args()

    base = LOCAL_BASE if args.local else PROD_BASE
    success = run(base)
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
