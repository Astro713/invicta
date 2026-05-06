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
    <!-- <div class="row mt-5 justify-content-center">
        <div class="col text-center">
            <a href="#">
                <img src="images/ig_logo_1.png" alt="IG-Home" class="img-fluid" style="height: 250px; width: auto;">
            </a>
        </div>
    </div> -->

    <!-- <div id="welcome">
        <h1 id="index-h1" class="text-center mt-5 mb-3">IEEE IGARSS 2027</h1>
        <p class="mt-5 mb-3 text-light">Welcome to Reykjavík Iceland IGARSS 2027,</p>
        <p class="text-light mt-3 mb-5">The 2027 International Geoscience and Remote Sensing Symposium (IGARSS) will take place in <span class="ig-lime-text">Reykjavík, Iceland, on July 11-16 2027</span>. The flagship conference of the IEEE Geoscience and Remote Sensing Society (GRSS) is aimed at providing a platform for sharing knowledge and experience on recent developments and advancements in geoscience and remote sensing technologies, particularly in the context of earth observation, disaster monitoring and risk assessment.</p>
    </div> -->
    <div class="home-mobile-flow">
    <div class="home-tiktok-panel float-end col-12 col-md-4 col-lg-3 ms-4 mt-4">

        <div class="col">
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
        <p class="ig-index-font-h1 mb-3 text-start">Welcome to Invicta Cane Corso</p>

        
        <p class="text-start text-light">Invicta Cane Corso was established in the countryside of Hempstead, Texas, where Alexis and Brenda welcomed their first Cane Corso, Azula, in 2024. After falling in love with the breed's loyalty, confidence, strength, and natural protective instincts, they expanded their family in 2025 with Ozai after moving to Cypress, Texas. With Azula's strong European bloodline and Ozai's powerful American lineage, they founded Invicta Cane Corso with a commitment to raising well-tempered, confident puppies backed by exceptional AKC pedigree and placing them in loving, responsible homes.</p>

   
        <div class="float-start col-12 col-md-3 col-lg-3 me-4 mt-3 mb-5">

            <div class="col ">
            <img src="images/invictas_azula.jpg" class="img-fluid mx-auto d-block shadow" style="max-height: 375px; width: auto;">
            </div>
        </div>
        <p class="ig-index-font-h2 mt-5 ">Invicta's Azula</p>

        <p class="text-start text-light">Azula is a majestic Cane Corso who reflects the original standard of the breed with strength, balance, athleticism, and presence. Her bloodline is primarily European and includes respected pedigree influence from X-Man of Barcelona, Spain. She embodies the qualities that make the Cane Corso exceptional: powerful movement, intense drive, and reliable protective instincts. Whether in a family setting, on open land, or in a working environment, Azula carries herself with the awareness, loyalty, and purpose expected from a true Cane Corso.</p>
    </div>
        <hr class="mt-5 mb-5" style="border-color: transparent;">

        <div class="destination-section">
            <div class="container p-5">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <p class="ig-index-font-h2 mb-3">Mad River's Ozai</p>
                        <p class="text-white mb-3">Ozai represents the future of the Invicta Cane Corso program. Built from one of the strongest American bloodlines through Mad River Cane Corso in Ohio, he is young, composed, and already showing the natural confidence that defines a well-bred Cane Corso. At just 8 months old, Ozai stands 27 inches at the shoulder and weighs 110 pounds. His broad shoulders, powerful paws, strong head, and balanced structure are setting the tone for the quality, strength, and presence expected in future Invicta litters.</p>
                    </div>
                    <div class="col-md-6">
                        <img src="images/invictas_ozai.jpg" class="img-fluid mx-auto d-block" style="max-height: 375px; width: auto;">
                    </div>
                </div>
            </div>
        </div>

        <hr class="mt-5 mb-5" style="border-color: transparent;">
        
        <div class="row justify-content-center mt-5 mb-5">
        <div class="col-md-6 text-center">
            <a href="#">
                <img src="images/invicta_logo.png" alt="" class="img-fluid" style="max-height: 275px; width: auto;">
            </a>
        </div>
        </div>

</div>

<?php
// End Page Display
web_footer(['depth'=>1, 'fn'=>pathinfo(__FILE__, PATHINFO_BASENAME), 'footer_extras'=>null]);
?>