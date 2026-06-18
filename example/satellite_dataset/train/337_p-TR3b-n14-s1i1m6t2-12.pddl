(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph4 - mode
	thermograph3 - mode
	thermograph0 - mode
	image1 - mode
	infrared2 - mode
	infrared5 - mode
	Star1 - direction
	Star0 - direction
	Phenomenon2 - direction
	Planet3 - direction
	Star4 - direction
	Phenomenon5 - direction
)
(:init
	(supports instrument0 infrared5)
	(supports instrument0 spectrograph4)
	(supports instrument0 image1)
	(supports instrument0 infrared2)
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph3)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet3)
)
(:goal (and
	(have_image Phenomenon2 thermograph3)
	(have_image Planet3 infrared5)
	(have_image Planet3 thermograph0)
	(have_image Star4 infrared5)
	(have_image Star4 image1)
	(have_image Phenomenon5 spectrograph4)
))

)
