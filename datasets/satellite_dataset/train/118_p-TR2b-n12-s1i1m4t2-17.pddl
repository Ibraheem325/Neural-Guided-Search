(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared1 - mode
	infrared2 - mode
	spectrograph0 - mode
	thermograph3 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	Star3 - direction
	Phenomenon4 - direction
	Star5 - direction
)
(:init
	(supports instrument0 thermograph3)
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared2)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(have_image Star2 thermograph3)
	(have_image Star3 spectrograph0)
	(have_image Phenomenon4 thermograph3)
	(have_image Star5 infrared1)
))

)
