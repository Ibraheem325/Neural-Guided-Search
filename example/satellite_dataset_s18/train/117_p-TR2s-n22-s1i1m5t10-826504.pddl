(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph2 - mode
	infrared0 - mode
	infrared4 - mode
	infrared1 - mode
	infrared3 - mode
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	Star7 - direction
	Star8 - direction
	Star9 - direction
	Star5 - direction
	GroundStation1 - direction
	GroundStation0 - direction
	Phenomenon10 - direction
	Phenomenon11 - direction
	Planet12 - direction
	Star13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 infrared0)
	(supports instrument0 spectrograph2)
	(supports instrument0 infrared3)
	(supports instrument0 infrared4)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 Star5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(have_image Phenomenon10 infrared0)
	(have_image Phenomenon11 infrared3)
	(have_image Planet12 infrared4)
	(have_image Star13 infrared3)
	(have_image Planet14 infrared4)
))

)
