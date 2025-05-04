---
id: 1746381057-discharge-planning
alias: Discharge Planning
tags: []
---
# Discharge Planning

Okay, let's structure this as a Jira Epic with related User Stories/Tasks and create a draft Confluence page for documentation.

---

## Jira Structure

**1. Epic**

*   **Project:** `[Your Project Key]` (e.g., MLITE)
*   **Issue Type:** Epic
*   **Epic Name:** Implement Discharge Planning Module
*   **Summary:** Implement Discharge Planning Module
*   **Description:**
    Develop and integrate a new Discharge Planning module within mLITE. This module will allow authorized staff (initially admin, potentially others later) to:
    *   Identify inpatient patients requiring discharge planning based on predefined risk criteria (e.g., age > 65, mobility issues, complex care needs identified in assessments).
    *   View a filtered list of these patients (active/discharged, plan status).
    *   Create, view, edit, save, and print comprehensive discharge plans, integrating relevant data from the patient's record (SOAP, medications, DPJP, etc.).
    *   Manage patient and staff signatures for the plan.
*   **Acceptance Criteria:**
    *   A new "Discharge Planning" menu item is visible to authorized users in the admin sidebar.
    *   Users can access a page listing inpatient patients eligible for discharge planning.
    *   The patient list accurately reflects risk criteria derived from `rencana_pemulangan_assranapanak_custom` and `rencana_pemulangan_assranapdewasa_custom`.
    *   The list can be filtered by admission/discharge date range and plan status (Pending, Filled, All).
    *   Selecting a patient opens a dedicated Discharge Planning form.
    *   The form pre-populates relevant data (patient demographics, DPJP, SOAP summary, medication list).
    *   The form allows input/selection for examinations, post-discharge care, required documents, discharge status, follow-up date, and patient/staff signatures.
    *   The completed discharge plan can be saved to the `pilot_discharge_planing` table (or equivalent).
    *   A saved plan can be retrieved and edited.
    *   A print-friendly version of the discharge plan can be generated.
    *   The patient list visually indicates which patients have a completed plan (e.g., row highlighting).
    *   The module integrates cleanly with existing mLITE structures and data sources.

**2. Linked Issues (User Stories / Tasks within the Epic)**

*   **Issue 1:**
    *   **Project:** `[Your Project Key]`
    *   **Issue Type:** Story / Task
    *   **Summary:** [Backend] Create Discharge Planning Core Module & Data Retrieval
    *   **Description:** Set up the basic plugin structure (`Admin.php`, `Info.php`). Implement the backend logic (`_getPatientListData`) to query and filter patients based on risk criteria, date ranges, and plan status, joining necessary tables (`kamar_inap`, `reg_periksa`, `pasien`, `dpjp_ranap`, assessment tables, `pilot_discharge_planing`). Create endpoints to fetch initial form data (`ambilSetupDP`) and SOAP details.
    *   **Epic Link:** `[Link to Epic: Implement Discharge Planning Module]`
    *   **Acceptance Criteria:** PHP classes created. `_getPatientListData` function correctly returns filtered patient lists. `ambilSetupDP` endpoint returns necessary data for form population.

*   **Issue 2:**
    *   **Project:** `[Your Project Key]`
    *   **Issue Type:** Story / Task
    *   **Summary:** [Frontend] Develop Discharge Planning UI Templates
    *   **Description:** Create the HTML view files: `manage.html` for the main page layout and filters, `display.html` for the patient list table, and `form.DP.html` for the detailed discharge planning form structure. Include necessary placeholders for dynamic data.
    *   **Epic Link:** `[Link to Epic: Implement Discharge Planning Module]`
    *   **Acceptance Criteria:** HTML templates created and render basic structure. Filters, table layout, and form sections are present.

