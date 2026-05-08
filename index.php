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
web_header(['depth'=>1, 'fn'=>pathinfo(__FILE__, PATHINFO_BASENAME), 'title'=>null, 'auth_needed'=>$config['auth']['enabled'], 'header_extras'=>null]);
?>

<div class="container mt-5">


<p class="ig-index-font-h1 mb-3 text-center">Welcome to Invicta Cane Corso</p>

<div class="row home-mobile-flow align-items-center mb-5 mt-4">
    <div class="home-intro-panel col-md-6 mt-4">
        <div class="home-intro-copy">
            <p class="text-center text-light">Invicta Cane Corso is dedicated to raising true, well-balanced Cane Corsos with the strength, temperament, and presence that define the breed. Built on carefully selected European and American bloodlines, our program focuses on thoughtful pairings, hands-on care, and placing each puppy with a responsible home prepared for the loyalty, power, and purpose of a true Cane Corso.</p>
            <div class="text-center mt-4 mb-4">
                <a href="about.php" class="btn btn-outline-secondary text-white border-secondary">More About Us</a>
            </div>
        </div>
    </div>
    <div class="home-tiktok-panel col-md-6 mt-4">
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
                <img src="images/invictas_ozai.jpg" class="img-fluid mx-auto d-block" style="max-height: 375px; width: auto;">
            </div>
            <div class="col-md-6 mt-3">
                <p class="ig-index-font-h2 text-center mb-3">Upcoming Litter</p>
                <p class="text-white text-center mb-3">We are expecting a litter from <a href="dogs.php#azula" class="text-white text-decoration-underline">Invicta's Azula</a> and <a href="dogs.php#ozai" class="text-white text-decoration-underline">Mad River's Ozai</a> near the end of 2026. Stay tuned for updates as we get closer, and follow our social media pages for the latest news, announcements, and puppy updates from Invicta Cane Corso.</p>
                <div class="social-media text-center mt-4 mb-4">
                    <a target="_blank" rel="noopener" href="https://www.tiktok.com/@azulathecanecorso" class="text-white mx-2" aria-label="Invicta Cane Corso on TikTok"><i class="bi bi-tiktok fs-custom"></i></a>
                    <a target="_blank" rel="noopener" href="https://www.instagram.com/azulathecanecorso/" class="text-white mx-2" aria-label="Invicta Cane Corso on Instagram"><i class="bi bi-instagram fs-custom"></i></a>
                </div>
                <div class="text-center mt-4 mb-4">
                    <a href="puppies.php" class="btn btn-outline-secondary text-white border-secondary">Available Puppies</a>
                </div>
            </div>
        </div>
    </div>
</div>

<hr class="mt-5 mb-5" style="border-color: transparent;">
<hr class="mt-5 mb-5" style="border-color: transparent;">

<div class="row justify-content-center mt-5 mb-5">
    <div class="col-md-6 text-center">
        <a href="#">
            <img src="images/invicta_logo.png" alt="" class="img-fluid index-logo">
        </a>
    </div>
</div>

</div>

<?php
// End Page Display
web_footer(['depth'=>1, 'fn'=>pathinfo(__FILE__, PATHINFO_BASENAME), 'footer_extras'=>null]);
?>