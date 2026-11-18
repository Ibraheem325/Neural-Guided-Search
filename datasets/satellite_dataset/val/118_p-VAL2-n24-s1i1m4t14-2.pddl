(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	thermograph1 - mode
	infrared2 - mode
	infrared3 - mode
	Star0 - direction
	Star1 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star9 - direction
	Star10 - direction
	Star12 - direction
	Star13 - direction
	GroundStation11 - direction
	Star4 - direction
	Star6 - direction
	Star2 - direction
	Phenomenon14 - direction
	Planet15 - direction
	Star16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation11)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star16)
)
(:goal (and
	(have_image Phenomenon14 spectrograph0)
	(have_image Planet15 infrared3)
	(have_image Star16 infrared2)
	(have_image Planet17 infrared3)
))

)
