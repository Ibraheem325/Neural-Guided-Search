(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph2 - mode
	spectrograph1 - mode
	spectrograph0 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	Star3 - direction
	Star5 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	Star10 - direction
	Star11 - direction
	Star12 - direction
	Star13 - direction
	Star14 - direction
	Star15 - direction
	GroundStation16 - direction
	Star17 - direction
	Star18 - direction
	GroundStation19 - direction
	GroundStation20 - direction
	GroundStation21 - direction
	Star22 - direction
	GroundStation23 - direction
	GroundStation24 - direction
	GroundStation25 - direction
	Star26 - direction
	Star27 - direction
	Star28 - direction
	Star4 - direction
	Star29 - direction
	Planet30 - direction
	Star31 - direction
	Phenomenon32 - direction
	Star33 - direction
	Planet34 - direction
	Planet35 - direction
	Star36 - direction
	Phenomenon37 - direction
	Planet38 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation24)
)
(:goal (and
	(pointing satellite0 Planet30)
	(have_image Star29 spectrograph0)
	(have_image Planet30 spectrograph0)
	(have_image Star31 spectrograph0)
	(have_image Phenomenon32 spectrograph0)
	(have_image Star33 spectrograph1)
	(have_image Planet34 spectrograph1)
	(have_image Planet35 spectrograph2)
	(have_image Star36 spectrograph1)
	(have_image Phenomenon37 spectrograph2)
	(have_image Planet38 spectrograph1)
))

)
