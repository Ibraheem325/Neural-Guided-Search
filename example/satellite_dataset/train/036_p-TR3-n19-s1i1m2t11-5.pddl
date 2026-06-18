(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	infrared1 - mode
	GroundStation0 - direction
	Star1 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star7 - direction
	Star8 - direction
	GroundStation10 - direction
	GroundStation9 - direction
	Star2 - direction
	Star6 - direction
	Planet11 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 image0)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 GroundStation9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(have_image Planet11 image0)
	(have_image Planet12 image0)
	(have_image Phenomenon13 infrared1)
	(have_image Phenomenon14 image0)
))

)
