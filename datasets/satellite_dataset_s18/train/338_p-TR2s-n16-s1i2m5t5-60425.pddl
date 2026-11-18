(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared1 - mode
	thermograph2 - mode
	spectrograph4 - mode
	infrared0 - mode
	infrared3 - mode
	GroundStation0 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation1 - direction
	Star5 - direction
	Phenomenon6 - direction
	Phenomenon7 - direction
	Phenomenon8 - direction
)
(:init
	(supports instrument0 spectrograph4)
	(supports instrument0 infrared3)
	(supports instrument0 infrared0)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon6)
)
(:goal (and
	(pointing satellite0 Phenomenon8)
	(have_image Star5 infrared0)
	(have_image Phenomenon6 infrared3)
	(have_image Phenomenon7 infrared3)
	(have_image Phenomenon8 infrared3)
))

)
