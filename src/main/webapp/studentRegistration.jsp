<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration Form</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        /* === 1. UPDATED ROOT VARIABLES === */
        :root {
            --primary-color: #2563eb;
            --primary-hover-color: #1d4ed8;
            --error-color: #ef4444;
            
            /* New professional palette */
            --background-start: #f0f7ff; /* Light blue */
            --background-end: #e0e9f5;   /* Light grey-blue */
            --form-background: #ffffff;
            --text-color: #1f2937;       /* Darker text for contrast */
            --label-color: #4b5563;      /* Slightly darker label */
            --border-color: #d1d5db;     /* Clearer border */
            --placeholder-color: #9ca3af;
            --input-bg: #f9fafb;         /* Light grey for inputs */
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* === 2. NEW GRADIENT BACKGROUND === */
        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--background-start);
            background-image: linear-gradient(135deg, var(--background-start) 0%, var(--background-end) 100%);
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            align-items: center;
            min-height: 100vh;
            padding: 2rem 1rem;
        }

        /* === 3. CLEAN HEADER (NO BOX) === */
        .page-header {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            width: 100%;
            max-width: 600px;
            padding: 1rem 0;
            margin-bottom: 1.5rem; 
        }

        .header-logo {
            height: 60px;
            width: 60px;
            object-fit: contain;
            flex-shrink: 0;
            /* Adds a subtle shadow to the logo */
            filter: drop-shadow(0 3px 5px rgba(0,0,0,0.1));
        }

        .header-title {
            font-size: 1.75rem;
            font-weight: 600;
            color: var(--text-color); /* Dark text, not blue */
            margin: 0;
            line-height: 1.3;
        }

        /* === 4. ENHANCED FORM CONTAINER "CARD" === */
        .form-container {
            background-color: var(--form-background);
            padding: 2.5rem;
            border-radius: 12px;
            /* A softer, more pronounced shadow */
            box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.1);
            border: 1px solid #e5e7eb; /* Subtle border */
            width: 100%;
            max-width: 600px; 
        }
        
        .form-title {
            font-size: 1.75rem;
            font-weight: 600;
            text-align: center;
            margin-bottom: 2rem;
            color: var(--text-color);
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.25rem;
        }

        .input-group {
            margin-bottom: 1.25rem;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .input-group label {
            display: block;
            font-size: 0.9rem;
            font-weight: 500;
            color: var(--label-color);
            margin-bottom: 0.5rem;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper .input-icon {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            left: 15px;
            color: var(--placeholder-color);
            z-index: 2;
        }

        /* === 5. IMPROVED INPUT FIELDS === */
        .input-field, .select-field {
            width: 100%;
            padding: 0.85rem 1rem;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
            color: var(--text-color);
            background-color: var(--input-bg); /* Set light bg */
            transition: border-color 0.3s, box-shadow 0.3s;
            appearance: none;
        }

        .input-field {
            padding-left: 2.75rem;
        }

        .input-field:focus, .select-field:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.2);
            background-color: #fff; /* White on focus */
        }

        .select-wrapper {
            position: relative;
        }

        .select-wrapper::after {
            content: '\f078';
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            position: absolute;
            top: 50%;
            right: 15px;
            transform: translateY(-50%);
            color: var(--placeholder-color);
            pointer-events: none;
        }

        .dob-inputs {
            display: flex;
            gap: 0.75rem;
        }
        .dob-field {
            width: 100%;
            padding: 0.85rem;
            font-size: 1rem;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            background-color: var(--input-bg);
        }
        .dob-field:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.2);
            background-color: #fff;
        }
        #dob-day { width: 25%; text-align: center; }
        #dob-month { flex: 2; }
        #dob-year { flex: 1.5; }

        .file-input { display: none; }
        .file-upload-label {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.85rem 1rem;
            border: 1px dashed var(--border-color); /* Dashed border for file upload */
            border-radius: 8px;
            cursor: pointer;
            color: var(--placeholder-color);
            background-color: var(--input-bg);
            transition: background-color 0.3s;
        }
        .file-upload-label:hover {
            background-color: #f3f4f6;
        }
        .file-upload-label span {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            flex-grow: 1;
        }
        .file-preview {
            max-width: 40px;
            max-height: 40px;
            border-radius: 4px;
            margin-left: auto;
            display: none;
        }
        .file-upload-label.has-file .file-preview { display: block; }
        .file-upload-label.has-file {
            border-style: solid;
            border-color: var(--primary-color);
        }
        
        /* Captcha Styling */
        .captcha-wrapper {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        #captcha-display {
            padding: 0.85rem;
            background-color: #f3f4f6;
            border-radius: 8px;
            font-size: 1.25rem;
            font-weight: 600;
            letter-spacing: 4px;
            user-select: none;
            text-decoration: line-through;
            flex-grow: 1;
            text-align: center;
            border: 1px solid var(--border-color);
        }
        #captcha-refresh {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--label-color);
            transition: color 0.3s, transform 0.3s;
        }
        #captcha-refresh:hover {
            color: var(--primary-color);
            transform: rotate(90deg);
        }

        .error-message {
            color: var(--error-color);
            font-size: 0.8rem;
            margin-top: 0.25rem;
            display: none;
        }

        /* === 6. UPGRADED SUBMIT BUTTON === */
        .submit-btn {
            width: 100%;
            padding: 0.9rem;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 1rem;
            /* Smooth transition for hover */
            transition: background-color 0.3s, box-shadow 0.3s, transform 0.3s;
        }
        .submit-btn:hover {
            background-color: var(--primary-hover-color);
            /* Add a "lift" effect */
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(37, 99, 235, 0.3);
        }
        .submit-btn:disabled {
            background-color: var(--placeholder-color);
            cursor: not-allowed;
        }

        /* === 7. CLEAN FOOTER (NO BOX) === */
        .page-footer {
            width: 100%;
            max-width: 600px;
            text-align: center;
            padding: 1.5rem;
            margin-top: 1rem; 
            color: #777; /* Lighter, more subtle footer text */
            font-size: 0.9rem;
        }

        /* Toast notifications (unchanged) */
        #toast {
            visibility: hidden;
            min-width: 250px;
            margin-top: 20px;
            margin-right: 30px;
            background-color: #4CAF50;
            color: #fff;
            text-align: left;
            border-radius: 8px;
            padding: 15px;
            position: fixed;
            top: 20px;
            right: 30px;
            z-index: 1000;
            font-size: 16px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
            opacity: 0;
            transform: translateY(-20px);
            transition: all 0.5s ease;
        }
        #toast.show {
            visibility: visible;
            opacity: 1;
            transform: translateY(0);
        }
        #toast.error {
            background-color: #f44336;
        }
        #toast.success {
            background-color: #4CAF50;
        }
        
        /* Responsive CSS (unchanged) */
        @media (max-width: 600px) {
            body {
                padding: 1rem 0.5rem;
            }
            .page-header {
                flex-direction: column;
                gap: 1rem;
                padding: 1.5rem;
                text-align: center;
            }
            .header-title {
                font-size: 1.25rem;
            }
            .form-container {
                padding: 1.5rem;
            }
            .form-grid {
                /* Stack fields on top of each other */
                grid-template-columns: 1fr;
            }
            .full-width {
                /* This is default in a 1-column grid, but good to be explicit */
                grid-column: 1 / -1; 
            }
        }
        
    </style>
    
