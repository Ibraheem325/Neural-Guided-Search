(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared1 - mode
	thermograph0 - mode
	Star0 - direction
	GroundStation2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	Star11 - direction
	Star12 - direction
	GroundStation13 - direction
	Star10 - direction
	Star1 - direction
	Star14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star10)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation7)
)
(:goal (and
	(have_image Star14 thermograph0)
	(have_image Phenomenon15 infrared1)
	(have_image Phenomenon16 thermograph0)
	(have_image Planet17 infrared1)
))

)
