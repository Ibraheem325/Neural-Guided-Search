(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	infrared3 - mode
	thermograph1 - mode
	image4 - mode
	infrared2 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation6 - direction
	Star7 - direction
	Star12 - direction
	Star13 - direction
	Planet14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared2)
	(supports instrument0 image4)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation3)
)
(:goal (and
	(pointing satellite0 GroundStation10)
	(have_image Star12 image4)
	(have_image Star13 infrared3)
	(have_image Planet14 spectrograph0)
	(have_image Planet15 thermograph1)
))

)
