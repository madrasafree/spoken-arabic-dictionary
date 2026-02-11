<!-- Styles for the Banner -->
<style>
    .madrasa-banner-wrapper {
        background-color: #56c1e9;
        width: 100%;
        max-width: 1110px;
        margin: 0 auto;
        margin-bottom: 20px;
        /* Center the banner if screen is wider */
        padding: 0;
        display: flex;
        align-items: center;
        justify-content: space-between;
        direction: rtl;
        box-sizing: border-box;
        font-family: 'Abraham', sans-serif;
        /* Assuming you use Heebo or similar */
        overflow: hidden;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);

    }

    /* Logo Area */
    .madrasa-logo {
        background-color: #ffffff;
        height: 120px;
        padding: 0 20px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .madrasa-logo img {
        height: 80%;
        width: auto;
        display: block;
    }

    /* Content Area */
    .madrasa-content {
        flex: 1;
        text-align: center;
        padding: 0 1rem;
        color: #ffffff;
    }

    .madrasa-content h2 {
        margin: 0;
        font-size: 38px;
        font-weight: 800;
        line-height: 1;
        background-color: transparent;

    }

    .madrasa-content p {
        margin: 0.5rem 0 0;
        font-size: 30px;
        font-weight: 700;
        color: #01235e;
        line-height: 1;
    }

    /* Button Area */
    .madrasa-cta-container {
        padding-left: 30px;
        /* Padding on the left for RTL layout */
    }

    .madrasa-btn {
        background-color: #0a2a79;
        color: #ffffff !important;
        padding: 1rem 2.5rem;
        border-radius: 50px;
        text-decoration: none;
        font-size: 30px;
        font-weight: bold;
        white-space: nowrap;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        transition: background-color 0.2s ease, transform 0.1s ease;
        display: inline-block;
    }

    .madrasa-btn:hover {
        background-color: #0d3db5;
        transform: translateY(-1px);
    }

    /* --- MOBILE RESPONSIVE (Max width 768px) --- */
    @media screen and (max-width: 768px) {
        .madrasa-banner-wrapper {
            flex-direction: column;
            /* Stack elements vertically */
            height: auto;
            padding-bottom: 25px;
            text-align: center;
        }

        .madrasa-logo {
            width: 100%;
            height: auto;
            padding: 15px 0;
            margin-bottom: 15px;
        }

        .madrasa-logo img {
            height: 60px;
            /* Smaller logo on mobile */
        }

        .madrasa-content {
            padding: 0 15px;
            margin-bottom: 20px;
        }

        .madrasa-content h2 {
            font-size: 24px;
            /* Smaller title */
        }

        .madrasa-content p {
            font-size: 18px;
            /* Smaller subtitle */
        }

        .madrasa-cta-container {
            padding-left: 0;
            width: 100%;
            box-sizing: border-box;
            padding: 0 20px;
        }

        .madrasa-btn {
            width: 100%;
            /* Full width button */
            text-align: center;
            box-sizing: border-box;
            padding: 12px 0;
            font-size: 20px;
        }
    }
</style>

<section class="madrasa-banner-wrapper">
    <!-- Logo -->
    <div class="madrasa-logo">
        <img src="https://madrasafree.com/wp-content/uploads/2021/01/logo-1.png" alt="לוגו של מדרסה">
    </div>

    <!-- Text Content -->
    <div class="madrasa-content">
        <h2>מדרסה&nbsp;– לומדים לתקשר בערבית</h2>
        <p>קורסים לכל הרמות. <span>הירשמו עכשיו!</span></p>
    </div>

    <!-- CTA Button -->
    <div class="madrasa-cta-container">
        <a href="https://madrasafree.com" class="madrasa-btn">לפרטים והרשמה</a>
    </div>
</section>