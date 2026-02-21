<div align="center">
  <img src="https://github.com/madrasafree.png" alt="Madrasa Logo" width="150"/>

  # 📘 Spoken Arabic Dictionary 
  ### מילון ערבית מדוברת

  *A free, community-driven resource for Hebrew speakers learning Spoken Arabic.* <br>
  *פרויקט קהילתי טכנולוגי ללימוד השפה הערבית המדוברת עבור דוברי עברית.*
  
  [![Website](https://img.shields.io/badge/Website-milon.madrasafree.com-00a2e8?style=for-the-badge&logo=google-chrome)](https://milon.madrasafree.com/)
  [![License](https://img.shields.io/badge/License-Open_Source-4caf50?style=for-the-badge)](#)
</div>

<br>

Welcome to the **Spoken Arabic Dictionary** repository! This project powers the active dictionary at [milon.madrasafree.com](https://milon.madrasafree.com/), bridging languages and communities through collaborative learning.

---
The *Spoken Arabic Dictionary* project was founded in 2005 by Ronen Rothfarb and managed by him until 2022, when it was adopted by the non-profit organization **Madrasa**.

The dictionary is a community-driven content platform (similar to Wikipedia) where users can contribute words and expressions. To ensure high quality, contributions are reviewed by experienced moderators with a deep knowledge of both Hebrew and spoken Arabic.

## 🛠️ Technology Stack
This repository contains the legacy version of the dictionary, built with:
- **Language**: ASP Classic
- **Web Server**: IIS (Internet Information Services)
- **Database**: MS Access (`.mdb`)

*(Note: MS Access software is only required if you wish to strictly inspect the `.mdb` files directly. The IIS server reads the database natively using OLEDB drivers.)*

---

## 🚀 Getting Started (Local Development)

We provide an **automated setup script** that makes starting the project locally pain-free, either for developers or AI Agents.

### 📋 Prerequisites
- **Windows OS** (Windows 10+ or Windows Server)
- **PowerShell** with Administrator Privileges
- *No prior installation of IIS is strictly required, the script will handle it!*

### ⚙️ Automated Setup

Running the standalone setup script will perform a full local deployment, including enabling IIS features, opening proper ports, setting folder permissions, and scaffolding the required data structures.

**Step 1. Clone the repository**
```bash
git clone https://github.com/madrasafree/spoken-arabic-dictionary.git
cd spoken-arabic-dictionary
```

**Step 2. Run the setup script**
Open **PowerShell as Administrator** and execute:
```powershell
.\tools\setup-local-env.ps1
```
> **Note:** If you get an *Execution Policy* restriction error, run this first: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` and then run the script again.

**Step 3. Provide the Database**
The script automatically generates an `App_Data` folder at the root of the project.
Drop the actual application `.mdb` database file into this `App_Data` folder before browsing the site.

**Step 4. Access the Site**
Open your browser and navigate to:
[http://localhost:8081](http://localhost:8081)

---

### 🔧 Manual Setup (Advanced)
If you prefer to configure IIS manually without the script:
1. Ensure **IIS** and the **ASP Classic** feature are enabled in Windows Features.
2. Clone the repository and create an `App_Data` directory at the project root for the `.mdb` database.
3. In **IIS Manager**, create a new Website pointing the *Physical Path* to this repository. Set the Port to `8081` (or another port of your choice).
4. Assign `IIS_IUSRS` **Read & Write** permissions securely to the new `App_Data` folder.
5. In your site's Application Pool settings, ensure **Enable 32-Bit Applications** is set to `True` (Crucial for MS Access DB connections on 64-bit systems).