*   **Issue 3:**
    *   **Project:** `[Your Project Key]`
    *   **Issue Type:** Story / Task
    *   **Summary:** [Frontend] Implement Discharge Planning JavaScript Logic & Interactions
    *   **Description:** Develop the core JavaScript (`base_discharge_planning.js`, `discharge_planning.js`). Implement:
        *   AJAX calls to load patient list (`reloadDisplay`) and form data (`loadDischargePlanningData`, `loadSOAPData`).
        *   Event handling for patient selection, filter submission.
        *   Dynamic population of form fields.
        *   Initialization and handling of multi-select buttons (`setupMultiSelect`).
        *   Integration and handling of the date picker for the control date.
        *   Integration and handling of the SignaturePad for patient signature (`openFullscreen`, `saveGambar`, `closeFullscreen`).
        *   Display of staff QR code/signature placeholder.
    *   **Epic Link:** `[Link to Epic: Implement Discharge Planning Module]`
    *   **Acceptance Criteria:** Patient list loads and filters via AJAX. Selecting a patient loads form data. Multi-selects, date picker, and signature pad are functional.

*   **Issue 4:**
    *   **Project:** `[Your Project Key]`
    *   **Issue Type:** Story / Task
    *   **Summary:** [Backend/Frontend] Implement Save, Clear, and Print Functionality
    *   **Description:** Create backend endpoints (`simpanDischargePlanning`, `hapusDP`) to handle saving and potentially clearing/deleting plans. Implement frontend JavaScript (`handleSaveDP`, `handleClearDP`, `printDP`) to gather form data, submit it for saving/clearing, and generate the print view by collecting relevant data and formatting it in a new window.
    *   **Epic Link:** `[Link to Epic: Implement Discharge Planning Module]`
    *   **Acceptance Criteria:** Discharge plans can be saved successfully. Saved plans can be cleared (if deletion is implemented). Print button generates a formatted, print-friendly summary.

*   **Issue 5:**
    *   **Project:** `[Your Project Key]`
    *   **Issue Type:** Task
    *   **Summary:** [UI/UX] Integrate Module into Admin Interface
    *   **Description:** Modify `systems/Admin.php` and `themes/admin/index.html` to add the "Discharge Planning" menu item with its icon (`door.png`) and necessary access checks (currently checks for `admin` role and module activation). Ensure consistent styling.
    *   **Epic Link:** `[Link to Epic: Implement Discharge Planning Module]`
    *   **Acceptance Criteria:** Menu item appears correctly for authorized users. Icon is displayed. Access control works as intended.

*   **Issue 6:**
    *   **Project:** `[Your Project Key]`
    *   **Issue Type:** Task
    *   **Summary:** [Testing] Test Discharge Planning Module End-to-End
    *   **Description:** Perform comprehensive testing covering: patient list filtering, form loading/population, multi-select functionality, date selection, signature capture, saving plans, retrieving saved plans, clearing plans, printing, access control, and integration points (SOAP data, medication data accuracy). Test with various patient scenarios (with/without assessments, with/without existing plans).
    *   **Epic Link:** `[Link to Epic: Implement Discharge Planning Module]`
    *   **Acceptance Criteria:** All core functionalities work as expected according to the Epic's ACs. No critical bugs found.

*   **Issue 7:** (This task!)
    *   **Project:** `[Your Project Key]`
    *   **Issue Type:** Task
    *   **Summary:** [Documentation] Create Confluence Documentation for Discharge Planning Module
    *   **Description:** Write user guide and technical overview documentation for the new module based on the final implementation.
    *   **Epic Link:** `[Link to Epic: Implement Discharge Planning Module]`
    *   **Acceptance Criteria:** Confluence page created with relevant sections covering usage and technical details.

---

## Confluence Page Draft

**Page Title:** Discharge Planning Module Documentation (mLITE)

**Parent Page:** `[mLITE Documentation / Modules]` (Optional)

**Labels:** `mlite`, `discharge-planning`, `module`, `user-guide`, `technical-guide`

**(Page Content)**

### 1. Overview

The Discharge Planning module provides a centralized interface within mLITE for managing the discharge process for specific inpatient populations identified as potentially requiring coordinated post-discharge care. It aims to ensure continuity of care by documenting necessary instructions, follow-ups, and patient readiness for discharge.

**Goal:** To streamline the creation, management, and communication of discharge plans for high-risk patients.

