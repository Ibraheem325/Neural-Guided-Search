(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared5 - mode
	infrared2 - mode
	thermograph0 - mode
	thermograph3 - mode
	spectrograph4 - mode
	image1 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star5 - direction
	Star9 - direction
	Star10 - direction
	Phenomenon11 - direction
	Phenomenon12 - direction
)
(:init
	(supports instrument0 spectrograph4)
	(supports instrument0 image1)
	(supports instrument0 thermograph3)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared2)
	(supports instrument0 infrared5)
	(calibration_target instrument0 Star5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(pointing satellite0 Star0)
	(have_image Star9 image1)
	(have_image Star10 thermograph0)
	(have_image Phenomenon11 thermograph3)
	(have_image Phenomenon11 image1)
	(have_image Phenomenon12 infrared2)
	(have_image Phenomenon12 thermograph3)
))

)
