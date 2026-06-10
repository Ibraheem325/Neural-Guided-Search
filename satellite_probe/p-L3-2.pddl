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
	thermograph1 - mode
	infrared2 - mode
	infrared3 - mode
	spectrograph0 - mode
	Star3 - direction
	GroundStation7 - direction
	Star18 - direction
	Star19 - direction
	GroundStation15 - direction
	Star12 - direction
	GroundStation8 - direction
	Star13 - direction
	Star4 - direction
	Star6 - direction
	GroundStation16 - direction
	GroundStation11 - direction
	Star2 - direction
	GroundStation14 - direction
	Star9 - direction
	Star10 - direction
	Star0 - direction
	Star1 - direction
	GroundStation5 - direction
	GroundStation17 - direction
	Star20 - direction
	Star21 - direction
	Star22 - direction
	Phenomenon23 - direction
	Star24 - direction
	Phenomenon25 - direction
	Phenomenon26 - direction
	Star27 - direction
	Phenomenon28 - direction
	Star29 - direction
	Planet30 - direction
	Planet31 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation15)
	(supports instrument1 infrared3)
	(supports instrument1 infrared2)
	(calibration_target instrument1 Star12)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 GroundStation17)
	(supports instrument2 infrared2)
	(supports instrument2 infrared3)
	(calibration_target instrument2 Star1)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 Star4)
	(calibration_target instrument2 Star13)
	(calibration_target instrument2 GroundStation8)
	(calibration_target instrument2 GroundStation17)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star21)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 GroundStation14)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 GroundStation11)
	(calibration_target instrument3 GroundStation16)
	(supports instrument4 spectrograph0)
	(supports instrument4 infrared3)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 Star1)
	(calibration_target instrument4 Star0)
	(calibration_target instrument4 Star10)
	(calibration_target instrument4 Star9)
	(supports instrument5 infrared3)
	(supports instrument5 infrared2)
	(calibration_target instrument5 GroundStation17)
	(calibration_target instrument5 GroundStation5)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star20)
)
(:goal (and
	(have_image Star20 infrared2)
	(have_image Star21 thermograph1)
	(have_image Star22 infrared2)
	(have_image Phenomenon23 infrared2)
	(have_image Star24 thermograph1)
	(have_image Phenomenon25 infrared3)
	(have_image Phenomenon26 thermograph1)
	(have_image Star27 thermograph1)
	(have_image Phenomenon28 infrared3)
	(have_image Star29 infrared2)
	(have_image Planet30 spectrograph0)
	(have_image Planet31 infrared2)
))

)
