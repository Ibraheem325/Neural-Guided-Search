(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph4 - mode
	image3 - mode
	spectrograph1 - mode
	infrared2 - mode
	infrared0 - mode
	Star0 - direction
	GroundStation1 - direction
	Star3 - direction
	GroundStation2 - direction
	Star4 - direction
	Phenomenon5 - direction
	Phenomenon6 - direction
	Phenomenon7 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared0)
	(supports instrument0 infrared2)
	(supports instrument0 image3)
	(supports instrument0 thermograph4)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(pointing satellite0 GroundStation2)
	(have_image Star4 thermograph4)
	(have_image Phenomenon5 image3)
	(have_image Phenomenon6 infrared2)
	(have_image Phenomenon7 image3)
))

)
