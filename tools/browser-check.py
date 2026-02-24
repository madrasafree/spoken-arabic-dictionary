"""
browser-check.py — Playwright browser tests for milon.madrasafree.com

Usage:
    python tools/browser-check.py              # test production (headless)
    python tools/browser-check.py --local      # test localhost:8081
    python tools/browser-check.py --headed     # show browser window
    python tools/browser-check.py --screenshot # save screenshots to tools/screenshots/

Setup (once):
    pip install playwright
    playwright install chromium

What it checks:
  - Pages load without IIS error screen
  - No "Server Error" text in the page (IIS default error indicator)
  - Key elements are present (nav bar, page title area)
  - Custom 404 page is served (not IIS default error)
  - /docs/ returns 404 (blocked)
"""

import sys
import argparse
from pathlib import Path
from playwright.sync_api import sync_playwright, Page

PROD_BASE = "https://milon.madrasafree.com"
LOCAL_BASE = "http://localhost:8081"

IIS_ERROR_INDICATORS = [
    "Server Error",
    "HTTP Error",
    "IIS",
    "500 - Internal server error",
    "403 - Forbidden",
    "Runtime Error",
]

PAGES_TO_CHECK = [
    ("/", "default.asp or home", {"nav": True}),
    ("/about.asp", "About page", {"nav": True, "text": "מילון ערבית מדוברת"}),
    ("/labels.asp", "Labels tag cloud", {"nav": True, "text": "אינדקס נושאים"}),
    ("/word.asp?id=1", "Word page", {"nav": True}),
]

PAGES_404 = [
    ("/1.asp", "Non-existent → custom 404"),
    ("/docs/", "docs/ blocked → 404"),
]


def has_iis_error(page: Page) -> str | None:
    content = page.content()
    for indicator in IIS_ERROR_INDICATORS:
        if indicator in content:
            return indicator
    return None


def check_page(
    page: Page,
    base: str,
    path: str,
    description: str,
    expectations: dict,
    screenshot_dir: Path | None,
) -> bool:
    url = base + path
    passed = True
    issues = []

    try:
        response = page.goto(url, timeout=15000, wait_until="domcontentloaded")
        status = response.status if response else "?"

        iis_err = has_iis_error(page)
        if iis_err:
            issues.append(f"IIS error indicator found: '{iis_err}'")
            passed = False

        if expectations.get("nav"):
            # Check nav bar is present (inc/top.asp renders #bar-search-container)
            nav = page.locator("#bar-search-container, #siteTitle").first
            if nav.count() == 0:
                issues.append("Nav bar element not found")
                passed = False

        if "text" in expectations:
            if expectations["text"] not in page.content():
                issues.append(f"Expected text not found: {repr(expectations['text'])}")
                passed = False

        icon = "✓" if passed else "✗"
        print(f"  {icon}  {description}  [{status}]  {url}")
        for issue in issues:
            print(f"       ⚠ {issue}")

        if screenshot_dir:
            fname = (
                path.strip("/").replace("/", "_").replace("?", "_").replace("=", "")
                or "home"
            )
            page.screenshot(path=screenshot_dir / f"{fname}.png", full_page=True)

    except Exception as e:
        print(f"  ✗  {description}  {url}")
        print(f"       ERROR: {e}")
        passed = False

    return passed


def check_404_page(
    page: Page, base: str, path: str, description: str, screenshot_dir: Path | None
) -> bool:
    url = base + path
    try:
        response = page.goto(url, timeout=15000, wait_until="domcontentloaded")
        status = response.status if response else "?"

        content = page.content()
        # IIS default 404 shows "File or directory not found" — that means custom page is NOT serving
        is_iis_default = "File or directory not found" in content or (
            "404" in content and "Server Error" in content
        )
        is_custom = "לא נמצא" in content  # Hebrew text from our custom not_found.html

        if status == 404 and not is_iis_default:
            icon = "✓"
            note = "custom 404" if is_custom else "404 (verify content)"
            passed = True
        elif status == 404 and is_iis_default:
            icon = "✗"
            note = "IIS default 404 — custom error page not serving"
            passed = False
        else:
            icon = "✗"
            note = f"unexpected status {status}"
            passed = False

        print(f"  {icon}  {description}  [{status}]  {url}  — {note}")

        if screenshot_dir:
            fname = "404_" + path.strip("/").replace("/", "_") or "404_root"
            page.screenshot(path=screenshot_dir / f"{fname}.png", full_page=True)

        return passed
    except Exception as e:
        print(f"  ✗  {description}  {url}")
        print(f"       ERROR: {e}")
        return False


def main():
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

    print(f"\nBrowser check: {base}\n{'─' * 50}")
    all_passed = True

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=not args.headed)
        page = browser.new_page()

        print("\n  Pages:")
        for path, description, expectations in PAGES_TO_CHECK:
            ok = check_page(page, base, path, description, expectations, screenshot_dir)
            if not ok:
                all_passed = False

        print("\n  Error pages:")
        for path, description in PAGES_404:
            ok = check_404_page(page, base, path, description, screenshot_dir)
            if not ok:
                all_passed = False

        browser.close()

    print(f"\n{'─' * 50}")
    print(f"  {'ALL PASSED' if all_passed else 'SOME CHECKS FAILED'}\n")
    sys.exit(0 if all_passed else 1)


if __name__ == "__main__":
    main()