### 2. User Guide

**2.1 Accessing the Module**

1.  Log in to the mLITE Admin interface.
2.  Navigate to the main sidebar menu.
3.  Click on the "Discharge Planning" link (associated with the <img src="/assets/img/door.png" width="16" height="16"/> icon).
    *   *Note: Access may be restricted based on user roles (currently requires 'admin' role and module activation).*

**2.2 Patient List View (`manage.html`, `display.html`)**

Upon accessing the module, you will see a list of inpatient patients who meet the criteria for discharge planning.

*   **Criteria:** Patients typically appear here if they are flagged in specific initial assessments (e.g., `rencana_pemulangan_assranapanak_custom`, `rencana_pemulangan_assranapdewasa_custom`) based on factors like age (>65), limited mobility, or need for ongoing treatment/care.
*   **Table Columns:** Includes No. RM, Nama Pasien, Nomor Rawat, Bangsal/Kamar, DPJP, Penjamin, Tgl. Masuk, Tgl. Keluar, Status Pulang.
*   **Filtering:**
    *   Use the <i class="fa fa-calendar"></i> **Filter Pasien** dropdown at the top-right of the panel.
    *   Select a **Tanggal Awal** and **Tanggal Akhir** for the admission/discharge period.
    *   Click one of the filter buttons:
        *   **Tampilkan Belum Selesai:** Shows patients meeting risk criteria who are *still admitted* OR *discharged within the date range but have no plan saved* (`pilot_discharge_planing` record doesn't exist for them). Focuses on pending tasks.
        *   **Tampilkan Selesai:** Shows patients meeting risk criteria who were *discharged within the date range* AND *have a plan saved*. Focuses on completed tasks.
        *   **Tampilkan Semua:** Shows all patients meeting risk criteria who were *admitted within the date range* OR *discharged within the date range*, regardless of plan status. Provides a comprehensive view.
*   **Highlighting:** Rows highlighted in green indicate that a discharge plan has been saved for that patient (`nip_perawat` is not empty in `pilot_discharge_planing`).
*   **Selecting a Patient:** Click on the patient's name (hyperlink) to open the Discharge Planning form for that specific encounter.

**2.3 Discharge Planning Form (`form.DP.html`)**

This form is used to create or edit the discharge plan.

*   **Patient Information:** Basic details (Name, RM, Dates, DPJP) are pre-filled.
*   **Tanggal Kontrol:** Use the calendar button next to the input field to select the follow-up appointment date. Holidays and Sundays are visually marked.
*   **TTV/SOAP Summary:** A summary of the latest relevant SOAP note (TTV, Subjective, Objective, Assessment, Plan, etc.) is displayed for context.
*   **Pemeriksaan yang dilakukan:** Use the buttons to select relevant examinations performed. Click a blue button to select; it turns grey and enables the 'x' button. Click 'x' to deselect. Add free-text details in the "Keterangan Pemeriksaan" textarea.
*   **Perawatan Pasca Pulang:** Select required post-discharge care items (e.g., wound care, diet management) using the buttons. Add details in the "Keterangan Perawatan..." textarea.
*   **Kelengkapan Dokumen Kepulangan:** Select documents provided to the patient (e.g., discharge summary, prescriptions) using the buttons. Add details in the "Keterangan Dokumen..." textarea.
*   **Status Kepulangan:** Select the discharge status (e.g., Allowed Home, Referred To) using the buttons. Add details (like referral location) in the "Keterangan Kepulangan" textarea.
*   **Obat Pulang:** A list of prescribed discharge medications (from e-prescription/pharmacy data) is displayed.
*   **Signatures:**
    *   **Pasien:** Click the placeholder image (`onSignaturePadDP`) to open a full-screen canvas. The patient signs using a stylus or finger. Click "Simpan Ttd" to capture the signature. Click "Batal" or the 'x' to close without saving the current drawing.
    *   **Petugas:** Displays the name and QR code (generated based on the logged-in user who saves the form) of the staff member completing the plan.

**2.4 Saving, Clearing, and Finishing**

*   **Simpan:** Click the "Simpan" button to save the current state of the discharge plan.
*   **Hapus:** Click the "Hapus" button to delete the saved discharge plan for this encounter (requires confirmation).
*   **Print:** (Available after saving) Click the "Print" button to generate a printable summary of the plan in a new browser tab.
*   **Selesai:** Click the "Selesai" button to close the form view and return to the patient list.

### 3. Technical Details

**3.1 Module Location:** `/plugins/discharge_planning/`

**3.2 Key Files:**

*   `Admin.php`: Backend controller, handles requests, data fetching, saving.
*   `Info.php`: Plugin metadata.
*   `view/admin/manage.html`: Main wrapper view.
*   `view/admin/display.html`: Patient list display logic.
*   `view/admin/form.DP.html`: Discharge planning form structure.
*   `js/admin/base_discharge_planning.js`: Core frontend JavaScript class (`DischargePlanning`) handling AJAX, form interactions, multi-selects, signature pad, printing.
*   `js/admin/discharge_planning.js`: Initialization script for the module.

**3.3 Database Interaction:**

*   **Primary Table for Plans:** `pilot_discharge_planing` (stores saved plan details, including selections, free text, signature references, staff NIP).
*   **Data Sources for Patient List & Form:**
    *   `kamar_inap`, `reg_periksa`, `pasien`: Core patient and encounter data.
    *   `bangsal`, `kamar`: Location information.
    *   `penjab`: Guarantor information.
    *   `dpjp_ranap`, `dokter`: DPJP information.
    *   `rencana_pemulangan_assranapanak_custom`, `rencana_pemulangan_assranapdewasa_custom`: Source of risk criteria flags (`lebih_dari_65_tahun`, `keterbatasan_mobilitas`, `perawatan_pengobatan_lanjutan`).
    *   `pemeriksaan_ranap`: Source for SOAP note summary.
    *   `detail_pemberian_obat`, `databarang`, `resep_obat`: Source for discharge medication list.
*   **Key Functions:** `_getPatientListData` in `Admin.php` performs the main query for the patient list.

**3.4 Frontend Logic:**

*   **`DischargePlanning` Class:** Manages state and interactions within `base_discharge_planning.js`.
*   **AJAX:** Used extensively to load patient lists (`reloadDisplay`), fetch form data (`loadDischargePlanningData`), get SOAP details (`loadSOAPData`), and save/delete plans (`handleSaveDP`, `handleClearDP`). URLs are constructed dynamically using `mlite.url`, `mlite.admin`, `mlite.token`.
*   **Multi-Selects:** Implemented using dynamically generated button groups. State (`selectedPemeriksaan`, etc.) is managed in the JS class. Button clicks toggle state, update UI, and modify corresponding textarea content.
*   **Signature Pad:** Uses `signature_pad.umd.min.js`. `openFullscreen` displays the canvas, `saveGambar` captures the `toDataURL` output, `closeFullscreen` hides it.
*   **Printing:** The `printDP` function gathers data from the form fields and selected buttons, constructs HTML dynamically, and opens it in a new window for printing.

**3.5 Dependencies:**

*   jQuery
*   Bootstrap
*   DataTables (for patient list)
*   Bootstrap DateTimePicker
*   SignaturePad.js
*   jQuery.qrcode.js / qrcode.js (for staff QR code)
*   jQuery Minicolors (Used in signature pad sub-component, though pen color isn't actively changed in the DP form itself based on the provided code).
*   Moment.js (dependency for DateTimePicker)

**3.6 Configuration & Access:**

*   The module currently requires the `admin` user role for access, as checked in `themes/admin/index.html`. This might need adjustment for clinical roles (e.g., nurses).
*   Requires the underlying assessment forms (`rencana_pemulangan...`) to be in use to correctly identify patients needing planning.

### 4. Future Enhancements (Optional)

*   Role-based access control beyond 'admin'.
*   Notifications/alerts for pending discharge plans.
*   Integration with task management systems.
*   More detailed SOAP/Clinical data integration.

---