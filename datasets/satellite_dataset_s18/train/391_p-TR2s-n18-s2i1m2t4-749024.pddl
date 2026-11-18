(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	spectrograph1 - mode
	thermograph0 - mode
	Star0 - direction
	Star3 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	Star4 - direction
	Planet5 - direction
	Planet6 - direction
	Planet7 - direction
	Star8 - direction
	Planet9 - direction
	Planet10 - direction
	Phenomenon11 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation2)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation2)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet6)
)
(:goal (and
	(have_image Star4 thermograph0)
	(have_image Planet5 thermograph0)
	(have_image Planet6 thermograph0)
	(have_image Planet7 thermograph0)
	(have_image Star8 spectrograph1)
	(have_image Planet9 thermograph0)
	(have_image Planet10 thermograph0)
	(have_image Phenomenon11 thermograph0)
))

)