</head>
<body>


    <div class="form-container">
        <h2 class="form-title">Msc computer science Student Registration form</h2>
        <div id="toast"></div>
        
        <form action="StudentRegistration" method="post" id="studentForm" enctype="multipart/form-data">
            <div class="form-grid">
                <div class="input-group full-width">
                    <label for="full-name">Student Name</label>
                    <div class="input-wrapper"><i class="fa-solid fa-user input-icon"></i><input type="text" id="full-name" class="input-field" placeholder="Enter full name" required name="fullname"></div>
                </div>
                <div class="input-group">
                    <label for="father-name">Father's Name</label>
                    <div class="input-wrapper"><i class="fa-solid fa-user-tie input-icon"></i><input type="text" id="father-name" class="input-field" placeholder="Enter father's name" required name="fathername"></div>
                </div>
                <div class="input-group">
                    <label for="regdno">Registration number</label>
                    <div class="input-wrapper"><i class="fa-solid fa-user-tie input-icon"></i><input type="text" id="regdno" class="input-field" placeholder="Enter Registration number" required name="regdno"></div>
                </div>
                <div class="input-group">
                    <label for="mother-name">Mother's Name</label>
                    <div class="input-wrapper"><i class="fa-solid fa-user-shield input-icon"></i><input type="text" id="mother-name" class="input-field" placeholder="Enter mother's name" required name="mothername"></div>
                </div>

                <div class="input-group">
                    <label for="admission-no">Admission Number</label>
                    <div class="input-wrapper"><i class="fa-solid fa-id-card input-icon"></i><input type="text" id="admission-no" class="input-field" placeholder="e.g., 25CE...." required name="admno"></div>
                </div>
                <div class="input-group">
                    <label for="rank">Rank</label>
                    <div class="input-wrapper"><i class="fa-solid fa-hashtag input-icon"></i><input type="number" id="rank" class="input-field" placeholder="Enter rank" required name="rank"></div>
                </div>
                <div class="input-group">
                    <label for="admission-type">Admission Type</label>
                    <div class="select-wrapper">
                        <select id="admission-type" class="select-field" required name="admtype">
                            <option value="" disabled selected>----Select Type----</option>
                            <option value="Self Finance">Self Finance</option>
                            <option value="Self Support">Self Support</option>
                            <option value="Management Quota">Management Quota</option>
                        </select>
                    </div>
                </div>
                <div class="input-group">
                    <label for="class">Class</label>
                    <div class="select-wrapper">
                        <select id="class" class="select-field" required name="class">
                            <option value="" disabled selected>----Select Type----</option>
                            <option value="M.SC COMPUTERS">M.SC COMPUTERS</option>
                            <option value="MCA COMPUTERS">MCA COMPUTERS</option>
                            <option value="M.SC APPLIED CHEMISTRY">M.SC APPLIED CHEMISTRY</option>
                            <option value="MTECH-CSSE">MTECH-CSSE</option>
                            <option value="MTECH-ITCA">MTECH-ITCA</option>
                            <option value="MTECH-EEE">MTECH-EEE</option>
                            <option value="MTECH-ECE">MTECH-ECE</option>
                        </select>
                    </div>
                </div>
                <div class="input-group">
                    <label for="department">Department</label> <div class="select-wrapper">
                        <select id="department" class="select-field" required name="dept">
                            <option value="" disabled selected>----Select Type----</option>
                            <option value="CSSE">CSSE</option>
                            <option value="ITCA">ITCA</option>
                            <option value="ECE">ECE</option>
                            <option value="CHEMICAL">CHEMICAL</option>
                            <option value="EEE">EEE</option>
                            <option value="MECHANICAL">MECHANICAL</option>
                            <option value="CIVIL">CIVIL</option>
                            <option value="MARINE">MARINE</option>
                        </select>
                    </div>
                </div>
                <div class="input-group">
                    <label for="join-category">Join Category</label>
                    <div class="select-wrapper">
                        <select id="join-category" class="select-field" required name="joincate">
                            <option value="" disabled selected>----Select Category----</option>
                            <option value="OC">OC</option>
                            <option value="BC">BC</option>
                            <option value="SC">SC</option>
                            <option value="ST">ST</option>
                        </select>
                    </div>
                </div>

                <div class="input-group">
                    <label for="email">Email Address</label>
                    <div class="input-wrapper"><i class="fa-solid fa-envelope input-icon"></i><input type="email" id="email" class="input-field" placeholder="Enter email" required name="email"></div>
                </div>
                <div class="input-group">
                    <label for="phone">Phone Number</label>
                    <div class="input-wrapper"><i class="fa-solid fa-phone input-icon"></i><input type="tel" id="phone" class="input-field" placeholder="Enter phone" required name="phone"></div>
                </div>
                <div class="input-group full-width">
                    <label>Date of Birth</label>
                    <div class="dob-inputs">
                        <input type="number" id="dob-day" class="dob-field" placeholder="DD" min="1" max="31" required name="date">
                        <select id="dob-month" class="dob-field" required name="month">
                            <option value="" disabled selected>Month</option>
                            <option value="01">January</option><option value="02">February</option><option value="03">March</option><option value="04">April</option><option value="05">May</option><option value="06">June</option><option value="07">July</option><option value="08">August</option><option value="09">September</option><option value="10">October</option><option value="11">November</option><option value="12">December</option>
                        </select>
                        <select id="dob-year" class="dob-field" required name="year"><option value="" disabled selected>year</option></select>
                    </div>
                </div>
                <div class="input-group full-width">
                    <label for="gender">Gender</label>
                    <div class="select-wrapper">
                        <select id="gender" class="select-field" required name="gender">
                            <option value="" disabled selected>--------Select Gender--------</option>
                            <option value="MALE">Male</option>
                            <option value="FEMALE">Female</option>
                            <option value="OTHERS">Others</option>
                        </select>
                    </div>
                </div>

                <div class="input-group">
                    <label for="village">Village/Town</label>
                    <div class="input-wrapper"><i class="fa-solid fa-house-chimney input-icon"></i><input type="text" id="village" class="input-field" placeholder="Enter village or town" required name="village"></div>
                </div>
                <div class="input-group">
                    <label for="mandal">Mandal</label>
                    <div class="input-wrapper"><i class="fa-solid fa-map input-icon"></i><input type="text" id="mandal" class="input-field" placeholder="Enter mandal" required name="mandal"></div>
                </div>
                <div class="input-group">
                    <label for="district">District</label>
                    <div class="input-wrapper"><i class="fa-solid fa-city input-icon"></i><input type="text" id="district" class="input-field" placeholder="Enter district" required name="dist"></div>
                </div>
                <div class="input-group">
                    <label for="pincode">Pincode</label>
                    <div class="input-wrapper"><i class="fa-solid fa-location-dot input-icon"></i><input type="number" id="pincode" class="input-field" placeholder="Enter pincode" required name="pincode"></div>
                </div>

                <div class="input-group">
                    <label>Student Photo</label>
                    <label for="photo-upload" class="file-upload-label" id="photo-upload-label">
                        <i class="fa-solid fa-image"></i><span id="photo-filename">Upload a photo</span>
                        <img id="photo-preview" class="file-preview" >
                    </label>
                    <input type="file" id="photo-upload" class="file-input" accept="image/*"  name="photo">
                </div>
                <div class="input-group">
                    <label>Signature</label>
                    <label for="sign-upload" class="file-upload-label" id="sign-upload-label">
                        <i class="fa-solid fa-signature"></i><span id="sign-filename">Upload signature</span>
                        <img id="sign-preview" class="file-preview" >
                    </label>
                    <input type="file" id="sign-upload" class="file-input" accept="image/*"  name="sign">
                </div>

                <div class="input-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper"><i class="fa-solid fa-lock input-icon"></i><input type="password" id="password" class="input-field" placeholder="Min 8 chars" minlength="8" required name="password"></div>
                </div>
                <div class="input-group">
                    <label for="confirm-password">Confirm Password</label>
                    <div class="input-wrapper"><i class="fa-solid fa-lock input-icon"></i><input type="password" id="confirm-password" class="input-field" placeholder="Re-enter password" required></div>
                    <p class="error-message" id="password-error-message"></p>
                </div>
                
                <div class="input-group full-width">
                    <label for="captcha-input">Captcha</label>
                    <div class="captcha-wrapper">
                        <div id="captcha-display"></div>
                        <button type="button" id="captcha-refresh"><i class="fa-solid fa-rotate-right"></i></button>
                    </div>
                </div>
                <div class="input-group full-width">
                    <div class="input-wrapper"><i class="fa-solid fa-keyboard input-icon"></i><input type="text" id="captcha-input" class="input-field" placeholder="Enter captcha text" ></div>
                    <p class="error-message" id="captcha-error-message"></p>
                </div>

            </div> 
            <button type="submit" class="submit-btn full-width"><i class="fa-solid fa-user-graduate"></i>Submit </button>
        </form>
        
    </div>

    <script>
