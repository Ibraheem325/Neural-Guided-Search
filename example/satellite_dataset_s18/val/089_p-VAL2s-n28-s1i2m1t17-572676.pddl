(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	image0 - mode
	Star2 - direction
	Star5 - direction
	GroundStation7 - direction
	Star9 - direction
	GroundStation12 - direction
	Star13 - direction
	GroundStation14 - direction
	GroundStation15 - direction
	GroundStation10 - direction
	GroundStation4 - direction
	Star8 - direction
	Star6 - direction
	GroundStation3 - direction
	GroundStation11 - direction
	Star1 - direction
	Star16 - direction
	GroundStation0 - direction
	Planet17 - direction
	Star18 - direction
	Phenomenon19 - direction
	Star20 - direction
	Star21 - direction
	Phenomenon22 - direction
	Phenomenon23 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation11)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation0)
	(calibration_target instrument1 Star16)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 GroundStation11)
	(calibration_target instrument1 GroundStation3)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon23)
)
(:goal (and
	(have_image Planet17 image0)
	(have_image Star18 image0)
	(have_image Phenomenon19 image0)
	(have_image Star20 image0)
	(have_image Star21 image0)
	(have_image Phenomenon22 image0)
	(have_image Phenomenon23 image0)
))

)
