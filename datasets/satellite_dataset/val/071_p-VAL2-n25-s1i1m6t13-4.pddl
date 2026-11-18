(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	infrared1 - mode
	image5 - mode
	infrared4 - mode
	image3 - mode
	infrared2 - mode
	Star0 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation12 - direction
	GroundStation6 - direction
	GroundStation8 - direction
	Star7 - direction
	Star1 - direction
	Planet13 - direction
	Planet14 - direction
	Star15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 image5)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared2)
	(supports instrument0 image3)
	(supports instrument0 infrared4)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation12)
)
(:goal (and
	(have_image Planet13 infrared1)
	(have_image Planet13 infrared2)
	(have_image Planet14 image5)
	(have_image Star15 thermograph0)
	(have_image Phenomenon16 thermograph0)
))

)
