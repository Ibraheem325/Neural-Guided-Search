(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	satellite2 - satellite
	instrument5 - instrument
	image4 - mode
	spectrograph0 - mode
	infrared2 - mode
	infrared3 - mode
	thermograph1 - mode
	Star0 - direction
	Star2 - direction
	GroundStation8 - direction
	GroundStation6 - direction
	Star4 - direction
	Star7 - direction
	GroundStation10 - direction
	GroundStation3 - direction
	Star5 - direction
	Star9 - direction
	GroundStation1 - direction
	Star11 - direction
	Star12 - direction
	Star13 - direction
	Planet14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation6)
	(supports instrument1 infrared2)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 Star7)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation3)
	(supports instrument2 spectrograph0)
	(supports instrument2 infrared2)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 Star7)
	(supports instrument3 thermograph1)
	(calibration_target instrument3 GroundStation1)
	(calibration_target instrument3 Star5)
	(calibration_target instrument3 GroundStation3)
	(supports instrument4 spectrograph0)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 Star11)
	(calibration_target instrument4 Star9)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star11)
	(supports instrument5 infrared2)
	(supports instrument5 spectrograph0)
	(supports instrument5 infrared3)
	(supports instrument5 image4)
	(calibration_target instrument5 Star11)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet15)
)
(:goal (and
	(pointing satellite0 GroundStation10)
	(pointing satellite1 Planet15)
	(have_image Star12 image4)
	(have_image Star13 infrared3)
	(have_image Planet14 spectrograph0)
	(have_image Planet15 thermograph1)
))

)
