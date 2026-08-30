#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Diy motor isn't working, what is the problem with it ?",
    ouvert: true,
)

A question was posted on Reddit about a DIY#footnote[Do it yourself.] motor that isn't functioning properly. The user provides a photo of the motor.



#grid(
    columns: (2fr, 1fr),
    figure(image("../images/reddit.png", width:8cm)),
    lien("https://www.reddit.com/r/diyelectronics/comments/1hbktoz/diy_motor_isnt_working_what_is_the_problem_with_it/")
)

#question(
    coups-de-pouce: (
        "Does the motor looks like a synchronous or DC motor?",
        "What important part is missing for the motor to work?",
    )
)[
    Write a comment that you could post on Reddit to explain why the motor cannot work as shown in the photo.
]