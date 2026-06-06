(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	infrared2 - mode
	thermograph1 - mode
	spectrograph0 - mode
	GroundStation3 - direction
	Star4 - direction
	GroundStation7 - direction
	GroundStation9 - direction
	GroundStation14 - direction
	Star0 - direction
	GroundStation10 - direction
	GroundStation12 - direction
	Star2 - direction
	GroundStation13 - direction
	GroundStation1 - direction
	GroundStation8 - direction
	GroundStation11 - direction
	Star5 - direction
	GroundStation6 - direction
	Planet15 - direction
	Star16 - direction
	Star17 - direction
	Planet18 - direction
	Star19 - direction
	Planet20 - direction
	Planet21 - direction
	Phenomenon22 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet20)
	(supports instrument1 thermograph1)
	(supports instrument1 infrared2)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 Star2)
	(supports instrument2 thermograph1)
	(supports instrument2 infrared2)
	(calibration_target instrument2 GroundStation11)
	(calibration_target instrument2 GroundStation8)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 GroundStation13)
	(supports instrument3 spectrograph0)
	(supports instrument3 infrared2)
	(calibration_target instrument3 GroundStation6)
	(calibration_target instrument3 Star5)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet21)
)
(:goal (and
	(have_image Planet15 thermograph1)
	(have_image Star16 spectrograph0)
	(have_image Star17 infrared2)
	(have_image Planet18 spectrograph0)
	(have_image Star19 thermograph1)
	(have_image Planet20 thermograph1)
	(have_image Planet21 thermograph1)
	(have_image Phenomenon22 infrared2)
))

)
