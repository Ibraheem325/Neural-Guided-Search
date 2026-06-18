(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	thermograph2 - mode
	image1 - mode
	spectrograph0 - mode
	Star0 - direction
	Star1 - direction
	Planet2 - direction
	Phenomenon3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 spectrograph0)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 Star0)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon3)
)
(:goal (and
	(have_image Star1 thermograph2)
	(have_image Planet2 image1)
	(have_image Phenomenon3 image1)
	(have_image Star4 thermograph2)
))

)
