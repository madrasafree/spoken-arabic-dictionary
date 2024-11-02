# Spoken Arabic Dictionary Project - Current (Old Version)

Welcome to the repository for the Spoken Arabic Dictionary, currently hosted at [milon.madrasafree.com](https://milon.madrasafree.com/). This project serves as a free resource for Hebrew speakers who are interested in learning and speaking Arabic.

## Project History
The "Spoken Arabic Dictionary" project was founded in 2005 by Ronen Rothfarb and was managed by him until 2022 when it was taken over by the non-profit organization "Madrasa."

The dictionary is designed as a community-driven content platform, similar to Wikipedia, where users contribute words themselves. These contributions are reviewed by experienced users with deep knowledge of both Hebrew and spoken Arabic to ensure accuracy and reliability.

## Current Technology Stack
The current version of the Spoken Arabic Dictionary is built using:
- **ASP Classic**: for server-side scripting.
- **MS Access**: as the database backend.
- **IIS (Internet Information Services)**: as the web server.

## Setup for IIS and Local Environment
If you want to run the project locally or set it up on a new server, follow the steps below:

### Requirements
- **Windows Server** or **Windows 10+** (for local development).
- **IIS** (Internet Information Services) installed.
- **MS Access Runtime** (if required for local testing).

### Step-by-Step Setup for IIS
1. **Install IIS**
   - On Windows, go to **Control Panel** > **Programs** > **Turn Windows features on or off**.
   - Enable **Internet Information Services (IIS)** and ensure that **ASP** support is checked.

2. **Configure IIS for ASP Classic**
   - Open **IIS Manager**.
   - Add a new **Website**:
     - Point the **physical path** to the directory where your project files are located.
     - Set the **binding** to the desired port (default is 80 for HTTP).
   - Enable **ASP** in **Handler Mappings** by navigating to the site in **IIS Manager**, then selecting **Handler Mappings**, and ensuring that **ASP** is enabled.

3. **Permissions**
   - Ensure that the **IUSR** (IIS User) account has **Read/Write** permissions to the directory containing the **.mdb** file, as the dictionary allows user contributions.

### Local Environment Setup
For local development:
1. **Install IIS** on your local machine (follow the same steps as above).
2. Clone the repository to your local machine.
3. Configure IIS to point to the cloned directory.
4. Update any paths to ensure the database is accessible locally.

## Migration Project
We are currently working on migrating this project to a more modern stack using **Flask (Python)** for the backend and **PostgreSQL** as the database. This migration aims to improve scalability, maintainability, and performance, while also making it easier for developers to contribute to the project.

### Planned Technology Stack
- **Backend**: Flask (Python)
- **Database**: PostgreSQL
- **Web Server**: Nginx or another modern web server

Stay tuned for updates as we make progress on this migration.

## Contributing
If you are interested in contributing to this project, whether in its current ASP Classic form or the upcoming Flask version, please feel free to reach out. Contributions are welcome, especially in the areas of:
- Improving ASP Classic code for current stability.
- Assisting with the migration to Flask and PostgreSQL.
- Testing and providing feedback.


## Contact
For questions or suggestions, please contact the project maintainers at [info@madrasafree.com](mailto:info@madrasafree.com).

