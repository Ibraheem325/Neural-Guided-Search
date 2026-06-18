(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph3 - mode
	image1 - mode
	thermograph0 - mode
	spectrograph4 - mode
	infrared2 - mode
	Star0 - direction
	Star2 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	GroundStation3 - direction
	GroundStation1 - direction
	Star7 - direction
	Planet8 - direction
	Phenomenon9 - direction
	Planet10 - direction
)
(:init
	(supports instrument0 thermograph3)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph4)
	(supports instrument0 thermograph0)
	(supports instrument0 image1)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet10)
)
(:goal (and
	(pointing satellite0 Phenomenon9)
	(have_image Star7 thermograph0)
	(have_image Planet8 infrared2)
	(have_image Phenomenon9 image1)
	(have_image Planet10 infrared2)
))

)
