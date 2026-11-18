(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image3 - mode
	thermograph0 - mode
	thermograph2 - mode
	image1 - mode
	spectrograph4 - mode
	Star0 - direction
	GroundStation1 - direction
	Planet2 - direction
	Phenomenon3 - direction
	Star4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 image3)
	(supports instrument0 spectrograph4)
	(supports instrument0 image1)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(have_image Planet2 image3)
	(have_image Phenomenon3 thermograph2)
	(have_image Star4 image3)
	(have_image Planet5 spectrograph4)
))

)
