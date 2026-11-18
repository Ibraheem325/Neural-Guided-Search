(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph3 - mode
	spectrograph0 - mode
	infrared1 - mode
	infrared2 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Star2 - direction
	Star4 - direction
	Star5 - direction
	GroundStation3 - direction
	Star6 - direction
	Phenomenon7 - direction
	Phenomenon8 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph0)
	(supports instrument0 thermograph3)
	(calibration_target instrument0 GroundStation3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
)
(:goal (and
	(have_image Star6 infrared2)
	(have_image Phenomenon7 infrared1)
	(have_image Phenomenon8 thermograph3)
))

)
