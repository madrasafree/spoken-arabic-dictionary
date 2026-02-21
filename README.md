# Spoken Arabic Dictionary Project

Welcome to the repository for the Spoken Arabic Dictionary, currently hosted at [milon.madrasafree.com](https://milon.madrasafree.com/). This project serves as a free resource for Hebrew speakers who are interested in learning and speaking Arabic.

## Project History
The "Spoken Arabic Dictionary" project was founded in 2005 by Ronen Rothfarb and was managed by him until 2022 when it was taken over by the non-profit organization "Madrasa."

The dictionary is designed as a community-driven content platform, similar to Wikipedia, where users contribute words themselves. These contributions are reviewed by experienced users with deep knowledge of both Hebrew and spoken Arabic to ensure accuracy and reliability.

## Current Technology Stack
The current version of the Spoken Arabic Dictionary is built using:
- **ASP Classic**: for server-side scripting.
- **IIS (Internet Information Services)**: as the web server.
- **MS Access Database**: as the database backend. *(Note: MS Access software is only required if you want to open and strictly inspect the `.mdb` files directly. The IIS server interfaces via OLEDB drivers.)*

## Setting Up Locally

The easiest way to get the project running locally, either as a developer or through an AI agent, is using the automated setup script we provide. This requires a **Windows** environment.

### Requirements
- **Windows** (Windows 10+ or Windows Server).
- **IIS (Internet Information Services)** (can be enabled via our script).
- Administrator Privileges to execute the setup script.

### Automated Setup (Recommended)
You can quickly establish your `App_Data` folder and an IIS site mapped to port `8081` using PowerShell:

1. Open PowerShell **as Administrator**.
2. Navigate to the project root directory.
3. Run the setup script:
   ```powershell
   .\tools\setup-local-env.ps1
   ```

**What the script does:**
- Creates a demo `App_Data` folder in the project if one doesn't exist (this folder is ignored in version control).
- Checks if IIS and Classic ASP features are installed, and enables them if missing.
- Checks if the IIS service is running and starts it if necessary.
- Creates an Application Pool enabling 32-bit apps (useful for Access Database OLEDB connections).
- Provisions a new IIS Site designated to port `8081` mapped to the project root.
- Assigns required `IIS_IUSRS` permissions to the `App_Data` folder for file read/write.

After running the script, your local instance should be accessible at: `http://localhost:8081/`.
*Make sure to drop the application `.mdb` database into the generated `App_Data` folder before starting the app!*

### Manual Setup
If you prefer not to use the automated script:
1. Make sure you enable **IIS** with the **ASP** feature turned on in Windows Features.
2. In IIS Manager, create a new Website pointing the Physical Path to this repository's root. Set Port to `8081` (or another port).
3. Ensure the Application Pool for the site has **Enable 32-Bit Applications** set to `True`.
4. Create an `App_Data` folder at the root of the repository and place the project's MS Access database file inside.
5. In your file explorer, provide `IIS_IUSRS` Read/Write permissions into the new `App_Data` folder.
