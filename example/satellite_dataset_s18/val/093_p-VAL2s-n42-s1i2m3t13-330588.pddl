(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	spectrograph0 - mode
	thermograph1 - mode
	thermograph2 - mode
	Star0 - direction
	Star2 - direction
	GroundStation4 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	Star9 - direction
	Star10 - direction
	Star11 - direction
	Star12 - direction
	GroundStation1 - direction
	Star5 - direction
	GroundStation3 - direction
	Planet13 - direction
	Star14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Phenomenon17 - direction
	Star18 - direction
	Phenomenon19 - direction
	Star20 - direction
	Phenomenon21 - direction
	Star22 - direction
	Planet23 - direction
	Planet24 - direction
	Planet25 - direction
	Planet26 - direction
	Star27 - direction
	Planet28 - direction
	Phenomenon29 - direction
	Phenomenon30 - direction
	Phenomenon31 - direction
	Star32 - direction
	Phenomenon33 - direction
	Phenomenon34 - direction
	Planet35 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 thermograph1)
	(supports instrument1 thermograph2)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation3)
	(calibration_target instrument1 Star5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star22)
)
(:goal (and
	(have_image Planet13 thermograph1)
	(have_image Star14 thermograph2)
	(have_image Phenomenon15 spectrograph0)
	(have_image Star16 spectrograph0)
	(have_image Phenomenon17 thermograph1)
	(have_image Star18 thermograph1)
	(have_image Phenomenon19 thermograph2)
	(have_image Star20 thermograph1)
	(have_image Phenomenon21 spectrograph0)
	(have_image Star22 thermograph2)
	(have_image Planet23 thermograph1)
	(have_image Planet24 thermograph2)
	(have_image Planet25 spectrograph0)
	(have_image Planet26 thermograph2)
	(have_image Star27 spectrograph0)
	(have_image Planet28 thermograph1)
	(have_image Phenomenon29 spectrograph0)
	(have_image Phenomenon30 thermograph1)
	(have_image Phenomenon31 spectrograph0)
	(have_image Star32 thermograph2)
	(have_image Phenomenon33 thermograph2)
	(have_image Phenomenon34 spectrograph0)
	(have_image Planet35 thermograph2)
))

)
