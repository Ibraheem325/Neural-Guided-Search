(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	thermograph0 - mode
	spectrograph4 - mode
	image1 - mode
	thermograph3 - mode
	infrared5 - mode
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star0 - direction
	Planet4 - direction
	Star5 - direction
	Phenomenon6 - direction
	Star7 - direction
)
(:init
	(supports instrument0 thermograph3)
	(supports instrument0 infrared5)
	(supports instrument0 image1)
	(supports instrument0 spectrograph4)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet4)
)
(:goal (and
	(have_image Planet4 thermograph0)
	(have_image Planet4 infrared5)
	(have_image Star5 spectrograph4)
	(have_image Phenomenon6 image1)
	(have_image Phenomenon6 thermograph3)
	(have_image Star7 infrared2)
))

)