document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById("studentForm");
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirm-password');
    const passwordErrorMessage = document.getElementById('password-error-message');
    const yearSelect = document.getElementById('dob-year');

    // Captcha elements
    const captchaDisplay = document.getElementById('captcha-display');
    const captchaInput = document.getElementById('captcha-input');
    const captchaRefreshBtn = document.getElementById('captcha-refresh');
    const captchaErrorMessage = document.getElementById('captcha-error-message');
    let currentCaptcha = '';

    // --- Captcha Generation ---
    function generateCaptcha() {
        const chars = '1234567890';
        let captcha = '';
        for (let i = 0; i < 6; i++) {
            captcha += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        currentCaptcha = captcha;
        captchaDisplay.textContent = currentCaptcha;
        captchaErrorMessage.style.display = 'none';
        captchaInput.value = '';
    }

    // --- Populate Year Dropdown ---
    function populateYears() {
        const currentYear = new Date().getFullYear();
        const startYear = currentYear - 100;
        for (let year = currentYear - 15; year >= startYear; year--) {
            const option = document.createElement('option');
            option.value = year;
            option.textContent = year;
            yearSelect.appendChild(option);
        }
        // Set a reasonable default
        if(yearSelect.options.length > 20) {
             yearSelect.selectedIndex = 20; // Default to 20 years from start
        }
    }

    // --- File Input Preview ---
    function handleFileInputChange(inputElement, filenameSpan, previewImg, uploadLabel, defaultText) {
        inputElement.addEventListener('change', () => {
            if (inputElement.files.length > 0) {
                const file = inputElement.files[0];
                filenameSpan.textContent = file.name;
                filenameSpan.style.color = 'var(--text-color)';
                const reader = new FileReader();
                reader.onload = (e) => {
                    previewImg.src = e.target.result;
                    uploadLabel.classList.add('has-file');
                };
                reader.readDataURL(file);
            } else {
                filenameSpan.textContent = defaultText;
                filenameSpan.style.color = 'var(--placeholder-color)';
                uploadLabel.classList.remove('has-file');
                previewImg.src = '';
            }
        });
    }

    // --- Initial Setup ---
    populateYears();
    generateCaptcha();
    captchaRefreshBtn.addEventListener('click', generateCaptcha);

    handleFileInputChange(document.getElementById('photo-upload'), document.getElementById('photo-filename'), document.getElementById('photo-preview'), document.getElementById('photo-upload-label'), 'Upload a photo');
    handleFileInputChange(document.getElementById('sign-upload'), document.getElementById('sign-filename'), document.getElementById('sign-preview'), document.getElementById('sign-upload-label'), 'Upload signature');


    // --- Toast Function ---
    function showToast(message, isSuccess = true) {
        const toast = document.getElementById("toast");
        if (!toast) return; // Ensure toast container exists
        toast.textContent = message;
        toast.className = "show " + (isSuccess ? "success" : "error");
        
        // Hide the toast after 5 seconds
        setTimeout(() => { 
            toast.className = toast.className.replace("show", ""); 
        }, 5000);
    }
    
    
    // --- Validation Function ---
    function validateForm() {
        // Clear previous dynamic errors
        passwordErrorMessage.style.display = 'none';
        captchaErrorMessage.style.display = 'none';
        
        // 1. Check all 'required' text/number/email/tel inputs
        // We use querySelectorAll to find inputs and selects that have the 'required' attribute
        const requiredFields = form.querySelectorAll('input[required], select[required]');
        
        for (const field of requiredFields) {
            const label = field.labels[0] ? field.labels[0].textContent : field.name;
            
            // Check text/number/password/email/tel fields
            if (field.type !== 'file' && field.tagName !== 'SELECT' && field.value.trim() === "") {
                showToast(`Error: '${label}' is required.`, false);
                field.focus();
                return false;
            }
            
            // Check select fields
            if (field.tagName === 'SELECT' && field.value === "") {
                 showToast(`Error: Please select a value for '${label}'.`, false);
                field.focus();
                return false;
            }
            
            // Check file fields (photo and sign)
            if (field.type === 'file' && field.files.length === 0) {
                 showToast(`Error: Please upload a file for '${label}'.`, false);
                // Note: focusing a file input is tricky, we just show the error.
                return false;
            }
        }
        
        // 2. Specific Format Validations
        const emailInput = document.getElementById('email');
        // A simple regex for email validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(emailInput.value)) {
            showToast('Error: Please enter a valid email address.', false);
            emailInput.focus();
            return false;
        }
        
        const phoneInput = document.getElementById('phone');
        const phoneRegex = /^\d{10}$/; // Simple 10-digit phone regex
        if (!phoneRegex.test(phoneInput.value)) {
            showToast('Error: Phone number must be 10 digits.', false);
            phoneInput.focus();
            return false;
        }

        const pincodeInput = document.getElementById('pincode');
        const pincodeRegex = /^\d{6}$/; // Simple 6-digit pincode regex
        if (!pincodeRegex.test(pincodeInput.value)) {
            showToast('Error: Pincode must be 6 digits.', false);
            pincodeInput.focus();
            return false;
        }
        
        // 3. Password Match
        if (passwordInput.value !== confirmPasswordInput.value) {
            // Use the specific error message <p> tag for password
            passwordErrorMessage.textContent = 'Passwords do not match.';
            passwordErrorMessage.style.display = 'block';
            confirmPasswordInput.focus();
            return false;
        }
        
        // 4. Captcha Validation
        if (captchaInput.value.trim() !== currentCaptcha) {
            // Use the specific error message <p> tag for captcha
            captchaErrorMessage.textContent = 'Captcha is incorrect. Please try again.';
            captchaErrorMessage.style.display = 'block';
            generateCaptcha(); // Generate a new captcha
            captchaInput.focus();
            return false;
        }
        
        // If all checks pass
        return true;
    }
    // --- End of Validation Function ---


    // --- Form Submission Event Listener ---
    form.addEventListener('submit', (event) => {
        event.preventDefault(); // Always stop the default submission

        // Run the validation function.
        // If it returns false, stop right here.
        if (!validateForm()) {
            return; 
        }

        // --- AJAX form submission (Only runs if validation passed) ---
        const formData = new FormData(form); 
        const submitButton = form.querySelector('.submit-btn');
        submitButton.disabled = true; 
        submitButton.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Submitting...';
        
        fetch('StudentRegistration', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) {
                throw new Error(`Server error: ${response.statusText}`);
            }
            return response.text();
        })
        .then(data => {
             const isSuccess = data.toLowerCase().includes("success");
             showToast(data, isSuccess); 
             if(isSuccess) {
                form.reset();
                // Manually reset file previews
                document.getElementById('photo-filename').textContent = 'Upload a photo';
                document.getElementById('sign-filename').textContent = 'Upload signature';
                document.getElementById('photo-upload-label').classList.remove('has-file');
                document.getElementById('sign-upload-label').classList.remove('has-file');
                document.getElementById('photo-preview').src = '';
                document.getElementById('sign-preview').src = '';
             }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('An error occurred. Please try again.', false);
        })
        .finally(() => {
             generateCaptcha();  
             submitButton.disabled = false; 
             submitButton.innerHTML = '<i class="fa-solid fa-user-graduate"></i> Submit';
        });
    });

});
</script>
</body>
</html>