(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph1 - mode
	infrared3 - mode
	image4 - mode
	spectrograph0 - mode
	infrared2 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	Star4 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation10 - direction
	Star11 - direction
	Star12 - direction
	Star5 - direction
	GroundStation13 - direction
	Star2 - direction
	Planet14 - direction
	Planet15 - direction
	Planet16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph0)
	(supports instrument0 image4)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 GroundStation13)
	(calibration_target instrument0 Star5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation8)
)
(:goal (and
	(pointing satellite0 Star11)
	(have_image Planet14 infrared2)
	(have_image Planet15 image4)
	(have_image Planet16 image4)
	(have_image Phenomenon17 image4)
))

)
