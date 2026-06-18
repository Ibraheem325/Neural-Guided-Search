(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	image0 - mode
	thermograph1 - mode
	spectrograph2 - mode
	infrared3 - mode
	spectrograph5 - mode
	infrared4 - mode
	GroundStation5 - direction
	GroundStation7 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	GroundStation6 - direction
	Star9 - direction
	Star3 - direction
	GroundStation8 - direction
	Star4 - direction
	Star12 - direction
	Star13 - direction
	Planet14 - direction
	Star15 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 infrared4)
	(supports instrument1 spectrograph5)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 GroundStation2)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 GroundStation6)
	(supports instrument2 spectrograph5)
	(supports instrument2 infrared3)
	(calibration_target instrument2 GroundStation8)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation8)
	(supports instrument3 thermograph1)
	(supports instrument3 infrared3)
	(supports instrument3 spectrograph2)
	(calibration_target instrument3 Star9)
	(calibration_target instrument3 GroundStation6)
	(calibration_target instrument3 GroundStation8)
	(supports instrument4 infrared4)
	(supports instrument4 infrared3)
	(supports instrument4 spectrograph5)
	(calibration_target instrument4 Star4)
	(calibration_target instrument4 GroundStation8)
	(calibration_target instrument4 Star3)
	(supports instrument5 spectrograph2)
	(supports instrument5 infrared4)
	(supports instrument5 thermograph1)
	(calibration_target instrument5 Star4)
	(calibration_target instrument5 GroundStation8)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet14)
)
(:goal (and
	(pointing satellite0 Star3)
	(have_image Star12 image0)
	(have_image Star12 infrared4)
	(have_image Star13 spectrograph5)
	(have_image Planet14 thermograph1)
	(have_image Star15 image0)
))

)
