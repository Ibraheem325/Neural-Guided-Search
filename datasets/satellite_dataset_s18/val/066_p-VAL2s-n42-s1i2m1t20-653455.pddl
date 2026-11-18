(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation7 - direction
	Star8 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	Star12 - direction
	Star13 - direction
	GroundStation14 - direction
	GroundStation15 - direction
	GroundStation17 - direction
	GroundStation18 - direction
	Star19 - direction
	Star16 - direction
	GroundStation9 - direction
	GroundStation6 - direction
	Phenomenon20 - direction
	Star21 - direction
	Phenomenon22 - direction
	Star23 - direction
	Star24 - direction
	Phenomenon25 - direction
	Planet26 - direction
	Planet27 - direction
	Phenomenon28 - direction
	Planet29 - direction
	Planet30 - direction
	Phenomenon31 - direction
	Star32 - direction
	Star33 - direction
	Star34 - direction
	Planet35 - direction
	Planet36 - direction
	Planet37 - direction
	Phenomenon38 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 Star16)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon22)
)
(:goal (and
	(pointing satellite0 GroundStation15)
	(have_image Phenomenon20 image0)
	(have_image Star21 image0)
	(have_image Phenomenon22 image0)
	(have_image Star23 image0)
	(have_image Star24 image0)
	(have_image Phenomenon25 image0)
	(have_image Planet26 image0)
	(have_image Planet27 image0)
	(have_image Phenomenon28 image0)
	(have_image Planet29 image0)
	(have_image Planet30 image0)
	(have_image Phenomenon31 image0)
	(have_image Star32 image0)
	(have_image Star33 image0)
	(have_image Star34 image0)
	(have_image Planet35 image0)
	(have_image Planet36 image0)
	(have_image Planet37 image0)
	(have_image Phenomenon38 image0)
))

)
