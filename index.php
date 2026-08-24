<?php
require_once('CommonFiles/_config.php');

// $targetDate = strtotime("2024-07-07");
// $today = time();
// $difference = $targetDate - $today;
// $days = floor($difference / (60 * 60 * 24));

// echo '<link href="css/flipdown.min.css" rel="stylesheet">';
// $h = file_get_contents('important_dates.inc');

// $header_extras = <<<HTML
// <style>
// #sidebarToast {
//     position: fixed;
//     top: 40%;
//     left: 0;
//     transform: translate(0, -45%);
//     width: 350px;
//     z-index: 1050;
// }
// </style>
// HTML;

// $footer_extras = <<<HTML
// <script>
// document.addEventListener('DOMContentLoaded', function() {
//     var toastEl = document.getElementById('sidebarToast');
//     var toast = new bootstrap.Toast(toastEl, { autohide: false });
//     toast.show();
// });
// </script>
// HTML;


// Start Page Display
web_header([
    'depth'=>1,
    'fn'=>pathinfo(__FILE__, PATHINFO_BASENAME),
    'page_title'=>'Houston-Area Cane Corso Breeder | Invicta Cane Corso',
    'canonical_path'=>'/',
    'auth_needed'=>$config['auth']['enabled'],
    'header_extras'=>null,
]);
?>

<div class="container mt-5">

<div class="row home-mobile-flow align-items-center mb-5 mt-4">
    <div class="home-intro-panel col-md-7 mt-4">
        <div class="home-intro-copy">
            <h1 class="ig-index-font-h1 mb-4 text-center">Welcome to Invicta Cane Corso</h1>
            <p class="text-center text-light"><span class="invicta-rg-text">Invicta Cane Corso</span> is a Cane Corso breeding program located in Cypress, Texas, serving families throughout Greater Houston and across the United States through our <a href="puppies.php#flight-nanny" class="text-light text-decoration-underline">domestic flight nanny delivery service</a>. We are dedicated to raising true, well-balanced Cane Corsos with the strength, temperament, and presence that define the breed. Built on carefully selected <span class="invicta-rg-text">European &amp; American bloodlines</span>, our program focuses on thoughtful pairings, hands-on care, and placing each puppy with a responsible home prepared for the loyalty, power, and purpose of a true Cane Corso.</p>
            <div class="text-center mt-4 mb-4">
                <a href="about.php" class="btn btn-outline-secondary text-white border-secondary">More About Us</a>
            </div>
        </div>
    </div>
    <div class="home-tiktok-panel col-md-5 mt-4">
        <div class="home-tiktok-embed">
            <iframe
                class="tiktok-player"
                src="https://www.tiktok.com/player/v1/7613355033131863326?rel=0&loop=1&description=0&music_info=0"
                title="TikTok video by @azulathecanecorso"
                loading="lazy"
                allow="autoplay; encrypted-media; fullscreen; picture-in-picture"
                allowfullscreen>
            </iframe>

            <!--
            <iframe
                class="instagram-player"
                src="https://www.instagram.com/reel/DVcgdjyERx-/embed/"
                title="Instagram reel by @azulathecanecorso"
                loading="lazy"
                allow="autoplay; encrypted-media; fullscreen; picture-in-picture"
                allowfullscreen>
            </iframe>
            -->

        </div>
    </div>
</div>

<hr class="mt-5 mb-5" style="border-color: transparent;">

<div class="destination-section">
    <div class="container p-5">
        <div class="row align-items-center">
            <div class="col-md-6 mt-3">
                <img src="images/invictas_ozai.jpg" alt="Mad River's Ozai, a Cane Corso at Invicta Cane Corso in Cypress, Texas" class="img-fluid mx-auto d-block rounded-3 shadow-lg" style="max-height: 425px; width: auto;">
            </div>
            <div class="col-md-6 mt-3">
                <h2 class="ig-index-font-h2 text-center mb-3">Upcoming Cane Corso Litter</h2>
                <p class="text-white text-center mb-3">We are expecting a litter from <a href="dogs.php#azula" class=" text-decoration-underline">Invicta's Azula</a> and <a href="dogs.php#ozai" class=" text-decoration-underline">Mad River's Ozai</a> near the beginning of 2027. Stay tuned for updates as we get closer, and follow our social media pages for the latest news, announcements, and puppy updates from Invicta Cane Corso.</p>
                <div class="social-media text-center mt-4 mb-4">
                    <a target="_blank" rel="noopener" href="https://www.tiktok.com/@azulathecanecorso" class="text-white mx-2" aria-label="Invicta Cane Corso on TikTok"><i class="bi bi-tiktok fs-custom"></i></a>
                    <a target="_blank" rel="noopener" href="https://www.instagram.com/azulathecanecorso/" class="text-white mx-2" aria-label="Invicta Cane Corso on Instagram"><i class="bi bi-instagram fs-custom"></i></a>
                    <a href="mailto:info@invictacanecorso.com" class="text-white mx-2" aria-label="Email Invicta Cane Corso"><i class="bi bi-envelope fs-custom"></i></a>
                </div>
                <div class="text-center mt-4 mb-4">
                    <a href="puppies.php" class="btn btn-outline-dark text-white border-dark">Available Puppies</a>
                </div>
            </div>
        </div>
    </div>
</div>

<hr class="mt-5" style="border-color: transparent;">

<section class="row justify-content-center mt-5 mb-5" aria-labelledby="service-area-heading">
    <div class="col-md-8 text-center">
        <h2 id="service-area-heading" class="ig-index-font-h2 mb-3">Serving Greater Houston and Families Across the United States</h2>
        <p class="text-light">Our Cane Corso breeding program is based in Cypress, Texas, northwest of Houston. We serve responsible homes throughout Greater Houston, across Texas, and elsewhere in the United States through our <a href="puppies.php#flight-nanny" class="text-light text-decoration-underline">domestic flight nanny delivery service</a>. Every placement remains focused on the needs of the dog and the preparedness of the family.</p>
    </div>
</section>

<hr class="mt-5 mb-5" style="border-color: transparent;">

<div class="row justify-content-center mt-5 mb-5">
    <div class="col-md-6 text-center">
        <a href="/" aria-label="Invicta Cane Corso home">
            <img src="images/invicta_logo_master.png" alt="Invicta Cane Corso" class="img-fluid index-logo">
        </a>
    </div>
</div>

</div>

<?php
// End Page Display
web_footer(['depth'=>1, 'fn'=>pathinfo(__FILE__, PATHINFO_BASENAME), 'footer_extras'=>null]);
?>
