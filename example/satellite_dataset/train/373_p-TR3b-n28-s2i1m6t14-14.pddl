(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	thermograph0 - mode
	image3 - mode
	infrared4 - mode
	infrared2 - mode
	image1 - mode
	spectrograph5 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation5 - direction
	GroundStation8 - direction
	Star9 - direction
	Star10 - direction
	Star11 - direction
	Star12 - direction
	Star6 - direction
	Star13 - direction
	GroundStation4 - direction
	GroundStation7 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph5)
	(supports instrument0 infrared4)
	(supports instrument0 image1)
	(calibration_target instrument0 Star6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet14)
	(supports instrument1 infrared2)
	(supports instrument1 infrared4)
	(supports instrument1 thermograph0)
	(supports instrument1 image3)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 Star13)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation3)
)
(:goal (and
	(pointing satellite0 GroundStation1)
	(have_image Planet14 infrared4)
	(have_image Planet14 thermograph0)
	(have_image Phenomenon15 spectrograph5)
	(have_image Phenomenon15 image1)
	(have_image Star16 image3)
	(have_image Star17 infrared2)
))

)
