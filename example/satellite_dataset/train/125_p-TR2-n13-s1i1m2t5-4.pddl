(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared1 - mode
	thermograph0 - mode
	Star0 - direction
	Star1 - direction
	Star3 - direction
	Star4 - direction
	GroundStation2 - direction
	Planet5 - direction
	Planet6 - direction
	Phenomenon7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
)
(:goal (and
	(pointing satellite0 GroundStation2)
	(have_image Planet5 infrared1)
	(have_image Planet6 infrared1)
	(have_image Phenomenon7 thermograph0)
	(have_image Star8 infrared1)
))

)
