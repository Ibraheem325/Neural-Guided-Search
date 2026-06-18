(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image1 - mode
	thermograph3 - mode
	infrared5 - mode
	infrared2 - mode
	thermograph0 - mode
	spectrograph4 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	Phenomenon9 - direction
	Planet10 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph4)
	(supports instrument0 infrared5)
	(supports instrument0 thermograph3)
	(calibration_target instrument0 Star6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(pointing satellite0 Star1)
	(have_image Star7 infrared2)
	(have_image Star8 thermograph3)
	(have_image Phenomenon9 thermograph3)
	(have_image Phenomenon9 infrared2)
	(have_image Planet10 thermograph3)
	(have_image Planet10 infrared5)
))

)
