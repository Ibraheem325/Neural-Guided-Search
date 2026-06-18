(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	infrared3 - mode
	infrared4 - mode
	thermograph1 - mode
	image0 - mode
	spectrograph2 - mode
	spectrograph5 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	Star11 - direction
	Star12 - direction
	Star9 - direction
	GroundStation13 - direction
	Star4 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph5)
	(supports instrument0 spectrograph2)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation13)
	(supports instrument1 infrared4)
	(supports instrument1 image0)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 GroundStation13)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation5)
)
(:goal (and
	(have_image Phenomenon14 image0)
	(have_image Phenomenon14 thermograph1)
	(have_image Phenomenon15 infrared3)
	(have_image Phenomenon15 spectrograph2)
	(have_image Star16 spectrograph5)
	(have_image Planet17 infrared3)
))

)
