(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	GroundStation9 - direction
	GroundStation11 - direction
	GroundStation10 - direction
	GroundStation5 - direction
	Star7 - direction
	Star8 - direction
	Star12 - direction
	Star13 - direction
	Planet14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 GroundStation10)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation5)
)
(:goal (and
	(have_image Star12 image0)
	(have_image Star13 image0)
	(have_image Planet14 image0)
	(have_image Phenomenon15 image0)
))

)
