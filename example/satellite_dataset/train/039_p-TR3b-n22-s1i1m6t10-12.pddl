(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	spectrograph4 - mode
	thermograph3 - mode
	thermograph0 - mode
	infrared5 - mode
	image1 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation3 - direction
	Planet10 - direction
	Phenomenon11 - direction
	Star12 - direction
	Planet13 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 infrared5)
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph3)
	(supports instrument0 spectrograph4)
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation3)
)
(:goal (and
	(pointing satellite0 Star6)
	(have_image Planet10 infrared5)
	(have_image Phenomenon11 spectrograph4)
	(have_image Star12 infrared2)
	(have_image Planet13 image1)
))

)
