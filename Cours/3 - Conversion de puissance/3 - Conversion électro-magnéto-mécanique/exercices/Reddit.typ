#import "@local/prepa:0.1.1": *

#show: exercice.with(
    titre: "DIY motor isn't working, what is the problem with it?",
    explique: true,
)

A question was posted on Reddit about a DIY#footnote[Do it yourself.] motor that isn't functioning properly. The user provides a photo of the motor.



#grid(
    columns: (2fr, 1fr),
    figure(image("../images/reddit.png", width:8cm)),
    lien("https://www.reddit.com/r/diyelectronics/comments/1hbktoz/diy_motor_isnt_working_what_is_the_problem_with_it/")
)

#question(
    coups-de-pouce: (
        "Does the motor look like a synchronous or DC motor?",
        "What important part is missing for the motor to work?",
    )
)[
    Write a comment that you could post on Reddit to explain why the motor cannot work as shown in the photo.
][
    Your coil is fed with a direct current, and the current always flows the same way in it: there is no commutator. The magnet exerts a torque on the coil that tends to align the coil's magnetic moment with the magnet's field. So the coil turns at most half a turn, overshoots, comes back and stops in this equilibrium position, where the torque is zero. To keep it turning, the current has to be reversed, or at least cut, every half turn: that is the job of the brushes and commutator of a DC motor. The usual trick for this kind of motor is to scrape the enamel off only one half of one of the two axle leads (the other lead being scraped all around). The current then flows only during the half turn when the torque drives the coil forward, and the coil coasts through the other half turn thanks to its inertia.
]