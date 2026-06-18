(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	infrared2 - mode
	thermograph1 - mode
	infrared3 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	GroundStation5 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star10 - direction
	GroundStation11 - direction
	Star12 - direction
	Star3 - direction
	Star4 - direction
	Star6 - direction
	Star9 - direction
	Star13 - direction
	Planet14 - direction
	Star15 - direction
	Star16 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star13)
)
(:goal (and
	(have_image Star13 infrared3)
	(have_image Planet14 spectrograph0)
	(have_image Star15 infrared3)
	(have_image Star16 infrared3)
))

)
