(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared5 - mode
	image1 - mode
	thermograph0 - mode
	thermograph3 - mode
	spectrograph4 - mode
	infrared2 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Phenomenon5 - direction
	Phenomenon6 - direction
	Planet7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph3)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph4)
	(supports instrument0 infrared5)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet7)
)
(:goal (and
	(have_image Phenomenon5 spectrograph4)
	(have_image Phenomenon6 image1)
	(have_image Planet7 infrared2)
	(have_image Planet7 thermograph3)
	(have_image Star8 thermograph0)
	(have_image Star8 infrared5)
))

)
