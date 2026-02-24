"""
browser-check.py - Playwright browser tests for milon.madrasafree.com

Usage:
    python tools/browser-check.py              # test production (headless)
    python tools/browser-check.py --local      # test localhost:8081
    python tools/browser-check.py --headed     # show browser window
    python tools/browser-check.py --screenshot # save screenshots to tools/screenshots/

Setup (once):
    pip install -r tools/requirements.txt
    playwright install chromium
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from playwright.sync_api import Page, sync_playwright

PROD_BASE = "https://milon.madrasafree.com"
LOCAL_BASE = "http://localhost:8081"

IIS_ERROR_INDICATORS = [
    "Server Error",
    "HTTP Error",
    "500 - Internal server error",
    "403 - Forbidden",
    "Runtime Error",
]

PUBLIC_PAGES = [
    # path, description, expected_substring
    ("/", "Home page", None),
    ("/about.asp", "About page", "מילון ערבית מדוברת"),
    ("/labels.asp", "Labels page", "אינדקס נושאים"),
    ("/word.asp?id=1", "Word page", None),
]

ERROR_PAGES = [
    ("/1.asp", "Non-existent page (custom 404 expected)"),
    ("/docs/", "docs/ blocked (404 expected)"),
]

ADMIN_PAGES = [
    ("/admin/", "Admin folder route"),
    ("/admin.asp", "Legacy admin route"),
]


def _ok_icon(ok: bool) -> str:
    return "[OK]" if ok else "[FAIL]"


def has_iis_error(page: Page) -> str | None:
    content = page.content()
    for indicator in IIS_ERROR_INDICATORS:
        if indicator in content:
            return indicator
    return None


def screenshot_name(path: str, prefix: str = "") -> str:
    normalized = path.strip("/").replace("/", "_").replace("?", "_").replace("=", "")
    name = normalized or "home"
    return f"{prefix}{name}.png"


def check_public_page(
    page: Page,
    base: str,
    path: str,
    description: str,
    expected_text: str | None,
    screenshot_dir: Path | None,
) -> bool:
    url = base + path
    passed = True
    issues: list[str] = []

    try:
        response = page.goto(url, timeout=20000, wait_until="domcontentloaded")
        status = response.status if response else -1

        if status != 200:
            passed = False
            issues.append(f"Expected status 200, got {status}")

        iis_err = has_iis_error(page)
        if iis_err:
            passed = False
            issues.append(f"IIS error indicator found: {iis_err}")

        nav = page.locator("#bar-search-container, #siteTitle").first
        if nav.count() == 0:
            passed = False
            issues.append("Nav bar element not found")

        if expected_text and expected_text not in page.content():
            passed = False
            issues.append("Expected page marker text not found")

        print(f"  {_ok_icon(passed)} {description} [{status}] {url}")
        for issue in issues:
            print(f"       - {issue}")

        if screenshot_dir:
            page.screenshot(path=screenshot_dir / screenshot_name(path), full_page=True)
    except Exception as err:  # noqa: BLE001
        print(f"  [FAIL] {description} {url}")
        print(f"       - ERROR: {err}")
        passed = False

    return passed


def check_error_page(
    page: Page, base: str, path: str, description: str, screenshot_dir: Path | None
) -> bool:
    url = base + path
    try:
        response = page.goto(url, timeout=20000, wait_until="domcontentloaded")
        status = response.status if response else -1
        content = page.content()

        is_iis_default_404 = "File or directory not found" in content or (
            "404" in content and "Server Error" in content
        )
        passed = status == 404 and not is_iis_default_404

        detail = "custom/non-IIS 404" if passed else "unexpected 404 response"
        print(f"  {_ok_icon(passed)} {description} [{status}] {url} - {detail}")

        if screenshot_dir:
            page.screenshot(
                path=screenshot_dir / screenshot_name(path, prefix="404_"),
                full_page=True,
            )

        return passed
    except Exception as err:  # noqa: BLE001
        print(f"  [FAIL] {description} {url}")
        print(f"       - ERROR: {err}")
        return False


def check_admin_route(
    page: Page, base: str, path: str, description: str, screenshot_dir: Path | None
) -> bool:
    url = base + path
    passed = True
    issues: list[str] = []

    try:
        response = page.goto(url, timeout=20000, wait_until="domcontentloaded")
        status = response.status if response else -1
        final_url = page.url.lower()
        content = page.content().lower()

        if status == 404:
            passed = False
            issues.append("Admin route returned 404")

        iis_err = has_iis_error(page)
        if iis_err:
            passed = False
            issues.append(f"IIS error indicator found: {iis_err}")

        if "login.asp" not in final_url and "submit1" not in content:
            # Anonymous browser should land on login for protected admin pages.
            passed = False
            issues.append("Did not land on a login page for protected admin route")

        print(f"  {_ok_icon(passed)} {description} [{status}] {url} -> {page.url}")
        for issue in issues:
            print(f"       - {issue}")

        if screenshot_dir:
            page.screenshot(
                path=screenshot_dir / screenshot_name(path, prefix="admin_"),
                full_page=True,
            )
    except Exception as err:  # noqa: BLE001
        print(f"  [FAIL] {description} {url}")
        print(f"       - ERROR: {err}")
        passed = False

    return passed


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--local", action="store_true", help="Test localhost:8081")
    parser.add_argument("--headed", action="store_true", help="Show browser window")
    parser.add_argument(
        "--screenshot",
        action="store_true",
        help="Save screenshots to tools/screenshots/",
    )
    args = parser.parse_args()

    base = LOCAL_BASE if args.local else PROD_BASE
    screenshot_dir = None
    if args.screenshot:
        screenshot_dir = Path(__file__).parent / "screenshots"
        screenshot_dir.mkdir(exist_ok=True)

    print(f"\nBrowser check: {base}\n" + ("-" * 60))
    all_passed = True

    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(headless=not args.headed)
        page = browser.new_page()

        print("\nPublic pages:")
        for path, description, expected_text in PUBLIC_PAGES:
            if not check_public_page(
                page, base, path, description, expected_text, screenshot_dir
            ):
                all_passed = False

        print("\nError pages:")
        for path, description in ERROR_PAGES:
            if not check_error_page(page, base, path, description, screenshot_dir):
                all_passed = False

        print("\nAdmin routes:")
        for path, description in ADMIN_PAGES:
            if not check_admin_route(page, base, path, description, screenshot_dir):
                all_passed = False

        browser.close()

    print("\n" + ("-" * 60))
    print("ALL PASSED\n" if all_passed else "SOME CHECKS FAILED\n")
    sys.exit(0 if all_passed else 1)


if __name__ == "__main__":
    main()
