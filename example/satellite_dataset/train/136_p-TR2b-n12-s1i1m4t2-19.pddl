(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	image1 - mode
	infrared3 - mode
	image0 - mode
	Star0 - direction
	GroundStation1 - direction
	Phenomenon2 - direction
	Phenomenon3 - direction
	Planet4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 image0)
	(supports instrument0 image1)
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon3)
)
(:goal (and
	(pointing satellite0 Star0)
	(have_image Phenomenon2 infrared3)
	(have_image Phenomenon3 infrared2)
	(have_image Planet4 image1)
	(have_image Planet5 infrared3)
))

)
