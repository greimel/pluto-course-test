Dict(
    :main => [
        "welcome" => collections["welcome"].pages,
        #"Preliminaries" => collections["preliminaries"].pages,
        "Module 1: Mathematical Preliminaries" => collections["mathematics"].pages,
        "Module 2: Microeconomics" => collections["microeconomics"].pages,

    ],
    :about => Dict(
        :authors => [
            (name = "Fabian Greimel", url = "https://www.greimel.eu"),
            (name = "Second Instructor", url = "https://www.the-second.com")
        ],
        :title => "Microeconomics for AE",
        :subtitle => "BSc Econometrics | BSc Business Analytics",
        :term => "Fall 2023",
        :institution => "University of Amsterdam",
        :institution_url => "http://www.uva.nl",
        :institution_logo => "uva-logo.svg",
       # :institution_logo_darkmode => "julia-logo-dark.svg"
    )
)