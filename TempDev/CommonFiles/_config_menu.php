<?php

/*

[
  // Root Menu Structure

  [
    // Top Level Menu Item
    0=>'Display Text', 1=>'Destination link', 2=>null, 3=>false, 4=>['List Item class',...], 5=>['Anchor class',...]
  ],
   OR
  [
    // Top Level Menu with Drop-down
    0=>'Display Text', 1=>null, 2=>[
      // Sub-Menu Items
      [ 0=>'Display Text', 1=>'Destination link', 2=>false, 3=>['List Item class',...], 4=>['Anchor class',...]]
    ], 3=>false, 4=>['List Item class',...], 5=>['Anchor class',...]
  ],

]

*/

function get_menu()
{
  return [

      ["Home Page", "index.php", null, false, [], [] ],

  //   [ "Home Page", null, [
  //     ["Welcome",                   "index.php", null, [], []],
  //     ["Organizing Committee", "organizing_committee.php", false, [], []],
  //     ["Welcome Video",                  "index.php#welcomevideo", null, [], []],
  //     ["Community Partners",                       "index.php#partners", null, [], []],
  //     ["Acknowledgement",          "index.php#acknowledgment", null, [], []],
  //     ["Important Dates",                   "index.php#importantdates", null, [], []],
  //     ["Notable Deadlines",                 "index.php#info-boxes", null, [], []],
  //     ["News & Media",                      "index.php#news", null, [], []  ],
  //     ["Contacts",                          "contact.php", null, [], [] ],
  //     ["Social Media",                      "index.php#socialmedia", null, [], [] ],
  //     ["Policies",                          "policy.php", null, [], [] ],
  // ], null, [], []  ],


    // [ "General", null, [
    //   ["Welcome Message", "index.php", false, [], []],
    //   ["Organizing Committee", "organizing_committee.php", false, [], []],
    //   ["Diversity, Equity, Inclusion,<br> Access & Belonging", "dei_equity.php", false, [], []],
    //   ["Important Dates", "important_dates.php", false, [], [] ],
    //   ["Contacts", "contacts.php", false, [], [] ],
    //   ["Privacy and Non-Discrimination", "privacy-non-discrimination.php", false, [], [] ],
    // ], false, [], []  ],

    // [ "Registration", null, [
    //   // ["Registration", "registration.php", false, [], [] ],
    //   ["Visa Information", "visa_information.php", false, [], [] ],
    // ], false, [], []  ],

    // [ "Tutorial Proposals",                   "tutorial_proposals.php", null, false, [], [] ],
    // [ "Technical Program", 'technical_program.php', null, false, [], [] ],

    // [ "Paper Submission", null, [
    //   ["Submit a Paper", "papers.php", false, [], [] ],
    //   ["Check Submission Status", "Papers/FindPaperStatus.asp", false, [], [] ],
    // ], false, [], []  ],

    // [ "Travel & Venue", null, [
    //   ["Pasadena", "pasadena.php", false, [], [] ],
    //   ["Event Venue", "venue.php", false, [], [] ],
    //   ["Accommodation", "accommodation.php", false, [], [] ],
    //   ["Travel to Pasadena", "travel.php", false, [], [] ],
    //   ["About Kuala Lumpur", "kuala_lumpur.php", false, [], [] ],
    //   ["Travel to Kuala Lumpur", "travel.php", false, [], [] ],
    //   ["Travel in Kuala Lumpur", "transportation.php", false, [], [] ],
    //   ["Visa Requirements", "visa.php", false, [], [] ],
    // ], false, [], []  ],

    // ["Important Dates", "important_dates.php", null, false, [], [] ],

    // [ "Program", null, [
    //   ["Paper Submission", "paper_submission.php", false, [], [] ],
    //   ["Technical Themes", "topics.php", false, [], []],
    //   ["Community-Contributed Themes", "community_contributed_themes.php", false, [], []],
    //   ["Community-Contributed Theme Proposals", "cct_proposal.php", false, [], []],
    //   ["Tutorial Proposals", "tutorial_proposals.php", null, [], []],
    //   ["Call for Papers", "call_for_papers.php", false, [], [] ],
    //   ["Abstract Submission", "papers.php", false, [], [] ],
    //   ["Student Paper Competition", "spc.php", false, [], [] ],
    // ], false, [], []  ],

    // [ "For Authors", null, [
    //   ["Call for Papers", "call_for_papers.php", false, [], [] ],
    //   ["Paper Submission", "paper_submission.php", false, [], [] ],
    //   ["Technical Themes", "topics.php", false, [], []],
    //   ["Community-Contributed Themes", "community_contributed_sessions.php", false, [], []],
    //   ["Community-Contributed Theme Proposals", "cct_proposal.php", false, [], []],
    //   ["Abstract Submission", "papers.php", false, [], [] ],
    // ], false, [], []  ],

    // [ "For Students", null, [
    //   ["Student Paper Competition", "spc.php", false, [], [] ],
    //   ["CSA Canadian Student Grant", "csa_grant.php", false, [], [] ],
    // ], false, [], []  ],

    // [ "Sponsorship & Exhibition", "PatronReg.asp", null, false, [], []  ],

    // [ "Destination", null, [
    //   ["The Venue", "venue.php", null, [], []],
    //   ["The City", "brisbane.php", null, [], []],
    //   ["Travel & Stay", "transport.php", false, [], [] ],
    //   ["Family Services & Activities", "family_services.php", false, [], [] ],
    //   ["Accommodation", "accommodation.php", false, [], [] ],
    //   ["Social Life", "social_life.php", false, [], [] ],
    //   ["Queensland the State", "tours.php", false, [], [] ],
    //   ["Visa Information", "visa_information.php", false, [], [] ],
    // ], null, [], []  ],

    // [ "Sponsors/Exhibitors", null, [
    //   ["Become A Sponsor/Exhibitor", "become_a_sponsor_or_exhibitor.php", null, [], []],
    // ], null, [], []  ],

    // [ "Registration", "registration.php", null, false, [], []  ],

    // [ "Social Programs", null, [
    //   ["Malaysia Truly Asia", "malaysia_truly_asia.php", false, [], [] ],
    // ], false, [], []  ],

    // [ "Summer School", null, [
    //   ["Programme", "summerschool_programme.php", false, [], [] ],
    //   ["Venue & Accommodation", "summerschool_venue.php", false, [], [] ],
    //   ["Registration", "summerschool_registration.php", false, [], [] ],
    //   ["Contact", "summerschool_contact.php", false, [], [] ],
    // ], false, [], []  ],

    // [ "Social Programme", null, [
    //   ["Programme", "socialprogramme.php", false, [], [] ],
    //   ["Registration", "socialprogramme_registration.php", false, [], [] ],
    //   ["Contact", "socialprogramme_contact.php", false, [], [] ],
    // ], false, [], []  ],

    // ['Test', 'test.php', null, null, [], [] ],

  ];
}
?>