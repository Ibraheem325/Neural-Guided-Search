(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image2 - mode
	infrared0 - mode
	infrared1 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation9 - direction
	Star11 - direction
	Star12 - direction
	GroundStation13 - direction
	GroundStation14 - direction
	Star15 - direction
	GroundStation16 - direction
	Star17 - direction
	GroundStation5 - direction
	Star8 - direction
	Star10 - direction
	GroundStation2 - direction
	Planet18 - direction
	Phenomenon19 - direction
	Planet20 - direction
	Phenomenon21 - direction
	Planet22 - direction
	Phenomenon23 - direction
	Phenomenon24 - direction
	Phenomenon25 - direction
	Planet26 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 image2)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 Star10)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 GroundStation5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon19)
)
(:goal (and
	(have_image Planet18 infrared0)
	(have_image Phenomenon19 infrared0)
	(have_image Planet20 image2)
	(have_image Phenomenon21 image2)
	(have_image Planet22 infrared0)
	(have_image Phenomenon23 infrared0)
	(have_image Phenomenon24 image2)
	(have_image Phenomenon25 image2)
	(have_image Planet26 infrared1)
))

)
